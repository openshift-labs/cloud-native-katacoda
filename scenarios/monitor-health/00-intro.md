In this lab we will learn how to monitor application health using OpenShift 
health probes and how you can see container resource consumption using metrics.

##  Health Probes

When building microservices, monitoring becomes of extreme importance to make sure all services 
are running at all times, and when they don't there are automatic actions triggered to rectify 
the issues. 

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

* **HTTP Checks:** healthiness of the container is determined based on the response code of an HTTP 
endpoint. Anything between 200 and 399 is considered success. A HTTP check is ideal for applications 
that return HTTP status codes when completely initialized.

* **Container Execution Checks:** a specified command is executed inside the container and the healthiness is 
determined based on the return value (0 is success). 

* **TCP Socket Checks:** a socket is opened on a specified port to the container and it's considered healthy 
only if the check can establish a connection. TCP socket check is ideal for applications that do not 
start listening until initialization is complete.
 
Let's add health probes to the microservices deployed so far.