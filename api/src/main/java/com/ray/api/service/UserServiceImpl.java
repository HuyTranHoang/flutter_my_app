package com.ray.api.service;

import com.ray.api.dao.RoleRepository;
import com.ray.api.dao.UserRepository;
import com.ray.api.domain.User;
import com.ray.api.domain.UserPrincipal;
import com.ray.api.exception.EmailExistException;
import com.ray.api.exception.UserNotFoundException;
import com.ray.api.exception.UsernameExistException;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Arrays;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
@Transactional
@Qualifier("myUserDetailsService")
public class UserServiceImpl implements UserService, UserDetailsService {
    private final Logger LOGGER = LoggerFactory.getLogger(UserServiceImpl.class);
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;

    public UserServiceImpl(UserRepository userRepository, RoleRepository roleRepository, BCryptPasswordEncoder bCryptPasswordEncoder) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.bCryptPasswordEncoder = bCryptPasswordEncoder;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findUserByUsername(username);

        if (user == null) {
            LOGGER.error("User not found by username: " + username);
            throw  new UsernameNotFoundException("User not found by username: " + username);
        } else {
            UserPrincipal userPrincipal = new UserPrincipal(user);
            return userPrincipal;
        }
    }

    @Override
    public User register(String email, String password) throws UserNotFoundException, EmailExistException, UsernameExistException {
        /// username = email;
        validateNewUsernameAndEmail(StringUtils.EMPTY, email, email);
        String encodedPassword = bCryptPasswordEncoder.encode(password);

        User user = new User();
        user.setUsername(email);
        user.setEmail(email);
        user.setPassword(encodedPassword);
        user.setRoles(Stream.of(roleRepository.findByName("USER")).collect(Collectors.toSet()));

        userRepository.save(user);
//        LOGGER.info("New user password: " + password);
        return user;
    }

    @Override
    public User findUserByUsername(String username) {
        return userRepository.findUserByUsername(username);
    }

    @Override
    public User findUserByEmail(String username) {
        return userRepository.findUserByEmail(username);
    }

    @Override
    public User addNewUser(String username, String email, String[] role) throws UserNotFoundException, EmailExistException, UsernameExistException {
        validateNewUsernameAndEmail(StringUtils.EMPTY, username, email);
        String password = RandomStringUtils.randomAlphanumeric(10);
        String encodedPassword = bCryptPasswordEncoder.encode(password);

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(encodedPassword);
        user.setRoles(Arrays.stream(role).map(roleRepository::findByName).collect(Collectors.toSet()));

        userRepository.save(user);
        LOGGER.info("New user password: " + password);
        return user;
    }

    @Override
    public User updateUser(String currentUsername, String newUsername, String newEmail, String[] role) throws UserNotFoundException, EmailExistException, UsernameExistException {
        User currentUser = validateNewUsernameAndEmail(currentUsername, newUsername, newEmail);

        currentUser.setUsername(newUsername);
        currentUser.setEmail(newEmail);
        currentUser.setRoles(Arrays.stream(role).map(r -> roleRepository.findByName(r)).collect(Collectors.toSet()));

        userRepository.save(currentUser);
        return currentUser;
    }

    @Override
    public User updatePassword(String newPassword) {
        String currentPrincipalName = SecurityContextHolder.getContext().getAuthentication().getName();
        User currentUser = userRepository.findUserByUsername(currentPrincipalName);

        String encodedPassword = bCryptPasswordEncoder.encode(newPassword);
        currentUser.setPassword(encodedPassword);
        userRepository.save(currentUser);

        LOGGER.info("New user password: " + newPassword);
        return currentUser;
    }

    @Override
    public void deleteUser(long id) {
        userRepository.deleteById(id);
    }


    private User validateNewUsernameAndEmail(String currentUsername, String newUsername, String newEmail)
            throws UserNotFoundException, UsernameExistException, EmailExistException {
        User newUserByUsername = userRepository.findUserByUsername(newUsername);
        User newUserByEmail = userRepository.findUserByEmail(newEmail);

        if (StringUtils.isNotBlank(currentUsername)) {
            User currentUser = userRepository.findUserByUsername(currentUsername);
            if (currentUser == null) {
                throw new UserNotFoundException("No user found by username " + currentUsername);
            }

            if (newUserByUsername != null && !currentUser.getId().equals(newUserByUsername.getId())) {
                throw new UsernameExistException("Username already exists");
            }

            if (newUserByEmail != null && !currentUser.getId().equals(newUserByEmail.getId())) {
                throw new EmailExistException("Email has been registered for other user");
            }
            return currentUser;
        } else {
            if (newUserByUsername != null) {
                throw new UsernameExistException("Username already exists");
            }

            if (newUserByEmail != null) {
                throw new EmailExistException("Email has been registered for other user");
            }
            return null;
        }
    }
}
