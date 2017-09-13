## Create Project
[Projects](https://docs.openshift.com/container-platform/3.6/architecture/core_concepts/projects_and_users.html#projects) 
are a top level concept to help you organize your deployments. An
OpenShift project allows a community of users (or a user) to organize and manage
their content in isolation from other communities. Each project has its own
resources, policies (who can or cannot perform actions), and constraints (quotas
and limits on resources, etc). Projects act as a wrapper around all the
application services and endpoints you (or your teams) are using for your work.

For this lab, let's create a project that you will use in the following labs for 
deploying your applications. 


`oc new-project coolstore`{{execute}}

## Projects in OpenShift Web Console
OpenShift ships with a web-based console that will allow users to
perform various tasks via a browser. To get a feel for how the web console
works, open a new browser tab and go to the OpenShift Web Console:

`https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com`{{copy}}

The first screen you will see is the authentication screen. Enter your username and password and 
then log in. After you have authenticated to the web console, you will be presented with a
list of projects that your user has permission to work with.

Click on the **coolstore** project to be taken to the project overview page
which will list all of the routes, services, deployments, and pods that you have
running as part of your project. There's nothing there now, but that's about to
change.