Remote debugging is a useful debugging technique for application development which allows 
looking into the code that is being executed somewhere else on a different machine and 
execute the code line-by-line to help investigate bugs and issues. Remote debugging is 
part of  Java SE standard debugging architecture which you can learn more about it in [Java SE docs](https://docs.oracle.com/javase/8/docs/technotes/guides/jpda/architecture.html).


The Java image on OpenShift has built-in support for remote debugging and it can be enabled 
by setting the `JAVA_DEBUG=true` environment variables on the deployment config for the pod 
that you want to remotely debug.

```
oc set env dc/inventory JAVA_DEBUG=true
```{{execute T2}}

The Inventory pod will get restarted in debug mode. Since a pod is not directly accessible to 
a remote debugger, run the following command to forward the local port 5005 to the Inventory 
pod on port 5005. The the remote debugger can the connect to a local port and be redirected 
to the Inventory pod.

First, find the name of the Inventory pod.

```
oc get pod -l app=inventory
```{{execute T2}}

An then forward the local port using the following command. Replace the pod name with the 
Inventory pod name from the previous command.

```
oc port-forward --server https://master:8443 inventory-n-nnnn 5005 
```

You are all set now to start debugging using the tools of you choice. 

Remote debugging can be done using the prevalently available
Java Debugger command line or any modern IDE like JBoss 
Developer Studio (Eclipse) and IntelliJ IDEA.