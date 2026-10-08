# GREENMART PTIT - HỆ THỐNG THƯƠNG MẠI ĐIỆN TỬ BÁN THỰC PHẨM SẠCH VÀ HỮU CƠ

> **Báo cáo Đồ án môn học:** Lập trình Web (LTW)  
> **Đơn vị:** Học viện Công nghệ Bưu chính Viễn thông (PTIT)  
> **Giảng viên hướng dẫn:** ThS. Phạm Quang Hiếu  
> **Kiến trúc ứng dụng:** Java Servlet 4.0, JSP 2.3, JSTL 1.2, Hibernate ORM 5.6, H2 Database / MySQL 8.0, MVC Architecture, Apache Tomcat Server

---

## 1. Giới thiệu tổng quan dự án

**GreenMart PTIT** là website thương mại điện tử chuyên cung cấp thực phẩm tươi sạch đạt chuẩn VietGAP và thực phẩm hữu cơ cao cấp. Dự án được nghiên cứu và phát triển theo mô hình kiến trúc **MVC (Model - View - Controller)** chuẩn mực của Java Enterprise (Java EE), tập trung tối đa vào độ ổn định, khả năng kiểm soát dữ liệu chặt chẽ ở tầng Backend và trải nghiệm người dùng hiện đại, trực quan:

- **Mô hình MVC phân tầng rõ ràng**: Tách bạch hoàn toàn giữa tầng Điều hướng (`Controller` - Servlets), tầng Nghiệp vụ (`Service`), tầng Truy cập CSDL (`Repository`), tầng Thực thể (`Entity`) và tầng Hiển thị (`View` - JSP/JSTL).
- **Hệ thống Chat tư vấn trực tuyến (Live Chat)**: Hỗ trợ trao đổi tin nhắn hai chiều giữa Khách hàng và Ban quản trị (Admin/CSKH) theo thời gian thực với tính năng gắn kèm mã đơn hàng, bộ chọn biểu tượng cảm xúc (Emoji), tìm kiếm hội thoại. Nút chat nổi dính đáy màn hình kiểu Shopee (`.gm-floating-dock`) luôn hiển thị mượt mà trên tất cả các trang.
- **Theo dõi tiến trình đơn hàng (Order Tracking)**: Cho phép khách hàng tra cứu tiến trình xử lý và vận chuyển đơn hàng bằng mã đơn (`#GM...`) hoặc số điện thoại với thanh tiến trình trực quan 4 bước (Đặt hàng ➔ Xác nhận ➔ Đang giao ➔ Hoàn tất).
- **Bảng điều khiển Quản trị hiện đại (Admin Dashboard)**: Trang quản trị được tái thiết kế toàn diện với 5 phân hệ: Thống kê doanh thu thực tế (chỉ tính đơn hoàn thành), Quản lý sản phẩm (CRUD), Quản lý & duyệt đơn hàng thông minh kèm hóa đơn in ấn, Quản lý nhà bán hàng (Vendor), Quản lý tài khoản người dùng.
- **Hỗ trợ đa nền tảng Cơ sở dữ liệu (H2 & MySQL)**: Tích hợp sẵn cơ sở dữ liệu nhúng **H2 Database** khởi động ngay không cần cài đặt thêm CSDL, đồng thời hỗ trợ **MySQL 8.0** qua Docker Compose cho môi trường triển khai thực tế.
- **Bảo mật và Phân quyền nghiêm ngặt**: Xác thực người dùng và kiểm soát vai trò qua `HttpSession`. Các liên kết yêu cầu quyền Admin sẽ tự động điều hướng về trang đăng nhập với thông báo cảnh báo rõ ràng và tự động chuyển tiếp trở lại sau khi đăng nhập thành công.
- **Xử lý URL-Safe & UTF-8 toàn diện**: Sử dụng cơ chế Category Slug (`rau-cu`, `thit-ca-trung`, `do-uong-sua`, `banh-keo`, `thuc-pham-kho`) loại bỏ hoàn toàn lỗi xung đột ký tự `&` trong HTTP GET; tích hợp `EncodingFilter` bảo đảm dữ liệu tiếng Việt có dấu luôn hiển thị chính xác.

