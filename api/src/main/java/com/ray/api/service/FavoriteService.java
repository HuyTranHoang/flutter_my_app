package com.ray.api.service;

import java.util.Map;

public interface FavoriteService {
    Map<String, Boolean> getFavoriteProduct(String username);
    Map<String, Boolean> save(Long productId, String username, boolean favorite);
}
