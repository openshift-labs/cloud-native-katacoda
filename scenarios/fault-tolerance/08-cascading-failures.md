In this scenario so far you have been looking how to make sure the application pod is running, can scale to accommodate
user load and recovers from failures. However failures also happen in the downstream services that an application
is dependent on. It's not uncommon that the whole application fails or slows down because one of the downstream
services consumed by the application is not responsive or responds slowly.

[Circuit Breaker](https://martinfowler.com/bliki/CircuitBreaker.html) is a pattern to address this issue and while
became popular with microservice architecture, it's a useful pattern for all applications that depend on other
services.

The idea behind the circuit breaker is that you wrap the API calls to downstream services in a circuit breaker
object, which monitors for failures. Once the service invocation fails certain number of times, the circuit
breaker flips open, and all further calls to the circuit breaker return with an error or a fallback logic
without making the call to the unresponsive API. After a certain period, the circuit breaker allows for a call
to the downstream service to test the waters. If the call is successful, the circuit breaker closes and would call
the downstream service on consequent calls.

![Circuit Breaker](https://katacoda.com/openshift-roadshow/assets/fault-circuit-breaker.png)

Spring Boot and WildFly Swarm provide convenient integration with [Hystrix](https://github.com/Netflix/Hystrix)
which is a framework that provides circuit breaker functionality. Eclipse Vert.x, in addition to integration
with Hystrix, provides built-in support for circuit breakers.
