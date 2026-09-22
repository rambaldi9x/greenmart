# GREENMART PTIT - HỆ THỐNG WEBSITE BÁN THỰC PHẨM SẠCH VÀ HỮU CƠ

> **Báo cáo Đồ án môn học:** Lập trình Web  
> **Đơn vị:** Học viện Công nghệ Bưu chính Viễn thông (PTIT)  
> **Giảng viên hướng dẫn:** ThS. Phạm Quang Hiếu  
> **Kiến trúc ứng dụng:** Java Servlet (Java EE), JSP/JSTL, Hibernate ORM, MySQL Database (MVC Architecture)

---

## 1. Giới thiệu tổng quan dự án

**GreenMart** là nền tảng thương mại điện tử chuyên cung cấp thực phẩm tươi sạch đạt chuẩn VietGAP và hữu cơ. Hệ thống được xây dựng theo mô hình **MVC (Model - View - Controller)** chuẩn mực trong Java Web:
- **Không sử dụng file JavaScript (`.js`)**: Toàn bộ luồng điều hướng, xử lý logic, quản lý giỏ hàng, xác thực tài khoản và phân quyền đều được kiểm soát 100% tại tầng Backend bằng **Java Servlet** và **Java HttpSession**.
- **Xử lý URL-Safe thông minh**: Khắc phục triệt để lỗi phân tách tham số của ký tự `&` trong HTTP GET bằng cơ chế Category Slug (`rau-cu`, `thit-ca-trung`, `do-uong-sua`, `banh-keo`, `thuc-pham-kho`), đồng thời hỗ trợ tự động ánh xạ ngược về tên cơ sở dữ liệu.
- **Bộ lọc ký tự UTF-8 toàn diện**: Sử dụng `EncodingFilter` đảm bảo dữ liệu tiếng Việt có dấu luôn chính xác trên tất cả các request/response.

---

## 2. Công nghệ và Thư viện sử dụng

| Thành phần | Công nghệ / Thư viện | Vai trò |
|------------|----------------------|---------|
| **Ngôn ngữ** | Java (JDK 8 trở lên) | Xử lý logic nghiệp vụ phía server |
| **Kiến trúc** | Java Servlet 4.0, JSP 2.3, JSTL 1.2 | Xây dựng Controller và View theo mô hình MVC |
| **ORM Framework** | Hibernate 5.6.15.Final | Ánh xạ đối tượng quan hệ (ORM) với MySQL |
| **Cơ sở dữ liệu** | MySQL 8.0 | Lưu trữ dữ liệu hệ thống (Users, Products, Orders, Vendors, Coupons) |
| **Quản lý dự án** | Apache Maven | Quản lý vòng đời build, dependencies và đóng gói WAR |
| **Embedded Server** | Tomcat 7 Maven Plugin | Hỗ trợ chạy ứng dụng trực tiếp từ dòng lệnh |
| **Giao diện (Frontend)** | HTML5, CSS3, Font Awesome 6.4 | Giao diện responsive không phụ thuộc JavaScript |

---

## 3. Cấu trúc thư mục dự án

