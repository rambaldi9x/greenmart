package com.greenmart.controller;

import com.greenmart.entity.Coupon;
import com.greenmart.entity.Order;
import com.greenmart.entity.User;
import com.greenmart.model.Cart;
import com.greenmart.model.CartItemResult;
import com.greenmart.model.ServiceResult;
import com.greenmart.service.CartService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart", "/checkout"})
public class CartServlet extends HttpServlet {
    private CartService cartService;

    @Override
    public void init() throws ServletException {
        cartService = new CartService();
    }

    private Cart getCart(HttpSession session) {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = getCart(session);
        request.setAttribute("cart", cart);
        request.setAttribute("availableCoupons", cartService.getAvailableCoupons());
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Cart cart = getCart(session);

        boolean isAjax = "1".equals(request.getParameter("ajax"))
                || "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"));

        if ("add".equalsIgnoreCase(action)) {
            String prodIdStr = request.getParameter("productId");
            String qtyStr = request.getParameter("quantity");
            int qty = 1;
            Long prodId = null;
            try {
                if (qtyStr != null && !qtyStr.trim().isEmpty()) {
                    qty = Math.max(1, Integer.parseInt(qtyStr.trim()));
                }
                if (prodIdStr != null && !prodIdStr.trim().isEmpty()) {
                    prodId = Long.parseLong(prodIdStr.trim());
                }
            } catch (Exception ignored) {}

            CartItemResult result = cartService.addToCart(cart, prodId, qty);
            if (result.isSuccess()) {
                session.setAttribute("cartSuccess", result.getMessage());
            }

            if (isAjax) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(result.toJson());
                return;
            }

            String redirect = request.getParameter("redirect");
            if ("home".equalsIgnoreCase(redirect)) {
                response.sendRedirect(request.getContextPath() + "/home#products");
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }

        } else if ("update".equalsIgnoreCase(action) || "setQuantity".equalsIgnoreCase(action)) {
            String prodIdStr = request.getParameter("productId");
            String deltaStr = request.getParameter("delta");
            String qtyStr = request.getParameter("quantity");
            Long prodId = null;
            Integer qty = null;
            Integer delta = null;
            try {
                if (prodIdStr != null && !prodIdStr.trim().isEmpty()) prodId = Long.parseLong(prodIdStr.trim());
                if (qtyStr != null && !qtyStr.trim().isEmpty()) qty = Integer.parseInt(qtyStr.trim());
                if (deltaStr != null && !deltaStr.trim().isEmpty()) delta = Integer.parseInt(deltaStr.trim());
            } catch (Exception ignored) {}

            CartItemResult result = cartService.updateQuantity(cart, prodId, qty, delta);

            if (isAjax) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(result.toJson());
                return;
            }

            response.sendRedirect(request.getContextPath() + "/cart");

        } else if ("remove".equalsIgnoreCase(action)) {
            String prodIdStr = request.getParameter("productId");
            Long prodId = null;
            try {
                if (prodIdStr != null && !prodIdStr.trim().isEmpty()) prodId = Long.parseLong(prodIdStr.trim());
            } catch (Exception ignored) {}

            CartItemResult result = cartService.removeFromCart(cart, prodId);

            if (isAjax) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(result.toJson());
                return;
            }

            response.sendRedirect(request.getContextPath() + "/cart");

        } else if ("clear".equalsIgnoreCase(action)) {
            cartService.clearCart(cart);
            session.removeAttribute("couponSuccess");
            session.removeAttribute("couponError");
            response.sendRedirect(request.getContextPath() + "/cart");

        } else if ("applyCoupon".equalsIgnoreCase(action)) {
            String code = request.getParameter("couponCode");
            ServiceResult<Coupon> result = cartService.applyCoupon(cart, code);
            if (result.isSuccess()) {
                session.setAttribute("couponSuccess", result.getMessage());
                session.removeAttribute("couponError");
            } else {
                session.setAttribute("couponError", result.getMessage());
                session.removeAttribute("couponSuccess");
            }
            response.sendRedirect(request.getContextPath() + "/cart");

        } else if ("removeCoupon".equalsIgnoreCase(action)) {
            cartService.removeCoupon(cart);
            session.removeAttribute("couponSuccess");
            session.removeAttribute("couponError");
            response.sendRedirect(request.getContextPath() + "/cart");

        } else if ("checkout".equalsIgnoreCase(action)) {
            if (cart.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            String custName = request.getParameter("custName");
            String custPhone = request.getParameter("custPhone");
            String custAddress = request.getParameter("custAddress");
            String custPayment = request.getParameter("custPayment");

            User currentUser = (User) session.getAttribute("user");
            Order order = cartService.checkout(cart, currentUser, custName, custPhone, custAddress, custPayment);

            session.removeAttribute("couponSuccess");
            session.removeAttribute("couponError");

            String encodedName = URLEncoder.encode(custName != null ? custName : "", "UTF-8");
            long total = order != null && order.getTotal() != null ? order.getTotal().longValue() : 0L;
            String code = order != null ? order.getOrderCode() : "";

            response.sendRedirect(request.getContextPath() + "/cart?orderSuccess=1&orderCode=" + code + "&total=" + total + "&name=" + encodedName);

        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}