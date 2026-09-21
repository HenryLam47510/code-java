<%@ page import="com._2003store.model.Product" %>
<%@ page import="com._2003store.model.StockIssue" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xuất kho - 2003 Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2003store-20260921">
</head>
<body class="dashboard-page">
    <aside class="sidebar">
        <h2>2003 STORE</h2>
        <nav class="sidebar-nav">
            <div class="nav-group">
                <a class="nav-main" href="${pageContext.request.contextPath}<%= dashboardRoute %>">Dashboard</a>
                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}<%= dashboardRoute %>">Tổng quan</a>
                    <a href="${pageContext.request.contextPath}/reports">Báo cáo</a>
                    <a href="${pageContext.request.contextPath}/staff-report">Báo cáo nhân viên</a>
                </div>
            </div>
            <div class="nav-group">
                <a class="nav-main" href="${pageContext.request.contextPath}/products">Sản phẩm</a>
                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/products">Tất cả sản phẩm</a>
                    <a href="${pageContext.request.contextPath}/stock">Nhập kho</a>
                    <a href="${pageContext.request.contextPath}/stock-out">Xuất kho</a>
                </div>
            </div>
            <div class="nav-group">
                <a class="nav-main" href="${pageContext.request.contextPath}/orders">Đơn hàng</a>
                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/orders">Danh sách</a>
                    <a href="${pageContext.request.contextPath}/invoices">Hóa đơn</a>
                    <a href="${pageContext.request.contextPath}/customers">Khách hàng</a>
                </div>
            </div>
            <a class="single-link" href="${pageContext.request.contextPath}/customers">Khách hàng</a>
            <a class="single-link" href="${pageContext.request.contextPath}/stock">Nhập kho</a>
            <a class="single-link active" href="${pageContext.request.contextPath}/stock-out">Xuất kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/inventory-report">Báo cáo kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/suppliers">Nhà cung cấp</a>
            <a class="single-link" href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/employees">Nhân viên</a>
            <div class="nav-divider"></div>
            <a class="single-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </aside>

    <main class="main-panel">
        <div class="topbar">
            <h1>Quản lý xuất kho</h1>
            <span>Xin chào, ${sessionScope.user.fullName}</span>
        </div>

        <div class="card form-card">
            <h3>Phiếu xuất kho</h3>
            <form action="${pageContext.request.contextPath}/stock-out/add" method="post" class="stock-form">
                <select name="productId" required>
                    <option value="">-- Chọn sản phẩm --</option>
                    <%
                        List<Product> products = (List<Product>) request.getAttribute("products");
                        if (products != null) {
                            for (Product product : products) {
                    %>
                    <option value="<%= product.getId() %>"><%= product.getName() %> (Tồn: <%= product.getStock() %>)</option>
                    <%
                            }
                        }
                    %>
                </select>
                <input type="number" name="quantity" min="1" placeholder="Số lượng xuất" required>
                <select name="reason">
                    <option value="Ban hang">Bán hàng</option>
                    <option value="Tra hang">Trả hàng</option>
                    <option value="Hao hut">Hao hụt</option>
                    <option value="Khac">Khác</option>
                </select>
                <textarea name="note" placeholder="Ghi chú"></textarea>
                <button type="submit" class="btn btn-primary">Lưu phiếu xuất</button>
            </form>
        </div>

        <div class="card table-card">
            <h3>Lịch sử xuất kho</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Sản phẩm</th>
                        <th>Số lượng</th>
                        <th>Lý do</th>
                        <th>Ghi chú</th>
                        <th>Ngày</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<StockIssue> issues = (List<StockIssue>) request.getAttribute("issues");
                        if (issues != null) {
                            for (StockIssue issue : issues) {
                    %>
                    <tr>
                        <td><%= issue.getId() %></td>
                        <td><%= issue.getProductName() %></td>
                        <td><%= issue.getQuantity() %></td>
                        <td><%= issue.getReason() %></td>
                        <td><%= issue.getNote() %></td>
                        <td><%= issue.getCreatedAt() != null ? new SimpleDateFormat("dd/MM/yyyy HH:mm").format(issue.getCreatedAt()) : "--" %></td>
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
