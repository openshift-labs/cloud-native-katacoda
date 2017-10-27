When the Catalog pod is ready, verify that the PostgreSQL database is being 
used. Check the Catalog pod logs:

```
oc logs dc/catalog | grep hibernate.dialect
```{{execute}}

You would see the **PostgreSQL94Dialect** is selected by Hibernate in the logs:

```
2017-08-10 21:07:51.670  INFO 1 --- [           main] org.hibernate.dialect.Dialect            : HHH000400: Using dialect: org.hibernate.dialect.PostgreSQL94Dialect
```

You can also connect to the Catalog PostgreSQL database and verify that the seed data is loaded:

```
oc rsh dc/catalog-postgresql
```{{execute}}

Once connected to the PostgreSQL container, run the following:

> Run this command inside the Catalog PostgreSQL container, after opening a remote shell to it.

```
psql -U catalog -c "select item_id, name, price from product"
```{{execute}}

You should see the seed data gets listed.

```
 item_id |            name             | price
----------------------------------------------
 329299  | Red Fedora                  | 34.99
 329199  | Forge Laptop Sticker        |   8.5
 ...
```

Exit the container shell.

```
exit
```{{execute}}
