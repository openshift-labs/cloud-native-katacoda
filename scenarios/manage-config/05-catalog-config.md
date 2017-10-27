You should be quite familiar with config maps by now. Spring Boot application configuration is provided 
via a properties filed called `application.properties` and can be 
[overriden and overlayed via multiple mechanisms](https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-external-config.html). 

Check out the default Spring Boot configuration in Catalog Maven project `catalog-spring-boot/src/main/resources/application.properties`

In this scenario, you will configure the Catalog service which is based on Spring Boot to override the default 
configuration using an alternative `application.properties` backed by a config map.

Create a properties file with the Spring Boot configuration content using the PostgreSQL database 
credentials by clicking on *Copy to Editor*:

<pre class="file" data-filename="./application.properties" data-target="replace">
spring.datasource.url=jdbc:postgresql://catalog-postgresql:5432/catalog
spring.datasource.username=catalog
spring.datasource.password=catalog
spring.datasource.driver-class-name=org.postgresql.Driver
spring.jpa.hibernate.ddl-auto=create
</pre>

> The hostname defined for the PostgreSQL connection-url corresponds to the PostgreSQL 
service name published on OpenShift. This name will be resolved by the internal DNS server 
exposed by OpenShift and accessible to containers running on OpenShift.

```
oc create configmap catalog \
      --from-file=./application.properties
```{{execute}}

The [Spring Cloud Kubernetes](https://github.com/spring-cloud-incubator/spring-cloud-kubernetes) plug-in implements 
the integration between Kubernetes and Spring Boot and is already added as a dependency to the Catalog Maven 
project. Using this dependency, Spring Boot would search for a config map (by default with the same name as 
the application) to use as the source of application configurations during application bootstrapping and 
if enabled, triggers hot reloading of beans or Spring context when changes are detected on the config map.

Although Spring Cloud Kubernetes tries to discover config maps, due to security reasons containers 
by default are not allowed to snoop around OpenShift clusters and discover objects. Security comes first, 
and discovery is a privilege that needs to be granted to containers in each project. 

Since you do want Spring Boot to discover the config maps inside the **coolstore** project, you 
need to grant permission to the Spring Boot service account to access the OpenShift REST API and find the 
config maps. However you have done this already in previous scenarios using the 
`oc policy` command.

Delete the Catalog container to make it start again and look for the config maps:

```
oc delete pod -l deploymentconfig=catalog
```{{execute}}

The `-l deploymentconfig=catalog` means filter pods and only delete the ones that 
have the label `deploymentconfig` with the value `catalog`

Wait till the Catalog pod is ready before going to the next step.
