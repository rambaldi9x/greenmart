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
  <style>
    .cart-container {
      display: grid;
      grid-template-columns: 2fr 1fr;
      gap: 30px;
      padding: 30px 40px;
      min-height: 500px;
    }
    .cart-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
    }
    .cart-table th, .cart-table td {
      padding: 14px;
      text-align: left;
      border-bottom: 1px solid var(--border-color);
    }
    .cart-table th {
      background: var(--bg-light);
      color: var(--text-heading);
    }
    .qty-btn {
      padding: 4px 10px;
      border: 1px solid #ccc;
      background: white;
      cursor: pointer;
      border-radius: 4px;
    }
    .checkout-box {
      border: 1px solid var(--border-color);
      border-radius: 8px;
      padding: 25px;
      background: #fafafa;
      height: fit-content;
    }
    .checkout-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 15px;
      font-size: 15px;
    }
    .total-price {
      font-size: 20px;
      font-weight: bold;
      color: var(--primary-color);
    }
    .alert-success {
      background: #ecfdf5;
      border: 1px solid #10b981;
      color: #065f46;
      padding: 16px 20px;
      border-radius: 8px;
      margin: 20px 40px 0 40px;
      font-size: 15px;
    }
    @media (max-width: 900px) {
      .cart-container {
        grid-template-columns: 1fr;
        padding: 20px;
      }
    }
  </style>
