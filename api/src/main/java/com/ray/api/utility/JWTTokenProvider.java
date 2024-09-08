package com.ray.api.utility;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.ray.api.constant.SecurityConstant;
import com.ray.api.domain.UserPrincipal;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import static java.util.Arrays.stream;

@Component
public class JWTTokenProvider {
    @Value("${jwt.secret}")
    private String secret;

    public String generateJwtToken(UserPrincipal userPrincipal) {

        String[] claims = getClaimsFromUser(userPrincipal);

        return JWT.create()
                .withIssuer(SecurityConstant.COMPANY)
                .withAudience(SecurityConstant.APPLICATION_NAME)
                .withIssuedAt(new Date())
                .withSubject(userPrincipal.getUsername())
                .withArrayClaim(SecurityConstant.AUTHORITIES, claims)
                .withExpiresAt(new Date(System.currentTimeMillis() + SecurityConstant.EXPIRATION_TIME))
                .sign(Algorithm.HMAC512(secret.getBytes()));
    }

    public List<GrantedAuthority> getAuthoritiesFromToken(String token) {
        // create JWTVerifier to verify JWT token
        JWTVerifier verifier = getJwtVerifier();

        // get claims from token
        String[] claims = verifier.verify(token).getClaim(SecurityConstant.AUTHORITIES).asArray(String.class);

        // loop through claims from token and transform them to List<GrantedAuthority>
        return stream(claims).map(SimpleGrantedAuthority::new).collect(Collectors.toList());
    }

    private JWTVerifier getJwtVerifier() {
        // create JWTVerifier to verify JWT token
        JWTVerifier verifier;
        try {
            Algorithm algorithm = Algorithm.HMAC512(secret);
            verifier = JWT.require(algorithm).withIssuer(SecurityConstant.COMPANY).build();
        } catch (JWTVerificationException ex) {
            throw  new JWTVerificationException(SecurityConstant.TOKEN_CANNOT_BE_VERIFIED);
        }
        return verifier;
    }

    private String[] getClaimsFromUser(UserPrincipal userPrincipal) {
        List<String> authorities = new ArrayList<>();
        for (GrantedAuthority grantedAuthority : userPrincipal.getAuthorities()) {
            authorities.add(grantedAuthority.getAuthority());
        }
        return authorities.toArray(new String[0]);
    }


    // after validating JWT token, we tell Spring to give us the Authentication
    public Authentication getAuthentication(String username, List<GrantedAuthority> authorities, HttpServletRequest request) {
        UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken =
                new UsernamePasswordAuthenticationToken(username, null, authorities);

        usernamePasswordAuthenticationToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
        return usernamePasswordAuthenticationToken;
    }


    public boolean isTokenValid(String username, String token) {
        JWTVerifier verifier = getJwtVerifier();

        // check whether the token is expired
        Date expirationDate = verifier.verify(token).getExpiresAt();
        boolean isTokenExpired = expirationDate.before(new Date());

        // user StringUtils from org.apache.commons
        return StringUtils.isNotEmpty(username) && !isTokenExpired;
    }


    public String getSubject(String token) {
        JWTVerifier verifier = getJwtVerifier();
        return verifier.verify(token).getSubject();
    }
}