---

## 2. Công nghệ và Thư viện sử dụng

| Thành phần | Công nghệ / Thư viện | Phiên bản | Vai trò & Mục đích sử dụng |
|------------|----------------------|-----------|---------------------------|
| **Ngôn ngữ nền tảng** | Java (JDK) | 1.8 / 11+ | Ngôn ngữ phát triển logic nghiệp vụ phía Server |
| **Web Framework** | Java Servlet | 4.0.1 | Điều hướng request, kiểm soát phiên và bảo mật (Controller) |
| **View Engine** | JSP & JSTL Core/Fmt/Fn | 2.3.3 / 1.2 | Xây dựng giao diện hiển thị dữ liệu động (View) |
| **ORM Framework** | Hibernate Core | 5.6.15.Final | Ánh xạ đối tượng quan hệ (ORM) và tự động quản lý schema CSDL |
| **Cơ sở dữ liệu 1** | H2 Database | 2.2.224 | CSDL nhúng dạng file/in-memory chạy ngay không cần cài đặt |
| **Cơ sở dữ liệu 2** | MySQL Connector/J | 8.0.33 | Trình điều khiển kết nối MySQL cho môi trường sản xuất |
| **JSON Processing** | Jackson Databind | 2.15.2 | Xử lý dữ liệu JSON cho các API chat và tra cứu đơn hàng |
| **Quản lý dự án** | Apache Maven | 3.6+ | Quản lý phụ thuộc (dependencies), biên dịch và đóng gói WAR |
| **Web Server** | Apache Tomcat | 9.0 / Maven Plugin 2.2 | Máy chủ ứng dụng chạy Servlet Container |
| **Frontend UI** | HTML5, CSS3, Font Awesome | 6.4.0 | Giao diện Responsive hiện đại, màu sắc nhận diện thương hiệu |

---

## 3. Cấu trúc thư mục dự án

