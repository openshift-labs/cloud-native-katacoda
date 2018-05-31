Since the API Gateway requires the Catalog and Inventory services to be running, let's run all three 
services simultaneously and verify that the API Gateway works as expected. 

Start the Catalog service in a new terminal:

```
cd catalog-spring-boot
mvn spring-boot:run
```{{execute T2}}

Start the Inventory service as well in another new terminal:

```
cd inventory-wildfly-swarm
mvn wildfly-swarm:run
```{{execute T3}}