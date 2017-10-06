Health probes are defined on the deployment config for each pod and can be added using OpenShift Web 
Console or OpenShift CLI. You will try both in this scenario.

Like mentioned, health probes are defined on a deployment config for each pod. Review the available 
deployment configs in the project. 

`oc get dc`{{execute}}

> **dc** stands for deployment config

Add a liveness probe on the catalog deployment config using **oc set probe**

```oc set probe dc/catalog --liveness --get-url=http://:8080/health```{{execute}}

OpenShift automates deployments using [deployment triggers](https://docs.openshift.com/container-platform/3.6/dev_guide/deployments/basic_deployment_operations.html#triggers) 
that react to changes to the container image or configuration. 
Therefore, as soon as you define the probe, OpenShift automatically redeploys the 
Catalog pod using the new configuration including the liveness probe. 

The **--get-url** defines the HTTP endpoint to use for check the liveness of the container. The **ht<span>tp://:8080**
syntax is a convenient way to define the endpoint without having to worry about the hostname for the running 
container. 

> It is possible to customize the probes even further using for example **--initial-delay-seconds**
> to specify how long to wait after the container starts and before to begin checking the probes. 
> Run **oc set probe --help** to get a list of all available options.

Add a readiness probe on the catalog deployment config using the same **/health** endpoint that you used for 
the liveness probe.

> It's recommended to have separate endpoints for readiness and liveness to indicate to OpenShift when 
> to restart the container and when to leave it alone and remove it from the load-balancer so 
> that an administrator would  manually investigate the issue. 

```oc set probe dc/catalog --readiness --get-url=http://:8080/health```{{execute}}

Viola! OpenShift automatically restarts the Catalog pod and as soon as the health 
probes succeed, it is ready to receive traffic. 

> Fabric8 Maven Plugin can also be configured to automatically set the health probes when running **fabric8:deploy**
> goal. Read more on [Fabric8 docs](https://maven.fabric8.io/#enrichers) under 
> [Spring Boot](https://maven.fabric8.io/#f8-spring-boot-health-check), 
> [WildFly Swarm](https://maven.fabric8.io/#f8-wildfly-swarm-health-check) and 
> [Eclipse Vert.x](https://maven.fabric8.io/#f8-vertx-health-check).