```text
Nhom_LTW_GreenMart_PTIT/
├── pom.xml                                      # File cấu hình Maven (Dependencies, Plugins WAR, Tomcat7)
├── docker-compose.yml                           # Cấu hình container MySQL 8.0
├── sql/
│   └── greenmart.sql                            # Kịch bản DDL tạo bảng + DML import dữ liệu mẫu chuẩn UTF-8
├── database/
│   └── schema_mysql.sql                         # Bản sao lưu trữ kịch bản CSDL
├── src/main/
│   ├── java/com/greenmart/
│   │   ├── controller/                          # Tầng Controller (Java Servlets)
│   │   │   ├── HomeServlet.java                 # Điều hướng trang chủ, lọc danh mục, tìm kiếm, xem chi tiết
│   │   │   ├── AuthServlet.java                 # Đăng nhập, đăng ký, đăng xuất (quản lý qua HttpSession)
│   │   │   ├── CartServlet.java                 # Quản lý giỏ hàng, cập nhật số lượng, áp mã giảm giá, đặt hàng
│   │   │   └── AdminServlet.java                # Bảng điều khiển quản trị, CRUD sản phẩm, duyệt đơn, duyệt vendor
│   │   ├── entity/                              # Tầng Entity (Hibernate JPA Annotations)
│   │   │   ├── Category.java                    # Entity Danh mục
│   │   │   ├── Coupon.java                      # Entity Mã khuyến mãi
│   │   │   ├── Order.java                       # Entity Đơn đặt hàng
│   │   │   ├── OrderItem.java                   # Entity Chi tiết mặt hàng trong đơn
│   │   │   ├── Product.java                     # Entity Sản phẩm
│   │   │   ├── User.java                        # Entity Người dùng
│   │   │   ├── UserRole.java                    # Entity Vai trò
│   │   │   └── Vendor.java                      # Entity Nhà bán hàng / Đối tác
│   │   ├── filter/                              # Tầng Filter lọc request
│   │   │   └── EncodingFilter.java              # Filter chuẩn hóa UTF-8 cho toàn bộ request/response
│   │   ├── model/                               # Tầng Model hỗ trợ phiên làm việc
│   │   │   ├── Cart.java                        # Đối tượng Giỏ hàng trong HttpSession
│   │   │   └── CartItem.java                    # Đối tượng sản phẩm trong giỏ hàng
│   │   ├── repository/                          # Tầng Data Access (Thao tác với Hibernate Session)
│   │   │   ├── ProductRepository.java           # Thao tác CRUD sản phẩm
│   │   │   ├── UserRepository.java              # Thao tác tài khoản người dùng
│   │   │   ├── OrderRepository.java             # Thao tác lưu đơn hàng và chi tiết đơn hàng
│   │   │   ├── VendorRepository.java            # Thao tác thông tin và trạng thái vendor
│   │   │   └── CouponRepository.java            # Truy vấn mã giảm giá
│   │   ├── service/                             # Tầng Service (Xử lý nghiệp vụ logic)
│   │   │   ├── ProductService.java              # Lọc sản phẩm, ánh xạ category slug, CRUD sản phẩm
│   │   │   ├── UserService.java                 # Đăng nhập, đăng ký, kiểm tra tài khoản
│   │   │   ├── OrderService.java                # Tạo đơn hàng, tự động trừ số lượng kho, cập nhật trạng thái
│   │   │   ├── VendorService.java               # Xử lý duyệt / từ chối đối tác
│   │   │   └── CouponService.java               # Xác thực và tính toán giá trị khuyến mãi
│   │   └── util/                                # Tiện ích hệ thống
│   │       ├── HibernateUtil.java               # Quản lý SessionFactory kết nối CSDL
│   │       └── TestDB.java                      # File kiểm thử kết nối CSDL và bộ lọc độc lập
│   ├── resources/
│   │   ├── application.properties               # Cấu hình kết nối MySQL và Hibernate
│   │   └── schema_mysql.sql                     # Tài nguyên kịch bản SQL nội bộ
│   └── webapp/                                  # Tầng View (Giao diện JSP thuần)
│       ├── WEB-INF/
│       │   └── web.xml                          # Cấu hình Web App, Welcome File và Bộ lọc
│       ├── css/
│       │   └── style.css                        # Toàn bộ CSS giao diện người dùng và admin
│       ├── index.jsp                            # Giao diện Trang chủ, danh sách sản phẩm, modal chi tiết
│       ├── cart.jsp                             # Giao diện Giỏ hàng, áp mã giảm giá, biểu mẫu đặt hàng
│       ├── login.jsp                            # Giao diện Đăng nhập & Đăng ký tài khoản
│       └── admin.jsp                            # Giao diện Bảng điều khiển Quản trị viên (5 Tabs chức năng)
└── README.md                                    # Tài liệu hướng dẫn dự án chi tiết
```

---

## 4. Các chức năng chính của hệ thống

### 4.1. Khách hàng (Dành cho người dùng)
1. **Trang chủ & Tìm kiếm**:
   - Duyệt danh sách sản phẩm phân loại theo từng danh mục.
   - Tìm kiếm sản phẩm theo từ khóa (tên, phân loại).
   - Lọc sản phẩm theo khoảng giá tùy chỉnh (từ giá tối thiểu đến giá tối đa).
   - Danh mục hiển thị bằng URL slug thân thiện (`home?category=rau-cu`), an toàn, không bị lỗi ký tự `&`.
