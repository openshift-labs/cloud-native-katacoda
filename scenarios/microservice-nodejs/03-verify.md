In order to access the Web UI from outside (e.g. from a browser), it needs to get added to the load 
balancer. Run the following command to add the Web UI service to the built-in HAProxy load balancer 
in OpenShift.

```oc expose svc/web```{{execute}}

```oc get route web```{{execute}}

Point your browser at the Web UI route url. You should be able to see the CoolStore with all 
products and their inventory status.

![CoolStore Shop](https://katacoda.com/openshift-roadshow/assets/coolstore-web.png)

Well done! 