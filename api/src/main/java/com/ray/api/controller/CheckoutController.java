package com.ray.api.controller;

import com.ray.api.dao.OrderRepository;
import com.ray.api.dao.UserRepository;
import com.ray.api.domain.User;
import com.ray.api.dto.CheckoutDto;
import com.ray.api.entity.OrderItem;
import com.ray.api.entity.Orders;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/checkout")
public class CheckoutController {
    private final OrderRepository orderRepository;
    private final UserRepository userRepository;

    @Autowired
    public CheckoutController(OrderRepository orderRepository, UserRepository userRepository) {
        this.orderRepository = orderRepository;
        this.userRepository = userRepository;
    }

    @PostMapping
    public Object checkout(@RequestBody CheckoutDto checkoutDto) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findUserByUsername(username);

        UUID uuid = UUID.randomUUID();

        Orders orders = new Orders(
                checkoutDto.getName(),
                checkoutDto.getAddress(),
                checkoutDto.getTotal(),
                uuid.toString());
        orders.setUser(user);

        Set<OrderItem> orderItemList =
                checkoutDto.getItems().stream().map(item -> new OrderItem(item.getTitle(), item.getImageUrl(), item.getUnit(), item.getQty(), item.getId(), orders)).collect(Collectors.toSet());

        orders.setOrderItems(orderItemList);
        Orders returnOrder = orderRepository.save(orders);

        Map<String, Object> response = new HashMap<>();
        response.put("orderTrackingNumber", returnOrder.getOrderTrackingNumber());
        response.put("dateCreated", returnOrder.getDateCreated());
        
        return response;
    }
}