2. **Xem chi tiết sản phẩm**:
   - Xem thông tin đầy đủ về nguồn gốc, giá bán, mô tả dinh dưỡng và số lượng tồn kho.
3. **Giỏ hàng & Đặt hàng (Session-based Cart)**:
   - Thêm sản phẩm vào giỏ hàng trực tiếp từ trang chủ hoặc chi tiết sản phẩm.
   - Tăng/giảm số lượng từng mặt hàng, xóa sản phẩm khỏi giỏ hàng.
   - Áp dụng mã khuyến mãi (giảm `%` hoặc giảm tiền mặt trực tiếp).
   - Điền thông tin giao hàng (họ tên, SĐT, địa chỉ, phương thức COD hoặc chuyển khoản QR).
   - **Tự động trừ số lượng kho**: Sau khi đặt hàng thành công, hệ thống tự động trừ số lượng tồn kho trong database.
4. **Tài khoản cá nhân**:
   - Đăng ký tài khoản mới với kiểm tra ràng buộc mật khẩu.
   - Đăng nhập hệ thống, lưu trạng thái người dùng trong phiên làm việc.
   - Đăng xuất an toàn.

### 4.2. Quản trị viên (Dành cho Admin)
- **Kiểm soát quyền truy cập**: Tự động chuyển hướng về trang đăng nhập nếu người dùng chưa xác thực hoặc không mang vai trò `admin`.
- **Tab 1 - Báo cáo & Thống kê (Dashboard)**:
  - Thống kê tổng doanh thu thực tế từ các đơn hàng.
  - Tổng số đơn hàng, tổng số mặt hàng đang bán, số đối tác Vendor đã duyệt.
  - Danh sách 5 đơn hàng mới nhất kèm trạng thái trực quan.
- **Tab 2 - Quản lý sản phẩm (Products CRUD)**:
  - Thêm mới sản phẩm (tên, danh mục, giá bán, tồn kho, link ảnh, mô tả).
  - Chỉnh sửa thông tin sản phẩm có sẵn.
  - Xóa sản phẩm khỏi cơ sở dữ liệu.
  - Tìm kiếm nhanh sản phẩm theo từ khóa.
- **Tab 3 - Quản lý đơn hàng (Orders Management)**:
  - Xem toàn bộ danh sách đơn đặt hàng từ khách hàng.
  - Cập nhật trạng thái đơn hàng (`Chờ duyệt`, `Đã xác nhận`, `Đang giao hàng`, `Hoàn tất`, `Hủy đơn`).
  - Xem chi tiết từng đơn: danh sách sản phẩm, đơn giá, số lượng, giảm giá, thông tin người nhận.
  - Xóa đơn hàng khi cần.
- **Tab 4 - Quản lý nhà cung cấp (Vendors Management)**:
  - Xem danh sách cửa hàng đăng ký bán hàng trên sàn GreenMart.
  - Duyệt đơn đăng ký (`Approved`), Từ chối (`Rejected`) hoặc Đặt lại về chờ duyệt (`Waiting`).
- **Tab 5 - Quản lý người dùng (Users Management)**:
  - Danh sách tài khoản đã đăng ký trên hệ thống.
  - Phân định rõ vai trò `Admin` và `Khách hàng`.
  - Cho phép xóa tài khoản người dùng thông thường (khóa bảo vệ không cho xóa Admin).

---

## 5. Hướng dẫn cài đặt và khởi chạy hệ thống

### 5.1. Yêu cầu môi trường
- **Java**: JDK 8 trở lên (khuyến nghị Java 8, 11 hoặc 17).
- **Maven**: Apache Maven 3.6 trở lên.
- **MySQL**: Phiên bản 8.0 (hoặc sử dụng Docker Compose tích hợp sẵn).

### 5.2. Khởi động Cơ sở dữ liệu MySQL

#### Cách 1: Sử dụng Docker Compose (Khuyên dùng)
Tại thư mục gốc của dự án, mở PowerShell/Terminal và chạy:
```powershell
docker-compose up -d
```

Sau đó nạp dữ liệu mẫu từ file `sql/greenmart.sql`:
```powershell
docker cp sql/greenmart.sql my_mysql_container:/tmp/greenmart.sql
docker exec my_mysql_container mysql -u greenmart -pgreenmart --default-character-set=utf8mb4 -e "source /tmp/greenmart.sql;"
```

