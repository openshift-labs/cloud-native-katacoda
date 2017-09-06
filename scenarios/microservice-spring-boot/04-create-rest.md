Spring Boot uses Spring Web MVC as the default RESTful stack in Spring applications. Create 
a new Java class named `CatalogController.java` in `com.redhat.cloudnative.catalog` package with 
the following content:

<pre class="file" data-filename="./catalog-spring-boot/src/main/java/com/redhat/cloudnative/catalog/CatalogController.java" data-target="replace">
package com.redhat.cloudnative.catalog;

import java.util.*;
import java.util.stream.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping(value = "/api/catalog")
public class CatalogController {
    @Autowired
    private ProductRepository repository;

    @ResponseBody
    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Product> getAll() {
        Spliterator<Product> products = repository.findAll().spliterator();
        return StreamSupport.stream(products, false).collect(Collectors.toList());
    }
}
</pre>

The above REST services defines an endpoint that is accessible via `HTTP GET` at `/api/catalog`. Notice 
the `repository` field on the controller class which is used to retrieve the list of products. Spring Boot 
automatically provides an implementation for `ProductRepository` at runtime and 
[it into the controller using the `@Autowire` annotation](https://docs.spring.io/spring-boot/docs/current/reference/html/using-boot-spring-beans-and-dependency-injection.html).

Build and package the Catalog service using Maven.

`mvn package`{{execute}}

You should see a `BUILD SUCCESS` in the build logs.

