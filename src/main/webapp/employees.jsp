<%@ page import="com._2003store.model.Employee" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý nhân viên - 2003 Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="dashboard-page dashboard-theme">
    <aside class="sidebar">
        <h2>2003 STORE</h2>
        <nav class="sidebar-nav">
            <div class="nav-group">
                <a class="nav-main" href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/dashboard">Tổng quan</a>
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
            <a class="single-link active" href="${pageContext.request.contextPath}/employees">Nhân viên</a>
            <div class="nav-divider"></div>
            <a class="single-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </aside>

    <main class="main-panel">
        <div class="topbar">
            <h1>Quản lý nhân viên & quyền truy cập</h1>
            <span class="welcome-pill">Xin chào, ${sessionScope.user.fullName}</span>
        </div>

        <div class="card form-card">
            <h3>Thêm / chỉnh sửa nhân viên</h3>
            <form action="${pageContext.request.contextPath}/employees" method="post" class="stock-form">
                <input type="hidden" name="id" value="${employeeEdit.id}">
                <input type="text" name="fullName" placeholder="Họ tên" value="${employeeEdit.fullName}" required>
                <input type="text" name="username" placeholder="Tên đăng nhập" value="${employeeEdit.username}" required>
                <input type="password" name="password" placeholder="Mật khẩu" value="${employeeEdit.password}">
                <select name="role" required>
                    <option value="ADMIN" ${employeeEdit.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                    <option value="MANAGER" ${employeeEdit.role == 'MANAGER' ? 'selected' : ''}>Quản lý</option>
                    <option value="STAFF" ${employeeEdit.role == 'STAFF' || employeeEdit.role == null ? 'selected' : ''}>Nhân viên</option>
                </select>
                <input type="text" name="position" placeholder="Vị trí công việc" value="${employeeEdit.position}">
                <input type="text" name="phone" placeholder="Số điện thoại" value="${employeeEdit.phone}">
                <button type="submit" class="btn btn-primary">Lưu nhân viên</button>
            </form>
        </div>

        <div class="card table-card">
            <h3>Danh sách nhân viên</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ tên</th>
                        <th>Username</th>
                        <th>Vai trò</th>
                        <th>Vị trí</th>
                        <th>SĐT</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Employee> employees = (List<Employee>) request.getAttribute("employees");
                        if (employees != null) {
                            for (Employee employee : employees) {
                    %>
                    <tr>
                        <td><%= employee.getId() %></td>
                        <td><%= employee.getFullName() %></td>
                        <td><%= employee.getUsername() %></td>
                        <td><%= employee.getRole() %></td>
                        <td><%= employee.getPosition() %></td>
                        <td><%= employee.getPhone() %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/employees?action=edit&id=<%= employee.getId() %>" class="btn btn-primary">Sửa</a>
                            <a href="${pageContext.request.contextPath}/employees?action=delete&id=<%= employee.getId() %>" class="btn" onclick="return confirm('Xoá nhân viên này?')">Xoá</a>
                        </td>
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
