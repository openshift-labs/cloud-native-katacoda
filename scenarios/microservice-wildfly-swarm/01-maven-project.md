The **inventory-wildfly-swarm** project shows the components of 
a WildFly Swarm project laid out in different subdirectories according to Maven best 
practices. Run the following command to examine the Maven project structure.

```tree```{{execute}}

This is a minimal Java EE project with support for JAX-RS for building 
RESTful services and JPA for connecting
to a database. [JAX-RS](https://docs.oracle.com/javaee/7/tutorial/jaxrs.htm) 
is one of Java EE standards that uses Java annotations 
to simplify the development of RESTful web services. [Java Persistence API (JPA)](https://docs.oracle.com/javaee/7/tutorial/partpersist.htm) is 
another Java EE standard that provides Java developers with an 
object/relational mapping facility for managing relational data in Java applications.

This project currently contains no code other than the main class for exposing a single 
RESTful application defined in **InventoryApplication.java**.