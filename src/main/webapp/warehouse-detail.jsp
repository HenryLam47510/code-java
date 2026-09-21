<%@ page import="com._2003store.model.WarehouseDetail" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
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
    <title>Chi tiết kho - 2003 Store</title>
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
            <a class="single-link" href="${pageContext.request.contextPath}/stock-out">Xuất kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/inventory-report">Báo cáo kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/suppliers">Nhà cung cấp</a>
            <a class="single-link" href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/employees">Nhân viên</a>
            <a class="single-link active" href="${pageContext.request.contextPath}/warehouse-detail">Chi tiết kho</a>
            <div class="nav-divider"></div>
            <a class="single-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </aside>

    <main class="main-panel">
        <div class="topbar">
            <h1>Chi tiết kho & phân loại</h1>
            <span class="welcome-pill">Xin chào, ${sessionScope.user.fullName}</span>
        </div>

        <div class="stats">
            <div class="card stat stat-blue">
                <h3>Sản phẩm</h3>
                <p>${warehouseDetail.size()}</p>
            </div>
            <div class="card stat stat-green">
                <h3>Tổng tồn kho</h3>
                <p>
                    <%
                        List<WarehouseDetail> items = (List<WarehouseDetail>) request.getAttribute("warehouseDetail");
                        int totalQty = 0;
                        if (items != null) {
                            for (WarehouseDetail item : items) {
                                totalQty += item.getCurrentStock();
                            }
                        }
                        out.print(totalQty);
                    %>
                </p>
            </div>
            <div class="card stat stat-orange">
                <h3>Giá trị dự kiến</h3>
                <p>
                    <%
                        long totalValue = 0;
                        if (items != null) {
                            for (WarehouseDetail item : items) {
                                totalValue += item.getInventoryValue();
                            }
                        }
                        out.print(NumberFormat.getNumberInstance(new Locale("vi", "VN")).format(totalValue) + "₫");
                    %>
                </p>
            </div>
        </div>

        <div class="card table-card">
            <h3>Thống kê theo danh mục và sản phẩm</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Sản phẩm</th>
                        <th>Danh mục</th>
                        <th>Thương hiệu</th>
                        <th>Nhập</th>
                        <th>Xuất</th>
                        <th>Tồn</th>
                        <th>Giá trị tồn</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (items != null) {
                            for (WarehouseDetail item : items) {
                    %>
                    <tr>
                        <td><%= item.getProductId() %></td>
                        <td><%= item.getProductName() %></td>
                        <td><%= item.getCategory() %></td>
                        <td><%= item.getBrand() %></td>
                        <td><%= item.getTotalImported() %></td>
                        <td><%= item.getTotalExported() %></td>
                        <td><%= item.getCurrentStock() %></td>
                        <td><%= NumberFormat.getNumberInstance(new Locale("vi", "VN")).format(item.getInventoryValue()) %>₫</td>
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
