package com.ray.api.config;

import com.ray.api.constant.SecurityConstant;
import com.ray.api.filter.JwtAccessDeniedHandler;
import com.ray.api.filter.JwtAuthenticationEntryPoint;
import com.ray.api.filter.JwtAuthorizationFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.Arrays;
import java.util.Collections;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfiguration extends WebSecurityConfigurerAdapter {
    private final JwtAuthorizationFilter jwtAuthorizationFilter;
    private final JwtAccessDeniedHandler jwtAccessDeniedHandler;
    private final JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;
    private final UserDetailsService userDetailsService;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;

    @Autowired
    public SecurityConfiguration(JwtAuthorizationFilter jwtAuthorizationFilter,
                                 JwtAccessDeniedHandler jwtAccessDeniedHandler,
                                 JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint,
                                 @Qualifier("myUserDetailsService")UserDetailsService userDetailsService,
                                 BCryptPasswordEncoder bCryptPasswordEncoder) {
        this.jwtAuthorizationFilter = jwtAuthorizationFilter;
        this.jwtAccessDeniedHandler = jwtAccessDeniedHandler;
        this.jwtAuthenticationEntryPoint = jwtAuthenticationEntryPoint;
        this.userDetailsService = userDetailsService;
        this.bCryptPasswordEncoder = bCryptPasswordEncoder;
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        // tells Spring Security to use our UserDetailService & BCryptor
        auth.userDetailsService(userDetailsService).passwordEncoder(bCryptPasswordEncoder);
    }

    // tell Spring to use which handler & config
    @Override
    protected void configure(HttpSecurity http) throws Exception {

        http
            .headers().frameOptions().sameOrigin() // this configuration is needed for H2 database
            .and()
                .csrf().disable() // csrf is used in SpringMVC
                .cors() // config cors here instead of controller level
            .and()
            // not keeping track of session, every session is new and must be checked.
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            .and()
                .authorizeRequests()
                // .anyRequest().permitAll();
                .antMatchers(SecurityConstant.PUBLIC_URLS).permitAll()
                .antMatchers(HttpMethod.GET, SecurityConstant.PUBLIC_GET_URLS).permitAll()
                // and other request will be checked
                .anyRequest().authenticated()
            .and()
                // configure Exception Handler for authenticating
                .exceptionHandling().accessDeniedHandler(jwtAccessDeniedHandler)
                .authenticationEntryPoint(jwtAuthenticationEntryPoint)
            .and()
                // set List<GrantedAuthority> to Security Context before the UsernamePasswordAuthenticationFilter
                // because the UsernamePasswordAuthenticationFilter if token is verified then we don't need to check username&password authentication
                .addFilterBefore(jwtAuthorizationFilter, UsernamePasswordAuthenticationFilter.class);
    }

    @Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

    @Bean
    public CorsFilter corsFilter() {
        UrlBasedCorsConfigurationSource urlBasedCorsConfigurationSource = new UrlBasedCorsConfigurationSource();
        CorsConfiguration corsConfiguration = new CorsConfiguration();
        corsConfiguration.setAllowCredentials(true);
//        corsConfiguration.setAllowedOrigins(Arrays.asList("http://localhost:59319/"));
        corsConfiguration.setAllowedOriginPatterns(Collections.singletonList("*"));
        corsConfiguration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS", "HEAD"));
        corsConfiguration.setAllowedHeaders(Arrays.asList("Origin", "Access-Control-Allow-Origin", "Content-Type",
                "Accept", "Jwt-Token", "Authorization", "Origin, Accept", "X-Requested-With",
                "Access-Control-Request-Method", "Access-Control-Request-Headers"));
        //, "authorization", "authentication", "content-type", "Jwt-Token"));
        corsConfiguration.setExposedHeaders(Arrays.asList("Origin", "Content-Type", "Accept", "Jwt-Token", "Authorization",
                "Access-Control-Allow-Origin", "Access-Control-Allow-Credentials"));
        //"Jwt-Token"
        urlBasedCorsConfigurationSource.registerCorsConfiguration("/**", corsConfiguration);
        return new CorsFilter(urlBasedCorsConfigurationSource);
    }
}
