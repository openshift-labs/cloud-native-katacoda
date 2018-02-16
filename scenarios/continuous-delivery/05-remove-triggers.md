OpenShift automates deployments using [deployment triggers]({{OPENSHIFT_DOCS_BASE}}/dev_guide/deployments/basic_deployment_operations.html#triggers) that react to changes to the container image or configuration. Since you want to control the deployments instead 
from the pipeline, you should set the Inventory deploy triggers to manual deployment 
so that building a new Inventory container image wouldn't automatically result in a 
new deployment. That would allow the pipeline to decide when a deployment should occur.

Set the Inventory deployment triggers to manual:

```
oc set triggers dc/inventory --manual
```{{execute}}