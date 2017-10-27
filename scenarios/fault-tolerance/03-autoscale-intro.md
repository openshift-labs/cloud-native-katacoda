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