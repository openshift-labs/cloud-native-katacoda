OpenShift has built-in support for CI/CD pipelines by allowing developers to define 
a [Jenkins pipeline](https://jenkins.io/solutions/pipeline/) for execution by a Jenkins 
automation engine, which is automatically provisioned on-demand by OpenShift when needed.

The build can get started, monitored, and managed by OpenShift in 
the same way as any other build types e.g. S2I. Pipeline workflows are defined in 
a Jenkinsfile, either embedded directly in the build configuration, or supplied in 
a Git repository and referenced by the build configuration. 

Jenkinsfile is a text file that contains the definition of a Jenkins Pipeline 
and is created using a [scripted or declarative syntax](https://jenkins.io/doc/book/pipeline/syntax/).

Create a file called `Jenkinsfile` in the root the `inventory-wildfly-swarm`:

<pre class="file" data-filename="./inventory-wildfly-swarm/Jenkinsfile" data-target="replace">
node("maven") {
  stage("Build JAR") {
    git url: "INVENTORY-GIT-URL"
    sh "mvn clean package"
    stash name:"jar", includes:"target/inventory-1.0-SNAPSHOT-swarm.jar"
  }

  stage("Build Image") {
    unstash name:"jar"
    sh "oc start-build inventory-s2i --from-file=target/inventory-1.0-SNAPSHOT-swarm.jar"
    openshiftVerifyBuild bldCfg: "inventory-s2i", waitTime: '20', waitUnit: 'min'
  }

  stage("Deploy") {
    openshiftDeploy deploymentConfig: inventory
  }
}
</pre>

This pipeline has three stages:

* *Build JAR*: to build and test the jar file using Maven
* *Build Image*: to build a container image from the Inventory JAR archive using OpenShift S2I
* *Deploy Image*: to deploy the Inventory container image in the current project

Note that the pipeline definition is fully integrated with OpenShift and you can 
perform operations like image build, image deploy, etc directly from within the `Jenkinsfile`.

When building deployment pipelines, it's important to treat your [infrastructure and everything else that needs to be configured (including the pipeline definition) as code](https://martinfowler.com/bliki/InfrastructureAsCode.html) 
and store them in a source repository for version control. 

Commit and push the `Jenkinsfile` to the Git repository.

`git add Jenkinsfile`{{execute}}
`git commit -m "pipeline added"`{{execute}}
`git push origin master`{{execute}}

The pipeline definition is ready and now you can create a deployment pipeline using 
this `Jenkinsfile`.