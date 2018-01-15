Let's create a [PostgreSQL database](https://docs.openshift.com/container-platform/3.7/using_images/db_images/postgresql.html) 
for the Inventory service using the PostgreSQL template that is provided out-of-the-box
```
oc new-app postgresql-persistent \
    --param=DATABASE_SERVICE_NAME=inventory-postgresql \
    --param=POSTGRESQL_DATABASE=inventory \
    --param=POSTGRESQL_USER=inventory \
    --param=POSTGRESQL_PASSWORD=inventory \
    --labels=app=inventory
```{{execute}}

The `--param` parameter provides a value for the template parameters. The recommended approach is 
not to provide any value for username and password and allow the template to generate a random value for 
you due to security reasons. In this scenario in order to reduce typos, a fixed value is provided for username and 
password.

Deploy another PostgreSQL database for the Catalog service:

```
oc new-app postgresql-persistent \
    --param=DATABASE_SERVICE_NAME=catalog-postgresql \
    --param=POSTGRESQL_DATABASE=catalog \
    --param=POSTGRESQL_USER=catalog \
    --param=POSTGRESQL_PASSWORD=catalog \
    --labels=app=catalog
```{{execute}}

Now you can move on to configure the Inventory and Catalog service to use these PostgreSQL databases.