Modify the Inventory deployment config so that it injects the YAML configuration you just created as 
a config map into the Inventory container:

```
oc volume dc/inventory \
   --add \
   --configmap-name=inventory \
   --mount-path=/app/config
```{{execute}}

The above command mounts the content of the `inventory` config map as a file inside the Inventory container 
at `/app/config/project-stages.yaml`

The last step is the [aforementioned system properties](https://wildfly-swarm.gitbooks.io/wildfly-swarm-users-guide/configuration/project_stages.html#_command_line_switches_system_properties) on the Inventory container to overlay the 
WildFly Swarm configuration, using the **JAVA_OPTIONS** environment variable. 

> The Java runtime on OpenShift can be configured using 
> [a set of environment variables](https://access.redhat.com/documentation/en-us/red_hat_jboss_middleware_for_openshift/3/html/red_hat_java_s2i_for_openshift/reference#configuration_environment_variables) 
> to tune the JVM without the need to rebuild a new Java runtime container image every time a new option is needed.

```
oc set env dc/inventory \
   JAVA_OPTIONS="-Dswarm.project.stage=prod -Dswarm.project.stage.file=file:///app/config/project-stages.yml"
```{{execute}}

The Inventory pod gets restarted automatically due to the configuration changes. Wait till it's ready 
before going to the next step.