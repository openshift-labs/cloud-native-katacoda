The [Java Debugger (JDB)](http://docs.oracle.com/javase/8/docs/technotes/tools/windows/jdb.html) 
is a simple command-line debugger for Java. The **jdb** command is included by default in 
Java SE and provides inspection and debugging of a local or remote JVM. Although **jdb** is not 
the most convenient way to debug Java code, it's a handy tool since it can be run on any environment 
that Java SE is available. 

The instructions in this section focus on using **jdb** however if you are familiar with JBoss Developer 
Studio, Eclipse or IntelliJ you can use them for remote debugging.

Go to the **inventory-wildfly-swarm** project folder in a new terminal window
and start JDB by pointing at the folder containing the Java source code for the application under debug:

`cd inventory-wildfly-swarm`{{execute T2}}

`jdb -attach localhost:5005 -sourcepath :src/main/java/`{{execute T2}}

Now that you are connected to the JVM running inside the Inventory pod on OpenShift, add 
a breakpoint to pause the code execution when it reaches the Java method handling the 
REST API **/api/inventory** Review the **InventoryResource.java** class and note that the 
**getAvailability()** is the method where you should add the breakpoint.

Add the breakpoint.

`stop in com.redhat.cloudnative.inventory.InventoryResource.getAvailability`{{execute T2}}

Click on the plus sign on top of the terminal window and then 
**Open New Terminal**. Use **curl** to invoke the Inventory API with 
the suspect product id in this terminal in order to pause the code execution at the defined breakpoint.

> You can find out the Inventory route url using `oc get routes` Replace 
> `INVENTORY-ROUTE-HOST` with the Inventory route url from your project.

`curl -v http://INVENTORY-ROUTE-HOST/api/inventory/444436`

The code execution pauses at the **getAvailability()** method. You can verify it 
using the **list** command to see the source code in the terminal window where 
you started JDB. The arrow shows which line is 
to execute next:

`list`{{execute T2}}

You'll see an output similar to this.

```
default task-3[1] list
21        @GET
22        @Path("/api/inventory/{itemId}")
23        @Produces(MediaType.APPLICATION_JSON)
24        public Inventory getAvailability(@PathParam("itemId") String itemId) {
25 =>         Inventory inventory = em.find(Inventory.class, itemId);
26            return inventory;
27        }
28    }
```

Execute one line of code using **next** command so the the inventory object is 
retrieved from the database.

`next`{{execute T2}}

Use **locals** command to see the local variables and verify the retrieved inventory 
object from the database.

`locals`{{execute T2}}

You'll see an output similar to this.

```
default task-2[1] locals
Method arguments:
itemId = "444436"
Local variables:
inventory = null
```

Oh! Did you notice the problem? 

The **inventory** object which is the object retrieved from the database 
for the provided product id is **null** and is returned as the REST response! The non-existing 
product id is not a problem on its own because it simply could mean this product is discontinued 
and removed from the Inventory database but it's not removed from the product catalog database 
yet. The bug is however caused because the code returns this **null** value instead of a sensible 
REST response. If the product id does not exist, a proper JSON response stating a zero inventory 
should be returned instead of **null**

Exit the debugger.

`quit`{{execute T2}}

And then stop the fabric8 maven plugin port forwarding via pressing **CTRL+C** 
in the first terminal window.
