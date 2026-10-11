package com.greenmart.service;

import com.greenmart.entity.Order;
import com.greenmart.entity.Product;
import com.greenmart.entity.User;
import com.greenmart.entity.Vendor;
import com.greenmart.model.AdminDashboardStats;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class AdminService {
    private final ProductService productService;
    private final OrderService orderService;
    private final VendorService vendorService;
    private final UserService userService;

    public AdminService() {
        this.productService = new ProductService();
        this.orderService = new OrderService();
        this.vendorService = new VendorService();
        this.userService = new UserService();
    }

    public AdminDashboardStats getDashboardStats() {
        List<Order> orders = orderService.getAllOrders();
        List<Product> products = productService.getAllProducts();
        List<Vendor> vendors = vendorService.getAllVendors();

        AdminDashboardStats stats = new AdminDashboardStats();

        // 1. Order stats & revenue
        double totalRevenue = 0.0;
        int completedOrdersCount = 0;
        long waitingOrdersCount = 0;
        long confirmedOrdersCount = 0;
        long shippingOrdersCount = 0;
        long canceledOrdersCount = 0;

        for (Order o : orders) {
            String st = o.getStatus() != null ? o.getStatus().trim() : "";
            if (o.getTotal() != null && orderService.isOrderCompleted(st)) {
                totalRevenue += o.getTotal();
                completedOrdersCount++;
            } else if ("Waiting".equalsIgnoreCase(st)) {
                waitingOrdersCount++;
            } else if ("Confirmed".equalsIgnoreCase(st)) {
                confirmedOrdersCount++;
            } else if ("Shipping".equalsIgnoreCase(st)) {
                shippingOrdersCount++;
            } else if ("Canceled".equalsIgnoreCase(st) || "Cancelled".equalsIgnoreCase(st)) {
                canceledOrdersCount++;
            }
        }

        stats.setTotalRevenue(totalRevenue);
        stats.setTotalOrders(orders.size());
        stats.setCompletedOrdersCount(completedOrdersCount);
        stats.setWaitingOrdersCount(waitingOrdersCount);
        stats.setConfirmedOrdersCount(confirmedOrdersCount);
        stats.setShippingOrdersCount(shippingOrdersCount);
        stats.setCanceledOrdersCount(canceledOrdersCount);

        // 2. Vendor stats
        long approvedVendorsCount = 0;
        long waitingVendorsCount = 0;
        long rejectedVendorsCount = 0;

        for (Vendor v : vendors) {
            String vst = v.getStatus() != null ? v.getStatus().trim() : "";
            if ("Approved".equalsIgnoreCase(vst)) {
                approvedVendorsCount++;
            } else if ("Waiting".equalsIgnoreCase(vst)) {
                waitingVendorsCount++;
            } else if ("Rejected".equalsIgnoreCase(vst) || "Suspended".equalsIgnoreCase(vst)) {
                rejectedVendorsCount++;
            }
        }

        stats.setTotalVendors(approvedVendorsCount);
        stats.setAllVendorsCount(vendors.size());
        stats.setApprovedVendorsCount(approvedVendorsCount);
        stats.setWaitingVendorsCount(waitingVendorsCount);
        stats.setRejectedVendorsCount(rejectedVendorsCount);

        // 3. Product stats
        long inStockCount = 0;
        long lowStockCount = 0;
        long outOfStockCount = 0;
        long totalStockUnits = 0;
        long rauCuCount = 0;
        long thitCaCount = 0;
        long doUongCount = 0;
        long banhKeoCount = 0;
        long thucPhamKhoCount = 0;
        Set<String> distinctCategories = new LinkedHashSet<>();

        for (Product p : products) {
            int cnt = p.getCount() != null ? p.getCount() : 0;
            totalStockUnits += cnt;
            String cat = p.getCategory() != null ? p.getCategory().trim() : "";
            String catLower = cat.toLowerCase();

            if (!cat.isEmpty()) {
                distinctCategories.add(cat);
            }

            if (catLower.contains("rau") || catLower.contains("trái") || catLower.contains("trai")) {
                rauCuCount++;
            } else if (catLower.contains("thịt") || catLower.contains("cá") || catLower.contains("thit") || catLower.contains("ca")) {
                thitCaCount++;
            } else if (catLower.contains("uống") || catLower.contains("sữa") || catLower.contains("uong") || catLower.contains("sua")) {
                doUongCount++;
            } else if (catLower.contains("bánh") || catLower.contains("kẹo") || catLower.contains("banh") || catLower.contains("keo")) {
                banhKeoCount++;
            } else if (catLower.contains("khô") || catLower.contains("kho")) {
                thucPhamKhoCount++;
            }

            if (cnt <= 0) {
                outOfStockCount++;
            } else if (cnt <= 15) {
                lowStockCount++;
            } else {
                inStockCount++;
            }
        }

        stats.setTotalProducts(products.size());
        stats.setInStockCount(inStockCount);
        stats.setLowStockCount(lowStockCount);
        stats.setOutOfStockCount(outOfStockCount);
        stats.setTotalStockUnits(totalStockUnits);
        stats.setDistinctCategories(distinctCategories);
        stats.setRauCuCount(rauCuCount);
        stats.setThitCaCount(thitCaCount);
        stats.setDoUongCount(doUongCount);
        stats.setBanhKeoCount(banhKeoCount);
        stats.setThucPhamKhoCount(thucPhamKhoCount);

        return stats;
    }

    public List<Product> getFilteredProducts(String categoryFilter, String stockFilter, String search) {
        List<Product> products = productService.getAllProducts();

        if (categoryFilter != null && !categoryFilter.trim().isEmpty() && !"all".equalsIgnoreCase(categoryFilter)) {
            String cf = categoryFilter.trim().toLowerCase();
            products = products.stream()
                    .filter(p -> {
                        if (p.getCategory() == null) return false;
                        String c = p.getCategory().trim().toLowerCase();
                        if ("rau-cu".equals(cf) || cf.contains("rau")) return c.contains("rau") || c.contains("trái") || c.contains("trai");
                        if ("thit-ca".equals(cf) || cf.contains("thịt") || cf.contains("thit")) return c.contains("thịt") || c.contains("cá") || c.contains("thit") || c.contains("ca");
                        if ("do-uong".equals(cf) || cf.contains("uống") || cf.contains("uong") || cf.contains("sữa") || cf.contains("sua")) return c.contains("uống") || c.contains("sữa") || c.contains("uong") || c.contains("sua");
                        if ("banh-keo".equals(cf) || cf.contains("bánh") || cf.contains("banh")) return c.contains("bánh") || c.contains("kẹo") || c.contains("banh") || c.contains("keo");
                        if ("thuc-pham-kho".equals(cf) || cf.contains("khô") || cf.contains("kho")) return c.contains("khô") || c.contains("kho");
                        return c.contains(cf) || cf.contains(c);
                    })
                    .collect(Collectors.toList());
        }

        if (stockFilter != null && !stockFilter.trim().isEmpty() && !"all".equalsIgnoreCase(stockFilter)) {
            String sf = stockFilter.trim();
            if ("out".equalsIgnoreCase(sf)) {
                products = products.stream().filter(p -> p.getCount() == null || p.getCount() <= 0).collect(Collectors.toList());
            } else if ("low".equalsIgnoreCase(sf)) {
                products = products.stream().filter(p -> p.getCount() != null && p.getCount() > 0 && p.getCount() <= 15).collect(Collectors.toList());
            } else if ("available".equalsIgnoreCase(sf)) {
                products = products.stream().filter(p -> p.getCount() != null && p.getCount() > 15).collect(Collectors.toList());
            }
        }

        if (search != null && !search.trim().isEmpty()) {
            String kw = search.trim().toLowerCase();
            products = products.stream()
                    .filter(p -> (p.getName() != null && p.getName().toLowerCase().contains(kw))
                            || (p.getCategory() != null && p.getCategory().toLowerCase().contains(kw))
                            || (p.getId() != null && String.valueOf(p.getId()).contains(kw)))
                    .collect(Collectors.toList());
        }

        return products;
    }

    public List<Order> getFilteredOrders(String statusFilter, String search) {
        List<Order> orders = orderService.getAllOrders();

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter)) {
            String sf = statusFilter.trim();
            if ("completed".equalsIgnoreCase(sf)) {
                orders = orders.stream().filter(o -> orderService.isOrderCompleted(o.getStatus())).collect(Collectors.toList());
            } else if ("canceled".equalsIgnoreCase(sf) || "cancelled".equalsIgnoreCase(sf)) {
                orders = orders.stream().filter(o -> "Canceled".equalsIgnoreCase(o.getStatus()) || "Cancelled".equalsIgnoreCase(o.getStatus())).collect(Collectors.toList());
            } else {
                orders = orders.stream().filter(o -> sf.equalsIgnoreCase(o.getStatus())).collect(Collectors.toList());
            }
        }

        if (search != null && !search.trim().isEmpty()) {
            String kw = search.trim().toLowerCase();
            orders = orders.stream()
                    .filter(o -> (o.getOrderCode() != null && o.getOrderCode().toLowerCase().contains(kw))
                            || (o.getName() != null && o.getName().toLowerCase().contains(kw))
                            || (o.getPhone() != null && o.getPhone().contains(kw)))
                    .collect(Collectors.toList());
        }

        return orders;
    }

    public List<Vendor> getFilteredVendors(String statusFilter, String search) {
        return vendorService.filterVendors(statusFilter, search);
    }

    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }

    public Product getProductById(Long id) {
        return productService.getProductById(id);
    }

    public Order getOrderById(Long id) {
        return orderService.getOrderById(id);
    }

    public Vendor getVendorById(Long id) {
        return vendorService.getVendorById(id);
    }

    public void saveOrUpdateProduct(Long id, String name, String category, Double price, Integer count, String image, String description) {
        double safePrice = price != null ? price : 0.0;
        int safeCount = count != null ? count : 100;
        String safeImage = (image != null && !image.trim().isEmpty()) ? image.trim()
                : "https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=400&q=80";
        String safeDesc = (description != null && !description.trim().isEmpty()) ? description.trim()
                : "Sản phẩm tươi ngon đảm bảo tiêu chuẩn an toàn thực phẩm.";

        if (id != null) {
            Product existing = productService.getProductById(id);
            if (existing != null) {
                existing.setName(name);
                existing.setCategory(category);
                existing.setPrice(safePrice);
                existing.setCount(safeCount);
                existing.setImage(safeImage);
                existing.setDescription(safeDesc);
                productService.updateProduct(existing);
                return;
            }
        }

        Product newProd = new Product(name, category, safePrice, safeCount, safeImage, safeDesc, null);
        productService.saveProduct(newProd);
    }

    public void saveOrUpdateVendor(Long id, String shopCode, String shopName, String contactPerson,
                                   String email, String phone, String address, String category,
                                   String description, Double rating, String status) {
        double safeRating = rating != null ? rating : 4.8;
        String safeStatus = (status != null && !status.trim().isEmpty()) ? status.trim() : "Approved";

        if (id != null) {
            Vendor existing = vendorService.getVendorById(id);
            if (existing != null) {
                existing.setShopCode(shopCode);
                existing.setShopName(shopName);
                existing.setContactPerson(contactPerson);
                existing.setEmail(email);
                existing.setPhone(phone);
                existing.setAddress(address);
                existing.setCategory(category);
                existing.setDescription(description);
                existing.setRating(safeRating);
                existing.setStatus(safeStatus);
                vendorService.updateVendor(existing);
                return;
            }
        }

        String safeCode = (shopCode != null && !shopCode.trim().isEmpty()) ? shopCode.trim() : "VND-" + (System.currentTimeMillis() % 10000);
        Vendor newV = new Vendor(safeCode, shopName, contactPerson, email, phone, address, category, description, safeRating, safeStatus, null);
        vendorService.saveVendor(newV);
    }

    public void deleteProduct(Long id) {
        productService.deleteProduct(id);
    }

    public void deleteOrder(Long id) {
        orderService.deleteOrder(id);
    }

    public boolean deleteUser(Long targetId, Long currentUserId) {
        return userService.deleteUserSafe(targetId, currentUserId);
    }

    public void updateVendorStatus(Long id, String status) {
        vendorService.updateVendorStatus(id, status);
    }

    public void deleteVendor(Long id) {
        vendorService.deleteVendor(id);
    }

    public void updateOrderStatus(Long id, String status) {
        orderService.updateOrderStatus(id, status);
    }
}
