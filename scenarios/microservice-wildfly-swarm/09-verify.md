You can see the expose DNS url for the Inventory service in the OpenShift Web Console or using 
OpenShift CLI:

```oc get routes```{{execute}}

Copy the route url for the Inventory service and verify the API Gateway service 
works using `curl`, replace `INVENTORY-ROUTE-HOST` with your route url:

```curl http://INVENTORY-ROUTE-HOST/api/inventory/329299```

You should see a JSON response like:

```
{"itemId":"329299","quantity":35}
```

You can also click on **Dashboard** at the top of the terminal window to 
open OpenShift Web Console and log in using your username and password to 
see the Inventory service in the web console.

Well done!