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
        long approvedVendorsCount = vendors.stream()
                .filter(v -> "Approved".equalsIgnoreCase(v.getStatus()))
                .count();

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", orders.size());
        request.setAttribute("waitingOrdersCount", waitingOrdersCount);
        request.setAttribute("confirmedOrdersCount", confirmedOrdersCount);
        request.setAttribute("shippingOrdersCount", shippingOrdersCount);
        request.setAttribute("completedOrdersCount", completedOrdersCount);
        request.setAttribute("canceledOrdersCount", canceledOrdersCount);
        request.setAttribute("totalProducts", products.size());
        request.setAttribute("totalVendors", approvedVendorsCount);

        if ("products".equalsIgnoreCase(tab)) {
            String search = request.getParameter("search");
            if (search != null && !search.trim().isEmpty()) {
                String kw = search.trim().toLowerCase();
                products = products.stream()
                        .filter(p -> (p.getName() != null && p.getName().toLowerCase().contains(kw))
                                || (p.getCategory() != null && p.getCategory().toLowerCase().contains(kw)))
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