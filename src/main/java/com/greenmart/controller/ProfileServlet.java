package com.greenmart.controller;

import com.greenmart.entity.Order;
import com.greenmart.entity.User;
import com.greenmart.service.OrderService;
import com.greenmart.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile", "/user-profile", "/account"})
public class ProfileServlet extends HttpServlet {
    private UserService userService;
    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User sessionUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth?mode=login");
            return;
        }

        User freshUser = userService.getUserById(sessionUser.getId());
        if (freshUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=logout");
            return;
        }
        session.setAttribute("user", freshUser);

        List<Order> orders = orderService.getOrdersByUserId(freshUser.getId());
        double totalSpent = 0.0;
        int completedOrders = 0;
        for (Order o : orders) {
            if ("Completed".equalsIgnoreCase(o.getStatus()) || "Delivered".equalsIgnoreCase(o.getStatus())) {
                completedOrders++;
                if (o.getTotal() != null) {
                    totalSpent += o.getTotal();
                }
            }
        }

        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) {
            tab = "profile";
        }

        request.setAttribute("currentUser", freshUser);
        request.setAttribute("orders", orders);
        request.setAttribute("totalOrders", orders.size());
        request.setAttribute("completedOrders", completedOrders);
        request.setAttribute("totalSpent", totalSpent);
        request.setAttribute("activeTab", tab);

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User sessionUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth?mode=login");
            return;
        }

        User currentUser = userService.getUserById(sessionUser.getId());
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=logout");
            return;
        }

        String action = request.getParameter("action");

        if ("updateProfile".equalsIgnoreCase(action)) {
            String username = request.getParameter("username");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            if (username == null || username.trim().isEmpty()) {
                session.setAttribute("profileError", "Họ và tên không được để trống!");
                session.removeAttribute("profileSuccess");
            } else {
                boolean ok = userService.updateProfile(currentUser.getId(), username, phone, address);
                if (ok) {
                    User updatedUser = userService.getUserById(currentUser.getId());
                    session.setAttribute("user", updatedUser);
                    session.setAttribute("profileSuccess", "Cập nhật thông tin cá nhân thành công!");
                    session.removeAttribute("profileError");
                } else {
                    session.setAttribute("profileError", "Không thể cập nhật thông tin cá nhân. Vui lòng thử lại!");
                    session.removeAttribute("profileSuccess");
                }
            }
            response.sendRedirect(request.getContextPath() + "/profile?tab=profile");

        } else if ("changePassword".equalsIgnoreCase(action)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (oldPassword == null || !oldPassword.equals(currentUser.getPassword())) {
                session.setAttribute("profileError", "Mật khẩu hiện tại không chính xác!");
                session.removeAttribute("profileSuccess");
            } else if (newPassword == null || newPassword.length() < 6) {
                session.setAttribute("profileError", "Mật khẩu mới phải có ít nhất 6 ký tự!");
                session.removeAttribute("profileSuccess");
            } else if (!newPassword.equals(confirmPassword)) {
                session.setAttribute("profileError", "Mật khẩu xác nhận không khớp!");
                session.removeAttribute("profileSuccess");
            } else if (newPassword.equals(oldPassword)) {
                session.setAttribute("profileError", "Mật khẩu mới không được trùng với mật khẩu hiện tại!");
                session.removeAttribute("profileSuccess");
            } else {
                boolean ok = userService.changePassword(currentUser.getId(), oldPassword, newPassword);
                if (ok) {
                    User updatedUser = userService.getUserById(currentUser.getId());
                    session.setAttribute("user", updatedUser);
                    session.setAttribute("profileSuccess", "Đổi mật khẩu thành công!");
                    session.removeAttribute("profileError");
                } else {
                    session.setAttribute("profileError", "Không thể đổi mật khẩu. Vui lòng thử lại!");
                    session.removeAttribute("profileSuccess");
                }
            }
            response.sendRedirect(request.getContextPath() + "/profile?tab=password");

        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }
}
