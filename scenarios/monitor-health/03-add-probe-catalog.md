Health probes are defined on the deployment config (`dc`) and can be added using OpenShift Web 
Console or OpenShift CLI. 

Add a liveness probe on the Catalog deployment config:

```
oc set probe dc/catalog --liveness --get-url=http://:8080/health
```{{execute}}

OpenShift automates deployments using [deployment triggers](https://docs.openshift.com/container-platform/3.6/dev_guide/deployments/basic_deployment_operations.html#triggers) 
that react to changes to the container image or configuration. 
Therefore, as soon as you define the probe, OpenShift automatically redeploys the 
Catalog pod using the new configuration including the liveness probe. 

The `--get-url` defines the HTTP endpoint to use for check the liveness of the container. The `ht<span>tp://:8080`
syntax is a convenient way to define the endpoint without having to worry about the hostname for the running 
container. 

Add a readiness probe on the catalog deployment config using the same `/health` endpoint that you used for 
the liveness probe. Note that it's recommended to have separate endpoints for readiness and liveness.

```
oc set probe dc/catalog --readiness --get-url=http://:8080/health
```{{execute}}

Viola! OpenShift automatically restarts the Catalog pod and as soon as the health 
probes succeed, it is ready to receive traffic. 

Fabric8 Maven Plugin can also be configured to automatically set the health 
probes when running `fabric8:deploy` goal. Read more on Fabric8 docs for 
[Spring Boot](https://maven.fabric8.io/#f8-spring-boot-health-check), 
[WildFly Swarm](https://maven.fabric8.io/#f8-wildfly-swarm-health-check) and 
[Eclipse Vert.x](https://maven.fabric8.io/#f8-vertx-health-check).
