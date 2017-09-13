Spring Boot, WildFly Swarm and Vert.x all provide out-of-the-box support for creating RESTful endpoints that
provide details on the health of the application. These endpoints by default provide basic data about the 
service however they all provide a way to customize the health data and add more meaningful information (e.g. 
database connection health, backoffice system availability, etc).

[Spring Boot Actuator](http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#production-ready) is a 
sub-project of Spring Boot which adds health and management HTTP endpoints to the application. Enabling Spring Boot 
Actuator is done via adding **org.springframework.boot:spring-boot-starter-actuator** dependency to the Maven project 
dependencies which is already done for the Catalog services.

Verify that the health endpoint works for the Catalog service using **curl** replacing **CATALOG-ROUTE-HOST**
with the Catalog route url:

> Remember how to find out the route urls? Try **oc get route catalog**

`curl http://CATALOG-ROUTE-HOST/health`

You should see a response like:
```
{"status":"UP","diskSpace":{"status":"UP","total":3209691136,"free":2667175936,"threshold":10485760},"db":{"status":"UP","database":"H2","hello":1}}
```

[WildFly Swarm health endpoints](https://wildfly-swarm.gitbooks.io/wildfly-swarm-users-guide/content/advanced/monitoring.html) function in a similar fashion and are enabled by adding **org.wildfly.swarm:monitor**
to the Maven project dependencies. 
This is also already done for the Inventory service.

Verify that the health endpoint works for the Inventory service using **curl** replacing **INVENTORY-ROUTE-HOST**
with the Catalog route url:

> You know this by know! Use **oc get route inventory** to get the Inventory route url 

`curl http://INVENTORY-ROUTE-HOST/node`

```
{
    "name" : "localhost",
    "server-state" : "running",
    "suspend-state" : "RUNNING",
    "running-mode" : "NORMAL",
    "uuid" : "79b3ffc5-d98c-4b8e-ae5c-9756ed13944a",
    "swarm-version" : "2017.8.1"
}
```

Expectedly, Eclipse Vert.x also provides a [health check module](http://vertx.io/docs/vertx-health-check/java) 
which is enabled by adding **io.vertx:vertx-health-check** as a dependency to the Maven project. 

Verify that the health endpoint works for the Inventory service using **curl** replacing **API-GATEWAY-ROUTE-HOST**
with the API Gateway route url:

> Yup! You can use **oc get route gateway** to get the API Gateway route url 

`curl http://API-GATEWAY-ROUTE-HOST/health`

```
{"status":"UP"}
```

Last but not least, although you can build more sophisticated health endpoints for the Web UI as well, you 
can use the root context ("/") of the Web UI in this lab to verify it's up and running.
