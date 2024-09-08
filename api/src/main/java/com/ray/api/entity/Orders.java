package com.ray.api.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.ray.api.domain.User;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Objects;
import java.util.Set;

@Entity
@Getter
@Setter
@Table(name="orders")
public class Orders {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="id")
    private Long id;

    @Column(name = "name")
    private String name;

    @Column(name = "address")
    private String address;

    @Column(name = "total")
    private BigDecimal total;

    @Column(name = "order_tracking_number")
    private String orderTrackingNumber;

    @Column(name = "date_created", updatable = false)
    @CreationTimestamp
    // Hibernate's @CreationTimestamp and @UpdateTimestamp annotations make it easy to track the timestamp of the creation and last update of an entity.
    // When a new entity gets persisted, Hibernate gets the current timestamp from the VM and sets it as the value of the attribute annotated with @CreationTimestamp.
    private Date dateCreated;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "orders")
    @JsonManagedReference
    private Set<OrderItem> orderItems;

    @ManyToOne
    @JoinColumn(name = "user_id")
    @JsonIgnore
    private User user;


    public Orders() {
    }

    public Orders(String name, String address, BigDecimal total, String orderTrackingNumber) {
        this.name = name;
        this.address = address;
        this.total = total;
        this.orderTrackingNumber = orderTrackingNumber;
    }

    @Override
    public String toString() {
        return "Orders{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", address='" + address + '\'' +
                ", total=" + total +
                ", orderTrackingNumber='" + orderTrackingNumber + '\'' +
                ", orderItems=" + orderItems +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Orders orders = (Orders) o;
        return id.equals(orders.id) && Objects.equals(orderTrackingNumber, orders.orderTrackingNumber);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, orderTrackingNumber);
    }
}
