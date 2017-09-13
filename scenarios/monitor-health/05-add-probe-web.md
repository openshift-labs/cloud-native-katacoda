Although you can add the liveness and health probes to the Web UI using a single CLI command, let's 
give the OpenShift Web Console a try this time.

Go the OpenShift Web Console in your browser and in the **coolstore** project. Click on 
**Applications >> Deployments** on the left-side bar. Click on **web** and then the **Configuration** 
tab. You will see the warning about health checks, with a link to
click in order to add them. Click **Add health checks** now. 

> Instead of **Configuration** tab, you can directly click on **Actions** button on the top-right 
> and then **Edit Health Checks**

![Health Probes](https://raw.githubusercontent.com/openshift-roadshow/cloud-native-katacoda/master/assets/health-web-details.png)

You will want to click both **Add Readiness Probe** and **Add Liveness Probe** and
then fill them out as follows:

*Readiness Probe*

* Path: `/`
* Initial Delay: `10`
* Timeout: `1`

*Liveness Probe*

* Path: `/`
* Initial Delay: `180`
* Timeout: `1`

![Readiness Probe](https://raw.githubusercontent.com/openshift-roadshow/cloud-native-katacoda/master/assets/health-readiness.png)

![Readiness Probe](https://raw.githubusercontent.com/openshift-roadshow/cloud-native-katacoda/master/assets/health-liveness.png)

Click **Save** and then click the **Overview** button in the left navigation. You
will notice that Web UI pod is getting restarted and it stays light blue
for a while. This is a sign that the pod(s) have not yet passed their readiness
checks and it turns blue when it's ready!

![Web Redeploy](https://raw.githubusercontent.com/openshift-roadshow/cloud-native-katacoda/master/assets/health-web-redeploy.png)
