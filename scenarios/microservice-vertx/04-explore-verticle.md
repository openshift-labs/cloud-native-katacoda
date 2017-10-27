Let's break down what happens in the above code. The **start** method creates an HTTP
server and a REST mapping to map **/api/products** to the **products** Java
method.

Vert.x provides [built-in service discovery](http://vertx.io/docs/vertx-service-discovery/java)
for finding where dependent services are deployed
and accessing their endpoints. Vert.x service discovery can seamlessly integrated with external
service discovery mechanisms provided by OpenShift, Kubernetes, Consul, Redis, etc.

In this scenario, since you will deploy the API Gateway on OpenShift, the OpenShift service discovery
bridge is used to automatically import OpenShift services into the Vert.x application as they
get deployed and undeployed. Since you also want to test the API Gateway locally, there is an
**onErrorReturn()** clause in the the service lookup to fallback on a local service for Inventory
and Catalog REST APIs.

The **products** method invokes the Catalog REST endpoint and retrieves the products. It then
iterates over the retrieve products and for each product invokes the
Inventory REST endpoint to get the inventory status and enrich the product data with availability
info.

Note that instead of making blocking calls to the Catalog and Inventory REST APIs, all calls
are non-blocking and handled using [RxJava](http://vertx.io/docs/vertx-rx/java). Due to its non-blocking
nature, the **product()** method can immediately return without waiting for the Catalog and Inventory
REST invocations to complete and whenever the result of the REST calls is ready, the result
will be acted upon and update the response which is then sent back to the client.

Run the maven build to make sure the code compiles successfully.

```
mvn package
```{{execute}}
