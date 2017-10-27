The code execution pauses at the **getAvailability()** method. You can verify it 
using the **list** command to see the source code in the terminal window where 
you started JDB. The arrow shows which line is 
to execute next:

```
list
```{{execute T3}}

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

```
next
```{{execute T3}}

Use **locals** command to see the local variables and verify the retrieved inventory 
object from the database.

```
locals
```{{execute T3}}

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

```
quit
```{{execute T3}}

And then stop the fabric8 maven plugin port forwarding via pressing **CTRL+C** 
in the first terminal window.
