In order to pause code execution at the breakpoint, you have to invoke the Inventory 
REST API once more.

Go back to the first terminal window and use `curl` to invoke the Inventory 
REST API.

You can find out the Inventory route url using `oc get routes`. Replace 
`INVENTORY-ROUTE-HOST` with the Inventory route url from your project.

```curl -v http://INVENTORY-ROUTE-HOST/api/inventory/444436```
