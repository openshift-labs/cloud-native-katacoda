It’s time to build and deploy our service on OpenShift. First, make sure you are on the **coolstore**project:

`oc project coolstore`{{execute}}

OpenShift [Source-to-Image (S2I)](https://docs.openshift.com/container-platform/3.6/architecture/core_concepts/builds_and_image_streams.html#source-build) 
feature can be used to build a container image from your project. OpenShift 
S2I uses the supported OpenJDK container image to build the final container image 
of the Catalog service by uploading the Spring Boot uber-jar from the **target**
folder to the OpenShift platform. 

Maven projects can use the [Fabric8 Maven Plugin](https://maven.fabric8.io) in 
order to use OpenShift S2I for building the container image of the application 
from within the project. This maven plugin is a Kubernetes/OpenShift client 
able to communicate with the OpenShift platform using the REST endpoints in 
order to issue the commands allowing to build a project, deploy it and finally 
launch a docker process as a pod.

To build and deploy the Catalog service on OpenShift using the **fabric8**maven plugin, run the following maven command:

`mvn fabric8:deploy`{{execute}}

This will cause the following to happen:

* The Catalog uber-jar is built using Spring Boot
* A container image is built on OpenShift containing the Catalog uber-jar and JDK
* All necessary objects are created within the OpenShift project to deploy the Catalog service

Once this completes, your project should be up and running. OpenShift runs the different components of 
the project in one or more pods which are the unit of runtime deployment and consists of the running 
containers for the project. 

Let's take a moment and review the OpenShift resources that are created for the Catalog REST API:

* **Build Config**: **catalog-s2i**build config is the configuration for building the Catalog 
container image from the catalog source code or JAR archive
* **Image Stream**: **catalog**image stream is the virtual view of all catalog container 
images built and pushed to the OpenShift integrated registry.
* **Deployment Config**: **catalog**deployment config deploys and redeploys the Catalog container 
image whenever a new Catalog container image becomes available
* **Service**: **catalog**service is an internal load balancer which identifies a set of 
pods (containers) in order to proxy the connections it receives to them. Backing pods can be 
added to or removed from a service arbitrarily while the service remains consistently available, 
enabling anything that depends on the service to refer to it at a consistent address (service name 
or IP).
* **Route**: **catalog**route registers the service on the built-in external load-balancer 
and assigns a public DNS name to it so that it can be reached from outside OpenShift cluster.

You can review the above resources in the OpenShift Web Console or using **oc describe**command:

> **bc**is the short-form of **buildconfig**and can be interchangeably used instead of it with the 
> OpenShift CLI. The same goes for **is**instead of **imagestream** **dc**instead of**deploymentconfig**
> and **svc**instead of **service**

`oc describe bc catalog-s2i`{{execute}}
`oc describe is catalog`{{execute}}
`oc describe dc catalog`{{execute}}
`oc describe svc catalog`{{execute}}
`oc describe route catalog`{{execute}}

You can see the expose DNS url for the Catalog service in the OpenShift Web Console or using 
OpenShift CLI:

`oc get routes`{{execute}}

Copy the route url for the Catalog service and verify the Catalog service works using **curl**

> Replace **CATALOG-ROUTE-HOST**with the Catalog route host listed from your project.

`curl http://CATALOG-ROUTE-HOST/api/catalog`

You should see a JSON response like:
```
[{"itemId":"329299","name":"Red Fedora","desc":"Official Red Hat Fedora","price":34.99},...]
```

Well done! You are ready to move on to the next lab.