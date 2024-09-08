package com.ray.api.entity;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Objects;

@Getter
@Setter
public class FavoriteId implements Serializable {
    private Long productId;
    private Long userId;

    public FavoriteId() {
    }

    public FavoriteId(Long productId, Long userId) {
        this.productId = productId;
        this.userId = userId;
    }

    @Override
    public String toString() {
        return "FavoriteId{" +
                "productId=" + productId +
                ", userId=" + userId +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        FavoriteId that = (FavoriteId) o;
        return productId.equals(that.productId) && userId.equals(that.userId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(productId, userId);
    }
}
