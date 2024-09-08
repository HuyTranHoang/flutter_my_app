package com.ray.api.service;

import com.ray.api.domain.User;
import com.ray.api.exception.EmailExistException;
import com.ray.api.exception.UserNotFoundException;
import com.ray.api.exception.UsernameExistException;

public interface UserService {
    User register(String username, String email) throws UserNotFoundException, EmailExistException, UsernameExistException;

    User findUserByUsername(String username);
    User findUserByEmail(String email);

    User addNewUser(String username, String email, String[] role) throws UserNotFoundException, EmailExistException, UsernameExistException;

    User updateUser(String currentUsername, String newUsername, String newEmail, String[] role) throws UserNotFoundException, EmailExistException, UsernameExistException;

    User updatePassword(String newPassword);

    void deleteUser(long id);
}
