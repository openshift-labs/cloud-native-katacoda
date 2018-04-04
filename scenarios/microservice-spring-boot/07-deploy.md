It’s time to build and deploy Catalog service on OpenShift using [Source-to-Image (S2I)](https://docs.openshift.com/container-platform/3.7/architecture/core_concepts/builds_and_image_streams.html#source-build).

To build and deploy the Catalog service on OpenShift using the **fabric8** maven plugin, run the following maven command:

```
mvn fabric8:deploy
```{{execute T1}}

During the deployment, you might see that Fabric8 Maven Plugin throws an `java.util.concurrent.RejectedExecutionException` 
exception. This is due to [a bug](https://github.com/fabric8io/kubernetes-client/issues/1035) in one of Fabric8 Maven Plugin 
dependencies which is being worked on right now and will be fixed soon. You can ignore this exception for now. The deployment 
nevertheless succeeds.

`fabric8:deploy` will cause the following to happen:

* The Catalog uber-jar is built using Spring Boot
* A container image is built on OpenShift containing the Catalog uber-jar and JDK
* All necessary objects are created within the OpenShift project to deploy the Catalog service

Once this completes, your project should be up and running. OpenShift runs the different components of 
the project in one or more pods which are the unit of runtime deployment and consists of the running 
containers for the project. 