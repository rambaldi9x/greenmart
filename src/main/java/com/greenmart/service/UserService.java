package com.greenmart.service;

import com.greenmart.entity.User;
import com.greenmart.model.ServiceResult;
import com.greenmart.repository.UserRepository;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class UserService {
    private final UserRepository userRepository;

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

    public ServiceResult<User> registerUser(String email, String username, String password, String confirmPassword) {
        if (username == null || username.trim().isEmpty()) {
            return ServiceResult.error("Vui lòng nhập họ và tên!");
        }
        if (email == null || email.trim().isEmpty()) {
            return ServiceResult.error("Vui lòng nhập địa chỉ email!");
        }
        if (password == null || password.length() < 6) {
            return ServiceResult.error("Mật khẩu phải có ít nhất 6 ký tự!");
        }
        if (!password.equals(confirmPassword)) {
            return ServiceResult.error("Mật khẩu xác nhận không khớp!");
        }

        String cleanEmail = email.trim().toLowerCase();
        User exists = userRepository.findByEmail(cleanEmail);
        if (exists != null) {
            return ServiceResult.error("Email đã tồn tại trên hệ thống!");
        }

        User newUser = new User();
        newUser.setEmail(cleanEmail);
        newUser.setUsername(username.trim());
        newUser.setPassword(password);
        newUser.setRole("user");
        newUser.setCreatedAt(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        userRepository.save(newUser);
        return ServiceResult.ok(newUser, "Đăng ký tài khoản thành công!");
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User getUserById(Long id) {
        return userRepository.findById(id);
    }

    public void updateUser(User user) {
        userRepository.update(user);
    }

    public boolean updateProfile(Long userId, String username, String phone, String address) {
        if (userId == null) return false;
        User user = userRepository.findById(userId);
        if (user != null) {
            if (username != null && !username.trim().isEmpty()) {
                user.setUsername(username.trim());
            }
            user.setPhone(phone != null ? phone.trim() : null);
            user.setAddress(address != null ? address.trim() : null);
            userRepository.update(user);
            return true;
        }
        return false;
    }

    public ServiceResult<User> updateProfileWithValidation(Long userId, String username, String phone, String address) {
        if (userId == null) {
            return ServiceResult.error("Người dùng không hợp lệ!");
        }
        if (username == null || username.trim().isEmpty()) {
            return ServiceResult.error("Họ và tên không được để trống!");
        }

        User user = userRepository.findById(userId);
        if (user == null) {
            return ServiceResult.error("Không tìm thấy thông tin tài khoản!");
        }

        user.setUsername(username.trim());
        user.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
        user.setAddress(address != null && !address.trim().isEmpty() ? address.trim() : null);
        userRepository.update(user);
        return ServiceResult.ok(user, "Cập nhật thông tin cá nhân thành công!");
    }

    public boolean changePassword(Long userId, String oldPassword, String newPassword) {
        if (userId == null || oldPassword == null || newPassword == null) return false;
        User user = userRepository.findById(userId);
        if (user != null && oldPassword.equals(user.getPassword())) {
            user.setPassword(newPassword);
            userRepository.update(user);
            return true;
        }
        return false;
    }

    public ServiceResult<User> changePasswordWithValidation(Long userId, String oldPassword, String newPassword, String confirmPassword) {
        if (userId == null) {
            return ServiceResult.error("Người dùng không hợp lệ!");
        }
        User user = userRepository.findById(userId);
        if (user == null) {
            return ServiceResult.error("Không tìm thấy thông tin tài khoản!");
        }

        if (oldPassword == null || !oldPassword.equals(user.getPassword())) {
            return ServiceResult.error("Mật khẩu hiện tại không chính xác!");
        }
        if (newPassword == null || newPassword.length() < 6) {
            return ServiceResult.error("Mật khẩu mới phải có ít nhất 6 ký tự!");
        }
        if (!newPassword.equals(confirmPassword)) {
            return ServiceResult.error("Mật khẩu xác nhận không khớp!");
        }
        if (newPassword.equals(oldPassword)) {
            return ServiceResult.error("Mật khẩu mới không được trùng với mật khẩu hiện tại!");
        }

        user.setPassword(newPassword);
        userRepository.update(user);
        return ServiceResult.ok(user, "Đổi mật khẩu thành công!");
    }

    public void deleteUser(Long id) {
        userRepository.delete(id);
    }

    public boolean deleteUserSafe(Long targetId, Long currentUserId) {
        if (targetId == null) return false;
        if (currentUserId != null && targetId.equals(currentUserId)) {
            return false; // Cannot delete oneself
        }
        userRepository.delete(targetId);
        return true;
    }
}