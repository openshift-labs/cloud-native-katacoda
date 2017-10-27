##  Health Probes

OpenShift, using Kubernetes health probes, offers a solution for monitoring application 
health and try to automatically heal faulty containers through restarting them to fix issues such as
a deadlock in the application which can be resolved by restarting the container. Restarting a container 
in such a state can help to make the application more available despite bugs.

Furthermore, there are of course a category of issues that can't be resolved by restarting the container. 
In those scenarios, OpenShift would remove the faulty container from the built-in load-balancer and send traffic 
only to the healthy container remained.

There are two type of health probes available in OpenShift: [liveness probes and readiness probes](https://docs.openshift.com/container-platform/3.6/dev_guide/application_health.html#container-health-checks-using-probes). 
*Liveness probes* are to know when to restart a container and *readiness probes* to know when a 
Container is ready to start accepting traffic.

Health probes also provide crucial benefits when automating deployments with practices like rolling updates in 
order to remove downtime during deployments. A readiness health probe would signal OpenShift when to switch 
traffic from the old version of the container to the new version so that the users don't get affected during 
deployments.

There are [three ways to define a health probe](https://docs.openshift.com/container-platform/3.6/dev_guide/application_health.html#container-health-checks-using-probes) for a container:

* **HTTP Checks:** check the response code of an HTTP endpoint. 
* **Container Execution Checks:** check the return value of a command inside the container
* **TCP Socket Checks:** check connectivity to a port on the container
 