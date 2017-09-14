Create a new Java class named **Inventory.java** in 
**com.redhat.cloudnative.inventory** package with the following code.

<pre class="file" data-filename="./inventory-wildfly-swarm/src/main/java/com/redhat/cloudnative/inventory/Inventory.java" data-target="replace">
package com.redhat.cloudnative.inventory;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;
import java.io.Serializable;

@Entity
@Table(name = "INVENTORY", uniqueConstraints = @UniqueConstraint(columnNames = "itemId"))
public class Inventory implements Serializable {
	@Id
    private String itemId;

    private int quantity;

    public Inventory() {
    }

    public String getItemId() {
        return itemId;
    }

    public void setItemId(String itemId) {
        this.itemId = itemId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    @Override
    public String toString() {
        return "Inventory [itemId='" + itemId + '\'' + ", quantity=" + quantity + ']';
    }
}
</pre>

Review the **Inventory** domain model and note the JPA annotations on this class. **@Entity** marks 
the class as a JPA entity, **@Table** customizes the table creation process by defining a table 
name and database constraint and **@Id** marks the primary key for the table.

WildFly Swarm configuration is done to a large extend through detecting the intent of the 
developer and automatically adding the required dependencies configurations to make sure it can 
get out of the way and developers can be productive with their code rather than Googling for 
configuration snippets. As an example, configuration database access with JPA is composed of 
the following steps:

1. Add the **org.wildfly.swarm:jpa** dependency to **pom.xml** 
2. Add the database driver (e.g. **org.postgresql:postgresql**) to ** pom.xml**
3. Add database connection details in **src/main/resources/project-stages.yml**

Examine **pom.xml** and note the **org.wildfly.swarm:jpa** that is already added to enable JPA:

```xml
<dependency>
    <groupId>org.wildfly.swarm</groupId>
    <artifactId>jpa</artifactId>
</dependency>
```

Examine **src/main/resources/META-INF/persistence.xml** to see the JPA datasource configuration 
for this project. Also note that the configurations uses **META-INF/load.sql** to import 
initial data into the database.

Examine **src/main/resources/project-stages.yml** to see the database connection details. 
An in-memory H2 database is used in this scenario for local development and in the following 
labs will be replaced with a PostgreSQL database. Be patient! More on that later.

Build and package the Inventory service using Maven to make sure you code compiles:

`mvn package`{{execute}}

If builds successfully, continue to the next step to create a RESTful service.