```text
Nhom_LTW_GreenMart_PTIT/
├── pom.xml                                      # Quản lý dependencies (Servlet, JSP, JSTL, Hibernate, H2, MySQL)
├── docker-compose.yml                           # Kịch bản khởi chạy MySQL 8.0 container độc lập
├── README.md                                    # Tài liệu báo cáo đồ án chi tiết
├── sql/
│   └── greenmart.sql                            # Kịch bản DDL tạo bảng và DML nạp dữ liệu chuẩn UTF-8
├── src/main/
│   ├── java/com/greenmart/
│   │   ├── controller/                          # Tầng Controller (Java Servlets)
│   │   │   ├── HomeServlet.java                 # Trang chủ, xem danh mục (URL slug), tìm kiếm, chi tiết sản phẩm
│   │   │   ├── AuthServlet.java                 # Đăng nhập, đăng ký, đăng xuất, chuyển hướng bảo mật
│   │   │   ├── CartServlet.java                 # Quản lý giỏ hàng session, áp mã giảm giá, tạo đơn hàng COD/VietQR
│   │   │   ├── AdminServlet.java                # Bảng điều khiển quản trị, CRUD sản phẩm, duyệt đơn, vendor, user
│   │   │   ├── ChatServlet.java                 # Xử lý tin nhắn CSKH hai chiều, tìm kiếm hội thoại, polling
│   │   │   ├── OrderTrackingServlet.java        # Tra cứu tiến trình vận chuyển đơn hàng qua mã đơn hoặc SĐT
│   │   │   └── ProfileServlet.java              # Trang cá nhân người dùng, cập nhật thông tin và xem đơn đã đặt
│   │   ├── entity/                              # Tầng Entity (Hibernate JPA Entities)
│   │   │   ├── Category.java                    # Danh mục sản phẩm
│   │   │   ├── Product.java                     # Sản phẩm & số lượng tồn kho
│   │   │   ├── Order.java                       # Đơn đặt hàng & thông tin giao nhận
│   │   │   ├── OrderItem.java                   # Chi tiết từng mặt hàng trong đơn
│   │   │   ├── Coupon.java                      # Mã khuyến mãi giảm giá
│   │   │   ├── Vendor.java                      # Nhà cung cấp / Đối tác bán hàng
│   │   │   ├── User.java                        # Tài khoản người dùng hệ thống
│   │   │   ├── UserRole.java                    # Phân quyền vai trò (Admin / User)
│   │   │   └── ChatMessage.java                 # Bản ghi tin nhắn trao đổi khách hàng - CSKH
│   │   ├── filter/                              # Tầng Bộ lọc (Filters)
│   │   │   └── EncodingFilter.java              # Bộ lọc UTF-8 toàn diện cho mọi request/response
│   │   ├── model/                               # Tầng Model hỗ trợ phiên làm việc (Session Models)
│   │   │   ├── Cart.java                        # Đối tượng Giỏ hàng lưu trữ trong HttpSession
│   │   │   └── CartItem.java                    # Mặt hàng trong giỏ hàng (sản phẩm, số lượng, thành tiền)
│   │   ├── repository/                          # Tầng Data Access (Truy vấn CSDL qua Hibernate)
│   │   │   ├── ProductRepository.java           # CRUD sản phẩm, lọc theo danh mục và tìm kiếm từ khóa
│   │   │   ├── OrderRepository.java             # Quản lý đơn hàng, chi tiết đơn, truy vấn theo mã và SĐT
│   │   │   ├── UserRepository.java              # Xác thực tài khoản, CRUD người dùng
│   │   │   ├── VendorRepository.java            # Quản lý thông tin và trạng thái phê duyệt vendor
│   │   │   ├── CouponRepository.java            # Kiểm tra mã giảm giá và áp dụng khuyến mãi
│   │   │   └── ChatRepository.java              # Lưu trữ và truy xuất lịch sử tin nhắn hội thoại
│   │   ├── service/                             # Tầng Nghiệp vụ logic (Services)
│   │   │   ├── ProductService.java              # Ánh xạ slug danh mục, xử lý logic sản phẩm
│   │   │   ├── OrderService.java                # Tạo đơn, trừ số lượng tồn kho tự động, đối soát hoàn tất
│   │   │   ├── UserService.java                 # Logic đăng nhập, đăng ký, kiểm tra tài khoản hợp lệ
│   │   │   ├── VendorService.java               # Duyệt, từ chối và quản lý trạng thái nhà bán hàng
│   │   │   ├── CouponService.java               # Tính toán chiết khấu tiền mặt hoặc phần trăm
│   │   │   └── ChatService.java                 # Quản lý tin nhắn, lấy danh sách hội thoại của người dùng/Admin
│   │   └── util/                                # Tiện ích hệ thống (Utilities)
│   │       ├── HibernateUtil.java               # Khởi tạo và quản lý SessionFactory kết nối CSDL
│   │       └── DatabaseSeeder.java              # Tự động khởi tạo cấu trúc và nạp dữ liệu mẫu phong phú
│   ├── resources/
│   │   ├── application.properties               # Cấu hình chuỗi kết nối H2 / MySQL và Hibernate
│   │   └── schema_mysql.sql                     # Kịch bản SQL lưu trữ dự phòng
│   └── webapp/                                  # Tầng Giao diện (JSP/JSTL Views & Assets)
│       ├── WEB-INF/
│       │   └── web.xml                          # Khai báo cấu hình ứng dụng web, welcome file và servlet mapping
│       ├── css/
│       │   └── style.css                        # Hệ thống CSS giao diện người dùng và quản trị viên
│       ├── index.jsp                            # Giao diện Trang chủ, danh mục sản phẩm, modal xem chi tiết
│       ├── cart.jsp                             # Giao diện Giỏ hàng, áp mã giảm giá, form thông tin giao hàng
│       ├── login.jsp                            # Giao diện Đăng nhập & Đăng ký tài khoản
│       ├── tracking.jsp                         # Giao diện Tra cứu & theo dõi tiến trình đơn hàng trực quan
│       ├── profile.jsp                          # Giao diện Thông tin tài khoản và Lịch sử đơn hàng cá nhân
│       ├── chat.jsp                             # Giao diện Nhắn tin tư vấn trực tuyến chuyên nghiệp
│       └── admin.jsp                            # Giao diện Bảng điều khiển Quản trị viên (5 Tabs chức năng)
```

---

