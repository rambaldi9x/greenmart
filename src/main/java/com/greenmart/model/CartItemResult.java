package com.greenmart.model;

import java.io.Serializable;

public class CartItemResult implements Serializable {
    private static final long serialVersionUID = 1L;

    private boolean success;
    private String action;
    private Long productId;
    private int itemQuantity;
    private int totalQuantity;
    private double subtotal;
    private String message;

    public CartItemResult() {}

    public CartItemResult(boolean success, String action, Long productId, int itemQuantity, int totalQuantity, double subtotal, String message) {
        this.success = success;
        this.action = action;
        this.productId = productId;
        this.itemQuantity = itemQuantity;
        this.totalQuantity = totalQuantity;
        this.subtotal = subtotal;
        this.message = message;
    }

    public String toJson() {
        return String.format(
            "{\"status\":\"%s\",\"action\":\"%s\",\"productId\":%s,\"quantity\":%d,\"totalQuantity\":%d,\"subtotal\":%.0f}",
            success ? "success" : "error",
            action != null ? action : "",
            productId != null ? productId : "null",
            itemQuantity,
            totalQuantity,
            subtotal
        );
    }

    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public int getItemQuantity() { return itemQuantity; }
    public void setItemQuantity(int itemQuantity) { this.itemQuantity = itemQuantity; }

    public int getTotalQuantity() { return totalQuantity; }
    public void setTotalQuantity(int totalQuantity) { this.totalQuantity = totalQuantity; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
}
