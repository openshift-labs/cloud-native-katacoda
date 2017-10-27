Set resource containers on the Web UI pod using `oc set resource` to the following:

* Memory Request: 256 MB
* Memory Limit: 512 MB
* CPU Request: 200 millicore
* CPU Limit: 300 millicore

CPU is measured in units called millicores while memory is measured in bytes and is specified with [SI suffices](https://docs.openshift.com/container-platform/3.6/dev_guide/compute_resources.html#dev-compute-resources) 
(E, P, T, G, M, K) or their power-of-two-equivalents (Ei, Pi, Ti, Gi, Mi, Ki).

```
oc set resources dc/web --limits=cpu=400m,memory=512Mi --requests=cpu=200m,memory=256Mi
```{{execute}}

The pods get restarted automatically setting the new resource limits in effect. Now you can define an 
autoscaler to scale the Web UI pods up to 5 instances whenever 
the CPU consumption passes 50% utilization:

```
oc autoscale dc/web --min 1 --max 5 --cpu-percent=40
```{{execute}}

All set! Now the Web UI can scale automatically to multiple instances if the load on the CoolStore 
online store increases. You can verify that using for example `ab` the 
[Apache HTTP server benchmarking tool](https://httpd.apache.org/docs/2.4/programs/ab.html). Let's 
deploy the `ab` container image from [Docker Hub](https://hub.docker.com/r/jordi/ab/) and 
generate some load on the Web UI:

```
oc run web-load --rm --attach --image=jordi/ab -- ab -n 50000 -c 10 http://web:8080/
```{{execute}}

OpenShift will first looks in the internal image registry and then in defined upstream registries 
([Red Hat Container Catalog](https://access.redhat.com/search/#/container-images) and 
[Docker Hub](https://hub.docker.com) by default) to find and pull this image. 

As the load is generates, you will notice that it will create a spike in the 
Web UI cpu usage and trigger the autoscaler to scale the Web UI container to 5 pods (as configured 
on the deployment config) to cope with the load.

Depending on the resources available on the OpenShift cluster, the pod might scale 
to fewer than 5 pods. to handle the extra load. You can increase the load by 
specifying a higher number of requests e.g. `ab -n 80000`.

![Web UI Automatically Scaled](https://katacoda.com/openshift-roadshow/assets/fault-autoscale-web.png)