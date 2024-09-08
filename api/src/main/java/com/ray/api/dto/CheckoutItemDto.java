package com.ray.api.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class CheckoutItemDto {
    private Long id;

    private String title;

    private String imageUrl;

    private BigDecimal unit;

    private int qty;
}
