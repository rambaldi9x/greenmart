package com.greenmart.controller;

import com.greenmart.entity.Coupon;
import com.greenmart.entity.Order;
import com.greenmart.entity.Product;
import com.greenmart.entity.User;
import com.greenmart.model.Cart;
import com.greenmart.service.CouponService;
import com.greenmart.service.OrderService;
import com.greenmart.service.ProductService;

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
    private ProductService productService;
    private OrderService orderService;
    private CouponService couponService;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        orderService = new OrderService();
        couponService = new CouponService();
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
        request.setAttribute("availableCoupons", couponService.getAllCoupons());
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
            try {
                if (qtyStr != null && !qtyStr.trim().isEmpty()) {
                    qty = Math.max(1, Integer.parseInt(qtyStr.trim()));
                }
            } catch (Exception ignored) {}

            Long prodId = null;
            try {
                prodId = Long.parseLong(prodIdStr);
                Product product = productService.getProductById(prodId);
                if (product != null) {
                    cart.addItem(product, qty);
                    session.setAttribute("cartSuccess", "Đã thêm " + qty + " sản phẩm \"" + product.getName() + "\" vào giỏ hàng thành công!");
                }
            } catch (Exception ignored) {}

            if (isAjax) {
                int itemQty = (prodId != null) ? cart.getItemQuantity(prodId) : 0;
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(String.format(
                    "{\"status\":\"success\",\"action\":\"add\",\"productId\":%s,\"quantity\":%d,\"totalQuantity\":%d,\"subtotal\":%.0f}",
                    prodId != null ? prodId : "null", itemQty, cart.getTotalQuantity(), cart.getSubtotal()
                ));
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
            try {
                prodId = Long.parseLong(prodIdStr);
                if (qtyStr != null && !qtyStr.trim().isEmpty()) {
                    int qty = Integer.parseInt(qtyStr.trim());
                    cart.setQuantity(prodId, qty);
                } else if (deltaStr != null && !deltaStr.trim().isEmpty()) {
                    int delta = Integer.parseInt(deltaStr.trim());
                    cart.updateQuantity(prodId, delta);
                }
            } catch (Exception ignored) {}

            if (isAjax) {
                int itemQty = (prodId != null) ? cart.getItemQuantity(prodId) : 0;
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(String.format(
                    "{\"status\":\"success\",\"action\":\"update\",\"productId\":%s,\"quantity\":%d,\"totalQuantity\":%d,\"subtotal\":%.0f}",
                    prodId != null ? prodId : "null", itemQty, cart.getTotalQuantity(), cart.getSubtotal()
                ));
                return;
            }

            response.sendRedirect(request.getContextPath() + "/cart");

        } else if ("remove".equalsIgnoreCase(action)) {
            String prodIdStr = request.getParameter("productId");
            Long prodId = null;
            try {
                prodId = Long.parseLong(prodIdStr);
                cart.removeItem(prodId);
            } catch (Exception ignored) {}

            if (isAjax) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(String.format(
                    "{\"status\":\"success\",\"action\":\"remove\",\"productId\":%s,\"quantity\":0,\"totalQuantity\":%d,\"subtotal\":%.0f}",
                    prodId != null ? prodId : "null", cart.getTotalQuantity(), cart.getSubtotal()
                ));
                return;
            }

            response.sendRedirect(request.getContextPath() + "/cart");

        } else if ("clear".equalsIgnoreCase(action)) {
            cart.clear();
            session.removeAttribute("couponSuccess");
            session.removeAttribute("couponError");
            response.sendRedirect(request.getContextPath() + "/cart");

        } else if ("applyCoupon".equalsIgnoreCase(action)) {
            String code = request.getParameter("couponCode");
            Coupon coupon = couponService.getCouponByCode(code);
            if (coupon != null) {
                cart.setAppliedCoupon(coupon);
                session.setAttribute("couponSuccess", "Áp dụng mã giảm giá thành công: " + coupon.getLabel());
                session.removeAttribute("couponError");
            } else {
                session.setAttribute("couponError", "Mã giảm giá không hợp lệ hoặc đã hết hạn!");
                session.removeAttribute("couponSuccess");
            }
            response.sendRedirect(request.getContextPath() + "/cart");

        } else if ("removeCoupon".equalsIgnoreCase(action)) {
            cart.removeCoupon();
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
            Order order = orderService.createOrder(currentUser, custName, custPhone, custAddress, custPayment, cart);

            cart.clear();
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