## 4. Các chức năng chi tiết của hệ thống

### 4.1. Phân hệ Khách hàng (User Features)
1. **Trang chủ & Mua sắm thông minh**:
   - Duyệt sản phẩm theo danh mục chuẩn URL-Safe: `home?category=rau-cu`, `thit-ca-trung`, `do-uong-sua`, `banh-keo`, `thuc-pham-kho`.
   - Tìm kiếm sản phẩm đa tiêu chí theo tên, danh mục hoặc mô tả.
   - Lọc sản phẩm theo khoảng giá tối thiểu - tối đa.
   - Thẻ sản phẩm hiển thị đầy đủ hình ảnh, giá bán, giá gốc, nhãn chứng nhận VietGAP, số lượng tồn kho và nút thêm nhanh vào giỏ.
2. **Xem chi tiết sản phẩm**:
   - Modal hiển thị thông tin chi tiết: xuất xứ, tiêu chuẩn canh tác, giá tiền, mô tả dinh dưỡng và số lượng khả dụng.
3. **Giỏ hàng & Đặt hàng (Session Cart)**:
   - Quản lý giỏ hàng trực tiếp qua `HttpSession` (thêm, cập nhật số lượng, xóa từng mặt hàng, dọn sạch giỏ).
   - Áp dụng mã giảm giá khuyến mãi linh hoạt (giảm phần trăm `%` hoặc giảm số tiền cố định).
   - Lựa chọn phương thức thanh toán: **Thu tiền khi giao hàng (COD)** hoặc **Chuyển khoản ngân hàng VietQR**.
   - **Tự động trừ số lượng tồn kho**: Ngay khi đặt hàng thành công, hệ thống tự động trừ số lượng tồn kho tương ứng của sản phẩm trong database.
4. **Theo dõi tiến trình đơn hàng (`/track-order`)**:
   - Nhập mã đơn hàng (`#GM...`) hoặc số điện thoại để tra cứu hành trình đơn hàng.
   - Thanh trạng thái trực quan 4 bước: **Đặt hàng thành công ➔ Shop đã xác nhận ➔ Đang giao hàng ➔ Giao hàng thành công**.
   - Xem thông tin người nhận, danh sách món hàng, tổng tiền và phương thức thanh toán.
5. **Chat tư vấn trực tuyến với CSKH (`/chat`)**:
   - Kết nối chat trực tiếp giữa khách hàng và quản trị viên/chăm sóc khách hàng.
   - Hỗ trợ gửi tin nhắn kèm mã đơn hàng cần khiếu nại hoặc tư vấn.
   - Cung cấp tiện ích chọn biểu tượng cảm xúc (Emoji Picker), xem trạng thái tin nhắn và làm mới tin nhắn tự động.
   - Thanh nổi dính đáy màn hình (Shopee-style dock) với nút **Chat** màu cam đỏ kèm badge thông báo và nút **Theo dõi đơn hàng** luôn sẵn sàng ở mọi trang web.
6. **Hồ sơ cá nhân & Lịch sử đơn hàng (`/profile`)**:
   - Quản lý thông tin họ tên, email, số điện thoại, địa chỉ nhận hàng mặc định.
   - Bảng lịch sử các đơn hàng đã đặt kèm trạng thái, tổng tiền và nút bấm tra cứu trực tiếp.

---

### 4.2. Phân hệ Quản trị viên (Admin Dashboard)
> Truy cập tại: `http://localhost:8080/admin` (Yêu cầu tài khoản có vai trò `admin`). Nếu chưa đăng nhập hoặc không đủ quyền, hệ thống tự động chuyển hướng về trang đăng nhập với thông báo cảnh báo và ghi nhớ đường dẫn chuyển tiếp.

1. **Tab 1: Báo cáo & Thống kê (Dashboard)**:
   - **Doanh thu thực tế (Hoàn tất)**: Hệ thống tính toán doanh thu chuẩn xác, **chỉ tính tổng tiền từ các đơn hàng đã hoàn thành** (`Completed`, `Delivered`, `Hoàn tất`), loại trừ đơn hủy và đơn đang chờ.
   - Thống kê tổng số đơn hàng, tổng số sản phẩm đang kinh doanh, số lượng đối tác Vendor đã duyệt.
   - Danh sách 5 đơn hàng mới nhất phát sinh trên toàn sàn kèm nhãn trạng thái trực quan.
