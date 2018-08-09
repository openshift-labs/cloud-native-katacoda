The Web UI is built using Node.js for server-side JavaScript and AngularJS for client-side 
JavaScript. Let's deploy it on OpenShift using the certified Node.js container image available 
in OpenShift. 

In the previous scenarios, you used the OpenShift 
[Source-to-Image (S2I)](https://docs.openshift.com/container-platform/3.7/architecture/core_concepts/builds_and_image_streams.html#source-build) 
feature via the [Fabric8 Maven Plugin](https://maven.fabric8.io) to build a container image from the 
source code on your laptop. In this scenario, you will still use S2I but instead instruct OpenShift 
to obtain the application code directly from the source repository and build and deploy a 
container image of it.

The source code for the the Node.js Web front-end is available in this Git repository: 
<https://github.com/openshift-labs/cloud-native-labs/tree/master/web-nodejs>

Use the OpenShift CLI command to create a new build and deployment for the Web component:

```
oc new-app \
   nodejs~https://github.com/openshift-labs/cloud-native-labs.git#ocp-3.10 \
   --context-dir=web-nodejs \
   --name=web
```{{execute}}

The **--context-dir** option specifies the sub-directly of the Git repository which contains 
the source code for the application to be built and deployed. 

A build gets created and starts building the Node.js Web UI container image. 