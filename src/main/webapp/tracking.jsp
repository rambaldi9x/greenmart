<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Theo Dõi Trạng Thái Đơn Hàng - GreenMart</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="css/tracking.css">

</head>
<body class="tracking-page">

  <!-- Top bar -->
  <div class="top-bar">
    <div><i class="fa fa-phone"></i> Hotline: 1900 6868 | Giao hàng tận nơi 24/7</div>
    <div>Tra Cứu & Theo Dõi Hành Trình Đơn Hàng GreenMart</div>
  </div>

  <!-- Header -->
  <header class="header">
    <a href="home" class="logo">
      <i class="fa-solid fa-leaf"></i> GREENMART
    </a>

    <div class="header-actions">
      <a href="home" class="action-item"><i class="fa fa-arrow-left"></i> Tiếp tục mua sắm</a>
      <c:choose>
        <c:when test="${not empty sessionScope.user}">
          <a href="profile" class="action-item" title="Xem thông tin cá nhân" style="font-weight: 600; color: var(--text-heading); text-decoration: none;">
            <i class="fa-solid fa-circle-user" style="color: var(--primary-color);"></i>
            <span>${sessionScope.user.username}</span>
          </a>
          <a href="auth?action=logout" class="action-item" style="color:#ef4444;" title="Đăng xuất">
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
      <li><a href="cart"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng</a></li>
      <li><a href="track-order" style="text-decoration: underline;"><i class="fa-solid fa-truck-fast"></i> Tra cứu đơn hàng</a></li>
      <li><a href="chat"><i class="fa-solid fa-comments"></i> Trò chuyện / Chat</a></li>
      <c:if test="${not empty sessionScope.user}">
        <li><a href="profile"><i class="fa-solid fa-user-gear"></i> Thông tin User</a></li>
      </c:if>
      <c:if test="${sessionScope.user.role == 'admin'}">
        <li><a href="admin"><i class="fa-solid fa-gauge"></i> Trang Quản trị (Admin)</a></li>
      </c:if>
    </ul>
    <div style="color: white; font-size: 14px;"><i class="fa-solid fa-shield-halved"></i> Kiểm tra tình trạng đơn 24/7</div>
  </nav>

  <!-- Hero Section -->
  <div class="tracking-hero">
    <h1><i class="fa-solid fa-truck-ramp-box"></i> Theo Dõi Đơn Hàng Của Bạn</h1>
    <p>Nhập mã đơn hàng hoặc số điện thoại để cập nhật tiến độ đóng gói, vận chuyển và giao hàng theo thời gian thực.</p>
  </div>

  <!-- Search Card -->
  <div class="search-tracking-card">
    <form action="track-order" method="GET">
      <div class="tracking-input-group">
        <input type="text" name="code" value="${searchedCode}" 
               placeholder="Nhập mã đơn hàng (Ví dụ: GM782914)..." required autofocus>
        <button type="submit">
          <i class="fa-solid fa-magnifying-glass"></i> Tra cứu
        </button>
      </div>
    </form>
    
    <div class="quick-codes-bar">
      <span><i class="fa-solid fa-lightbulb"></i> Đơn mẫu tra cứu nhanh:</span>
      <a href="track-order?code=GM782914" class="quick-code-pill">#GM782914 (Hoàn tất)</a>
      <a href="track-order?code=GM554129" class="quick-code-pill">#GM554129 (Đang giao)</a>
      <a href="track-order?code=GM902183" class="quick-code-pill">#GM902183 (Chờ duyệt)</a>
    </div>
  </div>

  <div class="tracking-result-container">

    <!-- Thông báo lỗi nếu không tìm thấy -->
    <c:if test="${not empty searchError}">
      <div style="background: #fef2f2; border: 1px solid #fecaca; color: #991b1b; padding: 18px 22px; border-radius: 10px; margin-bottom: 25px; display: flex; align-items: center; gap: 14px;">
        <i class="fa-solid fa-circle-exclamation" style="font-size: 24px;"></i>
        <div>
          <h4 style="margin-bottom: 3px;">Không tìm thấy đơn hàng</h4>
          <p style="font-size: 13px; margin: 0;">${searchError}</p>
        </div>
      </div>
    </c:if>

    <!-- KẾT QUẢ ĐƠN HÀNG TÌM THẤY -->
    <c:if test="${not empty foundOrder}">
      <c:set var="st" value="${foundOrder.status}"/>
      <c:set var="isCanceled" value="${st == 'Canceled' || st == 'Cancelled'}"/>
      <c:set var="isCompleted" value="${st == 'Completed' || st == 'Delivered'}"/>
      <c:set var="isShipping" value="${st == 'Shipping'}"/>
      <c:set var="isConfirmed" value="${st == 'Confirmed'}"/>
      <c:set var="isWaiting" value="${st == 'Waiting' || empty st}"/>

      <div class="order-status-card">
        <!-- Header -->
        <div class="order-summary-header">
          <div class="title-col">
            <h2>
              <i class="fa-solid fa-receipt" style="color: var(--primary-color);"></i>
              Đơn hàng #${foundOrder.orderCode}
            </h2>
            <div class="date-text">
              <i class="fa-regular fa-clock"></i> Thời gian đặt hàng: ${foundOrder.createdAt}
            </div>
          </div>
          <div>
            <c:choose>
              <c:when test="${isCanceled}">
                <span style="background:#fee2e2;color:#991b1b;padding:6px 14px;border-radius:20px;font-weight:700;font-size:13px;display:inline-flex;align-items:center;gap:6px;">
                  <i class="fa-solid fa-ban"></i> Đã hủy đơn
                </span>
              </c:when>
              <c:when test="${isCompleted}">
                <span style="background:#dcfce7;color:#166534;padding:6px 14px;border-radius:20px;font-weight:700;font-size:13px;display:inline-flex;align-items:center;gap:6px;">
                  <i class="fa-solid fa-circle-check"></i> Giao thành công
                </span>
              </c:when>
              <c:when test="${isShipping}">
                <span style="background:#e0f2fe;color:#0369a1;padding:6px 14px;border-radius:20px;font-weight:700;font-size:13px;display:inline-flex;align-items:center;gap:6px;">
                  <i class="fa-solid fa-truck-fast"></i> Đang giao hàng
                </span>
              </c:when>
              <c:when test="${isConfirmed}">
                <span style="background:#f5f3ff;color:#7c3aed;padding:6px 14px;border-radius:20px;font-weight:700;font-size:13px;display:inline-flex;align-items:center;gap:6px;">
                  <i class="fa-solid fa-boxes-packing"></i> Đã xác nhận & Đang soạn
                </span>
              </c:when>
              <c:otherwise>
                <span style="background:#fef3c7;color:#92400e;padding:6px 14px;border-radius:20px;font-weight:700;font-size:13px;display:inline-flex;align-items:center;gap:6px;">
                  <i class="fa-solid fa-hourglass-half"></i> Chờ duyệt đơn
                </span>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <!-- Banner nếu hủy -->
        <c:if test="${isCanceled}">
          <div class="banner-canceled">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <div>
              <strong>Đơn hàng này đã bị hủy.</strong>
              <div style="font-size: 13px; margin-top: 3px;">
                Nếu bạn cần hỗ trợ hoặc muốn đặt lại hàng, vui lòng liên hệ bộ phận Chăm Sóc Khách Hàng của GreenMart.
              </div>
            </div>
          </div>
        </c:if>

        <!-- VISUAL STEPPER TRACKER (Tiến trình vận chuyển) -->
        <c:if test="${not isCanceled}">
          <div class="stepper-wrapper">
            <c:set var="fillWidth" value="0%"/>
            <c:if test="${isConfirmed}"><c:set var="fillWidth" value="33%"/></c:if>
            <c:if test="${isShipping}"><c:set var="fillWidth" value="66%"/></c:if>
            <c:if test="${isCompleted}"><c:set var="fillWidth" value="100%"/></c:if>

            <div class="stepper-progress-bar">
              <div class="stepper-progress-fill" style="width: ${fillWidth};"></div>
            </div>

            <!-- Bước 1: Đặt hàng thành công -->
            <div class="step-node ${isConfirmed || isShipping || isCompleted ? 'completed' : 'active'}">
              <div class="step-icon-wrap">
                <i class="fa-solid fa-file-invoice"></i>
              </div>
              <div class="step-title">1. Đã đặt hàng</div>
              <div class="step-desc">Đơn đã ghi nhận</div>
            </div>

            <!-- Bước 2: Đã xác nhận -->
            <div class="step-node ${isShipping || isCompleted ? 'completed' : (isConfirmed ? 'active' : 'pending')}">
              <div class="step-icon-wrap">
                <i class="fa-solid fa-boxes-packing"></i>
              </div>
              <div class="step-title">2. Đã xác nhận</div>
              <div class="step-desc">Đang đóng gói</div>
            </div>

            <!-- Bước 3: Đang giao hàng -->
            <div class="step-node ${isCompleted ? 'completed' : (isShipping ? 'active' : 'pending')}">
              <div class="step-icon-wrap">
                <i class="fa-solid fa-truck-fast"></i>
              </div>
              <div class="step-title">3. Đang giao hàng</div>
              <div class="step-desc">Shipper đang tới</div>
            </div>

            <!-- Bước 4: Hoàn thành -->
            <div class="step-node ${isCompleted ? 'completed' : 'pending'}">
              <div class="step-icon-wrap">
                <i class="fa-solid fa-circle-check"></i>
              </div>
              <div class="step-title">4. Đã giao hàng</div>
              <div class="step-desc">Hoàn tất thành công</div>
            </div>
          </div>
        </c:if>

        <!-- Thông tin giao nhận -->
        <div class="tracking-info-grid">
          <div class="info-block">
            <label><i class="fa-solid fa-user"></i> Người nhận hàng</label>
            <div class="val">${foundOrder.name} &bull; ${foundOrder.phone}</div>
          </div>
          <div class="info-block">
            <label><i class="fa-solid fa-location-dot"></i> Địa chỉ giao hàng</label>
            <div class="val">${foundOrder.address}</div>
          </div>
          <div class="info-block">
            <label><i class="fa-solid fa-credit-card"></i> Phương thức thanh toán</label>
            <div class="val">
              <c:choose>
                <c:when test="${foundOrder.paymentMethod == 'BANK'}">Chuyển khoản ngân hàng (QR Code)</c:when>
                <c:otherwise>Thanh toán tiền mặt khi nhận hàng (COD)</c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="info-block">
            <label><i class="fa-solid fa-shield-halved"></i> Đơn vị vận chuyển</label>
            <div class="val" style="color: var(--primary-color);">GreenMart FastExpress (Nội thành trong ngày)</div>
          </div>
        </div>

        <!-- Danh sách sản phẩm trong đơn -->
        <h3 style="font-size: 16px; margin-bottom: 12px; color: #1e293b;">
          <i class="fa-solid fa-basket-shopping"></i> Chi tiết sản phẩm trong đơn
        </h3>
        <table class="tracking-items-table">
          <thead>
            <tr>
              <th>Sản phẩm</th>
              <th style="text-align: right;">Đơn giá</th>
              <th style="text-align: center;">Số lượng</th>
              <th style="text-align: right;">Thành tiền</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty foundOrder.items}">
                <tr><td colspan="4" style="text-align:center;color:#888;">Chi tiết mặt hàng đang được cập nhật.</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="it" items="${foundOrder.items}">
                  <tr>
                    <td><strong>${it.productName}</strong></td>
                    <td style="text-align: right; color: #475569;">
                      <fmt:formatNumber value="${it.productPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                    </td>
                    <td style="text-align: center; font-weight: bold;">&times; ${it.quantity}</td>
                    <td style="text-align: right; font-weight: 700; color: #0f172a;">
                      <fmt:formatNumber value="${it.productPrice * it.quantity}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>

        <!-- Bảng tính tiền -->
        <div style="background: #ffffff; border-radius: 8px; padding: 15px 20px; border: 1px solid #e2e8f0; margin-bottom: 25px; max-width: 380px; margin-left: auto;">
          <div style="display:flex; justify-content:space-between; margin-bottom: 8px; font-size: 14px; color: #64748b;">
            <span>Tạm tính:</span>
            <span><fmt:formatNumber value="${foundOrder.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
          </div>
          <c:if test="${foundOrder.discount != null && foundOrder.discount > 0}">
            <div style="display:flex; justify-content:space-between; margin-bottom: 8px; font-size: 14px; color: #16a34a;">
              <span>Giảm giá (${foundOrder.couponCode}):</span>
              <span>- <fmt:formatNumber value="${foundOrder.discount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
            </div>
          </c:if>
          <div style="display:flex; justify-content:space-between; margin-bottom: 8px; font-size: 14px; color: #64748b;">
            <span>Phí giao hàng:</span>
            <span style="color: #16a34a; font-weight: 600;">Miễn phí</span>
          </div>
          <div style="display:flex; justify-content:space-between; padding-top: 10px; border-top: 1px solid #e2e8f0; font-size: 18px; font-weight: bold; color: var(--primary-color);">
            <span>Tổng thanh toán:</span>
            <span><fmt:formatNumber value="${foundOrder.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
          </div>
        </div>

        <!-- Footer Actions -->
        <div class="tracking-footer-actions">
          <a href="chat?withAdmin=1&orderCode=${foundOrder.orderCode}" class="btn-primary" style="text-decoration:none; display:inline-flex; align-items:center; gap:8px;">
            <i class="fa-solid fa-comments"></i> Cần hỗ trợ? Chat với CSKH về đơn này
          </a>
          <div style="display:flex; gap:10px;">
            <button onclick="window.print()" class="btn-primary" style="background:#475569; display:inline-flex; align-items:center; gap:6px; padding:10px 16px;">
              <i class="fa-solid fa-print"></i> In hoá đơn
            </button>
            <a href="home" style="display:inline-flex; align-items:center; gap:6px; padding:10px 16px; border:1px solid #cbd5e1; border-radius:6px; color:#334155; text-decoration:none;">
              <i class="fa fa-arrow-left"></i> Tiếp tục mua sắm
            </a>
          </div>
        </div>

      </div>
    </c:if>

    <!-- NẾU NGƯỜI DÙNG ĐÃ ĐĂNG NHẬP VÀ CHƯA TÌM: HIỂN THỊ CÁC ĐƠN GẦN ĐÂY CỦA HỌ -->
    <c:if test="${empty foundOrder && not empty userRecentOrders}">
      <div style="background: white; border-radius: 12px; padding: 25px; border: 1px solid #e2e8f0; box-shadow: 0 4px 15px rgba(0,0,0,0.04);">
        <h3 style="font-size: 17px; margin-bottom: 15px; color: #0f172a;">
          <i class="fa-solid fa-clock-rotate-left" style="color: var(--primary-color);"></i>
          Các đơn hàng gần đây của bạn (${sessionScope.user.username})
        </h3>
        <p style="font-size: 13px; color: #64748b; margin-bottom: 16px;">
          Bấm vào mã đơn hàng để xem tiến trình giao hàng chi tiết:
        </p>
        <div style="display:grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 14px;">
          <c:forEach var="ro" items="${userRecentOrders}">
            <div style="border: 1px solid #e2e8f0; border-radius: 8px; padding: 14px 16px; background: #fafafa; display:flex; flex-direction:column; justify-content:space-between; gap:10px;">
              <div>
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 6px;">
                  <strong style="color: var(--text-heading); font-size: 15px;">#${ro.orderCode}</strong>
                  <span style="font-size: 11px; padding: 2px 8px; border-radius: 10px; font-weight: 600;
                    background: ${ro.status == 'Completed' ? '#dcfce7' : (ro.status == 'Shipping' ? '#e0f2fe' : (ro.status == 'Canceled' ? '#fee2e2' : '#fef3c7'))};
                    color: ${ro.status == 'Completed' ? '#166534' : (ro.status == 'Shipping' ? '#0369a1' : (ro.status == 'Canceled' ? '#991b1b' : '#92400e'))};">
                    ${ro.status == 'Completed' ? 'Hoàn tất' : (ro.status == 'Shipping' ? 'Đang giao' : (ro.status == 'Canceled' ? 'Đã hủy' : 'Chờ duyệt'))}
                  </span>
                </div>
                <div style="font-size: 12px; color: #64748b; margin-bottom: 4px;">
                  <i class="fa-regular fa-calendar"></i> ${ro.createdAt}
                </div>
                <div style="font-size: 14px; font-weight: bold; color: var(--primary-color);">
                  <fmt:formatNumber value="${ro.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                </div>
              </div>
              <a href="track-order?code=${ro.orderCode}" class="btn-primary" style="text-align:center; text-decoration:none; font-size: 13px; padding: 7px 12px;">
                <i class="fa-solid fa-truck-fast"></i> Theo dõi hành trình
              </a>
            </div>
          </c:forEach>
        </div>
      </div>
    </c:if>

  </div>

  <!-- THANH TIỆN ÍCH NỔI CỐ ĐỊNH DÍNH ĐÁY MÀN HÌNH (Fixed Bottom Sticky Dock) -->
  <div class="gm-floating-dock" id="gmFloatingDock">
    <!-- Nút 1: Xem giỏ hàng -->
    <a href="cart" class="dock-btn dock-btn-cart" title="Xem giỏ hàng của bạn">
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

    <!-- Nút 2: Chat Shopee-style dính đáy màn hình (Chuẩn theo pasted-image-1.png) -->
    <a href="chat<c:if test="${not empty foundOrder}">?withAdmin=1&orderCode=${foundOrder.orderCode}</c:if>" class="dock-btn dock-btn-chat" title="<c:choose><c:when test="${not empty foundOrder}">Chat với CSKH về đơn #${foundOrder.orderCode}</c:when><c:otherwise>Chat tư vấn trực tuyến với CSKH</c:otherwise></c:choose>">
      <div class="dock-chat-icon-wrap">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block; vertical-align:middle;">
          <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" fill="white" stroke="white"></path>
          <path d="M8 10c.8 1.2 2.2 1.8 4 1.8s3.2-.6 4-1.8" stroke="#ee4d2d" stroke-width="2.2" fill="none"></path>
        </svg>
      </div>
      <span style="letter-spacing:0.3px;">${not empty foundOrder ? 'Chat về đơn' : 'Chat'}</span>
      <i class="fa-solid fa-caret-down dock-chat-caret"></i>
      <span class="dock-badge-tab" id="floatingChatBadge">1</span>
    </a>
  </div>

</body>
</html>
