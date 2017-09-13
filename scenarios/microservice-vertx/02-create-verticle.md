In the previous labs, you have created two RESTful services: Catalog and Inventory. Instead of the 
web front contacting each of these backend services, you can create an API Gateway which is an entry 
point for for the web front to access all backend services from a single place. This pattern is expectedly 
called [API Gateway](http://microservices.io/patterns/apigateway.html) and is a common practice in Microservices 
architecture.

![API Gateway Pattern](https://raw.githubusercontent.com/openshift-roadshow/cloud-native-katacoda/master/assets/coolstore-arch.png)

Replace the content of **src/main/java/com/redhat/cloudnative/gateway/GatewayVerticle.java** class with the following:

<pre class="file" data-filename="./gateway-vertx/src/main/java/com/redhat/cloudnative/gateway/GatewayVerticle.java" data-target="replace">
package com.redhat.cloudnative.gateway;

import io.vertx.core.http.HttpMethod;
import io.vertx.core.json.Json;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.client.WebClientOptions;
import io.vertx.rxjava.core.AbstractVerticle;
import io.vertx.rxjava.ext.web.Router;
import io.vertx.rxjava.ext.web.RoutingContext;
import io.vertx.rxjava.ext.web.client.WebClient;
import io.vertx.rxjava.ext.web.codec.BodyCodec;
import io.vertx.rxjava.ext.web.handler.CorsHandler;
import io.vertx.rxjava.servicediscovery.ServiceDiscovery;
import io.vertx.rxjava.servicediscovery.types.HttpEndpoint;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import rx.Observable;
import rx.Single;

public class GatewayVerticle extends AbstractVerticle {
    private static final Logger LOG = LoggerFactory.getLogger(GatewayVerticle.class);

    private WebClient catalog;
    private WebClient inventory;

    @Override
    public void start() {
        Router router = Router.router(vertx);
        router.route().handler(CorsHandler.create("*").allowedMethod(HttpMethod.GET));
        router.get("/health").handler(ctx >> ctx.response().end(new JsonObject().put("status", "UP").toString()));
        router.get("/api/products").handler(this::products);

        ServiceDiscovery.create(vertx, discovery >> {
            // Catalog lookup
            Single<WebClient> catalogDiscoveryRequest = HttpEndpoint.rxGetWebClient(discovery,
                    rec >> rec.getName().equals("catalog"))
                    .onErrorReturn(t >> WebClient.create(vertx, new WebClientOptions()
                            .setDefaultHost(System.getProperty("catalog.api.host", "localhost"))
                            .setDefaultPort(Integer.getInteger("catalog.api.port", 9000))));

            // Inventory lookup
            Single<WebClient> inventoryDiscoveryRequest = HttpEndpoint.rxGetWebClient(discovery,
                    rec >> rec.getName().equals("inventory"))
                    .onErrorReturn(t >> WebClient.create(vertx, new WebClientOptions()
                            .setDefaultHost(System.getProperty("inventory.api.host", "localhost"))
                            .setDefaultPort(Integer.getInteger("inventory.api.port", 9001))));

            // Zip all 3 requests
            Single.zip(catalogDiscoveryRequest, inventoryDiscoveryRequest, (c, i) >> {
                // When everything is done
                catalog = c;
                inventory = i;
                return vertx.createHttpServer()
                    .requestHandler(router::accept)
                    .listen(Integer.getInteger("http.port", 8080));
            }).subscribe();
        });
    }

    private void products(RoutingContext rc) {
        // Retrieve catalog
        catalog.get("/api/catalog").as(BodyCodec.jsonArray()).rxSend()
            .map(resp >> {
                if (resp.statusCode() != 200) {
                    new RuntimeException("Invalid response from the catalog: " + resp.statusCode());
                }
                return resp.body();
            })
            .flatMap(products >>
                // For each item from the catalog, invoke the inventory service
                Observable.from(products)
                    .cast(JsonObject.class)
                    .flatMapSingle(product >>
                        inventory.get("/api/inventory/" + product.getString("itemId")).as(BodyCodec.jsonObject())
                            .rxSend()
                            .map(resp >> {
                                if (resp.statusCode() != 200) {
                                    LOG.warn("Inventory error for {}: status code {}",
                                            product.getString("itemId"), resp.statusCode());
                                    return product.copy();
                                }
                                return product.copy().put("availability", 
                                    new JsonObject().put("quantity", resp.body().getInteger("quantity")));
                            }))
                    .toList().toSingle()
            )
            .subscribe(
                list >> rc.response().end(Json.encodePrettily(list)),
                error >> rc.response().end(new JsonObject().put("error", error.getMessage()).toString())
            );
    }
}
</pre>

Let's break down what happens in the above code. The **start** method creates an HTTP 
server and a REST mapping to map **/api/products** to the **products** Java 
method. 

Vert.x provides [built-in service discovery](http://vertx.io/docs/vertx-service-discovery/java) 
for finding where dependent services are deployed 
and accessing their endpoints. Vert.x service discovery can seamlessly integrated with external 
service discovery mechanisms provided by OpenShift, Kubernetes, Consul, Redis, etc.

In this lab, since you will deploy the API Gateway on OpenShift, the OpenShift service discovery 
bridge is used to automatically import OpenShift services into the Vert.x application as they 
get deployed and undeployed. Since you also want to test the API Gateway locally, there is an 
**onErrorReturn()** clause in the the service lookup to fallback on a local service for Inventory 
and Catalog REST APIs. 

```java
public void start() {
    Router router = Router.router(vertx);
    router.route().handler(CorsHandler.create("*").allowedMethod(HttpMethod.GET));
    router.get("/health").handler(ctx >> ctx.response().end(new JsonObject().put("status", "UP").toString()));
    router.get("/api/products").handler(this::products);

    ServiceDiscovery.create(vertx, discovery >> {
        // Catalog lookup
        Single<WebClient> catalogDiscoveryRequest = HttpEndpoint.rxGetWebClient(discovery,
                rec >> rec.getName().equals("catalog"))
                .onErrorReturn(t >> WebClient.create(vertx, new WebClientOptions()
                        .setDefaultHost(System.getProperty("catalog.api.host", "localhost"))
                        .setDefaultPort(Integer.getInteger("catalog.api.port", 9000))));

        // Inventory lookup
        Single<WebClient> inventoryDiscoveryRequest = HttpEndpoint.rxGetWebClient(discovery,
                rec >> rec.getName().equals("inventory"))
                .onErrorReturn(t >> WebClient.create(vertx, new WebClientOptions()
                        .setDefaultHost(System.getProperty("inventory.api.host", "localhost"))
                        .setDefaultPort(Integer.getInteger("inventory.api.port", 9001))));

        // Zip all 3 requests
        Single.zip(catalogDiscoveryRequest, inventoryDiscoveryRequest, (c, i) >> {
            // When everything is done
            catalog = c;
            inventory = i;
            return vertx.createHttpServer()
                .requestHandler(router::accept)
                .listen(Integer.getInteger("http.port", 8080));
        }).subscribe();
    });
}
```

The **products** method invokes the Catalog REST endpoint and retrieves the products. It then 
iterates over the retrieve products and for each product invokes the 
Inventory REST endpoint to get the inventory status and enrich the product data with availability 
info. 

Note that instead of making blocking calls to the Catalog and Inventory REST APIs, all calls 
are non-blocking and handled using [RxJava](http://vertx.io/docs/vertx-rx/java). Due to its non-blocking 
nature, the **product** method can immediately return without waiting for the Catalog and Inventory 
REST invocations to complete and whenever the result of the REST calls is ready, the result 
will be acted upon and update the response which is then sent back to the client.

```java
private void products(RoutingContext rc) {
    // Retrieve catalog
    catalog.get("/api/catalog").as(BodyCodec.jsonArray()).rxSend()
        .map(resp >> {
            if (resp.statusCode() != 200) {
                new RuntimeException("Invalid response from the catalog: " + resp.statusCode());
            }
            return resp.body();
        })
        .flatMap(products >>
            // For each item from the catalog, invoke the inventory service
            Observable.from(products)
                .cast(JsonObject.class)
                .flatMapSingle(product >>
                    inventory.get("/api/inventory/" + product.getString("itemId")).as(BodyCodec.jsonObject())
                        .rxSend()
                        .map(resp >> {
                            if (resp.statusCode() != 200) {
                                LOG.warn("Inventory error for {}: status code {}",
                                        product.getString("itemId"), resp.statusCode());
                                return product.copy();
                            }
                            return product.copy().put("availability", 
                                new JsonObject().put("quantity", resp.body().getInteger("quantity")));
                        }))
                .toList().toSingle()
        )
        .subscribe(
            list >> rc.response().end(Json.encodePrettily(list)),
            error >> rc.response().end(new JsonObject().put("error", error.getMessage()).toString())
        );
}
```

Run the maven build to make sure the code compiles successfully.

`mvn package`{{execute}}