2. **Tab 2: Quản lý sản phẩm (Products Management)**:
   - Danh sách sản phẩm dạng bảng có ảnh đại diện, danh mục, giá bán và số lượng tồn kho.
   - Tìm kiếm sản phẩm nhanh theo từ khóa.
   - Biểu mẫu Thêm mới / Chỉnh sửa sản phẩm: tên, danh mục, giá tiền, số lượng tồn kho, link ảnh, mô tả chi tiết.
   - Xóa sản phẩm khỏi cơ sở dữ liệu có thông báo xác nhận.
3. **Tab 3: Quản lý đơn hàng & Vận chuyển (Orders Management - Thiết kế mới)**:
   - **4 Thẻ thống kê nhanh**: Tổng số đơn, Số đơn chờ duyệt xử lý ngay, Số đơn đang vận chuyển, Doanh thu thực tế.
   - **Bộ lọc trạng thái dạng viên thuốc (Filter Chips)**: Lọc tức thì theo từng nhóm: *Tất cả*, *Chờ duyệt*, *Đã xác nhận*, *Đang giao*, *Hoàn tất*, *Đã hủy* kèm số lượng đơn chi tiết trên từng tab.
   - **Thanh tìm kiếm đơn hàng**: Tìm kiếm chính xác theo mã đơn (`#GM...`), tên khách hàng hoặc số điện thoại.
   - **Bảng quản lý đơn hàng hiện đại**:
     - Hiển thị avatar tròn chữ cái đầu của khách hàng, tên, số điện thoại có link bấm gọi, địa chỉ giao hàng.
     - Tag nhận diện phương thức thanh toán COD hoặc VietQR có màu sắc chuyên biệt.
     - Form chuyển đổi trạng thái đơn hàng nhanh với nút Lưu tiện lợi.
     - Cụm thao tác: Nút **Chi tiết** mở modal hóa đơn, nút **Chat** kết nối ngay với khách hàng về đơn này, nút **Xóa** đơn.
   - **Modal Chi tiết Hóa đơn (Invoice Fulfillment Modal)**:
     - Thanh Stepper tiến trình xử lý đơn hàng.
     - Khung thông tin khách hàng và thông tin thanh toán 2 cột cân đối.
     - Bảng danh sách chi tiết các mặt hàng: đơn giá, số lượng, thành tiền, tạm tính, giảm giá coupon và tổng thanh toán.
     - Hỗ trợ nút **In hóa đơn** (`window.print()`) phục vụ đóng gói và xuất kho.
4. **Tab 4: Quản lý nhà bán hàng (Vendors Management)**:
   - Danh sách đối tác cửa hàng đăng ký mở gian hàng trên GreenMart.
   - Duyệt gian hàng (`Approved`), Từ chối (`Rejected`), hoặc Đặt lại trạng thái Chờ duyệt (`Waiting`).
5. **Tab 5: Quản lý người dùng (Users Management)**:
   - Danh sách toàn bộ tài khoản đăng ký trên hệ thống.
   - Phân định rõ vai trò Quản trị viên (`★ Admin`) và Khách hàng (`Khách hàng`).
   - Hỗ trợ xóa tài khoản thành viên (có cơ chế khóa bảo vệ tuyệt đối không cho phép xóa tài khoản Admin).

---

## 5. Hướng dẫn cài đặt và Khởi chạy ứng dụng

### 5.1. Yêu cầu môi trường
- **Java Development Kit (JDK)**: Phiên bản 1.8 hoặc 11 trở lên.
- **Apache Maven**: Phiên bản 3.6 trở lên (hoặc Maven tích hợp sẵn trong IntelliJ IDEA).
- **IDE**: IntelliJ IDEA (khuyến nghị bản Ultimate) hoặc Eclipse.

---

### 5.2. Khởi chạy nhanh bằng H2 Database (Mặc định - Khuyên dùng)
Hệ thống đã được cấu hình sẵn sử dụng **H2 Database dạng File** (`../data/greenmart`), không yêu cầu cài đặt MySQL hay dịch vụ cơ sở dữ liệu bên ngoài.

