All of the above comes out-of-the-box and don't need any extra configuration. Remove the Catalog 
pod to verify how OpenShift starts the pod again. First, check the Catalog pod that is running:

```
oc get pods -l deploymentconfig=catalog
```{{execute}}

The `-l` options tells the command to list pods that have the `deploymentconfig=catalog` label 
assigned to them. You can see pods labels using `oc get pods --show-labels` command.

Delete the Catalog pod.

```
oc delete pods -l deploymentconfig=catalog
```{{execute}}

You need to be fast for this one! List the Catalog pods again immediately:

```
oc get pods -l deploymentconfig=catalog
```{{execute}}

As the Catalog pod is being deleted, OpenShift notices the lack of 1 pod and starts a new Catalog 
pod automatically.

```
NAME         READY  STATUS
catalog-3-5  0/1    ContainerCreating
catalog-3-x  0/1    Terminating
```

