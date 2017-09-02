In this lab you will learn about building microservices using a subset of Java EE 
technologies which are driven via the MicroProfile standard. Furthermore you will create a 
microservice called Inventory using WildFly Swarm to expose a REST API for 
checking product inventory status.

## What is WildFly Swarm?

Java EE applications are traditionally created as an `ear` or `war` archive including all 
dependencies and deployed in an application server. Multiple Java EE applications can and 
were typically deployed in the same application server. This model is well understood in 
the development teams and has been used over the past several years.

WildFly Swarm offers an innovative approach to packaging and running Java EE applications by 
packaging them with just enough of the Java EE server runtime to be able to run them directly 
on the JVM using `java -jar`. For more details on various approaches to packaging Java 
applications, read [this blog post](https://developers.redhat.com/blog/2017/08/24/the-skinny-on-fat-thin-hollow-and-uber).

WildFly Swarm is based on WildFly and it's compatible with 
MicroProfile, which is a community effort to standardized the subset of Java EE standards 
such as JAX-RS, CDI and JSON-P that are useful for building microservices applications.

Since WildFly Swarm is based on Java EE standards, it significantly simplifies refactoring 
existing Java EE application to microservices and allows much of existing code-base to be 
reused in the new services.