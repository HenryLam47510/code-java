<%@ page import="com._2003store.model.Customer" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    com._2003store.model.User sessionUser = (com._2003store.model.User) session.getAttribute("user");
    String userRole = sessionUser != null ? sessionUser.getRole() : "";
    String dashboardRoute = "/dashboard/employee";
    if ("ADMIN".equalsIgnoreCase(userRole)) {
        dashboardRoute = "/dashboard/admin";
    } else if ("MANAGER".equalsIgnoreCase(userRole)) {
        dashboardRoute = "/dashboard/manager";
    }

    com._2003store.service.AuthService authService = new com._2003store.service.AuthService();
    boolean canAccessOrders = sessionUser != null && authService.hasAccess(sessionUser, "orders");
    boolean canAccessProducts = sessionUser != null && authService.hasAccess(sessionUser, "products");
    boolean canAccessCustomers = sessionUser != null && authService.hasAccess(sessionUser, "customers");
    boolean canAccessReports = sessionUser != null && authService.hasAccess(sessionUser, "reports");
    boolean canAccessStaffReport = sessionUser != null && authService.hasAccess(sessionUser, "staff-report");
    boolean canAccessEmployees = sessionUser != null && authService.hasAccess(sessionUser, "employees");
    boolean canAccessInventory = sessionUser != null && authService.hasAccess(sessionUser, "inventory-check");
    boolean canAccessSuppliers = sessionUser != null && authService.hasAccess(sessionUser, "suppliers");
    boolean canAccessLoginHistory = sessionUser != null && authService.hasAccess(sessionUser, "login-history");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khách hàng - 2003 Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2003store-20260921">