</head>
<body>

  <!-- Header -->
  <header class="header">
    <a href="home" class="logo">
      <i class="fa-solid fa-leaf"></i> GREENMART
    </a>
    <div class="header-actions">
      <a href="home" class="action-item"><i class="fa fa-arrow-left"></i> Tiếp tục mua sắm</a>
      <div class="action-item" style="position:relative;">
        <i class="fa-solid fa-cart-shopping"></i>
        <span>Giỏ hàng</span>
        <span class="badge">
          ${not empty sessionScope.cart ? sessionScope.cart.totalQuantity : 0}
        </span>
      </div>
    </div>
  </header>

  <nav class="navbar">
    <ul class="nav-links">
      <li><a href="home"><i class="fa fa-home"></i> Trang chủ</a></li>
      <li><a href="cart" style="text-decoration: underline;"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng</a></li>
      <c:if test="${sessionScope.user.role == 'admin'}">
        <li><a href="admin"><i class="fa-solid fa-gauge"></i> Quản trị (Admin)</a></li>
      </c:if>
    </ul>
  </nav>

  <!-- Thông báo đặt hàng thành công -->
  <c:if test="${param.orderSuccess == '1'}">
    <div class="alert-success">
      <h3 style="margin-bottom: 6px;"><i class="fa-solid fa-circle-check"></i> Đặt hàng thành công!</h3>
      <p>Cảm ơn <strong>${param.name}</strong>, đơn hàng <strong>${param.orderCode}</strong> trị giá
        <strong><fmt:formatNumber value="${param.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></strong>
        đã được hệ thống ghi nhận. Chúng tôi sẽ sớm liên hệ với bạn để xác nhận đơn hàng.</p>
    </div>
  </c:if>

  <div class="cart-container">
    <div>
      <h2 style="color: var(--text-heading); margin-bottom: 20px;">Giỏ hàng của bạn</h2>
      
      <c:choose>
        <c:when test="${empty sessionScope.cart }">
          <div style="text-align: center; padding: 60px 20px; background: white; border-radius: 8px; border: 1px solid var(--border-color);">
            <i class="fa-solid fa-cart-arrow-down" style="font-size: 48px; color: #cbd5e1; margin-bottom: 15px;"></i>
            <h3 style="color: var(--text-heading); margin-bottom: 10px;">Giỏ hàng trống</h3>
            <p style="color: var(--text-body); margin-bottom: 20px;">Bạn chưa chọn sản phẩm nào vào giỏ hàng.</p>
            <a href="home" class="btn-primary" style="text-decoration: none; display: inline-block;">
              <i class="fa fa-arrow-left"></i> Mua sắm ngay
            </a>
          </div>
        </c:when>
        <c:otherwise>
          <table class="cart-table">
            <thead>
              <tr>
                <th>Sản phẩm</th>
                <th>Đơn giá</th>
                <th>Số lượng</th>
                <th>Thành tiền</th>
                <th>Xóa</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="item" items="${sessionScope.cart.items}">
                <tr>
                  <td style="display:flex;align-items:center;gap:12px;">
                    <img src="${item.productImage}" style="width:50px;height:50px;object-fit:cover;border-radius:4px;" alt="${item.productName}">
                    <strong>${item.productName}</strong>
                  </td>
                  <td>
                    <fmt:formatNumber value="${item.productPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                  </td>
                  <td>
                    <div style="display: flex; align-items: center;">
                      <form action="cart" method="POST" style="display:inline;">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="productId" value="${item.productId}">
                        <input type="hidden" name="delta" value="-1">
                        <button type="submit" class="qty-btn">-</button>
                      </form>
                      <span style="margin: 0 10px; font-weight: bold;">${item.quantity}</span>
                      <form action="cart" method="POST" style="display:inline;">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="productId" value="${item.productId}">
                        <input type="hidden" name="delta" value="1">
                        <button type="submit" class="qty-btn">+</button>
                      </form>
                    </div>
                  </td>
                  <td style="color:var(--primary-color);font-weight:bold;">
                    <fmt:formatNumber value="${item.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                  </td>
                  <td>
                    <form action="cart" method="POST" style="display:inline;">
                      <input type="hidden" name="action" value="remove">
                      <input type="hidden" name="productId" value="${item.productId}">
                      <button type="submit" title="Xóa khỏi giỏ" style="color:red;border:none;background:none;cursor:pointer;font-size:16px;">
                        <i class="fa fa-trash"></i>
                      </button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- Thông tin đặt hàng -->
    <c:if test="${not empty sessionScope.cart}">
      <div class="checkout-box">
        <h3 style="color: var(--text-heading); margin-bottom: 15px;">Mã Giảm Giá</h3>
        
        <!-- Form mã giảm giá -->
        <form action="cart" method="POST" style="margin-bottom: 20px;">
          <input type="hidden" name="action" value="applyCoupon">
          <div style="display:flex;gap:8px;">
            <input type="text" name="couponCode" placeholder="VD: GREENMART10, CHAO50K"
              value="${sessionScope.cart.appliedCoupon != null ? sessionScope.cart.appliedCoupon.code : ''}"
              style="flex:1;text-transform:uppercase;padding:8px 12px;border:1px solid var(--border-color);border-radius:5px;" maxlength="20" required>
            <button type="submit"
              style="padding:8px 14px;background:var(--primary-color);color:white;border:none;border-radius:5px;cursor:pointer;white-space:nowrap;font-size:13px;">
              Áp dụng
            </button>
          </div>
        </form>

        <c:if test="${not empty sessionScope.couponSuccess}">
          <div style="color: #16a34a; font-size: 13px; margin-bottom: 10px;">
            <i class="fa fa-check"></i> ${sessionScope.couponSuccess}
          </div>
        </c:if>
        <c:if test="${not empty sessionScope.couponError}">
          <div style="color: #dc2626; font-size: 13px; margin-bottom: 10px;">
            <i class="fa fa-circle-exclamation"></i> ${sessionScope.couponError}
          </div>
        </c:if>

        <hr style="margin: 20px 0; border: none; border-top: 1px solid var(--border-color);">

        <div class="checkout-row">
          <span>Tạm tính:</span>
          <span><fmt:formatNumber value="${sessionScope.cart.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
        </div>

        <c:if test="${sessionScope.cart.appliedCoupon != null}">
          <div class="checkout-row" style="color:#16a34a;">
            <span>Giảm giá (${sessionScope.cart.appliedCoupon.label}):
              <form action="cart" method="POST" style="display:inline; margin-left: 6px;">
                <input type="hidden" name="action" value="removeCoupon">
                <button type="submit" title="Xóa mã" style="border:none;background:none;color:#dc2626;cursor:pointer;font-size:12px;">✕</button>
              </form>
            </span>
            <span style="font-weight:bold;">
              - <fmt:formatNumber value="${sessionScope.cart.discount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
            </span>
          </div>
        </c:if>

        <div class="checkout-row">
          <span>Phí vận chuyển:</span>
          <span>Miễn phí</span>
        </div>
        <div class="checkout-row total-price">
          <span>Tổng thanh toán:</span>
          <span><fmt:formatNumber value="${sessionScope.cart.grandTotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
        </div>

        <hr style="margin: 20px 0; border: none; border-top: 1px solid var(--border-color);">

        <h3 style="color: var(--text-heading); margin-bottom: 15px;">Thông tin giao hàng</h3>
        <form action="cart" method="POST">
          <input type="hidden" name="action" value="checkout">
          <div class="form-group">
            <label>Họ và tên người nhận <span style="color:red;">*</span></label>
            <input type="text" name="custName" value="${sessionScope.user != null ? sessionScope.user.username : ''}" required placeholder="Nguyễn Văn A">
          </div>
          <div class="form-group">
            <label>Số điện thoại <span style="color:red;">*</span></label>
            <input type="tel" name="custPhone" required placeholder="0987654321" pattern="[0-9]{10,11}" title="Số điện thoại phải có 10 hoặc 11 chữ số">
          </div>
          <div class="form-group">
            <label>Địa chỉ nhận hàng <span style="color:red;">*</span></label>
            <textarea name="custAddress" required rows="2" placeholder="Số nhà, Phường/Xã, Quận/Huyện, Tỉnh/TP"></textarea>
          </div>
          <div class="form-group">
            <label>Phương thức thanh toán</label>
            <select name="custPayment">
              <option value="COD">Thanh toán khi nhận hàng (COD)</option>
              <option value="BANK">Chuyển khoản ngân hàng (QR Code)</option>
            </select>
          </div>

          <button type="submit" class="btn-primary" style="width: 100%; margin-top: 15px; padding: 12px; font-size: 15px;">
            <i class="fa fa-credit-card"></i> Hoàn tất đặt hàng
          </button>
        </form>
      </div>
    </c:if>
  </div>

</body>
</html>
