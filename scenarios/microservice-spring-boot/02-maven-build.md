You can use Maven to make sure the skeleton project builds successfully.

> Make sure to run the **package** Maven goal and not **install**. The latter would 
> download a lot more dependencies and do things you don't need yet!

```
mvn package
```{{execute}}

You should see a **BUILD SUCCESS** in the build logs.

Once built, the resulting **jar** is located in the **target/** directory:

```
ls target/*.jar
```{{execute}}

The listed jar archite, **catalog-1.0-SNAPSHOT.jar** is an uber-jar with all the dependencies required packaged in the **jar** to enable running the application with **java -jar**.

Now that the project is ready, let's get coding and create a domain model, data repository, and a  
RESTful endpoint to create the Catalog service:

![Catalog RESTful Service](https://katacoda.com/openshift-roadshow/assets/springboot-catalog-arch.png)
