<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:if test="${orders == null}">
  <c:redirect url="/admin"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>GreenMart - Bảng Điều Khiển Quản Trị</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .admin-layout {
      display: grid;
      grid-template-columns: 240px 1fr;
      min-height: 100vh;
    }
    .sidebar {
      background: #253d4e;
      color: white;
      padding: 25px 20px;
    }
    .sidebar h2 {
      color: var(--primary-color);
      font-size: 22px;
      margin-bottom: 30px;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .sidebar-menu {
      list-style: none;
    }
    .sidebar-menu li {
      margin-bottom: 12px;
    }
    .sidebar-menu a {
      color: #cfd4dc;
      text-decoration: none;
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 10px 15px;
      border-radius: 6px;
      transition: all 0.2s;
    }
    .sidebar-menu a.active, .sidebar-menu a:hover {
      background: var(--primary-color);
      color: white;
    }
    .main-panel {
      padding: 30px 40px;
      background: #f8f9fa;
      overflow-y: auto;
    }
    .stats-cards {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 20px;
      margin-bottom: 30px;
    }
    .card-stat {
      background: white;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
      border-left: 4px solid var(--primary-color);
    }
    .card-stat h4 {
      font-size: 14px;
      color: var(--text-body);
      margin-bottom: 8px;
    }
    .card-stat .val {
      font-size: 24px;
      font-weight: bold;
      color: var(--text-heading);
    }
    .admin-table {
      width: 100%;
      border-collapse: collapse;
      background: white;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    .admin-table th, .admin-table td {
      padding: 12px 16px;
      text-align: left;
      border-bottom: 1px solid var(--border-color);
    }
    .admin-table th {
      background: #f1f3f6;
      color: var(--text-heading);
    }
    .btn-action {
      display: inline-block;
      padding: 6px 12px;
      border-radius: 4px;
      border: none;
      cursor: pointer;
      font-size: 13px;
      text-decoration: none;
      color: white;
    }
    .btn-edit { background: #3b82f6; }
    .btn-delete { background: #ef4444; margin-left: 5px; }
  </style>
</head>
<body>

<div class="admin-layout">
  <!-- Sidebar -->
  <aside class="sidebar">
    <h2><i class="fa fa-leaf"></i> GREENMART</h2>
    <div style="background:rgba(255,255,255,0.08);border-radius:8px;padding:12px 15px;margin-bottom:20px;">
      <div style="font-size:12px;color:#aab4be;">Đăng nhập với tư cách</div>
      <div style="font-weight:bold;color:var(--primary-color);margin-top:4px;">
        ${sessionScope.user.username}
      </div>
    </div>
    <ul class="sidebar-menu">
      <li>
        <a href="admin?tab=dashboard" class="${currentTab == 'dashboard' || empty currentTab ? 'active' : ''}">
          <i class="fa-solid fa-chart-pie"></i> Thống kê
        </a>
      </li>
      <li>
        <a href="admin?tab=products" class="${currentTab == 'products' ? 'active' : ''}">
          <i class="fa-solid fa-box"></i> Quản lý sản phẩm
        </a>
      </li>
      <li>
        <a href="admin?tab=orders" class="${currentTab == 'orders' ? 'active' : ''}">
          <i class="fa fa-shopping-cart"></i> Quản lý đơn hàng
        </a>
      </li>
      <li>
        <a href="admin?tab=vendors" class="${currentTab == 'vendors' ? 'active' : ''}">
          <i class="fa-solid fa-store"></i> Nhà cung cấp (Vendor)
        </a>
      </li>
      <li>
        <a href="admin?tab=users" class="${currentTab == 'users' ? 'active' : ''}">
          <i class="fa-solid fa-users"></i> Quản lý người dùng
        </a>
      </li>
      <li style="margin-top:25px;border-top:1px solid rgba(255,255,255,0.1);padding-top:15px;">
        <a href="home"><i class="fa fa-arrow-left"></i> Xem Website</a>
      </li>
      <li>
        <a href="auth?action=logout" style="color:#f87171;">
          <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
        </a>
      </li>
    </ul>
  </aside>

  <!-- Main content panel -->
  <main class="main-panel">

    <!-- Tab 1: Dashboard -->
    <c:if test="${currentTab == 'dashboard' || empty currentTab}">
      <div>
        <h2 style="margin-bottom: 20px; color: var(--text-heading);">Báo Cáo Hoạt Động Hệ Thống</h2>
        <div class="stats-cards">
          <div class="card-stat">
            <h4>Tổng doanh thu</h4>
            <div class="val">
              <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
            </div>
          </div>
          <div class="card-stat">
            <h4>Tổng số đơn hàng</h4>
            <div class="val">${totalOrders} đơn</div>
          </div>
          <div class="card-stat">
            <h4>Sản phẩm đang bán</h4>
            <div class="val">${totalProducts} món</div>
          </div>
          <div class="card-stat">
            <h4>Nhà bán hàng (Vendor)</h4>
            <div class="val">${totalVendors} shop</div>
          </div>
        </div>

        <div style="background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05);">
          <h3 style="margin-bottom: 15px; color: var(--text-heading);">Đơn hàng gần đây</h3>
          <table class="admin-table">
            <thead>
              <tr>
                <th>Mã đơn</th>
                <th>Khách hàng</th>
                <th>Tổng tiền</th>
                <th>Thời gian</th>
                <th>Trạng thái</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${empty orders}">
                  <tr><td colspan="5" style="text-align:center;padding:25px;color:#888;">Chưa có đơn hàng nào.</td></tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="o" items="${orders}" begin="0" end="4">
                    <tr>
                      <td><strong>${o.orderCode}</strong></td>
                      <td>${o.name}</td>
                      <td style="color:var(--primary-color);font-weight:bold;">
                        <fmt:formatNumber value="${o.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                      </td>
                      <td>${o.createdAt}</td>
                      <td>
                        <c:choose>
                          <c:when test="${o.status == 'Completed'}"><span style="background:#ecfdf5;color:#16a34a;padding:4px 10px;border-radius:4px;font-weight:600;font-size:13px;">Hoàn tất</span></c:when>
                          <c:when test="${o.status == 'Shipping'}"><span style="background:#fffbeb;color:#d97706;padding:4px 10px;border-radius:4px;font-weight:600;font-size:13px;">Đang giao hàng</span></c:when>
                          <c:when test="${o.status == 'Confirmed'}"><span style="background:#f5f3ff;color:#7c3aed;padding:4px 10px;border-radius:4px;font-weight:600;font-size:13px;">Đã xác nhận</span></c:when>
                          <c:when test="${o.status == 'Canceled'}"><span style="background:#fef2f2;color:#dc2626;padding:4px 10px;border-radius:4px;font-weight:600;font-size:13px;">Đã hủy</span></c:when>
                          <c:otherwise><span style="background:#f0f9ff;color:#0284c7;padding:4px 10px;border-radius:4px;font-weight:600;font-size:13px;">Chờ duyệt</span></c:otherwise>
                        </c:choose>
                      </td>
                    </tr>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>
    </c:if>

    <!-- Tab 2: Quản lý sản phẩm (CRUD) -->
    <c:if test="${currentTab == 'products'}">
      <div>
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
          <h2 style="color: var(--text-heading);">Danh sách sản phẩm</h2>
          <a href="admin?tab=products&action=new" class="btn-primary" style="text-decoration:none;">
            <i class="fa fa-plus"></i> Thêm sản phẩm mới
          </a>
        </div>
        <div style="margin-bottom: 16px;">
          <form action="admin" method="GET" style="display:flex; gap:10px;">
            <input type="hidden" name="tab" value="products">
            <input type="text" name="search" value="${search}" placeholder="🔍 Tìm theo tên hoặc danh mục..."
              style="padding:10px 14px;border:1px solid var(--border-color);border-radius:6px;width:340px;font-size:14px;outline:none;">
            <button type="submit" class="btn-primary" style="padding:10px 18px;">Tìm</button>
            <c:if test="${not empty search}">
              <a href="admin?tab=products" style="padding:10px 14px;border:1px solid #ccc;background:white;border-radius:6px;text-decoration:none;color:#555;">✕ Xóa tìm</a>
            </c:if>
          </form>
        </div>

        <table class="admin-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Hình ảnh</th>
              <th>Tên sản phẩm</th>
              <th>Danh mục</th>
              <th>Giá bán</th>
              <th>Tồn kho</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty products}">
                <tr><td colspan="7" style="text-align:center;padding:30px;color:#888;">Không tìm thấy sản phẩm nào.</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="p" items="${products}">
                  <tr>
                    <td>#${p.id}</td>
                    <td><img src="${p.image}" style="width:45px;height:45px;object-fit:cover;border-radius:4px;" alt="${p.name}"></td>
                    <td><strong>${p.name}</strong></td>
                    <td>${p.category}</td>
                    <td style="color:var(--primary-color);font-weight:bold;">
                      <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                    </td>
                    <td>${p.count != null ? p.count : '0'}</td>
                    <td>
                      <a href="admin?tab=products&action=edit&id=${p.id}" class="btn-action btn-edit">
                        <i class="fa-solid fa-pen"></i> Sửa
                      </a>
                      <a href="admin?action=deleteProduct&id=${p.id}" class="btn-action btn-delete">
                        <i class="fa fa-trash"></i> Xóa
                      </a>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </c:if>

    <!-- Tab 3: Quản lý đơn hàng -->
    <c:if test="${currentTab == 'orders'}">
      <div>
        <h2 style="margin-bottom: 16px; color: var(--text-heading);">Quản lý đơn đặt hàng</h2>
        <div style="margin-bottom: 16px;">
          <form action="admin" method="GET" style="display:flex; gap:10px;">
            <input type="hidden" name="tab" value="orders">
            <input type="text" name="search" value="${search}" placeholder="🔍 Tìm theo mã đơn, tên khách hoặc SĐT..."
              style="padding:10px 14px;border:1px solid var(--border-color);border-radius:6px;width:380px;font-size:14px;outline:none;">
            <button type="submit" class="btn-primary" style="padding:10px 18px;">Tìm</button>
            <c:if test="${not empty search}">
              <a href="admin?tab=orders" style="padding:10px 14px;border:1px solid #ccc;background:white;border-radius:6px;text-decoration:none;color:#555;">✕ Xóa tìm</a>
            </c:if>
          </form>
        </div>
        <table class="admin-table">
          <thead>
            <tr>
              <th>Mã đơn</th>
              <th>Khách hàng</th>
              <th>Điện thoại</th>
              <th>Địa chỉ</th>
              <th>Tổng tiền</th>
              <th>Trạng thái</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty orders}">
                <tr><td colspan="7" style="text-align:center;padding:30px;color:#888;">Chưa có đơn hàng nào.</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="o" items="${orders}">
                  <tr>
                    <td><strong>${o.orderCode}</strong></td>
                    <td>${o.name}</td>
                    <td>${o.phone}</td>
                    <td>${o.address}</td>
                    <td style="color:var(--primary-color);font-weight:bold;">
                      <fmt:formatNumber value="${o.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                    </td>
                    <td>
                      <form action="admin" method="POST" style="display:flex; align-items:center; gap:6px;">
                        <input type="hidden" name="action" value="updateOrderStatus">
                        <input type="hidden" name="id" value="${o.id}">
                        <select name="status" style="padding:5px 8px;border-radius:4px;border:1px solid #ccc;font-size:13px;">
                          <option value="Waiting" ${o.status == 'Waiting' ? 'selected' : ''}>Chờ duyệt</option>
                          <option value="Confirmed" ${o.status == 'Confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                          <option value="Shipping" ${o.status == 'Shipping' ? 'selected' : ''}>Đang giao hàng</option>
                          <option value="Completed" ${o.status == 'Completed' ? 'selected' : ''}>Hoàn tất</option>
                          <option value="Canceled" ${o.status == 'Canceled' ? 'selected' : ''}>Hủy đơn</option>
                        </select>
                        <button type="submit" class="btn-action btn-edit" style="padding:4px 8px;font-size:12px;">Lưu</button>
                      </form>
                    </td>
                    <td style="white-space:nowrap;">
                      <a href="admin?tab=orders&viewOrder=${o.id}" class="btn-action btn-edit">
                        <i class="fa-solid fa-eye"></i> Chi tiết
                      </a>
                      <a href="admin?action=deleteOrder&id=${o.id}" class="btn-action btn-delete">
                        <i class="fa fa-trash"></i> Xóa
                      </a>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </c:if>

    <!-- Tab 4: Quản lý nhà cung cấp -->
    <c:if test="${currentTab == 'vendors'}">
      <div>
        <h2 style="margin-bottom:6px;color:var(--text-heading);">Danh sách Nhà Bán Hàng (Vendor)</h2>
        <p style="color:var(--text-body);font-size:13px;margin-bottom:16px;">
          Duyệt hoặc từ chối đăng ký của các cửa hàng muốn bán hàng trên GreenMart.
        </p>
        <table class="admin-table">
          <thead>
            <tr>
              <th>Mã Shop</th>
              <th>Tên Cửa hàng</th>
              <th>Email</th>
              <th>Số điện thoại</th>
              <th>Trạng thái</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty vendors}">
                <tr><td colspan="6" style="text-align:center;padding:30px;color:#888;">Chưa có nhà bán hàng nào.</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="v" items="${vendors}">
                  <tr>
                    <td><strong>${v.shopCode}</strong></td>
                    <td>${v.shopName}</td>
                    <td>${v.email}</td>
                    <td>${v.phone}</td>
                    <td>
                      <c:choose>
                        <c:when test="${v.status == 'Approved'}"><span style="color:#16a34a;font-weight:bold;">Đã duyệt</span></c:when>
                        <c:when test="${v.status == 'Rejected'}"><span style="color:#dc2626;font-weight:bold;">Từ chối</span></c:when>
                        <c:otherwise><span style="color:#d97706;font-weight:bold;">Chờ duyệt</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td style="white-space:nowrap;">
                      <c:choose>
                        <c:when test="${v.status == 'Approved' || v.status == 'Rejected'}">
                          <a href="admin?action=vendorStatus&id=${v.id}&status=Waiting" class="btn-action btn-edit">
                            <i class="fa fa-rotate-left"></i> Đặt lại
                          </a>
                        </c:when>
                        <c:otherwise>
                          <a href="admin?action=vendorStatus&id=${v.id}&status=Approved" class="btn-action btn-edit" style="background:#16a34a;">
                            <i class="fa-solid fa-check"></i> Duyệt
                          </a>
                          <a href="admin?action=vendorStatus&id=${v.id}&status=Rejected" class="btn-action btn-delete">
                            <i class="fa-solid fa-xmark"></i> Từ chối
                          </a>
                        </c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </c:if>

    <!-- Tab 5: Quản lý người dùng -->
    <c:if test="${currentTab == 'users'}">
      <div>
        <h2 style="margin-bottom:6px;color:var(--text-heading);">Danh sách Người dùng</h2>
        <p style="color:var(--text-body);font-size:13px;margin-bottom:16px;">
          Tất cả tài khoản đã đăng ký trên hệ thống.
        </p>
        <table class="admin-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Họ và tên</th>
              <th>Email</th>
              <th>Vai trò</th>
              <th>Ngày đăng ký</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty users}">
                <tr><td colspan="6" style="text-align:center;padding:30px;color:#888;">Chưa có người dùng nào.</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="u" items="${users}">
                  <tr>
                    <td>#${u.id}</td>
                    <td><strong>${u.username}</strong></td>
                    <td>${u.email}</td>
                    <td>
                      <c:choose>
                        <c:when test="${u.role == 'admin'}">
                          <span style="background:#fef3c7;color:#92400e;padding:3px 10px;border-radius:4px;font-size:12px;font-weight:600;">
                            ★ Admin
                          </span>
                        </c:when>
                        <c:otherwise>
                          <span style="background:#f0f9ff;color:#0369a1;padding:3px 10px;border-radius:4px;font-size:12px;font-weight:600;">
                            Khách hàng
                          </span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>${u.createdAt != null ? u.createdAt : '—'}</td>
                    <td>
                      <c:choose>
                        <c:when test="${u.role == 'admin'}">
                          <span style="color:#888;font-size:12px;">Không thể xóa</span>
                        </c:when>
                        <c:otherwise>
                          <a href="admin?action=deleteUser&id=${u.id}" class="btn-action btn-delete">
                            <i class="fa fa-trash"></i> Xóa
                          </a>
                        </c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </c:if>

  </main>
</div>

<!-- Modal Thêm / Sửa Sản Phẩm (Điều hướng bằng Java Servlet) -->
<c:if test="${param.action == 'new' || param.action == 'edit' || not empty editProduct}">
  <div class="modal" id="productModal" style="display: flex;">
    <div class="modal-content" style="max-width: 500px;">
      <div class="modal-header">
        <h3 style="font-size: 18px; color: var(--text-heading);">
          ${not empty editProduct ? 'Chỉnh sửa sản phẩm #' += editProduct.id : 'Thêm sản phẩm mới'}
        </h3>
        <a href="admin?tab=products" class="close-btn" style="text-decoration: none; font-size: 24px; color: #888;">&times;</a>
      </div>
      <form action="admin" method="POST">
        <input type="hidden" name="action" value="saveProduct">
        <input type="hidden" name="id" value="${editProduct != null ? editProduct.id : ''}">
        
        <div class="form-group">
          <label>Tên sản phẩm <span style="color:red;">*</span></label>
          <input type="text" name="name" value="${editProduct != null ? editProduct.name : ''}" required placeholder="Ví dụ: Nui rau củ Safoco">
        </div>
        <div class="form-group">
          <label>Danh mục</label>
          <select name="category">
            <option value="Rau củ & Trái cây" ${editProduct.category == 'Rau củ & Trái cây' ? 'selected' : ''}>Rau củ & Trái cây</option>
            <option value="Thịt, Cá & Trứng" ${editProduct.category == 'Thịt, Cá & Trứng' ? 'selected' : ''}>Thịt, Cá & Trứng</option>
            <option value="Đồ uống & Sữa" ${editProduct.category == 'Đồ uống & Sữa' ? 'selected' : ''}>Đồ uống & Sữa</option>
            <option value="Bánh kẹo" ${editProduct.category == 'Bánh kẹo' ? 'selected' : ''}>Bánh kẹo & Ăn vặt</option>
            <option value="Thực phẩm khô" ${editProduct.category == 'Thực phẩm khô' ? 'selected' : ''}>Thực phẩm khô</option>
          </select>
        </div>
        <div class="form-group">
          <label>Giá bán (VNĐ) <span style="color:red;">*</span></label>
          <input type="number" name="price" value="${editProduct != null ? editProduct.price : ''}" required placeholder="25000">
        </div>
        <div class="form-group">
          <label>Số lượng kho <span style="color:red;">*</span></label>
          <input type="number" name="count" value="${editProduct != null ? editProduct.count : '100'}" required placeholder="100">
        </div>
        <div class="form-group">
          <label>Link ảnh (URL)</label>
          <input type="url" name="image" value="${editProduct != null ? editProduct.image : ''}" placeholder="https://images.unsplash.com/...">
        </div>
        <div class="form-group">
          <label>Mô tả sản phẩm</label>
          <textarea name="description" rows="3" placeholder="Mô tả ngắn gọn về sản phẩm..."
            style="width:100%;padding:8px 12px;border:1px solid var(--border-color);border-radius:5px;font-size:14px;resize:vertical;">${editProduct != null ? editProduct.description : ''}</textarea>
        </div>
        <button type="submit" class="btn-primary" style="width: 100%; padding: 12px; font-size: 15px;">
          <i class="fa-solid fa-floppy-disk"></i> Lưu sản phẩm
        </button>
      </form>
    </div>
  </div>
</c:if>

<!-- Modal Chi tiết đơn hàng (Điều hướng bằng Java Servlet) -->
<c:if test="${not empty viewOrderObj}">
  <div class="modal" id="orderDetailModal" style="display: flex;">
    <div class="modal-content" style="width: 620px; max-width: 96%;">
      <div class="modal-header">
        <h3 style="font-size: 17px; color: var(--text-heading);">
          Chi tiết đơn hàng — <strong>${viewOrderObj.orderCode}</strong>
        </h3>
        <a href="admin?tab=orders" class="close-btn" style="text-decoration: none; font-size: 24px; color: #888;">&times;</a>
      </div>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:16px;padding:16px;background:#f8f9fa;border-radius:8px;">
        <div>
          <div style="font-size:12px;color:#888;margin-bottom:4px;">Khách hàng</div>
          <div style="font-weight:bold;">${viewOrderObj.name}</div>
          <div style="font-size:13px;color:var(--text-body);">${viewOrderObj.phone}</div>
        </div>
        <div>
          <div style="font-size:12px;color:#888;margin-bottom:4px;">Trạng thái</div>
          <span style="background:#f0f9ff;color:#0284c7;padding:4px 12px;border-radius:4px;font-weight:600;font-size:13px;">
            ${viewOrderObj.status}
          </span>
        </div>
        <div>
          <div style="font-size:12px;color:#888;margin-bottom:4px;">Địa chỉ giao hàng</div>
          <div style="font-size:13px;">${viewOrderObj.address}</div>
        </div>
        <div>
          <div style="font-size:12px;color:#888;margin-bottom:4px;">Thời gian đặt</div>
          <div style="font-size:13px;">${viewOrderObj.createdAt}</div>
        </div>
      </div>
      <table style="width:100%;border-collapse:collapse;margin-bottom:12px;">
        <thead style="background:#f1f3f6;">
          <tr>
            <th style="padding:10px 14px;text-align:left;font-size:13px;">Sản phẩm</th>
            <th style="padding:10px 14px;text-align:left;font-size:13px;">Đơn giá</th>
            <th style="padding:10px 14px;text-align:center;font-size:13px;">SL</th>
            <th style="padding:10px 14px;text-align:left;font-size:13px;">Thành tiền</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${empty viewOrderObj.items}">
              <tr><td colspan="4" style="text-align:center;padding:20px;color:#888;">Không có chi tiết sản phẩm.</td></tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="it" items="${viewOrderObj.items}">
                <tr>
                  <td style="padding:10px 14px;"><strong>${it.productName}</strong></td>
                  <td style="padding:10px 14px;color:var(--primary-color);font-weight:bold;">
                    <fmt:formatNumber value="${it.productPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                  </td>
                  <td style="padding:10px 14px;text-align:center;">${it.quantity}</td>
                  <td style="padding:10px 14px;font-weight:bold;">
                    <fmt:formatNumber value="${it.productPrice * it.quantity}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
      <div style="border-top:1px solid var(--border-color);padding-top:12px;">
        <div style="display:flex;justify-content:space-between;padding:6px 0;">
          <span>Tạm tính:</span>
          <span><fmt:formatNumber value="${viewOrderObj.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
        </div>
        <c:if test="${viewOrderObj.discount != null && viewOrderObj.discount > 0}">
          <div style="display:flex;justify-content:space-between;padding:6px 0;color:#16a34a;">
            <span>Giảm giá (${viewOrderObj.couponCode}):</span>
            <span>- <fmt:formatNumber value="${viewOrderObj.discount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
          </div>
        </c:if>
        <div style="display:flex;justify-content:space-between;padding:8px 0;font-size:17px;font-weight:bold;color:var(--primary-color);">
          <span>Tổng thanh toán:</span>
          <span><fmt:formatNumber value="${viewOrderObj.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
        </div>
        <div style="font-size:12px;color:#888;margin-top:4px;">
          Phương thức thanh toán: ${viewOrderObj.paymentMethod}
        </div>
      </div>
    </div>
  </div>
</c:if>

</body>
</html>
