package com.ray.api.dto;

import lombok.Data;

import java.util.Set;

@Data
public class UserDto {
    private String currentUsername;
    private String username;
    private String email;
    private Set<String> roles;
    private String password;
}
