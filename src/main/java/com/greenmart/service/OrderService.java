package com.greenmart.service;

import com.greenmart.entity.Order;
import com.greenmart.entity.OrderItem;
import com.greenmart.entity.Product;
import com.greenmart.entity.User;
import com.greenmart.model.Cart;
import com.greenmart.model.CartItem;
import com.greenmart.repository.OrderRepository;
import com.greenmart.repository.ProductRepository;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Random;

public class OrderService {
    private OrderRepository orderRepository;
    private ProductRepository productRepository;

    public OrderService() {
        this.orderRepository = new OrderRepository();
        this.productRepository = new ProductRepository();
    }

    public Order createOrder(User user, String customerName, String phone, String address, String paymentMethod, Cart cart) {
        if (cart == null || cart.isEmpty()) return null;

        Order order = new Order();
        String orderCode = "GM" + (100000 + new Random().nextInt(900000));
        order.setOrderCode(orderCode);
        if (user != null) {
            order.setUserId(user.getId());
        }
        order.setName(customerName);
        order.setPhone(phone);
        order.setAddress(address);
        order.setPaymentMethod(paymentMethod != null ? paymentMethod : "COD");
        order.setSubtotal(cart.getSubtotal());
        order.setDiscount(cart.getDiscount());
        if (cart.getAppliedCoupon() != null) {
            order.setCouponCode(cart.getAppliedCoupon().getCode());
        }
        order.setTotal(cart.getGrandTotal());
        order.setStatus("Waiting");
        order.setCreatedAt(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));

        // Save order
        orderRepository.save(order);

        // Save order items & update product stock
        for (CartItem ci : cart.getItems()) {
            OrderItem item = new OrderItem();
            item.setOrderId(order.getId());
            item.setProductId(ci.getProductId());
            item.setProductName(ci.getProductName());
            item.setProductPrice(ci.getProductPrice());
            item.setQuantity(ci.getQuantity());
            orderRepository.saveOrderItem(item);

            // Deduct stock
            if (ci.getProductId() != null) {
                Product p = productRepository.findById(ci.getProductId());
                if (p != null && p.getCount() != null) {
                    p.setCount(Math.max(0, p.getCount() - ci.getQuantity()));
                    productRepository.update(p);
                }
            }
        }

        return order;
    }

    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }

    public Order getOrderById(Long id) {
        return orderRepository.findById(id);
    }

    public void updateOrderStatus(Long orderId, String status) {
        orderRepository.updateStatus(orderId, status);
    }

    public void deleteOrder(Long orderId) {
        orderRepository.delete(orderId);
    }
}
