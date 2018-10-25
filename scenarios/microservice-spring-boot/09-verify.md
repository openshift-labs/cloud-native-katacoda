You can see the exposed DNS url for the Catalog service in the OpenShift Web Console or using 
OpenShift CLI:

```
oc get routes
```{{execute T1}}

Copy the route url for the Catalog service and verify the Catalog service works using `curl`

> Replace `CATALOG-ROUTE-HOST` with the Catalog route host listed from your project.

```curl http://CATALOG-ROUTE-HOST/api/catalog```

You should see a JSON response like:
```
[{"itemId":"329299","name":"Red Fedora","desc":"Official Red Hat Fedora","price":34.99},...]
```

You can also click on **Dashboard** at the top of the terminal window to 
open OpenShift Web Console and log in using your username and password to 
see the Catalog service in the web console.

Well done!