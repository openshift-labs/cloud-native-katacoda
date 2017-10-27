The **gateway-vertx** project shows the components of 
a Vert.x project laid out in different subdirectories according to Maven best 
practices. Run the following command to examine the Maven project structure.

```
tree
```{{execute T1}}

This is a minimal Vert.x project with support for RESTful services. This project currently contains no code
other than the main class, **GatewayVerticle.java** which is there to bootstrap the Vert.x application. Verticles
are encapsulated parts of the application that can run completely independently and communicate with each other
via the built-in event bus in Vert.x. Verticles get deployed and run by Vert.x in an event loop and therefore it 
is important that the code in a Verticle does not block. This asynchronous architecture allows Vert.x applications 
to easily scale and handle large amounts of throughput with few threads.All API calls in Vert.x by default are non-blocking and support this concurrency model.

![Vert.x Event Loop](https://katacoda.com/openshift-roadshow/assets/vertx-event-loop.jpg)

Although you can have multiple, there is currently only one Verticle created in the **gateway-vertx** project. 

Examine **GatewayVerticle.java**. Here is what happens in this verticle:

1. A Verticle is created
2. **Router** is used for mapping the REST endpoints
3. A REST endpoint is created to return a static response
3. An HTTP Server is created to listen on port 8080