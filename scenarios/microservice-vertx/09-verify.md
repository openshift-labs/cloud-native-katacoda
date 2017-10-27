You can see the expose DNS url for the Catalog service in the OpenShift Web Console or using 
OpenShift CLI.

`oc get routes`{{execute}}

Copy the route url for API Gateway and verify the API Gateway service works using `curl`

> Replace **API-GATEWAY-ROUTE-HOST** with your API Gateway route url in the following command

`curl http://API-GATEWAY-ROUTE-HOST/api/products`

You would see a JSON response like:

```
[{
  "itemId" : "329299",
  "name" : "Red Fedora",
  "desc" : "Official Red Hat Fedora",
  "price" : 34.99,
  "availability" : {
    "quantity" : 35
  }
...
```

As mentioned earlier, Vert.x built-in service discovery is integrated with OpenShift service 
discovery to lookup the Catalog and Inventory APIs.

Well done! 