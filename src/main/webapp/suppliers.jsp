<%@ page import="com._2003store.model.Supplier" %>
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
    <title>Quản lý nhà cung cấp - 2003 Store</title>
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
            <a class="single-link active" href="${pageContext.request.contextPath}/suppliers">Nhà cung cấp</a>
            <a class="single-link" href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/employees">Nhân viên</a>
            <div class="nav-divider"></div>
            <a class="single-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </aside>

    <main class="main-panel">
        <div class="topbar">
            <h1>Quản lý nhà cung cấp</h1>
            <span>Xin chào, ${sessionScope.user.fullName}</span>
        </div>

        <div class="card form-card">
            <h3>Thông tin nhà cung cấp</h3>
            <form action="${pageContext.request.contextPath}/suppliers/add" method="post" class="supplier-form">
                <input type="hidden" name="action" value="add">
                <input type="text" name="name" placeholder="Tên nhà cung cấp" required>
                <input type="text" name="phone" placeholder="Số điện thoại" required>
                <input type="email" name="email" placeholder="Email">
                <input type="text" name="address" placeholder="Địa chỉ">
                <textarea name="note" placeholder="Ghi chú"></textarea>
                <button type="submit" class="btn btn-primary">Thêm nhà cung cấp</button>
            </form>
        </div>

        <div class="card table-card">
            <h3>Danh sách nhà cung cấp</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên</th>
                        <th>SĐT</th>
                        <th>Email</th>
                        <th>Địa chỉ</th>
                        <th>Ghi chú</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Supplier> suppliers = (List<Supplier>) request.getAttribute("suppliers");
                        if (suppliers != null) {
                            for (Supplier supplier : suppliers) {
                    %>
                    <tr>
                        <td><%= supplier.getId() %></td>
                        <td><%= supplier.getName() %></td>
                        <td><%= supplier.getPhone() %></td>
                        <td><%= supplier.getEmail() %></td>
                        <td><%= supplier.getAddress() %></td>
                        <td><%= supplier.getNote() %></td>
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
