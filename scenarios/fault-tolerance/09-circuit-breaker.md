Let's take the Inventory service down and see what happens to the CoolStore online shop.

```
oc scale dc/inventory --replicas=0
```{{execute}}

Now point your browser at the Web UI route url.

> You can find the Web UI route url in the OpenShift Web Console above the **web** pod or
> using the `oc get routes` command.

![CoolStore Without Circuit Breaker](https://katacoda.com/openshift-roadshow/assets/fault-coolstore-no-cb.png)

Although only the Inventory service is down, there are no products displayed in the online store because
the Inventory service call failure propagates and causes the entire API Gateway to blow up!
