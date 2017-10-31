It’s time to build and deploy our service on OpenShift. 
Like discussed, Vert.x service discovery integrates into OpenShift service discovery via OpenShift 
REST API and imports available services to make them available to the Vert.x application. Security 
in OpenShift comes first and therefore accessing the OpenShift REST API requires the user or the 
system (Vert.x in this case) to have sufficient permissions to do so. All containers in 
OpenShift run with a **serviceaccount** (by default, the project **default** service account) which can 
be used to grant permissions for operations like accessing the OpenShift REST API. You can read 
more about service accounts in the [OpenShift Documentation](https://docs.openshift.com/container-platform/3.6/dev_guide/service_accounts.html) and this 
[blog post](https://blog.openshift.com/understanding-service-accounts-sccs/#_service_accounts)

Grant permission to the API Gateway to be able to access OpenShift REST API and discover services.

```
oc policy add-role-to-user view -n coolstore -z default
```{{execute T1}}

It’s time to build and deploy Catalog service on OpenShift using [Source-to-Image (S2I)](https://docs.openshift.com/container-platform/3.6/architecture/core_concepts/builds_and_image_streams.html#source-build).
To build and deploy the Inventory service on OpenShift using the fabric8 maven plugin, 
run the following Maven command __in the first terminal window__:

```
mvn fabric8:deploy
```{{execute T1}}

This will cause the following to happen:

* The API Gateway uber-jar is built using WildFly Swarm
* A container image is built on OpenShift containing the API Gateway uber-jar and JDK
* All necessary objects are created within the OpenShift project to deploy the API Gateway service

Once this completes, your project should be up and running. OpenShift runs the different components of 
the project in one or more pods which are the unit of runtime deployment and consists of the running 
containers for the project. 
