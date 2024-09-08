package com.ray.api.controller;

import com.google.common.base.Strings;
import com.ray.api.dao.ProductRepository;
import com.ray.api.domain.HttpResponse;
import com.ray.api.entity.PageInfo;
import com.ray.api.entity.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@CrossOrigin("http://localhost:3000")
@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final ProductRepository productRepository;

    @Autowired
    public ProductController(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @GetMapping
    public ResponseEntity<Map<String, Object>> getAllProducts(@RequestParam(defaultValue = "0") int page,
                                                           @RequestParam(defaultValue = "1000") int size) {
        Pageable paging = PageRequest.of(page, size);
        Page<Product> products = productRepository.findAll(paging);

        PageInfo myPage = new PageInfo(products.getNumber(), products.getTotalElements(), products.getTotalPages(),products.getSize());

        Map<String, Object> response = new HashMap<>();
        response.put("products", products.getContent());
        response.put("page", myPage);

        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @GetMapping("/search/{category}")
    public ResponseEntity<Map<String, Object>> getAllProducts(@PathVariable("category") String category,
                                                              @RequestParam(defaultValue = "0") int page,
                                                              @RequestParam(defaultValue = "1000") int size) {
        Pageable paging = PageRequest.of(page, size);
        Page<Product> products = productRepository.findProductsByCategory(category, paging);

        PageInfo myPage = new PageInfo(products.getNumber(), products.getTotalElements(), products.getTotalPages(),products.getSize());

        Map<String, Object> response = new HashMap<>();
        response.put("products", products.getContent());
        response.put("page", myPage);

        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/add")
    public Product postProduct(@RequestBody Product product) {
        Product newProduct = new Product();
        newProduct.setTitle(product.getTitle());
        newProduct.setDescription(product.getDescription());
        newProduct.setDate(product.getDate());
        newProduct.setAmount(product.getAmount());
        newProduct.setCategory(!Strings.isNullOrEmpty(product.getCategory()) ? product.getCategory() : "U");
        newProduct.setImageUrl(!Strings.isNullOrEmpty(product.getImageUrl()) ? product.getImageUrl() : "http://localhost:8080/api/file/image/placeholder.png");
        return productRepository.save(newProduct);
    }

    @PostMapping("/update")
    public Product putProduct(@RequestBody Product product) {
        Product updatedProduct = productRepository.getById(product.getId());
        updatedProduct.setTitle(!Strings.isNullOrEmpty(product.getTitle()) ? product.getTitle() : updatedProduct.getTitle());
        updatedProduct.setDescription(product.getDescription());
        updatedProduct.setDate(product.getDate());
        updatedProduct.setAmount(product.getAmount() != null ? product.getAmount() : updatedProduct.getAmount());
        updatedProduct.setCategory(!Strings.isNullOrEmpty(product.getCategory()) ? product.getCategory() : updatedProduct.getCategory());
        updatedProduct.setImageUrl(!Strings.isNullOrEmpty(product.getImageUrl()) ? product.getImageUrl() : updatedProduct.getImageUrl());
        return productRepository.save(updatedProduct);
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<HttpResponse> deleteProduct(@PathVariable("id") Long id) {
        productRepository.deleteById(id);
        return response(HttpStatus.NO_CONTENT, "");
    }

    private ResponseEntity<HttpResponse> response(HttpStatus httpStatus, String message) {
        return new ResponseEntity<>(new HttpResponse(httpStatus.value(), httpStatus, httpStatus.getReasonPhrase(), message), httpStatus);
    }
}
