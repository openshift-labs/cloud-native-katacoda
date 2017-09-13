Remote debugging is a useful debugging technique for application development which allows 
looking into the code that is being executed somewhere else on a different machine and 
execute the code line-by-line to help investigate bugs and issues. Remote debugging is 
part of  Java SE standard debugging architecture which you can learn more about it in [Java SE docs](https://docs.oracle.com/javase/8/docs/technotes/guides/jpda/architecture.html).

The Java image on OpenShift has built-in support for remote debugging and it can be enabled 
by setting the **JAVA_DEBUG=true**environment variables on the deployment config for the pod 
that you want to remotely debug.

Enable remote debugging on the **inventory**deployment config:

`oc env dc/inventory -e JAVA_DEBUG=true`{{execute}}

The default port for remoting debugging is **5005**however you can change this port by setting 
the **JAVA_DEBUG_PORT**environment variable. You can read more about all the supported environment 
variables for changing the Java image behavior in the [Java S2I Image docs](https://access.redhat.com/documentation/en-us/red_hat_jboss_middleware_for_openshift/3/html/red_hat_java_s2i_for_openshift/reference#configuration_environment_variables).

As soon as you set the environment variable, a new Inventory pod gets started with the new 
configurations (environment variables).

You can now use the OpenShift CLI to forward a local port to the remote debugging port on the Inventory 
pod and treat it as if the JVM was running locally on your machine. Find out the name of the 
Inventory pod using **oc get**command:

> The **--show-all=false**option makes the OpenShift CLI to list only pods that are running excluding 
> pods that are stopped.

`oc get pods --show-all=false`{{execute}}

And forward a local port to the Inventory pod port **5005**

> The pod name would be different in your project. Replace **INVENTORY-POD-NAME**with 
> the pod name from your project.

`oc port-forward INVENTORY-POD-NAME 5005`

You are all set now to start debugging using the tools of you choice. 

Remote debugging can be done using the prevalently available
Java Debugger command line or any modern IDE like JBoss 
Developer Studio (Eclipse) and IntelliJ IDEA.