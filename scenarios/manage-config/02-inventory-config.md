WildFly Swarm supports multiple mechanisms for externalizing configurations such as environment variables, 
Maven properties, command-line arguments and more. The recommend approach for the long-term for externalizing 
configuration is however using a [YAML file](https://reference.wildfly-swarm.io/configuration.html#_using_yaml) 
which you have already packaged within the Inventory Maven project.

The YAML file can be packaged within the application JAR file and be overladed 
[using command-line or system properties](https://wildfly-swarm.gitbooks.io/wildfly-swarm-users-guide/configuration/project_stages.html#_command_line_switches_system_properties) which you will do in this scenario.

> Check out **inventory-wildfly-swarm/src/main/resources/project-stages.yml** which contains the default configuration.

Create a YAML file with the PostgreSQL database credentials by clicking on *Copy to Editor*. 
Note that you can give an arbitrary name to this configuration 
(e.g. **prod** in order to tell WildFly Swarm which one to use:

<pre class="file" data-filename="./project-stages.yml" data-target="replace">
project:
  stage: prod
swarm:
  datasources:
    data-sources:
      InventoryDS:
        driver-name: postgresql
        connection-url: jdbc:postgresql://inventory-postgresql:5432/inventory
        user-name: inventory
        password: inventory
</pre>

> The hostname defined for the PostgreSQL connection-url corresponds to the PostgreSQL 
> service name published on OpenShift. This name will be resolved by the internal DNS server 
> exposed by OpenShift and accessible to containers running on OpenShift.

And then create a config map that you will use to overlay on the default **project-stages.yml** which is 
packaged in the Inventory JAR archive:

`oc create configmap inventory \
   --from-file=./project-stages.yml`{{execute}}

> If you don't like bash commands, Go to the **coolstore** 
> project in OpenShift Web Console and then on the left sidebar, **Resources &rarr; Config Maps**. Click 
> on **Create Config Map** button to create a config map with the following info:
> 
> * Name: **inventory**
> * Key: **project-stages.yml**
> * Value: *copy-paste the content of the above project-stages.yml*

Config maps hold key-value pairs and in the above command an **inventory** config map 
is created with **project-stages.yml** as the key and the content of the **project-stages.yml** as the 
value. Whenever a config map is injected into a container, it would appear as a file with the same 
name as the key, at path on the filesystem.

> You can see the content of the config map in the OpenShift Web Console or by 
> using **oc describe cm inventory** command.

Modify the Inventory deployment config so that it injects the YAML configuration you just created as 
a config map into the Inventory container:

`oc volume dc/inventory \
   --add \
   --configmap-name=inventory \
   --mount-path=/app/config`{{execute}}

The above command mounts the content of the **inventory** config map into the Inventory container 
at **/app/config/project-stages.yaml**

The last step is the [beforementioned system properties](https://wildfly-swarm.gitbooks.io/wildfly-swarm-users-guide/configuration/project_stages.html#_command_line_switches_system_properties) on the Inventory container to overlay the 
WildFly Swarm configuration, using the **JAVA_OPTIONS** environment variable. 

> The Java runtime on OpenShift can be configured using 
> [a set of environment variables](https://access.redhat.com/documentation/en-us/red_hat_jboss_middleware_for_openshift/3/html/red_hat_java_s2i_for_openshift/reference#configuration_environment_variables) 
> to tune the JVM without the need to rebuild a new Java runtime container image every time a new option is needed.

`oc set env dc/inventory \
   JAVA_OPTIONS="-Dswarm.project.stage=prod -Dswarm.project.stage.file=file:///app/config/project-stages.yml"`{{execute}}

The Inventory pod gets restarted automatically due to the configuration changes. Wait till it's ready, 
and then verify that the config map is in fact injected into the container by opening a remote shell into the 
Inventory container:

`oc rsh dc/inventory`{{execute}}

When connected to the container, check if the YAML file is there

> Run this command inside the Inventory container, after opening a remote shell to it.

`cat /app/config/project-stages.yml`{{execute}}

You would see the content of the config map that is mounted inside the container.

> You can run a command remotely on a container using **oc rsh**
> 
>     oc rsh dc/inventory cat /app/config/project-stages.yml

Also verify that the PostgreSQL database is actually used by the Inventory service. You 
can either check the Inventory pod logs:

`oc logs dc/inventory | grep hibernate.dialect`{{execute}}

You would see the **PostgreSQL94Dialect** is selected by Hibernate in the logs:

```
2017-08-10 16:55:44,657 INFO  [org.hibernate.dialect.Dialect] (ServerService Thread Pool -- 15) HHH000400: Using dialect: org.hibernate.dialect.PostgreSQL94Dialect
```

You can also connect to Inventory PostgreSQL database and check if the seed data is 
loaded into the database:

`oc rsh dc/inventory-postgresql`{{execute}}

Once connected to the PostgreSQL container, run the following:

> Run this command inside the Inventory PostgreSQL container, after opening a remote shell to it.

`psql -U inventory -c "select * from inventory"`{{execute}}

You should see the seed data gets listed.

```
 itemid | quantity
------------------
 329299 |       35
 329199 |       12
 165613 |       45
 165614 |       87
 165954 |       43
 444434 |       32
 444435 |       53
 444436 |       42
(8 rows)
```

Exit the container shell.

`exit`{{execute}}

You have now created a config map that holds the configuration content for Inventory and can be updated 
at anytime for example when promoting the container image between environments without needing to 
modify the Inventory container image itself. 