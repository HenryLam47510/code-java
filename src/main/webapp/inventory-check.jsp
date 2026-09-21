<%@ page import="com._2003store.model.InventoryCheck" %>
<%@ page import="com._2003store.model.Product" %>
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
    <title>Kiểm kho - 2003 Store</title>
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
                        <a href="${pageContext.request.contextPath}/customers">Khách hàng</a>
                        <a href="${pageContext.request.contextPath}/reports">Doanh thu</a>
                        <a href="${pageContext.request.contextPath}/staff-report">Báo cáo nhân viên</a>
                        <a href="${pageContext.request.contextPath}/login-history">Nhật ký hệ thống</a>
                    </div>
                </div>
                <% if (canAccessInventory) { %><a class="single-link active" href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a><% } %>
                <% if (canAccessSuppliers) { %><a class="single-link" href="${pageContext.request.contextPath}/suppliers">Nhà cung cấp</a><% } %>
            <% } else if ("MANAGER".equalsIgnoreCase(userRole)) { %>
                <div class="nav-group active manager-shell">
                    <a class="nav-main" href="${pageContext.request.contextPath}/dashboard/manager">Quản lý</a>
                    <div class="nav-submenu">
                        <a href="${pageContext.request.contextPath}/dashboard/manager">Tổng quan</a>
                        <% if (canAccessOrders) { %><a href="${pageContext.request.contextPath}/orders">Bán hàng & Đơn hàng</a><% } %>
                        <% if (canAccessProducts) { %><a href="${pageContext.request.contextPath}/products">Sản phẩm</a><% } %>
                        <% if (canAccessCustomers) { %><a href="${pageContext.request.contextPath}/customers">Khách hàng</a><% } %>
                        <% if (canAccessInventory) { %><a href="${pageContext.request.contextPath}/stock">Nhập kho</a><a href="${pageContext.request.contextPath}/stock-out">Xuất kho</a><a class="active" href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a><% } %>
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
                        <% if (canAccessOrders) { %><a href="${pageContext.request.contextPath}/orders">Đơn hàng</a><% } %>
                        <% if (canAccessProducts) { %><a href="${pageContext.request.contextPath}/products">Sản phẩm</a><% } %>
                        <% if (canAccessCustomers) { %><a href="${pageContext.request.contextPath}/customers">Khách hàng</a><% } %>
                    </div>
                </div>
            <% } %>
            <% if (canAccessLoginHistory && "ADMIN".equalsIgnoreCase(userRole)) { %><a class="single-link" href="${pageContext.request.contextPath}/login-history">Lịch sử đăng nhập</a><% } %>
            <div class="nav-divider"></div>
            <a class="single-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </aside>

    <main class="main-panel">
        <div class="topbar">
            <h1>Kiểm kê kho</h1>
            <span>Xin chào, ${sessionScope.user.fullName}</span>
        </div>

        <div class="card form-card">
            <h3>Phiếu kiểm kê</h3>
            <form action="${pageContext.request.contextPath}/inventory-check/add" method="post" class="stock-form">
                <select name="productId" required>
                    <option value="">-- Chọn sản phẩm --</option>
                    <%
                        List<Product> products = (List<Product>) request.getAttribute("products");
                        if (products != null) {
                            for (Product product : products) {
                    %>
                    <option value="<%= product.getId() %>"><%= product.getName() %> (Tồn hệ thống: <%= product.getStock() %>)</option>
                    <%
                            }
                        }
                    %>
                </select>
                <input type="number" name="countedQuantity" min="0" placeholder="Số lượng thực đếm" required>
                <input type="text" name="countedBy" placeholder="Người kiểm kê">
                <textarea name="note" placeholder="Ghi chú"></textarea>
                <button type="submit" class="btn btn-primary">Lưu kiểm kê</button>
            </form>
        </div>

        <div class="card table-card">
            <h3>Lịch sử kiểm kho</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Sản phẩm</th>
                        <th>Tồn hệ thống</th>
                        <th>Đếm thực tế</th>
                        <th>Chênh lệch</th>
                        <th>Người kiểm</th>
                        <th>Ghi chú</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<InventoryCheck> checks = (List<InventoryCheck>) request.getAttribute("checks");
                        if (checks != null) {
                            for (InventoryCheck check : checks) {
                    %>
                    <tr>
                        <td><%= check.getId() %></td>
                        <td><%= check.getProductName() %></td>
                        <td><%= check.getExpectedQuantity() %></td>
                        <td><%= check.getCountedQuantity() %></td>
                        <td><%= check.getVariance() %></td>
                        <td><%= check.getCountedBy() %></td>
                        <td><%= check.getNote() %></td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>
