You can see the build logs using OpenShift Web Console 
or OpenShift CLI, after a few moments when the build starts:

```
oc logs -f bc/web
```{{execute}}

The `-f` option is to follow the logs as the build progresses. After the building the Node.s Web UI 
completes, it gets pushed into the internal image registry in OpenShift and then deployed within 
your project.
