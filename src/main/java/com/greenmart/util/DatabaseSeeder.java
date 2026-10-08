package com.greenmart.util;

import com.greenmart.entity.*;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import java.util.Arrays;
import java.util.List;

public class DatabaseSeeder {

    public static void main(String[] args) {
        System.out.println("==================================================");
        System.out.println(" Starting GreenMart Database Seeder (H2 DB)...");
        System.out.println("==================================================");

        SessionFactory sessionFactory = HibernateUtil.getSessionFactory();
        System.out.println("Hibernate SessionFactory initialized successfully.");

        Transaction tx = null;
        try (Session session = sessionFactory.openSession()) {
            tx = session.beginTransaction();

            session.doWork(conn -> {
                try (java.sql.Statement stmt = conn.createStatement()) {
                    try { stmt.execute("ALTER TABLE user ADD COLUMN IF NOT EXISTS phone VARCHAR(20)"); } catch (Exception ignored) {}
                    try { stmt.execute("ALTER TABLE user ADD COLUMN IF NOT EXISTS address VARCHAR(500)"); } catch (Exception ignored) {}
                    try {
                        stmt.execute("CREATE TABLE IF NOT EXISTS chat_message (" +
                                "id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
                                "sender_id BIGINT, " +
                                "receiver_id BIGINT, " +
                                "sender_name VARCHAR(100), " +
                                "receiver_name VARCHAR(100), " +
                                "content TEXT, " +
                                "created_at VARCHAR(50), " +
                                "is_read BOOLEAN DEFAULT FALSE" +
                                ")");
                    } catch (Exception ex) {
                        System.out.println("Notice creating chat_message table: " + ex.getMessage());
                    }
                } catch (Exception ex) {
                    System.out.println("Notice in doWork: " + ex.getMessage());
                }
            });

            System.out.println("Cleaning existing data before seeding...");
            try { session.createQuery("DELETE FROM ChatMessage").executeUpdate(); } catch (Exception ignored) {}
            session.createQuery("DELETE FROM OrderItem").executeUpdate();
            session.createQuery("DELETE FROM Order").executeUpdate();
            session.createQuery("DELETE FROM Product").executeUpdate();
            session.createQuery("DELETE FROM Category").executeUpdate();
            session.createQuery("DELETE FROM User").executeUpdate();
            session.createQuery("DELETE FROM Vendor").executeUpdate();
            session.createQuery("DELETE FROM Coupon").executeUpdate();
            session.createQuery("DELETE FROM UserRole").executeUpdate();

            // 1. Roles
            System.out.println("Seeding User Roles...");
            UserRole roleAdmin = new UserRole();
            roleAdmin.setRoleName("admin");
            session.save(roleAdmin);

            UserRole roleUser = new UserRole();
            roleUser.setRoleName("user");
            session.save(roleUser);

            // 2. Categories
            System.out.println("Seeding Categories...");
            Category catRauCu = new Category("Rau củ & Trái cây", "https://images.unsplash.com/photo-1610348725531-843dff563e2c?auto=format&fit=crop&w=400&q=80");
            Category catThitCa = new Category("Thịt, Cá & Trứng", "https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?auto=format&fit=crop&w=400&q=80");
            Category catDoUong = new Category("Đồ uống & Sữa", "https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=400&q=80");
            Category catBanhKeo = new Category("Bánh kẹo", "https://images.unsplash.com/photo-1587314168485-3236d6710814?auto=format&fit=crop&w=400&q=80");
            Category catKho = new Category("Thực phẩm khô", "https://images.unsplash.com/photo-1621996346565-e3d5d628169a?auto=format&fit=crop&w=400&q=80");

            for (Category cat : Arrays.asList(catRauCu, catThitCa, catDoUong, catBanhKeo, catKho)) {
                session.save(cat);
            }

            // 3. Users
            System.out.println("Seeding Users...");
            User userAdmin = new User("admin@greenmart.vn", "Admin GreenMart", "123456", "admin", "0901234567", "PTIT Km10 Nguyễn Trãi, Hà Đông, Hà Nội", "2026-09-01 08:00:00");
            User userAn = new User("an.nguyen@gmail.com", "Nguyễn Văn An", "123456", "user", "0987112233", "Số 12 Chùa Bộc, Đống Đa, Hà Nội", "2026-09-10 09:30:00");
            User userMai = new User("mai.tran@gmail.com", "Trần Thị Mai", "123456", "user", "0912445566", "Số 96A Trần Phú, Hà Đông, Hà Nội", "2026-09-12 14:15:00");
            User userNam = new User("nam.le@gmail.com", "Lê Hoàng Nam", "123456", "user", "0933557799", "Số 25 Cầu Giấy, Cầu Giấy, Hà Nội", "2026-09-15 11:20:00");

            session.save(userAdmin);
            session.save(userAn);
            session.save(userMai);
            session.save(userNam);

            // 4. Products
            System.out.println("Seeding Products...");
            Product p1 = new Product("Cà chua bi hữu cơ VietGAP hộp 500g", "Rau củ & Trái cây", 28000.0, 35,
                    "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=400&q=80",
                    "Cà chua ngọt thanh giòn mọng, giàu vitamin A và C, canh tác theo chuẩn hữu cơ VietGAP an toàn tuyệt đối.", "2026-09-15 10:00:00");

            Product p2 = new Product("Xà lách mỡ Đà Lạt thủy canh túi 400g", "Rau củ & Trái cây", 24000.0, 40,
                    "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=400&q=80",
                    "Rau xà lách mỡ tươi xanh, giòn ngọt tự nhiên, thích hợp làm salad trộn và ăn kèm các món cuốn.", "2026-09-15 10:05:00");

            Product p3 = new Product("Bí ngòi xanh hữu cơ Lâm Đồng 500g", "Rau củ & Trái cây", 19500.0, 25,
                    "https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=400&q=80",
                    "Bí ngòi xanh non, ngọt mát, thanh nhiệt, dùng xào tỏi hoặc nấu canh tôm thịt rất ngon.", "2026-09-15 10:10:00");

            Product p4 = new Product("Thịt heo nạc dăm CP tươi sạch 500g", "Thịt, Cá & Trứng", 75000.0, 20,
                    "https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?auto=format&fit=crop&w=400&q=80",
                    "Thịt heo nạc dăm mềm ngậy có xen kẽ vân mỡ mỏng, kiểm dịch an toàn thực phẩm 3F khép kín.", "2026-09-15 10:15:00");

            Product p5 = new Product("Trứng gà ta thảo mộc hộp 10 quả", "Thịt, Cá & Trứng", 39000.0, 60,
                    "https://images.unsplash.com/photo-1516448620398-c5f44bf9f441?auto=format&fit=crop&w=400&q=80",
                    "Trứng gà ta nuôi thả tự nhiên, lòng đỏ đậm đà, thơm bùi, giàu omega-3 và khoáng chất.", "2026-09-15 10:20:00");

            Product p6 = new Product("Cá hồi Na Uy phi lê tươi sống 300g", "Thịt, Cá & Trứng", 185000.0, 15,
                    "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=400&q=80",
                    "Cá hồi nhập khẩu Na Uy đạt chuẩn Sashimi, thịt săn chắc béo ngậy, dồi dào DHA cho gia đình.", "2026-09-15 10:25:00");

            Product p7 = new Product("Sữa tươi tiệt trùng ít đường Dalat Milk 180ml", "Đồ uống & Sữa", 34500.0, 80,
                    "https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=400&q=80",
                    "Sữa tươi sạch 100% từ đàn bò sữa cao nguyên Lâm Đồng, vị ngọt thanh tự nhiên và thơm ngậy.", "2026-09-15 10:30:00");

            Product p8 = new Product("Thùng 24 chai Nutriboost sữa chua Hy Lạp", "Đồ uống & Sữa", 210000.0, 20,
                    "https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?auto=format&fit=crop&w=400&q=80",
                    "Thức uống dinh dưỡng sữa chua Hy Lạp kết hợp hương vị việt quất thanh mát, bổ sung năng lượng.", "2026-09-15 10:35:00");

            Product p9 = new Product("Nước ép cam nguyên chất ép lạnh Le Fruit 1L", "Đồ uống & Sữa", 58000.0, 30,
                    "https://images.unsplash.com/photo-1613478223719-2ab802602423?auto=format&fit=crop&w=400&q=80",
                    "100% nước cam tươi nguyên chất không pha đường, giàu vitamin C hỗ trợ đề kháng.", "2026-09-15 10:40:00");

            Product p10 = new Product("Bánh bông lan cuộn Solite kem lá dứa 360g", "Bánh kẹo", 53500.0, 45,
                    "https://images.unsplash.com/photo-1587314168485-3236d6710814?auto=format&fit=crop&w=400&q=80",
                    "Bánh mềm xốp, thơm mùi lá dứa tự nhiên cuộn kem béo ngậy, bữa phụ tuyệt vời cho cả nhà.", "2026-09-15 10:45:00");

            Product p11 = new Product("Khô mực xé sợi Pichi cay ngọt gói 50g", "Bánh kẹo", 33000.0, 50,
                    "https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?auto=format&fit=crop&w=400&q=80",
                    "Mực khô xé cay cay ngọt ngọt, tẩm ướp gia vị đậm đà, món ăn vặt hấp dẫn mọi lứa tuổi.", "2026-09-15 10:50:00");

            Product p12 = new Product("Nui rau củ xoắn Safoco gói 300g", "Thực phẩm khô", 22500.0, 70,
                    "https://images.unsplash.com/photo-1621996346565-e3d5d628169a?auto=format&fit=crop&w=400&q=80",
                    "Nui xoắn chiết xuất từ bột gạo và tinh chất rau củ tự nhiên, tạo màu sắc bắt mắt và bổ dưỡng.", "2026-09-15 10:55:00");

            Product p13 = new Product("Gạo ST25 Ông Cua chính hãng túi 5kg", "Thực phẩm khô", 195000.0, 25,
                    "https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=400&q=80",
                    "Gạo ngon nhất thế giới ST25, hạt dài trắng trong, cơm dẻo mềm thơm mùi lá dứa đặc trưng.", "2026-09-15 11:00:00");

            List<Product> products = Arrays.asList(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13);
            for (Product p : products) {
                session.save(p);
            }

            // 5. Vendors
            System.out.println("Seeding Vendors...");
            session.save(createVendor("SHOP01", "Happy Food Store", "vendor1@greenmart.vn", "0987654321", "Approved", "2026-09-02 10:00:00"));
            session.save(createVendor("SHOP02", "Dalat Fresh Farm", "dalatfarm@greenmart.vn", "0912345678", "Approved", "2026-09-05 14:30:00"));
            session.save(createVendor("SHOP03", "Organic Hanoi Garden", "organic.hn@greenmart.vn", "0978888111", "Waiting", "2026-09-18 09:20:00"));
            session.save(createVendor("SHOP04", "Mekong Organic Fruits", "mekong@greenmart.vn", "0902345678", "Approved", "2026-09-19 16:45:00"));

            // 6. Coupons
            System.out.println("Seeding Coupons...");
            session.save(createCoupon("GREENMART10", "percent", 10.0, "Giảm 10% tổng đơn hàng", 1));
            session.save(createCoupon("SALE20", "percent", 20.0, "Giảm 20% đơn hàng khai trương", 1));
            session.save(createCoupon("CHAO50K", "fixed", 50000.0, "Giảm 50.000 đ đơn từ 200k", 1));
            session.save(createCoupon("FREESHIP", "fixed", 25000.0, "Miễn phí vận chuyển toàn quốc", 1));

            // 7. Orders & OrderItems
            System.out.println("Seeding Orders & Order Items...");

            // Order 1
            Order o1 = new Order();
            o1.setOrderCode("GM782914");
            o1.setUserId(userAn.getId());
            o1.setName("Nguyễn Văn An");
            o1.setPhone("0987112233");
            o1.setAddress("Số 12 Chùa Bộc, Đống Đa, Hà Nội");
            o1.setPaymentMethod("COD");
            o1.setSubtotal(103000.0);
            o1.setDiscount(10300.0);
            o1.setCouponCode("GREENMART10");
            o1.setTotal(92700.0);
            o1.setStatus("Completed");
            o1.setCreatedAt("2026-09-18 11:30:00");
            session.save(o1);

            session.save(createOrderItem(o1.getId(), p1.getId(), p1.getName(), p1.getPrice(), 1));
            session.save(createOrderItem(o1.getId(), p4.getId(), p4.getName(), p4.getPrice(), 1));

            // Order 2
            Order o2 = new Order();
            o2.setOrderCode("GM554129");
            o2.setUserId(userMai.getId());
            o2.setName("Trần Thị Mai");
            o2.setPhone("0912445566");
            o2.setAddress("Số 96A Trần Phú, Hà Đông, Hà Nội");
            o2.setPaymentMethod("BANK");
            o2.setSubtotal(244500.0);
            o2.setDiscount(0.0);
            o2.setCouponCode(null);
            o2.setTotal(244500.0);
            o2.setStatus("Shipping");
            o2.setCreatedAt("2026-09-20 15:45:00");
            session.save(o2);

            session.save(createOrderItem(o2.getId(), p7.getId(), p7.getName(), p7.getPrice(), 1));
            session.save(createOrderItem(o2.getId(), p8.getId(), p8.getName(), p8.getPrice(), 1));

            // Order 3
            Order o3 = new Order();
            o3.setOrderCode("GM902183");
            o3.setUserId(null);
            o3.setName("Lê Thị Thu");
            o3.setPhone("0977334455");
            o3.setAddress("Số 45 Nguyễn Trãi, Thanh Xuân, Hà Nội");
            o3.setPaymentMethod("COD");
            o3.setSubtotal(142000.0);
            o3.setDiscount(0.0);
            o3.setCouponCode(null);
            o3.setTotal(142000.0);
            o3.setStatus("Waiting");
            o3.setCreatedAt("2026-09-22 17:20:00");
            session.save(o3);

            session.save(createOrderItem(o3.getId(), p5.getId(), p5.getName(), p5.getPrice(), 2));
            session.save(createOrderItem(o3.getId(), p2.getId(), p2.getName(), p2.getPrice(), 1));
            session.save(createOrderItem(o3.getId(), p11.getId(), p11.getName(), p11.getPrice(), 1));

            // 8. Seed Chat Messages
            System.out.println("Seeding Sample Chat Messages...");
            ChatMessage m1 = new ChatMessage(userAn.getId(), userAn.getUsername(), userAdmin.getId(), userAdmin.getUsername(),
                    "Chào shop! Cho mình hỏi rau xà lách mỡ và cà chua bi đợt này còn tươi ngon không ạ?", "2026-09-18 09:30:00");
            ChatMessage m2 = new ChatMessage(userAdmin.getId(), userAdmin.getUsername(), userAn.getId(), userAn.getUsername(),
                    "Dạ chào anh An! Toàn bộ rau củ hữu cơ VietGAP bên em vừa thu hoạch sáng nay, cực kỳ tươi ngon anh nhé!", "2026-09-18 09:32:00");
            ChatMessage m3 = new ChatMessage(userAn.getId(), userAn.getUsername(), userAdmin.getId(), userAdmin.getUsername(),
                    "Tuyệt quá, mình vừa lên đơn rồi, shop đóng gói kỹ giúp mình nha.", "2026-09-18 09:35:00");
            ChatMessage m4 = new ChatMessage(userAdmin.getId(), userAdmin.getUsername(), userAn.getId(), userAn.getUsername(),
                    "Dạ vâng ạ, nhân viên GreenMart đang đóng gói bảo quản mát và giao ngay cho anh trong 2h ạ!", "2026-09-18 09:36:00");

            ChatMessage m5 = new ChatMessage(userMai.getId(), userMai.getUsername(), userAdmin.getId(), userAdmin.getUsername(),
                    "Shop ơi, cửa hàng mình có hỗ trợ xuất hoá đơn điện tử cho công ty không ạ?", "2026-09-20 14:10:00");
            ChatMessage m6 = new ChatMessage(userAdmin.getId(), userAdmin.getUsername(), userMai.getId(), userMai.getUsername(),
                    "Dạ chào chị Mai, bên em có hỗ trợ xuất hoá đơn đỏ VAT đầy đủ ạ. Chị chỉ cần để lại thông tin MST và email công ty ở ghi chú đơn hàng là được nhé!", "2026-09-20 14:15:00");

            session.save(m1);
            session.save(m2);
            session.save(m3);
            session.save(m4);
            session.save(m5);
            session.save(m6);

            session.flush();
            tx.commit();

            // Print summary statistics
            Long roleCount = session.createQuery("SELECT COUNT(r) FROM UserRole r", Long.class).uniqueResult();
            Long catCount = session.createQuery("SELECT COUNT(c) FROM Category c", Long.class).uniqueResult();
            Long userCount = session.createQuery("SELECT COUNT(u) FROM User u", Long.class).uniqueResult();
            Long prodCount = session.createQuery("SELECT COUNT(p) FROM Product p", Long.class).uniqueResult();
            Long vendorCount = session.createQuery("SELECT COUNT(v) FROM Vendor v", Long.class).uniqueResult();
            Long couponCount = session.createQuery("SELECT COUNT(cp) FROM Coupon cp", Long.class).uniqueResult();
            Long orderCount = session.createQuery("SELECT COUNT(o) FROM Order o", Long.class).uniqueResult();
            Long itemCount = session.createQuery("SELECT COUNT(oi) FROM OrderItem oi", Long.class).uniqueResult();

            System.out.println("==================================================");
            System.out.println(" Database seeded successfully for H2 Database!");
            System.out.println(" Summary of seeded records:");
            System.out.println("  - Roles:       " + roleCount);
            System.out.println("  - Categories:  " + catCount);
            System.out.println("  - Users:       " + userCount);
            System.out.println("  - Products:    " + prodCount);
            System.out.println("  - Vendors:     " + vendorCount);
            System.out.println("  - Coupons:     " + couponCount);
            System.out.println("  - Orders:      " + orderCount);
            System.out.println("  - Order Items: " + itemCount);
            System.out.println("==================================================");
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.err.println("Error while seeding database: " + e.getMessage());
            e.printStackTrace();
        } finally {
            HibernateUtil.shutdown();
        }
    }

    private static Vendor createVendor(String shopCode, String shopName, String email, String phone, String status, String registeredAt) {
        Vendor v = new Vendor();
        v.setShopCode(shopCode);
        v.setShopName(shopName);
        v.setEmail(email);
        v.setPhone(phone);
        v.setStatus(status);
        v.setRegisteredAt(registeredAt);
        return v;
    }

    private static Coupon createCoupon(String code, String type, Double value, String label, Integer active) {
        Coupon c = new Coupon();
        c.setCode(code);
        c.setType(type);
        c.setValue(value);
        c.setLabel(label);
        c.setActive(active);
        return c;
    }

    private static OrderItem createOrderItem(Long orderId, Long productId, String productName, Double productPrice, Integer quantity) {
        OrderItem item = new OrderItem();
        item.setOrderId(orderId);
        item.setProductId(productId);
        item.setProductName(productName);
        item.setProductPrice(productPrice);
        item.setQuantity(quantity);
        return item;
    }
}