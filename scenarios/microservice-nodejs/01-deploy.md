The Web UI is built using Node.js for server-side JavaScript and AngularJS for client-side 
JavaScript. Let's deploy it on OpenShift using the certified Node.js container image available 
in OpenShift. 

In the previous labs, you used the OpenShift 
[Source-to-Image (S2I)](https://docs.openshift.com/container-platform/3.6/architecture/core_concepts/builds_and_image_streams.html#source-build) 
feature via the [Fabric8 Maven Plugin](https://maven.fabric8.io) to build a container image from the 
source code on your laptop. In this lab, you will still use S2I but instead instruct OpenShift 
to obtain the application code directly from the source repository and build and deploy a 
container image of it.

The source code for the the Node.js Web front-end is available in this Git repository: 
<https://github.com/openshift-roadshow/cloud-native-labs/tree/master/web-nodejs>

First, make sure you are on the **coolstore**project:

`oc project coolstore`{{execute}}

Use the OpenShift CLI command to create a new build and deployment for the Web component:

> Feeling adventurous? Build and deploy the Web front-end via the OpenShift Web Console 
> instead. To give you a hint, start by clicking on **Add to project** within the 
> **coolstore** project and pick **JavaScript** and then **Node.js** in the service 
> catalog. Don't forget to click on **advanced options** and set **Context Dir** to **web-nodejs**
> which is the sub-folder of the Git repository where the source code for Web resides.

```
oc new-app nodejs~https://github.com/openshift-roadshow/cloud-native-labs.git \
        --context-dir=web-nodejs \
        --name=web \
        --labels=app=coolstore,microservice=web
```{{execute}}

The **--context-dir**option specifies the sub-directly of the Git repository which contains 
the source code for the application to be built and deployed. The **--labels**allows 
assigining arbitrary key-value labels to the application objects in order to make it easier to 
find them later on when you have many applications in the same project.

A build gets created and starts building the Node.js Web UI container image. You can see the build 
logs using OpenShift Web Console or OpenShift CLI:

`oc logs -f bc/web`{{execute}}

The **-f**option is to follow the logs as the build progresses. After the building the Node.s Web UI 
completes, it gets pushed into the internal image registry in OpenShift and then deployed within 
your project.

In order to access the Web UI from outside (e.g. from a browser), it needs to get added to the load 
balancer. Run the following command to add the Web UI service to the built-in HAProxy load balancer 
in OpenShift.

`oc expose svc/web`{{execute}}
`oc get route web`{{execute}}

Point your browser at the Web UI route url. You should be able to see the CoolStore with all 
products and their inventory status.

![CoolStore Shop](https://raw.githubusercontent.com/openshift-roadshow/cloud-native-katacoda/master/assets/coolstore-web.png)

Currently the **fabric8-maven-plugin**has a 
[bug](https://github.com/fabric8io/fabric8-maven-plugin/issues/742)
that prevents grouping the pods properly. Run the following 
tweak to assign an **app**label to deployment configs and group them 
together in the OpenShift Web Console

`oc label dc app=coolstore --all --overwrite`{{execute}}

![CoolStore Pods](https://raw.githubusercontent.com/openshift-roadshow/cloud-native-katacoda/master/assets/coolstore-pods-nodb.png)

Well done! You are ready to move on to the next lab.