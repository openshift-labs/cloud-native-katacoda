There is a Gogs Git Server deployed on your OpenShift cluster which you can use 
for version control during this scenario. Open Gogs in a new browser tab:

<http://gogs-infra-app-[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com>

Register with the following details:
* Username: **developer**
* Email: **developer@me.com**
* Password: **developer**

Login after registration and then click on the plus icon on the top navigation 
bar and then on **New Repository**.

![Create New Repository](https://katacoda.com/openshift-roadshow/assets/cd-gogs-plus-icon.png)

Give **inventory-wildfly-swarm** as **Repository Name** and click on **Create Repository** 
button, leaving the rest with default values.

![Create New Repository](https://katacoda.com/openshift-roadshow/assets/cd-gogs-new-repo.png)

The Git repository is created now. 

Click on the copy-to-clipboard icon to near the 
HTTP Git url to copy it to the clipboard which you will need in a few minutes.

![Empty Repository](https://katacoda.com/openshift-roadshow/assets/cd-gogs-empty-repo.png)
