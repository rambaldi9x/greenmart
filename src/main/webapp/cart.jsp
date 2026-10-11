<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:if test="${cart == null}">
  <c:redirect url="/cart"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Giỏ Hàng & Thanh Toán - GreenMart</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="css/cart.css">
</head>
<body class="cart-page-bg">

  <!-- Top bar -->
  <div class="top-bar">
    <div><i class="fa fa-phone"></i> Hotline Hỗ Trợ 24/7: 1900 6868 | Giao hàng tận nơi siêu tốc</div>
    <div>GreenMart - Thực Phẩm Sạch Chuẩn VietGAP</div>
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
      <div class="action-item" style="position:relative;">
        <i class="fa-solid fa-cart-shopping" style="color: var(--primary-color);"></i>
        <span style="font-weight: 700;">Giỏ hàng</span>
        <span class="badge" id="cart-count">
          ${not empty sessionScope.cart ? sessionScope.cart.totalQuantity : 0}
        </span>
      </div>
    </div>
  </header>

  <!-- Navbar -->
  <nav class="navbar">
    <ul class="nav-links">
      <li><a href="home"><i class="fa fa-home"></i> Trang chủ</a></li>
      <li><a href="home#products"><i class="fa-solid fa-store"></i> Sản phẩm</a></li>
      <li><a href="cart" style="text-decoration: underline;"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng</a></li>
      <li><a href="track-order"><i class="fa-solid fa-truck-fast"></i> Tra cứu đơn hàng</a></li>
      <li><a href="chat"><i class="fa-solid fa-comments"></i> Trò chuyện / Chat</a></li>
      <c:if test="${not empty sessionScope.user}">
        <li><a href="profile"><i class="fa-solid fa-user-gear"></i> Thông tin User</a></li>
      </c:if>
      <c:if test="${sessionScope.user.role == 'admin'}">
        <li><a href="admin"><i class="fa-solid fa-gauge"></i> Quản trị (Admin)</a></li>
      </c:if>
    </ul>
    <div style="color: white; font-size: 14px;"><i class="fa-solid fa-shield-halved"></i> Đảm bảo hoàn tiền 100% nếu không tươi ngon</div>
  </nav>

  <!-- Stepper Progress Header -->
  <div class="cart-steps-header">
    <div class="cart-steps-wrap">
      <div class="cart-step-item active">
        <span class="cart-step-num"><i class="fa-solid fa-cart-shopping"></i></span>
        <span>1. Giỏ Hàng Của Bạn</span>
      </div>
      <div class="cart-step-divider"></div>
      <div class="cart-step-item ${not empty sessionScope.cart && !sessionScope.cart.isEmpty() ? 'active' : ''}">
        <span class="cart-step-num"><i class="fa-solid fa-location-dot"></i></span>
        <span>2. Thông Tin Nhận Hàng</span>
      </div>
      <div class="cart-step-divider"></div>
      <div class="cart-step-item ${param.orderSuccess == '1' ? 'active' : ''}">
        <span class="cart-step-num"><i class="fa-solid fa-circle-check"></i></span>
        <span>3. Hoàn Tất Đơn Hàng</span>
      </div>
    </div>
  </div>

  <!-- NẾU ĐẶT HÀNG THÀNH CÔNG -->
  <c:if test="${param.orderSuccess == '1'}">
    <div class="order-success-card">
      <div class="success-icon-bubble">
        <i class="fa-solid fa-check"></i>
      </div>
      <h2 style="color: #065f46; font-size: 26px; margin-bottom: 8px;">Đặt Hàng Thành Công!</h2>
      <p style="color: #475569; font-size: 15px; margin-bottom: 20px;">
        Cảm ơn <strong>${param.name}</strong>! Đơn hàng của bạn đã được ghi nhận trên hệ thống GreenMart.
      </p>

      <div style="background: #f8fafc; border: 1px dashed #cbd5e1; border-radius: 10px; padding: 18px 24px; max-width: 480px; margin: 0 auto 25px; text-align: left;">
        <div style="display:flex; justify-content:space-between; margin-bottom:8px;">
          <span style="color:#64748b;">Mã đơn hàng:</span>
          <strong style="color:#0f172a; font-size:16px;">#${param.orderCode}</strong>
        </div>
        <div style="display:flex; justify-content:space-between; margin-bottom:8px;">
          <span style="color:#64748b;">Tổng số tiền:</span>
          <strong style="color:var(--primary-color); font-size:18px;">
            <fmt:formatNumber value="${param.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
          </strong>
        </div>
        <div style="display:flex; justify-content:space-between; font-size:13px; color:#64748b;">
          <span>Thời gian giao ước tính:</span>
          <span style="color:#16a34a; font-weight:600;"><i class="fa-solid fa-bolt"></i> Giao hỏa tốc 2 giờ</span>
        </div>
      </div>

      <div style="display:flex; gap:12px; justify-content:center; flex-wrap:wrap;">
        <a href="track-order?code=${param.orderCode}" class="btn-primary" style="text-decoration:none; display:inline-flex; align-items:center; gap:8px; padding:12px 24px; font-size:15px;">
          <i class="fa-solid fa-truck-fast"></i> Theo dõi tiến trình đơn hàng
        </a>
        <a href="chat?withAdmin=1&orderCode=${param.orderCode}" class="btn-chat-outline" style="background:#f0fdf4; border-color:#86efac; color:#15803d; text-decoration:none; display:inline-flex; align-items:center; gap:8px; padding:12px 20px; font-size:15px; font-weight:600;">
          <i class="fa-solid fa-comments"></i> Chat với shop về đơn này
        </a>
        <a href="home" style="display:inline-flex; align-items:center; gap:6px; padding:12px 20px; border:1px solid #cbd5e1; border-radius:6px; color:#475569; text-decoration:none;">
          <i class="fa fa-arrow-left"></i> Mua thêm món khác
        </a>
      </div>
    </div>
  </c:if>

  <!-- NỘI DUNG GIỎ HÀNG -->
  <c:if test="${param.orderSuccess != '1'}">
    <div class="cart-layout">

      <!-- CỘT TRÁI: DANH SÁCH MÓN HÀNG -->
      <div>

        <!-- Thanh tính điều kiện Freeship (Ngưỡng 200k) -->
        <c:if test="${not empty sessionScope.cart && !sessionScope.cart.isEmpty()}">
          <c:set var="subtotal" value="${sessionScope.cart.subtotal}"/>
          <c:set var="freeThreshold" value="200000"/>
          <c:set var="percent" value="${(subtotal / freeThreshold) * 100}"/>
          <c:if test="${percent > 100}"><c:set var="percent" value="100"/></c:if>

          <div class="freeship-meter-card">
            <div class="freeship-text">
              <c:choose>
                <c:when test="${subtotal >= freeThreshold}">
                  <i class="fa-solid fa-circle-check" style="color: #10b981; font-size: 16px;"></i>
                  <span>Bạn đã được <strong>MIỄN PHÍ VẬN CHUYỂN</strong> toàn quốc cho đơn hàng này!</span>
                </c:when>
                <c:otherwise>
                  <i class="fa-solid fa-truck-fast" style="color: var(--primary-color);"></i>
                  <span>Mua thêm <strong><fmt:formatNumber value="${freeThreshold - subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></strong> để được <strong>FREESHIP</strong> toàn quốc!</span>
                </c:otherwise>
              </c:choose>
            </div>
            <div class="freeship-bar-bg">
              <div class="freeship-bar-fill" style="width: ${percent}%;"></div>
            </div>
          </div>
        </c:if>

        <div class="cart-main-card">
          <div class="cart-main-header">
            <h2>
              <i class="fa-solid fa-basket-shopping" style="color: var(--primary-color);"></i>
              Sản phẩm trong giỏ (${not empty sessionScope.cart ? sessionScope.cart.totalQuantity : 0} món)
            </h2>
            <c:if test="${not empty sessionScope.cart && !sessionScope.cart.isEmpty()}">
              <form action="cart" method="POST" onsubmit="return confirm('Bạn có chắc muốn xóa tất cả sản phẩm khỏi giỏ hàng?');">
                <input type="hidden" name="action" value="clear">
                <button type="submit" class="btn-clear-cart">
                  <i class="fa-regular fa-trash-can"></i> Xóa tất cả
                </button>
              </form>
            </c:if>
          </div>

          <!-- Danh sách mặt hàng -->
          <c:choose>
            <c:when test="${empty sessionScope.cart || sessionScope.cart.isEmpty()}">
              <div style="text-align: center; padding: 60px 20px;">
                <div style="width: 80px; height: 80px; border-radius: 50%; background: #f0fdf4; color: var(--primary-color); display: flex; align-items: center; justify-content: center; font-size: 36px; margin: 0 auto 16px;">
                  <i class="fa-solid fa-cart-shopping"></i>
                </div>
                <h3 style="color: var(--text-heading); margin-bottom: 8px;">Giỏ hàng của bạn đang trống</h3>
                <p style="color: #64748b; font-size: 14px; max-width: 380px; margin: 0 auto 20px;">
                  Hãy khám phá hàng trăm thực phẩm hữu cơ, rau củ quả tươi sạch và đặt hàng ngay!
                </p>
                <a href="home#products" class="btn-primary" style="text-decoration: none; display: inline-flex; align-items: center; gap: 8px; padding: 12px 24px;">
                  <i class="fa fa-arrow-left"></i> Khám phá mua sắm ngay
                </a>
              </div>
            </c:when>

            <c:otherwise>
              <div class="cart-items-list">
                <c:forEach var="item" items="${sessionScope.cart.items}">
                  <div class="cart-item-row" id="cart-row-${item.productId}">
                    <!-- Ảnh -->
                    <img src="${item.productImage}" class="cart-item-img" alt="${item.productName}">

                    <!-- Tên & Giá lẻ -->
                    <div class="cart-item-info">
                      <h4>${item.productName}</h4>
                      <div class="cart-item-unit-price">
                        Đơn giá: <fmt:formatNumber value="${item.productPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                      </div>
                    </div>

                    <!-- Bộ nút chỉnh số lượng (Stepper) -->
                    <div>
                      <div class="qty-stepper">
                        <!-- Giảm 1 -->
                        <form action="cart" method="POST" style="margin:0; display:inline;">
                          <input type="hidden" name="action" value="update">
                          <input type="hidden" name="productId" value="${item.productId}">
                          <input type="hidden" name="delta" value="-1">
                          <button type="submit" class="qty-step-btn" title="Giảm 1">-</button>
                        </form>

                        <!-- Ô nhập số lượng -->
                        <form action="cart" method="POST" style="margin:0; display:inline;">
                          <input type="hidden" name="action" value="setQuantity">
                          <input type="hidden" name="productId" value="${item.productId}">
                          <input type="number" name="quantity" value="${item.quantity}" min="1" max="999" class="qty-input"
                                 onchange="this.form.submit();" title="Nhập số lượng rồi nhấn Enter">
                        </form>

                        <!-- Tăng 1 -->
                        <form action="cart" method="POST" style="margin:0; display:inline;">
                          <input type="hidden" name="action" value="update">
                          <input type="hidden" name="productId" value="${item.productId}">
                          <input type="hidden" name="delta" value="1">
                          <button type="submit" class="qty-step-btn" title="Tăng 1">+</button>
                        </form>
                      </div>
                    </div>

                    <!-- Thành tiền -->
                    <div class="cart-item-subtotal">
                      <fmt:formatNumber value="${item.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                    </div>

                    <!-- Xóa -->
                    <div>
                      <form action="cart" method="POST" style="margin:0;">
                        <input type="hidden" name="action" value="remove">
                        <input type="hidden" name="productId" value="${item.productId}">
                        <button type="submit" class="btn-item-delete" title="Xóa món này khỏi giỏ">
                          <i class="fa-solid fa-trash-can"></i>
                        </button>
                      </form>
                    </div>
                  </div>
                </c:forEach>
              </div>

              <!-- Footer của cột sản phẩm -->
              <div style="padding: 16px 22px; background: #fafafa; border-top: 1px solid #f1f5f9; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px;">
                <a href="home#products" style="color: var(--primary-color); font-weight: 600; text-decoration: none; font-size: 14px; display: inline-flex; align-items: center; gap: 6px;">
                  <i class="fa fa-arrow-left"></i> Tiếp tục chọn thêm sản phẩm khác
                </a>
                <span style="font-size: 13px; color: #64748b;">
                  <i class="fa-solid fa-truck-fast"></i> Giao hàng tận nơi siêu tốc trong 2 giờ
                </span>
              </div>
            </c:otherwise>
          </c:choose>
        </div>

      </div>

      <!-- CỘT PHẢI: MÃ GIẢM GIÁ & THANH TOÁN -->
      <c:if test="${not empty sessionScope.cart && !sessionScope.cart.isEmpty()}">
        <div class="checkout-sidebar">

          <!-- Card 1: Khuyến Mãi / Voucher -->
          <div class="checkout-card">
            <h3 class="card-heading">
              <i class="fa-solid fa-ticket" style="color: var(--primary-color);"></i>
              Mã Ưu Đãi / Voucher
            </h3>

            <!-- Form áp dụng mã -->
            <form action="cart" method="POST" id="couponForm" style="display:flex; gap:8px;">
              <input type="hidden" name="action" value="applyCoupon">
              <input type="text" id="couponInput" name="couponCode" placeholder="Nhập mã (VD: GREENMART10)"
                     value="${sessionScope.cart.appliedCoupon != null ? sessionScope.cart.appliedCoupon.code : ''}"
                     style="flex:1; text-transform:uppercase; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-weight:700; font-size:13px; outline:none;" required>
              <button type="submit" class="btn-primary" style="padding:9px 16px; font-size:13px; white-space:nowrap;">
                Áp dụng
              </button>
            </form>

            <!-- Bấm nhanh các voucher có sẵn -->
            <div class="coupon-chips-list">
              <span class="coupon-chip" onclick="applyQuickCoupon('GREENMART10')"><i class="fa-solid fa-tag"></i> GREENMART10 (-10%)</span>
              <span class="coupon-chip" onclick="applyQuickCoupon('SALE20')"><i class="fa-solid fa-tag"></i> SALE20 (-20%)</span>
              <span class="coupon-chip" onclick="applyQuickCoupon('CHAO50K')"><i class="fa-solid fa-tag"></i> CHAO50K (-50k)</span>
              <span class="coupon-chip" onclick="applyQuickCoupon('FREESHIP')"><i class="fa-solid fa-tag"></i> FREESHIP</span>
            </div>

            <!-- Thông báo thành công / lỗi coupon -->
            <c:if test="${not empty sessionScope.couponSuccess}">
              <div style="margin-top:12px; padding:8px 12px; background:#ecfdf5; border-radius:6px; color:#065f46; font-size:13px; display:flex; align-items:center; gap:6px;">
                <i class="fa-solid fa-circle-check"></i> ${sessionScope.couponSuccess}
              </div>
            </c:if>
            <c:if test="${not empty sessionScope.couponError}">
              <div style="margin-top:12px; padding:8px 12px; background:#fef2f2; border-radius:6px; color:#991b1b; font-size:13px; display:flex; align-items:center; gap:6px;">
                <i class="fa-solid fa-circle-exclamation"></i> ${sessionScope.couponError}
              </div>
            </c:if>

            <!-- Tag mã đang áp dụng -->
            <c:if test="${sessionScope.cart.appliedCoupon != null}">
              <div style="margin-top:12px; padding:8px 12px; background:#f0fdf4; border:1px dashed #22c55e; border-radius:6px; display:flex; justify-content:space-between; align-items:center;">
                <span style="font-size:13px; color:#15803d; font-weight:600;">
                  <i class="fa-solid fa-check"></i> Đang dùng: ${sessionScope.cart.appliedCoupon.label}
                </span>
                <form action="cart" method="POST" style="margin:0;">
                  <input type="hidden" name="action" value="removeCoupon">
                  <button type="submit" title="Hủy mã" style="background:none; border:none; color:#ef4444; font-size:13px; cursor:pointer; font-weight:700;">
                    ✕ Bỏ mã
                  </button>
                </form>
              </div>
            </c:if>
          </div>

          <!-- Card 2: Tóm Tắt Chi Phí & Thông Tin Đặt Hàng -->
          <div class="checkout-card">
            <h3 class="card-heading">
              <i class="fa-solid fa-receipt" style="color: var(--primary-color);"></i>
              Tóm Tắt Đơn Hàng
            </h3>

            <div class="summary-row">
              <span>Tạm tính (${sessionScope.cart.totalQuantity} món):</span>
              <span><fmt:formatNumber value="${sessionScope.cart.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
            </div>

            <c:if test="${sessionScope.cart.appliedCoupon != null}">
              <div class="summary-row" style="color:#16a34a; font-weight:600;">
                <span>Giảm giá voucher:</span>
                <span>- <fmt:formatNumber value="${sessionScope.cart.discount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
              </div>
            </c:if>

            <div class="summary-row">
              <span>Phí giao hàng:</span>
              <span style="color:#16a34a; font-weight:600;">Miễn phí</span>
            </div>

            <div class="summary-row total">
              <span>Tổng thanh toán:</span>
              <span><fmt:formatNumber value="${sessionScope.cart.grandTotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
            </div>

            <hr style="margin: 20px 0; border: none; border-top: 1px solid #f1f5f9;">

            <!-- FORM GIAO HÀNG & THANH TOÁN -->
            <h3 class="card-heading" style="margin-bottom: 12px;">
              <i class="fa-solid fa-truck" style="color: var(--primary-color);"></i>
              Thông Tin Giao Hàng
            </h3>

            <form action="cart" method="POST">
              <input type="hidden" name="action" value="checkout">

              <div class="form-group" style="margin-bottom: 12px;">
                <label style="font-size:13px; font-weight:600; color:#334155; margin-bottom:4px; display:block;">
                  Họ tên người nhận <span style="color:red;">*</span>
                </label>
                <input type="text" name="custName" value="${sessionScope.user != null ? sessionScope.user.username : ''}"
                       required placeholder="Ví dụ: Nguyễn Văn An"
                       style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:14px; outline:none; box-sizing:border-box;">
              </div>

              <div class="form-group" style="margin-bottom: 12px;">
                <label style="font-size:13px; font-weight:600; color:#334155; margin-bottom:4px; display:block;">
                  Số điện thoại <span style="color:red;">*</span>
                </label>
                <input type="tel" name="custPhone" value="${sessionScope.user != null ? sessionScope.user.phone : ''}"
                       required placeholder="Ví dụ: 0987654321" pattern="[0-9]{10,11}" title="Gồm 10 hoặc 11 chữ số"
                       style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:14px; outline:none; box-sizing:border-box;">
              </div>

              <div class="form-group" style="margin-bottom: 15px;">
                <label style="font-size:13px; font-weight:600; color:#334155; margin-bottom:4px; display:block;">
                  Địa chỉ nhận hàng <span style="color:red;">*</span>
                </label>
                <textarea name="custAddress" required rows="2" placeholder="Số nhà, tên đường, Phường/Xã, Quận/Huyện..."
                          style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:14px; outline:none; box-sizing:border-box; resize:vertical;">${sessionScope.user != null ? sessionScope.user.address : ''}</textarea>
              </div>

              <!-- Thẻ chọn phương thức thanh toán -->
              <label style="font-size:13px; font-weight:600; color:#334155; margin-bottom:8px; display:block;">
                Phương thức thanh toán
              </label>
              <div class="payment-options-grid">
                <!-- COD -->
                <label class="payment-option-card selected" id="card-cod" onclick="selectPayment('COD')">
                  <input type="radio" name="custPayment" value="COD" checked>
                  <div class="payment-option-info">
                    <h5><i class="fa-solid fa-money-bill-wave" style="color:#16a34a;"></i> Tiền mặt khi nhận hàng (COD)</h5>
                    <p>Nhận hàng kiểm tra độ tươi ngon rồi mới thanh toán</p>
                  </div>
                </label>

                <!-- BANK QR -->
                <label class="payment-option-card" id="card-bank" onclick="selectPayment('BANK')">
                  <input type="radio" name="custPayment" value="BANK">
                  <div class="payment-option-info">
                    <h5><i class="fa-solid fa-qrcode" style="color:#2563eb;"></i> Chuyển khoản ngân hàng (VietQR)</h5>
                    <p>Quét mã QR tiện lợi, xác nhận đơn hàng tự động</p>
                  </div>
                </label>
              </div>

              <!-- Box chi tiết ngân hàng xuất hiện khi chọn BANK -->
              <div id="bankDetailsBox" class="bank-qr-preview-box" style="display: none;">
                <div style="font-weight: 700; color: #1e40af; margin-bottom: 6px; display:flex; align-items:center; gap:6px;">
                  <i class="fa-solid fa-building-columns"></i> Ngân hàng MB Bank (Quân Đội)
                </div>
                <div>Số tài khoản: <strong style="font-size:14px; color:#0f172a;">090123456789</strong></div>
                <div>Chủ tài khoản: <strong>GREENMART ORGANIC STORE</strong></div>
                <div style="margin-top: 4px; color:#64748b; font-size:11px;">
                  * Mã QR và nội dung chuyển khoản tự động sẽ hiển thị ngay sau khi bạn bấm đặt hàng.
                </div>
              </div>

              <button type="submit" class="btn-primary" style="width:100%; padding:14px; font-size:16px; font-weight:700; display:flex; align-items:center; justify-content:center; gap:8px; box-shadow:0 4px 15px rgba(59, 183, 126, 0.35);">
                <i class="fa-solid fa-lock"></i> Đặt hàng ngay &bull; <fmt:formatNumber value="${sessionScope.cart.grandTotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
              </button>
            </form>

            <!-- Cam kết chất lượng -->
            <div class="trust-badges-grid">
              <div class="trust-badge-item">
                <i class="fa-solid fa-shield-halved" style="color:var(--primary-color);"></i>
                <span>100% Chuẩn VietGAP</span>
              </div>
              <div class="trust-badge-item">
                <i class="fa-solid fa-rotate-left" style="color:var(--primary-color);"></i>
                <span>Đổi trả trong 24h</span>
              </div>
              <div class="trust-badge-item">
                <i class="fa-solid fa-truck-fast" style="color:var(--primary-color);"></i>
                <span>Giao hỏa tốc 2 giờ</span>
              </div>
              <div class="trust-badge-item">
                <i class="fa-solid fa-headset" style="color:var(--primary-color);"></i>
                <span>Tư vấn hỗ trợ 24/7</span>
              </div>
            </div>

          </div>

        </div>
      </c:if>

    </div>
  </c:if>

  <!-- THANH TIỆN ÍCH NỔI CỐ ĐỊNH DÍNH ĐÁY MÀN HÌNH (Fixed Bottom Sticky Dock) -->
  <div class="gm-floating-dock" id="gmFloatingDock">
    <!-- Nút 1: Theo dõi tiến trình đơn hàng -->
    <a href="track-order" class="dock-btn dock-btn-track" title="Theo dõi tiến trình đơn hàng (Tra cứu mã vận đơn)">
      <i class="fa-solid fa-truck-fast"></i>
      <span>Theo dõi đơn</span>
    </a>

    <!-- Nút 2: Chat Shopee-style dính đáy màn hình (Chuẩn theo pasted-image-1.png) -->
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
        <a href="chat" title="Mở trang đầy đủ" target="_blank" class="live-chat-ctrl-btn">
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
            Vui lòng <a href="auth?mode=login&redirect=cart" style="color:var(--primary-color); font-weight:700;">Đăng nhập</a> để trò chuyện trực tiếp với CSKH.
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <script src="js/cart.js"></script>

</body>
</html>
