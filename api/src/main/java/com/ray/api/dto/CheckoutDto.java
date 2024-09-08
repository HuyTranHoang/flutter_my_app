package com.ray.api.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class CheckoutDto {
    private String name;

    private String address;

    private BigDecimal total;

    private List<CheckoutItemDto> items;
}
