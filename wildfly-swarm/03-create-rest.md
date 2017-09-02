WildFly Swarm uses JAX-RS standard for building REST services. Create a new Java class named 
`InventoryResource.java` in `com.redhat.cloudnative.inventory` package with the following content:

<pre class="file" data-filename="./src/main/java/com/redhat/cloudnative/inventory/InventoryResource.java" data-target="replace">
package com.redhat.cloudnative.inventory;

import javax.enterprise.context.ApplicationScoped;
import javax.persistence.*;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

@Path("/")
@ApplicationScoped
public class InventoryResource {
    @PersistenceContext(unitName = "InventoryPU")
    private EntityManager em;

    @GET
    @Path("/api/inventory/{itemId}")
    @Produces(MediaType.APPLICATION_JSON)
    public Inventory getAvailability(@PathParam("itemId") String itemId) {
        Inventory inventory = em.find(Inventory.class, itemId);
        return inventory;
    }
}
</pre>

The above REST services defines an endpoint that is accessible via `HTTP GET` at 
for example `/api/inventory/329299` with 
the last path param being the product id which we want to check its inventory status.

Build and package the Inventory service using Maven

`mvn package`{{execute}}

Using WildFly Swarm maven plugin, you can conveniently run the application locally and test the endpoint.

`mvn wildfly-swarm:run`{{execute}}

> Alternatively, you can run the application using the uber-jar produced during the Maven build: `java -jar target/inventory-1.0-SNAPSHOT-swarm.jar`

Once you see `WildFly Swarm is Ready` in the logs, the Inventory service is up and running and you can access the 
inventory REST API. Let’s test it out using `curl` in a new terminal window:

`curl http://localhost:9001/api/inventory/329299`{{execute}}

You would see a JSON response like this:
```
{"itemId":"329299","quantity":35}
```

The REST API returned a JSON object representing the inventory count for this product. Congratulations!

Stop the service by pressing `CTRL-C` in the terminal window.
