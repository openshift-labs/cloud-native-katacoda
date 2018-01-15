[Projects](https://docs.openshift.com/container-platform/3.7/architecture/core_concepts/projects_and_users.html#projects) 
are a top level concept to help you organize your deployments. An
OpenShift project allows a community of users (or a user) to organize and manage
their content in isolation from other communities. Each project has its own
resources, policies (who can or cannot perform actions), and constraints (quotas
and limits on resources, etc). Projects act as a wrapper around all the
application services and endpoints you (or your teams) are using for your work.

For this scenario, let's create a project that you will use in the following scenarios for 
deploying your applications. 

```
oc new-project coolstore
```{{execute}}