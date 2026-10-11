package com.greenmart.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.greenmart.entity.User;
import com.greenmart.model.OrderTrackingResult;
import com.greenmart.service.OrderService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "OrderTrackingServlet", urlPatterns = {"/track-order", "/tracking", "/order-status"})
public class OrderTrackingServlet extends HttpServlet {
    private OrderService orderService;
    private ObjectMapper objectMapper;

    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
        objectMapper = new ObjectMapper();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");
        String phone = request.getParameter("phone");
        String isAjax = request.getParameter("ajax");

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        Long currentUserId = (currentUser != null) ? currentUser.getId() : null;

        OrderTrackingResult result = orderService.trackOrder(code, phone, currentUserId);

        if ("1".equals(isAjax)) {
            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> respMap = new HashMap<>();
            if (result.getFoundOrder() != null) {
                respMap.put("status", "success");
                respMap.put("order", orderService.orderToMap(result.getFoundOrder()));
            } else {
                respMap.put("status", "error");
                respMap.put("message", result.getSearchError() != null ? result.getSearchError() : "Không tìm thấy đơn hàng");
            }
            response.getWriter().write(objectMapper.writeValueAsString(respMap));
            return;
        }

        result.applyToRequest(request);
        request.getRequestDispatcher("/tracking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");
        String phone = request.getParameter("phone");

        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/track-order?");
        if (code != null && !code.trim().isEmpty()) {
            redirectUrl.append("code=").append(java.net.URLEncoder.encode(code.trim(), "UTF-8"));
        } else if (phone != null && !phone.trim().isEmpty()) {
            redirectUrl.append("phone=").append(java.net.URLEncoder.encode(phone.trim(), "UTF-8"));
        }

        response.sendRedirect(redirectUrl.toString());
    }
}
