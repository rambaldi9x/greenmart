package com.greenmart.controller;

import com.greenmart.entity.Order;
import com.greenmart.entity.User;
import com.greenmart.model.ServiceResult;
import com.greenmart.model.UserOrderStats;
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
        UserOrderStats stats = orderService.getUserOrderStats(freshUser.getId());
        stats.applyToRequest(request);

        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) {
            tab = "profile";
        }

        request.setAttribute("currentUser", freshUser);
        request.setAttribute("orders", orders);
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

            ServiceResult<User> result = userService.updateProfileWithValidation(currentUser.getId(), username, phone, address);
            if (result.isSuccess()) {
                session.setAttribute("user", result.getData());
                session.setAttribute("profileSuccess", result.getMessage());
                session.removeAttribute("profileError");
            } else {
                session.setAttribute("profileError", result.getMessage());
                session.removeAttribute("profileSuccess");
            }
            response.sendRedirect(request.getContextPath() + "/profile?tab=profile");

        } else if ("changePassword".equalsIgnoreCase(action)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            ServiceResult<User> result = userService.changePasswordWithValidation(currentUser.getId(), oldPassword, newPassword, confirmPassword);
            if (result.isSuccess()) {
                session.setAttribute("user", result.getData());
                session.setAttribute("profileSuccess", result.getMessage());
                session.removeAttribute("profileError");
            } else {
                session.setAttribute("profileError", result.getMessage());
                session.removeAttribute("profileSuccess");
            }
            response.sendRedirect(request.getContextPath() + "/profile?tab=password");

        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }
}
