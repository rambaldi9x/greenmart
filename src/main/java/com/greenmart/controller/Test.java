package com.greenmart.controller;

import com.greenmart.util.DatabaseSeeder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

@WebServlet(name = "TestSeederServlet", urlPatterns = {"/test"})
public class Test extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processSeed(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processSeed(req, resp);
    }

    private void processSeed(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String format = req.getParameter("format");

        try {
            // Thực thi làm mới và nạp lại toàn bộ dữ liệu từ đầu
            Map<String, Long> stats = DatabaseSeeder.seed();

            // Nếu client yêu cầu JSON
            if ("json".equalsIgnoreCase(format)) {
                resp.setContentType("application/json; charset=UTF-8");
                PrintWriter out = resp.getWriter();
                StringBuilder json = new StringBuilder("{");
                json.append("\"status\":\"success\",");
                json.append("\"message\":\"Database seeded successfully\",");
                json.append("\"stats\":{");
                int i = 0;
                for (Map.Entry<String, Long> entry : stats.entrySet()) {
                    if (i++ > 0) json.append(",");
                    json.append("\"").append(entry.getKey()).append("\":").append(entry.getValue());
                }
                json.append("}}");
                out.print(json.toString());
                out.flush();
                return;
            }

            // Mặc định trả về giao diện HTML hiện đại, đẹp mắt
            resp.setContentType("text/html; charset=UTF-8");
            PrintWriter out = resp.getWriter();
            renderSuccessHtml(out, stats, req.getContextPath());

        } catch (Exception ex) {
            resp.setContentType("text/html; charset=UTF-8");
            PrintWriter out = resp.getWriter();
            renderErrorHtml(out, ex.getMessage(), req.getContextPath());
        }
    }

    private void renderSuccessHtml(PrintWriter out, Map<String, Long> stats, String contextPath) {
        out.println("<!DOCTYPE html>");
        out.println("<html lang='vi'>");
        out.println("<head>");
        out.println("  <meta charset='UTF-8'>");
        out.println("  <meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("  <title>Khởi Tạo Dữ Liệu Mẫu - GreenMart PTIT</title>");
        out.println("  <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css'>");
        out.println("  <style>");
        out.println("    :root { --primary: #3bb77e; --primary-dark: #2ea16d; --bg: #f8fafc; --text: #0f172a; }");
        out.println("    body { font-family: 'Segoe UI', system-ui, sans-serif; background: var(--bg); margin: 0; padding: 40px 20px; color: var(--text); }");
        out.println("    .container { max-width: 840px; margin: 0 auto; background: #ffffff; border-radius: 18px; box-shadow: 0 10px 30px rgba(0,0,0,0.06); overflow: hidden; border: 1px solid #e2e8f0; }");
        out.println("    .header { background: linear-gradient(135deg, #064e3b 0%, #047857 100%); color: white; padding: 36px 30px; text-align: center; }");
        out.println("    .header i { font-size: 52px; margin-bottom: 15px; color: #6ee7b7; }");
        out.println("    .header h1 { margin: 0 0 10px 0; font-size: 26px; font-weight: 800; }");
        out.println("    .header p { margin: 0; font-size: 15px; opacity: 0.9; }");
        out.println("    .body { padding: 36px 30px; }");
        out.println("    .alert-banner { background: #ecfdf5; border: 1px solid #a7f3d0; border-radius: 12px; padding: 16px 20px; display: flex; align-items: center; gap: 14px; margin-bottom: 28px; color: #065f46; font-size: 14.5px; }");
        out.println("    .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 16px; margin-bottom: 30px; }");
        out.println("    .stat-card { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 12px; padding: 18px; text-align: center; transition: all 0.2s; }");
        out.println("    .stat-card:hover { transform: translateY(-2px); border-color: var(--primary); box-shadow: 0 4px 12px rgba(59,183,126,0.12); }");
        out.println("    .stat-card .val { font-size: 26px; font-weight: 800; color: #047857; margin-bottom: 4px; }");
        out.println("    .stat-card .lbl { font-size: 13px; color: #64748b; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }");
        out.println("    .accounts-box { background: #f1f5f9; border-radius: 12px; padding: 20px; margin-bottom: 30px; border-left: 4px solid var(--primary); }");
        out.println("    .accounts-box h4 { margin: 0 0 12px 0; font-size: 15px; color: #1e293b; display: flex; align-items: center; gap: 8px; }");
        out.println("    .account-item { display: flex; justify-content: space-between; font-size: 13.5px; padding: 6px 0; border-bottom: 1px dashed #cbd5e1; }");
        out.println("    .account-item:last-child { border-bottom: none; }");
        out.println("    .actions { display: flex; gap: 14px; justify-content: center; flex-wrap: wrap; }");
        out.println("    .btn { display: inline-flex; align-items: center; gap: 8px; padding: 12px 24px; border-radius: 25px; font-size: 14px; font-weight: 700; text-decoration: none; transition: all 0.2s; cursor: pointer; border: none; }");
        out.println("    .btn-primary { background: linear-gradient(135deg, #3bb77e 0%, #059669 100%); color: white; box-shadow: 0 4px 12px rgba(59,183,126,0.3); }");
        out.println("    .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(59,183,126,0.4); }");
        out.println("    .btn-secondary { background: #ffffff; color: #334155; border: 1px solid #cbd5e1; }");
        out.println("    .btn-secondary:hover { background: #f8fafc; color: #0f172a; }");
        out.println("  </style>");
        out.println("</head>");
        out.println("<body>");
        out.println("  <div class='container'>");
        out.println("    <div class='header'>");
        out.println("      <i class='fa-solid fa-circle-check'></i>");
        out.println("      <h1>Khởi Tạo Dữ Liệu Thành Công!</h1>");
        out.println("      <p>Toàn bộ cơ sở dữ liệu mẫu GreenMart PTIT đã được làm sạch và nạp lại từ đầu.</p>");
        out.println("    </div>");
        out.println("    <div class='body'>");
        out.println("      <div class='alert-banner'>");
        out.println("        <i class='fa-solid fa-shield-halved' style='font-size:20px; color:#059669;'></i>");
        out.println("        <div><strong>Hệ thống sẵn sàng:</strong> Schema tự động cập nhật, SessionFactory được giữ nguyên và kết nối H2 DB hoạt động hoàn hảo.</div>");
        out.println("      </div>");
        out.println("      <h3 style='margin:0 0 16px 0; font-size:16px; color:#1e293b;'><i class='fa-solid fa-chart-simple' style='color:var(--primary); margin-right:6px;'></i> Bảng Thống Kê Số Lượng Dữ Liệu Đã Nạp:</h3>");
        out.println("      <div class='stats-grid'>");
        out.println("        <div class='stat-card'><div class='val'>" + stats.getOrDefault("products", 0L) + "</div><div class='lbl'>Sản Phẩm VietGAP</div></div>");
        out.println("        <div class='stat-card'><div class='val'>" + stats.getOrDefault("vendors", 0L) + "</div><div class='lbl'>Nhà Bán Hàng (Vendor)</div></div>");
        out.println("        <div class='stat-card'><div class='val'>" + stats.getOrDefault("categories", 0L) + "</div><div class='lbl'>Danh Mục Hàng</div></div>");
        out.println("        <div class='stat-card'><div class='val'>" + stats.getOrDefault("users", 0L) + "</div><div class='lbl'>Người Dùng / Khách</div></div>");
        out.println("        <div class='stat-card'><div class='val'>" + stats.getOrDefault("orders", 0L) + "</div><div class='lbl'>Đơn Hàng Mẫu</div></div>");
        out.println("        <div class='stat-card'><div class='val'>" + stats.getOrDefault("coupons", 0L) + "</div><div class='lbl'>Mã Khuyến Mãi</div></div>");
        out.println("        <div class='stat-card'><div class='val'>" + stats.getOrDefault("chatMessages", 0L) + "</div><div class='lbl'>Tin Nhắn Chat</div></div>");
        out.println("        <div class='stat-card'><div class='val'>" + stats.getOrDefault("roles", 0L) + "</div><div class='lbl'>Vai Trò Hệ Thống</div></div>");
        out.println("      </div>");
        out.println("      <div class='accounts-box'>");
        out.println("        <h4><i class='fa-solid fa-key'></i> Tài Khoản Đăng Nhập Mẫu (Mật khẩu: <code>123456</code>)</h4>");
        out.println("        <div class='account-item'><span><strong>Admin Quản trị:</strong> <code>admin@greenmart.vn</code></span><span style='color:#059669; font-weight:bold;'>Quyền: admin</span></div>");
        out.println("        <div class='account-item'><span><strong>Khách hàng 1:</strong> <code>an.nguyen@gmail.com</code> (Nguyễn Văn An)</span><span style='color:#2563eb;'>Quyền: user</span></div>");
        out.println("        <div class='account-item'><span><strong>Khách hàng 2:</strong> <code>mai.tran@gmail.com</code> (Trần Thị Mai)</span><span style='color:#2563eb;'>Quyền: user</span></div>");
        out.println("        <div class='account-item'><span><strong>Đối tác cung ứng:</strong> <code>vendor@greenmart.vn</code> (Dalat Farm)</span><span style='color:#d97706;'>Quyền: vendor/user</span></div>");
        out.println("      </div>");
        out.println("      <div class='actions'>");
        out.println("        <a href='" + contextPath + "/home' class='btn btn-primary'><i class='fa-solid fa-house'></i> Đến Trang Chủ</a>");
        out.println("        <a href='" + contextPath + "/admin' class='btn btn-secondary'><i class='fa-solid fa-gauge-high'></i> Trang Quản Trị Admin</a>");
        out.println("        <a href='" + contextPath + "/auth?action=login' class='btn btn-secondary'><i class='fa-solid fa-right-to-bracket'></i> Đăng Nhập</a>");
        out.println("        <a href='" + contextPath + "/test' class='btn btn-secondary' title='Nhấn để chạy lại seeder'><i class='fa-solid fa-rotate'></i> Seed Lại</a>");
        out.println("      </div>");
        out.println("    </div>");
        out.println("  </div>");
        out.println("</body>");
        out.println("</html>");
    }

    private void renderErrorHtml(PrintWriter out, String errorMsg, String contextPath) {
        out.println("<!DOCTYPE html>");
        out.println("<html lang='vi'>");
        out.println("<head>");
        out.println("  <meta charset='UTF-8'>");
        out.println("  <title>Lỗi Khởi Tạo Dữ Liệu</title>");
        out.println("  <style>body{font-family:sans-serif;background:#fef2f2;color:#991b1b;padding:40px;text-align:center;} .box{max-width:600px;margin:auto;background:white;padding:30px;border-radius:12px;border:1px solid #fecaca;}</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("  <div class='box'>");
        out.println("    <h2><i class='fa-solid fa-triangle-exclamation'></i> Quá Trình Seed Thất Bại</h2>");
        out.println("    <p>Chi tiết lỗi: " + errorMsg + "</p>");
        out.println("    <p><a href='" + contextPath + "/test'>Thử lại</a> | <a href='" + contextPath + "/home'>Về trang chủ</a></p>");
        out.println("  </div>");
        out.println("</body>");
        out.println("</html>");
    }
}
