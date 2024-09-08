package com.ray.api.dao;

import com.ray.api.entity.Favorite;
import com.ray.api.entity.FavoriteId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

public interface FavoriteRepository extends JpaRepository<Favorite, FavoriteId> {
    // http://localhost:8080/api/favorites/search/findByUserId?userId=1
    List<Favorite> findByUserId(@RequestParam("userId") Long userId);
}
