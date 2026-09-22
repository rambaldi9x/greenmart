-- =====================================================================
--  DỰ ÁN LẬP TRÌNH WEB: HỆ THỐNG GREENMART PTIT
--  HỆ THỐNG CƠ SỞ DỮ LIỆU MYSQL (DDL + DML DATA IMPORT)
-- =====================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. KHỞI TẠO CƠ SỞ DỮ LIỆU
CREATE DATABASE IF NOT EXISTS `greenmart` 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

USE `greenmart`;

-- =====================================================================
--  PHẦN 1: DDL (DATA DEFINITION LANGUAGE) - TẠO CẤU TRÚC CÁC BẢNG
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Bảng Vai trò người dùng (user_roles)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `role_name` VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 2. Bảng Người dùng (users)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `role` VARCHAR(20) DEFAULT 'user',
  `created_at` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 3. Bảng Danh mục sản phẩm (categories)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `image` TEXT DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 4. Bảng Sản phẩm (products)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `category` VARCHAR(100) NOT NULL,
  `price` DOUBLE NOT NULL,
  `count` INT DEFAULT 100,
  `image` TEXT DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  `created_at` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 5. Bảng Nhà cung cấp / Đối tác (vendors)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS `vendors`;
CREATE TABLE `vendors` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `shop_code` VARCHAR(50) NOT NULL UNIQUE,
  `shop_name` VARCHAR(150) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `phone` VARCHAR(20) DEFAULT NULL,
  `status` VARCHAR(30) DEFAULT 'Waiting', -- 'Waiting', 'Approved', 'Rejected'
  `registered_at` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 6. Bảng Mã giảm giá (coupons)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS `coupons`;
