package com.ray.api.constant;

public class SecurityConstant {
    public static final long EXPIRATION_TIME = 432000000;// 5 days in milliseconds
    public static final String TOKEN_PREFIX = "Bearer ";
    public static final String JWT_TOKEN_HEADER = "Jwt-Token";
    public static final String TOKEN_CANNOT_BE_VERIFIED = "Token cannot be verified";
    public static final String COMPANY = "Ray LTD";
    public static final String APPLICATION_NAME = "API for React - Basic";
    public static final String AUTHORITIES = "authorities";
    public static final String FORBIDDEN_MESSAGE = "You need to log in to access this page";
    public static final String ACCESS_DENIED_MESSAGE = "You do not have permission to access this page";
    public static final String OPTIONS_HTTP_METHOD = "OPTIONS"; // If it is option HTTP request then allow it
    public static final String[] PUBLIC_URLS = {"/h2-console/**", "/api/user/login", "/api/user/register", "/api/products/**", "/api/file/**", "/api/favorite/**"};
    public static final String[] PUBLIC_GET_URLS = {"/favicon.ico"};
}
