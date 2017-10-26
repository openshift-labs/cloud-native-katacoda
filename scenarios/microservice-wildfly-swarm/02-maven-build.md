Run the Maven build to make sure the skeleton project builds successfully. You 
should get a **BUILD SUCCESS** message in the logs, otherwise the build has failed.

> Make sure to run the **package** Maven goal and not **install**. The latter would 
> download a lot more dependencies and do things you don't need yet!

`mvn package`{{execute}}

You should see a **BUILD SUCCESS** in the logs.

Once built, the resulting *jar* is located in the **target** directory:

`ls target/*.jar`{{execute}}

The listed jar archive, **inventory-1.0-SNAPSHOT-swarm.jar** , is an uber-jar with 
all the dependencies required packaged in the *jar* to enable running the 
application with **java -jar**. WildFly Swarm also creates a *war* packaging as a standard Java EE web app 
that could be deployed to any Java EE app server (for example, JBoss EAP, or its upstream WildFly project). 

Now let's write some code and create a domain model and a RESTful endpoint to create the Inventory service:

![Inventory RESTful Service](https://katacoda.com/openshift-roadshow/assets/wfswarm-inventory-arch.png)
