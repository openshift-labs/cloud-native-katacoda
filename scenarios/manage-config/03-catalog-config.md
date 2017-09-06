You should be quite familiar with config maps by now. Spring Boot application configuration is provided 
via a properties filed called `application.properties` and can be 
[overriden and overlayed via multiple mechanisms](https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-external-config.html). 

> Check out the default Spring Boot configuration in Catalog Maven project `catalog-spring-boot/src/main/resources/application.properties`.

In this lab, you will configure the Catalog service which is based on Spring Boot to override the default 
configuration using an alternative `application.properties` backed by a config map.

Create a config map with the the Spring Boot configuration content using the PostgreSQL database 
credentials:

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

`oc create configmap catalog --from-file=./application.properties`{{execute}}

> You can use the OpenShift Web Console to create config maps by clicking on **Resources >> Config Maps** 
> on the left sidebar inside the your project. Click on **Create Config Map** button to create a config map 
> with the following info:
> 
> * Name: `catalog`
> * Key: `application.properties`
> * Value: *copy-paste the content of the above application.properties excluding the first and last lines (the lines that contain EOF)*

The [Spring Cloud Kubernetes](https://github.com/spring-cloud-incubator/spring-cloud-kubernetes) plug-in implements 
the integration between Kubernetes and Spring Boot and is already added as a dependency to the Catalog Maven 
project. Using this dependency, Spring Boot would search for a config map (by default with the same name as 
the application) to use as the source of application configurations during application bootstrapping and 
if enabled, triggers hot reloading of beans or Spring context when changes are detected on the config map.

Although Spring Cloud Kubernetes tries to discover config maps, due to security reasons containers 
by default are not allowed to snoop around OpenShift clusters and discover objects. Security comes first, 
and discovery is a privilege that needs to be granted to containers in each project. 

Since you do want Spring Boot to discover the config maps inside the `coolstore` project, you 
need to grant permission to the Spring Boot service account to access the OpenShift REST API and find the 
config maps. However you have done this already in previous labs and no need to grant permission again. 

> For the record, you can grant permission to the default service account in your project using this 
command: 
> 
>     oc policy add-role-to-user view -n coolstore -z default

Delete the Catalog container to make it start again and look for the config maps:

`oc delete pod -l app=catalog`{{execute}}

When the Catalog container is ready, verify that the PostgreSQL database is being used:

`oc logs dc/catalog | grep hibernate.dialect`{{execute}}

You would see the `PostgreSQL94Dialect` is selected by Hibernate in the logs:

```
2017-08-10 21:07:51.670  INFO 1 --- [           main] org.hibernate.dialect.Dialect            : HHH000400: Using dialect: org.hibernate.dialect.PostgreSQL94Dialect
```

You can also connect to the Catalog PostgreSQL database and verify that the seed data is loaded:

`oc rsh dc/catalog-postgresql`{{execute}}

Once connected to the PostgreSQL container, run the following:

> Run this command inside the Catalog PostgreSQL container, after opening a remote shell to it.

`psql -U catalog -c "select item_id, name, price from product"`{{execute}}

You should see the seed data gets listed.

```
 item_id |            name             | price
----------------------------------------------
 329299  | Red Fedora                  | 34.99
 329199  | Forge Laptop Sticker        |   8.5
 165613  | Solid Performance Polo      |  17.8
 165614  | Ogio Caliber Polo           | 28.75
 165954  | 16 oz. Vortex Tumbler       |     6
 444434  | Pebble Smart Watch          |    24
 444435  | Oculus Rift                 |   106
 444436  | Lytro Camera                |  44.3
(8 rows)
```

Exit the container shell.

`exit`{{execute}}
