<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:if test="${empty sessionScope.user}">
  <c:redirect url="/auth?mode=login&redirect=chat"/>
</c:if>
<c:if test="${contacts == null}">
  <c:redirect url="/chat"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tin Nhắn & Hỗ Trợ Khách Hàng - GreenMart</title>
  <link rel="stylesheet" href="css/style.css?v=20261008_chat_v3">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    :root {
      --gm-primary: #3bb77e;
      --gm-primary-dark: #29a56c;
      --gm-primary-light: #ecfdf5;
      --gm-dark: #253d4e;
      --gm-heading: #0f172a;
      --gm-text: #334155;
      --gm-muted: #64748b;
      --gm-border: #e2e8f0;
      --gm-bg: #f1f5f9;
    }

    * { box-sizing: border-box; }
    body {
      margin: 0;
      padding: 0;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      background: #f0f2f5;
      color: var(--gm-text);
    }

    /* Top bar */
    .top-bar {
      background: #253d4e;
      color: #cbd5e1;
      padding: 8px 28px;
      font-size: 12.5px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    /* Header */
    .header {
      background: #ffffff;
      padding: 14px 28px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 1px 4px rgba(0,0,0,0.06);
    }
    .header .logo {
      font-size: 22px;
      font-weight: 800;
      color: #3bb77e;
      text-decoration: none;
      display: flex;
      align-items: center;
      gap: 8px;
      letter-spacing: -0.5px;
    }
    .header-actions {
      display: flex;
      align-items: center;
      gap: 16px;
    }
    .action-item {
      color: #334155;
      text-decoration: none;
      font-size: 13.5px;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 7px;
      position: relative;
      transition: color 0.2s;
    }
    .action-item:hover { color: #3bb77e; }
    .action-item .badge {
      background: #ef4444;
      color: white;
      border-radius: 12px;
      padding: 1px 6px;
      font-size: 11px;
      font-weight: 700;
      margin-left: -2px;
    }

    /* Navbar */
    .navbar {
      background: #3bb77e;
      padding: 0 28px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .nav-links {
      list-style: none;
      margin: 0;
      padding: 0;
      display: flex;
      gap: 4px;
    }
    .nav-links li a {
      color: #ffffff;
      text-decoration: none;
      font-size: 13.5px;
      font-weight: 600;
      padding: 12px 16px;
      display: flex;
      align-items: center;
      gap: 7px;
      transition: background 0.2s;
    }
    .nav-links li a:hover {
      background: rgba(0,0,0,0.1);
    }

    /* Chat Page Wrapper */
    .chat-page-wrapper {
      max-width: 1360px;
      margin: 16px auto 24px;
      padding: 0 20px;
      height: calc(100vh - 165px);
      min-height: 640px;
    }

    /* Chat Outer Card */
    .chat-container-card {
      display: flex;
      background: #ffffff;
      border-radius: 20px;
      box-shadow: 0 16px 45px rgba(0, 0, 0, 0.08), 0 2px 8px rgba(0, 0, 0, 0.04);
      height: 100%;
      overflow: hidden;
      border: 1px solid #e2e8f0;
    }

    /* Left Sidebar */
    .chat-sidebar {
      width: 360px;
      min-width: 320px;
      border-right: 1px solid #edf2f7;
      display: flex;
      flex-direction: column;
      background: #ffffff;
    }

    .chat-sidebar-header {
      padding: 16px 20px;
      border-bottom: 1px solid #f1f5f9;
      background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
    }

    .current-user-info {
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .current-avatar {
      background: linear-gradient(135deg, #3bb77e 0%, #29a56c 100%);
      color: white;
      box-shadow: 0 4px 12px rgba(59, 183, 126, 0.35);
    }

    .avatar-circle {
      width: 44px;
      height: 44px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 700;
      font-size: 16px;
      flex-shrink: 0;
    }

    .user-details h4 {
      font-size: 15px;
      font-weight: 700;
      color: #0f172a;
      margin: 0 0 3px 0;
    }

    .online-indicator {
      font-size: 12px;
      color: #10b981;
      display: flex;
      align-items: center;
      gap: 6px;
      font-weight: 600;
    }

    .dot-online {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: #10b981;
      display: inline-block;
      box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.25);
      animation: pulseDot 2s infinite;
    }
    @keyframes pulseDot {
      0%, 100% { transform: scale(1); opacity: 1; }
      50% { transform: scale(1.2); opacity: 0.8; }
    }

    .chat-search-wrap {
      padding: 12px 18px;
      border-bottom: 1px solid #f1f5f9;
      position: relative;
    }

    .search-icon {
      position: absolute;
      left: 32px;
      top: 50%;
      transform: translateY(-50%);
      color: #94a3b8;
      font-size: 13px;
    }

    #contactSearchInput {
      width: 100%;
      padding: 10px 14px 10px 38px;
      border-radius: 24px;
      border: 1.5px solid #e2e8f0;
      background: #f8fafc;
      font-size: 13px;
      outline: none;
      box-sizing: border-box;
      transition: all 0.2s;
    }

    #contactSearchInput:focus {
      border-color: #3bb77e;
      background: #ffffff;
      box-shadow: 0 0 0 3px rgba(59, 183, 126, 0.15);
    }

    .contacts-scroll-area {
      flex: 1;
      overflow-y: auto;
      padding: 6px 0;
    }

    .contact-item {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 12px 16px;
      margin: 3px 8px;
      border-radius: 12px;
      text-decoration: none !important;
      color: inherit !important;
      transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
      cursor: pointer;
      border: 1.5px solid transparent;
    }

    .contact-item:hover {
      background: #f8fafc;
      transform: translateX(2px);
    }

    .contact-item.active {
      background: linear-gradient(135deg, #ecfdf5 0%, #f0fdf4 100%) !important;
      border-color: #a7f3d0 !important;
      box-shadow: 0 4px 14px rgba(59, 183, 126, 0.12);
    }

    .contact-avatar {
      position: relative;
      width: 44px;
      height: 44px;
      min-width: 44px;
      border-radius: 50%;
      background: #64748b;
      color: white;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 700;
      font-size: 16px;
      flex-shrink: 0;
    }

    .contact-avatar.admin-avatar {
      background: linear-gradient(135deg, #10b981 0%, #059669 100%);
      box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
    }

    .avatar-status-dot {
      position: absolute;
      bottom: 0px;
      right: 0px;
      width: 11px;
      height: 11px;
      border-radius: 50%;
      background: #10b981;
      border: 2px solid white;
    }

    .contact-info {
      flex: 1;
      min-width: 0;
    }

    .contact-top-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 3px;
    }

    .contact-name {
      font-weight: 700;
      font-size: 14px;
      color: #1e293b;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      display: flex;
      align-items: center;
      gap: 4px;
    }

    .contact-item.active .contact-name {
      color: #065f46;
    }

    .contact-time {
      font-size: 11px;
      color: #94a3b8;
      flex-shrink: 0;
      margin-left: 6px;
    }

    .contact-bottom-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .contact-last-msg {
      font-size: 12.5px;
      color: #64748b;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      max-width: 175px;
    }

    .contact-unread-count {
      background: #ef4444;
      color: white;
      border-radius: 12px;
      padding: 1px 7px;
      font-size: 10.5px;
      font-weight: 700;
      min-width: 16px;
      text-align: center;
      line-height: 15px;
    }

    .badge-cskh {
      background: #ecfdf5;
      color: #059669;
      border: 1px solid #a7f3d0;
      padding: 2px 8px;
      border-radius: 12px;
      font-size: 11px;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 4px;
    }

    .badge-role-tag {
      font-size: 10.5px;
      padding: 2px 7px;
      border-radius: 6px;
      font-weight: 600;
    }

    .verified-icon {
      color: #10b981;
      font-size: 13px;
      margin-left: 3px;
    }

    /* Right Main Chat Area */
    .chat-main-area {
      flex: 1;
      display: flex;
      flex-direction: column;
      background: #f8fafc;
      min-width: 0;
      height: 100%;
    }

    /* Active Header */
    .chat-active-header {
      padding: 14px 24px;
      border-bottom: 1px solid #edf2f7;
      display: flex;
      justify-content: space-between;
      align-items: center;
      background: #ffffff;
      box-shadow: 0 1px 4px rgba(0,0,0,0.02);
      z-index: 10;
    }

    .active-contact-left {
      display: flex;
      align-items: center;
      gap: 13px;
    }

    .active-contact-title {
      display: flex;
      align-items: center;
      gap: 8px;
      flex-wrap: wrap;
    }

    .active-contact-name {
      font-size: 16px;
      font-weight: 700;
      color: #0f172a;
      margin: 0;
    }

    .active-contact-status {
      font-size: 12px;
      color: #64748b;
      display: flex;
      align-items: center;
      gap: 6px;
      margin-top: 3px;
    }

    .active-contact-actions {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .btn-chat-outline {
      border: 1.5px solid #e2e8f0;
      background: #ffffff;
      padding: 7px 14px;
      border-radius: 20px;
      font-size: 12.5px;
      text-decoration: none !important;
      color: #334155;
      font-weight: 600;
      transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
      display: inline-flex;
      align-items: center;
      gap: 6px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.04);
    }

    .btn-chat-outline:hover {
      border-color: #3bb77e;
      color: #065f46;
      background: #ecfdf5;
      transform: translateY(-1px);
    }

    /* Referenced Order Banner */
    .chat-ref-order-banner {
      background: linear-gradient(135deg, #f0fdf4 0%, #ecfdf5 100%);
      border: 1.5px solid #a7f3d0;
      border-radius: 12px;
      margin: 12px 20px 0;
      padding: 12px 18px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 14px;
      box-shadow: 0 4px 14px rgba(16, 185, 129, 0.08);
      animation: slideDownBanner 0.25s ease;
    }
    @keyframes slideDownBanner {
      from { opacity: 0; transform: translateY(-8px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .chat-ref-order-left {
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .ref-order-icon-box {
      width: 40px;
      height: 40px;
      border-radius: 10px;
      background: #ffffff;
      color: #10b981;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      box-shadow: 0 2px 6px rgba(16, 185, 129, 0.15);
      flex-shrink: 0;
    }

    .ref-order-meta h5 {
      margin: 0 0 3px 0;
      font-size: 14px;
      color: #0f172a;
      display: flex;
      align-items: center;
      gap: 6px;
      flex-wrap: wrap;
    }

    .ref-order-meta p {
      margin: 0;
      font-size: 12px;
      color: #64748b;
    }

    .chat-ref-order-actions {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .btn-ref-send {
      background: linear-gradient(135deg, #3bb77e 0%, #29a56c 100%);
      color: white;
      border: none;
      padding: 7px 14px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 700;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      box-shadow: 0 2px 8px rgba(59, 183, 126, 0.3);
      transition: transform 0.2s;
    }
    .btn-ref-send:hover { transform: translateY(-1px); }

    .btn-ref-track {
      background: white;
      color: #0369a1;
      border: 1px solid #7dd3fc;
      padding: 6px 13px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 5px;
    }

    .btn-ref-close {
      background: none;
      border: none;
      font-size: 20px;
      color: #94a3b8;
      cursor: pointer;
      line-height: 1;
      padding: 4px;
    }

    /* Messages Area */
    .chat-messages-container {
      flex: 1;
      padding: 22px 26px;
      overflow-y: auto;
      background: #f8fafc;
      display: flex;
      flex-direction: column;
      gap: 16px;
    }

    .empty-conversation-notice {
      margin: auto;
      text-align: center;
      padding: 40px 20px;
    }

    .empty-icon-wrap {
      width: 70px;
      height: 70px;
      border-radius: 50%;
      background: #ecfdf5;
      color: #10b981;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 32px;
      margin: 0 auto 16px;
      box-shadow: 0 4px 16px rgba(16, 185, 129, 0.2);
    }

    .chat-message-row {
      display: flex;
      align-items: flex-end;
      gap: 10px;
      max-width: 75%;
      animation: fadeInMsg 0.22s cubic-bezier(0.4, 0, 0.2, 1);
    }
    @keyframes fadeInMsg {
      from { opacity: 0; transform: translateY(6px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .chat-message-row.row-mine {
      align-self: flex-end;
      flex-direction: row-reverse;
    }

    .chat-message-row.row-theirs {
      align-self: flex-start;
    }

    .message-sender-avatar {
      width: 32px;
      height: 32px;
      border-radius: 50%;
      background: #64748b;
      color: white;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 12px;
      font-weight: 700;
      flex-shrink: 0;
      margin-bottom: 18px;
    }

    .bubble-and-time {
      display: flex;
      flex-direction: column;
      max-width: 100%;
    }

    .chat-message-row.row-mine .bubble-and-time {
      align-items: flex-end;
    }

    .message-sender-label {
      font-size: 11px;
      color: #64748b;
      margin-bottom: 3px;
      font-weight: 600;
      margin-left: 4px;
    }

    .chat-bubble {
      padding: 12px 18px;
      font-size: 14.5px;
      line-height: 1.55;
      word-break: break-word;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
    }

    .bubble-mine {
      background: linear-gradient(135deg, #10b981 0%, #059669 100%);
      color: white;
      border-radius: 18px 18px 4px 18px;
      box-shadow: 0 4px 15px rgba(16, 185, 129, 0.28);
    }

    .bubble-theirs {
      background: #ffffff;
      color: #1e293b;
      border: 1px solid #e2e8f0;
      border-radius: 18px 18px 18px 4px;
    }

    .message-time-meta {
      font-size: 11px;
      color: #94a3b8;
      margin-top: 4px;
      padding: 0 4px;
    }

    /* Order Link Chip inside message */
    .order-link-chip {
      background: rgba(255, 255, 255, 0.28);
      color: inherit;
      padding: 2px 8px;
      border-radius: 6px;
      font-weight: 700;
      text-decoration: underline;
      display: inline-flex;
      align-items: center;
      gap: 4px;
    }
    .bubble-theirs .order-link-chip {
      background: #eff6ff;
      color: #1d4ed8;
      border: 1px solid #bfdbfe;
      text-decoration: none;
    }
    .bubble-theirs .order-link-chip:hover {
      background: #dbeafe;
    }

    /* Quick Suggestions */
    .chat-quick-suggestions {
      background: #ffffff;
      border-top: 1px solid #f1f5f9;
      padding: 10px 22px;
      display: flex;
      align-items: center;
      gap: 8px;
      overflow-x: auto;
      white-space: nowrap;
    }
    .chat-quick-suggestions::-webkit-scrollbar { height: 4px; }
    .chat-quick-suggestions::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 4px; }

    .quick-title {
      font-size: 12px;
      font-weight: 700;
      color: #64748b;
      display: flex;
      align-items: center;
      gap: 4px;
      flex-shrink: 0;
    }

    .quick-chip {
      background: #f8fafc;
      border: 1.5px solid #e2e8f0;
      padding: 6px 14px;
      border-radius: 20px;
      font-size: 12.5px;
      color: #334155;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 5px;
      transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
      flex-shrink: 0;
      font-weight: 500;
    }
    .quick-chip:hover {
      background: #ecfdf5;
      border-color: #10b981;
      color: #065f46;
      transform: translateY(-1.5px);
      box-shadow: 0 3px 10px rgba(16, 185, 129, 0.18);
    }

    /* Input Bar */
    .chat-input-form {
      padding: 14px 22px;
      background: #ffffff;
      border-top: 1px solid #edf2f7;
      position: relative;
    }

    .chat-input-wrapper {
      display: flex;
      align-items: center;
      gap: 10px;
      background: #f8fafc;
      border: 1.5px solid #e2e8f0;
      border-radius: 30px;
      padding: 6px 8px 6px 16px;
      transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
    }

    .chat-input-wrapper:focus-within {
      border-color: #10b981;
      background: #ffffff;
      box-shadow: 0 0 0 3.5px rgba(16, 185, 129, 0.15);
    }

    #chatInputMessage {
      flex: 1;
      border: none;
      background: transparent;
      font-size: 14.5px;
      color: #0f172a;
      outline: none;
      padding: 6px 4px;
    }

    .btn-emoji-toggle {
      background: none;
      border: none;
      font-size: 20px;
      color: #64748b;
      cursor: pointer;
      padding: 4px;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: color 0.2s;
    }
    .btn-emoji-toggle:hover {
      color: #f59e0b;
    }

    .emoji-tray {
      position: absolute;
      bottom: 70px;
      left: 22px;
      background: white;
      border-radius: 14px;
      padding: 12px 14px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.15);
      border: 1px solid #e2e8f0;
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
      max-width: 320px;
      z-index: 50;
    }
    .emoji-tray span {
      font-size: 22px;
      cursor: pointer;
      transition: transform 0.15s;
    }
    .emoji-tray span:hover {
      transform: scale(1.3);
    }

    .btn-send-message {
      background: linear-gradient(135deg, #10b981 0%, #059669 100%);
      color: white;
      border: none;
      border-radius: 24px;
      padding: 10px 22px;
      font-weight: 700;
      font-size: 14px;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      box-shadow: 0 4px 14px rgba(16, 185, 129, 0.35);
      transition: all 0.2s ease;
    }
    .btn-send-message:hover {
      transform: translateY(-1.5px);
      box-shadow: 0 6px 20px rgba(16, 185, 129, 0.45);
    }
    .btn-send-message:active {
      transform: translateY(0);
    }

    @media (max-width: 900px) {
      .chat-sidebar {
        width: 100%;
        min-width: 100%;
      }
      .chat-container-card {
        flex-direction: column;
      }
      .chat-page-wrapper {
        height: auto;
        min-height: auto;
      }
    }
  </style>

</head>
<body style="background: #f4f6f8;">

  <!-- Top bar -->
  <div class="top-bar">
    <div><i class="fa fa-phone"></i> Hotline Hỗ Trợ 24/7: 1900 6868 | Tư vấn thực phẩm sạch</div>
    <div>Trung Tâm Trò Chuyện & Chăm Sóc Khách Hàng GreenMart</div>
  </div>

  <!-- Header -->
  <header class="header">
    <a href="home" class="logo">
      <i class="fa-solid fa-leaf"></i> GREENMART
    </a>

    <div class="header-actions">
      <a href="home" class="action-item">
        <i class="fa fa-arrow-left"></i>
        <span>Tiếp tục mua sắm</span>
      </a>
      <a href="cart" class="action-item">
        <i class="fa-solid fa-cart-shopping"></i>
        <span>Giỏ hàng</span>
        <span class="badge" id="cart-count">
          ${not empty sessionScope.cart ? sessionScope.cart.totalQuantity : 0}
        </span>
      </a>
      <c:if test="${not empty sessionScope.user}">
        <a href="profile" class="action-item" title="Xem thông tin cá nhân">
          <i class="fa-solid fa-circle-user" style="color: var(--primary-color);"></i>
          <span>${sessionScope.user.username}</span>
        </a>
        <c:if test="${sessionScope.user.role == 'admin'}">
          <a href="admin" class="action-item" style="color: #2563eb;">
            <i class="fa-solid fa-gauge"></i> Quản trị
          </a>
        </c:if>
        <a href="auth?action=logout" class="action-item" style="color:#ef4444;" title="Đăng xuất">
          <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
        </a>
      </c:if>
    </div>
  </header>

  <!-- Navigation -->
  <nav class="navbar">
    <ul class="nav-links">
      <li><a href="home"><i class="fa fa-home"></i> Trang chủ</a></li>
      <li><a href="home#products"><i class="fa-solid fa-store"></i> Sản phẩm</a></li>
      <li><a href="cart"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng</a></li>
      <li><a href="track-order"><i class="fa-solid fa-truck-fast"></i> Tra cứu đơn hàng</a></li>
      <li><a href="chat" style="text-decoration: underline;"><i class="fa-solid fa-comments"></i> Trò chuyện / Chat</a></li>
      <c:if test="${not empty sessionScope.user}">
        <li><a href="profile"><i class="fa-solid fa-user-gear"></i> Thông tin User</a></li>
      </c:if>
      <c:if test="${sessionScope.user.role == 'admin'}">
        <li><a href="admin"><i class="fa-solid fa-gauge"></i> Trang Quản trị (Admin)</a></li>
      </c:if>
    </ul>
    <div style="color: white; font-size: 14px;"><i class="fa-solid fa-headset"></i> Trung tâm hỗ trợ trực tuyến 24/7</div>
  </nav>

  <!-- Main Chat Container -->
  <div class="chat-page-wrapper">
    <div class="chat-container-card">

      <!-- Left Sidebar: Danh sách người trò chuyện -->
      <aside class="chat-sidebar">
        <!-- Current user banner -->
        <div class="chat-sidebar-header">
          <div class="current-user-info">
            <div class="avatar-circle current-avatar">
              <c:choose>
                <c:when test="${sessionScope.user.role == 'admin'}">
                  <i class="fa-solid fa-headset"></i>
                </c:when>
                <c:when test="${not empty sessionScope.user.username}">
                  ${fn:toUpperCase(fn:substring(sessionScope.user.username, 0, 1))}
                </c:when>
                <c:otherwise>
                  <i class="fa-solid fa-user"></i>
                </c:otherwise>
              </c:choose>
            </div>
            <div class="user-details">
              <h4>${sessionScope.user.username}</h4>
              <span class="online-indicator">
                <span class="dot-online"></span>
                <c:choose>
                  <c:when test="${sessionScope.user.role == 'admin'}">
                    Tư vấn viên (Admin CSKH)
                  </c:when>
                  <c:otherwise>
                    Đang trực tuyến
                  </c:otherwise>
                </c:choose>
              </span>
            </div>
          </div>
        </div>

        <!-- Search contacts -->
        <div class="chat-search-wrap">
          <i class="fa-solid fa-magnifying-glass search-icon"></i>
          <input type="text" id="contactSearchInput" placeholder="Tìm kiếm liên hệ..." onkeyup="filterContacts()">
        </div>

        <!-- Contact List -->
        <div class="contacts-scroll-area" id="contactsListContainer">
          <c:choose>
            <c:when test="${empty contacts}">
              <div style="padding: 35px 20px; text-align: center; color: #94a3b8; font-size: 14px;">
                <i class="fa-regular fa-comment-dots" style="font-size: 36px; margin-bottom: 10px; display: block; color:#cbd5e1;"></i>
                Chưa có cuộc trò chuyện nào
              </div>
            </c:when>
            <c:otherwise>
              <c:forEach var="c" items="${contacts}">
                <a href="chat?with=${c.user.id}" 
                   class="contact-item ${activeContact != null && activeContact.id == c.user.id ? 'active' : ''}"
                   data-contact-id="${c.user.id}"
                   data-name="${fn:toLowerCase(c.user.username)}"
                   data-role="${fn:toLowerCase(c.user.role)}">
                  
                  <div class="contact-avatar ${c.user.role == 'admin' ? 'admin-avatar' : ''}">
                    <c:choose>
                      <c:when test="${c.user.role == 'admin'}">
                        <i class="fa-solid fa-headset"></i>
                      </c:when>
                      <c:when test="${not empty c.user.username}">
                        ${fn:toUpperCase(fn:substring(c.user.username, 0, 1))}
                      </c:when>
                      <c:otherwise>
                        U
                      </c:otherwise>
                    </c:choose>
                    <span class="avatar-status-dot"></span>
                  </div>

                  <div class="contact-info">
                    <div class="contact-top-row">
                      <span class="contact-name">
                        ${c.user.username}
                        <c:if test="${c.user.role == 'admin'}">
                          <i class="fa-solid fa-circle-check verified-icon" title="Nhân viên hỗ trợ chính thức"></i>
                        </c:if>
                      </span>
                      <c:if test="${not empty c.lastMessage && fn:length(c.lastMessage.createdAt) >= 16}">
                        <span class="contact-time">${fn:substring(c.lastMessage.createdAt, 11, 16)}</span>
                      </c:if>
                    </div>

                    <div class="contact-bottom-row">
                      <span class="contact-last-msg">
                        <c:choose>
                          <c:when test="${not empty c.lastMessage}">
                            <c:if test="${c.lastMessage.senderId == sessionScope.user.id}">Bạn: </c:if>
                            ${c.lastMessage.content}
                          </c:when>
                          <c:otherwise>
                            <c:choose>
                              <c:when test="${c.user.role == 'admin'}">
                                <span style="color: #16a34a; font-weight: 500;">Bắt đầu trò chuyện với CSKH...</span>
                              </c:when>
                              <c:otherwise>
                                <span style="color: #94a3b8; font-style: italic;">Chưa có tin nhắn...</span>
                              </c:otherwise>
                            </c:choose>
                          </c:otherwise>
                        </c:choose>
                      </span>

                      <div style="display: flex; gap: 4px; align-items: center;">
                        <c:if test="${c.user.role == 'admin'}">
                          <span class="badge-cskh">CSKH</span>
                        </c:if>
                        <c:if test="${c.unreadCount > 0}">
                          <span class="contact-unread-count">${c.unreadCount}</span>
                        </c:if>
                      </div>
                    </div>
                  </div>
                </a>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </div>
      </aside>

      <!-- Right Main: Khung Chat -->
      <main class="chat-main-area">
        <c:choose>
          <c:when test="${activeContact != null}">
            <!-- Chat Active Header -->
            <div class="chat-active-header">
              <div class="active-contact-left">
                <div class="contact-avatar active-avatar ${activeContact.role == 'admin' ? 'admin-avatar' : ''}">
                  <c:choose>
                    <c:when test="${activeContact.role == 'admin'}">
                      <i class="fa-solid fa-headset"></i>
                    </c:when>
                    <c:when test="${not empty activeContact.username}">
                      ${fn:toUpperCase(fn:substring(activeContact.username, 0, 1))}
                    </c:when>
                    <c:otherwise>
                      U
                    </c:otherwise>
                  </c:choose>
                  <span class="avatar-status-dot"></span>
                </div>
                <div>
                  <div class="active-contact-title">
                    <h3 class="active-contact-name" style="margin: 0;">
                      ${activeContact.username}
                    </h3>
                    <c:choose>
                      <c:when test="${activeContact.role == 'admin'}">
                        <span class="badge-cskh">
                          <i class="fa-solid fa-shield-halved"></i> CSKH GreenMart 24/7
                        </span>
                      </c:when>
                      <c:otherwise>
                        <span class="badge-role-tag" style="background:#f1f5f9; color:#475569;">
                          Khách hàng
                        </span>
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <div class="active-contact-status" style="margin-top: 3px;">
                    <span class="dot-online"></span> 
                    <c:choose>
                      <c:when test="${activeContact.role == 'admin'}">
                        Sẵn sàng hỗ trợ giải đáp đơn hàng, giao hàng & tư vấn sản phẩm
                      </c:when>
                      <c:otherwise>
                        Đang hoạt động &bull; Email: ${activeContact.email}
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>
              </div>

              <div class="active-contact-actions" style="display:flex; gap:8px;">
                <c:if test="${not empty referencedOrder || not empty orderCodeParam}">
                  <a href="track-order?code=${not empty referencedOrder ? referencedOrder.orderCode : orderCodeParam}" target="_blank" class="btn-chat-outline" style="background:#ecfdf5; border-color:#86efac; color:#15803d; font-weight:700;" title="Xem hành trình đơn hàng này">
                    <i class="fa-solid fa-receipt"></i> Đơn #${not empty referencedOrder ? referencedOrder.orderCode : orderCodeParam}
                  </a>
                </c:if>
                <a href="track-order" class="btn-chat-outline" title="Tra cứu tiến trình đơn hàng">
                  <i class="fa-solid fa-truck-fast"></i> Tra cứu đơn
                </a>
                <a href="cart" class="btn-chat-outline" title="Xem giỏ hàng của bạn">
                  <i class="fa-solid fa-cart-shopping"></i> Giỏ hàng
                </a>
              </div>
            </div>

            <!-- Chat Messages Body -->
            <div class="chat-messages-container" id="chatMessagesContainer">
              <c:choose>
                <c:when test="${empty messages}">
                  <div class="empty-conversation-notice" id="emptyNotice">
                    <div class="empty-icon-wrap">
                      <c:choose>
                        <c:when test="${activeContact.role == 'admin'}">
                          <i class="fa-solid fa-headset"></i>
                        </c:when>
                        <c:otherwise>
                          <i class="fa-regular fa-comments"></i>
                        </c:otherwise>
                      </c:choose>
                    </div>
                    <c:choose>
                      <c:when test="${activeContact.role == 'admin'}">
                        <h4 style="color:#0f172a; margin-bottom:6px;">Chào bạn! Bạn cần GreenMart hỗ trợ gì hôm nay?</h4>
                        <p style="color:#64748b; font-size:14px; max-width:440px; margin:0 auto 15px;">
                          Đội ngũ CSKH GreenMart luôn sẵn sàng tư vấn thực phẩm tươi sạch, kiểm tra đơn hàng và giải đáp mọi thắc mắc.
                        </p>
                      </c:when>
                      <c:otherwise>
                        <h4 style="color:#0f172a; margin-bottom:6px;">Bắt đầu trò chuyện với ${activeContact.username}!</h4>
                        <p style="color:#64748b; font-size:14px;">Gửi tin nhắn đầu tiên để bắt đầu cuộc trò chuyện.</p>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </c:when>
                <c:otherwise>
                  <c:forEach var="m" items="${messages}">
                    <div class="chat-message-row ${m.senderId == sessionScope.user.id ? 'row-mine' : 'row-theirs'}" data-msg-id="${m.id}">
                      <c:if test="${m.senderId != sessionScope.user.id}">
                        <div class="message-sender-avatar ${activeContact.role == 'admin' ? 'admin-avatar' : ''}">
                          <c:choose>
                            <c:when test="${activeContact.role == 'admin'}">
                              <i class="fa-solid fa-headset"></i>
                            </c:when>
                            <c:when test="${not empty m.senderName}">
                              ${fn:toUpperCase(fn:substring(m.senderName, 0, 1))}
                            </c:when>
                            <c:otherwise>
                              U
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </c:if>

                      <div class="bubble-and-time">
                        <c:if test="${m.senderId != sessionScope.user.id}">
                          <div class="message-sender-label">
                            ${m.senderName}
                            <c:if test="${activeContact.role == 'admin'}">
                              <span style="color:#15803d; font-size:10px; font-weight:700;">(CSKH)</span>
                            </c:if>
                          </div>
                        </c:if>
                        <div class="chat-bubble ${m.senderId == sessionScope.user.id ? 'bubble-mine' : 'bubble-theirs'}">
                          <c:out value="${m.content}"/>
                        </div>
                        <div class="message-time-meta">
                          <c:choose>
                            <c:when test="${not empty m.createdAt && fn:length(m.createdAt) >= 16}">
                              ${fn:substring(m.createdAt, 11, 16)} &bull; ${fn:substring(m.createdAt, 8, 10)}/${fn:substring(m.createdAt, 5, 7)}
                            </c:when>
                            <c:otherwise>
                              <c:out value="${m.createdAt}"/>
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </div>
                    </div>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
            </div>

            <!-- Thẻ đơn hàng đính kèm tham chiếu (Referenced Order Card Banner) -->
            <c:if test="${not empty referencedOrder || not empty orderCodeParam}">
              <div id="referencedOrderBanner" class="chat-ref-order-banner">
                <div class="chat-ref-order-left">
                  <div class="ref-order-icon-box">
                    <i class="fa-solid fa-receipt"></i>
                  </div>
                  <div class="ref-order-meta">
                    <h5>
                      <span>Đơn hàng đang thảo luận:</span>
                      <strong>#${not empty referencedOrder ? referencedOrder.orderCode : orderCodeParam}</strong>
                      <c:if test="${not empty referencedOrder}">
                        <c:choose>
                          <c:when test="${referencedOrder.status == 'Completed' || referencedOrder.status == 'Delivered'}">
                            <span class="status-pill pill-completed" style="font-size:11px; padding:2px 8px;"><i class="fa-solid fa-circle-check"></i> Hoàn tất</span>
                          </c:when>
                          <c:when test="${referencedOrder.status == 'Shipping'}">
                            <span class="status-pill pill-shipping" style="font-size:11px; padding:2px 8px;"><i class="fa-solid fa-truck-fast"></i> Đang giao</span>
                          </c:when>
                          <c:when test="${referencedOrder.status == 'Confirmed'}">
                            <span class="status-pill pill-confirmed" style="font-size:11px; padding:2px 8px;"><i class="fa-solid fa-boxes-packing"></i> Đã xác nhận</span>
                          </c:when>
                          <c:when test="${referencedOrder.status == 'Canceled' || referencedOrder.status == 'Cancelled'}">
                            <span class="status-pill pill-canceled" style="font-size:11px; padding:2px 8px;"><i class="fa-solid fa-ban"></i> Đã hủy</span>
                          </c:when>
                          <c:otherwise>
                            <span class="status-pill pill-waiting" style="font-size:11px; padding:2px 8px;"><i class="fa-solid fa-hourglass-half"></i> Chờ duyệt</span>
                          </c:otherwise>
                        </c:choose>
                      </c:if>
                    </h5>
                    <p>
                      <c:choose>
                        <c:when test="${not empty referencedOrder}">
                          Tổng tiền: <strong><fmt:formatNumber value="${referencedOrder.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></strong> &bull; Đặt ngày ${referencedOrder.createdAt}
                        </c:when>
                        <c:otherwise>
                          Bạn đang yêu cầu hỗ trợ về mã đơn này.
                        </c:otherwise>
                      </c:choose>
                    </p>
                  </div>
                </div>
                <div class="chat-ref-order-actions">
                  <button type="button" class="btn-ref-send" onclick="sendQuickMessage('Shop ơi, kiểm tra giúp mình tiến độ đơn hàng #${not empty referencedOrder ? referencedOrder.orderCode : orderCodeParam} với ạ! 📦')">
                    <i class="fa-solid fa-paper-plane"></i> Gửi vào chat
                  </button>
                  <a href="track-order?code=${not empty referencedOrder ? referencedOrder.orderCode : orderCodeParam}" target="_blank" class="btn-ref-track">
                    <i class="fa-solid fa-truck-fast"></i> Xem hành trình
                  </a>
                  <button type="button" class="btn-ref-close" onclick="document.getElementById('referencedOrderBanner').style.display='none'" title="Đóng thẻ tham chiếu">
                    &times;
                  </button>
                </div>
              </div>
            </c:if>

            <!-- Quick Suggestions (Gợi ý câu hỏi nhanh thông minh theo vai trò) -->
            <div class="chat-quick-suggestions">
              <span class="quick-title"><i class="fa-solid fa-bolt"></i> Gợi ý:</span>
              <c:choose>
                <c:when test="${sessionScope.user.role == 'admin'}">
                  <!-- Gợi ý dành cho Admin / Nhân viên CSKH -->
                  <button type="button" class="quick-chip" onclick="sendQuickMessage('Dạ chào bạn! GreenMart có thể hỗ trợ gì cho bạn hôm nay ạ? 👋')">👋 Chào khách</button>
                  <button type="button" class="quick-chip" onclick="sendQuickMessage('Rau củ hữu cơ VietGAP bên em mới thu hoạch sáng nay, cực kỳ tươi ngon bạn nhé! 🥦')">🥦 Tư vấn rau củ</button>
                  <button type="button" class="quick-chip" onclick="sendQuickMessage('Đơn hàng nội thành bên mình giao hỏa tốc trong 2 giờ bạn nhé! 🚚')">🚚 Báo thời gian giao</button>
                  <button type="button" class="quick-chip" onclick="sendQuickMessage('Bạn vui lòng gửi mã đơn hàng để shop kiểm tra tiến độ giao hàng ngay cho bạn nhé! 📦')">📦 Hỏi mã đơn</button>
                  <button type="button" class="quick-chip" onclick="sendQuickMessage('Dạ bên em có hỗ trợ xuất hoá đơn điện tử VAT đầy đủ cho công ty ạ! 🧾')">🧾 Xuất hoá đơn VAT</button>
                </c:when>
                <c:otherwise>
                  <!-- Gợi ý dành cho Khách hàng -->
                  <button type="button" class="quick-chip" onclick="sendQuickMessage('Chào shop, mình cần tư vấn thực phẩm tươi sạch hôm nay ạ! 👋')">👋 Chào shop tư vấn</button>
                  <c:choose>
                    <c:when test="${not empty param.orderCode || not empty orderCodeParam}">
                      <button type="button" class="quick-chip" onclick="sendQuickMessage('Shop ơi, kiểm tra giúp mình tiến độ đơn hàng #${not empty param.orderCode ? param.orderCode : orderCodeParam} với ạ! 📦')">📦 Hỏi đơn #${not empty param.orderCode ? param.orderCode : orderCodeParam}</button>
                    </c:when>
                    <c:otherwise>
                      <button type="button" class="quick-chip" onclick="sendQuickMessage('Shop kiểm tra giúp mình tiến độ đơn hàng vừa đặt với ạ! 📦')">📦 Kiểm tra đơn hàng</button>
                    </c:otherwise>
                  </c:choose>
                  <button type="button" class="quick-chip" onclick="sendQuickMessage('Rau củ hữu cơ và trái cây hôm nay có những loại nào tươi ngon vậy shop? 🥦')">🥦 Rau củ hôm nay</button>
                  <button type="button" class="quick-chip" onclick="sendQuickMessage('Đơn hàng giao trong nội thành thì khoảng bao lâu nhận được ạ? 🚚')">🚚 Thời gian giao hàng</button>
                  <button type="button" class="quick-chip" onclick="sendQuickMessage('Cửa hàng có chính sách freeship cho đơn từ bao nhiêu không ạ? 🏷️')">🏷️ Ưu đãi phí ship</button>
                  <button type="button" class="quick-chip" onclick="sendQuickMessage('GreenMart có hỗ trợ xuất hoá đơn đỏ VAT cho đơn hàng không ạ? 🧾')">🧾 Xuất hoá đơn VAT</button>
                </c:otherwise>
              </c:choose>
            </div>

            <!-- Chat Input Bar -->
            <form id="chatForm" class="chat-input-form" onsubmit="handleSendMessage(event)">
              <div class="chat-input-wrapper">
                <!-- Emoji toggle -->
                <button type="button" class="btn-emoji-toggle" onclick="toggleEmojiPicker()" title="Chọn biểu cảm emoji">
                  <i class="fa-regular fa-face-smile"></i>
                </button>

                <!-- Emoji Picker Tray -->
                <div id="emojiPickerTray" class="emoji-tray" style="display: none;">
                  <span onclick="insertEmoji('😊')">😊</span>
                  <span onclick="insertEmoji('👍')">👍</span>
                  <span onclick="insertEmoji('❤️')">❤️</span>
                  <span onclick="insertEmoji('🌱')">🌱</span>
                  <span onclick="insertEmoji('🛒')">🛒</span>
                  <span onclick="insertEmoji('📦')">📦</span>
                  <span onclick="insertEmoji('🥦')">🥦</span>
                  <span onclick="insertEmoji('🍅')">🍅</span>
                  <span onclick="insertEmoji('🥑')">🥑</span>
                  <span onclick="insertEmoji('🍎')">🍎</span>
                  <span onclick="insertEmoji('⭐')">⭐</span>
                  <span onclick="insertEmoji('🔥')">🔥</span>
                  <span onclick="insertEmoji('🎉')">🎉</span>
                  <span onclick="insertEmoji('💯')">💯</span>
                </div>

                <input type="text" 
                       id="chatInputMessage" 
                       placeholder="Nhập tin nhắn với ${activeContact.username}... (Nhấn Enter để gửi)" 
                       autocomplete="off" 
                       required>

                <button type="submit" id="btnSubmitChat" class="btn-send-message">
                  <i class="fa-solid fa-paper-plane"></i> Gửi
                </button>
              </div>
            </form>
          </c:when>

          <c:otherwise>
            <!-- When no contact is selected -->
            <div class="empty-conversation-notice" style="height: 100%; display: flex; flex-direction: column; justify-content: center; align-items: center;">
              <div class="empty-icon-wrap" style="width: 80px; height: 80px; font-size: 36px;">
                <i class="fa-solid fa-comments"></i>
              </div>
              <h3 style="margin-bottom: 8px;">Chào mừng bạn đến với Hộp thoại GreenMart</h3>
              <p style="color: #64748b; font-size: 14px; max-width: 400px; text-align: center;">
                Vui lòng chọn một người từ danh sách liên hệ bên trái để bắt đầu cuộc trò chuyện.
              </p>
            </div>
          </c:otherwise>
        </c:choose>
      </main>

    </div>
  </div>

  <script>
    const currentUserId = ${sessionScope.user != null ? sessionScope.user.id : -1};
    const currentUserName = '<c:out value="${sessionScope.user != null ? sessionScope.user.username : ''}" escapeXml="true"/>';
    const activeContactId = ${activeContact != null ? activeContact.id : 'null'};
    const initialOrderCode = '<c:out value="${not empty param.orderCode ? param.orderCode : (not empty orderCodeParam ? orderCodeParam : '')}" escapeXml="true"/>';

    // Web Audio Sound Chime when receiving message
    function playChime() {
      try {
        const AudioCtx = window.AudioContext || window.webkitAudioContext;
        if (!AudioCtx) return;
        const ctx = new AudioCtx();
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.type = 'sine';
        osc.frequency.setValueAtTime(587.33, ctx.currentTime);
        osc.frequency.setValueAtTime(880.00, ctx.currentTime + 0.08);
        gain.gain.setValueAtTime(0.12, ctx.currentTime);
        gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.35);
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.start();
        osc.stop(ctx.currentTime + 0.35);
      } catch (e) {}
    }

    // Scroll to bottom of message container
    function scrollToBottom(smooth) {
      const container = document.getElementById('chatMessagesContainer');
      if (container) {
        if (smooth) {
          container.scrollTo({ top: container.scrollHeight, behavior: 'smooth' });
        } else {
          container.scrollTop = container.scrollHeight;
        }
      }
    }

    // Get max message ID currently in DOM
    function getMaxMessageId() {
      const rows = document.querySelectorAll('.chat-message-row[data-msg-id]');
      let maxId = 0;
      rows.forEach(r => {
        const id = parseInt(r.getAttribute('data-msg-id'));
        if (id && id > maxId) maxId = id;
      });
      return maxId;
    }

    // Filter contacts on search input
    function filterContacts() {
      const input = document.getElementById('contactSearchInput');
      const filter = input ? input.value.toLowerCase().trim() : '';
      const items = document.querySelectorAll('.contact-item');
      items.forEach(it => {
        const name = it.getAttribute('data-name') || '';
        if (name.includes(filter)) {
          it.style.display = 'flex';
        } else {
          it.style.display = 'none';
        }
      });
    }

    // Cập nhật đoạn trích tin nhắn cuối cùng trên sidebar theo thời gian thực
    function updateSidebarSnippet(contactId, content, timeStr) {
      const contactLink = document.querySelector('.contact-item[data-contact-id="' + contactId + '"]');
      if (contactLink) {
        const lastMsgEl = contactLink.querySelector('.contact-last-msg');
        if (lastMsgEl) {
          lastMsgEl.textContent = content;
          lastMsgEl.style.color = '#334155';
          lastMsgEl.style.fontWeight = '500';
        }
        const timeEl = contactLink.querySelector('.contact-time');
        if (timeEl && timeStr) {
          timeEl.textContent = timeStr;
        }
        // Đưa cuộc trò chuyện lên đầu danh sách
        const parent = contactLink.parentElement;
        if (parent && parent.firstElementChild !== contactLink) {
          parent.insertBefore(contactLink, parent.firstElementChild);
        }
      }
    }

    // Quick emoji insertion
    function toggleEmojiPicker() {
      const tray = document.getElementById('emojiPickerTray');
      if (tray) {
        tray.style.display = (tray.style.display === 'none' || tray.style.display === '') ? 'flex' : 'none';
      }
    }

    function insertEmoji(emoji) {
      const input = document.getElementById('chatInputMessage');
      if (input) {
        input.value += emoji;
        input.focus();
      }
      const tray = document.getElementById('emojiPickerTray');
      if (tray) tray.style.display = 'none';
    }

    // Quick message click
    function sendQuickMessage(text) {
      const input = document.getElementById('chatInputMessage');
      if (input) {
        input.value = text;
        input.focus();
        handleSendMessage();
      }
    }

    function escapeHtml(text) {
      if (!text) return '';
      const div = document.createElement('div');
      div.textContent = text;
      return div.innerHTML;
    }

    function formatMessageContent(text) {
      if (!text) return '';
      let escaped = escapeHtml(text);
      return escaped.replace(/(#?GM\d{6})/gi, function(match) {
        let cleanCode = match.replace('#', '');
        return '<a href="track-order?code=' + cleanCode + '" target="_blank" class="order-link-chip" title="Xem hành trình đơn ' + match + '"><i class="fa-solid fa-receipt"></i> ' + match + '</a>';
      });
    }

    // Append a message bubble to DOM
    function appendMessageDOM(msg, isMine) {
      const container = document.getElementById('chatMessagesContainer');
      if (!container) return;

      const emptyNotice = document.getElementById('emptyNotice');
      if (emptyNotice) emptyNotice.remove();

      // Check if already in DOM
      if (document.querySelector('.chat-message-row[data-msg-id="' + msg.id + '"]')) {
        return;
      }

      const row = document.createElement('div');
      row.className = 'chat-message-row ' + (isMine ? 'row-mine' : 'row-theirs');
      row.setAttribute('data-msg-id', msg.id);

      const timeStr = msg.createdAt && msg.createdAt.length >= 16 ? msg.createdAt.substring(11, 16) : '';
      const dateStr = msg.createdAt && msg.createdAt.length >= 10 ? (msg.createdAt.substring(8, 10) + '/' + msg.createdAt.substring(5, 7)) : '';

      let senderAvatarHtml = '';
      if (!isMine) {
        const initial = (msg.senderName && msg.senderName.length > 0) ? msg.senderName.charAt(0).toUpperCase() : 'U';
        senderAvatarHtml = '<div class="message-sender-avatar">' + initial + '</div>';
      }

      let innerHtml = '';
      innerHtml += senderAvatarHtml;
      innerHtml += '<div class="bubble-and-time">';
      if (!isMine) {
        innerHtml += '<div class="message-sender-label">' + escapeHtml(msg.senderName) + '</div>';
      }
      innerHtml += '<div class="chat-bubble ' + (isMine ? 'bubble-mine' : 'bubble-theirs') + '">';
      innerHtml += formatMessageContent(msg.content);
      innerHtml += '</div>';
      innerHtml += '<div class="message-time-meta">';
      innerHtml += timeStr + ' &bull; ' + dateStr;
      innerHtml += '</div>';
      innerHtml += '</div>';

      row.innerHTML = innerHtml;
      container.appendChild(row);
      scrollToBottom(true);
    }

    // Handle send message form submit
    function handleSendMessage(e) {
      if (e && e.preventDefault) e.preventDefault();
      if (!activeContactId) return;

      const input = document.getElementById('chatInputMessage');
      const content = input ? input.value.trim() : '';
      if (!content) return;

      input.value = '';
      const submitBtn = document.getElementById('btnSubmitChat');
      if (submitBtn) submitBtn.disabled = true;

      const formData = new URLSearchParams();
      formData.append('action', 'send');
      formData.append('receiverId', activeContactId);
      formData.append('content', content);

      fetch('chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData
      })
      .then(res => res.json())
      .then(data => {
        if (submitBtn) submitBtn.disabled = false;
        if (input) input.focus();
        if (data && data.status === 'success' && data.message) {
          appendMessageDOM(data.message, true);
          updateSidebarSnippet(activeContactId, 'Bạn: ' + data.message.content, 'Vừa xong');
        } else if (data && data.message) {
          alert(data.message);
        }
      })
      .catch(err => {
        if (submitBtn) submitBtn.disabled = false;
        if (input) input.focus();
        console.error('Lỗi gửi tin nhắn:', err);
      });
    }

    // Polling new messages
    function pollNewMessages() {
      if (!activeContactId) return;
      const afterId = getMaxMessageId();

      fetch('chat?action=poll&withUserId=' + activeContactId + '&afterId=' + afterId + '&ajax=1')
      .then(res => res.json())
      .then(data => {
        if (data && data.status === 'success' && Array.isArray(data.messages)) {
          let hasNewTheirs = false;
          data.messages.forEach(msg => {
            appendMessageDOM(msg, msg.isMine);
            if (!msg.isMine) {
              hasNewTheirs = true;
              const shortTime = msg.createdAt && msg.createdAt.length >= 16 ? msg.createdAt.substring(11, 16) : '';
              updateSidebarSnippet(msg.senderId, msg.content, shortTime);
            }
          });
          if (hasNewTheirs) {
            playChime();
          }
        }
      })
      .catch(err => {
        console.error('Lỗi nhận tin nhắn mới:', err);
      });
    }

    // Initial setup on load
    window.addEventListener('DOMContentLoaded', () => {
      // Format all pre-existing bubbles with clickable order codes
      document.querySelectorAll('.chat-bubble').forEach(b => {
        b.innerHTML = formatMessageContent(b.textContent.trim());
      });

      scrollToBottom(false);
      const input = document.getElementById('chatInputMessage');
      if (input) {
        if (initialOrderCode) {
          input.value = 'Chào shop, mình cần hỗ trợ về đơn hàng #' + initialOrderCode + ' ạ!';
        }
        input.focus();
      }

      // Start periodic polling every 2.5 seconds
      if (activeContactId) {
        setInterval(pollNewMessages, 2500);
      }
    });

    // Close emoji tray if clicked outside
    document.addEventListener('click', (e) => {
      const tray = document.getElementById('emojiPickerTray');
      const toggle = document.querySelector('.btn-emoji-toggle');
      if (tray && toggle && !tray.contains(e.target) && !toggle.contains(e.target)) {
        tray.style.display = 'none';
      }
    });
  </script>

</body>
</html>
