In this scenario you will learn about Eclipse Vert.x and how you can 
build microservices using reactive principles. During this scenario you will 
create a scalable API Gateway that aggregates Catalog and Inventory APIs.

## What is Eclipse Vert.x?

[Eclipse Vert.x](http://vertx.io) is a toolkit for building reactive applications on the Java Virtual Machine (JVM). Vert.x does not 
impose a specific framework or packaging model and can be used within your existing applications and frameworks 
in order to add reactive functionality by just adding the Vert.x jar files to the application classpath.

Vert.x enables building reactive systems as defined by [The Reactive Manifesto](http://www.reactivemanifesto.org) and build 
services that are:

* *Responsive*: to handle requests in a reasonable time
* *Resilient*: to stay responsive in the face of failures
* *Elastic*: to stay responsive under various loads and be able to scale up and down
* *Message driven*: components interact using asynchronous message-passing

Vert.x is designed to be event-driven and non-blocking. Events are delivered in an event loop that must never be blocked. Unlike traditional applications, Vert.x uses a very small number of threads responsible for dispatching the events to event handlers. If the event loop is blocked, the events won’t be delivered anymore and therefore the code needs to be mindful of this execution model.