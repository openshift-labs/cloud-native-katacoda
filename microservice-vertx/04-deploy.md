It’s time to build and deploy our service on OpenShift. First, make sure you are on the `coolstore` project:

`oc project coolstore`{{execute}}

Like discussed, Vert.x service discovery integrates into OpenShift service discovery via OpenShift 
REST API and imports available services to make them available to the Vert.x application. Security 
in OpenShift comes first and therefore accessing the OpenShift REST API requires the user or the 
system (Vert.x in this case) to have sufficient permissions to do so. All containers in 
OpenShift run with a `serviceaccount` (by default, the project `default` service account) which can 
be used to grant permissions for operations like accessing the OpenShift REST API. You can read 
more about service accounts in the [OpenShift Documentation]({{OPENSHIFT_DOCS_BASE}}/dev_guide/service_accounts.html) and this 
[blog post](https://blog.openshift.com/understanding-service-accounts-sccs/#_service_accounts)

Grant permission to the API Gateway to be able to access OpenShift REST API and discover services.

`oc policy add-role-to-user view -n coolstore -z default`{{execute}}

OpenShift [Source-to-Image (S2I)]({{OPENSHIFT_DOCS_BASE}}/architecture/core_concepts/builds_and_image_streams.html#source-build) 
feature can be used to build a container image from your project. OpenShift 
S2I uses the supported OpenJDK container image to build the final container 
image of the API Gateway service by uploading the Vert.x uber-jar from 
the `target` folder to the OpenShift platform. 

Maven projects can use the [Fabric8 Maven Plugin](https://maven.fabric8.io) in order to use OpenShift S2I for building 
the container image of the application from within the project. This maven plugin is a Kubernetes/OpenShift client 
able to communicate with the OpenShift platform using the REST endpoints in order to issue the commands 
allowing to build a project, deploy it and finally launch a docker process as a pod.

To build and deploy the Inventory service on OpenShift using the `fabric8` maven plugin, run the following Maven command:

`mvn fabric8:deploy`{{execute}}

This will cause the following to happen:

* The API Gateway uber-jar is built using WildFly Swarm
* A container image is built on OpenShift containing the API Gateway uber-jar and JDK
* All necessary objects are created within the OpenShift project to deploy the API Gateway service

Once this completes, your project should be up and running. OpenShift runs the different components of 
the project in one or more pods which are the unit of runtime deployment and consists of the running 
containers for the project. 

Let's take a moment and review the OpenShift resources that are created for the Catalog REST API:

* **Build Config**: `gateway-s2i` build config is the configuration for building the Catalog 
container image from the gateway source code or JAR archive
* **Image Stream**: `gateway` image stream is the virtual view of all gateway container 
images built and pushed to the OpenShift integrated registry.
* **Deployment Config**: `gateway` deployment config deploys and redeploys the Catalog container 
image whenever a new Catalog container image becomes available
* **Service**: `gateway` service is an internal load balancer which identifies a set of 
pods (containers) in order to proxy the connections it receives to them. Backing pods can be 
added to or removed from a service arbitrarily while the service remains consistently available, 
enabling anything that depends on the service to refer to it at a consistent address (service name 
or IP).
* **Route**: `gateway` route registers the service on the built-in external load-balancer 
and assigns a public DNS name to it so that it can be reached from outside OpenShift cluster.

You can review the above resources in the OpenShift Web Console or using `oc describe` command:

> `bc` is the short-form of `buildconfig` and can be interchangeably used instead of it with the
> OpenShift CLI. The same goes for `is` instead of `imagestream`, `dc` instead of`deploymentconfig` 
> and `svc` instead of `service`.

`oc describe bc gateway-s2i`{{execute}}
`oc describe is gateway`{{execute}}
`oc describe dc gateway`{{execute}}
`oc describe svc gateway`{{execute}}
`oc describe route gateway`{{execute}}

You can see the expose DNS url for the Catalog service in the OpenShift Web Console or using 
OpenShift CLI.

`oc get routes`{{execute}}

Copy the route url for API Gateway and verify the API Gateway service works using `curl`:

> Replace `API-GATEWAY-ROUTE-HOST` with your API Gateway route url in the following command

`curl http://API-GATEWAY-ROUTE-HOST/api/products`

You would see a JSON response like:

```
[ {
  "itemId" : "329299",
  "name" : "Red Fedora",
  "desc" : "Official Red Hat Fedora",
  "price" : 34.99,
  "availability" : {
    "quantity" : 35
  }
},
...
]
```

As mentioned earlier, Vert.x built-in service discovery is integrated with OpenShift service 
discovery to lookup the Catalog and Inventory APIs.

Well done! You are ready to move on to the next lab.