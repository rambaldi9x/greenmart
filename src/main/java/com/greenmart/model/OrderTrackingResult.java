package com.greenmart.model;

import com.greenmart.entity.Order;

import javax.servlet.http.HttpServletRequest;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class OrderTrackingResult implements Serializable {
    private static final long serialVersionUID = 1L;

    private String searchedCode = "";
    private String searchedPhone = "";
    private Order foundOrder;
    private List<Order> foundOrders = new ArrayList<>();
    private String searchError;
    private List<Order> userRecentOrders = Collections.emptyList();
    private int step = 1;

    public OrderTrackingResult() {}

    public void applyToRequest(HttpServletRequest request) {
        request.setAttribute("searchedCode", searchedCode);
        request.setAttribute("searchedPhone", searchedPhone);
        request.setAttribute("foundOrder", foundOrder);
        request.setAttribute("foundOrders", foundOrders);
        request.setAttribute("searchError", searchError);
        request.setAttribute("userRecentOrders", userRecentOrders);
    }

    public String getSearchedCode() { return searchedCode; }
    public void setSearchedCode(String searchedCode) { this.searchedCode = searchedCode != null ? searchedCode : ""; }

    public String getSearchedPhone() { return searchedPhone; }
    public void setSearchedPhone(String searchedPhone) { this.searchedPhone = searchedPhone != null ? searchedPhone : ""; }

    public Order getFoundOrder() { return foundOrder; }
    public void setFoundOrder(Order foundOrder) { this.foundOrder = foundOrder; }

    public List<Order> getFoundOrders() { return foundOrders; }
    public void setFoundOrders(List<Order> foundOrders) { this.foundOrders = (foundOrders != null) ? foundOrders : new ArrayList<>(); }

    public String getSearchError() { return searchError; }
    public void setSearchError(String searchError) { this.searchError = searchError; }

    public List<Order> getUserRecentOrders() { return userRecentOrders; }
    public void setUserRecentOrders(List<Order> userRecentOrders) { this.userRecentOrders = (userRecentOrders != null) ? userRecentOrders : Collections.emptyList(); }

    public int getStep() { return step; }
    public void setStep(int step) { this.step = step; }
}
