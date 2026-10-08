<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:if test="${empty sessionScope.user}">
  <c:redirect url="/auth?mode=login"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Thông Tin Tài Khoản - GreenMart</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .profile-page {
      background-color: #f6f8fb;
      min-height: 100vh;
      padding-bottom: 50px;
    }
    .profile-container {
      max-width: 1200px;
      margin: 25px auto;
      padding: 0 20px;
    }
    .profile-hero {
      background: linear-gradient(135deg, #253d4e 0%, #2f4858 100%);
      color: white;
      border-radius: 12px;
      padding: 30px 35px;
      margin-bottom: 25px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
      gap: 20px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.06);
    }
    .profile-avatar-wrap {
      display: flex;
      align-items: center;
      gap: 20px;
    }
    .profile-avatar {
      width: 75px;
      height: 75px;
      border-radius: 50%;
      background: var(--primary-color);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 32px;
      color: white;
      box-shadow: 0 2px 10px rgba(59, 183, 126, 0.4);
    }
    .profile-meta h2 {
      font-size: 22px;
      margin-bottom: 4px;
      color: white;
    }
    .profile-meta p {
      font-size: 13px;
      color: #cbd5e1;
      margin: 2px 0;
    }
    .badge-role {
      display: inline-block;
      font-size: 11px;
      padding: 3px 8px;
      border-radius: 12px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .badge-admin {
      background: #fef3c7;
      color: #92400e;
    }
    .badge-user {
      background: #dcfce7;
      color: #166534;
    }
    .profile-stats {
      display: flex;
      gap: 20px;
      flex-wrap: wrap;
    }
    .stat-pill {
      background: rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(4px);
      padding: 12px 20px;
      border-radius: 8px;
      text-align: center;
      min-width: 110px;
      border: 1px solid rgba(255, 255, 255, 0.15);
    }
    .stat-pill .num {
      font-size: 20px;
      font-weight: bold;
      color: #38bdf8;
    }
    .stat-pill .num.green {
      color: #4ade80;
    }
    .stat-pill .num.yellow {
      color: #fde047;
    }
    .stat-pill .label {
      font-size: 12px;
      color: #e2e8f0;
      margin-top: 2px;
    }
    .profile-grid {
      display: grid;
      grid-template-columns: 280px 1fr;
      gap: 25px;
    }
    .profile-menu {
      background: white;
      border-radius: 10px;
      border: 1px solid var(--border-color);
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0,0,0,0.03);
      height: fit-content;
    }
    .menu-item {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 15px 20px;
      color: var(--text-heading);
      text-decoration: none;
      font-weight: 500;
      border-bottom: 1px solid var(--border-color);
      transition: all 0.2s;
      cursor: pointer;
    }
    .menu-item:last-child {
      border-bottom: none;
    }
    .menu-item:hover, .menu-item.active {
      background: #f0fdf4;
      color: var(--primary-color);
      border-left: 4px solid var(--primary-color);
      padding-left: 16px;
    }
    .menu-item i {
      font-size: 16px;
      width: 20px;
      text-align: center;
    }
    .profile-card {
      background: white;
      border-radius: 10px;
      border: 1px solid var(--border-color);
      padding: 30px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.03);
    }
    .card-title {
      font-size: 18px;
      font-weight: 700;
      color: var(--text-heading);
      margin-bottom: 20px;
      padding-bottom: 12px;
      border-bottom: 1px solid var(--border-color);
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .alert-box {
      padding: 14px 18px;
      border-radius: 8px;
      margin-bottom: 20px;
      font-size: 14px;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .alert-success {
      background: #ecfdf5;
      color: #065f46;
      border: 1px solid #a7f3d0;
    }
    .alert-danger {
      background: #fef2f2;
      color: #991b1b;
      border: 1px solid #fecaca;
    }
    .tab-pane {
      display: none;
    }
    .tab-pane.active {
      display: block;
    }
    .order-card {
      border: 1px solid var(--border-color);
      border-radius: 8px;
      padding: 18px 20px;
      margin-bottom: 16px;
      background: #ffffff;
      transition: all 0.2s;
    }
    .order-card:hover {
      box-shadow: 0 4px 12px rgba(0,0,0,0.05);
      border-color: #cbd5e1;
    }
    .order-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 12px;
      padding-bottom: 10px;
      border-bottom: 1px dashed var(--border-color);
      flex-wrap: wrap;
      gap: 10px;
    }
    .order-code {
      font-weight: bold;
      color: var(--text-heading);
      font-size: 15px;
    }
    .order-date {
      color: #64748b;
      font-size: 13px;
    }
    .status-badge {
      display: inline-block;
      padding: 4px 10px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
    }
    .status-waiting {
      background: #fef3c7;
      color: #92400e;
    }
    .status-shipping {
      background: #e0f2fe;
      color: #0369a1;
    }
    .status-completed {
      background: #dcfce7;
      color: #166534;
    }
    .status-cancelled {
      background: #fee2e2;
      color: #991b1b;
    }
    .order-items-list {
      margin: 10px 0;
      padding-left: 0;
      list-style: none;
    }
    .order-item-row {
      display: flex;
      justify-content: space-between;
      padding: 6px 0;
      font-size: 14px;
      color: var(--text-body);
      border-bottom: 1px solid #f8fafc;
    }
    .order-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 12px;
      padding-top: 10px;
      border-top: 1px solid var(--border-color);
      flex-wrap: wrap;
      gap: 10px;
    }
    .order-total {
      font-size: 16px;
      font-weight: bold;
      color: var(--primary-color);
    }
    @media (max-width: 850px) {
      .profile-grid {
        grid-template-columns: 1fr;
      }
      .profile-hero {
        flex-direction: column;
        align-items: flex-start;
      }
    }

    /* ===================================================
       BOTTOM STICKY ACTION TABS (Thanh tab tiện ích dính đáy màn hình)
       Luôn luôn cố định ở đáy màn hình (bottom: 0) kể cả khi cuộn trang
       =================================================== */
    .gm-floating-dock {
      position: fixed !important;
      bottom: 0 !important;
      right: 24px !important;
      z-index: 99999 !important;
      display: flex !important;
      flex-direction: row !important;
      align-items: flex-end !important;
      gap: 10px !important;
      pointer-events: none !important;
      line-height: normal !important;
      margin: 0 !important;
      padding: 0 !important;
    }

    .dock-btn {
      pointer-events: auto !important;
      display: inline-flex !important;
      align-items: center !important;
      justify-content: center !important;
      gap: 7px !important;
      height: 42px !important;
      padding: 0 16px !important;
      border-radius: 8px 8px 0 0 !important;
      text-decoration: none !important;
      font-weight: 600 !important;
      font-size: 13.5px !important;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif !important;
      box-shadow: 0 -3px 12px rgba(0, 0, 0, 0.16) !important;
      transition: transform 0.2s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.2s ease, background-color 0.2s ease !important;
      cursor: pointer !important;
      user-select: none !important;
      border: none !important;
      outline: none !important;
      position: relative !important;
      box-sizing: border-box !important;
      white-space: nowrap !important;
    }

    .dock-btn:hover {
      transform: translateY(-4px) !important;
      box-shadow: 0 -6px 18px rgba(0, 0, 0, 0.24) !important;
    }

    .dock-btn:active {
      transform: translateY(0) !important;
    }

    /* Tab 1: Theo dõi tiến trình đơn hàng */
    .dock-btn-track {
      background: #0284c7 !important;
      color: #ffffff !important;
    }

    .dock-btn-track:hover {
      background: #0369a1 !important;
      color: #ffffff !important;
    }

    .dock-btn-track i {
      color: #ffffff !important;
      font-size: 15px !important;
    }

    /* Tab 2: Giỏ hàng GreenMart */
    .dock-btn-cart {
      background: #3bb77e !important;
      color: #ffffff !important;
    }

    .dock-btn-cart:hover {
      background: #2ea06c !important;
      color: #ffffff !important;
    }

    .dock-btn-cart i {
      color: #ffffff !important;
      font-size: 15px !important;
    }

    /* Tab 3: Chat Shopee-style (Đỏ cam #ee4d2d chuẩn 100% theo mẫu) */
    .dock-btn-chat {
      background: #ee4d2d !important;
      color: #ffffff !important;
    }

    .dock-btn-chat:hover {
      background: #d73211 !important;
      color: #ffffff !important;
    }

    .dock-chat-icon-wrap {
      display: inline-flex !important;
      align-items: center !important;
      justify-content: center !important;
    }

    .dock-chat-caret {
      font-size: 10px !important;
      margin-left: 2px !important;
      opacity: 0.85 !important;
      color: #ffffff !important;
    }

    /* Badge số 1 góc trên bên phải của tab Chat (Chuẩn như ảnh mẫu pasted-image-1.png) */
    .dock-badge-tab {
      position: absolute !important;
      top: -7px !important;
      right: -5px !important;
      background-color: #ee4d2d !important;
      color: #ffffff !important;
      border-radius: 50% !important;
      min-width: 18px !important;
      height: 18px !important;
      padding: 0 4px !important;
      font-size: 11px !important;
      font-weight: 700 !important;
      line-height: 14px !important;
      display: inline-flex !important;
      align-items: center !important;
      justify-content: center !important;
      border: 2px solid #ffffff !important;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.25) !important;
    }

    .dock-icon-box {
      position: relative !important;
      display: inline-flex !important;
      align-items: center !important;
      justify-content: center !important;
    }

    .dock-badge {
      position: absolute !important;
      top: -8px !important;
      right: -10px !important;
      background-color: #ef4444 !important;
      color: white !important;
      border-radius: 12px !important;
      padding: 1px 6px !important;
      font-size: 10.5px !important;
      font-weight: 700 !important;
      min-width: 16px !important;
      text-align: center !important;
      line-height: 14px !important;
      border: 2px solid #ffffff !important;
    }

    .dock-cart-info {
      display: inline-flex !important;
      align-items: center !important;
      gap: 6px !important;
    }

    .dock-subtotal {
      background: rgba(0, 0, 0, 0.2) !important;
      padding: 2px 8px !important;
      border-radius: 12px !important;
      font-size: 12px !important;
      font-weight: 700 !important;
    }

    @media (max-width: 600px) {
      .gm-floating-dock {
        right: 12px !important;
        gap: 6px !important;
      }
      .dock-btn {
        height: 38px !important;
        padding: 0 12px !important;
        font-size: 12px !important;
      }
      .dock-subtotal {
        display: none !important;
      }
    }
  </style>

