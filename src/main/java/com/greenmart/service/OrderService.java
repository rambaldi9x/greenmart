package com.greenmart.service;

import com.greenmart.entity.Order;
import com.greenmart.entity.OrderItem;
import com.greenmart.entity.Product;
import com.greenmart.entity.User;
import com.greenmart.model.Cart;
import com.greenmart.model.CartItem;
import com.greenmart.model.OrderTrackingResult;
import com.greenmart.model.UserOrderStats;
import com.greenmart.repository.OrderRepository;
import com.greenmart.repository.ProductRepository;

import java.text.SimpleDateFormat;
import java.util.*;

public class OrderService {
    private final OrderRepository orderRepository;
    private final ProductRepository productRepository;

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

    public List<Order> getOrdersByUserId(Long userId) {
        return orderRepository.findByUserId(userId);
    }

    public Order getOrderById(Long id) {
        return orderRepository.findById(id);
    }

    public Order getOrderByCode(String orderCode) {
        return orderRepository.findByOrderCode(orderCode);
    }

    public List<Order> getOrdersByPhone(String phone) {
        return orderRepository.findByPhone(phone);
    }

    public boolean isOrderCompleted(String status) {
        if (status == null) return false;
        String s = status.trim().toLowerCase();
        return "completed".equals(s) || "delivered".equals(s) || "hoàn tất".equals(s) || "hoàn thành".equals(s);
    }

    public void updateOrderStatus(Long orderId, String status) {
        orderRepository.updateStatus(orderId, status);
    }

    public void deleteOrder(Long orderId) {
        orderRepository.delete(orderId);
    }

    public UserOrderStats getUserOrderStats(Long userId) {
        if (userId == null) {
            return new UserOrderStats(0, 0, 0.0);
        }
        List<Order> orders = getOrdersByUserId(userId);
        double totalSpent = 0.0;
        int completedOrders = 0;
        for (Order o : orders) {
            if (isOrderCompleted(o.getStatus())) {
                completedOrders++;
                if (o.getTotal() != null) {
                    totalSpent += o.getTotal();
                }
            }
        }
        return new UserOrderStats(orders.size(), completedOrders, totalSpent);
    }

    public int calculateTrackingStep(String status) {
        int step = 1;
        String st = status != null ? status.trim().toLowerCase() : "waiting";
        if (st.contains("cancel") || st.contains("hủy")) {
            step = -1;
        } else if (st.contains("complete") || st.contains("hoàn") || st.contains("deliver")) {
            step = 4;
        } else if (st.contains("ship") || st.contains("giao")) {
            step = 3;
        } else if (st.contains("confirm") || st.contains("xác nhận")) {
            step = 2;
        }
        return step;
    }

    public Map<String, Object> orderToMap(Order o) {
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
        map.put("step", calculateTrackingStep(o.getStatus()));
        return map;
    }

    public OrderTrackingResult trackOrder(String code, String phone, Long currentUserId) {
        OrderTrackingResult result = new OrderTrackingResult();
        result.setSearchedCode(code != null ? code.trim() : "");
        result.setSearchedPhone(phone != null ? phone.trim() : "");

        Order foundOrder = null;
        List<Order> foundOrders = new ArrayList<>();
        String searchError = null;

        if (code != null && !code.trim().isEmpty()) {
            String trimmedCode = code.trim().toUpperCase();
            foundOrder = getOrderByCode(trimmedCode);
            if (foundOrder == null) {
                List<Order> all = getAllOrders();
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
            foundOrders = getOrdersByPhone(phone.trim());
            if (foundOrders.isEmpty()) {
                searchError = "Không tìm thấy đơn hàng nào gắn với số điện thoại \"" + phone.trim() + "\"!";
            } else if (foundOrders.size() == 1) {
                foundOrder = foundOrders.get(0);
            }
        }

        List<Order> userRecentOrders = Collections.emptyList();
        if (currentUserId != null && foundOrder == null && foundOrders.isEmpty()) {
            userRecentOrders = getOrdersByUserId(currentUserId);
        }

        result.setFoundOrder(foundOrder);
        result.setFoundOrders(foundOrders);
        result.setSearchError(searchError);
        result.setUserRecentOrders(userRecentOrders);
        if (foundOrder != null) {
            result.setStep(calculateTrackingStep(foundOrder.getStatus()));
        }

        return result;
    }
}
