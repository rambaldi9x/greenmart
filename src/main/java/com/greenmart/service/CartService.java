package com.greenmart.service;

import com.greenmart.entity.Coupon;
import com.greenmart.entity.Order;
import com.greenmart.entity.Product;
import com.greenmart.entity.User;
import com.greenmart.model.Cart;
import com.greenmart.model.CartItemResult;
import com.greenmart.model.ServiceResult;

import java.util.List;

public class CartService {
    private final ProductService productService;
    private final OrderService orderService;
    private final CouponService couponService;

    public CartService() {
        this.productService = new ProductService();
        this.orderService = new OrderService();
        this.couponService = new CouponService();
    }

    public List<Coupon> getAvailableCoupons() {
        return couponService.getAllCoupons();
    }

    public CartItemResult addToCart(Cart cart, Long productId, int quantity) {
        if (cart == null || productId == null) {
            return new CartItemResult(false, "add", productId, 0, 0, 0.0, "Thông tin sản phẩm không hợp lệ");
        }

        int qty = Math.max(1, quantity);
        Product product = productService.getProductById(productId);
        if (product == null) {
            return new CartItemResult(false, "add", productId, 0, cart.getTotalQuantity(), cart.getSubtotal(), "Không tìm thấy sản phẩm");
        }

        cart.addItem(product, qty);
        String msg = "Đã thêm " + qty + " sản phẩm \"" + product.getName() + "\" vào giỏ hàng thành công!";
        return new CartItemResult(true, "add", productId, cart.getItemQuantity(productId), cart.getTotalQuantity(), cart.getSubtotal(), msg);
    }

    public CartItemResult updateQuantity(Cart cart, Long productId, Integer quantity, Integer delta) {
        if (cart == null || productId == null) {
            return new CartItemResult(false, "update", productId, 0, 0, 0.0, "Thông tin giỏ hàng không hợp lệ");
        }

        if (quantity != null) {
            cart.setQuantity(productId, quantity);
        } else if (delta != null) {
            cart.updateQuantity(productId, delta);
        }

        int currentQty = cart.getItemQuantity(productId);
        return new CartItemResult(true, "update", productId, currentQty, cart.getTotalQuantity(), cart.getSubtotal(), "Đã cập nhật giỏ hàng");
    }

    public CartItemResult removeFromCart(Cart cart, Long productId) {
        if (cart != null && productId != null) {
            cart.removeItem(productId);
        }
        int totalQty = (cart != null) ? cart.getTotalQuantity() : 0;
        double subtotal = (cart != null) ? cart.getSubtotal() : 0.0;
        return new CartItemResult(true, "remove", productId, 0, totalQty, subtotal, "Đã xóa sản phẩm khỏi giỏ hàng");
    }

    public void clearCart(Cart cart) {
        if (cart != null) {
            cart.clear();
        }
    }

    public ServiceResult<Coupon> applyCoupon(Cart cart, String couponCode) {
        if (cart == null) {
            return ServiceResult.error("Giỏ hàng không hợp lệ!");
        }
        if (couponCode == null || couponCode.trim().isEmpty()) {
            return ServiceResult.error("Vui lòng nhập mã giảm giá!");
        }

        Coupon coupon = couponService.getCouponByCode(couponCode.trim());
        if (coupon != null) {
            cart.setAppliedCoupon(coupon);
            return ServiceResult.ok(coupon, "Áp dụng mã giảm giá thành công: " + coupon.getLabel());
        }
        return ServiceResult.error("Mã giảm giá không hợp lệ hoặc đã hết hạn!");
    }

    public void removeCoupon(Cart cart) {
        if (cart != null) {
            cart.removeCoupon();
        }
    }

    public Order checkout(Cart cart, User user, String name, String phone, String address, String paymentMethod) {
        if (cart == null || cart.isEmpty()) {
            return null;
        }
        Order order = orderService.createOrder(user, name, phone, address, paymentMethod, cart);
        cart.clear();
        return order;
    }
}
