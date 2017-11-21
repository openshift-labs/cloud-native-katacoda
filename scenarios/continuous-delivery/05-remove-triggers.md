OpenShift automates deployments using [deployment triggers]({{OPENSHIFT_DOCS_BASE}}/dev_guide/deployments/basic_deployment_operations.html#triggers) that react to changes to the container image or configuration. Since you want to control the deployments instead 
from the pipeline, you should remove the Inventory deploy triggers so that building a new 
Inventory container image wouldn't automatically result in a new deployment. That would 
allow the pipeline to decide when a deployment should occur.

Remove the Inventory deployment triggers:

```
oc set triggers dc/inventory --remove-all
```{{execute}}