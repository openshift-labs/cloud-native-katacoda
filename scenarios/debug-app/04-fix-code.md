Edit **com/redhat/cloudnative/inventory/InventoryResource.java** add replace the code with 
the following in order to return a zero inventory for products that don't exist in the inventory 
database.

<pre class="file" data-filename="./inventory-wildfly-swarm/src/main/java/com/redhat/cloudnative/inventory/InventoryResource.java" data-target="replace">
package com.redhat.cloudnative.inventory;

import javax.enterprise.context.ApplicationScoped;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import org.wildfly.swarm.health.Health;
import org.wildfly.swarm.health.HealthStatus;
import java.util.Date;

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

        if (inventory == null) {
            inventory = new Inventory();
            inventory.setItemId(itemId);
            inventory.setQuantity(0);
        }

        return inventory;
    }
}
</pre>

Commit the changes to the Git repository.

`git add src/main/java/com/redhat/cloudnative/inventory/InventoryResource.java`{{execute}}
`git commit -m "inventory returns zero for non-existing product id`{{execute}}
`git push origin master`{{execute}}
~~~

As soon as you commit the changes to the Git repository, the **inventory-pipeline** gets 
triggered to build and deploy a new Inventory container with the fix. Go to the 
OpenShift Web Console and inside the **coolstore** project. On the sidebar 
menu, Click on **Builds >> Pipelines** to see its progress.

When the pipeline completes successfully, point your browser at the Web route and verify 
that the inventory status is visible for all products. The suspect product should show 
the inventory status as _Not in Stock_.

![Inventory Status Bug Fixed](https://raw.githubusercontent.com/openshift-roadshow/cloud-native-katacoda/master/assets/debug-coolstore-bug-fixed.png)

Well done and congratulations for completing all the labs.