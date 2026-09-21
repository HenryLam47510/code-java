<%@ page import="com._2003store.model.Employee" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý nhân viên - 2003 Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2003store-20260921">
</head>
<body class="dashboard-page">
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

    <main class="main-panel dashboard-shell">
        <div class="workspace-col">
            <header class="topbar modern-topbar">
                <div class="search-box">
                    <span>⌕</span>
                    <input type="text" placeholder="Tìm nhân viên, vai trò, số điện thoại...">
                </div>
                <div class="topbar-actions">
                    <button class="icon-button" type="button" aria-label="Thông báo">
                        🔔
                        <span class="badge-count">7</span>
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
                        <span class="panel-kicker">Nhân sự</span>
                        <h3>Thêm / chỉnh sửa nhân viên</h3>
                    </div>
                </div>
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

            <div class="card form-card">
                <div class="panel-header">
                    <div>
                        <span class="panel-kicker">Cấu hình thanh toán</span>
                        <h3>Tài khoản nhận tiền VietQR</h3>
                    </div>
                </div>
                <%
                    String bankSuccess = request.getParameter("success");
                    String bankError = request.getParameter("error");
                    if (bankSuccess != null && !bankSuccess.isBlank()) {
                %>
                <div class="alert-box"><%= bankSuccess %></div>
                <% }
                    if (bankError != null && !bankError.isBlank()) {
                %>
                <div class="alert-box"><%= bankError %></div>
                <% } %>
                <form action="${pageContext.request.contextPath}/employees" method="post" class="stock-form">
                    <input type="hidden" name="action" value="save-bank-config">
                    <input type="text" name="bankId" placeholder="Mã ngân hàng (VD: MB)" value="${initParam['STORE_BANK_ID'] != null ? initParam['STORE_BANK_ID'] : 'MB'}" required>
                    <input type="text" name="accountNumber" placeholder="Số tài khoản" value="${initParam['STORE_ACCOUNT_NUMBER'] != null ? initParam['STORE_ACCOUNT_NUMBER'] : '050117052004'}" required>
                    <input type="text" name="accountName" placeholder="Tên người nhận" value="${initParam['STORE_ACCOUNT_NAME'] != null ? initParam['STORE_ACCOUNT_NAME'] : 'Hoang Manh Dung'}" required>
                    <button type="submit" class="btn btn-primary">Lưu thông tin ngân hàng</button>
                </form>
            </div>

            <div class="card table-card">
                <div class="section-head">
                    <h3>Danh sách nhân viên</h3>
                    <a href="#" class="table-link">Phân quyền</a>
                </div>
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
                            <td><span class="badge"><%= employee.getRole() %></span></td>
                            <td><%= employee.getPosition() %></td>
                            <td><%= employee.getPhone() %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/employees?action=edit&id=<%= employee.getId() %>" class="btn btn-small">Sửa</a>
                                <a href="${pageContext.request.contextPath}/employees?action=delete&id=<%= employee.getId() %>" class="btn btn-small" onclick="return confirm('Xoá nhân viên này?')">Xoá</a>
                            </td>
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
                    <h4>Hiệu suất</h4>
                    <button class="dismiss-btn" type="button">Xem</button>
                </div>
                <div class="notice">
                    <div class="avatar">NV</div>
                    <div>
                        <h5>Đội ngũ</h5>
                        <p>8 nhân sự đang hoạt động, 2 ca làm sáng/tối.</p>
                    </div>
                </div>
                <div class="notice critical">
                    <div class="avatar">!</div>
                    <div>
                        <h5>Phân quyền</h5>
                        <p>Cần kiểm tra quyền truy cập đối với 2 tài khoản mới.</p>
                    </div>
                </div>
            </div>
        </aside>
    </main>
</body>
</html>
