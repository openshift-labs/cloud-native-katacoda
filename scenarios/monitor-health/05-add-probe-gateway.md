You are an expert in health probes by now! Add liveness and readiness probes to the API Gateway service:

```
oc set probe dc/gateway \
    --liveness \
    --readiness \
    --get-url=http://:8080/health
```{{execute}}

OpenShift automatically restarts the Gateway pod and as soon as the health probes succeed, it is 
ready to receive traffic. 
