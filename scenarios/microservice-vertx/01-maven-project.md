The **gateway-vertx** project shows the components of 
a Vert.x project laid out in different subdirectories according to Maven best 
practices. Run the following command to examine the Maven project structure.

`tree`{{execute T1}}

This is a minimal Vert.x project with support for RESTful services. This project currently contains no code
other than the main class, **GatewayVerticle.java** which is there to bootstrap the Vert.x application. Verticles
are encapsulated parts of the application that can run completely independently and communicate with each other
via the built-in event bus in Vert.x. Verticles get deployed and run by Vert.x in an event loop and therefore it 
is important that the code in a Verticle does not block. This asynchronous architecture allows Vert.x applications 
to easily scale and handle large amounts of throughput with few threads.All API calls in Vert.x by default are non-blocking and support this concurrency model.

![Vert.x Event Loop](https://katacoda.com/openshift-roadshow/assets/vertx-event-loop.jpg)

Although you can have multiple, there is currently only one Verticle created in the **gateway-vertx** project. 

Examine **GatewayVerticle.java**. Here is what happens in this verticle:

1. A Verticle is created by extending from **AbstractVerticle** class
2. **Router** is retrieved for mapping the REST endpoints
3. A REST endpoint is created for **/*** to return a static JSON response `{"message": "Hello World"}`
3. An HTTP Server is created which listens on port 8080

You can use Maven to make sure the skeleton project builds successfully. 

> Make sure to run the **package** Maven goal and not **install** The latter would 
> download a lot more dependencies and do things you don't need yet!

`mvn package`{{execute T1}}

You should see a **BUILD SUCCESS** in the logs.

Once built, the resulting *jar* is located in the **target/** directory:

`ls target/*.jar`{{execute T1}}

The listed jar archive, **gateway-1.0-SNAPSHOT.jar** is an uber-jar with all the 
dependencies required packaged in the *jar* to enable running the application with **java -jar**.

You can run the Vert.x application using **java -jar** or conveniently using **vertx:run** goal from 
the **vertx-maven-plugin**

`mvn vertx:run`{{execute T1}}

Verify the application is working using **curl** in a new terminal window:

`curl http://localhost:8080`{{execute T2}}

You should see a **{"message": "Hello World"}** JSON response.

Note that while the application is running using **mvn vertx:run** you can make changes in the code
and they would immediately be compiled and updated in the running application to provide the fast
feedback to the developer.

Now that the project is ready, let's get coding!
