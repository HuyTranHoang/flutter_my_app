package com.ray.api.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.ray.api.entity.Orders;
import com.ray.api.entity.Product;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.Objects;
import java.util.Set;

@Entity
@Getter
@Setter
@Table(name = "user")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "username")
    private String username;

    // @JsonProperty(access = JsonProperty.Access.WRITE_ONLY) will hide when serializing and un-hide when de-serializing
    @Column(name = "password")
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;

    @Column(name = "email")
    private String email;

    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.DETACH, CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH })
    @JoinTable(name = "user_role",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "role_id"))
    private Set<Role> roles;

    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.DETACH, CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH })
    @JoinTable(name = "user_favorite_product",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "product_id"))
    @JsonIgnore
    private Set<Product> products;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private Set<Orders> orders;

    public User() {
    }

    public User(Long id, String username, String password, String email) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", email='" + email + '\'' +
                ", roles=" + roles +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return id.equals(user.id) && username.equals(user.username) && password.equals(user.password) && email.equals(user.email) && roles.equals(user.roles);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, username, password, email, roles);
    }
}
