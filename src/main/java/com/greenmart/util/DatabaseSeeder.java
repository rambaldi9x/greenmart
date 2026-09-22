//package com.greenmart.util;
//
//import java.sql.Connection;
//import java.sql.DriverManager;
//import java.sql.Statement;
//
//public class DatabaseSeeder {
//    public static void main(String[] args) {
//        System.out.println("Initializing Hibernate to create tables...");
//        HibernateUtil.getSessionFactory(); // This triggers hbm2ddl=update
//        System.out.println("Hibernate initialization complete.");
//
//        String url = "jdbc:mysql://127.0.0.1:3306/greenmart?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&useUnicode=true&characterEncoding=UTF-8";
//        String user = "greenmart";
//        String pass = "greenmart";
//
//        try (Connection conn = DriverManager.getConnection(url, user, pass);
//             Statement stmt = conn.createStatement()) {
//
//            // Roles
//            stmt.executeUpdate("INSERT IGNORE INTO user_roles (role_name) VALUES ('admin'), ('user')");
//
//            // Categories
//            stmt.executeUpdate("INSERT IGNORE INTO categories (name, image) VALUES ('Thực phẩm khô', ''), ('Đồ uống & Sữa', ''), ('Bánh kẹo', ''), ('Rau củ & Trái cây', ''), ('Thịt, Cá & Trứng', '')");
//
//            // Admin
//            stmt.executeUpdate("INSERT IGNORE INTO users (email, username, password, role) VALUES ('admin@greenmart.vn', 'Admin GreenMart', '123456', 'admin')");
//
//            // Products
//            stmt.executeUpdate("INSERT IGNORE INTO products (name, category, price, count, image, description) VALUES ('Nui rau củ xoắn Safoco gói 300g', 'Thực phẩm khô', 22500, 50, 'https://images.unsplash.com/photo-1621996346565-e3d5d628169a?auto=format&fit=crop&w=400&q=80', 'Nui rau củ bổ dưỡng từ bột gạo và tinh bột khoai mì')");
//            stmt.executeUpdate("INSERT IGNORE INTO products (name, category, price, count, image, description) VALUES ('Sữa tươi tiệt trùng ít đường Dalat Milk 180ml', 'Đồ uống & Sữa', 34500, 80, 'https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=400&q=80', 'Sữa tươi sạch 100% từ cao nguyên Lâm Đồng')");
//            stmt.executeUpdate("INSERT IGNORE INTO products (name, category, price, count, image, description) VALUES ('Thùng 24 chai Nutriboost sữa chua Hy Lạp', 'Đồ uống & Sữa', 210000, 20, 'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?auto=format&fit=crop&w=400&q=80', 'Hương vị việt quất thanh mát')");
//            stmt.executeUpdate("INSERT IGNORE INTO products (name, category, price, count, image, description) VALUES ('Cà chua bi hữu cơ VietGAP hộp 500g', 'Rau củ & Trái cây', 28000, 0, 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=400&q=80', 'Cà chua ngọt thanh giòn mọng')");
//            stmt.executeUpdate("INSERT IGNORE INTO products (name, category, price, count, image, description) VALUES ('Thịt heo nạc dăm CP tươi ngon 500g', 'Thịt, Cá & Trứng', 75000, 15, 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?auto=format&fit=crop&w=400&q=80', 'Thịt heo tươi mới trong ngày')");
//            stmt.executeUpdate("INSERT IGNORE INTO products (name, category, price, count, image, description) VALUES ('Trứng gà ta thảo mộc hộp 10 quả', 'Thịt, Cá & Trứng', 39000, 60, 'https://images.unsplash.com/photo-1516448620398-c5f44bf9f441?auto=format&fit=crop&w=400&q=80', 'Trứng gà nuôi thả tự nhiên')");
//
//            // Vendors
//            stmt.executeUpdate("INSERT IGNORE INTO vendors (shop_code, shop_name, email, phone, status) VALUES ('SHOP01','Happy Food Store', 'vendor1@greenmart.vn', '0987654321','Approved')");
//            stmt.executeUpdate("INSERT IGNORE INTO vendors (shop_code, shop_name, email, phone, status) VALUES ('SHOP02','Dalat Fresh Farm', 'dalatfarm@greenmart.vn', '0912345678','Waiting')");
//
//            // Coupons
//            stmt.executeUpdate("INSERT IGNORE INTO coupons (code, type, value, label) VALUES ('GREENMART10','percent', 10, 'Giảm 10%')");
//            stmt.executeUpdate("INSERT IGNORE INTO coupons (code, type, value, label) VALUES ('CHAO50K','fixed', 50000, 'Giảm 50.000 đ')");
//
//            System.out.println("Data seeded successfully!");
//            HibernateUtil.shutdown();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//}