</head>
<body class="profile-page">

  <!-- Header -->
  <header class="header">
    <a href="home" class="logo">
      <i class="fa-solid fa-leaf"></i> GREENMART
    </a>
    <div class="header-actions">
      <a href="home" class="action-item"><i class="fa fa-arrow-left"></i> Tiếp tục mua sắm</a>
      <a href="profile" class="action-item" style="color: var(--primary-color); font-weight: 600;">
        <i class="fa-solid fa-circle-user"></i>
        <span>${sessionScope.user.username}</span>
      </a>
      <a href="chat" class="action-item" title="Trò chuyện & Hỗ trợ">
        <i class="fa-solid fa-comments"></i>
        <span>Trò chuyện</span>
      </a>
      <a href="cart" class="action-item">
        <i class="fa-solid fa-cart-shopping"></i>
        <span>Giỏ hàng</span>
        <span class="badge">
          ${not empty sessionScope.cart ? sessionScope.cart.totalQuantity : 0}
        </span>
      </a>
      <a href="auth?action=logout" class="action-item" style="color:#ef4444;" title="Đăng xuất">
        <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
      </a>
    </div>
  </header>

  <!-- Navigation -->
  <nav class="navbar">
    <ul class="nav-links">
      <li><a href="home"><i class="fa fa-home"></i> Trang chủ</a></li>
      <li><a href="home#products"><i class="fa-solid fa-store"></i> Sản phẩm</a></li>
      <li><a href="cart"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng</a></li>
      <li><a href="track-order"><i class="fa-solid fa-truck-fast"></i> Tra cứu đơn hàng</a></li>
      <li><a href="chat"><i class="fa-solid fa-comments"></i> Trò chuyện / Chat</a></li>
      <li><a href="profile" style="text-decoration: underline;"><i class="fa-solid fa-user-gear"></i> Thông tin User</a></li>
      <c:if test="${sessionScope.user.role == 'admin'}">
        <li><a href="admin"><i class="fa-solid fa-gauge"></i> Quản trị (Admin)</a></li>
      </c:if>
    </ul>
    <div style="color: white; font-size: 14px;"><i class="fa-solid fa-shield-halved"></i> Trung tâm tài khoản an toàn</div>
  </nav>

  <div class="profile-container">

    <!-- Alerts -->
    <c:if test="${not empty sessionScope.profileSuccess}">
      <div class="alert-box alert-success">
        <i class="fa-solid fa-circle-check"></i>
        <span>${sessionScope.profileSuccess}</span>
      </div>
      <c:remove var="profileSuccess" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.profileError}">
      <div class="alert-box alert-danger">
        <i class="fa-solid fa-circle-exclamation"></i>
        <span>${sessionScope.profileError}</span>
      </div>
      <c:remove var="profileError" scope="session"/>
    </c:if>

    <!-- Hero Card -->
    <div class="profile-hero">
      <div class="profile-avatar-wrap">
        <div class="profile-avatar">
          <i class="fa-solid fa-user"></i>
        </div>
        <div class="profile-meta">
          <h2>${sessionScope.user.username}</h2>
          <p><i class="fa-regular fa-envelope"></i> ${sessionScope.user.email}</p>
          <div style="margin-top: 6px; display: flex; align-items: center; gap: 8px;">
            <span class="badge-role ${sessionScope.user.role == 'admin' ? 'badge-admin' : 'badge-user'}">
              <i class="fa-solid ${sessionScope.user.role == 'admin' ? 'fa-crown' : 'fa-circle-check'}"></i>
              ${sessionScope.user.role == 'admin' ? 'Quản trị viên (Admin)' : 'Khách hàng thân thiết'}
            </span>
            <span style="font-size: 12px; color: #cbd5e1;">
              • Tham gia: ${empty sessionScope.user.createdAt ? '2026-09-01' : sessionScope.user.createdAt}
            </span>
          </div>
        </div>
      </div>

      <div class="profile-stats">
        <div class="stat-pill">
          <div class="num">${totalOrders}</div>
          <div class="label">Tổng đơn hàng</div>
        </div>
        <div class="stat-pill">
          <div class="num green">${completedOrders}</div>
          <div class="label">Đơn thành công</div>
        </div>
        <div class="stat-pill">
          <div class="num yellow">
            <fmt:formatNumber value="${totalSpent}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
          </div>
          <div class="label">Tổng chi tiêu</div>
        </div>
      </div>
    </div>

    <!-- Main Grid -->
    <div class="profile-grid">
      <!-- Left Menu -->
      <aside class="profile-menu">
        <a href="#profile" class="menu-item ${activeTab == 'profile' || empty activeTab ? 'active' : ''}" onclick="switchTab('profile', this)">
          <i class="fa-solid fa-id-card"></i> Thông tin cá nhân
        </a>
        <a href="#orders" class="menu-item ${activeTab == 'orders' ? 'active' : ''}" onclick="switchTab('orders', this)">
          <i class="fa-solid fa-clock-rotate-left"></i> Lịch sử đơn hàng
          <span style="margin-left: auto; background: #e2e8f0; font-size: 11px; padding: 2px 7px; border-radius: 10px; color: #475569;">
            ${totalOrders}
          </span>
        </a>
        <a href="#password" class="menu-item ${activeTab == 'password' ? 'active' : ''}" onclick="switchTab('password', this)">
          <i class="fa-solid fa-lock"></i> Đổi mật khẩu
        </a>
        <a href="chat" class="menu-item" style="color: var(--primary-color);">
          <i class="fa-solid fa-comments"></i> Hộp thư / Chat
        </a>
        <c:if test="${sessionScope.user.role == 'admin'}">
          <a href="admin" class="menu-item" style="color: #2563eb;">
            <i class="fa-solid fa-gauge"></i> Trang Quản Trị
          </a>
        </c:if>
        <a href="auth?action=logout" class="menu-item" style="color: #dc2626;">
          <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
        </a>
      </aside>

      <!-- Right Tab Content -->
      <main class="profile-card">

        <!-- TAB 1: THÔNG TIN CÁ NHÂN -->
        <div id="tab-profile" class="tab-pane ${activeTab == 'profile' || empty activeTab ? 'active' : ''}">
          <h3 class="card-title">
            <i class="fa-solid fa-user-pen" style="color: var(--primary-color);"></i>
            Thông Tin Cá Nhân
          </h3>

          <form action="profile" method="POST">
            <input type="hidden" name="action" value="updateProfile">

            <div class="form-group">
              <label>Địa chỉ Email</label>
              <input type="email" value="${sessionScope.user.email}" disabled
                     style="background: #f1f5f9; color: #64748b; cursor: not-allowed;">
              <small style="color: #64748b; font-size: 12px; margin-top: 3px; display: block;">
                Email được dùng làm tài khoản đăng nhập và không thể sửa đổi.
              </small>
            </div>

            <div class="form-group">
              <label>Họ và tên hiển thị <span style="color:red;">*</span></label>
              <input type="text" name="username" value="${sessionScope.user.username}" required
                     placeholder="Ví dụ: Nguyễn Văn An">
            </div>

            <div class="form-group">
              <label>Số điện thoại liên hệ</label>
              <input type="tel" name="phone" value="${sessionScope.user.phone}"
                     placeholder="Ví dụ: 0987654321" pattern="[0-9]{10,11}"
                     title="Số điện thoại gồm 10 hoặc 11 chữ số">
            </div>

            <div class="form-group">
              <label>Địa chỉ nhận hàng mặc định</label>
              <textarea name="address" rows="3" placeholder="Số nhà, tên đường, Phường/Xã, Quận/Huyện, Tỉnh/TP">${sessionScope.user.address}</textarea>
            </div>

            <div style="margin-top: 25px;">
              <button type="submit" class="btn-primary" style="display:inline-flex;align-items:center;gap:8px;">
                <i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi
              </button>
            </div>
          </form>
        </div>

        <!-- TAB 2: ĐỔI MẬT KHẨU -->
        <div id="tab-password" class="tab-pane ${activeTab == 'password' ? 'active' : ''}">
          <h3 class="card-title">
            <i class="fa-solid fa-key" style="color: var(--primary-color);"></i>
            Đổi Mật Khẩu
          </h3>

          <form action="profile" method="POST" style="max-width: 500px;">
            <input type="hidden" name="action" value="changePassword">

            <div class="form-group">
              <label>Mật khẩu hiện tại <span style="color:red;">*</span></label>
              <input type="password" name="oldPassword" required placeholder="Nhập mật khẩu đang dùng">
            </div>

            <div class="form-group">
              <label>Mật khẩu mới <span style="color:red;">*</span></label>
              <input type="password" name="newPassword" required placeholder="Tối thiểu 6 ký tự" minlength="6">
            </div>

            <div class="form-group">
              <label>Xác nhận mật khẩu mới <span style="color:red;">*</span></label>
              <input type="password" name="confirmPassword" required placeholder="Nhập lại mật khẩu mới" minlength="6">
            </div>

            <div style="margin-top: 25px;">
              <button type="submit" class="btn-primary" style="display:inline-flex;align-items:center;gap:8px;">
                <i class="fa-solid fa-shield-halved"></i> Cập nhật mật khẩu
              </button>
            </div>
          </form>
        </div>

        <!-- TAB 3: LỊCH SỬ ĐƠN HÀNG (Redesigned Modern UI) -->
        <div id="tab-orders" class="tab-pane ${activeTab == 'orders' ? 'active' : ''}">
          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; flex-wrap:wrap; gap:10px;">
            <h3 class="card-title" style="margin-bottom:0; padding-bottom:0; border-bottom:none;">
              <i class="fa-solid fa-clock-rotate-left" style="color: var(--primary-color);"></i>
              Lịch Sử Đơn Hàng Của Bạn
            </h3>
            <a href="track-order" class="btn-track-pill" style="font-size:12.5px; padding:6px 14px;">
              <i class="fa-solid fa-truck-fast"></i> Tra cứu mã vận đơn
            </a>
          </div>

          <c:choose>
            <c:when test="${empty orders}">
              <div style="text-align: center; padding: 50px 20px; background: #f8fafc; border-radius: 12px; border:1px solid #e2e8f0;">
                <i class="fa-solid fa-bag-shopping" style="font-size: 48px; color: #cbd5e1; margin-bottom: 15px; display:block;"></i>
                <h4 style="color: var(--text-heading); margin-bottom: 8px;">Bạn chưa có đơn hàng nào</h4>
                <p style="color: var(--text-body); font-size: 14px; margin-bottom: 20px;">
                  Hãy khám phá các sản phẩm tươi sạch tại GreenMart và đặt hàng ngay hôm nay!
                </p>
                <a href="home" class="btn-primary" style="text-decoration: none; display:inline-flex; align-items:center; gap:8px;">
                  <i class="fa fa-arrow-left"></i> Mua sắm nông sản ngay
                </a>
              </div>
            </c:when>
            <c:otherwise>
              <!-- Order Status Filter Bar (Instant Tabs) -->
              <div class="profile-orders-tabs">
                <button type="button" class="profile-order-tab-btn active" onclick="filterUserOrders('all', this)">
                  <i class="fa-solid fa-list-check"></i> Tất cả (${orders.size()})
                </button>
                <button type="button" class="profile-order-tab-btn" onclick="filterUserOrders('Waiting', this)">
                  <i class="fa-solid fa-hourglass-half" style="color:#d97706;"></i> Chờ duyệt
                </button>
                <button type="button" class="profile-order-tab-btn" onclick="filterUserOrders('Shipping', this)">
                  <i class="fa-solid fa-truck-fast" style="color:#0284c7;"></i> Đang giao
                </button>
                <button type="button" class="profile-order-tab-btn" onclick="filterUserOrders('Completed', this)">
                  <i class="fa-solid fa-circle-check" style="color:#16a34a;"></i> Hoàn tất
                </button>
                <button type="button" class="profile-order-tab-btn" onclick="filterUserOrders('Canceled', this)">
                  <i class="fa-solid fa-ban" style="color:#dc2626;"></i> Đã hủy
                </button>
              </div>

              <!-- Orders List Container -->
              <div class="orders-container" id="userOrdersListContainer">
                <c:forEach var="order" items="${orders}">
                  <div class="order-card-v2" data-order-status="${order.status}">
                    <!-- Card Top Header -->
                    <div class="order-card-top">
                      <div>
                        <div class="order-id-label">
                          <i class="fa-solid fa-receipt" style="color:var(--primary-color);"></i>
                          Đơn hàng #${order.orderCode}
                        </div>
                        <div class="order-time-meta">
                          <i class="fa-regular fa-calendar"></i> ${order.createdAt}
                        </div>
                      </div>
                      <div>
                        <c:choose>
                          <c:when test="${order.status == 'Completed' || order.status == 'Delivered'}">
                            <span class="status-pill pill-completed"><i class="fa-solid fa-circle-check"></i> Hoàn tất</span>
                          </c:when>
                          <c:when test="${order.status == 'Shipping'}">
                            <span class="status-pill pill-shipping"><i class="fa-solid fa-truck-fast"></i> Đang giao hàng</span>
                          </c:when>
                          <c:when test="${order.status == 'Confirmed'}">
                            <span class="status-pill pill-confirmed"><i class="fa-solid fa-boxes-packing"></i> Đã xác nhận</span>
                          </c:when>
                          <c:when test="${order.status == 'Canceled' || order.status == 'Cancelled'}">
                            <span class="status-pill pill-canceled"><i class="fa-solid fa-ban"></i> Đã hủy</span>
                          </c:when>
                          <c:otherwise>
                            <span class="status-pill pill-waiting"><i class="fa-solid fa-hourglass-half"></i> Chờ duyệt</span>
                          </c:otherwise>
                        </c:choose>
                      </div>
                    </div>

                    <!-- Mini Stepper Visual Bar -->
                    <c:choose>
                      <c:when test="${order.status == 'Canceled' || order.status == 'Cancelled'}">
                        <div style="background:#fef2f2; border:1px solid #fecaca; border-radius:8px; padding:10px 14px; margin-bottom:14px; font-size:13px; color:#991b1b; display:flex; align-items:center; gap:8px;">
                          <i class="fa-solid fa-circle-exclamation"></i>
                          <span>Đơn hàng này đã bị hủy. Liên hệ CSKH GreenMart nếu bạn cần hỗ trợ thêm.</span>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <div class="order-card-stepper">
                          <div class="card-step-item step-done">
                            <div class="card-step-circle"><i class="fa-solid fa-check"></i></div>
                            <div class="card-step-name">Đặt hàng</div>
                          </div>
                          <div class="card-step-item ${order.status == 'Confirmed' || order.status == 'Shipping' || order.status == 'Completed' || order.status == 'Delivered' ? 'step-done' : (order.status == 'Waiting' ? 'step-active' : '')}">
                            <div class="card-step-circle">
                              <c:choose>
                                <c:when test="${order.status == 'Confirmed' || order.status == 'Shipping' || order.status == 'Completed' || order.status == 'Delivered'}">
                                  <i class="fa-solid fa-check"></i>
                                </c:when>
                                <c:otherwise>2</c:otherwise>
                              </c:choose>
                            </div>
                            <div class="card-step-name">Xác nhận</div>
                          </div>
                          <div class="card-step-item ${order.status == 'Shipping' || order.status == 'Completed' || order.status == 'Delivered' ? 'step-done' : (order.status == 'Confirmed' ? 'step-active' : '')}">
                            <div class="card-step-circle">
                              <c:choose>
                                <c:when test="${order.status == 'Completed' || order.status == 'Delivered'}">
                                  <i class="fa-solid fa-check"></i>
                                </c:when>
                                <c:otherwise>3</c:otherwise>
                              </c:choose>
                            </div>
                            <div class="card-step-name">Đang giao</div>
                          </div>
                          <div class="card-step-item ${order.status == 'Completed' || order.status == 'Delivered' ? 'step-done' : (order.status == 'Shipping' ? 'step-active' : '')}">
                            <div class="card-step-circle">
                              <c:choose>
                                <c:when test="${order.status == 'Completed' || order.status == 'Delivered'}">
                                  <i class="fa-solid fa-check"></i>
                                </c:when>
                                <c:otherwise>4</c:otherwise>
                              </c:choose>
                            </div>
                            <div class="card-step-name">Hoàn tất</div>
                          </div>
                        </div>
                      </c:otherwise>
                    </c:choose>

                    <!-- Items list -->
                    <div class="order-items-grid">
                      <c:forEach var="item" items="${order.items}">
                        <div class="order-item-chip">
                          <div class="order-item-left">
                            <span class="order-item-badge">&times; ${item.quantity}</span>
                            <span style="font-weight:600; color:var(--text-heading);">${item.productName}</span>
                          </div>
                          <div style="font-weight:600; color:#475569;">
                            <fmt:formatNumber value="${item.productPrice * item.quantity}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                          </div>
                        </div>
                      </c:forEach>
                    </div>

                    <!-- Card Bottom Footer -->
                    <div class="order-card-bottom">
                      <div>
                        <span style="font-size:12.5px; color:#64748b;">
                          <i class="fa-solid fa-wallet"></i> 
                          ${order.paymentMethod == 'BANK' ? 'Chuyển khoản (VietQR)' : 'Thanh toán COD'}
                        </span>
                        <c:if test="${not empty order.couponCode}">
                          <span style="margin-left:10px; font-size:12px; color:#16a34a; background:#ecfdf5; padding:2px 8px; border-radius:12px; font-weight:600;">
                            <i class="fa-solid fa-ticket"></i> Mã: ${order.couponCode}
                          </span>
                        </c:if>
                      </div>

                      <div style="display:flex; align-items:center; gap:16px; flex-wrap:wrap;">
                        <div style="font-size:14px; color:#475569;">
                          Tổng thanh toán: 
                          <strong style="color:var(--primary-color); font-size:17px; font-weight:800; margin-left:4px;">
                            <fmt:formatNumber value="${order.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                          </strong>
                        </div>

                        <div class="order-card-actions">
                          <a href="track-order?code=${order.orderCode}" class="btn-track-pill" title="Xem tiến trình giao hàng chi tiết">
                            <i class="fa-solid fa-truck-fast"></i> Theo dõi
                          </a>
                          <a href="chat?withAdmin=1&orderCode=${order.orderCode}" class="btn-chat-order-pill" title="Hỏi bộ phận CSKH GreenMart về đơn này">
                            <i class="fa-solid fa-headset"></i> Hỏi CSKH
                          </a>
                        </div>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </div>

              <!-- Empty status filter message -->
              <div id="noFilteredOrdersNotice" style="display:none; text-align:center; padding:40px 20px; color:#94a3b8;">
                <i class="fa-regular fa-folder-open" style="font-size:32px; display:block; margin-bottom:8px;"></i>
                Không có đơn hàng nào thuộc trạng thái này.
              </div>
            </c:otherwise>
          </c:choose>
        </div>

      </main>
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

    <!-- Nút 3: Chat Shopee-style dính đáy màn hình (Chuẩn theo pasted-image-1.png) -->
    <a href="chat" class="dock-btn dock-btn-chat" id="dockChatActionBtn" title="Chat tư vấn trực tuyến với CSKH GreenMart">
      <div class="dock-chat-icon-wrap">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block; vertical-align:middle;">
          <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" fill="white" stroke="white"></path>
          <path d="M8 10c.8 1.2 2.2 1.8 4 1.8s3.2-.6 4-1.8" stroke="#ee4d2d" stroke-width="2.2" fill="none"></path>
        </svg>
      </div>
      <span style="letter-spacing:0.3px;">Chat</span>
      <i class="fa-solid fa-caret-down dock-chat-caret"></i>
      <span class="dock-badge-tab" id="floatingChatBadge">1</span>
    </a>
  </div>

  <script>
    function switchTab(tabId, el) {
      document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
      document.querySelectorAll('.menu-item').forEach(m => m.classList.remove('active'));
      
      const targetPane = document.getElementById('tab-' + tabId);
      if (targetPane) {
        targetPane.classList.add('active');
      }
      if (el) {
        el.classList.add('active');
      }
    }

    function filterUserOrders(status, btnEl) {
      document.querySelectorAll('.profile-order-tab-btn').forEach(b => b.classList.remove('active'));
      if (btnEl) btnEl.classList.add('active');

      const cards = document.querySelectorAll('.order-card-v2');
      let visibleCount = 0;

      cards.forEach(card => {
        const orderStatus = (card.getAttribute('data-order-status') || '').trim();
        let match = false;
        if (status === 'all') {
          match = true;
        } else if (status === 'Completed') {
          match = (orderStatus === 'Completed' || orderStatus === 'Delivered');
        } else if (status === 'Canceled') {
          match = (orderStatus === 'Canceled' || orderStatus === 'Cancelled');
        } else {
          match = (orderStatus.toLowerCase() === status.toLowerCase());
        }

        if (match) {
          card.style.display = 'block';
          visibleCount++;
        } else {
          card.style.display = 'none';
        }
      });

      const notice = document.getElementById('noFilteredOrdersNotice');
      if (notice) {
        notice.style.display = (visibleCount === 0) ? 'block' : 'none';
      }
    }

    // Auto open tab based on URL hash if present
    window.addEventListener('DOMContentLoaded', () => {
      const hash = window.location.hash.replace('#', '');
      if (hash && ['profile', 'password', 'orders'].includes(hash)) {
        const link = document.querySelector('a[href="#' + hash + '"]');
        switchTab(hash, link);
      }
    });
  </script>

</body>
</html>
