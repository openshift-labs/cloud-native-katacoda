So far Catalog and Inventory services have been using an in-memory H2 database. Although H2 
is a convenient database to run locally on your laptop, it's in no ways appropriate for production or 
even integration tests. Since it's strongly recommended to use the same technology stack (operating 
system, JVM, middleware, database, etc) that is used in production across all environments, you 
should modify Inventory and Catalog services to use PostgreSQL instead of the H2 in-memory database.

Fortunately, OpenShift supports stateful applications such as databases which required access to 
a persistent storage that survives the container itself. You can deploy databases on OpenShift and 
regardless of what happens to the container itself, the data is safe and can be used by the next 
database container.

In this scenario you will deploy 2 PostgreSQL databases for the Catalog and Inventory services 
using the templates. [OpenShift Templates](https://docs.openshift.com/container-platform/3.7/dev_guide/templates.html) 
use YAML/JSON to compose multiple containers and their configurations as a list of objects to 
be created and deployed at once hence making it simple to re-create complex deployments by just 
deploying a single template. Templates can be parameterized to get input for fields like service 
names and generate values for fields like passwords.
