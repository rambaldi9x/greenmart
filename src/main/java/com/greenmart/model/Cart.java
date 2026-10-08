package com.greenmart.model;

import com.greenmart.entity.Coupon;
import com.greenmart.entity.Product;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class Cart implements Serializable {
    private static final long serialVersionUID = 1L;

    private Map<Long, CartItem> items = new LinkedHashMap<>();
    private Coupon appliedCoupon;

    public void addItem(Product product, int quantity) {
        if (product == null || product.getId() == null) return;
        Long id = product.getId();
        if (items.containsKey(id)) {
            CartItem existing = items.get(id);
            existing.setQuantity(existing.getQuantity() + quantity);
        } else {
            items.put(id, new CartItem(product.getId(), product.getName(), product.getPrice(), product.getImage(), quantity));
        }
    }

    public void updateQuantity(Long productId, int delta) {
        if (productId == null || !items.containsKey(productId)) return;
        CartItem item = items.get(productId);
        int newQty = item.getQuantity() + delta;
        if (newQty <= 0) {
            items.remove(productId);
        } else {
            item.setQuantity(newQty);
        }
    }

    public void setQuantity(Long productId, int quantity) {
        if (productId == null || !items.containsKey(productId)) return;
        if (quantity <= 0) {
            items.remove(productId);
        } else {
            items.get(productId).setQuantity(quantity);
        }
    }

    public void removeItem(Long productId) {
        if (productId != null) {
            items.remove(productId);
        }
    }

    public void clear() {
        items.clear();
        appliedCoupon = null;
    }

    public List<CartItem> getItems() {
        return new ArrayList<>(items.values());
    }

    public Map<Long, CartItem> getItemsMap() {
        return items;
    }

    public int getItemQuantity(Long productId) {
        if (productId != null && items.containsKey(productId)) {
            return items.get(productId).getQuantity();
        }
        return 0;
    }

    public int getTotalQuantity() {
        int count = 0;
        for (CartItem item : items.values()) {
            count += item.getQuantity();
        }
        return count;
    }

    public double getSubtotal() {
        double total = 0.0;
        for (CartItem item : items.values()) {
            total += item.getTotal();
        }
        return total;
    }

    public double getDiscount() {
        if (appliedCoupon == null) return 0.0;
        double subtotal = getSubtotal();
        if ("percent".equalsIgnoreCase(appliedCoupon.getType())) {
            return Math.round(subtotal * (appliedCoupon.getValue() / 100.0));
        } else {
            return Math.min(appliedCoupon.getValue(), subtotal);
        }
    }

    public double getGrandTotal() {
        double grand = getSubtotal() - getDiscount();
        return Math.max(0.0, grand);
    }

    public Coupon getAppliedCoupon() {
        return appliedCoupon;
    }

    public void setAppliedCoupon(Coupon appliedCoupon) {
        this.appliedCoupon = appliedCoupon;
    }

    public void removeCoupon() {
        this.appliedCoupon = null;
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }
}
