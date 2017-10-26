Create a new Java class named **Product.java** in 
**com.redhat.cloudnative.catalog** package with the following code:

<pre class="file" data-filename="./src/main/java/com/redhat/cloudnative/catalog/Product.java" data-target="replace">
package com.redhat.cloudnative.catalog;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

@Entity
@Table(name = "PRODUCT", uniqueConstraints = @UniqueConstraint(columnNames = "itemId"))
public class Product implements Serializable {

  @Id
  private String itemId;

  private String name;

  private String description;

  private double price;

  public Product() {
  }

  public String getItemId() {
    return itemId;
  }

  public void setItemId(String itemId) {
    this.itemId = itemId;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public double getPrice() {
    return price;
  }

  public void setPrice(double price) {
    this.price = price;
  }

  @Override
  public String toString() {
    return "Product [itemId=" + itemId + ", name=" + name + ", price=" + price + "]";
  }
}
</pre>

Review the **Product** domain model and note the JPA annotations on this class. **@Entity** marks the
class as a JPA entity, **@Table** customizes the table creation process by defining a table
name and database constraint and **@Id** marks the primary key for the table
