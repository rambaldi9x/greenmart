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
  <link rel="stylesheet" href="css/style.css?v=20261008_sticky">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="css/home.css">
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
          <a href="profile" class="action-item" title="Xem thông tin cá nhân" style="font-weight: 600; color: var(--text-heading); text-decoration: none;">
            <i class="fa-solid fa-circle-user" style="color: var(--primary-color); font-size: 18px;"></i>
            <span>${sessionScope.user.username}</span>
            <c:if test="${sessionScope.user.role == 'admin'}">
              <span style="background:#fef3c7;color:#92400e;font-size:11px;padding:2px 6px;border-radius:4px;margin-left:4px;">Admin</span>
            </c:if>
          </a>
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

      <a href="chat" class="action-item" title="Trò chuyện & Hỗ trợ">
        <i class="fa-solid fa-comments"></i>
        <span>Trò chuyện</span>
      </a>

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
      <li><a href="track-order"><i class="fa-solid fa-truck-fast"></i> Tra cứu đơn hàng</a></li>
      <li><a href="chat"><i class="fa-solid fa-comments"></i> Trò chuyện / Chat</a></li>
      <c:if test="${not empty sessionScope.user}">
        <li><a href="profile"><i class="fa-solid fa-user-gear"></i> Thông tin User</a></li>
      </c:if>
      <c:if test="${sessionScope.user.role == 'admin'}">
        <li><a href="admin"><i class="fa-solid fa-gauge"></i> Trang Quản trị (Admin)</a></li>
      </c:if>
    </ul>
    <div style="color: white; font-size: 14px;"><i class="fa-solid fa-location-dot"></i> Giao nhanh: Hà Nội & TP. Hồ Chí Minh</div>
  </nav>

  <!-- Thông báo thêm giỏ hàng thành công -->
  <c:if test="${not empty sessionScope.cartSuccess}">
    <div style="background: #ecfdf5; border-left: 4px solid #10b981; color: #065f46; padding: 12px 40px; font-size: 14px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 5px rgba(0,0,0,0.05);">
      <div><i class="fa-solid fa-circle-check"></i> ${sessionScope.cartSuccess}</div>
      <a href="cart" style="color: var(--primary-color); font-weight: bold; text-decoration: underline;">Xem giỏ hàng &raquo;</a>
    </div>
    <c:remove var="cartSuccess" scope="session"/>
  </c:if>

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
          <c:set var="inCartQty" value="${not empty sessionScope.cart ? sessionScope.cart.getItemQuantity(p.id) : 0}"/>
          <div class="product-card" id="product-card-${p.id}">
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

              <!-- Thao tác giỏ hàng: CHỈ KHI THÊM GIỎ HÀNG THÌ MỚI HIỆN SỐ LƯỢNG -->
              <div class="card-actions" style="display: flex; gap: 8px; margin-top: 10px; align-items: center;">
                <c:choose>
                  <c:when test="${p.count != null && p.count <= 0}">
                    <button type="button" class="btn-add-cart" style="flex: 1; opacity: 0.6; cursor: not-allowed;" disabled>
                      Hết hàng
                    </button>
                  </c:when>
                  <c:otherwise>
                    <!-- Nút Thêm Giỏ (Hiển thị khi chưa thêm vào giỏ hàng) -->
                    <button type="button"
                            id="btn-add-${p.id}"
                            class="btn-add-cart"
                            style="flex: 1; display: ${inCartQty > 0 ? 'none' : 'block'};"
                            data-name="${p.name}"
                            onclick="handleAddToCart(${p.id}, this, ${p.count != null ? p.count : 999})">
                      <i class="fa fa-cart-plus"></i> Thêm giỏ
                    </button>

                    <!-- Bộ điều khiển số lượng (CHỈ HIỆN KHI ĐÃ THÊM VÀO GIỎ HÀNG) -->
                    <div id="qty-ctrl-${p.id}"
                         class="product-qty-stepper"
                         style="flex: 1; display: ${inCartQty > 0 ? 'flex' : 'none'}; align-items: center; justify-content: space-between;">
                      <button type="button"
                              class="stepper-btn"
                              onclick="handleUpdateQty(${p.id}, -1, ${p.count != null ? p.count : 999})"
                              title="Giảm số lượng">
                        <i class="fa-solid fa-minus"></i>
                      </button>
                      <span id="qty-val-${p.id}" class="stepper-qty">
                        ${inCartQty > 0 ? inCartQty : 1}
                      </span>
                      <button type="button"
                              class="stepper-btn"
                              onclick="handleUpdateQty(${p.id}, 1, ${p.count != null ? p.count : 999})"
                              title="Tăng số lượng">
                        <i class="fa-solid fa-plus"></i>
                      </button>
                    </div>
                  </c:otherwise>
                </c:choose>

                <!-- Nút xem chi tiết -->
                <a href="home?detailId=${p.id}&category=${category}&keyword=${keyword}#productDetailModal"
                   class="btn-card-detail"
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
        <div style="display:flex;justify-content:space-between;align-items:center;margin-top:16px;padding-top:16px;border-top:1px solid var(--border-color);flex-wrap:wrap;gap:12px;">
          <span style="font-size:24px;font-weight:bold;color:var(--primary-color);">
            <fmt:formatNumber value="${selectedProduct.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
          </span>
          <form action="cart" method="POST" style="display:flex;align-items:center;gap:10px;">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="productId" value="${selectedProduct.id}">
            <input type="hidden" name="redirect" value="home">
            <div style="display:flex;align-items:center;border:1px solid var(--border-color);border-radius:5px;overflow:hidden;background:white;">
              <button type="button" onclick="changeQty(this, -1)" style="border:none;background:#f1f5f9;padding:8px 12px;cursor:pointer;font-weight:bold;font-size:15px;color:var(--text-heading);">-</button>
              <input type="number" name="quantity" value="1" min="1" max="${selectedProduct.count != null ? selectedProduct.count : 999}"
                     title="Click để nhập số lượng"
                     style="width: 48px; text-align: center; border: none; outline: none; font-size: 14px; font-weight: 600;"
                     ${selectedProduct.count != null && selectedProduct.count <= 0 ? 'disabled' : ''}>
              <button type="button" onclick="changeQty(this, 1, ${selectedProduct.count != null ? selectedProduct.count : 999})" style="border:none;background:#f1f5f9;padding:8px 12px;cursor:pointer;font-weight:bold;font-size:15px;color:var(--text-heading);">+</button>
            </div>
            <button type="submit" class="btn-primary" style="display:flex;align-items:center;gap:8px;padding:10px 18px;" ${selectedProduct.count != null && selectedProduct.count <= 0 ? 'disabled' : ''}>
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
        <p>Bài tập lớn môn: Lập trình Web</p>
        <p>GVHD: ThS. Phạm Quang Hiếu</p>
        <p>Nhóm thực hiện: Nhóm 5 thành viên</p>
      </div>
    </div>
  </footer>

  <!-- POPUP CHAT TƯ VẤN TRỰC TUYẾN (Live Chat Popup Modal) -->
  <div id="liveChatWidget" class="live-chat-widget" style="display:none;">
    <div class="live-chat-header">
      <div class="live-chat-header-info">
        <div class="live-chat-avatar">
          <i class="fa-solid fa-headset"></i>
        </div>
        <div>
          <h4>GreenMart CSKH 24/7</h4>
          <span class="live-chat-status"><span class="dot-online"></span> Đang trực tuyến</span>
        </div>
      </div>
      <div class="live-chat-controls">
        <a href="chat" title="Mở trang đầy đủ" class="live-chat-ctrl-btn">
          <i class="fa-solid fa-up-right-from-square"></i>
        </a>
        <button type="button" onclick="closeFloatingChat(event)" class="live-chat-ctrl-btn" title="Đóng cửa sổ chat">
          <i class="fa-solid fa-xmark"></i>
        </button>
      </div>
    </div>

    <!-- Quick questions inside popup -->
    <div class="live-chat-quick-bar">
      <button type="button" onclick="sendWidgetQuick('Chào shop, mình cần tư vấn thực phẩm tươi sạch ạ! 👋')">👋 Tư vấn rau củ</button>
      <button type="button" onclick="sendWidgetQuick('Shop ơi, kiểm tra giúp mình tiến độ đơn hàng với ạ! 📦')">📦 Kiểm tra đơn</button>
      <button type="button" onclick="sendWidgetQuick('Thời gian giao hàng trong nội thành bao lâu shop? 🚚')">🚚 Thời gian ship</button>
    </div>

    <!-- Message body -->
    <div class="live-chat-body" id="liveChatBody">
      <div class="chat-message-row row-theirs">
        <div class="message-sender-avatar admin-avatar">
          <i class="fa-solid fa-headset"></i>
        </div>
        <div class="bubble-and-time">
          <div class="message-sender-label">GreenMart CSKH</div>
          <div class="chat-bubble bubble-theirs">
            Dạ chào bạn! GreenMart rất vui được hỗ trợ bạn. Bạn cần tư vấn thực phẩm tươi sạch hay hỗ trợ đơn hàng gì ạ? 😊
          </div>
          <div class="message-time-meta">Vừa xong</div>
        </div>
      </div>
    </div>

    <!-- Input bar -->
    <div class="live-chat-footer">
      <c:choose>
        <c:when test="${not empty sessionScope.user}">
          <form onsubmit="handleWidgetSend(event)" style="display:flex; gap:6px; width:100%;">
            <input type="text" id="widgetChatInput" placeholder="Nhập câu hỏi tư vấn..." autocomplete="off" required>
            <button type="submit" class="btn-primary" style="padding:8px 14px; border-radius:20px; font-size:13px;">
              <i class="fa-solid fa-paper-plane"></i>
            </button>
          </form>
        </c:when>
        <c:otherwise>
          <div style="font-size:12px; color:#64748b; text-align:center; width:100%;">
            Vui lòng <a href="auth?mode=login&redirect=home" style="color:var(--primary-color); font-weight:700;">Đăng nhập</a> để trò chuyện trực tiếp với CSKH.
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <!-- THANH TIỆN ÍCH NỔI CỐ ĐỊNH DÍNH ĐÁY MÀN HÌNH (Fixed Bottom Sticky Dock) -->
  <div class="gm-floating-dock" id="gmFloatingDock">
    <!-- Nút 1: Theo dõi tiến trình đơn hàng -->
    <a href="track-order" class="dock-btn dock-btn-track" title="Theo dõi tiến trình đơn hàng (Tra cứu mã vận đơn)">
      <i class="fa-solid fa-truck-fast"></i>
      <span>Theo dõi đơn</span>
    </a>

    <!-- Nút 2: Xem giỏ hàng -->
    <a href="cart" id="floating-cart-btn" class="dock-btn dock-btn-cart" title="Xem giỏ hàng của bạn">
      <div class="dock-icon-box">
        <i class="fa-solid fa-cart-shopping"></i>
        <span class="dock-badge" id="floating-cart-badge" style="${sessionScope.cart != null && sessionScope.cart.totalQuantity > 0 ? '' : 'display:none;'}">
          ${sessionScope.cart != null ? sessionScope.cart.totalQuantity : 0}
        </span>
      </div>
      <div class="dock-cart-info">
        <span>Giỏ hàng</span>
        <span class="dock-subtotal" id="floating-cart-subtotal" style="${sessionScope.cart != null && sessionScope.cart.totalQuantity > 0 ? '' : 'display:none;'}">
          <fmt:formatNumber value="${sessionScope.cart != null ? sessionScope.cart.subtotal : 0}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
        </span>
      </div>
    </a>

    <!-- Nút 3: Chat Shopee-style dính đáy màn hình (Chuẩn theo pasted-image-1.png) -->
    <button type="button" class="dock-btn dock-btn-chat" onclick="toggleFloatingChat()" title="Chat tư vấn trực tuyến với CSKH GreenMart">
      <div class="dock-chat-icon-wrap">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block; vertical-align:middle;">
          <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" fill="white" stroke="white"></path>
          <path d="M8 10c.8 1.2 2.2 1.8 4 1.8s3.2-.6 4-1.8" stroke="#ee4d2d" stroke-width="2.2" fill="none"></path>
        </svg>
      </div>
      <span style="letter-spacing:0.3px;">Chat</span>
      <i class="fa-solid fa-caret-down dock-chat-caret"></i>
      <span class="dock-badge-tab" id="floatingChatBadge">1</span>
    </button>
  </div>

  <!-- Toast notification -->
  <div id="toast-notify" style="position: fixed; bottom: 160px; right: 24px; z-index: 9999; display: none; background: #253d4e; color: white; padding: 14px 22px; border-radius: 8px; box-shadow: 0 6px 20px rgba(0,0,0,0.18); font-size: 14px; align-items: center; gap: 12px; transition: opacity 0.3s ease;">
    <i class="fa-solid fa-circle-check" style="color: #3bb77e; font-size: 20px;"></i>
    <span id="toast-msg">Đã cập nhật giỏ hàng!</span>
  </div>

  <script src="js/home.js"></script>

</body>
</html>
