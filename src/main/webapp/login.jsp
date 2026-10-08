<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đăng nhập & Đăng ký - GreenMart</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .auth-page {
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      background: #f4f6f8;
    }
    .auth-container {
      max-width: 440px;
      width: 92%;
      margin: 50px auto;
      background: white;
      padding: 35px 30px;
      border-radius: 12px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    }
    .auth-tabs {
      display: flex;
      border-bottom: 2px solid #edf2f7;
      margin-bottom: 25px;
    }
    .auth-tab {
      flex: 1;
      text-align: center;
      padding: 12px;
      font-weight: 600;
      color: var(--text-body);
      text-decoration: none;
      border-bottom: 2px solid transparent;
      margin-bottom: -2px;
      transition: all 0.2s;
    }
    .auth-tab.active {
      color: var(--primary-color);
      border-color: var(--primary-color);
    }
    .alert-error {
      background: #fef2f2;
      border-left: 4px solid #ef4444;
      color: #b91c1c;
      padding: 12px 14px;
      border-radius: 4px;
      margin-bottom: 20px;
      font-size: 14px;
    }
  </style>
</head>
<body class="auth-page">

  <!-- Header -->
  <header class="header">
    <a href="home" class="logo">
      <i class="fa-solid fa-leaf"></i> GREENMART
    </a>
    <div class="header-actions">
      <a href="home" class="action-item"><i class="fa fa-arrow-left"></i> Quay lại mua sắm</a>
    </div>
  </header>

  <div class="auth-container">
    <div style="text-align: center; margin-bottom: 20px;">
      <h2 style="color: var(--text-heading); font-size: 24px;">Tài Khoản GreenMart</h2>
      <p style="color: var(--text-body); font-size: 13px; margin-top: 4px;">Thực phẩm tươi sạch chuẩn VietGAP</p>
    </div>

    <div class="auth-tabs">
      <a href="auth?mode=login" class="auth-tab ${mode != 'register' ? 'active' : ''}">Đăng nhập</a>
      <a href="auth?mode=register" class="auth-tab ${mode == 'register' ? 'active' : ''}">Đăng ký</a>
    </div>

    <c:if test="${not empty error}">
      <div class="alert-error">
        <i class="fa-solid fa-circle-exclamation"></i> ${error}
      </div>
    </c:if>
    <c:if test="${param.error == 'unauthorized'}">
      <div class="alert-error">
        <i class="fa-solid fa-triangle-exclamation"></i> <strong>Yêu cầu quyền Quản trị:</strong> Vui lòng đăng nhập bằng tài khoản Admin để truy cập Bảng điều khiển quản trị!
      </div>
    </c:if>

    <c:choose>
      <c:when test="${mode == 'register'}">
        <!-- Register Form -->
        <form action="auth" method="POST">
          <input type="hidden" name="action" value="register">
          <div class="form-group">
            <label>Họ và tên <span style="color:red;">*</span></label>
            <input type="text" name="username" value="${username}" required placeholder="Nguyễn Văn An">
          </div>
          <div class="form-group">
            <label>Email <span style="color:red;">*</span></label>
            <input type="email" name="email" value="${email}" required placeholder="user@gmail.com">
          </div>
          <div class="form-group">
            <label>Mật khẩu <span style="color:red;">*</span></label>
            <input type="password" name="password" required placeholder="Ít nhất 6 ký tự">
          </div>
          <div class="form-group">
            <label>Xác nhận mật khẩu <span style="color:red;">*</span></label>
            <input type="password" name="confirmPassword" required placeholder="Nhập lại mật khẩu">
          </div>
          <button type="submit" class="btn-primary" style="width: 100%; margin-top: 10px; padding: 12px;">
            <i class="fa-solid fa-user-plus"></i> Đăng ký tài khoản
          </button>
        </form>
      </c:when>
      <c:otherwise>
        <!-- Login Form -->
        <form action="auth" method="POST">
          <input type="hidden" name="action" value="login">
          <c:if test="${not empty param.redirect}">
            <input type="hidden" name="redirect" value="${param.redirect}">
          </c:if>
          <div class="form-group">
            <label>Email đăng nhập <span style="color:red;">*</span></label>
            <input type="email" name="email" value="${email}" required placeholder="admin@greenmart.vn hoặc email của bạn">
          </div>
          <div class="form-group">
            <label>Mật khẩu <span style="color:red;">*</span></label>
            <input type="password" name="password" required placeholder="Nhập mật khẩu">
          </div>
          <button type="submit" class="btn-primary" style="width: 100%; margin-top: 10px; padding: 12px;">
            <i class="fa-solid fa-right-to-bracket"></i> Đăng nhập
          </button>
          <div style="background: #f8fafc; border: 1px dashed #cbd5e1; border-radius: 6px; padding: 10px; margin-top: 20px; font-size: 12px; color: #64748b; text-align: center;">
            <strong>Tài khoản Demo Admin:</strong><br>
            Email: <code>admin@greenmart.vn</code> | Mật khẩu: <code>123456</code>
          </div>
        </form>
      </c:otherwise>
    </c:choose>
  </div>

</body>
</html>
