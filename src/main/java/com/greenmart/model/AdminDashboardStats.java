package com.greenmart.model;

import javax.servlet.http.HttpServletRequest;
import java.io.Serializable;
import java.util.LinkedHashSet;
import java.util.Set;

public class AdminDashboardStats implements Serializable {
    private static final long serialVersionUID = 1L;

    private double totalRevenue;
    private int totalOrders;
    private long waitingOrdersCount;
    private long confirmedOrdersCount;
    private long shippingOrdersCount;
    private long completedOrdersCount;
    private long canceledOrdersCount;

    private int totalProducts;
    private long inStockCount;
    private long lowStockCount;
    private long outOfStockCount;
    private long totalStockUnits;
    private Set<String> distinctCategories = new LinkedHashSet<>();
    private int categoriesCount;
    private long rauCuCount;
    private long thitCaCount;
    private long doUongCount;
    private long banhKeoCount;
    private long thucPhamKhoCount;

    private long totalVendors;
    private int allVendorsCount;
    private long approvedVendorsCount;
    private long waitingVendorsCount;
    private long rejectedVendorsCount;

    public AdminDashboardStats() {}

    public void applyToRequest(HttpServletRequest request) {
        request.setAttribute("adminStats", this);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("waitingOrdersCount", waitingOrdersCount);
        request.setAttribute("confirmedOrdersCount", confirmedOrdersCount);
        request.setAttribute("shippingOrdersCount", shippingOrdersCount);
        request.setAttribute("completedOrdersCount", completedOrdersCount);
        request.setAttribute("canceledOrdersCount", canceledOrdersCount);

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("inStockCount", inStockCount);
        request.setAttribute("lowStockCount", lowStockCount);
        request.setAttribute("outOfStockCount", outOfStockCount);
        request.setAttribute("totalStockUnits", totalStockUnits);
        request.setAttribute("distinctCategories", distinctCategories);
        request.setAttribute("categoriesCount", categoriesCount);
        request.setAttribute("rauCuCount", rauCuCount);
        request.setAttribute("thitCaCount", thitCaCount);
        request.setAttribute("doUongCount", doUongCount);
        request.setAttribute("banhKeoCount", banhKeoCount);
        request.setAttribute("thucPhamKhoCount", thucPhamKhoCount);

        request.setAttribute("totalVendors", totalVendors);
        request.setAttribute("allVendorsCount", allVendorsCount);
        request.setAttribute("approvedVendorsCount", approvedVendorsCount);
        request.setAttribute("waitingVendorsCount", waitingVendorsCount);
        request.setAttribute("rejectedVendorsCount", rejectedVendorsCount);
    }

    public double getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }

    public int getTotalOrders() { return totalOrders; }
    public void setTotalOrders(int totalOrders) { this.totalOrders = totalOrders; }

    public long getWaitingOrdersCount() { return waitingOrdersCount; }
    public void setWaitingOrdersCount(long waitingOrdersCount) { this.waitingOrdersCount = waitingOrdersCount; }

    public long getConfirmedOrdersCount() { return confirmedOrdersCount; }
    public void setConfirmedOrdersCount(long confirmedOrdersCount) { this.confirmedOrdersCount = confirmedOrdersCount; }

    public long getShippingOrdersCount() { return shippingOrdersCount; }
    public void setShippingOrdersCount(long shippingOrdersCount) { this.shippingOrdersCount = shippingOrdersCount; }

    public long getCompletedOrdersCount() { return completedOrdersCount; }
    public void setCompletedOrdersCount(long completedOrdersCount) { this.completedOrdersCount = completedOrdersCount; }

    public long getCanceledOrdersCount() { return canceledOrdersCount; }
    public void setCanceledOrdersCount(long canceledOrdersCount) { this.canceledOrdersCount = canceledOrdersCount; }

    public int getTotalProducts() { return totalProducts; }
    public void setTotalProducts(int totalProducts) { this.totalProducts = totalProducts; }

    public long getInStockCount() { return inStockCount; }
    public void setInStockCount(long inStockCount) { this.inStockCount = inStockCount; }

    public long getLowStockCount() { return lowStockCount; }
    public void setLowStockCount(long lowStockCount) { this.lowStockCount = lowStockCount; }

    public long getOutOfStockCount() { return outOfStockCount; }
    public void setOutOfStockCount(long outOfStockCount) { this.outOfStockCount = outOfStockCount; }

    public long getTotalStockUnits() { return totalStockUnits; }
    public void setTotalStockUnits(long totalStockUnits) { this.totalStockUnits = totalStockUnits; }

    public Set<String> getDistinctCategories() { return distinctCategories; }
    public void setDistinctCategories(Set<String> distinctCategories) {
        this.distinctCategories = distinctCategories;
        this.categoriesCount = distinctCategories != null ? distinctCategories.size() : 0;
    }

    public int getCategoriesCount() { return categoriesCount; }
    public void setCategoriesCount(int categoriesCount) { this.categoriesCount = categoriesCount; }

    public long getRauCuCount() { return rauCuCount; }
    public void setRauCuCount(long rauCuCount) { this.rauCuCount = rauCuCount; }

    public long getThitCaCount() { return thitCaCount; }
    public void setThitCaCount(long thitCaCount) { this.thitCaCount = thitCaCount; }

    public long getDoUongCount() { return doUongCount; }
    public void setDoUongCount(long doUongCount) { this.doUongCount = doUongCount; }

    public long getBanhKeoCount() { return banhKeoCount; }
    public void setBanhKeoCount(long banhKeoCount) { this.banhKeoCount = banhKeoCount; }

    public long getThucPhamKhoCount() { return thucPhamKhoCount; }
    public void setThucPhamKhoCount(long thucPhamKhoCount) { this.thucPhamKhoCount = thucPhamKhoCount; }

    public long getTotalVendors() { return totalVendors; }
    public void setTotalVendors(long totalVendors) { this.totalVendors = totalVendors; }

    public int getAllVendorsCount() { return allVendorsCount; }
    public void setAllVendorsCount(int allVendorsCount) { this.allVendorsCount = allVendorsCount; }

    public long getApprovedVendorsCount() { return approvedVendorsCount; }
    public void setApprovedVendorsCount(long approvedVendorsCount) { this.approvedVendorsCount = approvedVendorsCount; }

    public long getWaitingVendorsCount() { return waitingVendorsCount; }
    public void setWaitingVendorsCount(long waitingVendorsCount) { this.waitingVendorsCount = waitingVendorsCount; }

    public long getRejectedVendorsCount() { return rejectedVendorsCount; }
    public void setRejectedVendorsCount(long rejectedVendorsCount) { this.rejectedVendorsCount = rejectedVendorsCount; }
}
