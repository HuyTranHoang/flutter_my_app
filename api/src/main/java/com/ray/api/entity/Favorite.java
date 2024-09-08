package com.ray.api.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "user_favorite_product")
@Getter
@Setter
@IdClass(FavoriteId.class)
public class Favorite implements Serializable {

    @Id
    @Column(name = "user_id", insertable=false, updatable=false)
    private Long userId;

    @Id
    @Column(name = "product_id", insertable=false, updatable=false)
    private Long productId;

    @Column(name="is_favorite")
    private boolean isFavorite;

    public Favorite() {
    }

}
