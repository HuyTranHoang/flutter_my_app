package com.ray.api.controller;

import com.ray.api.dao.UserRepository;
import com.ray.api.domain.HttpResponse;
import com.ray.api.domain.User;
import com.ray.api.domain.UserPrincipal;
import com.ray.api.dto.UserDto;
import com.ray.api.entity.PageInfo;
import com.ray.api.exception.EmailExistException;
import com.ray.api.exception.UserNotFoundException;
import com.ray.api.exception.UsernameExistException;
import com.ray.api.service.UserService;
import com.ray.api.utility.JWTTokenProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/user")
public class UserController {
    private final UserService userService;
    private final AuthenticationManager authenticationManager;
    private final JWTTokenProvider jwtTokenProvider;
    private final UserRepository userRepository;

    @Autowired
    public UserController(UserService userService, AuthenticationManager authenticationManager, JWTTokenProvider jwtTokenProvider, UserRepository userRepository) {
        this.userService = userService;
        this.authenticationManager = authenticationManager;
        this.jwtTokenProvider = jwtTokenProvider;
        this.userRepository = userRepository;
    }

    @PostMapping("/register")
    public ResponseEntity<User> register(@RequestBody User user) throws UserNotFoundException, EmailExistException, UsernameExistException {
        User newUser = userService.register(user.getEmail(), user.getPassword());
        return new ResponseEntity<>(newUser, HttpStatus.OK);
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody User user) {
        /**
         * authenticate the user, after authentication, the user information will be loaded into JWT token and return to user
         * in the following request, token will be verified and extracted information. The information will be loaded into SecurityContext
         */
        User loginUser = userService.findUserByEmail(user.getEmail());
        authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(loginUser.getUsername(), user.getPassword()));

        UserPrincipal userPrincipal = new UserPrincipal(loginUser);

        Map<String, Object> response = new HashMap<>();
        response.put("token", jwtTokenProvider.generateJwtToken(userPrincipal));
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/add")
    public ResponseEntity<User> addNewUser(@RequestBody UserDto user) throws UserNotFoundException, EmailExistException, UsernameExistException {
        User newUser = userService.addNewUser(user.getUsername(), user.getEmail(), user.getRoles().toArray(new String[0]));
        return new ResponseEntity<>(newUser, HttpStatus.OK);
    }

    @PostMapping("/update")
    public ResponseEntity<User> updateUser(@RequestBody UserDto user) throws UserNotFoundException, EmailExistException, UsernameExistException{
        User updatedUser = userService.updateUser(user.getCurrentUsername(), user.getUsername(), user.getEmail(), user.getRoles().toArray(new String[0]));
        return new ResponseEntity<>(updatedUser, HttpStatus.OK);
    }

    @PostMapping("/updatePassword")
    public ResponseEntity<User> updatePassword(@RequestBody UserDto user) {
        User updatedUser = userService.updatePassword(user.getPassword());
        return new ResponseEntity<>(updatedUser, HttpStatus.OK);
    }

    @GetMapping("/find/{username}")
    public ResponseEntity<User> getUser(@PathVariable("username") String username) {
        User user = userService.findUserByUsername(username);
        return new ResponseEntity<>(user, HttpStatus.OK);
    }

    @GetMapping("/list")
    public ResponseEntity<Map<String, Object>> getAllUsers(@RequestParam(defaultValue = "0") int page,
                                                           @RequestParam(defaultValue = "1000") int size) {
        Pageable paging = PageRequest.of(page, size);
        Page<User> users = userRepository.findAll(paging);

        PageInfo myPage = new PageInfo(users.getNumber(), users.getTotalElements(), users.getTotalPages(),users.getSize());

        Map<String, Object> response = new HashMap<>();
        response.put("users", users.getContent());
        response.put("page", myPage);

        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PreAuthorize("hasAnyAuthority('ADMIN')")
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<HttpResponse> deleteUser(@PathVariable("id") Long id) {
        userService.deleteUser(id);
        return response(HttpStatus.NO_CONTENT, "");
    }

    private ResponseEntity<HttpResponse> response(HttpStatus httpStatus, String message) {
        return new ResponseEntity<>(new HttpResponse(httpStatus.value(), httpStatus, httpStatus.getReasonPhrase(), message), httpStatus);
    }
}
