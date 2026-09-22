<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:if test="${products == null}">
  <c:redirect url="/home"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>GreenMart - Website Thực Phẩm Sạch & Hữu Cơ</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

  <!-- Top bar -->
  <div class="top-bar">
    <div><i class="fa fa-phone"></i> Hotline: 1900 6868 | Giao hàng tận nơi 24/7</div>
    <div>Chào mừng đến với GreenMart Organic Store!</div>
  </div>

  <!-- Header -->
  <header class="header">
    <a href="home" class="logo">
      <i class="fa-solid fa-leaf"></i> GREENMART
    </a>

    <!-- Search box -->
    <div class="search-box">
      <form action="home" method="GET" style="display: flex; width: 100%;">
        <select name="category" id="search-cat">
          <option value="all" ${category == 'all' || empty category ? 'selected' : ''}>Tất cả danh mục</option>
          <option value="rau-cu" ${category == 'rau-cu' ? 'selected' : ''}>Rau củ & Trái cây</option>
          <option value="thit-ca-trung" ${category == 'thit-ca-trung' ? 'selected' : ''}>Thịt, Cá & Trứng</option>
          <option value="do-uong-sua" ${category == 'do-uong-sua' ? 'selected' : ''}>Đồ uống & Sữa</option>
          <option value="banh-keo" ${category == 'banh-keo' ? 'selected' : ''}>Bánh kẹo & Ăn vặt</option>
          <option value="thuc-pham-kho" ${category == 'thuc-pham-kho' ? 'selected' : ''}>Thực phẩm khô</option>
        </select>
        <input type="text" name="keyword" value="${keyword}" placeholder="Tìm kiếm thực phẩm, rau củ, đồ hộp...">
        <button type="submit"><i class="fa fa-search"></i> Tìm</button>
      </form>
    </div>

    <!-- Actions -->
    <div class="header-actions">
      <c:choose>
        <c:when test="${not empty sessionScope.user}">
          <span class="action-item" style="font-weight: 600; color: var(--text-heading);">
            <i class="fa-solid fa-user-check" style="color: var(--primary-color);"></i>
            ${sessionScope.user.username}
            <c:if test="${sessionScope.user.role == 'admin'}">
              <span style="background:#fef3c7;color:#92400e;font-size:11px;padding:2px 6px;border-radius:4px;margin-left:4px;">Admin</span>
            </c:if>
          </span>
          <c:if test="${sessionScope.user.role == 'admin'}">
            <a href="admin" class="action-item" style="color: #2563eb;">
              <i class="fa-solid fa-gauge"></i> Quản trị
            </a>
          </c:if>
          <a href="auth?action=logout" class="action-item" title="Đăng xuất" style="color:#ef4444;">
            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
          </a>
        </c:when>
        <c:otherwise>
          <a href="auth" class="action-item">
            <i class="fa-regular fa-user"></i>
            <span>Đăng nhập</span>
          </a>
        </c:otherwise>
      </c:choose>

      <a href="cart" class="action-item">
        <i class="fa-solid fa-cart-shopping"></i>
        <span>Giỏ hàng</span>
        <span class="badge" id="cart-count">
          ${not empty sessionScope.cart ? sessionScope.cart.totalQuantity : 0}
        </span>
      </a>
    </div>
  </header>

  <!-- Navigation -->
  <nav class="navbar">
    <ul class="nav-links">
      <li><a href="home"><i class="fa fa-home"></i> Trang chủ</a></li>
      <li><a href="home#products"><i class="fa-solid fa-store"></i> Sản phẩm</a></li>
      <li><a href="cart"><i class="fa-solid fa-receipt"></i> Đơn hàng & Giỏ hàng</a></li>
      <c:if test="${sessionScope.user.role == 'admin'}">
        <li><a href="admin"><i class="fa-solid fa-gauge"></i> Trang Quản trị (Admin)</a></li>
      </c:if>
    </ul>
    <div style="color: white; font-size: 14px;"><i class="fa-solid fa-location-dot"></i> Giao nhanh: Hà Nội & TP. Hồ Chí Minh</div>
  </nav>

  <!-- Banner -->
  <div class="hero-banner">
    <h1>Đừng bỏ lỡ những ưu đãi thực phẩm tươi ngon!</h1>
    <p>Thực phẩm tươi sạch chuẩn VietGAP, giảm giá đến 30% cho đơn hàng đầu tiên.</p>
    <a href="#products" class="btn-primary">Mua ngay <i class="fa fa-arrow-right"></i></a>
  </div>

  <!-- Bộ lọc giá -->
  <div style="display:flex;align-items:center;gap:12px;padding:8px 40px;background:#f8f9fa;border-bottom:1px solid var(--border-color);flex-wrap:wrap;">
    <form action="home" method="GET" style="display: flex; align-items: center; gap: 12px; width: 100%; flex-wrap: wrap;">
      <c:if test="${not empty category}">
        <input type="hidden" name="category" value="${category}">
      </c:if>
      <c:if test="${not empty keyword}">
        <input type="hidden" name="keyword" value="${keyword}">
      </c:if>
      <span style="font-size:13px;font-weight:600;color:var(--text-heading);">Lọc theo giá:</span>
      <input type="number" name="minPrice" value="${minPrice}" placeholder="Giá từ (đ)" min="0"
        style="width:130px;padding:7px 10px;border:1px solid var(--border-color);border-radius:5px;font-size:13px;outline:none;">
      <span style="color:var(--text-body);">—</span>
      <input type="number" name="maxPrice" value="${maxPrice}" placeholder="Đến giá (đ)" min="0"
        style="width:130px;padding:7px 10px;border:1px solid var(--border-color);border-radius:5px;font-size:13px;outline:none;">
      <button type="submit" style="padding:7px 14px;border:1px solid var(--primary-color);background:var(--primary-color);color:white;border-radius:5px;font-size:13px;cursor:pointer;">Lọc</button>
      <a href="home"
        style="padding:7px 14px;border:1px solid #ccc;background:white;border-radius:5px;font-size:13px;cursor:pointer;color:var(--text-body);text-decoration:none;">
        ✕ Xóa lọc
      </a>
    </form>
  </div>

  <!-- Category chips filter -->
  <div class="categories-bar" id="category-chips">
    <a href="home?category=all" class="cat-chip ${category == 'all' || empty category ? 'active' : ''}">Tất cả</a>
    <a href="home?category=rau-cu" class="cat-chip ${category == 'rau-cu' ? 'active' : ''}">Rau củ & Trái cây</a>
    <a href="home?category=thit-ca-trung" class="cat-chip ${category == 'thit-ca-trung' ? 'active' : ''}">Thịt, Cá & Trứng</a>
    <a href="home?category=do-uong-sua" class="cat-chip ${category == 'do-uong-sua' ? 'active' : ''}">Đồ uống & Sữa tươi</a>
    <a href="home?category=banh-keo" class="cat-chip ${category == 'banh-keo' ? 'active' : ''}">Bánh kẹo</a>
    <a href="home?category=thuc-pham-kho" class="cat-chip ${category == 'thuc-pham-kho' ? 'active' : ''}">Thực phẩm khô</a>
  </div>

  <!-- Products Grid -->
  <h2 class="section-title" id="products">Sản phẩm tươi mới hôm nay</h2>
  <div class="products-grid" id="products-container">
    <c:choose>
      <c:when test="${empty products}">
        <p style="grid-column: 1/-1; text-align: center; padding: 50px 20px; color: var(--text-body);">
          Không tìm thấy sản phẩm nào phù hợp.
        </p>
      </c:when>
      <c:otherwise>
        <c:forEach var="p" items="${products}">
          <div class="product-card">
            <div style="position: relative;">
              <img src="${p.image}" alt="${p.name}" class="product-img">
              <c:choose>
                <c:when test="${p.count != null && p.count <= 0}">
                  <div style="position:absolute;top:8px;right:8px;background:#dc2626;color:white;padding:3px 10px;border-radius:4px;font-size:11px;font-weight:bold;">Hết hàng</div>
                </c:when>
                <c:when test="${p.count != null && p.count <= 5}">
                  <div style="position:absolute;top:8px;right:8px;background:#d97706;color:white;padding:3px 10px;border-radius:4px;font-size:11px;font-weight:bold;">Còn ${p.count}</div>
                </c:when>
              </c:choose>
            </div>
            <div class="product-info">
              <span class="product-cat">${p.category}</span>
              <div class="product-name" title="${p.name}">${p.name}</div>
              <div class="product-price">
                <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
              </div>
              <div style="display: flex; gap: 8px; margin-top: 10px;">
                <form action="cart" method="POST" style="flex: 1;">
                  <input type="hidden" name="action" value="add">
                  <input type="hidden" name="productId" value="${p.id}">
                  <input type="hidden" name="redirect" value="home">
                  <button type="submit" class="btn-add-cart" style="width: 100%;" ${p.count != null && p.count <= 0 ? 'disabled' : ''}>
                    <i class="fa fa-cart-plus"></i> ${p.count != null && p.count <= 0 ? 'Hết hàng' : 'Thêm giỏ'}
                  </button>
                </form>
                <a href="home?detailId=${p.id}&category=${category}&keyword=${keyword}#productDetailModal"
                   style="padding: 8px 12px; background: white; color: var(--primary-color); border: 1px solid var(--primary-color); border-radius: 5px; text-decoration: none; display: flex; align-items: center;"
                   title="Xem chi tiết">
                  <i class="fa-solid fa-eye"></i>
                </a>
              </div>
            </div>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>

  <!-- Modal Chi tiết sản phẩm (Điều hướng hoàn toàn bằng Java) -->
  <c:if test="${not empty selectedProduct}">
    <div class="modal" id="productDetailModal" style="display: flex;">
      <div class="modal-content" style="width:520px;max-width:95%;">
        <div class="modal-header">
          <h3 style="font-size:17px;color:var(--text-heading);max-width:420px;line-height:1.4;">${selectedProduct.name}</h3>
          <a href="home" class="close-btn" style="text-decoration:none;font-size:24px;color:#888;">&times;</a>
        </div>
        <img src="${selectedProduct.image}" alt="${selectedProduct.name}"
          style="width:100%;height:230px;object-fit:cover;border-radius:8px;margin-bottom:14px;">
        <div style="margin-bottom:8px;">
          <span style="font-size:12px;color:var(--text-body);text-transform:uppercase;letter-spacing:0.5px;background:var(--bg-light);padding:3px 10px;border-radius:20px;">
            ${selectedProduct.category}
          </span>
          <c:if test="${selectedProduct.count != null}">
            <span style="font-size: 12px; color: #64748b; margin-left: 10px;">Tồn kho: ${selectedProduct.count}</span>
          </c:if>
        </div>
        <p style="color:var(--text-body);margin:12px 0;line-height:1.75;font-size:14px;">
          ${selectedProduct.description}
        </p>
        <div style="display:flex;justify-content:space-between;align-items:center;margin-top:16px;padding-top:16px;border-top:1px solid var(--border-color);">
          <span style="font-size:24px;font-weight:bold;color:var(--primary-color);">
            <fmt:formatNumber value="${selectedProduct.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
          </span>
          <form action="cart" method="POST">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="productId" value="${selectedProduct.id}">
            <input type="hidden" name="redirect" value="home">
            <button type="submit" class="btn-primary" style="display:flex;align-items:center;gap:8px;" ${selectedProduct.count != null && selectedProduct.count <= 0 ? 'disabled' : ''}>
              <i class="fa fa-cart-plus"></i> ${selectedProduct.count != null && selectedProduct.count <= 0 ? 'Hết hàng' : 'Thêm vào giỏ hàng'}
            </button>
          </form>
        </div>
      </div>
    </div>
  </c:if>

  <!-- Footer -->
  <footer class="footer">
    <div class="footer-content">
      <div>
        <h3>GreenMart Organic Store</h3>
        <p>Hệ thống cung cấp thực phẩm tươi sạch hàng đầu, cam kết nguồn gốc xuất xứ rõ ràng, vận chuyển nhanh trong 2 giờ.</p>
        <p style="margin-top: 10px;">Địa chỉ: Học viện Công nghệ Bưu chính Viễn thông (PTIT)</p>
      </div>
      <div>
        <h3>Về chúng tôi</h3>
        <p>Giới thiệu GreenMart</p>
        <p>Chính sách bảo mật</p>
        <p>Điều khoản dịch vụ</p>
      </div>
      <div>
        <h3>Khách hàng</h3>
        <p>Hướng dẫn mua hàng</p>
        <p>Chính sách đổi trả</p>
        <p>Đăng ký gian hàng Vendor</p>
      </div>
      <div>
        <h3>Hỗ trợ kỹ thuật</h3>
        <p>Đồ án môn: Lập trình Web</p>
        <p>GVHD: ThS. Phạm Quang Hiếu</p>
        <p>Nhóm thực hiện: Nhóm 8 thành viên</p>
      </div>
    </div>
  </footer>

</body>
</html>
