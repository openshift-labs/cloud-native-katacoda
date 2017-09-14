Config map is a superb mechanism for externalizing application configuration while keeping 
containers independent of in which environment or on what container platform they are running. 
Nevertheless, due their clear-text nature, they are not suitable for sensitive data like 
database credentials, SSH certificates, etc. In the current scenario, we used config maps for database 
credentials to simplify the steps however for production environments, you should opt for a more 
secure way to handle sensitive data.

Fortunately, OpenShift already provides a secure mechanism for handling sensitive data which is 
called [Secrets](https://docs.openshift.com/container-platform/3.6/dev_guide/secrets.html). Secret objects act and are used 
similar to config maps however with the difference that they are encrypted as they travel over the wire 
and also at rest when kept on a persistent disk. Like config maps, secrets can be injected into 
containers a environment variables or files on the filesystem using a temporary file-storage 
facility (tmpfs).

You won't create any secrets in this scenario however you have already created 2 secrets when you created 
the PostgreSQL databases for Inventory and Catalog services. The PostgreSQL template by default stores 
the database credentials in a secret in the project it's being created:

`oc describe secret catalog-postgresql`{{execute}}

This secret has two encrypted properties defined as **database-user** and **database-password** which hold 
the PostgreSQL username and password values. These values are injected in the PostgreSQL container as 
environment variables and used to initialize the database.

Go to the **coolstore** in the OpenShift Web Console and click on the **catalog-postgresql**
deployment (blue text under the title **Deployment**) and then on the ** Environment**. Notice the values 
from the secret are defined as env vars on the deployment:

![Secrets as Env Vars](https://katacoda.com/openshift-roadshow/assets/config-psql-secret.png)

That's all for this scenario! You are ready to move on to the next scenario.