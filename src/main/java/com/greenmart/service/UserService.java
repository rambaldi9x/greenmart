package com.greenmart.service;

import com.greenmart.entity.User;
import com.greenmart.repository.UserRepository;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class UserService {
    private UserRepository userRepository;

    public UserService() {
        this.userRepository = new UserRepository();
    }

    public User login(String email, String password) {
        if (email == null || password == null) return null;
        User user = userRepository.findByEmail(email.trim().toLowerCase());
        if (user != null && password.equals(user.getPassword())) {
            return user;
        }
        return null;
    }

    public User register(String email, String username, String password) {
        if (email == null || username == null || password == null) return null;
        String cleanEmail = email.trim().toLowerCase();
        User exists = userRepository.findByEmail(cleanEmail);
        if (exists != null) {
            return null; // email taken
        }
        User newUser = new User();
        newUser.setEmail(cleanEmail);
        newUser.setUsername(username.trim());
        newUser.setPassword(password);
        newUser.setRole("user");
        newUser.setCreatedAt(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        userRepository.save(newUser);
        return newUser;
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User getUserById(Long id) {
        return userRepository.findById(id);
    }

    public void deleteUser(Long id) {
        userRepository.delete(id);
    }
}