#### Bước 1: Biên dịch mã nguồn và nạp dữ liệu mẫu
Mở Terminal/PowerShell tại thư mục gốc dự án:
```powershell
mvn clean compile
```

#### Bước 2: Nạp dữ liệu mẫu tự động (Seeder)
Chạy lớp `com.greenmart.util.DatabaseSeeder` để tự động tạo bảng và nạp sẵn tài khoản Admin, khách hàng, danh mục, sản phẩm, mã giảm giá và đơn hàng mẫu:
- **Trong IntelliJ IDEA**: Mở file `src/main/java/com/greenmart/util/DatabaseSeeder.java` ➔ Nhấp chuột phải chọn **Run 'DatabaseSeeder.main()'**.
- **Hoặc qua dòng lệnh Maven**:
```powershell
mvn exec:java -Dexec.mainClass="com.greenmart.util.DatabaseSeeder"
```

#### Bước 3: Chạy ứng dụng trên Tomcat
- **Cách 1 (Khuyên dùng trong IntelliJ)**: Chọn cấu hình chạy Tomcat Server **"green"** ➔ Nhấn **Run** hoặc **Debug**.
- **Cách 2 (Dòng lệnh Maven Tomcat7 Plugin)**:
```powershell
mvn tomcat7:run
```

Sau khi máy chủ khởi động thành công, mở trình duyệt web và truy cập:
👉 **`http://localhost:8080/home`** hoặc **`http://localhost:8080`**

---

### 5.3. Khởi chạy bằng MySQL Database (Tùy chọn)

Nếu muốn sử dụng cơ sở dữ liệu MySQL truyền thống:

1. **Khởi động MySQL qua Docker Compose**:
   ```powershell
   docker-compose up -d
   ```
   *(Hoặc sử dụng máy chủ MySQL cục bộ trên máy tại cổng `3306`).*

2. **Cấu hình lại chuỗi kết nối**:
   Mở file `src/main/resources/application.properties` và bỏ ghi chú (uncomment) cấu hình MySQL:
   ```properties
   db.url=jdbc:mysql://127.0.0.1:3306/greenmart?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&useUnicode=true&characterEncoding=UTF-8
   db.username=greenmart
   db.password=greenmart
   db.driver=com.mysql.cj.jdbc.Driver
   hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
   ```

3. **Nạp dữ liệu từ file `sql/greenmart.sql`**:
   ```powershell
   mysql -u greenmart -pgreenmart greenmart < sql/greenmart.sql
   ```

4. **Đóng gói và chạy ứng dụng**:
   ```powershell
   mvn clean package -DskipTests
   mvn tomcat7:run
   ```

---

## 6. Danh sách URL điều hướng chính (Route Mapping)

| Chức năng | Đường dẫn (URL) | Servlet xử lý | Quyền truy cập |
|-----------|-----------------|---------------|----------------|
| **Trang chủ & Mua sắm** | `http://localhost:8080/home` (hoặc `/`) | `HomeServlet` | Công khai |
| **Lọc danh mục** | `http://localhost:8080/home?category=rau-cu` | `HomeServlet` | Công khai |
| **Giỏ hàng & Đặt hàng** | `http://localhost:8080/cart` | `CartServlet` | Công khai |
| **Đăng nhập & Đăng ký** | `http://localhost:8080/auth` (hoặc `/login`) | `AuthServlet` | Công khai |
| **Đăng xuất tài khoản** | `http://localhost:8080/auth?action=logout` | `AuthServlet` | Đã đăng nhập |
| **Tra cứu đơn hàng** | `http://localhost:8080/track-order` | `OrderTrackingServlet` | Công khai |
| **Hồ sơ cá nhân & Đơn mua**| `http://localhost:8080/profile` | `ProfileServlet` | Đã đăng nhập |
| **Chat CSKH trực tuyến** | `http://localhost:8080/chat` | `ChatServlet` | Đã đăng nhập |
| **Bảng điều khiển Quản trị**| `http://localhost:8080/admin` | `AdminServlet` | Quản trị viên (`admin`) |
| **Admin - Quản lý sản phẩm**| `http://localhost:8080/admin?tab=products` | `AdminServlet` | Quản trị viên (`admin`) |
| **Admin - Quản lý đơn hàng**| `http://localhost:8080/admin?tab=orders` | `AdminServlet` | Quản trị viên (`admin`) |
| **Admin - Nhà bán hàng** | `http://localhost:8080/admin?tab=vendors` | `AdminServlet` | Quản trị viên (`admin`) |
| **Admin - Người dùng** | `http://localhost:8080/admin?tab=users` | `AdminServlet` | Quản trị viên (`admin`) |

