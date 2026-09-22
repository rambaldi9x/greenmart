package com.greenmart.controller;

import com.greenmart.entity.Product;
import com.greenmart.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home", ""})
public class HomeServlet extends HttpServlet {
    private ProductService productService;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String category = request.getParameter("category");
        String keyword = request.getParameter("keyword");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String detailIdStr = request.getParameter("detailId");

        List<Product> products = productService.filterProducts(category, keyword, minPriceStr, maxPriceStr);

        if (detailIdStr != null && !detailIdStr.trim().isEmpty()) {
            try {
                Long detailId = Long.parseLong(detailIdStr.trim());
                Product selectedProduct = productService.getProductById(detailId);
                request.setAttribute("selectedProduct", selectedProduct);
            } catch (Exception ignored) {}
        }

        String activeSlug = ProductService.mapDbNameToSlug(category);

        request.setAttribute("products", products);
        request.setAttribute("category", activeSlug);
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("minPrice", minPriceStr != null ? minPriceStr : "");
        request.setAttribute("maxPrice", maxPriceStr != null ? maxPriceStr : "");

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}