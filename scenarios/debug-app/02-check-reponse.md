Invoke the Inventory API using `curl` for the suspect product id to see what actually 
happens when API Gateway makes this call:

You can find out the Inventory route url using `oc get route inventory` Replace 
`INVENTORY-ROUTE-HOST` with the Inventory route url from your project.

```
curl -v http://INVENTORY-ROUTE-HOST/api/inventory/444436
```

The response `204 No Content` means no response has come back and that seems to be the 
reason the inventory status is not displayed 
on the web interface.

Let's debug the Inventory service to get to the bottom of this!