To build and deploy the Inventory service on OpenShift using the **fabric8** maven plugin, run the following Maven command:

`mvn fabric8:deploy`{{execute}}

This will cause the following to happen:

* The Inventory uber-jar is built using WildFly Swarm
* A container image is built on OpenShift containing the Inventory uber-jar and JDK
* All necessary objects are created within the OpenShift project to deploy the Inventory service

This might take little while depending on the network bandwidth but once this completes, your 
project should be up and running. OpenShift runs the different components of 
the project in one or more pods which are the unit of runtime deployment and consists of the running 
containers for the project. 

Let's take a moment and review the OpenShift resources that are created for the Inventory REST API:

* Build Config: **inventory-s2i** build config is the configuration for building the Inventory 
container image from the inventory source code or JAR archive
* Image Stream: **inventory** image stream is the virtual view of all inventory container 
images built and pushed to the OpenShift integrated registry.
* Deployment Config: **inventory** deployment config deploys and redeploys the Inventory container 
image whenever a new Inventory container image becomes available
* Service: **inventory** service is an internal load balancer which identifies a set of 
pods (containers) in order to proxy the connections it receives to them. Backing pods can be 
added to or removed from a service arbitrarily while the service remains consistently available, 
enabling anything that depends on the service to refer to it at a consistent address (service name 
or IP).
* Route: **inventory** route registers the service on the built-in external load-balancer 
and assigns a public DNS name to it so that it can be reached from outside OpenShift cluster.

You can review the above resources in the OpenShift Web Console or using **oc describe** command:

> **bc** is the short-form of **buildconfig** and can be interchangeably used 
> instead of it with the OpenShift CLI. The same goes for **is** instead 
> of **imagestream**, **dc** instead of **deploymentconfig** and **svc** instead of **service**.


`oc describe bc inventory-s2i`{{execute}}

`oc describe is inventory`{{execute}}

`oc describe dc inventory`{{execute}}

`oc describe svc inventory`{{execute}}

`oc describe route inventory`{{execute}}

You can see the expose DNS url for the Inventory service in the OpenShift Web Console or using 
OpenShift CLI:

`oc get routes`{{execute}}

Copy the route url for the Inventory service and verify the API Gateway service 
works using **curl**, replace **INVENTORY-ROUTE-HOST** with your route url:

`curl http://INVENTORY-ROUTE-HOST/api/inventory/329299`

You should see a JSON response like:

```
{"itemId":"329299","quantity":35}
```

You can also click on *Dashboard* at the top of the terminal window to 
open OpenShift Web Console and log in using your username and password to 
see the Inventory service in the web console.

Well done! You are ready to move on to the next scenario.