package com.greenmart.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.greenmart.entity.Order;
import com.greenmart.entity.User;
import com.greenmart.service.OrderService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

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

        Order foundOrder = null;
        List<Order> foundOrders = new ArrayList<>();
        String searchError = null;

        if (code != null && !code.trim().isEmpty()) {
            String trimmedCode = code.trim().toUpperCase();
            foundOrder = orderService.getOrderByCode(trimmedCode);
            if (foundOrder == null) {
                // If not found by full code, check if number only or search all orders
                List<Order> all = orderService.getAllOrders();
                for (Order o : all) {
                    if (o.getOrderCode() != null && o.getOrderCode().toUpperCase().contains(trimmedCode)) {
                        foundOrder = o;
                        break;
                    }
                }
            }
            if (foundOrder == null) {
                searchError = "Không tìm thấy đơn hàng với mã \"" + code.trim() + "\". Vui lòng kiểm tra lại mã đơn!";
            }
        } else if (phone != null && !phone.trim().isEmpty()) {
            foundOrders = orderService.getOrdersByPhone(phone.trim());
            if (foundOrders.isEmpty()) {
                searchError = "Không tìm thấy đơn hàng nào gắn với số điện thoại \"" + phone.trim() + "\"!";
            } else if (foundOrders.size() == 1) {
                foundOrder = foundOrders.get(0);
            }
        }

        // If user is logged in and no search query was given, provide their recent orders
        List<Order> userRecentOrders = Collections.emptyList();
        if (currentUser != null && foundOrder == null && foundOrders.isEmpty()) {
            userRecentOrders = orderService.getOrdersByUserId(currentUser.getId());
        }

        if ("1".equals(isAjax)) {
            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> respMap = new HashMap<>();
            if (foundOrder != null) {
                respMap.put("status", "success");
                respMap.put("order", orderToMap(foundOrder));
            } else {
                respMap.put("status", "error");
                respMap.put("message", searchError != null ? searchError : "Không tìm thấy đơn hàng");
            }
            response.getWriter().write(objectMapper.writeValueAsString(respMap));
            return;
        }

        request.setAttribute("searchedCode", code != null ? code.trim() : "");
        request.setAttribute("searchedPhone", phone != null ? phone.trim() : "");
        request.setAttribute("foundOrder", foundOrder);
        request.setAttribute("foundOrders", foundOrders);
        request.setAttribute("searchError", searchError);
        request.setAttribute("userRecentOrders", userRecentOrders);

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

    private Map<String, Object> orderToMap(Order o) {
        Map<String, Object> map = new HashMap<>();
        if (o == null) return map;
        map.put("id", o.getId());
        map.put("orderCode", o.getOrderCode());
        map.put("name", o.getName());
        map.put("phone", o.getPhone());
        map.put("address", o.getAddress());
        map.put("paymentMethod", o.getPaymentMethod());
        map.put("subtotal", o.getSubtotal());
        map.put("discount", o.getDiscount());
        map.put("couponCode", o.getCouponCode());
        map.put("total", o.getTotal());
        map.put("status", o.getStatus());
        map.put("createdAt", o.getCreatedAt());

        // Step number 1: Waiting, 2: Confirmed, 3: Shipping, 4: Completed, -1: Canceled
        int step = 1;
        String st = o.getStatus() != null ? o.getStatus().trim().toLowerCase() : "waiting";
        if (st.contains("cancel") || st.contains("hủy")) {
            step = -1;
        } else if (st.contains("complete") || st.contains("hoàn") || st.contains("deliver")) {
            step = 4;
        } else if (st.contains("ship") || st.contains("giao")) {
            step = 3;
        } else if (st.contains("confirm") || st.contains("xác nhận")) {
            step = 2;
        }
        map.put("step", step);
        return map;
    }
}
