Now that Catalog and Inventory services are up and running, start the API Gateway 
service in the first terminal window:

```
mvn vertx:run
```{{execute T1}}

You will see the following exception in the logs: 
`java.io.FileNotFoundException: .../kubernetes.io/serviceaccount/token` which is 
expected. It is the result of Vert.x trying to import services form OpenShift. Since you are 
running the API Gateway on your local machine, the lookup fails and falls back to the local 
service lookup.

Note that while the application is running using `mvn vertx:run`, you can make changes in the code
and they would immediately be compiled and updated in the running application to provide fast
feedback to the developer.

Now you can test the API Gateway by hitting the `/api/products` endpoint using `curl` in 
a new terminal window:

```
curl http://localhost:8080/api/products
```{{execute T4}}

You should see a JSON response like:
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

Note that the JSON response aggregates responses from Catalog and Inventory services and 
the inventory info for each product is available within the same JSON object.

Stop all services by pressing **CTRL-C** in all terminal windows.