WildFly Swarm supports multiple mechanisms for externalizing configurations such as environment variables, 
Maven properties, command-line arguments and more. The recommend approach for the long-term for externalizing 
configuration is however using a [YAML file](https://reference.wildfly-swarm.io/configuration.html#_using_yaml) 
which you have already packaged within the Inventory Maven project.

The YAML file can be packaged within the application JAR file and be overladed 
[using command-line or system properties](https://wildfly-swarm.gitbooks.io/wildfly-swarm-users-guide/configuration/project_stages.html#_command_line_switches_system_properties) which you will do in this scenario.

Check out `project-stages.yml` in Inventory Maven project which contains the default configuration:

```
cat inventory-wildfly-swarm/src/main/resources/project-stages.yml
```{{execute}}

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

The hostname defined for the PostgreSQL connection-url corresponds to the PostgreSQL 
service name published on OpenShift. This name will be resolved by the internal DNS server 
exposed by OpenShift and accessible to containers running on OpenShift.

And then create a config map that you will use to overlay on the default `project-stages.yml` which is 
packaged in the Inventory JAR archive:

```
oc create configmap inventory \
   --from-file=./project-stages.yml
```{{execute}}

Config maps hold key-value pairs and in the above command an `inventory` config map 
is created with `project-stages.yml` as the key and the content of the `project-stages.yml` as the 
value. Whenever a config map is injected into a container, it would appear as a file with the same 
name as the key, at path on the filesystem.

You can see the content of the config map in the OpenShift Web Console or via CLI:
```
oc describe cm inventory
```{{execute}}