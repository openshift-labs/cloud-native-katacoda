Let's take a moment and review the OpenShift resources that are created for the Catalog REST API:

* Build Config: **catalog-s2i** build config is the configuration for building the Catalog 
container image from the catalog source code or JAR archive
* Image Stream: **catalog** image stream is the virtual view of all catalog container 
images built and pushed to the OpenShift integrated registry.
* Deployment Config: **catalog** deployment config deploys and redeploys the Catalog container 
image whenever a new Catalog container image becomes available
* Service: **catalog** service is an internal load balancer which identifies a set of 
pods (containers) in order to proxy the connections it receives to them. Backing pods can be 
added to or removed from a service arbitrarily while the service remains consistently available, 
enabling anything that depends on the service to refer to it at a consistent address (service name 
or IP).
* Route: **catalog** route registers the service on the built-in external load-balancer 
and assigns a public DNS name to it so that it can be reached from outside OpenShift cluster.

You can review the above resources in the OpenShift Web Console or using `oc describe` command:

> **bc** is the short-form of **buildconfig** and can be interchangeably used instead of it with the 
> OpenShift CLI. The same goes for **is** instead of **imagestream**, **dc** instead of **deploymentconfig**
> and **svc** instead of **service**

`oc describe bc catalog-s2i`{{execute}}

`oc describe is catalog`{{execute}}

`oc describe dc catalog`{{execute}}

`oc describe svc catalog`{{execute}}

`oc describe route catalog`{{execute}}
