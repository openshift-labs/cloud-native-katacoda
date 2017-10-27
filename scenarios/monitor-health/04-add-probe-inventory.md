Adding liveness and readiness probes can be done at the same time if you want to define the same health endpoint 
and parameters for both liveness and readiness probes. 

Add liveness and readiness probes to the Inventory service:

```
oc set probe dc/inventory \
    --liveness \
    --readiness \
    --get-url=http://:8080/node
```{{execute}}

OpenShift automatically restarts the Inventory pod and as soon as the health probes succeed, it is ready to receive traffic. 

You can get a detailed look into the deployment config and verify that the health probes are in fact configured as you wanted:

```
oc describe dc/inventory
```{{execute}}

Look for `Liveness` and `Readiness` in the result.