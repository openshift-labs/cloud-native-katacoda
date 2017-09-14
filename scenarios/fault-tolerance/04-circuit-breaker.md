In this scenario so far you have been looking how to make sure the application pod is running, can scale to accommodate 
user load and recovers from failures. However failures also happen in the downstream services that an application 
is dependent on. It's not uncommon that the whole application fails or slows down because one of the downstream 
services consumed by the application is not responsive or responds slowly.

[Circuit Breaker](https://martinfowler.com/bliki/CircuitBreaker.html) is a pattern to address this issue and while 
became popular with microservice architecture, it's a useful pattern for all applications that depend on other 
services.

The idea behind the circuit breaker is that you wrap the API calls to downstream services in a circuit breaker 
object, which monitors for failures. Once the service invocation fails certain number of times, the circuit 
breaker flips open, and all further calls to the circuit breaker return with an error or a fallback logic 
without making the call to the unresponsive API. After a certain period, the circuit breaker for allow a call 
to the downstream service to test the waters. If the call success, the circuit breaker closes and would call 
the downstream service on consequent calls.

![Circuit Breaker](/api/workshops/roadshow/content/assets/images/fault-circuit-breaker.png){:width="300px"}

Spring Boot and WildFly Swarm provide convenient integration with [Hystrix](https://github.com/Netflix/Hystrix) 
which is a framework that provides circuit breaker functionality. Eclipse Vert.x, in addition to integration 
with Hystrix, provides built-in support for circuit breakers.

Let's take the Inventory service down and see what happens to the CoolStore online shop.

`oc scale dc/inventory --replicas=0`{{execute}}

Now point your browser at the Web UI route url.

> You can find the Web UI route url in the OpenShift Web Console above the **web** pod or 
> using the **oc get routes** command.

![CoolStore Without Circuit Breaker](https://raw.githubusercontent.com/openshift-roadshow/cloud-native-katacoda/master/assets/fault-coolstore-no-cb.png)

Although only the Inventory service is down, there are no products displayed in the online store because 
the Inventory service call failure propagates and causes the entire API Gateway to blow up! 

The CoolStore online shop cannot function without the products list, however the inventory status is not a 
crucial bit in the shopping experience. Let's add a circuit breaker for calls to the Inventory service and 
provide a default inventory status when the Inventory service is not responsive.

In the **gateway-vertx** project, replace the **GatewayVerticle.java** code with the following:

<pre class="file" data-filename="./src/main/java/com/redhat/cloudnative/gateway/GatewayVerticle.java" data-target="replace">
package com.redhat.cloudnative.gateway;

import io.vertx.circuitbreaker.CircuitBreakerOptions;
import io.vertx.core.http.HttpMethod;
import io.vertx.core.json.Json;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.client.WebClientOptions;
import io.vertx.rxjava.circuitbreaker.CircuitBreaker;
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
    private CircuitBreaker circuit;

    @Override
    public void start() {

        circuit = CircuitBreaker.create("inventory-circuit-breaker", vertx,
            new CircuitBreakerOptions()
                .setFallbackOnFailure(true)
                .setMaxFailures(3)
                .setResetTimeout(5000)
                .setTimeout(1000)
        );

        Router router = Router.router(vertx);
        router.route().handler(CorsHandler.create("*").allowedMethod(HttpMethod.GET));
        router.get("/health").handler(ctx -> ctx.response().end(new JsonObject().put("status", "UP").toString()));
        router.get("/api/products").handler(this::products);

        ServiceDiscovery.create(vertx, discovery -> {
            // Catalog lookup
            Single<WebClient> catalogDiscoveryRequest = HttpEndpoint.rxGetWebClient(discovery,
                    rec -> rec.getName().equals("catalog"))
                    .onErrorReturn(t -> WebClient.create(vertx, new WebClientOptions()
                            .setDefaultHost(System.getProperty("catalog.api.host", "localhost"))
                            .setDefaultPort(Integer.getInteger("catalog.api.port", 9000))));

            // Inventory lookup
            Single<WebClient> inventoryDiscoveryRequest = HttpEndpoint.rxGetWebClient(discovery,
                    rec -> rec.getName().equals("inventory"))
                    .onErrorReturn(t -> WebClient.create(vertx, new WebClientOptions()
                            .setDefaultHost(System.getProperty("inventory.api.host", "localhost"))
                            .setDefaultPort(Integer.getInteger("inventory.api.port", 9001))));

            // Zip all 3 requests
            Single.zip(catalogDiscoveryRequest, inventoryDiscoveryRequest, (c, i) -> {
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
            .map(resp -> {
                if (resp.statusCode() != 200) {
                    new RuntimeException("Invalid response from the catalog: " + resp.statusCode());
                }
                return resp.body();
            })
            .flatMap(products ->
                // For each item from the catalog, invoke the inventory service
                Observable.from(products)
                    .cast(JsonObject.class)
                    .flatMapSingle(product ->
                        circuit.rxExecuteCommandWithFallback(
                            future ->
                                inventory.get("/api/inventory/" + product.getString("itemId")).as(BodyCodec.jsonObject())
                                    .rxSend()
                                    .map(resp -> {
                                        if (resp.statusCode() != 200) {
                                            LOG.warn("Inventory error for {}: status code {}",
                                                    product.getString("itemId"), resp.statusCode());
                                        }
                                        return product.copy().put("availability", 
                                            new JsonObject().put("quantity", resp.body().getInteger("quantity")));
                                    })
                                    .subscribe(
                                        future::complete,
                                        future::fail),
                            error -> {
                                LOG.error("Inventory error for {}: {}", product.getString("itemId"), error.getMessage());
                                return product;
                            }
                        ))
                    .toList().toSingle()
            )
            .subscribe(
                list -> rc.response().end(Json.encodePrettily(list)),
                error -> rc.response().end(new JsonObject().put("error", error.getMessage()).toString())
            );
    }
}
</pre>

The above code is quite similar to the previous code however it wraps the calls to the Inventory 
service in a **CircuitBreaker** using the built-in circuit breaker in Vert.x. The circuit breaker 
is configured (using **CircuitBreakerOptions** to flip open after 3 failures and time out on the 
calls after 1 second. 

```
circuit = CircuitBreaker.create("inventory-circuit-breaker", vertx,
    new CircuitBreakerOptions()
        .setFallbackOnFailure(true)
        .setMaxFailures(3)
        .setResetTimeout(10000)
        .setTimeout(1000)
);
```

The **circuit.rxExecuteCommandWithFallback(...)** method, defines the fallback logic for 
when the circuit is open and logs an error without calling the Inventory service in those 
scenarios.

```
circuit.rxExecuteCommandWithFallback(
    future ->
        // call inventory service 
        ...
    error -> {
        // log and error
        ...
    }
)
```

Build the API Gateway using Maven.

`mvn package`{{execute}}