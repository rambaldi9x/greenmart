package com.greenmart.controller;

import com.greenmart.entity.Order;
import com.greenmart.entity.Product;
import com.greenmart.entity.User;
import com.greenmart.entity.Vendor;
import com.greenmart.service.OrderService;
import com.greenmart.service.ProductService;
import com.greenmart.service.UserService;
import com.greenmart.service.VendorService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {
    private ProductService productService;
    private OrderService orderService;
    private VendorService vendorService;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        orderService = new OrderService();
        vendorService = new VendorService();
        userService = new UserService();
    }

    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth?error=unauthorized&redirect=admin");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;

        String action = request.getParameter("action");
        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) {
            tab = "dashboard";
        }

        // Handle GET actions
        if ("deleteProduct".equalsIgnoreCase(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                productService.deleteProduct(id);
            } catch (Exception ignored) {}
            response.sendRedirect(request.getContextPath() + "/admin?tab=products");
            return;
        } else if ("deleteOrder".equalsIgnoreCase(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                orderService.deleteOrder(id);
            } catch (Exception ignored) {}
            response.sendRedirect(request.getContextPath() + "/admin?tab=orders");
            return;
        } else if ("deleteUser".equalsIgnoreCase(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                User currentUser = (User) request.getSession().getAttribute("user");
                if (currentUser == null || !id.equals(currentUser.getId())) {
                    userService.deleteUser(id);
                }
            } catch (Exception ignored) {}
            response.sendRedirect(request.getContextPath() + "/admin?tab=users");
            return;
        } else if ("vendorStatus".equalsIgnoreCase(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                String status = request.getParameter("status");
                vendorService.updateVendorStatus(id, status);
            } catch (Exception ignored) {}
            response.sendRedirect(request.getContextPath() + "/admin?tab=vendors");
            return;
        } else if ("deleteVendor".equalsIgnoreCase(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                vendorService.deleteVendor(id);
            } catch (Exception ignored) {}
            response.sendRedirect(request.getContextPath() + "/admin?tab=vendors");
            return;
        }

        // Tab data preparation
        List<Order> orders = orderService.getAllOrders();
        List<Product> products = productService.getAllProducts();
        List<Vendor> vendors = vendorService.getAllVendors();
        List<User> users = userService.getAllUsers();

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

        // Vendor stats
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

        // Product stats
        long inStockCount = 0;
        long lowStockCount = 0;
        long outOfStockCount = 0;
        long totalStockUnits = 0;
        long rauCuCount = 0;
        long thitCaCount = 0;
        long doUongCount = 0;
        long banhKeoCount = 0;
        long thucPhamKhoCount = 0;
        java.util.Set<String> distinctCategories = new java.util.LinkedHashSet<>();

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

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", orders.size());
        request.setAttribute("waitingOrdersCount", waitingOrdersCount);
        request.setAttribute("confirmedOrdersCount", confirmedOrdersCount);
        request.setAttribute("shippingOrdersCount", shippingOrdersCount);
        request.setAttribute("completedOrdersCount", completedOrdersCount);
        request.setAttribute("canceledOrdersCount", canceledOrdersCount);
        request.setAttribute("totalProducts", products.size());
        request.setAttribute("totalVendors", approvedVendorsCount);
        request.setAttribute("allVendorsCount", vendors.size());
        request.setAttribute("approvedVendorsCount", approvedVendorsCount);
        request.setAttribute("waitingVendorsCount", waitingVendorsCount);
        request.setAttribute("rejectedVendorsCount", rejectedVendorsCount);
        request.setAttribute("inStockCount", inStockCount);
        request.setAttribute("lowStockCount", lowStockCount);
        request.setAttribute("outOfStockCount", outOfStockCount);
        request.setAttribute("totalStockUnits", totalStockUnits);
        request.setAttribute("distinctCategories", distinctCategories);
        request.setAttribute("categoriesCount", distinctCategories.size());
        request.setAttribute("rauCuCount", rauCuCount);
        request.setAttribute("thitCaCount", thitCaCount);
        request.setAttribute("doUongCount", doUongCount);
        request.setAttribute("banhKeoCount", banhKeoCount);
        request.setAttribute("thucPhamKhoCount", thucPhamKhoCount);

        if ("products".equalsIgnoreCase(tab)) {
            String categoryFilter = request.getParameter("categoryFilter");
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
                request.setAttribute("categoryFilter", categoryFilter.trim());
            }

            String stockFilter = request.getParameter("stockFilter");
            if (stockFilter != null && !stockFilter.trim().isEmpty() && !"all".equalsIgnoreCase(stockFilter)) {
                String sf = stockFilter.trim();
                if ("out".equalsIgnoreCase(sf)) {
                    products = products.stream().filter(p -> p.getCount() == null || p.getCount() <= 0).collect(Collectors.toList());
                } else if ("low".equalsIgnoreCase(sf)) {
                    products = products.stream().filter(p -> p.getCount() != null && p.getCount() > 0 && p.getCount() <= 15).collect(Collectors.toList());
                } else if ("available".equalsIgnoreCase(sf)) {
                    products = products.stream().filter(p -> p.getCount() != null && p.getCount() > 15).collect(Collectors.toList());
                }
                request.setAttribute("stockFilter", sf);
            }

            String search = request.getParameter("search");
            if (search != null && !search.trim().isEmpty()) {
                String kw = search.trim().toLowerCase();
                products = products.stream()
                        .filter(p -> (p.getName() != null && p.getName().toLowerCase().contains(kw))
                                || (p.getCategory() != null && p.getCategory().toLowerCase().contains(kw))
                                || (p.getId() != null && String.valueOf(p.getId()).contains(kw)))
                        .collect(Collectors.toList());
                request.setAttribute("search", search.trim());
            }
            if ("edit".equalsIgnoreCase(action)) {
                try {
                    Long id = Long.parseLong(request.getParameter("id"));
                    Product editProd = productService.getProductById(id);
                    request.setAttribute("editProduct", editProd);
                } catch (Exception ignored) {}
            }
        } else if ("orders".equalsIgnoreCase(tab)) {
            String statusFilter = request.getParameter("statusFilter");
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter)) {
                String sf = statusFilter.trim();
                if ("completed".equalsIgnoreCase(sf)) {
                    orders = orders.stream().filter(o -> orderService.isOrderCompleted(o.getStatus())).collect(Collectors.toList());
                } else if ("canceled".equalsIgnoreCase(sf) || "cancelled".equalsIgnoreCase(sf)) {
                    orders = orders.stream().filter(o -> "Canceled".equalsIgnoreCase(o.getStatus()) || "Cancelled".equalsIgnoreCase(o.getStatus())).collect(Collectors.toList());
                } else {
                    orders = orders.stream().filter(o -> sf.equalsIgnoreCase(o.getStatus())).collect(Collectors.toList());
                }
                request.setAttribute("statusFilter", sf);
            }

            String search = request.getParameter("search");
            if (search != null && !search.trim().isEmpty()) {
                String kw = search.trim().toLowerCase();
                orders = orders.stream()
                        .filter(o -> (o.getOrderCode() != null && o.getOrderCode().toLowerCase().contains(kw))
                                || (o.getName() != null && o.getName().toLowerCase().contains(kw))
                                || (o.getPhone() != null && o.getPhone().contains(kw)))
                        .collect(Collectors.toList());
                request.setAttribute("search", search.trim());
            }
            String viewOrderIdStr = request.getParameter("viewOrder");
            if (viewOrderIdStr != null) {
                try {
                    Long viewId = Long.parseLong(viewOrderIdStr);
                    Order viewOrderObj = orderService.getOrderById(viewId);
                    request.setAttribute("viewOrderObj", viewOrderObj);
                } catch (Exception ignored) {}
            }
        } else if ("vendors".equalsIgnoreCase(tab)) {
            String statusFilter = request.getParameter("statusFilter");
            String search = request.getParameter("search");
            vendors = vendorService.filterVendors(statusFilter, search);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("search", search);

            String viewVendorIdStr = request.getParameter("viewVendor");
            if (viewVendorIdStr != null && !viewVendorIdStr.trim().isEmpty()) {
                try {
                    Long vId = Long.parseLong(viewVendorIdStr.trim());
                    Vendor viewVendorObj = vendorService.getVendorById(vId);
                    request.setAttribute("viewVendorObj", viewVendorObj);
                } catch (Exception ignored) {}
            }

            if ("editVendor".equalsIgnoreCase(action)) {
                try {
                    Long editId = Long.parseLong(request.getParameter("id"));
                    Vendor editVendorObj = vendorService.getVendorById(editId);
                    request.setAttribute("editVendorObj", editVendorObj);
                } catch (Exception ignored) {}
            }
        }

        request.setAttribute("orders", orders);
        request.setAttribute("products", products);
        request.setAttribute("vendors", vendors);
        request.setAttribute("users", users);
        request.setAttribute("currentTab", tab);

        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;

        String action = request.getParameter("action");

        if ("saveProduct".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String priceStr = request.getParameter("price");
            String countStr = request.getParameter("count");
            String image = request.getParameter("image");
            String description = request.getParameter("description");

            double price = 0.0;
            int count = 100;
            try {
                if (priceStr != null) price = Double.parseDouble(priceStr.trim());
                if (countStr != null) count = Integer.parseInt(countStr.trim());
            } catch (Exception ignored) {}

            if (image == null || image.trim().isEmpty()) {
                image = "https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=400&q=80";
            }
            if (description == null || description.trim().isEmpty()) {
                description = "Sản phẩm tươi ngon đảm bảo tiêu chuẩn an toàn thực phẩm.";
            }

            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    Long id = Long.parseLong(idStr.trim());
                    Product existing = productService.getProductById(id);
                    if (existing != null) {
                        existing.setName(name);
                        existing.setCategory(category);
                        existing.setPrice(price);
                        existing.setCount(count);
                        existing.setImage(image);
                        existing.setDescription(description);
                        productService.updateProduct(existing);
                    }
                } catch (Exception ignored) {}
            } else {
                Product newProd = new Product(name, category, price, count, image, description, null);
                productService.saveProduct(newProd);
            }
            response.sendRedirect(request.getContextPath() + "/admin?tab=products");

        } else if ("saveVendor".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            String shopCode = request.getParameter("shopCode");
            String shopName = request.getParameter("shopName");
            String contactPerson = request.getParameter("contactPerson");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            String ratingStr = request.getParameter("rating");
            String status = request.getParameter("status");

            double rating = 4.8;
            try {
                if (ratingStr != null && !ratingStr.trim().isEmpty()) {
                    rating = Double.parseDouble(ratingStr.trim());
                }
            } catch (Exception ignored) {}

            if (status == null || status.trim().isEmpty()) {
                status = "Approved";
            }

            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    Long id = Long.parseLong(idStr.trim());
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
                        existing.setRating(rating);
                        existing.setStatus(status);
                        vendorService.updateVendor(existing);
                    }
                } catch (Exception ignored) {}
            } else {
                if (shopCode == null || shopCode.trim().isEmpty()) {
                    shopCode = "VND-" + (System.currentTimeMillis() % 10000);
                }
                Vendor newV = new Vendor(shopCode, shopName, contactPerson, email, phone, 
                        address, category, description, rating, status, null);
                vendorService.saveVendor(newV);
            }
            response.sendRedirect(request.getContextPath() + "/admin?tab=vendors");

        } else if ("updateOrderStatus".equalsIgnoreCase(action)) {
            String redirectUrl = request.getParameter("redirect");
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                String status = request.getParameter("status");
                orderService.updateOrderStatus(id, status);
            } catch (Exception ignored) {}
            if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/" + redirectUrl);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin?tab=orders");
            }

        } else {
            response.sendRedirect(request.getContextPath() + "/admin");
        }
    }
}