The **catalog-spring-boot** project shows the components of 
a Spring Boot project laid out in different subdirectories according to Maven best 
practices. Run the following command to examine the Maven project structure.

```
tree
```{{execute}}

This is a minimal Spring Boot project with support for RESTful services and Spring Data with JPA for connecting
to a database. This project currently contains no code other than the main class, `CatalogApplication.java`
which is there to bootstrap the Spring Boot application.

Examine **CatalogApplication.java**

The database is configured using the Spring application configuration file which is located at 
**src/main/resources/application.properties**. Examine this file to see the database connection details 
and note that an in-memory H2 database is used in this scenario for local development and will be replaced
with a PostgreSQL database in the following scenarios. Be patient! More on that later.