</head>
<body class="dashboard-page">
    <aside class="sidebar">
        <h2>2003 STORE</h2>
        <nav class="sidebar-nav">
            <% if ("ADMIN".equalsIgnoreCase(userRole)) { %>
                <div class="nav-group active manager-shell">
                    <a class="nav-main" href="${pageContext.request.contextPath}/dashboard/admin">Admin</a>
                    <div class="nav-submenu">
                        <a href="${pageContext.request.contextPath}/dashboard/admin">Tổng quan</a>
                        <a href="${pageContext.request.contextPath}/employees">Quản lý nhân sự</a>
                        <a href="${pageContext.request.contextPath}/orders">Đơn hàng</a>
                        <a href="${pageContext.request.contextPath}/products">Sản phẩm</a>
                        <a class="active" href="${pageContext.request.contextPath}/customers">Khách hàng</a>
                        <a href="${pageContext.request.contextPath}/reports">Doanh thu</a>
                        <a href="${pageContext.request.contextPath}/staff-report">Báo cáo nhân viên</a>
                        <a href="${pageContext.request.contextPath}/login-history">Nhật ký hệ thống</a>
                    </div>
                </div>
                <% if (canAccessInventory) { %><a class="single-link" href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a><% } %>
                <% if (canAccessSuppliers) { %><a class="single-link" href="${pageContext.request.contextPath}/suppliers">Nhà cung cấp</a><% } %>
            <% } else if ("MANAGER".equalsIgnoreCase(userRole)) { %>
                <div class="nav-group active manager-shell">
                    <a class="nav-main" href="${pageContext.request.contextPath}/dashboard/manager">Quản lý</a>
                    <div class="nav-submenu">
                        <a href="${pageContext.request.contextPath}/dashboard/manager">Tổng quan</a>
                        <% if (canAccessOrders) { %><a href="${pageContext.request.contextPath}/orders">Bán hàng & Đơn hàng</a><% } %>
                        <% if (canAccessProducts) { %><a href="${pageContext.request.contextPath}/products">Sản phẩm</a><% } %>
                        <% if (canAccessCustomers) { %><a class="active" href="${pageContext.request.contextPath}/customers">Khách hàng</a><% } %>
                        <% if (canAccessInventory) { %><a href="${pageContext.request.contextPath}/stock">Nhập kho</a><a href="${pageContext.request.contextPath}/stock-out">Xuất kho</a><a href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a><% } %>
                        <% if (canAccessSuppliers) { %><a href="${pageContext.request.contextPath}/suppliers">Nhà cung cấp</a><% } %>
                        <% if (canAccessReports) { %><a href="${pageContext.request.contextPath}/inventory-report">Báo cáo kho</a><a href="${pageContext.request.contextPath}/reports">Doanh thu</a><% } %>
                        <% if (canAccessStaffReport) { %><a href="${pageContext.request.contextPath}/staff-report">Nhân sự</a><% } %>
                        <% if (canAccessEmployees) { %><a href="${pageContext.request.contextPath}/employees">Nhân viên</a><% } %>
                    </div>
                </div>
            <% } else { %>
                <div class="nav-group active manager-shell">
                    <a class="nav-main" href="${pageContext.request.contextPath}/dashboard/employee">Bán hàng</a>
                    <div class="nav-submenu">
                        <a href="${pageContext.request.contextPath}/dashboard/employee">Tổng quan</a>
                        <% if (canAccessOrders) { %><a href="${pageContext.request.contextPath}/orders">Tạo đơn</a><a href="${pageContext.request.contextPath}/orders">Đơn hàng</a><% } %>
                        <% if (canAccessProducts) { %><a href="${pageContext.request.contextPath}/products">Sản phẩm</a><% } %>
                        <% if (canAccessCustomers) { %><a class="active" href="${pageContext.request.contextPath}/customers">Khách hàng</a><% } %>
                    </div>
                </div>
            <% } %>
            <% if (canAccessLoginHistory && "ADMIN".equalsIgnoreCase(userRole)) { %><a class="single-link" href="${pageContext.request.contextPath}/login-history">Lịch sử đăng nhập</a><% } %>
            <div class="nav-divider"></div>
            <a class="single-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </aside>

    <main class="main-panel dashboard-shell">
        <div class="workspace-col">
            <header class="topbar modern-topbar">
                <div class="search-box">
                    <span>⌕</span>
                    <input type="text" placeholder="Tìm khách hàng, số điện thoại, email...">
                </div>
                <div class="topbar-actions">
                    <button class="icon-button" type="button" aria-label="Thông báo">
                        🔔
                        <span class="badge-count">4</span>
                    </button>
                    <div class="user-mini">
                        <div class="avatar">${sessionScope.user.fullName.substring(0,1)}</div>
                        <div>
                            <strong>${sessionScope.user.fullName}</strong>
                            <small>${sessionScope.user.role}</small>
                        </div>
                    </div>
                </div>
            </header>

            <div class="card form-card">
                <div class="panel-header">
                    <div>
                        <span class="panel-kicker">Khách hàng</span>
                        <h3>Thêm khách hàng mới</h3>
                    </div>
                </div>
                <form action="${pageContext.request.contextPath}/customers/add" method="post" class="customer-form">
                    <input type="text" name="name" placeholder="Tên khách hàng" required>
                    <input type="text" name="phone" placeholder="Số điện thoại" required>
                    <input type="email" name="email" placeholder="Email">
                    <textarea name="note" placeholder="Ghi chú"></textarea>
                    <button type="submit" class="btn btn-primary">Lưu</button>
                </form>
            </div>

            <div class="card table-card">
                <div class="section-head">
                    <h3>Danh sách khách hàng</h3>
                    <a href="#" class="table-link">Xuất file</a>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên</th>
                            <th>SĐT</th>
                            <th>Email</th>
                            <th>Ghi chú</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Customer> customers = (List<Customer>) request.getAttribute("customers");
                            if (customers != null) {
                                for (Customer customer : customers) {
                        %>
                        <tr>
                            <td><%= customer.getId() %></td>
                            <td><%= customer.getName() %></td>
                            <td><%= customer.getPhone() %></td>
                            <td><%= customer.getEmail() != null ? customer.getEmail() : "-" %></td>
                            <td><%= customer.getNote() != null ? customer.getNote() : "-" %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <aside class="right-rail">
            <div class="notification-card">
                <div class="notification-header">
                    <h4>Tổng quan</h4>
                    <button class="dismiss-btn" type="button">Xem</button>
                </div>
                <div class="notice">
                    <div class="avatar">KH</div>
                    <div>
                        <h5>Khách hàng mới</h5>
                        <p>Đã có 12 khách hàng tương tác trong tuần này.</p>
                    </div>
                </div>
                <div class="notice critical">
                    <div class="avatar">!</div>
                    <div>
                        <h5>Chăm sóc</h5>
                        <p>Cần theo dõi 3 khách hàng có giá trị lớn hơn 5 triệu.</p>
                    </div>
                </div>
            </div>
        </aside>
    </main>
</body>
</html>
