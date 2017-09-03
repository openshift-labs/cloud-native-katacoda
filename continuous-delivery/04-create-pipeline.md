Like mentioned, [OpenShift Pipelines](https://docs.openshift.com/container-platform/3.6/architecture/core_concepts/builds_and_image_streams.html#pipeline-build) enable creating deployment pipelines using the widely popular `Jenkinsfile` format.

Create a deployment pipeline.

> Make sure to run the `oc new-app` command from within the `inventory-widlfly-swarm` folder.

`oc new-app . --name=inventory-pipeline --strategy=pipeline`{{execute}}

The above command creates a new build config of type pipeline which is automatically 
configured to fetch the `Jenkinsfile` from the Git repository of the current folder 
(`inventory-wildfly-swarm` Git repository) and execute it on Jenkins. As soon as the 
pipeline is created, OpenShift auto-provisions a Jenkins server in your project, using 
the certified Jenkins image that is available in OpenShift image registry.

Go OpenShift Web Console inside the **coolstore** project and from the left sidebar 
click on **Builds >> Pipelines**

![OpenShift Pipeline](https://raw.githubusercontent.com/openshift-roadshow/cloud-native-katacoda/master/assets/cd-pipeline-inprogress.png)

Pipeline syntax allows creating complex deployment scenarios with the possibility of defining 
checkpoint for manual interaction and approval process using 
[the large set of steps and plugins that Jenkins provide](https://jenkins.io/doc/pipeline/steps/) in 
order to adapt the pipeline to the process used in your team. You can see a few examples of 
advanced pipelines in the 
[OpenShift GitHub Repository](https://github.com/openshift/origin/tree/master/examples/jenkins/pipeline).

In order to update the deployment pipeline, all you need to do is to update the `Jenkinsfile` 
in the `inventory-wildfly-swarm` Git repository. OpenShift pipeline automatically executes the 
updated pipeline next time it runs.
