package com.ray.api.controller;

import com.ray.api.domain.HttpResponse;
import com.ray.api.entity.Favorite;
import com.ray.api.service.FavoriteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/favorite")
public class FavoriteController {
    private FavoriteService favoriteService;

    @Autowired
    public FavoriteController(FavoriteService favoriteService) {
        this.favoriteService = favoriteService;
    }

    @GetMapping()
    public ResponseEntity<Map<String, Boolean>> getUserFavoriteProduct() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        Map<String, Boolean> userFavoriteProduct = favoriteService.getFavoriteProduct(username);
        return new ResponseEntity<>(userFavoriteProduct, HttpStatus.OK);
    }

    @PostMapping()
    public ResponseEntity<Map<String, Boolean>> updateFavorite(@RequestBody Favorite favorite) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        Map<String, Boolean> response = favoriteService.save(favorite.getProductId(), username, favorite.isFavorite());
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    private ResponseEntity<HttpResponse> response(HttpStatus httpStatus, String message) {
        return new ResponseEntity<>(new HttpResponse(httpStatus.value(), httpStatus, httpStatus.getReasonPhrase(), message), httpStatus);
    }
}
