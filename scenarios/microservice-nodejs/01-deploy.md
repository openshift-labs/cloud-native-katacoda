The Web UI is built using Node.js for server-side JavaScript and AngularJS for client-side 
JavaScript. Let's deploy it on OpenShift using the certified Node.js container image available 
in OpenShift. 

In the previous scenarios, you used the OpenShift 
[Source-to-Image (S2I)](https://docs.openshift.com/container-platform/3.6/architecture/core_concepts/builds_and_image_streams.html#source-build) 
feature via the [Fabric8 Maven Plugin](https://maven.fabric8.io) to build a container image from the 
source code on your laptop. In this scenario, you will still use S2I but instead instruct OpenShift 
to obtain the application code directly from the source repository and build and deploy a 
container image of it.

The source code for the the Node.js Web front-end is available in this Git repository: 
<https://github.com/openshift-roadshow/cloud-native-labs/tree/master/web-nodejs>

Use the OpenShift CLI command to create a new build and deployment for the Web component:

> Feeling adventurous? Build and deploy the Web front-end via the OpenShift Web Console 
> instead. To give you a hint, start by clicking on **Add to project** within the 
> **coolstore** project and pick **JavaScript** and then **Node.js** in the service 
> catalog. Don't forget to click on **advanced options** and set **Context Dir** to **web-nodejs**
> which is the sub-folder of the Git repository where the source code for Web resides.

```
oc new-app nodejs~https://github.com/openshift-roadshow/cloud-native-labs.git \
        --context-dir=web-nodejs \
        --name=web
```{{execute}}

The **--context-dir** option specifies the sub-directly of the Git repository which contains 
the source code for the application to be built and deployed. The **--labels** allows 
assigining arbitrary key-value labels to the application objects in order to make it easier to 
find them later on when you have many applications in the same project.

A build gets created and starts building the Node.js Web UI container image. 