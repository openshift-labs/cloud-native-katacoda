Set the following resource constraints on the Web UI pod:

* Memory Request: 256 MB
* Memory Limit: 512 MB
* CPU Request: 200 millicore
* CPU Limit: 300 millicore

CPU is measured in units called millicores while memory is measured in bytes and is specified with [SI suffices](https://docs.openshift.com/container-platform/3.7/dev_guide/compute_resources.html#dev-compute-resources) 
(E, P, T, G, M, K) or their power-of-two-equivalents (Ei, Pi, Ti, Gi, Mi, Ki).

```
oc set resources dc/web --limits=cpu=400m,memory=512Mi --requests=cpu=200m,memory=256Mi
```{{execute}}

The pods get restarted automatically setting the new resource limits in effect. Now you can define an 
autoscaler to scale the Web UI pods up to 5 instances whenever the CPU consumption passes 40% utilization:

```
oc autoscale dc/web --min 1 --max 5 --cpu-percent=40
```{{execute}}

All set! Now the Web UI can scale automatically to multiple instances if the load on the CoolStore 
online store increases. You can verify that using for example `siege` the 
[http load testing and benchmarking utility](https://www.joedog.org/siege-manual/). Let's 
deploy the `siege` container image from [Docker Hub](https://hub.docker.com/r/siamaksade/siege/) 
as a [Kubernetes job](https://docs.openshift.com/container-platform/3.10/dev_guide/jobs.html) and 
generate some load on the Web UI:

```
oc run web-load --restart='OnFailure' --image=siamaksade/siege -- -c80 -d2 -t5M  http://web:8080/
```{{execute}}

OpenShift will first looks in the internal image registry and then in defined upstream registries 
([Red Hat Container Catalog](https://access.redhat.com/search/#/container-images) and 
[Docker Hub](https://hub.docker.com) by default) to find and pull this image. 

As the load is generated, you will notice that it will create a spike in the 
Web UI cpu usage and trigger the autoscaler to scale the Web UI container to 5 pods (as configured 
on the deployment config) to cope with the load.

Depending on the resources available on the OpenShift cluster, the pod might scale 
to fewer than 5 pods to handle the extra load. You can generate more load load by 
specifying a higher number of concurrent requests `-c80` flag. Just make sure to remove the 
existing `web-load` job first (see if you can find out how!). 

![Web UI Automatically Scaled](https://katacoda.com/openshift-roadshow/assets/fault-autoscale-web.gif)