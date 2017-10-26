Using WildFly Swarm maven plugin, you can conveniently run the application locally and test the endpoint.

`mvn wildfly-swarm:run`{{execute}}

Alternatively, you can run the application using the uber-jar produced 
during the Maven build: 

`java -jar target/inventory-1.0-SNAPSHOT-swarm.jar`

Once you see **WildFly Swarm is Ready** in the logs, the Inventory service is up and running and you can access the 
inventory REST API. Let’s test it out using **curl** in a new terminal window:

`curl http://localhost:9001/api/inventory/329299`{{execute T2}}

You would see a JSON response like this:
```
{"itemId":"329299","quantity":35}
```

The REST API returned a JSON object representing the inventory count for this product. Congratulations!

Stop the service by pressing **CTRL-C** in the terminal window.