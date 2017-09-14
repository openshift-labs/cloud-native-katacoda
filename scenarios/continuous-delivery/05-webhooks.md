Manually triggering the deployment pipeline to run is useful but the real goes is to be able 
to build and deploy every change in code or configuration at least to lower environments 
(e.g. dev and test) and ideally all the way to production with some manual approvals in-place.

In order to automate triggering the pipeline, you can define a webhook on your Git repository 
to notify OpenShift on every commit that is made to the Git repository and trigger a pipeline 
execution.

You can get see the webhook links for your **inventory-pipeline** using the **describe** command.

`oc describe bc inventory-pipeline`{{execute}}

You would see many details about the build config, including the webhooks urls.

> You can also see the webhooks in the OpenShift Web Console by going to **Build &rarr; Pipelines** , 
> click on the pipeline and go to the **Configurations** tab.

Copy the Generic webhook url which you will need in the next steps.

Go to Gogs browser tab and then your **inventory-wildfly-swarm** Git repository, then click on **Settings**:

<https://gogs-[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com>

![Repository Settings](https://raw.githubusercontent.com/openshift-roadshow/cloud-native-katacoda/master/assets/cd-gogs-settings-link.png)

On the left menu, click on **Webhooks** and then on **Add Webhook** button and then **Gogs**. 

Create a webhook with the following details:

* **Payload URL**: paste the Generic webhook url you copied from the *inventory-pipeline*
* **Content type**: **application/json**

Click on **Add Webhook**. 

![Repository Webhook](https://raw.githubusercontent.com/openshift-roadshow/cloud-native-katacoda/master/assets/cd-gogs-webhook-add.png)

All done. You can click on the newly defined webhook to see the list of **Recent Delivery**. 
Clicking on the **Test Delivery** button allows you to manually trigger the webhook for 
testing purposes. Click on it and verify that the **inventory-pipeline** start running 
immediately.

Well done! You are ready for the next scenario.