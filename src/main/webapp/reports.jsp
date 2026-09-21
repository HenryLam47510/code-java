<%@ page import="com._2003store.model.RevenuePoint" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.math.BigDecimal" %>
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
    <title>Báo cáo doanh thu - 2003 Store</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                        <a class="active" href="${pageContext.request.contextPath}/reports">Doanh thu</a>
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
                        <% if (canAccessCustomers) { %><a href="${pageContext.request.contextPath}/customers">Khách hàng</a><% } %>
                        <% if (canAccessInventory) { %><a href="${pageContext.request.contextPath}/stock">Nhập kho</a><a href="${pageContext.request.contextPath}/stock-out">Xuất kho</a><a href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a><% } %>
                        <% if (canAccessReports) { %><a href="${pageContext.request.contextPath}/inventory-report">Báo cáo kho</a><a class="active" href="${pageContext.request.contextPath}/reports">Doanh thu</a><% } %>
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

    <main class="main-panel dashboard-shell">
        <div class="workspace-col">
            <header class="topbar modern-topbar">
                <div class="search-box">
                    <span>⌕</span>
                    <input type="text" placeholder="Tìm báo cáo theo thời gian...">
                </div>
                <div class="topbar-actions">
                    <button class="icon-button" type="button" aria-label="Thông báo">
                        🔔
                        <span class="badge-count">6</span>
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
                        <span class="panel-kicker">Báo cáo</span>
                        <h3>Chọn khoảng thời gian</h3>
                    </div>
                </div>
                <form class="report-filter" method="get" action="${pageContext.request.contextPath}/reports">
                    <input type="date" name="from" value="${from}">
                    <input type="date" name="to" value="${to}">
                    <input type="hidden" name="view" value="${selectedView != null ? selectedView : 'day'}">
                    <button type="submit" class="btn btn-primary">Lọc báo cáo</button>
                </form>
                <div class="segmented-control report-mode">
                    <a href="${pageContext.request.contextPath}/reports?view=day" class="segment-button ${selectedView == 'day' ? 'active' : ''}">Theo ngày</a>
                    <a href="${pageContext.request.contextPath}/reports?view=month" class="segment-button ${selectedView == 'month' ? 'active' : ''}">Theo tháng</a>
                    <a href="${pageContext.request.contextPath}/reports?view=year" class="segment-button ${selectedView == 'year' ? 'active' : ''}">Theo năm</a>
                </div>
            </div>

            <div class="card chart-box">
                <div class="section-head">
                    <h3>Biểu đồ doanh thu</h3>
                    <span class="muted">${selectedView == 'month' ? 'Theo tháng' : selectedView == 'year' ? 'Theo năm' : 'Theo ngày'}</span>
                </div>
                <div class="chart-wrap revenue-chart">
                    <%
                        List<RevenuePoint> revenueSeries = (List<RevenuePoint>) request.getAttribute("revenueSeries");
                        BigDecimal maxRevenue = BigDecimal.ZERO;
                        if (revenueSeries != null) {
                            for (RevenuePoint point : revenueSeries) {
                                if (point.getValue() != null && point.getValue().compareTo(maxRevenue) > 0) {
                                    maxRevenue = point.getValue();
                                }
                            }
                        }
                        if (revenueSeries != null && !revenueSeries.isEmpty()) {
                            for (RevenuePoint point : revenueSeries) {
                                BigDecimal heightPercent = maxRevenue.compareTo(BigDecimal.ZERO) == 0 ? BigDecimal.ZERO : point.getValue().multiply(BigDecimal.valueOf(100)).divide(maxRevenue, 2, java.math.RoundingMode.HALF_UP);
                    %>
                    <div class="bar-col">
                        <span class="bar-value"><%= NumberFormat.getNumberInstance(new Locale("vi", "VN")).format(point.getValue()) %>₫</span>
                        <div class="bar-fill" style="height: <%= heightPercent %>%;"></div>
                        <span class="day-label"><%= point.getLabel() %></span>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div class="empty-chart">Chưa có dữ liệu doanh thu cho khoảng thời gian đã chọn.</div>
                    <% } %>
                </div>
            </div>
        </div>

        <aside class="right-rail">
            <div class="notification-card">
                <div class="notification-header">
                    <h4>Tóm tắt</h4>
                    <button class="dismiss-btn" type="button">Xuất</button>
                </div>
                <div class="notice">
                    <div class="avatar">₹</div>
                    <div>
                        <h5>Doanh thu</h5>
                        <p><strong>${totalRevenue}</strong> tổng doanh thu hiện tại.</p>
                    </div>
                </div>
                <div class="notice critical">
                    <div class="avatar">!</div>
                    <div>
                        <h5>Chỉ số</h5>
                        <p>Tỷ lệ hoàn thành đơn trong tháng là 94%.</p>
                    </div>
                </div>
            </div>
        </aside>
    </main>

</body>
</html>
