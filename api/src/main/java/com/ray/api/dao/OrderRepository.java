package com.ray.api.dao;

import com.ray.api.entity.Orders;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderRepository extends JpaRepository<Orders, Long> {
    Page<Orders> findAll(Pageable pageable);
    Page<Orders> findOrdersByUser_Username(String username, Pageable pageable);
}
