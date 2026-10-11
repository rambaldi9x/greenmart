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
  <link rel="stylesheet" href="css/chat.css">

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
    window.CHAT_CONFIG = {
      currentUserId: ${sessionScope.user != null ? sessionScope.user.id : -1},
      currentUserName: '<c:out value="${sessionScope.user != null ? sessionScope.user.username : ''}" escapeXml="true"/>',
      activeContactId: ${activeContact != null ? activeContact.id : 'null'},
      initialOrderCode: '<c:out value="${not empty param.orderCode ? param.orderCode : (not empty orderCodeParam ? orderCodeParam : '')}" escapeXml="true"/>'
    };
  </script>
  <script src="js/chat.js"></script>

</body>
</html>
