Applications capacity for serving clients is bounded by the amount of computing power 
allocated to them and although it's possible to increase the computing power per instance, 
it's far easier to keep the application instances within reasonable sizes and 
instead add more instances to increase serving capacity. Traditionally, due to 
the stateful nature of most monolithic applications, increasing capacity had been achieved 
via scaling up the application server and the underlying virtual or physical machine by adding 
more cpu and memory (vertical scaling). Cloud-native apps however are stateless and can be 
easily scaled up by spinning up more application instances and load-balancing requests 
between those instances (horizontal scaling).

![Scaling Up vs Scaling Out](https://katacoda.com/openshift-roadshow/assets/fault-scale-up-vs-out.png)

In previous scenarios, you learned how to build container images from your application code and 
deploy them on OpenShift. Container images on OpenShift follow the 
[immutable server](https://martinfowler.com/bliki/ImmutableServer.html) pattern which guarantees 
your application instances will always starts from a known well-configured state and makes 
deploying instances a repeatable practice. Immutable server pattern simplifies scaling out 
application instances to starting a new instance which is guaranteed to be identical to the 
existing instances and adding it to the load-balancer.