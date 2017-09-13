There is a Gogs Git Server deployed on your OpenShift cluster which you can use 
for version control during this lab. Go to Gogs web:
<https://gogs-[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com>

Log in with the following credentials:
* Username: `developer`
* Password: `developer`

Click on the plus icon on the top navigation bar and then on **New Repository**.

![Create New Repository](https://raw.githubusercontent.com/openshift-roadshow/cloud-native-katacoda/master/assets/cd-gogs-plus-icon.png)

Give **inventory-wildfly-swarm** as **Repository Name** and click on **Create Repository** 
button, leaving the rest with default values.

![Create New Repository](https://raw.githubusercontent.com/openshift-roadshow/cloud-native-katacoda/master/assets/cd-gogs-new-repo.png)

The Git repository is created now. 

Click on the copy-to-clipboard icon to near the 
HTTP Git url to copy it to the clipboard which you will need in a few minutes.

![Empty Repository](https://raw.githubusercontent.com/openshift-roadshow/cloud-native-katacoda/master/assets/cd-gogs-empty-repo.png)
