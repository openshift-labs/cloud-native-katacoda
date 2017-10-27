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

You can review the above resources in the OpenShift Web Console or using `oc describe` command:

> **bc** is the short-form of **buildconfig** and can be interchangeably used 
> instead of it with the OpenShift CLI. The same goes for **is** instead 
> of **imagestream**, **dc** instead of **deploymentconfig** and **svc** instead of **service**.


`oc describe bc inventory-s2i`{{execute}}

`oc describe is inventory`{{execute}}

`oc describe dc inventory`{{execute}}

`oc describe svc inventory`{{execute}}

`oc describe route inventory`{{execute}}
