Since the API Gateway requires the Catalog and Inventory services to be running, let's run all three 
services simultaneously and verify that the API Gateway works as expected. 

Start the Catalog service in a new terminal:

```
mvn spring-boot:run -f catalog-spring-boot
```{{execute T2}}

Start the Inventory service as well in another new terminal:

```
mvn wildfly-swarm:run -f inventory-wildfly-swarm
```{{execute T3}}