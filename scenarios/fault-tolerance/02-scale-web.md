Now, let's scale up the Web UI to 2 instances. In OpenShift, 
deployment config is responsible for starting the 
application pods and ensuring the specified number of instances for each application pod 
is running. Therefore the number of pods you want to scale to should be defined on the 
deployment config.

First, get list of deployment configs available in the project.

```
oc get dc
```{{execute}}

And then, scale the **web** deployment config to 2 pods:

```
oc scale dc/web --replicas=2
```{{execute}}

The `--replicas` option specified the number of Web UI pods that should be running. If you look 
at the OpenShift Web Console, you can see a new pod is being started for the Web UI and as soon 
as the health probes pass, it will be automatically added to the load-balancer.

![Scaling Up Pods](https://katacoda.com/openshift-roadshow/assets/fault-scale-up.png)

After the new pod is deployed, you can verify that the new pod is added to the load balancer by checking the details of the 
Web UI service object:

```
oc describe svc/web
```{{execute}}

**Endpoints** shows the IPs of the 2 pods that the load-balancer is sending traffic to.

```
...
Endpoints:              10.129.0.146:8080,10.129.0.232:8080
...
```

The load-balancer by default, sends the client to the same pod on consequent requests. The 
[load-balancing strategy](https://docs.openshift.com/container-platform/3.5/architecture/core_concepts/routes.html#load-balancing) 
can be specified using an annotation on the route object. Run the following 
to change the load-balancing strategy to round robin: 

```
oc annotate route/web haproxy.router.openshift.io/balance=roundrobin --overwrite
```{{execute}}