#### Cách 2: Sử dụng MySQL Server cài đặt trên máy
1. Mở MySQL Workbench hoặc MySQL CLI.
2. Nạp toàn bộ nội dung file `sql/greenmart.sql`:
```powershell
mysql -u root -p < sql/greenmart.sql
```
*(Nếu thông tin kết nối MySQL khác mặc định, vui lòng cập nhật lại tại `src/main/resources/application.properties`).*

### 5.3. Build và Chạy ứng dụng

#### Bước 1: Build gói đóng gói WAR chuẩn bằng Maven
```powershell
mvn clean package
```
- Kết quả: Tạo file `target/greenmart-ptit.war` chuẩn mực.

#### Bước 2: Khởi chạy ứng dụng trực tiếp bằng Tomcat Plugin
```powershell
mvn tomcat7:run
```

Sau khi server khởi động thành công, mở trình duyệt web và truy cập:
👉 **`http://localhost:8080`** hoặc **`http://localhost:8080/home`**

---

## 6. Danh sách URL điều hướng chính

| Trang chức năng | Đường dẫn (URL) | Quyền hạn |
|-----------------|-----------------|-----------|
| **Trang chủ & Mua sắm** | `http://localhost:8080/home` (hoặc `/`) | Mọi người |
| **Giỏ hàng & Thanh toán** | `http://localhost:8080/cart` | Mọi người |
| **Đăng nhập & Đăng ký** | `http://localhost:8080/auth` (hoặc `/login`) | Mọi người |
| **Đăng xuất tài khoản** | `http://localhost:8080/auth?action=logout` | Đã đăng nhập |
| **Bảng quản trị Admin** | `http://localhost:8080/admin` | Tài khoản Admin |
| **Quản trị Sản phẩm** | `http://localhost:8080/admin?tab=products` | Tài khoản Admin |
| **Quản trị Đơn hàng** | `http://localhost:8080/admin?tab=orders` | Tài khoản Admin |
| **Quản trị Nhà bán hàng** | `http://localhost:8080/admin?tab=vendors` | Tài khoản Admin |
| **Quản trị Người dùng** | `http://localhost:8080/admin?tab=users` | Tài khoản Admin |

---

## 7. Dữ liệu thử nghiệm (Demo Credentials)

### 7.1. Tài khoản đăng nhập
| Vai trò | Email đăng nhập | Mật khẩu | Quyền hạn truy cập |
|---------|-----------------|----------|-------------------|
| **Quản trị viên (Admin)** | `admin@greenmart.vn` | `123456` | Toàn quyền quản trị hệ thống (`/admin`) |
| **Khách hàng mẫu 1** | `an.nguyen@gmail.com` | `123456` | Mua hàng, xem đơn cá nhân |
| **Khách hàng mẫu 2** | `mai.tran@gmail.com` | `123456` | Mua hàng, xem đơn cá nhân |

*(Người dùng cũng có thể tự đăng ký tài khoản mới tự do tại trang Đăng ký).*

### 7.2. Mã giảm giá thử nghiệm
- **`GREENMART10`**: Giảm 10% trên tổng giá trị giỏ hàng.
- **`SALE20`**: Giảm 20% cho đơn hàng.
- **`CHAO50K`**: Giảm trực tiếp 50.000 VNĐ.
- **`FREESHIP`**: Giảm phí vận chuyển 25.000 VNĐ.

---

## 8. Kết luận & Đánh giá môn học

Dự án **GreenMart PTIT** đáp ứng đầy đủ và vượt trội các yêu cầu môn học **Lập trình Web**:
- Thực hiện đầy đủ mô hình MVC thuần chuẩn với Java Servlet & JSP JSTL.
- Loại bỏ toàn bộ JavaScript phía client theo đúng định hướng Java-driven, nâng cao khả năng kiểm soát dữ liệu tại Server.
- Xử lý các vấn đề thực tế như mã hóa ký tự UTF-8 tiếng Việt, phân tách tham số đặc biệt `&`, giao dịch CSDL với Hibernate ORM và phân quyền tài khoản chặt chẽ.
