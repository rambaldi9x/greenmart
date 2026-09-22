//package com.greenmart.util;
//
//import com.greenmart.entity.Product;
//import com.greenmart.entity.User;
//import com.greenmart.repository.ProductRepository;
//import com.greenmart.repository.UserRepository;
//import java.util.List;
//
//public class TestDB {
//    public static void main(String[] args) {
//        ProductRepository repo = new ProductRepository();
//        List<Product> products = repo.findAll();
//        System.out.println("Found products: " + products.size());
//        for (Product p : products) {
//            System.out.println("- " + p.getName());
//        }
//
//        com.greenmart.service.ProductService ps = new com.greenmart.service.ProductService();
//        System.out.println("Filter by 'rau-cu': " + ps.filterProducts("rau-cu", null, null, null).size());
//        System.out.println("Filter by 'Rau củ & Trái cây': " + ps.filterProducts("Rau củ & Trái cây", null, null, null).size());
//        System.out.println("Filter by 'Rau củ ' (truncated by &): " + ps.filterProducts("Rau củ ", null, null, null).size());
//        System.out.println("Filter by 'thit-ca-trung': " + ps.filterProducts("thit-ca-trung", null, null, null).size());
//        System.out.println("Filter by 'Thịt, Cá ' (truncated by &): " + ps.filterProducts("Thịt, Cá ", null, null, null).size());
//        System.out.println("Filter by 'do-uong-sua': " + ps.filterProducts("do-uong-sua", null, null, null).size());
//        System.out.println("Filter by 'all': " + ps.filterProducts("all", null, null, null).size());
//        System.exit(0);
//    }
//}