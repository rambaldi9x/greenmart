package com.greenmart.service;

import com.greenmart.entity.Product;
import com.greenmart.repository.ProductRepository;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

public class ProductService {
    private ProductRepository productRepository;

    public ProductService() {
        this.productRepository = new ProductRepository();
    }

    public static String mapCategorySlugToDbName(String slugOrName) {
        if (slugOrName == null) return null;
        String s = slugOrName.trim().toLowerCase();
        if (s.isEmpty() || s.equals("all")) return null;

        if (s.equals("rau-cu") || s.contains("rau củ") || s.contains("trái cây")) {
            return "Rau củ & Trái cây";
        }
        if (s.equals("thit-ca-trung") || s.contains("thịt") || s.contains("cá") || s.contains("trứng")) {
            return "Thịt, Cá & Trứng";
        }
        if (s.equals("do-uong-sua") || s.contains("đồ uống") || s.contains("sữa")) {
            return "Đồ uống & Sữa";
        }
        if (s.equals("banh-keo") || s.contains("bánh kẹo")) {
            return "Bánh kẹo";
        }
        if (s.equals("thuc-pham-kho") || s.contains("thực phẩm khô")) {
            return "Thực phẩm khô";
        }
        return slugOrName.trim();
    }

    public static String mapDbNameToSlug(String name) {
        if (name == null) return "all";
        String s = name.trim().toLowerCase();
        if (s.isEmpty() || s.equals("all")) return "all";

        if (s.contains("rau củ") || s.contains("trái cây") || s.equals("rau-cu")) return "rau-cu";
        if (s.contains("thịt") || s.contains("cá") || s.contains("trứng") || s.equals("thit-ca-trung")) return "thit-ca-trung";
        if (s.contains("đồ uống") || s.contains("sữa") || s.equals("do-uong-sua")) return "do-uong-sua";
        if (s.contains("bánh kẹo") || s.equals("banh-keo")) return "banh-keo";
        if (s.contains("thực phẩm khô") || s.equals("thuc-pham-kho")) return "thuc-pham-kho";
        return s;
    }

    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    public List<Product> filterProducts(String category, String keyword, String minPriceStr, String maxPriceStr) {
        List<Product> products = productRepository.findAll();

        String targetCategory = mapCategorySlugToDbName(category);
        if (targetCategory != null && !targetCategory.equalsIgnoreCase("all")) {
            products = products.stream()
                    .filter(p -> p.getCategory() != null && (
                            p.getCategory().equalsIgnoreCase(targetCategory)
                            || p.getCategory().toLowerCase().contains(targetCategory.toLowerCase())
                    ))
                    .collect(Collectors.toList());
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim().toLowerCase();
            products = products.stream()
                    .filter(p -> p.getName() != null && p.getName().toLowerCase().contains(kw))
                    .collect(Collectors.toList());
        }

        if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
            try {
                double min = Double.parseDouble(minPriceStr.trim());
                products = products.stream()
                        .filter(p -> p.getPrice() != null && p.getPrice() >= min)
                        .collect(Collectors.toList());
            } catch (Exception ignored) {}
        }

        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
            try {
                double max = Double.parseDouble(maxPriceStr.trim());
                products = products.stream()
                        .filter(p -> p.getPrice() != null && p.getPrice() <= max)
                        .collect(Collectors.toList());
            } catch (Exception ignored) {}
        }

        return products;
    }

    public Product getProductById(Long id) {
        return productRepository.findById(id);
    }

    public void saveProduct(Product product) {
        if (product.getCreatedAt() == null) {
            product.setCreatedAt(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        }
        productRepository.save(product);
    }

    public void updateProduct(Product product) {
        productRepository.update(product);
    }

    public void deleteProduct(Long id) {
        productRepository.delete(id);
    }
}