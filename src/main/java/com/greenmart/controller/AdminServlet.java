package com.greenmart.controller;

import com.greenmart.entity.Order;
import com.greenmart.entity.Product;
import com.greenmart.entity.User;
import com.greenmart.entity.Vendor;
import com.greenmart.model.AdminDashboardStats;
import com.greenmart.service.AdminService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {
    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        adminService = new AdminService();
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
                adminService.deleteProduct(id);
            } catch (Exception ignored) {}
            response.sendRedirect(request.getContextPath() + "/admin?tab=products");
            return;
        } else if ("deleteOrder".equalsIgnoreCase(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                adminService.deleteOrder(id);
            } catch (Exception ignored) {}
            response.sendRedirect(request.getContextPath() + "/admin?tab=orders");
            return;
        } else if ("deleteUser".equalsIgnoreCase(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                User currentUser = (User) request.getSession().getAttribute("user");
                adminService.deleteUser(id, currentUser != null ? currentUser.getId() : null);
            } catch (Exception ignored) {}
            response.sendRedirect(request.getContextPath() + "/admin?tab=users");
            return;
        } else if ("vendorStatus".equalsIgnoreCase(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                String status = request.getParameter("status");
                adminService.updateVendorStatus(id, status);
            } catch (Exception ignored) {}
            response.sendRedirect(request.getContextPath() + "/admin?tab=vendors");
            return;
        } else if ("deleteVendor".equalsIgnoreCase(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                adminService.deleteVendor(id);
            } catch (Exception ignored) {}
            response.sendRedirect(request.getContextPath() + "/admin?tab=vendors");
            return;
        }

        // Dashboard Stats
        AdminDashboardStats stats = adminService.getDashboardStats();
        stats.applyToRequest(request);

        // Filtered Lists for Tabs
        String categoryFilter = request.getParameter("categoryFilter");
        String stockFilter = request.getParameter("stockFilter");
        String prodSearch = request.getParameter("search");
        List<Product> products = adminService.getFilteredProducts(categoryFilter, stockFilter, prodSearch);

        String orderStatusFilter = request.getParameter("statusFilter");
        String orderSearch = request.getParameter("search");
        List<Order> orders = adminService.getFilteredOrders(orderStatusFilter, orderSearch);

        String vendorStatusFilter = request.getParameter("statusFilter");
        String vendorSearch = request.getParameter("search");
        List<Vendor> vendors = adminService.getFilteredVendors(vendorStatusFilter, vendorSearch);

        List<User> users = adminService.getAllUsers();

        // Modals / Specific actions
        if ("products".equalsIgnoreCase(tab)) {
            request.setAttribute("categoryFilter", categoryFilter);
            request.setAttribute("stockFilter", stockFilter);
            request.setAttribute("search", prodSearch);
            if ("edit".equalsIgnoreCase(action)) {
                try {
                    Long id = Long.parseLong(request.getParameter("id"));
                    request.setAttribute("editProduct", adminService.getProductById(id));
                } catch (Exception ignored) {}
            }
        } else if ("orders".equalsIgnoreCase(tab)) {
            request.setAttribute("statusFilter", orderStatusFilter);
            request.setAttribute("search", orderSearch);
            String viewOrderIdStr = request.getParameter("viewOrder");
            if (viewOrderIdStr != null) {
                try {
                    Long viewId = Long.parseLong(viewOrderIdStr);
                    request.setAttribute("viewOrderObj", adminService.getOrderById(viewId));
                } catch (Exception ignored) {}
            }
        } else if ("vendors".equalsIgnoreCase(tab)) {
            request.setAttribute("statusFilter", vendorStatusFilter);
            request.setAttribute("search", vendorSearch);
            String viewVendorIdStr = request.getParameter("viewVendor");
            if (viewVendorIdStr != null && !viewVendorIdStr.trim().isEmpty()) {
                try {
                    Long vId = Long.parseLong(viewVendorIdStr.trim());
                    request.setAttribute("viewVendorObj", adminService.getVendorById(vId));
                } catch (Exception ignored) {}
            }
            if ("editVendor".equalsIgnoreCase(action)) {
                try {
                    Long editId = Long.parseLong(request.getParameter("id"));
                    request.setAttribute("editVendorObj", adminService.getVendorById(editId));
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

            Long id = null;
            Double price = null;
            Integer count = null;
            try {
                if (idStr != null && !idStr.trim().isEmpty()) id = Long.parseLong(idStr.trim());
                if (priceStr != null && !priceStr.trim().isEmpty()) price = Double.parseDouble(priceStr.trim());
                if (countStr != null && !countStr.trim().isEmpty()) count = Integer.parseInt(countStr.trim());
            } catch (Exception ignored) {}

            adminService.saveOrUpdateProduct(id, name, category, price, count, image, description);
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

            Long id = null;
            Double rating = null;
            try {
                if (idStr != null && !idStr.trim().isEmpty()) id = Long.parseLong(idStr.trim());
                if (ratingStr != null && !ratingStr.trim().isEmpty()) rating = Double.parseDouble(ratingStr.trim());
            } catch (Exception ignored) {}

            adminService.saveOrUpdateVendor(id, shopCode, shopName, contactPerson, email, phone, address, category, description, rating, status);
            response.sendRedirect(request.getContextPath() + "/admin?tab=vendors");

        } else if ("updateOrderStatus".equalsIgnoreCase(action)) {
            String redirectUrl = request.getParameter("redirect");
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                String status = request.getParameter("status");
                adminService.updateOrderStatus(id, status);
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