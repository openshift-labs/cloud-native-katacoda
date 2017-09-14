So far Catalog and Inventory services have been using an in-memory H2 database. Although H2 
is a convenient database to run locally on your laptop, it's in no ways appropriate for production or 
even integration tests. Since it's strongly recommended to use the same technology stack (operating 
system, JVM, middleware, database, etc) that is used in production across all environments, you 
should modify Inventory and Catalog services to use PostgreSQL instead of the H2 in-memory database.

Fortunately, OpenShfit supports stateful applications such as databases which required access to 
a persistent storage that survives the container itself. You can deploy databases on OpenShift and 
regardless of what happens to the container itself, the data is safe and can be used by the next 
database container.

Let's create a [PostgreSQL database](https://docs.openshift.com/container-platform/3.6/using_images/db_images/postgresql.html) 
for the Inventory service using the PostgreSQL template that is provided out-of-the-box:

> [OpenShift Templates](https://docs.openshift.com/container-platform/3.6/dev_guide/templates.html) uses YAML/JSON to compose 
> multiple containers and their configurations as a list of objects to be created and deployed at once hence 
> making it simple to re-create complex deployments by just deploying a single template. Templates can 
> be parameterized to get input for fields like service names and generate values for fields like passwords.

`oc new-app postgresql-persistent \
    --param=DATABASE_SERVICE_NAME=inventory-postgresql \
    --param=POSTGRESQL_DATABASE=inventory \
    --param=POSTGRESQL_USER=inventory \
    --param=POSTGRESQL_PASSWORD=inventory \
    --labels=app=coolstore,microservice=inventory`{{execute}}

> The **--param** parameter provides a value for the given parameters. The recommended approach is 
> not to provide any value for username and password and allow the template to generate a random value for 
> you due to security reasons. In this lab in order to reduce typos, a fixed value is provided for username and 
> password.

And another one for the Catalog service:

```
oc new-app postgresql-persistent \
    --param=DATABASE_SERVICE_NAME=catalog-postgresql \
    --param=POSTGRESQL_DATABASE=catalog \
    --param=POSTGRESQL_USER=catalog \
    --param=POSTGRESQL_PASSWORD=catalog \
    --labels=app=coolstore,microservice=catalog
```{{execute}}

Now you can move on to configure the Inventory and Catalog service to use these PostgreSQL databases.