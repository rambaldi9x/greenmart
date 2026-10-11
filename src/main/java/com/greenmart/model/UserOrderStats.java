package com.greenmart.model;

import javax.servlet.http.HttpServletRequest;
import java.io.Serializable;

public class UserOrderStats implements Serializable {
    private static final long serialVersionUID = 1L;

    private int totalOrders;
    private int completedOrders;
    private double totalSpent;

    public UserOrderStats() {}

    public UserOrderStats(int totalOrders, int completedOrders, double totalSpent) {
        this.totalOrders = totalOrders;
        this.completedOrders = completedOrders;
        this.totalSpent = totalSpent;
    }

    public void applyToRequest(HttpServletRequest request) {
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("completedOrders", completedOrders);
        request.setAttribute("totalSpent", totalSpent);
    }

    public int getTotalOrders() { return totalOrders; }
    public void setTotalOrders(int totalOrders) { this.totalOrders = totalOrders; }

    public int getCompletedOrders() { return completedOrders; }
    public void setCompletedOrders(int completedOrders) { this.completedOrders = completedOrders; }

    public double getTotalSpent() { return totalSpent; }
    public void setTotalSpent(double totalSpent) { this.totalSpent = totalSpent; }
}