---

## 7. Dữ liệu thử nghiệm (Demo Credentials)

### 7.1. Tài khoản đăng nhập hệ thống
| Vai trò | Email đăng nhập | Mật khẩu | Quyền hạn và Ghi chú |
|---------|-----------------|----------|----------------------|
| **Quản trị viên (Admin)** | `admin@greenmart.vn` | `123456` | Toàn quyền quản trị hệ thống (`/admin`), duyệt đơn, trả lời chat |
| **Khách hàng 1** | `an.nguyen@gmail.com` | `123456` | Khách hàng mẫu có lịch sử đơn hàng, nhắn tin CSKH |
| **Khách hàng 2** | `mai.tran@gmail.com` | `123456` | Khách hàng mẫu có lịch sử đơn hàng |
| **Khách hàng 3** | `nam.le@gmail.com` | `123456` | Khách hàng mẫu |

*(Người dùng có thể tự do đăng ký tài khoản mới tại trang Đăng ký).*

---

### 7.2. Mã giảm giá thử nghiệm (Coupons)
- **`GREENMART10`**: Giảm 10% trên tổng giá trị đơn hàng.
- **`SALE20`**: Giảm 20% trên tổng giá trị đơn hàng.
- **`CHAO50K`**: Giảm trực tiếp 50.000 VNĐ cho đơn hàng.
- **`FREESHIP`**: Miễn phí vận chuyển (giảm 25.000 VNĐ).

---

### 7.3. Mã đơn hàng mẫu phục vụ tra cứu tiến trình (`/track-order`)
- **`GM610776`**: Đơn hàng trạng thái *Chờ duyệt* (Khách hàng Nguyễn Văn An).
- **`GM554129`**: Đơn hàng trạng thái *Đang giao hàng* (Khách hàng Trần Thị Mai).
- **`GM782914`**: Đơn hàng trạng thái *Hoàn tất* (Khách hàng Nguyễn Văn An).
- **`GM946938`**: Đơn hàng trạng thái *Đã hủy* (Admin GreenMart).

---

## 8. Kết luận & Đánh giá môn học

Dự án **GreenMart PTIT** đáp ứng trọn vẹn và vượt mức các mục tiêu yêu cầu của học phần **Lập trình Web**:
1. **Kiến trúc MVC chuẩn mực**: Phân tách rõ ràng giữa Controller (Java Servlets), Service, Repository, Entity (Hibernate JPA) và View (JSP/JSTL).
2. **Kiểm soát nghiệp vụ chặt chẽ phía Server**: Quản lý phiên làm việc (`HttpSession`), tính toán giỏ hàng, đối soát mã giảm giá, tự động trừ tồn kho và xác thực phân quyền an toàn không phụ thuộc vào mã script client.
3. **Trải nghiệm người dùng hoàn chỉnh**: Tích hợp các tính năng thương mại điện tử thực tế như Chat tư vấn CSKH hai chiều, Tra cứu vận chuyển đơn hàng đa kênh, Thanh công cụ nổi dính đáy màn hình (Floating Dock Shopee-style).
4. **Bảng quản trị hiện đại**: Bảng điều khiển quản trị trực quan với biểu đồ chỉ số, bộ lọc tab pill, form cập nhật nhanh và tính năng in ấn hóa đơn chuyên nghiệp.
5. **Khả năng triển khai linh hoạt**: Cung cấp giải pháp CSDL H2 nhúng khởi động tức thì kèm Seeder dữ liệu mẫu, song song với cấu hình MySQL trên Docker Compose.
