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
    <%@ include file="/WEB-INF/sidebar.jsp" %>

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