CREATE TABLE `coupons` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(50) NOT NULL UNIQUE,
  `type` VARCHAR(20) NOT NULL, -- 'percent' hoặc 'fixed'
  `value` DOUBLE NOT NULL,
  `label` VARCHAR(150) NOT NULL,
  `active` INT DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 7. Bảng Đơn hàng (orders)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `order_code` VARCHAR(50) NOT NULL UNIQUE,
  `user_id` BIGINT DEFAULT NULL,
  `customer_name` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `address` TEXT NOT NULL,
  `payment_method` VARCHAR(30) DEFAULT 'COD',
  `subtotal` DOUBLE NOT NULL,
  `discount` DOUBLE DEFAULT 0,
  `coupon_code` VARCHAR(50) DEFAULT NULL,
  `total` DOUBLE NOT NULL,
  `status` VARCHAR(30) DEFAULT 'Waiting', -- 'Waiting', 'Confirmed', 'Shipping', 'Completed', 'Canceled'
  `created_at` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_orders_users` (`user_id`),
  CONSTRAINT `fk_orders_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 8. Bảng Chi tiết đơn hàng (order_items)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT NOT NULL,
  `product_id` BIGINT DEFAULT NULL,
  `product_name` VARCHAR(255) NOT NULL,
  `product_price` DOUBLE NOT NULL,
  `quantity` INT NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_order_items_orders` (`order_id`),
  KEY `fk_order_items_products` (`product_id`),
  CONSTRAINT `fk_order_items_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_order_items_products` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =====================================================================
--  PHẦN 2: DML (DATA MANIPULATION LANGUAGE) - IMPORT DỮ LIỆU MẪU
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Dữ liệu vai trò người dùng
-- ---------------------------------------------------------------------
INSERT INTO `user_roles` (`id`, `role_name`) VALUES
(1, 'admin'),
(2, 'user');

-- ---------------------------------------------------------------------
-- 2. Dữ liệu tài khoản người dùng
-- ---------------------------------------------------------------------
INSERT INTO `users` (`id`, `username`, `email`, `password`, `role`, `created_at`) VALUES
(1, 'Admin GreenMart', 'admin@greenmart.vn', '123456', 'admin', '2026-09-01 08:00:00'),
(2, 'Nguyễn Văn An', 'an.nguyen@gmail.com', '123456', 'user', '2026-09-10 09:30:00'),
(3, 'Trần Thị Mai', 'mai.tran@gmail.com', '123456', 'user', '2026-09-12 14:15:00'),
(4, 'Lê Hoàng Nam', 'nam.le@gmail.com', '123456', 'user', '2026-09-15 11:20:00');

-- ---------------------------------------------------------------------
-- 3. Dữ liệu danh mục sản phẩm
-- ---------------------------------------------------------------------
INSERT INTO `categories` (`id`, `name`, `image`) VALUES
(1, 'Rau củ & Trái cây', 'https://images.unsplash.com/photo-1610348725531-843dff563e2c?auto=format&fit=crop&w=400&q=80'),
(2, 'Thịt, Cá & Trứng', 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?auto=format&fit=crop&w=400&q=80'),
(3, 'Đồ uống & Sữa', 'https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=400&q=80'),
(4, 'Bánh kẹo', 'https://images.unsplash.com/photo-1587314168485-3236d6710814?auto=format&fit=crop&w=400&q=80'),
(5, 'Thực phẩm khô', 'https://images.unsplash.com/photo-1621996346565-e3d5d628169a?auto=format&fit=crop&w=400&q=80');

-- ---------------------------------------------------------------------
-- 4. Dữ liệu sản phẩm tươi ngon
-- ---------------------------------------------------------------------
INSERT INTO `products` (`id`, `name`, `category`, `price`, `count`, `image`, `description`, `created_at`) VALUES
(1, 'Cà chua bi hữu cơ VietGAP hộp 500g', 'Rau củ & Trái cây', 28000, 35, 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=400&q=80', 'Cà chua ngọt thanh giòn mọng, giàu vitamin A và C, canh tác theo chuẩn hữu cơ VietGAP an toàn tuyệt đối.', '2026-09-15 10:00:00'),
(2, 'Xà lách mỡ Đà Lạt thủy canh túi 400g', 'Rau củ & Trái cây', 24000, 40, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=400&q=80', 'Rau xà lách mỡ tươi xanh, giòn ngọt tự nhiên, thích hợp làm salad trộn và ăn kèm các món cuốn.', '2026-09-15 10:05:00'),
(3, 'Bí ngòi xanh hữu cơ Lâm Đồng 500g', 'Rau củ & Trái cây', 19500, 25, 'https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=400&q=80', 'Bí ngòi xanh non, ngọt mát, thanh nhiệt, dùng xào tỏi hoặc nấu canh tôm thịt rất ngon.', '2026-09-15 10:10:00'),

(4, 'Thịt heo nạc dăm CP tươi sạch 500g', 'Thịt, Cá & Trứng', 75000, 20, 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?auto=format&fit=crop&w=400&q=80', 'Thịt heo nạc dăm mềm ngậy có xen kẽ vân mỡ mỏng, kiểm dịch an toàn thực phẩm 3F khép kín.', '2026-09-15 10:15:00'),
(5, 'Trứng gà ta thảo mộc hộp 10 quả', 'Thịt, Cá & Trứng', 39000, 60, 'https://images.unsplash.com/photo-1516448620398-c5f44bf9f441?auto=format&fit=crop&w=400&q=80', 'Trứng gà ta nuôi thả tự nhiên, lòng đỏ đậm đà, thơm bùi, giàu omega-3 và khoáng chất.', '2026-09-15 10:20:00'),
(6, 'Cá hồi Na Uy phi lê tươi sống 300g', 'Thịt, Cá & Trứng', 185000, 15, 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=400&q=80', 'Cá hồi nhập khẩu Na Uy đạt chuẩn Sashimi, thịt săn chắc béo ngậy, dồi dào DHA cho gia đình.', '2026-09-15 10:25:00'),

(7, 'Sữa tươi tiệt trùng ít đường Dalat Milk 180ml', 'Đồ uống & Sữa', 34500, 80, 'https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=400&q=80', 'Sữa tươi sạch 100% từ đàn bò sữa cao nguyên Lâm Đồng, vị ngọt thanh tự nhiên và thơm ngậy.', '2026-09-15 10:30:00'),
(8, 'Thùng 24 chai Nutriboost sữa chua Hy Lạp', 'Đồ uống & Sữa', 210000, 20, 'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?auto=format&fit=crop&w=400&q=80', 'Thức uống dinh dưỡng sữa chua Hy Lạp kết hợp hương vị việt quất thanh mát, bổ sung năng lượng.', '2026-09-15 10:35:00'),
(9, 'Nước ép cam nguyên chất ép lạnh Le Fruit 1L', 'Đồ uống & Sữa', 58000, 30, 'https://images.unsplash.com/photo-1613478223719-2ab802602423?auto=format&fit=crop&w=400&q=80', '100% nước cam tươi nguyên chất không pha đường, giàu vitamin C hỗ trợ đề kháng.', '2026-09-15 10:40:00'),

(10, 'Bánh bông lan cuộn Solite kem lá dứa 360g', 'Bánh kẹo', 53500, 45, 'https://images.unsplash.com/photo-1587314168485-3236d6710814?auto=format&fit=crop&w=400&q=80', 'Bánh mềm xốp, thơm mùi lá dứa tự nhiên cuộn kem béo ngậy, bữa phụ tuyệt vời cho cả nhà.', '2026-09-15 10:45:00'),
(11, 'Khô mực xé sợi Pichi cay ngọt gói 50g', 'Bánh kẹo', 33000, 50, 'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?auto=format&fit=crop&w=400&q=80', 'Mực khô xé cay cay ngọt ngọt, tẩm ướp gia vị đậm đà, món ăn vặt hấp dẫn mọi lứa tuổi.', '2026-09-15 10:50:00'),

(12, 'Nui rau củ xoắn Safoco gói 300g', 'Thực phẩm khô', 22500, 70, 'https://images.unsplash.com/photo-1621996346565-e3d5d628169a?auto=format&fit=crop&w=400&q=80', 'Nui xoắn chiết xuất từ bột gạo và tinh chất rau củ tự nhiên, tạo màu sắc bắt mắt và bổ dưỡng.', '2026-09-15 10:55:00'),
(13, 'Gạo ST25 Ông Cua chính hãng túi 5kg', 'Thực phẩm khô', 195000, 25, 'https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=400&q=80', 'Gạo ngon nhất thế giới ST25, hạt dài trắng trong, cơm dẻo mềm thơm mùi lá dứa đặc trưng.', '2026-09-15 11:00:00');

-- ---------------------------------------------------------------------
-- 5. Dữ liệu nhà cung cấp / đối tác (vendors)
-- ---------------------------------------------------------------------
INSERT INTO `vendors` (`id`, `shop_code`, `shop_name`, `email`, `phone`, `status`, `registered_at`) VALUES
(1, 'SHOP01', 'Happy Food Store', 'vendor1@greenmart.vn', '0987654321', 'Approved', '2026-09-02 10:00:00'),
(2, 'SHOP02', 'Dalat Fresh Farm', 'dalatfarm@greenmart.vn', '0912345678', 'Approved', '2026-09-05 14:30:00'),
(3, 'SHOP03', 'Organic Hanoi Garden', 'organic.hn@greenmart.vn', '0978888111', 'Waiting', '2026-09-18 09:20:00'),
(4, 'SHOP04', 'Mekong Organic Fruits', 'mekong@greenmart.vn', '0902345678', 'Approved', '2026-09-19 16:45:00');

-- ---------------------------------------------------------------------
-- 6. Dữ liệu mã giảm giá (coupons)
-- ---------------------------------------------------------------------
INSERT INTO `coupons` (`id`, `code`, `type`, `value`, `label`, `active`) VALUES
(1, 'GREENMART10', 'percent', 10, 'Giảm 10% tổng đơn hàng', 1),
(2, 'SALE20', 'percent', 20, 'Giảm 20% đơn hàng khai trương', 1),
(3, 'CHAO50K', 'fixed', 50000, 'Giảm 50.000 đ đơn từ 200k', 1),
(4, 'FREESHIP', 'fixed', 25000, 'Miễn phí vận chuyển toàn quốc', 1);

-- ---------------------------------------------------------------------
-- 7. Dữ liệu đơn hàng mẫu (orders)
-- ---------------------------------------------------------------------
INSERT INTO `orders` (`id`, `order_code`, `user_id`, `customer_name`, `phone`, `address`, `payment_method`, `subtotal`, `discount`, `coupon_code`, `total`, `status`, `created_at`) VALUES
(1, 'GM782914', 2, 'Nguyễn Văn An', '0987112233', 'Số 12 Chùa Bộc, Đống Đa, Hà Nội', 'COD', 103000, 10300, 'GREENMART10', 92700, 'Completed', '2026-09-18 11:30:00'),
(2, 'GM554129', 3, 'Trần Thị Mai', '0912445566', 'Số 96A Trần Phú, Hà Đông, Hà Nội', 'BANK', 244500, 0, NULL, 244500, 'Shipping', '2026-09-20 15:45:00'),
(3, 'GM902183', NULL, 'Lê Thị Thu', '0977334455', 'Số 45 Nguyễn Trãi, Thanh Xuân, Hà Nội', 'COD', 142000, 0, NULL, 142000, 'Waiting', '2026-09-22 17:20:00');

-- ---------------------------------------------------------------------
-- 8. Dữ liệu chi tiết đơn hàng (order_items)
-- ---------------------------------------------------------------------
INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `product_name`, `product_price`, `quantity`) VALUES
(1, 1, 1, 'Cà chua bi hữu cơ VietGAP hộp 500g', 28000, 1),
(2, 1, 4, 'Thịt heo nạc dăm CP tươi sạch 500g', 75000, 1),
(3, 2, 7, 'Sữa tươi tiệt trùng ít đường Dalat Milk 180ml', 34500, 1),
(4, 2, 8, 'Thùng 24 chai Nutriboost sữa chua Hy Lạp', 210000, 1),
(5, 3, 5, 'Trứng gà ta thảo mộc hộp 10 quả', 39000, 2),
(6, 3, 2, 'Xà lách mỡ Đà Lạt thủy canh túi 400g', 24000, 1),
(7, 3, 11, 'Khô mực xé sợi Pichi cay ngọt gói 50g', 33000, 1);

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================================
--  HOÀN TẤT IMPORT CƠ SỞ DỮ LIỆU GREENMART
-- =====================================================================
