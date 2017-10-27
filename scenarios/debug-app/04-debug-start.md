The [Java Debugger (JDB)](http://docs.oracle.com/javase/8/docs/technotes/tools/windows/jdb.html) 
is a simple command-line debugger for Java. The `jdb` command is included by default in 
Java SE and provides inspection and debugging of a local or remote JVM. Although JDB is not 
the most convenient way to debug Java code, it's a handy tool since it can be run on any environment 
that Java SE is available. 

The instructions in this section focuses on using JDB however if you are familiar with JBoss Developer 
Studio, Eclipse or IntelliJ you can use them for remote debugging.

Go to the **inventory-wildfly-swarm** folder in a new terminal window
and start JDB by pointing at the folder containing the Java source code for the application under debug:

```
cd inventory-wildfly-swarm
```{{execute T2}}

```
jdb -attach localhost:5005 -sourcepath :src/main/java/
```{{execute T2}}

Now that you are connected to the JVM running inside the Inventory pod on OpenShift, add 
a breakpoint to pause the code execution when it reaches the Java method handling the 
REST API `/api/inventory` Review the `InventoryResource.java` class and note that the 
`getAvailability()` is the method where you should add the breakpoint.

Add a breakpoint:

```
stop in com.redhat.cloudnative.inventory.InventoryResource.getAvailability
```{{execute T2}}