Spring Data repository abstraction simplifies dealing with data models in Spring applications by 
reducing the amount of boilerplate code required to implement data access layers for various 
persistence stores. [Repository and its sub-interfaces](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#repositories.core-concepts) 
are the central concept in Spring Data which is a marker interface to provide 
data manipulation functionality for the entity class that is being managed. When the application starts, 
Spring finds all interfaces marked as repositories and for each interface found, the infrastructure 
configures the required persistent technologies and provides an implementation for the repository interface.

Create a new Java interface named **ProductRepository.java**in **com.redhat.cloudnative.catalog**package 
and extend **CrudRepository**interface in order to indicate to Spring that you want to expose a 
complete set of methods to manipulate the entity.

<pre class="file" data-filename="./catalog-spring-boot/src/main/java/com/redhat/cloudnative/catalog/ProductRepository.java" data-target="replace">
package com.redhat.cloudnative.catalog;

import org.springframework.data.repository.CrudRepository;

public interface ProductRepository extends CrudRepository<Product, String> {
}
</pre>

Build and package the Catalog service using Maven to make sure there are no compilation errors:

`mvn clean package`{{execute}}

That's it! Now that you have a domain model and a repository to retrieve the domain mode, let's create a 
RESTful service that returns the list of products.