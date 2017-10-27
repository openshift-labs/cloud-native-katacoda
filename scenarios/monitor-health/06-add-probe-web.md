Although you can add the liveness and health probes to the Web UI using a single CLI command, let's 
give the OpenShift Web Console a try this time.

Go the OpenShift Web Console by clicking on **Dashboard** and go in the **coolstore** project. Click on 
**Applications &rarr; Deployments** on the left-side bar. Click on **web** and then the **Configuration** 
tab. You will see the warning about health checks, with a link to
click in order to add them. Click **Add health checks** now. 

![Health Probes](https://katacoda.com/openshift-roadshow/assets/health-web-details.png)

You should click on both **Add Readiness Probe** and **Add Liveness Probe** and
then fill them out as follows:

*Readiness Probe*

* Path: **/**
* Initial Delay: **10**
* Timeout: **1**

*Liveness Probe*

* Path: **/**
* Initial Delay: **180**
* Timeout: **1**

![Readiness Probe](https://katacoda.com/openshift-roadshow/assets/health-readiness.png)

![Readiness Probe](https://katacoda.com/openshift-roadshow/assets/health-liveness.png)

Click **Save** and then click the **Overview** button in the left navigation. You
will notice that Web UI pod is getting restarted and it stays light blue
for a while. This is a sign that the pod(s) have not yet passed their readiness
checks and it turns blue when it's ready!

![Web Redeploy](https://katacoda.com/openshift-roadshow/assets/health-web-redeploy.png)
