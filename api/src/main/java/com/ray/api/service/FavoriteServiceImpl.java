package com.ray.api.service;

import com.ray.api.dao.FavoriteRepository;
import com.ray.api.dao.ProductRepository;
import com.ray.api.dao.UserRepository;
import com.ray.api.domain.User;
import com.ray.api.entity.Favorite;
import com.ray.api.entity.FavoriteId;
import com.ray.api.entity.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
public class FavoriteServiceImpl implements FavoriteService{
    private FavoriteRepository favoriteRepository;
    private UserRepository userRepository;
    private ProductRepository productRepository;

    @Autowired
    public FavoriteServiceImpl(FavoriteRepository favoriteRepository, UserRepository userRepository, ProductRepository productRepository) {
        this.favoriteRepository = favoriteRepository;
        this.userRepository = userRepository;
        this.productRepository = productRepository;
    }

    @Override
    @Transactional
    public Map<String, Boolean> getFavoriteProduct(String username) {
        User user = userRepository.findUserByUsername(username);
        List<Favorite> favoriteList = favoriteRepository.findByUserId(user.getId());
        Map<String, Boolean> response = new HashMap<>();
        for (Favorite favorite: favoriteList) {
            response.put(favorite.getProductId().toString(), favorite.isFavorite());
        }
        return response;
    }


    @Transactional //(propagation=Propagation.REQUIRES_NEW)
    void createNewFavorite(User user, Product product) {
        Set<Product> productSet = user.getProducts() == null ? new HashSet<>() : user.getProducts();
        productSet.add(product);
        user.setProducts(productSet);
        userRepository.save(user);
    }

    @Transactional //(propagation=Propagation.REQUIRES_NEW)
    Favorite updateFavoriteStatus(Long productId, Long userId, boolean favorite) {
        Favorite createdFavorite = favoriteRepository.getById(new FavoriteId(productId, userId));
        createdFavorite.setFavorite(favorite);
        return favoriteRepository.save(createdFavorite);
    }

    @Override
    public Map<String, Boolean> save(Long productId, String username, boolean favorite) {
        Product product = productRepository.getById(productId);
        User user = userRepository.findUserByUsername(username);

        boolean exist = favoriteRepository.existsById(new FavoriteId(productId, user.getId()));

        if (!exist) {
            createNewFavorite(user, product);
        }
        Favorite createdFavorite = updateFavoriteStatus(product.getId(), user.getId(), favorite);

        Map<String, Boolean> response = new HashMap<>();

        response.put(createdFavorite.getProductId().toString(), createdFavorite.isFavorite());
        return response;
    }

}
