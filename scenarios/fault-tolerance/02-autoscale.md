Although scaling up and scaling down pods are automated and easy using OpenShift, however it still 
requires a person or a system to run a command or invoke an API call (to OpenShift REST API. Yup! there
is a REST API for all OpenShift operations) to scale the applications. That in turn needs to be in response 
to some sort of increase to the application load and therefore the person or the system needs to be aware of 
how much load the application is handling at all times to make the scaling decision.

OpenShift automates this aspect of scaling as well via automatically scaling the application pods up 
and down within a specified min and max boundary based on the container metrics such as cpu and memory 
consumption. In that case, if there is a surge of users visiting the CoolStore online shop due to 
holiday season coming up or a good deal on a product, OpenShift would automatically add more pods to 
handle the increase load on the application and after the load goes, the application is automatically 
scaled down to free up compute resources.

In order the define auto-scaling for a pod, we should first define how much cpu and memory a pod is 
allowed to consume which will act as a guideline for OpenShift to know when to scale the pod up or 
down. Since the deployment config starts the application pods, the application pod resource 
(cpu and memory) containers should also be defined on the deployment config.

When allocating compute resources to application pods, each container may specify a *request*
and a *limit*value each for CPU and memory. The 
[*request*](https://docs.openshift.com/container-platform/3.6/dev_guide/compute_resources.html#dev-memory-requests) 
values define how much resources should be dedicated to an application pod so that it can run. It's 
the minimum resources needed in other words. The 
[*limit*](https://docs.openshift.com/container-platform/3.6/dev_guide/compute_resources.html#dev-memory-limits) values 
defines how much resources an application pod is allowed to consume, if there is more resources 
on the node available than what the pod has request. This is to allow various quality of service 
tiers with regards to compute resources. You can read more about these quality of service tiers 
in [OpenShift Documentation](https://docs.openshift.com/container-platform/3.6/dev_guide/compute_resources.html#quality-of-service-tiers).

Set resource containers on the Web UI pod using `oc set resource` to the following:

* Memory Request: 256 MB
* Memory Limit: 512 MB
* CPU Request: 200 millicore
* CPU Limit: 300 millicore

> CPU is measured in units called millicores. Each node in a cluster inspects the 
> operating system to determine the amount of CPU cores on the node, then multiplies 
> that value by 1000 to express its total capacity. For example, if a node has 2 cores, 
> the node’s CPU capacity would be represented as 2000m. If you wanted to use 1/10 of 
> a single core, it would be represented as 100m. Memory is measured in 
> bytes and is specified with [SI suffices](https://docs.openshift.com/container-platform/3.6/dev_guide/compute_resources.html#dev-compute-resources) 
> (E, P, T, G, M, K) or their power-of-two-equivalents (Ei, Pi, Ti, Gi, Mi, Ki).


`$ oc set resources dc/web --limits=cpu=400m,memory=512Mi --requests=cpu=200m,memory=256Mi`{{execute}}

> You can also use the OpenShift Web Console by clicking on **Applications** >> **Deployments** within 
> the **coolstore** project. Click then on **web** and from the **Actions** menu on 
> the top-right, choose **Edit Resource Limits**.

The pods get restarted automatically setting the new resource limits in effect. Now you can define an 
autoscaler using `oc autoscale` command to scale the Web UI pods up to 5 instances whenever 
the CPU consumption passes 50% utilization:

> You can configure an autoscaler using OpenShift Web Console by clicking 
> on **Applications** >> **Deployments** within 
> the **coolstore** project. Click then on **web** and from the **Actions** menu on 
> the top-right, choose **Edit Autoscaler**.

`oc autoscale dc/web --min 1 --max 5 --cpu-percent=40`{{execute}}

All set! Now the Web UI can scale automatically to multiple instances if the load on the CoolStore 
online store increases. You can verify that using for example `ab`, the 
[Apache HTTP server benchmarking tool](https://httpd.apache.org/docs/2.4/programs/ab.html). Let's 
deploy the `ab` container image from [Docker Hub](https://hub.docker.com/r/jordi/ab/) and 
generate some load on the Web UI. Since we want to run this container only once and after it runs 
it's not needed anymore, use the `oc run --rm` command to run the container and throw it away 
after it's done running:

`oc run web-load --rm --attach --image=jordi/ab -- ab -n 50000 -c 10 http://web:8080/`{{execute}}

In the above, `--image` specified which container image should be deployed. OpenShift will first 
looks in the internal image registry and then in defined upstream registries 
([Red Hat Container Catalog](https://access.redhat.com/search/#/container-images) and 
[Docker Hub](https://hub.docker.com) by default) to find and pull this image. After `--`, you 
can override the container entry point to whatever command you want to run in that container.

As you the `ab` container generates the load, you will notice that it will create a spike in the 
Web UI cpu usage and trigger the autoscaler to scale the Web UI container to 5 pods (as configured 
on the deployment config) to cope with the load.

> Depending on the resources available on the OpenShift cluster in the lab environment, 
> the Web UI might scale to fewer than 5 pods to handle the extra load. You can increase 
> the load by specifying a higher number of requests (e.g. 80K) using `ab -n` flag.

![Web UI Automatically Scaled](https://raw.githubusercontent.com/openshift-roadshow/cloud-native-katacoda/master/assets/fault-autoscale-web.png)

You can see the aggregated cpu metrics graph of all 5 Web UI pods by going to the OpenShift Web Console and clicking on **Monitoring** and then the arrow (**>**) on the left side of **web-n** under **Deployments**.

![Web UI Aggregated CPU Metrics](https://raw.githubusercontent.com/openshift-roadshow/cloud-native-katacoda/master/assets/fault-autoscale-metrics.png)

When the load on Web UI disappears, after a while OpenShift scales the Web UI pods down to the minimum 
or whatever this needed to cope with the load at that point.