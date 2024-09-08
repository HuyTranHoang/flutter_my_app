package com.ray.api.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Objects;

@Entity
@Getter
@Setter
@Table(name="order_item")
public class OrderItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="id")
    private Long id;

    @Column(name = "title")
    private String title;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "unit")
    private BigDecimal unit;

    @Column(name = "quantity")
    private int quantity;

    @Column(name="product_id")
    private Long productId;

    @ManyToOne
    @JoinColumn(name = "order_id")
    @JsonBackReference
    private Orders orders;

    public OrderItem() {
    }

    public OrderItem(String title, String imageUrl, BigDecimal unit, int quantity, Long productId, Orders orders) {
        this.title = title;
        this.imageUrl = imageUrl;
        this.unit = unit;
        this.quantity = quantity;
        this.productId = productId;
        this.orders = orders;
    }

    @Override
    public String toString() {
        return "OrderItem{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                ", unit=" + unit +
                ", quantity=" + quantity +
                ", productId=" + productId +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        OrderItem orderItem = (OrderItem) o;
        return quantity == orderItem.quantity && id.equals(orderItem.id) && Objects.equals(title, orderItem.title) && Objects.equals(imageUrl, orderItem.imageUrl) && Objects.equals(unit, orderItem.unit) && Objects.equals(productId, orderItem.productId) && Objects.equals(orders, orderItem.orders);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, title, imageUrl, unit, quantity, productId, orders);
    }
}
