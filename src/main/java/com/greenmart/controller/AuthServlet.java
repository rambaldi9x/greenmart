package com.greenmart.controller;

import com.greenmart.entity.User;
import com.greenmart.model.ServiceResult;
import com.greenmart.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AuthServlet", urlPatterns = {"/auth", "/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String uri = request.getRequestURI();

        if ("logout".equalsIgnoreCase(action) || uri.endsWith("/logout")) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("user");
            }
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String mode = request.getParameter("mode");
        if (uri.endsWith("/register") || "register".equalsIgnoreCase(mode)) {
            request.setAttribute("mode", "register");
        } else {
            request.setAttribute("mode", "login");
        }

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = request.getRequestURI().endsWith("/register") ? "register" : "login";
        }

        HttpSession session = request.getSession();

        if ("login".equalsIgnoreCase(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            User user = userService.login(email, password);
            if (user != null) {
                session.setAttribute("user", user);
                String redirect = request.getParameter("redirect");
                if (redirect != null && !redirect.trim().isEmpty()) {
                    String cleanRedirect = redirect.trim().replaceFirst("^/+", "");
                    response.sendRedirect(request.getContextPath() + "/" + cleanRedirect);
                    return;
                }
                if ("admin".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin");
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
                return;
            } else {
                request.setAttribute("error", "Email hoặc mật khẩu không chính xác!");
                request.setAttribute("mode", "login");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } else if ("register".equalsIgnoreCase(action)) {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            ServiceResult<User> result = userService.registerUser(email, username, password, confirmPassword);
            if (result.isSuccess()) {
                session.setAttribute("user", result.getData());
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                request.setAttribute("error", result.getMessage());
                request.setAttribute("mode", "register");
                request.setAttribute("username", username);
                request.setAttribute("email", email);
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}