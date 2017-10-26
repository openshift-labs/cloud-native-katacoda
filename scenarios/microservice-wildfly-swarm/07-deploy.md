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