In order to pause code execution at the breakpoint, you have to invoke the Inventory 
REST API once more.

Click on the plus sign on top of the terminal window and then 
**Open New Terminal**. Use `curl` to invoke the Inventory API with 
the suspect product id in this terminal in order to pause the code execution at the defined breakpoint.

You can find out the Inventory route url using `oc get routes` Replace 
`INVENTORY-ROUTE-HOST` with the Inventory route url from your project.

```curl -v http://INVENTORY-ROUTE-HOST/api/inventory/444436```
