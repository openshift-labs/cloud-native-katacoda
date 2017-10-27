You can see the aggregated cpu metrics graph of all 5 Web UI pods by going
 to the OpenShift Web Console and clicking on **Monitoring** and then 
 the arrow (**>**) on the left side of **web-n** under **Deployments**.

![Web UI Aggregated CPU Metrics](https://katacoda.com/openshift-roadshow/assets/fault-autoscale-metrics.png)

When the load on Web UI disappears, after a while OpenShift scales the Web UI pods down to the minimum 
or whatever this needed to cope with the load at that point.