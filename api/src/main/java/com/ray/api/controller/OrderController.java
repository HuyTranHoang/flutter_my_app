package com.ray.api.controller;

import com.ray.api.dao.OrderRepository;
import com.ray.api.entity.Orders;
import com.ray.api.entity.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/orders")
public class OrderController {
    private final OrderRepository orderRepository;

    @Autowired
    public OrderController(OrderRepository orderRepository) {
        this.orderRepository = orderRepository;
    }

    @GetMapping
    public ResponseEntity<Map<String, Object>> getAllOrders(@RequestParam(defaultValue = "0") int page,
                                                              @RequestParam(defaultValue = "1000") int size) {
        Pageable paging = PageRequest.of(page, size);
        Page<Orders> orders = orderRepository.findAll(paging);

        PageInfo myPage = new PageInfo(orders.getNumber(), orders.getTotalElements(), orders.getTotalPages(),orders.getSize());

        Map<String, Object> response = new HashMap<>();
        response.put("orders", orders.getContent());
        response.put("page", myPage);

        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @GetMapping("/user")
    public ResponseEntity<Map<String, Object>> getOrdersRestrictByUser(@RequestParam(defaultValue = "0") int page,
                                                                    @RequestParam(defaultValue = "1000") int size) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        Pageable paging = PageRequest.of(page, size);
        Page<Orders> orders = orderRepository.findOrdersByUser_Username(username, paging);

        PageInfo myPage = new PageInfo(orders.getNumber(), orders.getTotalElements(), orders.getTotalPages(),orders.getSize());

        Map<String, Object> response = new HashMap<>();
        response.put("orders", orders.getContent());
        response.put("page", myPage);

        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}
