OpenShift has built-in support for CI/CD pipelines by allowing developers to define
a [Jenkins pipeline](https://jenkins.io/solutions/pipeline/) for execution by a Jenkins
automation engine, which is automatically provisioned on-demand by OpenShift when needed.

The build can get started, monitored, and managed by OpenShift in
the same way as any other build types e.g. S2I. Pipeline workflows are defined in
a Jenkinsfile, either embedded directly in the build configuration, or supplied in
a Git repository and referenced by the build configuration.

Jenkinsfile is a text file that contains the definition of a Jenkins Pipeline
and is created using a [scripted or declarative syntax](https://jenkins.io/doc/book/pipeline/syntax/).

Create a file called **Jenkinsfile** in the root of **inventory-wildfly-swarm** by clicking on
 *Copy to Editor*:

<pre class="file" data-filename="./inventory-wildfly-swarm/Jenkinsfile" data-target="replace">
pipeline {
  agent {
      label 'maven'
  }
  stages {
    stage('Build JAR') {
      steps {
        sh "mvn package"
        stash name:"jar", includes:"target/inventory-1.0-SNAPSHOT-swarm.jar"
      }
    }
    stage('Build Image') {
      steps {
        unstash name:"jar"
        script {
          openshift.withCluster() {
            openshift.startBuild("inventory-s2i", "--from-file=target/inventory-1.0-SNAPSHOT-swarm.jar", "--wait")
          }
        }
      }
    }
    stage('Deploy') {
      steps {
        script {
          openshift.withCluster() {
            def dc = openshift.selector("dc", "inventory")
            dc.rollout().latest()
            dc.rollout().status()
          }
        }
      }
    }
  }
}
</pre>

This pipeline has three stages:

* Build JAR: to build and test the jar file using Maven
* Build Image: to build a container image from the Inventory JAR archive using OpenShift S2I
* Deploy: to deploy the Inventory container image in the current project

Note that the pipeline definition is fully integrated with OpenShift and you can
perform operations like image build, image deploy, etc directly from within the **Jenkinsfile**.