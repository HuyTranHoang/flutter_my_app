package com.ray.api.entity;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Objects;

@Entity
@Getter
@Setter
@Table(name="product")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="id")
    private Long id;

    @Column(name = "title")
    @JsonProperty("name")
    private String title;

    @Column(name="description")
    private String description;

    @Column(name = "amount")
    @JsonProperty("unitPrice")
    private BigDecimal amount;

    @Column(name="date")
    private Date date;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "category")
    private String category;

//    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.DETACH, CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH })
//    @JoinTable(name = "user_favorite_product",
//            joinColumns = @JoinColumn(name = "product_id"),
//            inverseJoinColumns = @JoinColumn(name = "user_id"))
//    private Set<Product> products;

    public Product() {
    }

    public Product(Long id, String title, BigDecimal amount, Date date, String imageUrl, String category) {
        this.id = id;
        this.title = title;
        this.amount = amount;
        this.date = date;
        this.imageUrl = imageUrl;
        this.category = category;
    }

    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", amount=" + amount +
                ", date=" + date +
                ", imageUrl='" + imageUrl + '\'' +
                ", category='" + category + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Product product = (Product) o;
        return Objects.equals(id, product.id) && Objects.equals(title, product.title) && Objects.equals(amount, product.amount) && Objects.equals(date, product.date) && Objects.equals(imageUrl, product.imageUrl) && Objects.equals(category, product.category);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, title, amount, date, imageUrl, category);
    }
}
