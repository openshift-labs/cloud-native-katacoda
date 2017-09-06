
You can now trigger a new continuer image build on OpenShift using 
the `oc start-build` command which allows you to build container images directly from the application 
archives (`jar`, `war`, etc) without the need to have access to the source code for example by downloading 
the `jar` file form the Maven repository (e.g. Nexus or Artifactory).

`oc start-build gateway-s2i --from-file=target/gateway-1.0-SNAPSHOT.jar`{{execute}}

As soon as the new `gateway` container image is built, OpenShift deploys the new image automatically 
thanks to the [deployment triggers](https://docs.openshift.com/container-platform/3.6/dev_guide/deployments/basic_deployment_operations.html#triggers) 
defined on the `gateway` deployment config.

Let's try the Web UI again in the browser while the Inventory service is still down.

![CoolStore With Circuit Breaker](.../images/fault-coolstore-with-cb.png)

It looks better now! The Inventory service failure is contained and the inventory status is removed from the 
user interface and allows the CoolStore online shop to continue functioning and accept orders. Selling an 
out-of-stock product to a few customers can simply be resolved by a discount coupons while 
losing the trust of all visiting customers due to a crashed online store is not so easily repairable!

Scale the Inventory service back up before moving on to the next labs.

`oc scale dc/inventory --replicas=1`{{execute}}

Well done! Let's move on to the next.