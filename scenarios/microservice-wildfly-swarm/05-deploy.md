It’s time to build and deploy our service on OpenShift. First, make sure you 
are **coolstore** project is the active project in OpenShift:

`oc project coolstore`{{execute}}

OpenShift [Source-to-Image (S2I)](https://docs.openshift.com/container-platform/3.6/architecture/core_concepts/builds_and_image_streams.html#source-build) 
feature can be used to build a container image from your project. OpenShift 
S2I uses the supported OpenJDK container image to build the final container image of the 
Inventory service by uploading the WildFly Swam uber-jar from the **target** folder to 
the OpenShift platform. 

Maven projects can use the [Fabric8 Maven Plugin](https://maven.fabric8.io) in order 
to use OpenShift S2I for building 
the container image of the application from within the project. This maven plugin is a Kubernetes/OpenShift client 
able to communicate with the OpenShift platform using the REST endpoints in order to issue the commands 
allowing to build a project, deploy it and finally launch a docker process as a pod.

To build and deploy the Inventory service on OpenShift using the **fabric8** maven plugin, run the following Maven command:

`mvn fabric8:deploy`{{execute}}

This will cause the following to happen:

* The Inventory uber-jar is built using WildFly Swarm
* A container image is built on OpenShift containing the Inventory uber-jar and JDK
* All necessary objects are created within the OpenShift project to deploy the Inventory service

Once this completes, your project should be up and running. OpenShift runs the different components of 
the project in one or more pods which are the unit of runtime deployment and consists of the running 
containers for the project. 

Let's take a moment and review the OpenShift resources that are created for the Inventory REST API:

* **Build Config**: **inventory-s2i** build config is the configuration for building the Inventory 
container image from the inventory source code or JAR archive
* **Image Stream**: **inventory** image stream is the virtual view of all inventory container 
images built and pushed to the OpenShift integrated registry.
* **Deployment Config**: **inventory** deployment config deploys and redeploys the Inventory container 
image whenever a new Inventory container image becomes available
* **Service**: **inventory** service is an internal load balancer which identifies a set of 
pods (containers) in order to proxy the connections it receives to them. Backing pods can be 
added to or removed from a service arbitrarily while the service remains consistently available, 
enabling anything that depends on the service to refer to it at a consistent address (service name 
or IP).
* **Route**: **inventory** route registers the service on the built-in external load-balancer 
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

Copy the route url for the Inventory service and verify the API Gateway service works using **curl**:

`curl http://INVENTORY-ROUTE-HOST/api/inventory/329299`

You should see a JSON response like:

```
{"itemId":"329299","quantity":35}
```

Well done! You are ready to move on to the next lab.