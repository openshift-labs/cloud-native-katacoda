The `catalog-spring-boot` project has the following structure which shows the components of 
the Spring Boot project laid out in different subdirectories according to Maven best practices:


Once loaded, you should see the following files and be able to navigate amongst the files. The 
components of the Spring Boot project are laid out in different subdirectories according to Maven best practices:

```
├── pom.xml            # The Maven project file
└── src
    └── main
        └── java       # The source code to the project
        └── resources  # The static resource files and configurations
```

This is a minimal Spring Boot project with support for RESTful services and Spring Data with JPA for connecting
to a database. This project currently contains no code other than the main class, `CatalogApplication.java`
which is there to bootstrap the Spring Boot application.

Examine `catalog-spring-boot/src/main/java/com/redhat/cloudnative/catalog/CatalogApplication.java`:

```java
package com.redhat.cloudnative.catalog;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CatalogApplication {

    public static void main(String[] args) {
        SpringApplication.run(CatalogApplication.class, args);
    }
}
```

The database is configured using the Spring application configuration file which is located at 
`src/main/resources/application.properties`. Examine this file to see the database connection details 
and note that an in-memory H2 database is used in this lab for local development and will be replaced
with a PostgreSQL database in the following labs. Be patient! More on that later.

You can use Maven to make sure the skeleton project builds successfully. You should get a `BUILD SUCCESS` message 
in the logs, otherwise the build has failed.

> Make sure to run the `package` Maven goal and not `install`. The latter would 
> download a lot more dependencies and do things you don't need yet!

`mvn package`{{execute}}

You should see a `BUILD SUCCESS` in the build logs.

```
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 2.282 s
[INFO] Finished at: 2017-07-25T13:55:16+07:00
[INFO] Final Memory: 35M/381M
[INFO] ------------------------------------------------------------------------
```

Once built, the resulting `jar` is located in the `target/` directory:

`ls target/*.jar`{{execute}}

The listed jar archite, `target/catalog-1.0-SNAPSHOT.jar`, is an uber-jar with all the dependencies required packaged in the `jar` to enable running the application with `java -jar`.

Now that the project is ready, let's get coding and create a domain model, data repository, and a  
RESTful endpoint to create the Catalog service:

![Catalog RESTful Service](../assets/springboot-catalog-arch.png)
