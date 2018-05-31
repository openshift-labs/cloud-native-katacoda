CoolStore application seem to have a bug that causes the inventory status for one of the 
products not be displayed in the web interface. 

![Inventory Status Bug](https://katacoda.com/openshift-roadshow/assets/debug-coolstore-bug.png)

This is not an expected behavior! In previous scenarios, you added a circuit breaker to 
protect the CoolStore application from failures and in case the Inventory API is not 
available, to skip it and show the products without the inventory status. However, right 
now the inventory status is available for all products but one which is not how we 
expect to see the products.

Since the product list is provides by the API Gateway, take a look into the API Gateway 
logs to see if there are any errors:

```
oc logs dc/gateway | grep -i error
```{{execute}}

Oh! Something seems to be wrong with the response the API Gateway has received from the 
Inventory API for the product id **444436** 

```
...
WARNING: Inventory error for 444436: status code 204
SEVERE: Inventory error for 444436: null
...
```

Look into the Inventory pod logs to investigate further and see if you can find more  
information about this bug:

```
oc logs dc/inventory | grep ERROR
```{{execute}}

There doesn't seem to be anything relevant to the **invalid response** error that the 
API Gateway received either! 