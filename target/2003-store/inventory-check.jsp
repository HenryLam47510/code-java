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
    <%@ include file="/WEB-INF/sidebar.jsp" %>

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
