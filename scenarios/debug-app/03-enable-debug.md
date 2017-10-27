Remote debugging is a useful debugging technique for application development which allows 
looking into the code that is being executed somewhere else on a different machine and 
execute the code line-by-line to help investigate bugs and issues. Remote debugging is 
part of  Java SE standard debugging architecture which you can learn more about it in [Java SE docs](https://docs.oracle.com/javase/8/docs/technotes/guides/jpda/architecture.html).


The Java image on OpenShift has built-in support for remote debugging and it can be enabled 
by setting the **JAVA_DEBUG=true** environment variables on the deployment config for the pod 
that you want to remotely debug.

An easier approach would be to use the fabric8 maven plugin to enable remote debugging on 
the Inventory pod. It also forwards the default remote debugging port, 5005, from the 
Inventory pod to your workstation so simplify connectivity.

Enable remote debugging on Inventory:

```
cd inventory-wildfly-swarm
```{{execute T1}}

```
mvn fabric8:debug
```{{execute T1}}

You are all set now to start debugging using the tools of you choice. 

Don't wait for the command to return! The fabric8 maven plugin keeps the forwarded 
port open so that you can start debugging remotely.

Remote debugging can be done using the prevalently available
Java Debugger command line or any modern IDE like JBoss 
Developer Studio (Eclipse) and IntelliJ IDEA.