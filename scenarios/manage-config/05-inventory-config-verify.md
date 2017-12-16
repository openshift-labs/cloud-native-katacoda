When the Inventory pod is ready, verify that the config map is in fact injected 
into the container by running a shell command inside the Inventory container:

```
oc --server https://master:8443 rsh dc/inventory cat /app/config/project-stages.yml
```{{execute}}

Also verify that the PostgreSQL database is actually used by the Inventory service. Check the 
Inventory pod logs:

```
oc logs dc/inventory | grep hibernate.dialect
```{{execute}}

You would see the **PostgreSQL94Dialect** is selected by Hibernate in the logs:

```
2017-08-10 16:55:44,657 INFO  [org.hibernate.dialect.Dialect] (ServerService Thread Pool -- 15) HHH000400: Using dialect: org.hibernate.dialect.PostgreSQL94Dialect
```

You can also connect to Inventory PostgreSQL database and check if the seed data is 
loaded into the database:

```
oc --server https://master:8443 rsh dc/inventory-postgresql
```{{execute}}

Once connected to the PostgreSQL container, run the following inside the 
Inventory PostgreSQL container:

```
psql -U inventory -c "select * from inventory"
```{{execute}}

You should see the seed data gets listed.

```
 itemid | quantity
------------------
 329299 |       35
 329199 |       12
 ...
```

Exit the container shell.

```
exit
```{{execute}}

You have now created a config map that holds the configuration content for Inventory and can be updated 
at anytime for example when promoting the container image between environments without needing to 
modify the Inventory container image itself. 