WildFly Swarm uses JAX-RS standard for building REST services. Create a new Java class named
`InventoryResource.java` in `com.redhat.cloudnative.inventory` package with the following
content by clicking on *Copy to Editor*:

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

The above REST services defines an endpoint that is accessible via **HTTP GET** at
for example **/api/inventory/329299** with
the last path param being the product id which we want to check its inventory status.

Build and package the Inventory service using Maven

```
mvn package
```{{execute}}

You should see a **BUILD SUCCESS** in the build logs.
