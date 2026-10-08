<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:if test="${orders == null}">
  <c:redirect url="/admin"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>GreenMart - Bảng Điều Khiển Quản Trị</title>
  <link rel="stylesheet" href="css/style.css?v=20261008_admin_v4">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    :root {
      --primary-color: #3bb77e;
      --primary-dark: #2f9a68;
      --primary-light: #eaf8f1;
      --text-heading: #253d4e;
      --text-body: #7e7e7e;
      --border-color: #ececec;
    }
    * {
      box-sizing: border-box;
    }
    .admin-layout {
      display: grid;
      grid-template-columns: 240px 1fr;
      min-height: 100vh;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
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
      padding: 0;
      margin: 0;
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

    /* Original Dashboard stats */
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

    /* General Admin Table */
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

    /* ========================================================
       MODERN ORDER MANAGEMENT STYLES (TAB ORDERS)
       ======================================================== */
    .admin-orders-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
      flex-wrap: wrap;
      gap: 15px;
    }
    .admin-orders-title h2 {
      font-size: 24px;
      color: #1e293b;
      font-weight: 800;
      margin-bottom: 4px;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .admin-orders-title p {
      font-size: 13.5px;
      color: #64748b;
      margin: 0;
    }

    /* Orders Mini 4-Stat Cards */
    .orders-stats-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 16px;
      margin-bottom: 22px;
    }
    .orders-stat-card {
      background: #ffffff;
      border-radius: 12px;
      padding: 16px 20px;
      border: 1px solid #e2e8f0;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.03);
      display: flex;
      align-items: center;
      gap: 15px;
      transition: transform 0.2s, box-shadow 0.2s;
    }
    .orders-stat-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 14px rgba(0, 0, 0, 0.06);
    }
    .stat-card-icon {
      width: 48px;
      height: 48px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 20px;
      flex-shrink: 0;
    }
    .stat-card-icon.blue { background: #eff6ff; color: #2563eb; }
    .stat-card-icon.amber { background: #fffbeb; color: #d97706; }
    .stat-card-icon.sky { background: #f0f9ff; color: #0284c7; }
    .stat-card-icon.emerald { background: #ecfdf5; color: #059669; }
    .stat-card-info h5 {
      font-size: 12.5px;
      color: #64748b;
      font-weight: 600;
      margin: 0 0 4px 0;
    }
    .stat-card-info .stat-val {
      font-size: 20px;
      font-weight: 800;
      color: #0f172a;
      line-height: 1.2;
    }
    .stat-card-info .stat-sub {
      font-size: 11px;
      color: #94a3b8;
      margin-top: 2px;
    }

    /* Filter Chips Bar */
    .admin-order-filters {
      display: flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 18px;
      flex-wrap: wrap;
      background: #ffffff;
      padding: 10px 14px;
      border-radius: 12px;
      border: 1px solid #e2e8f0;
      box-shadow: 0 1px 4px rgba(0, 0, 0, 0.03);
    }
    .filter-tab-chip {
      padding: 7px 15px;
      border-radius: 20px;
      font-size: 13px;
      font-weight: 600;
      color: #475569;
      text-decoration: none !important;
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      display: inline-flex;
      align-items: center;
      gap: 7px;
      transition: all 0.2s ease;
      cursor: pointer;
    }
    .filter-tab-chip:hover {
      background: #f1f5f9;
      color: #0f172a;
      border-color: #cbd5e1;
    }
    .filter-tab-chip.active {
      background: #3bb77e !important;
      color: #ffffff !important;
      border-color: #3bb77e !important;
      box-shadow: 0 2px 8px rgba(59, 183, 126, 0.35);
    }
    .chip-counter {
      background: rgba(0, 0, 0, 0.08);
      font-size: 11px;
      font-weight: 700;
      padding: 1px 7px;
      border-radius: 10px;
      line-height: 16px;
    }
    .filter-tab-chip.active .chip-counter {
      background: rgba(255, 255, 255, 0.28);
      color: #ffffff;
    }

    /* Search & Action Bar */
    .admin-search-bar {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 20px;
      flex-wrap: wrap;
    }
    .admin-search-input-wrap {
      position: relative;
      flex: 1;
      max-width: 480px;
    }
    .admin-search-input-wrap i {
      position: absolute;
      left: 14px;
      top: 50%;
      transform: translateY(-50%);
      color: #94a3b8;
      font-size: 14px;
    }
    .admin-search-input-wrap input {
      width: 100%;
      padding: 10px 14px 10px 38px;
      border: 1px solid #cbd5e1;
      border-radius: 8px;
      font-size: 13.5px;
      outline: none;
      background: #ffffff;
      color: #1e293b;
      transition: border-color 0.2s, box-shadow 0.2s;
    }
    .admin-search-input-wrap input:focus {
      border-color: #3bb77e;
      box-shadow: 0 0 0 3px rgba(59, 183, 126, 0.15);
    }
    .btn-admin-search {
      padding: 10px 18px;
      background: #3bb77e;
      color: white;
      border: none;
      border-radius: 8px;
      font-weight: 600;
      font-size: 13.5px;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      transition: background 0.2s;
    }
    .btn-admin-search:hover {
      background: #2f9a68;
    }
    .btn-admin-reset {
      padding: 9px 14px;
      background: #f1f5f9;
      color: #475569;
      border: 1px solid #cbd5e1;
      border-radius: 8px;
      font-size: 13px;
      font-weight: 600;
      text-decoration: none !important;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      transition: all 0.2s;
    }
    .btn-admin-reset:hover {
      background: #e2e8f0;
      color: #0f172a;
    }

    /* Orders Table Box */
    .orders-table-wrapper {
      background: #ffffff;
      border-radius: 12px;
      border: 1px solid #e2e8f0;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.04);
      overflow: hidden;
    }
    .admin-orders-table {
      width: 100%;
      border-collapse: collapse;
      text-align: left;
    }
    .admin-orders-table thead th {
      background: #f8fafc;
      color: #475569;
      font-size: 12px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      padding: 14px 18px;
      border-bottom: 1px solid #e2e8f0;
      white-space: nowrap;
    }
    .admin-orders-table tbody td {
      padding: 16px 18px;
      border-bottom: 1px solid #f1f5f9;
      font-size: 13.5px;
      color: #334155;
      vertical-align: middle;
    }
    .admin-orders-table tbody tr:hover {
      background: #f8fafc;
    }
    .admin-orders-table tbody tr:last-child td {
      border-bottom: none;
    }

    /* Customer Cell */
    .customer-cell {
      display: flex;
      align-items: center;
      gap: 12px;
    }
    .customer-avatar-sm {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      background: linear-gradient(135deg, #3bb77e 0%, #059669 100%);
      color: white;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 800;
      font-size: 14px;
      flex-shrink: 0;
      box-shadow: 0 2px 6px rgba(59, 183, 126, 0.25);
    }
    .customer-name {
      font-weight: 700;
      color: #0f172a;
      font-size: 14px;
      margin-bottom: 2px;
    }
    .customer-phone {
      font-size: 12px;
      color: #475569;
      display: inline-flex;
      align-items: center;
      gap: 5px;
      text-decoration: none;
      transition: color 0.2s;
    }
    .customer-phone:hover {
      color: #2563eb;
    }
    .customer-addr {
      font-size: 11.5px;
      color: #94a3b8;
      max-width: 250px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      margin-top: 2px;
      display: flex;
      align-items: center;
      gap: 5px;
    }

    /* Payment tag */
    .payment-tag {
      display: inline-flex;
      align-items: center;
      gap: 5px;
      font-size: 11px;
      font-weight: 700;
      padding: 3px 8px;
      border-radius: 6px;
      margin-top: 5px;
    }
    .payment-tag.tag-cod {
      background: #f1f5f9;
      color: #475569;
      border: 1px solid #e2e8f0;
    }
    .payment-tag.tag-bank {
      background: #eff6ff;
      color: #1d4ed8;
      border: 1px solid #bfdbfe;
    }

    /* Status Pills */
    .status-pill {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 5px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 700;
      line-height: 1.2;
    }
    .status-pill.pill-waiting {
      background: #fffbeb;
      color: #b45309;
      border: 1px solid #fde68a;
    }
    .status-pill.pill-confirmed {
      background: #f5f3ff;
      color: #7c3aed;
      border: 1px solid #ddd6fe;
    }
    .status-pill.pill-shipping {
      background: #e0f2fe;
      color: #0369a1;
      border: 1px solid #bae6fd;
    }
    .status-pill.pill-completed {
      background: #ecfdf5;
      color: #15803d;
      border: 1px solid #bbf7d0;
    }
    .status-pill.pill-canceled {
      background: #fef2f2;
      color: #b91c1c;
      border: 1px solid #fecaca;
    }

    /* Status Quick Update Form */
    .status-quick-form {
      display: flex;
      align-items: center;
      gap: 6px;
      margin-top: 8px;
    }
    .status-select {
      padding: 5px 8px;
      border-radius: 6px;
      border: 1px solid #cbd5e1;
      font-size: 12px;
      background: #ffffff;
      color: #1e293b;
      cursor: pointer;
      outline: none;
      transition: border-color 0.2s;
    }
    .status-select:focus {
      border-color: #3bb77e;
    }
    .btn-save-status {
      padding: 5px 10px;
      font-size: 12px;
      font-weight: 700;
      border-radius: 6px;
      background: #3bb77e;
      color: white;
      border: none;
      cursor: pointer;
      transition: background 0.2s;
    }
    .btn-save-status:hover {
      background: #2f9a68;
    }

    /* Action Buttons in Table */
    .btn-table-action {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 6px 12px;
      border-radius: 6px;
      font-size: 12px;
      font-weight: 600;
      text-decoration: none !important;
      cursor: pointer;
      transition: all 0.2s;
    }
    .btn-view-order {
      background: #eff6ff;
      color: #1d4ed8;
      border: 1px solid #bfdbfe;
    }
    .btn-view-order:hover {
      background: #dbeafe;
      color: #1e40af;
    }
    .btn-chat-order {
      background: #f0fdf4;
      color: #15803d;
      border: 1px solid #bbf7d0;
    }
    .btn-chat-order:hover {
      background: #dcfce7;
      color: #166534;
    }
    .btn-del-order {
      background: #fef2f2;
      color: #ef4444;
      border: 1px solid #fecaca;
      padding: 6px 10px;
    }
    .btn-del-order:hover {
      background: #fee2e2;
      color: #dc2626;
    }

    /* Item count tag */
    .item-count-badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      background: #f1f5f9;
      color: #475569;
      padding: 4px 10px;
      border-radius: 12px;
      font-size: 12.5px;
      font-weight: 600;
    }

    /* Price cell */
    .price-val {
      color: #059669;
      font-weight: 800;
      font-size: 15.5px;
      letter-spacing: -0.2px;
    }
    .coupon-tag {
      font-size: 11px;
      color: #16a34a;
      background: #dcfce7;
      border: 1px solid #bbf7d0;
      padding: 2px 7px;
      border-radius: 4px;
      display: inline-flex;
      align-items: center;
      gap: 4px;
      margin-top: 3px;
      font-weight: 600;
    }

    /* Modal Invoice Styles */
    .modal {
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background: rgba(15, 23, 42, 0.65);
      backdrop-filter: blur(4px);
      display: none;
      align-items: center;
      justify-content: center;
      z-index: 10000;
    }
    .invoice-modal-content {
      background: white;
      border-radius: 16px;
      max-width: 740px;
      width: 96%;
      max-height: 90vh;
      overflow-y: auto;
      box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
      animation: modalFadeIn 0.25s ease-out;
    }
    @keyframes modalFadeIn {
      from { opacity: 0; transform: scale(0.96) translateY(-10px); }
      to { opacity: 1; transform: scale(1) translateY(0); }
    }
    .invoice-modal-header {
      padding: 18px 24px;
      background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
      color: white;
      display: flex;
      justify-content: space-between;
      align-items: center;
      position: sticky;
      top: 0;
      z-index: 2;
    }
    .invoice-modal-header h3 {
      font-size: 17px;
      font-weight: 700;
      display: flex;
      align-items: center;
      gap: 10px;
      margin: 0;
    }
    .invoice-modal-body {
      padding: 24px;
    }

    /* Stepper track */
    .mini-stepper-track {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 8px;
      margin-bottom: 24px;
      background: #f8fafc;
      padding: 16px;
      border-radius: 12px;
      border: 1px solid #e2e8f0;
    }
    .mini-step-item {
      text-align: center;
      position: relative;
    }
    .mini-step-icon {
      width: 32px;
      height: 32px;
      border-radius: 50%;
      background: #e2e8f0;
      color: #94a3b8;
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 6px;
      font-size: 13px;
      font-weight: 700;
    }
    .mini-step-item.done .mini-step-icon {
      background: #10b981;
      color: white;
    }
    .mini-step-item.active .mini-step-icon {
      background: #3b82f6;
      color: white;
      box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.2);
    }
    .mini-step-label {
      font-size: 12px;
      font-weight: 700;
      color: #64748b;
    }
    .mini-step-item.done .mini-step-label {
      color: #059669;
    }
    .mini-step-item.active .mini-step-label {
      color: #2563eb;
    }

    /* Invoice Info Grid */
    .invoice-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
      margin-bottom: 20px;
    }
    .invoice-info-card {
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      border-radius: 10px;
      padding: 14px 16px;
    }
    .invoice-info-card h4 {
      font-size: 13px;
      font-weight: 700;
      color: #0f172a;
      margin-bottom: 10px;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .invoice-info-row {
      font-size: 12.5px;
      color: #475569;
      margin-bottom: 6px;
      line-height: 1.4;
    }

    /* Summary Card */
    .invoice-summary-card {
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      border-radius: 10px;
      padding: 14px 18px;
    }
    .summary-line {
      display: flex;
      justify-content: space-between;
      font-size: 13px;
      color: #475569;
      margin-bottom: 6px;
    }
    .summary-total {
      display: flex;
      justify-content: space-between;
      font-size: 16px;
      font-weight: 800;
      color: #059669;
      border-top: 1px solid #cbd5e1;
      padding-top: 8px;
      margin-top: 8px;
    }
    .btn-chat-order-pill {
      background: #eff6ff;
      color: #1d4ed8;
      border: 1px solid #bfdbfe;
      border-radius: 6px;
      font-weight: 600;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      transition: all 0.2s;
    }
    .btn-chat-order-pill:hover {
      background: #dbeafe;
    }
    .btn-track-pill {
      background: #f1f5f9;
      color: #475569;
      border: 1px solid #cbd5e1;
      border-radius: 6px;
      font-weight: 600;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      transition: all 0.2s;
    }
    .btn-track-pill:hover {
      background: #e2e8f0;
    }

    /* =========================================================
       MODERN PRODUCTS MANAGEMENT STYLES
       ========================================================= */
    .admin-products-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 22px;
      flex-wrap: wrap;
      gap: 16px;
    }
    .admin-products-title h2 {
      font-size: 22px;
      font-weight: 800;
      color: #0f172a;
      margin: 0 0 5px 0;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .admin-products-title p {
      font-size: 13.5px;
      color: #64748b;
      margin: 0;
    }

    /* Products 4-Stat Cards */
    .products-stats-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 16px;
      margin-bottom: 22px;
    }
    .products-stat-card {
      background: #ffffff;
      border-radius: 12px;
      padding: 16px 20px;
      border: 1px solid #e2e8f0;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.03);
      display: flex;
      align-items: center;
      gap: 15px;
      transition: transform 0.2s, box-shadow 0.2s;
    }
    .products-stat-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 14px rgba(0, 0, 0, 0.06);
    }
    .p-stat-icon {
      width: 48px;
      height: 48px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 20px;
      flex-shrink: 0;
    }
    .p-stat-icon.emerald { background: #ecfdf5; color: #059669; }
    .p-stat-icon.blue { background: #eff6ff; color: #2563eb; }
    .p-stat-icon.amber { background: #fffbeb; color: #d97706; }
    .p-stat-icon.rose { background: #fff1f2; color: #e11d48; }

    .products-stat-card .p-stat-info h5 {
      font-size: 12.5px;
      color: #64748b;
      font-weight: 600;
      margin: 0 0 4px 0;
    }
    .products-stat-card .p-stat-info .stat-val {
      font-size: 21px;
      font-weight: 800;
      color: #0f172a;
      line-height: 1.2;
    }
    .products-stat-card .p-stat-info .stat-sub {
      font-size: 11px;
      color: #94a3b8;
      margin-top: 2px;
    }

    /* Toolbar: Filters & Actions */
    .admin-products-toolbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 18px;
      gap: 16px;
      flex-wrap: wrap;
    }
    .search-products-form {
      display: flex;
      align-items: center;
      background: #ffffff;
      border: 1px solid #cbd5e1;
      border-radius: 30px;
      padding: 4px 6px 4px 16px;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
      width: 380px;
      max-width: 100%;
      transition: all 0.2s;
    }
    .search-products-form:focus-within {
      border-color: #3bb77e;
      box-shadow: 0 0 0 3px rgba(59, 183, 126, 0.2);
    }
    .search-products-form input {
      border: none;
      outline: none;
      font-size: 13.5px;
      color: #0f172a;
      width: 100%;
      background: transparent;
    }
    .search-products-form button {
      background: #3bb77e;
      color: white;
      border: none;
      border-radius: 25px;
      padding: 8px 18px;
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      transition: background 0.2s;
    }
    .search-products-form button:hover {
      background: #2ea16d;
    }

    .btn-create-product {
      background: linear-gradient(135deg, #3bb77e 0%, #059669 100%);
      color: #ffffff !important;
      padding: 10px 22px;
      border-radius: 25px;
      font-size: 14px;
      font-weight: 700;
      text-decoration: none !important;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      box-shadow: 0 4px 12px rgba(59, 183, 126, 0.35);
      transition: all 0.2s;
      border: none;
      cursor: pointer;
    }
    .btn-create-product:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 18px rgba(59, 183, 126, 0.45);
    }

    /* Products Category & Stock Filter Chips */
    .admin-product-filters {
      display: flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 20px;
      flex-wrap: wrap;
      background: #ffffff;
      padding: 10px 14px;
      border-radius: 12px;
      border: 1px solid #e2e8f0;
      box-shadow: 0 1px 4px rgba(0, 0, 0, 0.03);
    }
    .prod-filter-chip {
      padding: 7px 15px;
      border-radius: 20px;
      font-size: 13px;
      font-weight: 600;
      color: #475569;
      text-decoration: none !important;
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      display: inline-flex;
      align-items: center;
      gap: 7px;
      transition: all 0.2s ease;
      cursor: pointer;
    }
    .prod-filter-chip:hover {
      background: #f1f5f9;
      color: #0f172a;
      border-color: #cbd5e1;
    }
    .prod-filter-chip.active {
      background: #3bb77e !important;
      color: #ffffff !important;
      border-color: #3bb77e !important;
      box-shadow: 0 2px 8px rgba(59, 183, 126, 0.35);
    }
    .prod-filter-chip .chip-counter {
      background: rgba(0, 0, 0, 0.06);
      padding: 2px 8px;
      border-radius: 12px;
      font-size: 11px;
      font-weight: 700;
    }
    .prod-filter-chip.active .chip-counter {
      background: rgba(255, 255, 255, 0.25);
      color: #ffffff;
    }

    /* Modern Products Table */
    .admin-products-table-wrap {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 14px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
      margin-bottom: 30px;
    }
    .admin-products-table {
      width: 100%;
      border-collapse: collapse;
      text-align: left;
    }
    .admin-products-table thead th {
      background: #f8fafc;
      color: #475569;
      font-size: 12px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      padding: 14px 18px;
      border-bottom: 2px solid #e2e8f0;
      white-space: nowrap;
    }
    .admin-products-table tbody tr {
      border-bottom: 1px solid #f1f5f9;
      transition: background 0.15s;
    }
    .admin-products-table tbody tr:hover {
      background: #f8fafc;
    }
    .admin-products-table td {
      padding: 14px 18px;
      font-size: 13.5px;
      color: #334155;
      vertical-align: middle;
    }

    /* Product Item Cell */
    .prod-cell {
      display: flex;
      align-items: center;
      gap: 14px;
    }
    .prod-thumb-box {
      width: 52px;
      height: 52px;
      border-radius: 10px;
      overflow: hidden;
      border: 1px solid #e2e8f0;
      background: #f8fafc;
      flex-shrink: 0;
      position: relative;
    }
    .prod-thumb-box img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.2s;
    }
    .prod-thumb-box:hover img {
      transform: scale(1.08);
    }
    .prod-info-name {
      font-weight: 700;
      color: #0f172a;
      font-size: 14px;
      line-height: 1.35;
      margin-bottom: 3px;
    }
    .prod-info-desc {
      font-size: 11.5px;
      color: #94a3b8;
      max-width: 280px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    /* Category Badges */
    .cat-badge {
      display: inline-flex;
      align-items: center;
      gap: 5px;
      padding: 4px 10px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
    }
    .cat-badge.rau-cu { background: #ecfdf5; color: #047857; border: 1px solid #a7f3d0; }
    .cat-badge.thit-ca { background: #fff7ed; color: #c2410c; border: 1px solid #fed7aa; }
    .cat-badge.do-uong { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
    .cat-badge.banh-keo { background: #faf5ff; color: #7e22ce; border: 1px solid #e9d5ff; }
    .cat-badge.thuc-pham-kho { background: #fefce8; color: #a16207; border: 1px solid #fef08a; }
    .cat-badge.default { background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; }

    /* Price formatting */
    .prod-price-text {
      color: #059669;
      font-weight: 800;
      font-size: 15px;
    }

    /* Inventory Progress */
    .stock-box {
      min-width: 120px;
    }
    .stock-number-wrap {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 5px;
      font-size: 12.5px;
      font-weight: 700;
    }
    .stock-progress-bar {
      height: 6px;
      background: #e2e8f0;
      border-radius: 4px;
      overflow: hidden;
      position: relative;
    }
    .stock-progress-fill {
      height: 100%;
      border-radius: 4px;
      transition: width 0.3s;
    }
    .stock-progress-fill.safe { background: #10b981; }
    .stock-progress-fill.warn { background: #f59e0b; }
    .stock-progress-fill.danger { background: #ef4444; }

    /* Actions buttons */
    .prod-action-group {
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .btn-prod-act {
      padding: 6px 12px;
      border-radius: 6px;
      font-size: 12.5px;
      font-weight: 600;
      text-decoration: none !important;
      display: inline-flex;
      align-items: center;
      gap: 5px;
      transition: all 0.15s ease;
      cursor: pointer;
      border: 1px solid transparent;
    }
    .btn-prod-edit {
      background: #eff6ff;
      color: #2563eb;
      border-color: #bfdbfe;
    }
    .btn-prod-edit:hover {
      background: #dbeafe;
      color: #1d4ed8;
    }
    .btn-prod-view {
      background: #f8fafc;
      color: #475569;
      border-color: #cbd5e1;
    }
    .btn-prod-view:hover {
      background: #f1f5f9;
      color: #0f172a;
    }
    .btn-prod-del {
      background: #fff1f2;
      color: #e11d48;
      border-color: #fecdd3;
    }
    .btn-prod-del:hover {
      background: #ffe4e6;
      color: #be123c;
    }

    /* Modern Product Create / Edit Modal */
    .product-modal-container {
      background: #ffffff;
      border-radius: 16px;
      max-width: 680px;
      width: 95%;
      overflow: hidden;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.18);
      animation: modalFadeIn 0.25s ease-out;
    }
    .product-modal-top {
      background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
      color: #ffffff;
      padding: 18px 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 2px solid #3bb77e;
    }
    .product-modal-top h3 {
      font-size: 17px;
      font-weight: 700;
      margin: 0;
      display: flex;
      align-items: center;
      gap: 10px;
      color: #ffffff;
    }
    .product-modal-body {
      padding: 24px;
      max-height: 80vh;
      overflow-y: auto;
    }
    .product-form-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
    }
    .form-full-width {
      grid-column: 1 / -1;
    }
    .product-input-label {
      display: block;
      font-size: 13px;
      font-weight: 700;
      color: #334155;
      margin-bottom: 6px;
    }
    .product-input-control {
      width: 100%;
      padding: 10px 14px;
      border: 1px solid #cbd5e1;
      border-radius: 8px;
      font-size: 13.5px;
      outline: none;
      transition: all 0.2s;
      background: #f8fafc;
      box-sizing: border-box;
    }
    .product-input-control:focus {
      border-color: #3bb77e;
      background: #ffffff;
      box-shadow: 0 0 0 3px rgba(59, 183, 126, 0.18);
    }
    .img-preview-box {
      width: 100%;
      height: 140px;
      border: 2px dashed #cbd5e1;
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      overflow: hidden;
      background: #f8fafc;
      margin-top: 6px;
    }
    .img-preview-box img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
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
      <li>
        <a href="chat">
          <i class="fa-solid fa-comments"></i> Tin nhắn & Chat KH
        </a>
      </li>
      <li style="margin-top:25px;border-top:1px solid rgba(255,255,255,0.1);padding-top:15px;">
        <a href="profile"><i class="fa-solid fa-circle-user"></i> Thông tin User</a>
      </li>
      <li>
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
            <h4>Doanh thu thực tế (Hoàn tất)</h4>
            <div class="val">
              <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
            </div>
            <div style="font-size: 12px; color: #16a34a; margin-top: 5px; font-weight: 500;">
              <i class="fa-solid fa-circle-check"></i> ${completedOrdersCount} đơn hoàn thành
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

    <!-- Tab 2: Quản lý sản phẩm (Modern Redesigned UI) -->
    <c:if test="${currentTab == 'products'}">
      <div>
        <!-- Products Header -->
        <div class="admin-products-header">
          <div class="admin-products-title">
            <h2><i class="fa-solid fa-boxes-stacked" style="color:var(--primary-color);"></i> Quản Lý Kho Hàng & Sản Phẩm</h2>
            <p>Kiểm soát danh mục hàng hóa, số lượng tồn kho thời gian thực và điều chỉnh giá bán toàn sàn GreenMart.</p>
          </div>
          <div>
            <span style="font-size:13px; color:#64748b; background:white; padding:8px 14px; border-radius:8px; border:1px solid #e2e8f0; display:inline-flex; align-items:center; gap:8px;">
              <span>Tổng kho: <strong style="color:#0f172a;">${totalStockUnits}</strong> đơn vị</span>
              <span style="color:#cbd5e1;">|</span>
              <span>Mặt hàng: <strong style="color:var(--primary-color);">${totalProducts}</strong> loại</span>
            </span>
          </div>
        </div>

        <!-- 4 Quick Stat Cards for Products -->
        <div class="products-stats-grid">
          <div class="products-stat-card">
            <div class="p-stat-icon blue">
              <i class="fa-solid fa-boxes-stacked"></i>
            </div>
            <div class="p-stat-info">
              <h5>Tổng sản phẩm</h5>
              <div class="stat-val">${totalProducts}</div>
              <div class="stat-sub">${categoriesCount} danh mục phân loại</div>
            </div>
          </div>
          <div class="products-stat-card">
            <div class="p-stat-icon emerald">
              <i class="fa-solid fa-circle-check"></i>
            </div>
            <div class="p-stat-info">
              <h5>Còn hàng dồi dào</h5>
              <div class="stat-val" style="color:#059669;">${inStockCount}</div>
              <div class="stat-sub">Tồn kho an toàn (&gt;15 đơn vị)</div>
            </div>
          </div>
          <div class="products-stat-card">
            <div class="p-stat-icon amber">
              <i class="fa-solid fa-triangle-exclamation"></i>
            </div>
            <div class="p-stat-info">
              <h5>Cảnh báo sắp hết</h5>
              <div class="stat-val" style="color:#d97706;">${lowStockCount}</div>
              <div class="stat-sub">Cần nhập thêm (&le;15 đơn vị)</div>
            </div>
          </div>
          <div class="products-stat-card">
            <div class="p-stat-icon rose">
              <i class="fa-solid fa-circle-xmark"></i>
            </div>
            <div class="p-stat-info">
              <h5>Đã hết hàng tồn</h5>
              <div class="stat-val" style="color:#e11d48;">${outOfStockCount}</div>
              <div class="stat-sub">Tạm ngừng hiển thị giỏ hàng</div>
            </div>
          </div>
        </div>

        <!-- Toolbar: Search bar & Add Button -->
        <div class="admin-products-toolbar">
          <form action="admin" method="GET" class="search-products-form">
            <input type="hidden" name="tab" value="products">
            <c:if test="${not empty categoryFilter}">
              <input type="hidden" name="categoryFilter" value="${categoryFilter}">
            </c:if>
            <c:if test="${not empty stockFilter}">
              <input type="hidden" name="stockFilter" value="${stockFilter}">
            </c:if>
            <i class="fa-solid fa-magnifying-glass" style="color:#94a3b8; font-size:14px; margin-right:8px;"></i>
            <input type="text" name="search" value="${search}" placeholder="Tìm theo tên sản phẩm, mã ID hoặc danh mục...">
            <button type="submit">
              Tìm kiếm
            </button>
            <c:if test="${not empty search}">
              <a href="admin?tab=products<c:if test="${not empty categoryFilter}">&categoryFilter=${categoryFilter}</c:if><c:if test="${not empty stockFilter}">&stockFilter=${stockFilter}</c:if>"
                style="margin-left:8px; font-size:12px; color:#ef4444; text-decoration:none;" title="Xóa tìm kiếm">
                <i class="fa-solid fa-xmark"></i>
              </a>
            </c:if>
          </form>

          <a href="admin?tab=products&action=new" class="btn-create-product">
            <i class="fa-solid fa-plus"></i> Thêm Sản Phẩm Mới
          </a>
        </div>

        <!-- Filter Chips Bar: Stock & Categories -->
        <div class="admin-product-filters">
          <span style="font-size:12px; font-weight:700; color:#64748b; text-transform:uppercase; letter-spacing:0.5px; margin-right:4px;">
            <i class="fa-solid fa-filter" style="color:var(--primary-color);"></i> Lọc:
          </span>

          <a href="admin?tab=products<c:if test="${not empty search}">&search=${search}</c:if>"
             class="prod-filter-chip ${(empty stockFilter and empty categoryFilter) ? 'active' : ''}"
             data-filter-type="all" data-filter-val="all">
            Tất cả sản phẩm
            <span class="chip-counter">${totalProducts != null ? totalProducts : 0}</span>
          </a>

          <a href="admin?tab=products&stockFilter=available<c:if test="${not empty search}">&search=${search}</c:if>"
             class="prod-filter-chip ${stockFilter == 'available' ? 'active' : ''}"
             data-filter-type="stock" data-filter-val="available">
            <i class="fa-solid fa-circle-check" style="color:#10b981; font-size:11px;"></i> Còn hàng
            <span class="chip-counter">${inStockCount != null ? inStockCount : 0}</span>
          </a>

          <a href="admin?tab=products&stockFilter=low<c:if test="${not empty search}">&search=${search}</c:if>"
             class="prod-filter-chip ${stockFilter == 'low' ? 'active' : ''}"
             data-filter-type="stock" data-filter-val="low">
            <i class="fa-solid fa-triangle-exclamation" style="color:#f59e0b; font-size:11px;"></i> Sắp hết
            <span class="chip-counter">${lowStockCount != null ? lowStockCount : 0}</span>
          </a>

          <a href="admin?tab=products&stockFilter=out<c:if test="${not empty search}">&search=${search}</c:if>"
             class="prod-filter-chip ${stockFilter == 'out' ? 'active' : ''}"
             data-filter-type="stock" data-filter-val="out">
            <i class="fa-solid fa-circle-xmark" style="color:#ef4444; font-size:11px;"></i> Hết hàng
            <span class="chip-counter">${outOfStockCount != null ? outOfStockCount : 0}</span>
          </a>

          <div style="height:20px; width:1px; background:#e2e8f0; margin:0 4px;"></div>

          <a href="admin?tab=products&categoryFilter=rau-cu<c:if test="${not empty search}">&search=${search}</c:if>"
             class="prod-filter-chip ${categoryFilter == 'rau-cu' or fn:contains(categoryFilter, 'Rau') ? 'active' : ''}"
             data-filter-type="category" data-filter-val="rau-cu">
            🌱 Rau củ & Trái cây
            <span class="chip-counter">${rauCuCount != null ? rauCuCount : 0}</span>
          </a>

          <a href="admin?tab=products&categoryFilter=thit-ca<c:if test="${not empty search}">&search=${search}</c:if>"
             class="prod-filter-chip ${categoryFilter == 'thit-ca' or fn:contains(categoryFilter, 'Thịt') ? 'active' : ''}"
             data-filter-type="category" data-filter-val="thit-ca">
            🥩 Thịt, Cá & Trứng
            <span class="chip-counter">${thitCaCount != null ? thitCaCount : 0}</span>
          </a>

          <a href="admin?tab=products&categoryFilter=do-uong<c:if test="${not empty search}">&search=${search}</c:if>"
             class="prod-filter-chip ${categoryFilter == 'do-uong' or fn:contains(categoryFilter, 'uống') or fn:contains(categoryFilter, 'Sữa') ? 'active' : ''}"
             data-filter-type="category" data-filter-val="do-uong">
            🥛 Đồ uống & Sữa
            <span class="chip-counter">${doUongCount != null ? doUongCount : 0}</span>
          </a>

          <a href="admin?tab=products&categoryFilter=banh-keo<c:if test="${not empty search}">&search=${search}</c:if>"
             class="prod-filter-chip ${categoryFilter == 'banh-keo' or fn:contains(categoryFilter, 'Bánh') ? 'active' : ''}"
             data-filter-type="category" data-filter-val="banh-keo">
            🍪 Bánh kẹo & Ăn vặt
            <span class="chip-counter">${banhKeoCount != null ? banhKeoCount : 0}</span>
          </a>

          <a href="admin?tab=products&categoryFilter=thuc-pham-kho<c:if test="${not empty search}">&search=${search}</c:if>"
             class="prod-filter-chip ${categoryFilter == 'thuc-pham-kho' or fn:contains(categoryFilter, 'khô') ? 'active' : ''}"
             data-filter-type="category" data-filter-val="thuc-pham-kho">
            🌾 Thực phẩm khô
            <span class="chip-counter">${thucPhamKhoCount != null ? thucPhamKhoCount : 0}</span>
          </a>
        </div>

        <!-- Products Table -->
        <div class="admin-products-table-wrap">
          <table class="admin-products-table">
            <thead>
              <tr>
                <th style="width: 70px;">Mã SP</th>
                <th>Sản phẩm & Thông tin</th>
                <th>Danh mục</th>
                <th>Giá niêm yết</th>
                <th style="width: 160px;">Tồn kho</th>
                <th>Trạng thái</th>
                <th style="text-align: right; width: 170px;">Thao tác</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${empty products}">
                  <tr>
                    <td colspan="7" style="text-align:center; padding:45px 20px; color:#64748b;">
                      <div style="font-size:36px; margin-bottom:10px; color:#cbd5e1;">
                        <i class="fa-solid fa-box-open"></i>
                      </div>
                      <div style="font-weight:700; font-size:15px; color:#334155; margin-bottom:4px;">Không tìm thấy sản phẩm phù hợp</div>
                      <div style="font-size:13px; color:#94a3b8;">Vui lòng thử từ khóa tìm kiếm hoặc bỏ chọn các bộ lọc phân loại.</div>
                      <c:if test="${not empty search or not empty categoryFilter or not empty stockFilter}">
                        <a href="admin?tab=products" style="display:inline-block; margin-top:14px; padding:6px 16px; background:#f1f5f9; color:#475569; border-radius:6px; font-weight:600; font-size:12.5px; text-decoration:none;">
                          <i class="fa-solid fa-rotate-left"></i> Đặt lại bộ lọc
                        </a>
                      </c:if>
                    </td>
                  </tr>
                </c:when>
                <c:otherwise>
                  <!-- Client-side empty message placeholder -->
                  <tr id="productsEmptyRow" style="display:none;">
                    <td colspan="7" style="text-align:center; padding:45px 20px; color:#64748b;">
                      <div style="font-size:36px; margin-bottom:10px; color:#cbd5e1;">
                        <i class="fa-solid fa-box-open"></i>
                      </div>
                      <div style="font-weight:700; font-size:15px; color:#334155; margin-bottom:4px;">Không có sản phẩm nào thuộc bộ lọc này</div>
                      <div style="font-size:13px; color:#94a3b8;">Vui lòng chọn bộ lọc khác hoặc nhấn Tất cả sản phẩm.</div>
                    </td>
                  </tr>

                  <c:forEach var="p" items="${products}">
                    <tr class="product-item-row"
                        data-cat-slug="${fn:contains(p.category, 'Rau') or fn:contains(p.category, 'Trái') ? 'rau-cu' : (fn:contains(p.category, 'Thịt') or fn:contains(p.category, 'Cá') ? 'thit-ca' : (fn:contains(p.category, 'uống') or fn:contains(p.category, 'Sữa') ? 'do-uong' : (fn:contains(p.category, 'Bánh') ? 'banh-keo' : (fn:contains(p.category, 'khô') ? 'thuc-pham-kho' : 'other'))))}"
                        data-stock-status="${p.count != null and p.count > 15 ? 'available' : (p.count != null and p.count > 0 ? 'low' : 'out')}"
                        data-name="${fn:toLowerCase(p.name)}"
                        data-id="${p.id}">
                      <!-- ID -->
                      <td>
                        <span style="font-size:12px; font-weight:700; color:#64748b; background:#f1f5f9; padding:3px 8px; border-radius:6px;">
                          #${p.id}
                        </span>
                      </td>

                      <!-- Product Image & Name -->
                      <td>
                        <div class="prod-cell">
                          <div class="prod-thumb-box">
                            <img src="${p.image}" alt="${p.name}" onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1542838132-92c53300491e?w=200';">
                          </div>
                          <div>
                            <div class="prod-info-name">${p.name}</div>
                            <div class="prod-info-desc">
                              ${not empty p.description ? p.description : 'Sản phẩm tiêu chuẩn chất lượng GreenMart PTIT'}
                            </div>
                          </div>
                        </div>
                      </td>

                      <!-- Category -->
                      <td>
                        <c:choose>
                          <c:when test="${fn:contains(p.category, 'Rau') or fn:contains(p.category, 'Trái')}">
                            <span class="cat-badge rau-cu"><i class="fa-solid fa-carrot"></i> ${p.category}</span>
                          </c:when>
                          <c:when test="${fn:contains(p.category, 'Thịt') or fn:contains(p.category, 'Cá')}">
                            <span class="cat-badge thit-ca"><i class="fa-solid fa-drumstick-bite"></i> ${p.category}</span>
                          </c:when>
                          <c:when test="${fn:contains(p.category, 'uống') or fn:contains(p.category, 'Sữa')}">
                            <span class="cat-badge do-uong"><i class="fa-solid fa-bottle-water"></i> ${p.category}</span>
                          </c:when>
                          <c:when test="${fn:contains(p.category, 'Bánh')}">
                            <span class="cat-badge banh-keo"><i class="fa-solid fa-cookie-bite"></i> ${p.category}</span>
                          </c:when>
                          <c:when test="${fn:contains(p.category, 'khô')}">
                            <span class="cat-badge thuc-pham-kho"><i class="fa-solid fa-wheat-awn"></i> ${p.category}</span>
                          </c:when>
                          <c:otherwise>
                            <span class="cat-badge default"><i class="fa-solid fa-tag"></i> ${p.category}</span>
                          </c:otherwise>
                        </c:choose>
                      </td>

                      <!-- Price -->
                      <td>
                        <span class="prod-price-text">
                          <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </span>
                      </td>

                      <!-- Stock & Progress -->
                      <td>
                        <div class="stock-box">
                          <div class="stock-number-wrap">
                            <span style="color:#0f172a;">${p.count != null ? p.count : 0} <span style="font-size:11px; font-weight:500; color:#64748b;">món</span></span>
                            <span style="font-size:11px; color:#94a3b8;">
                              <c:choose>
                                <c:when test="${p.count == null || p.count <= 0}">0%</c:when>
                                <c:when test="${p.count >= 100}">100%</c:when>
                                <c:otherwise>${p.count}%</c:otherwise>
                              </c:choose>
                            </span>
                          </div>
                          <div class="stock-progress-bar">
                            <c:set var="stockPct" value="${p.count != null ? (p.count > 100 ? 100 : p.count) : 0}"/>
                            <div class="stock-progress-fill ${p.count > 15 ? 'safe' : (p.count > 0 ? 'warn' : 'danger')}"
                                 style="width: ${stockPct}%;"></div>
                          </div>
                        </div>
                      </td>

                      <!-- Status Pill -->
                      <td>
                        <c:choose>
                          <c:when test="${p.count != null and p.count > 15}">
                            <span class="status-pill completed">
                              <span class="status-dot"></span> Đang bán
                            </span>
                          </c:when>
                          <c:when test="${p.count != null and p.count > 0}">
                            <span class="status-pill shipping">
                              <span class="status-dot"></span> Sắp hết
                            </span>
                          </c:when>
                          <c:otherwise>
                            <span class="status-pill canceled">
                              <span class="status-dot"></span> Hết hàng
                            </span>
                          </c:otherwise>
                        </c:choose>
                      </td>

                      <!-- Action Buttons -->
                      <td style="text-align: right;">
                        <div class="prod-action-group" style="justify-content: flex-end;">
                          <a href="admin?tab=products&action=edit&id=${p.id}" class="btn-prod-act btn-prod-edit" title="Chỉnh sửa sản phẩm">
                            <i class="fa-solid fa-pen-to-square"></i> Sửa
                          </a>
                          <a href="home?keyword=${p.name}" target="_blank" class="btn-prod-act btn-prod-view" title="Xem trên trang chủ khách hàng">
                            <i class="fa-solid fa-arrow-up-right-from-square"></i>
                          </a>
                          <a href="admin?action=deleteProduct&id=${p.id}" class="btn-prod-act btn-prod-del"
                             onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm \'${p.name}\' (ID #${p.id}) khỏi danh mục không?');"
                             title="Xóa sản phẩm">
                            <i class="fa-solid fa-trash-can"></i>
                          </a>
                        </div>
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

    <!-- Tab 3: Quản lý đơn hàng (Redesigned Modern UI) -->
    <c:if test="${currentTab == 'orders'}">
      <div>
        <!-- Header -->
        <div class="admin-orders-header">
          <div class="admin-orders-title">
            <h2><i class="fa-solid fa-boxes-packing" style="color:var(--primary-color);"></i> Quản Lý Đơn Hàng & Vận Chuyển</h2>
            <p>Theo dõi tiến độ xử lý đơn hàng, điều phối giao nhận và đối soát doanh thu toàn hệ thống.</p>
          </div>
          <div>
            <span style="font-size:13px; color:#64748b; background:white; padding:8px 14px; border-radius:8px; border:1px solid #e2e8f0;">
              Tổng: <strong>${totalOrders}</strong> đơn | Doanh thu hoàn tất: 
              <strong style="color:#059669; font-size:14px;">
                <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
              </strong>
            </span>
          </div>
        </div>

        <!-- 4 Quick Stat Cards for Orders -->
        <div class="orders-stats-grid">
          <div class="orders-stat-card">
            <div class="stat-card-icon blue">
              <i class="fa-solid fa-boxes-stacked"></i>
            </div>
            <div class="stat-card-info">
              <h5>Tổng số đơn hàng</h5>
              <div class="stat-val">${totalOrders}</div>
              <div class="stat-sub">Toàn bộ đơn hệ thống</div>
            </div>
          </div>
          <div class="orders-stat-card">
            <div class="stat-card-icon amber">
              <i class="fa-solid fa-hourglass-half"></i>
            </div>
            <div class="stat-card-info">
              <h5>Chờ duyệt xử lý</h5>
              <div class="stat-val" style="color:#d97706;">${waitingOrdersCount}</div>
              <div class="stat-sub">Cần admin xác nhận</div>
            </div>
          </div>
          <div class="orders-stat-card">
            <div class="stat-card-icon sky">
              <i class="fa-solid fa-truck-fast"></i>
            </div>
            <div class="stat-card-info">
              <h5>Đang vận chuyển</h5>
              <div class="stat-val" style="color:#0284c7;">${shippingOrdersCount}</div>
              <div class="stat-sub">Đang trên đường giao</div>
            </div>
          </div>
          <div class="orders-stat-card">
            <div class="stat-card-icon emerald">
              <i class="fa-solid fa-circle-check"></i>
            </div>
            <div class="stat-card-info">
              <h5>Doanh thu hoàn tất</h5>
              <div class="stat-val" style="color:#059669; font-size:17px;">
                <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
              </div>
              <div class="stat-sub">${completedOrdersCount} đơn hoàn thành</div>
            </div>
          </div>
        </div>

        <!-- Status Filter Tabs / Chips Bar -->
        <div class="admin-order-filters">
          <a href="admin?tab=orders" class="filter-tab-chip ${empty statusFilter || statusFilter == 'all' ? 'active' : ''}">
            <i class="fa-solid fa-list-check"></i> Tất cả <span class="chip-counter">${totalOrders}</span>
          </a>
          <a href="admin?tab=orders&statusFilter=Waiting" class="filter-tab-chip ${statusFilter == 'Waiting' ? 'active' : ''}">
            <i class="fa-solid fa-hourglass-half" style="color:#d97706;"></i> Chờ duyệt 
            <span class="chip-counter">${waitingOrdersCount}</span>
          </a>
          <a href="admin?tab=orders&statusFilter=Confirmed" class="filter-tab-chip ${statusFilter == 'Confirmed' ? 'active' : ''}">
            <i class="fa-solid fa-clipboard-check" style="color:#7c3aed;"></i> Đã xác nhận 
            <span class="chip-counter">${confirmedOrdersCount}</span>
          </a>
          <a href="admin?tab=orders&statusFilter=Shipping" class="filter-tab-chip ${statusFilter == 'Shipping' ? 'active' : ''}">
            <i class="fa-solid fa-truck-fast" style="color:#0284c7;"></i> Đang giao 
            <span class="chip-counter">${shippingOrdersCount}</span>
          </a>
          <a href="admin?tab=orders&statusFilter=Completed" class="filter-tab-chip ${statusFilter == 'Completed' ? 'active' : ''}">
            <i class="fa-solid fa-circle-check" style="color:#16a34a;"></i> Hoàn tất 
            <span class="chip-counter">${completedOrdersCount}</span>
          </a>
          <a href="admin?tab=orders&statusFilter=Canceled" class="filter-tab-chip ${statusFilter == 'Canceled' ? 'active' : ''}">
            <i class="fa-solid fa-ban" style="color:#dc2626;"></i> Đã hủy 
            <span class="chip-counter">${canceledOrdersCount}</span>
          </a>
        </div>

        <!-- Search input bar & Action Toolbar -->
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:18px; flex-wrap:wrap; gap:12px;">
          <form action="admin" method="GET" class="admin-search-bar" style="margin-bottom:0;">
            <input type="hidden" name="tab" value="orders">
            <c:if test="${not empty statusFilter}">
              <input type="hidden" name="statusFilter" value="${statusFilter}">
            </c:if>
            <div class="admin-search-input-wrap">
              <i class="fa-solid fa-magnifying-glass"></i>
              <input type="text" name="search" value="${search}" placeholder="Tìm theo mã đơn (#GM...), tên khách hoặc SĐT...">
            </div>
            <button type="submit" class="btn-admin-search">
              <i class="fa-solid fa-filter"></i> Lọc
            </button>
            <c:if test="${not empty search || not empty statusFilter}">
              <a href="admin?tab=orders" class="btn-admin-reset" title="Đặt lại bộ lọc">
                <i class="fa-solid fa-rotate-left"></i> Đặt lại
              </a>
            </c:if>
          </form>

          <div>
            <a href="admin?tab=orders" class="btn-admin-reset" style="background:#ffffff;" title="Tải lại danh sách">
              <i class="fa-solid fa-arrows-rotate"></i> Làm mới
            </a>
          </div>
        </div>

        <!-- Orders Table Wrapper -->
        <div class="orders-table-wrapper">
          <table class="admin-orders-table">
            <thead>
              <tr>
                <th style="width:140px;">Mã đơn hàng</th>
                <th>Khách hàng</th>
                <th style="width:110px;">Sản phẩm</th>
                <th style="width:130px;">Tổng tiền</th>
                <th style="width:230px;">Trạng thái</th>
                <th style="width:190px; text-align:center;">Thao tác</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${empty orders}">
                  <tr>
                    <td colspan="6" style="text-align:center; padding:60px 20px; color:#94a3b8;">
                      <i class="fa-regular fa-folder-open" style="font-size:42px; color:#cbd5e1; margin-bottom:14px; display:block;"></i>
                      <div style="font-size:15px; font-weight:600; color:#475569;">Không tìm thấy đơn hàng nào phù hợp</div>
                      <div style="font-size:13px; color:#94a3b8; margin-top:4px;">Thử đổi từ khóa tìm kiếm hoặc bấm Đặt lại để xem tất cả đơn hàng.</div>
                    </td>
                  </tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="o" items="${orders}">
                    <tr>
                      <!-- Mã đơn & Ngày giờ -->
                      <td>
                        <strong style="color:#0f172a; font-size:14px; font-family:monospace; font-weight:700;">#${o.orderCode}</strong>
                        <div style="font-size:11.5px; color:#64748b; margin-top:4px; display:flex; align-items:center; gap:4px;">
                          <i class="fa-regular fa-clock" style="font-size:11px;"></i>
                          <c:choose>
                            <c:when test="${not empty o.createdAt and fn:length(o.createdAt) >= 16}">
                              ${fn:substring(o.createdAt, 0, 16)}
                            </c:when>
                            <c:otherwise>
                              ${not empty o.createdAt ? o.createdAt : ''}
                            </c:otherwise>
                          </c:choose>
                        </div>
                        <div>
                          <c:choose>
                            <c:when test="${o.paymentMethod == 'BANK'}">
                              <span class="payment-tag tag-bank"><i class="fa-solid fa-qrcode"></i> VietQR</span>
                            </c:when>
                            <c:otherwise>
                              <span class="payment-tag tag-cod"><i class="fa-solid fa-money-bill-wave"></i> COD</span>
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </td>

                      <!-- Khách hàng -->
                      <td>
                        <div class="customer-cell">
                          <div class="customer-avatar-sm">
                            ${not empty o.name ? fn:toUpperCase(fn:substring(o.name, 0, 1)) : 'U'}
                          </div>
                          <div>
                            <div class="customer-name">${o.name}</div>
                            <div style="margin-top:2px;">
                              <a href="tel:${o.phone}" class="customer-phone" title="Gọi khách hàng">
                                <i class="fa-solid fa-phone" style="font-size:10.5px;"></i> ${o.phone}
                              </a>
                            </div>
                            <div class="customer-addr" title="${o.address}">
                              <i class="fa-solid fa-location-dot" style="font-size:10px;"></i> ${o.address}
                            </div>
                          </div>
                        </div>
                      </td>

                      <!-- Số món -->
                      <td>
                        <span class="item-count-badge">
                          <i class="fa-solid fa-box"></i> ${not empty o.items ? fn:length(o.items) : 1} món
                        </span>
                      </td>

                      <!-- Tổng tiền -->
                      <td>
                        <div class="price-val">
                          <fmt:formatNumber value="${o.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </div>
                        <c:if test="${not empty o.couponCode}">
                          <div class="coupon-tag">
                            <i class="fa-solid fa-ticket"></i> ${o.couponCode}
                          </div>
                        </c:if>
                      </td>

                      <!-- Trạng thái & Quick Update Form -->
                      <td>
                        <div style="margin-bottom:6px;">
                          <c:choose>
                            <c:when test="${o.status == 'Completed' || o.status == 'Delivered'}">
                              <span class="status-pill pill-completed"><i class="fa-solid fa-circle-check"></i> Hoàn tất</span>
                            </c:when>
                            <c:when test="${o.status == 'Shipping'}">
                              <span class="status-pill pill-shipping"><i class="fa-solid fa-truck-fast"></i> Đang giao</span>
                            </c:when>
                            <c:when test="${o.status == 'Confirmed'}">
                              <span class="status-pill pill-confirmed"><i class="fa-solid fa-boxes-packing"></i> Đã xác nhận</span>
                            </c:when>
                            <c:when test="${o.status == 'Canceled' || o.status == 'Cancelled'}">
                              <span class="status-pill pill-canceled"><i class="fa-solid fa-ban"></i> Đã hủy</span>
                            </c:when>
                            <c:otherwise>
                              <span class="status-pill pill-waiting"><i class="fa-solid fa-hourglass-half"></i> Chờ duyệt</span>
                            </c:otherwise>
                          </c:choose>
                        </div>
                        <form action="admin" method="POST" class="status-quick-form">
                          <input type="hidden" name="action" value="updateOrderStatus">
                          <input type="hidden" name="id" value="${o.id}">
                          <c:if test="${not empty statusFilter}">
                            <input type="hidden" name="redirect" value="admin?tab=orders&statusFilter=${statusFilter}">
                          </c:if>
                          <select name="status" class="status-select">
                            <option value="Waiting" ${o.status == 'Waiting' ? 'selected' : ''}>Chờ duyệt</option>
                            <option value="Confirmed" ${o.status == 'Confirmed' ? 'selected' : ''}>Xác nhận</option>
                            <option value="Shipping" ${o.status == 'Shipping' ? 'selected' : ''}>Đang giao</option>
                            <option value="Completed" ${o.status == 'Completed' ? 'selected' : ''}>Hoàn tất</option>
                            <option value="Canceled" ${o.status == 'Canceled' ? 'selected' : ''}>Hủy đơn</option>
                          </select>
                          <button type="submit" class="btn-save-status" title="Cập nhật trạng thái">
                            Lưu
                          </button>
                        </form>
                      </td>

                      <!-- Thao tác -->
                      <td style="white-space:nowrap; text-align:center;">
                        <div style="display:flex; align-items:center; justify-content:center; gap:6px;">
                          <a href="admin?tab=orders&viewOrder=${o.id}" class="btn-table-action btn-view-order" title="Xem chi tiết hóa đơn">
                            <i class="fa-solid fa-eye"></i> Chi tiết
                          </a>
                          <c:if test="${not empty o.userId}">
                            <a href="chat?with=${o.userId}&orderCode=${o.orderCode}" class="btn-table-action btn-chat-order" title="Nhắn tin với khách hàng">
                              <i class="fa-solid fa-comments"></i> Chat
                            </a>
                          </c:if>
                          <a href="admin?action=deleteOrder&id=${o.id}" class="btn-table-action btn-del-order" onclick="return confirm('Bạn có chắc chắn muốn xóa đơn hàng #${o.orderCode}?');" title="Xóa đơn hàng">
                            <i class="fa-solid fa-trash-can"></i>
                          </a>
                        </div>
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

<!-- Modal Thêm / Sửa Sản Phẩm (Modern Enterprise Modal with Live Preview) -->
<c:if test="${param.action == 'new' || param.action == 'edit' || not empty editProduct}">
  <div class="modal" id="productModal" style="display: flex;">
    <div class="product-modal-container">
      <div class="product-modal-top">
        <h3>
          <i class="fa-solid fa-boxes-stacked" style="color:var(--primary-color);"></i>
          <c:choose>
            <c:when test="${not empty editProduct}">Chỉnh Sửa Thông Tin Sản Phẩm — <strong>#${editProduct.id}</strong></c:when>
            <c:otherwise>Thêm Mới Sản Phẩm Vào Kho GreenMart</c:otherwise>
          </c:choose>
        </h3>
        <a href="admin?tab=products" class="close-btn" style="text-decoration: none; font-size: 24px; color: #ffffff; opacity:0.8; transition:opacity 0.2s;" title="Đóng">&times;</a>
      </div>

      <form action="admin" method="POST" class="product-modal-body">
        <input type="hidden" name="action" value="saveProduct">
        <input type="hidden" name="id" value="${editProduct != null ? editProduct.id : ''}">

        <div class="product-form-grid">
          <!-- Tên sản phẩm -->
          <div class="form-full-width">
            <label class="product-input-label">Tên sản phẩm <span style="color:#ef4444;">*</span></label>
            <input type="text" name="name" class="product-input-control" value="${editProduct != null ? editProduct.name : ''}"
                   required placeholder="Ví dụ: Táo Envy New Zealand Hộp 1kg">
          </div>

          <!-- Danh mục -->
          <div>
            <label class="product-input-label">Danh mục sản phẩm <span style="color:#ef4444;">*</span></label>
            <select name="category" class="product-input-control" style="cursor:pointer;">
              <option value="Rau củ & Trái cây" ${editProduct.category == 'Rau củ & Trái cây' ? 'selected' : ''}>🌱 Rau củ & Trái cây</option>
              <option value="Thịt, Cá & Trứng" ${editProduct.category == 'Thịt, Cá & Trứng' ? 'selected' : ''}>🥩 Thịt, Cá & Trứng</option>
              <option value="Đồ uống & Sữa" ${editProduct.category == 'Đồ uống & Sữa' ? 'selected' : ''}>🥛 Đồ uống & Sữa</option>
              <option value="Bánh kẹo" ${editProduct.category == 'Bánh kẹo' ? 'selected' : ''}>🍪 Bánh kẹo & Ăn vặt</option>
              <option value="Thực phẩm khô" ${editProduct.category == 'Thực phẩm khô' ? 'selected' : ''}>🌾 Thực phẩm khô</option>
            </select>
          </div>

          <!-- Giá bán -->
          <div>
            <label class="product-input-label">Giá bán niêm yết (VNĐ) <span style="color:#ef4444;">*</span></label>
            <input type="number" name="price" class="product-input-control" value="${editProduct != null ? editProduct.price : ''}"
                   required placeholder="Ví dụ: 65000" min="0" step="1000">
          </div>

          <!-- Số lượng tồn kho -->
          <div>
            <label class="product-input-label">Số lượng nhập kho <span style="color:#ef4444;">*</span></label>
            <input type="number" name="count" class="product-input-control" value="${editProduct != null ? editProduct.count : '100'}"
                   required placeholder="100" min="0">
          </div>

          <!-- Link ảnh URL -->
          <div>
            <label class="product-input-label">Đường dẫn hình ảnh (URL)</label>
            <input type="url" name="image" id="productImageInput" class="product-input-control"
                   value="${editProduct != null ? editProduct.image : ''}"
                   placeholder="https://images.unsplash.com/..."
                   oninput="document.getElementById('productImagePreview').src = this.value || 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=300';">
          </div>

          <!-- Preview ảnh trực tiếp -->
          <div class="form-full-width" style="display:flex; gap:16px; align-items:center; background:#f8fafc; padding:12px; border-radius:10px; border:1px solid #e2e8f0;">
            <div style="width:70px; height:70px; border-radius:8px; overflow:hidden; border:1px solid #cbd5e1; flex-shrink:0;">
              <img id="productImagePreview"
                   src="${editProduct != null && not empty editProduct.image ? editProduct.image : 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=300'}"
                   style="width:100%; height:100%; object-fit:cover;"
                   onerror="this.src='https://images.unsplash.com/photo-1542838132-92c53300491e?w=300';"
                   alt="Xem trước ảnh">
            </div>
            <div style="font-size:12.5px; color:#64748b; line-height:1.4;">
              <strong style="color:#334155;">Xem trước hình ảnh đại diện:</strong><br>
              Hình ảnh sẽ hiển thị trên lưới sản phẩm trang chủ và giỏ hàng của khách. Hỗ trợ định dạng ảnh từ Unsplash, Imgur, Cloudinary...
            </div>
          </div>

          <!-- Mô tả sản phẩm -->
          <div class="form-full-width">
            <label class="product-input-label">Mô tả chi tiết sản phẩm</label>
            <textarea name="description" rows="3" class="product-input-control"
                      placeholder="Mô tả tiêu chuẩn chất lượng, nguồn gốc xuất xứ, hạn sử dụng...">${editProduct != null ? editProduct.description : ''}</textarea>
          </div>
        </div>

        <!-- Buttons -->
        <div style="display:flex; justify-content:flex-end; gap:12px; margin-top:24px; border-top:1px solid #e2e8f0; padding-top:18px;">
          <a href="admin?tab=products" style="padding:10px 20px; border:1px solid #cbd5e1; background:white; color:#475569; border-radius:8px; font-weight:600; font-size:14px; text-decoration:none; display:inline-flex; align-items:center; gap:6px;">
            Hủy bỏ
          </a>
          <button type="submit" class="btn-create-product" style="padding:10px 26px; border-radius:8px; font-size:14px;">
            <i class="fa-solid fa-floppy-disk"></i>
            <c:choose>
              <c:when test="${not empty editProduct}">Cập Nhật Sản Phẩm</c:when>
              <c:otherwise>Lưu & Đăng Bán</c:otherwise>
            </c:choose>
          </button>
        </div>
      </form>
    </div>
  </div>
</c:if>

<!-- Modal Chi tiết đơn hàng (Redesigned Invoice / Fulfillment Modal) -->
<c:if test="${not empty viewOrderObj}">
  <div class="modal" id="orderDetailModal" style="display: flex;">
    <div class="invoice-modal-content">
      <div class="invoice-modal-header">
        <h3>
          <i class="fa-solid fa-file-invoice-dollar"></i>
          Chi Tiết Hóa Đơn — <strong>#${viewOrderObj.orderCode}</strong>
        </h3>
        <div style="display:flex; align-items:center; gap:10px;">
          <button type="button" onclick="window.print()" style="background:rgba(255,255,255,0.18); border:none; color:white; padding:6px 12px; border-radius:6px; font-size:12.5px; cursor:pointer;" title="In hóa đơn">
            <i class="fa-solid fa-print"></i> In
          </button>
          <a href="admin?tab=orders<c:if test="${not empty statusFilter}">&statusFilter=${statusFilter}</c:if>" class="close-btn" style="text-decoration: none; font-size: 24px; color: #ffffff; opacity:0.8;">&times;</a>
        </div>
      </div>

      <div class="invoice-modal-body">
        <!-- Progress Stepper Track -->
        <c:choose>
          <c:when test="${viewOrderObj.status == 'Canceled' || viewOrderObj.status == 'Cancelled'}">
            <div style="background:#fef2f2; border:1px solid #fecaca; border-radius:10px; padding:12px 18px; margin-bottom:20px; color:#991b1b; display:flex; align-items:center; gap:12px;">
              <i class="fa-solid fa-circle-exclamation" style="font-size:20px;"></i>
              <div>
                <strong>Đơn hàng này đã bị hủy</strong>
                <div style="font-size:12px; color:#b91c1c; margin-top:2px;">Đơn hàng không tiếp tục giao nhận. Số lượng hàng tồn kho đã được khôi phục.</div>
              </div>
            </div>
          </c:when>
          <c:otherwise>
            <div class="mini-stepper-track">
              <!-- Step 1: Chờ duyệt -->
              <div class="mini-step-item done">
                <div class="mini-step-icon"><i class="fa-solid fa-check"></i></div>
                <div class="mini-step-label">Đặt hàng</div>
              </div>
              <!-- Step 2: Đã xác nhận -->
              <div class="mini-step-item ${viewOrderObj.status == 'Confirmed' || viewOrderObj.status == 'Shipping' || viewOrderObj.status == 'Completed' || viewOrderObj.status == 'Delivered' ? 'done' : (viewOrderObj.status == 'Waiting' ? 'active' : '')}">
                <div class="mini-step-icon">
                  <c:choose>
                    <c:when test="${viewOrderObj.status == 'Confirmed' || viewOrderObj.status == 'Shipping' || viewOrderObj.status == 'Completed' || viewOrderObj.status == 'Delivered'}">
                      <i class="fa-solid fa-check"></i>
                    </c:when>
                    <c:otherwise>
                      <i class="fa-solid fa-boxes-packing"></i>
                    </c:otherwise>
                  </c:choose>
                </div>
                <div class="mini-step-label">Xác nhận</div>
              </div>
              <!-- Step 3: Đang giao hàng -->
              <div class="mini-step-item ${viewOrderObj.status == 'Shipping' || viewOrderObj.status == 'Completed' || viewOrderObj.status == 'Delivered' ? 'done' : (viewOrderObj.status == 'Confirmed' ? 'active' : '')}">
                <div class="mini-step-icon">
                  <c:choose>
                    <c:when test="${viewOrderObj.status == 'Completed' || viewOrderObj.status == 'Delivered'}">
                      <i class="fa-solid fa-check"></i>
                    </c:when>
                    <c:otherwise>
                      <i class="fa-solid fa-truck"></i>
                    </c:otherwise>
                  </c:choose>
                </div>
                <div class="mini-step-label">Đang giao</div>
              </div>
              <!-- Step 4: Hoàn tất -->
              <div class="mini-step-item ${viewOrderObj.status == 'Completed' || viewOrderObj.status == 'Delivered' ? 'done' : (viewOrderObj.status == 'Shipping' ? 'active' : '')}">
                <div class="mini-step-icon">
                  <c:choose>
                    <c:when test="${viewOrderObj.status == 'Completed' || viewOrderObj.status == 'Delivered'}">
                      <i class="fa-solid fa-circle-check"></i>
                    </c:when>
                    <c:otherwise>
                      <i class="fa-solid fa-flag-checkered"></i>
                    </c:otherwise>
                  </c:choose>
                </div>
                <div class="mini-step-label">Hoàn tất</div>
              </div>
            </div>
          </c:otherwise>
        </c:choose>

        <!-- 2-Column Info Grid -->
        <div class="invoice-grid">
          <div class="invoice-info-card">
            <h4><i class="fa-solid fa-user"></i> Thông tin khách hàng</h4>
            <div class="invoice-info-row">
              <strong>Họ và tên:</strong> ${viewOrderObj.name}
            </div>
            <div class="invoice-info-row">
              <strong>Điện thoại:</strong> 
              <a href="tel:${viewOrderObj.phone}" style="color:var(--primary-color); text-decoration:none; font-weight:600;">
                <i class="fa-solid fa-phone" style="font-size:11px;"></i> ${viewOrderObj.phone}
              </a>
            </div>
            <div class="invoice-info-row">
              <strong>Địa chỉ nhận hàng:</strong> ${viewOrderObj.address}
            </div>
          </div>

          <div class="invoice-info-card">
            <h4><i class="fa-solid fa-receipt"></i> Thông tin đơn & Thanh toán</h4>
            <div class="invoice-info-row">
              <strong>Mã đơn hàng:</strong> <span style="font-family:monospace; font-weight:700;">#${viewOrderObj.orderCode}</span>
            </div>
            <div class="invoice-info-row">
              <strong>Thời gian đặt:</strong> ${viewOrderObj.createdAt}
            </div>
            <div class="invoice-info-row">
              <strong>Hình thức thanh toán:</strong>
              <c:choose>
                <c:when test="${viewOrderObj.paymentMethod == 'BANK'}">
                  <span class="payment-tag tag-bank"><i class="fa-solid fa-qrcode"></i> Chuyển khoản VietQR</span>
                </c:when>
                <c:otherwise>
                  <span class="payment-tag tag-cod"><i class="fa-solid fa-money-bill-wave"></i> Thu tiền khi giao (COD)</span>
                </c:otherwise>
              </c:choose>
            </div>
            <div class="invoice-info-row" style="margin-top:6px;">
              <strong>Trạng thái:</strong>
              <c:choose>
                <c:when test="${viewOrderObj.status == 'Completed' || viewOrderObj.status == 'Delivered'}">
                  <span class="status-pill pill-completed"><i class="fa-solid fa-circle-check"></i> Hoàn tất</span>
                </c:when>
                <c:when test="${viewOrderObj.status == 'Shipping'}">
                  <span class="status-pill pill-shipping"><i class="fa-solid fa-truck-fast"></i> Đang giao</span>
                </c:when>
                <c:when test="${viewOrderObj.status == 'Confirmed'}">
                  <span class="status-pill pill-confirmed"><i class="fa-solid fa-boxes-packing"></i> Đã xác nhận</span>
                </c:when>
                <c:when test="${viewOrderObj.status == 'Canceled' || viewOrderObj.status == 'Cancelled'}">
                  <span class="status-pill pill-canceled"><i class="fa-solid fa-ban"></i> Đã hủy</span>
                </c:when>
                <c:otherwise>
                  <span class="status-pill pill-waiting"><i class="fa-solid fa-hourglass-half"></i> Chờ duyệt</span>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>

        <!-- Order Items Table -->
        <table style="width:100%; border-collapse:collapse; margin-bottom:12px; background:white; border:1px solid #e2e8f0; border-radius:8px; overflow:hidden;">
          <thead style="background:#f8fafc;">
            <tr>
              <th style="padding:10px 14px; text-align:left; font-size:13px; color:#475569;">Sản phẩm</th>
              <th style="padding:10px 14px; text-align:right; font-size:13px; color:#475569;">Đơn giá</th>
              <th style="padding:10px 14px; text-align:center; font-size:13px; color:#475569;">Số lượng</th>
              <th style="padding:10px 14px; text-align:right; font-size:13px; color:#475569;">Thành tiền</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty viewOrderObj.items}">
                <tr><td colspan="4" style="text-align:center; padding:20px; color:#888;">Không có chi tiết sản phẩm.</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="it" items="${viewOrderObj.items}">
                  <tr style="border-bottom:1px solid #f1f5f9;">
                    <td style="padding:10px 14px; font-weight:600; color:var(--text-heading);">
                      ${it.productName}
                    </td>
                    <td style="padding:10px 14px; text-align:right; color:#475569;">
                      <fmt:formatNumber value="${it.productPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                    </td>
                    <td style="padding:10px 14px; text-align:center;">
                      <span style="background:#f1f5f9; padding:2px 8px; border-radius:12px; font-weight:700; font-size:12px;">
                        &times; ${it.quantity}
                      </span>
                    </td>
                    <td style="padding:10px 14px; text-align:right; font-weight:700; color:var(--primary-color);">
                      <fmt:formatNumber value="${it.productPrice * it.quantity}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>

        <!-- Invoice Summary Box -->
        <div class="invoice-summary-card">
          <div class="summary-line">
            <span>Tạm tính tiền hàng:</span>
            <span><fmt:formatNumber value="${viewOrderObj.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
          </div>
          <c:if test="${viewOrderObj.discount != null && viewOrderObj.discount > 0}">
            <div class="summary-line" style="color:#16a34a;">
              <span>Giảm giá khuyến mãi (${viewOrderObj.couponCode}):</span>
              <span>- <fmt:formatNumber value="${viewOrderObj.discount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
            </div>
          </c:if>
          <div class="summary-line" style="color:#64748b;">
            <span>Phí giao hàng:</span>
            <span>Miễn phí (Freeship)</span>
          </div>
          <div class="summary-total">
            <span>Tổng thanh toán:</span>
            <span><fmt:formatNumber value="${viewOrderObj.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
          </div>
        </div>

        <!-- Direct Status Update form in modal -->
        <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:10px; padding:14px 18px; margin-top:16px;">
          <form action="admin" method="POST" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
            <input type="hidden" name="action" value="updateOrderStatus">
            <input type="hidden" name="id" value="${viewOrderObj.id}">
            <input type="hidden" name="redirect" value="admin?tab=orders&viewOrder=${viewOrderObj.id}<c:if test="${not empty statusFilter}">&statusFilter=${statusFilter}</c:if>">
            
            <div style="display:flex; align-items:center; gap:8px;">
              <label style="font-size:13px; font-weight:700; color:var(--text-heading);">Cập nhật trạng thái:</label>
              <select name="status" style="padding:6px 12px; border-radius:6px; border:1px solid #cbd5e1; font-size:13.5px; background:white; cursor:pointer;">
                <option value="Waiting" ${viewOrderObj.status == 'Waiting' ? 'selected' : ''}>Chờ duyệt</option>
                <option value="Confirmed" ${viewOrderObj.status == 'Confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                <option value="Shipping" ${viewOrderObj.status == 'Shipping' ? 'selected' : ''}>Đang giao hàng</option>
                <option value="Completed" ${viewOrderObj.status == 'Completed' ? 'selected' : ''}>Hoàn tất</option>
                <option value="Canceled" ${viewOrderObj.status == 'Canceled' ? 'selected' : ''}>Hủy đơn hàng</option>
              </select>
              <button type="submit" class="btn-primary" style="padding:6px 14px; font-size:13px; border-radius:6px;">
                <i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi
              </button>
            </div>

            <div style="display:flex; gap:10px;">
              <c:if test="${not empty viewOrderObj.userId}">
                <a href="chat?with=${viewOrderObj.userId}&orderCode=${viewOrderObj.orderCode}" class="btn-chat-order-pill" style="font-size:12.5px; padding:6px 14px;">
                  <i class="fa-solid fa-comments"></i> Chat với khách
                </a>
              </c:if>
              <a href="track-order?code=${viewOrderObj.orderCode}" target="_blank" class="btn-track-pill" style="font-size:12.5px; padding:6px 14px;">
                <i class="fa-solid fa-truck-fast"></i> Trang tra cứu
              </a>
            </div>
          </form>
        </div>

      </div>
    </div>
  </div>
</c:if>

<script>
document.addEventListener('DOMContentLoaded', function() {
  // Client-side Instant Filter for Products
  const filterChips = document.querySelectorAll('.prod-filter-chip');
  const productRows = document.querySelectorAll('.product-item-row');
  const emptyRow = document.getElementById('productsEmptyRow');

  if (filterChips.length > 0 && productRows.length > 0) {
    const urlParams = new URLSearchParams(window.location.search);
    const stockParam = urlParams.get('stockFilter');
    const catParam = urlParams.get('categoryFilter');

    function applyFilter(filterType, filterVal) {
      let visibleCount = 0;
      productRows.forEach(function(row) {
        let match = false;
        if (filterType === 'all' || !filterVal || filterVal === 'all') {
          match = true;
        } else if (filterType === 'stock') {
          match = (row.getAttribute('data-stock-status') === filterVal);
        } else if (filterType === 'category') {
          const rowCat = row.getAttribute('data-cat-slug');
          match = (rowCat === filterVal);
        }

        if (match) {
          row.style.display = '';
          visibleCount++;
        } else {
          row.style.display = 'none';
        }
      });

      if (emptyRow) {
        emptyRow.style.display = (visibleCount === 0) ? '' : 'none';
      }
    }

    filterChips.forEach(function(chip) {
      chip.addEventListener('click', function(e) {
        e.preventDefault();
        
        filterChips.forEach(function(c) { c.classList.remove('active'); });
        this.classList.add('active');

        const filterType = this.getAttribute('data-filter-type') || 'all';
        const filterVal = this.getAttribute('data-filter-val');

        applyFilter(filterType, filterVal);

        const url = new URL(window.location);
        url.searchParams.delete('stockFilter');
        url.searchParams.delete('categoryFilter');
        if (filterType === 'stock' && filterVal && filterVal !== 'all') {
          url.searchParams.set('stockFilter', filterVal);
        } else if (filterType === 'category' && filterVal && filterVal !== 'all') {
          url.searchParams.set('categoryFilter', filterVal);
        }
        window.history.replaceState({}, '', url);
      });
    });

    if (stockParam) {
      applyFilter('stock', stockParam);
    } else if (catParam) {
      applyFilter('category', catParam);
    }
  }
});
</script>
</body>
</html>
