<%@ page pageEncoding="UTF-8" %>
<%
    com._2003store.model.User sharedSidebarUser = (com._2003store.model.User) session.getAttribute("user");
    com._2003store.service.AuthService sharedSidebarAuth = new com._2003store.service.AuthService();
    String sharedSidebarRole = com._2003store.service.AuthService.normalizeRole(sharedSidebarUser != null ? sharedSidebarUser.getRole() : null);
    String sharedSidebarPath = request.getServletPath();
    String sharedSidebarDashboard = com._2003store.service.AuthService.getDashboardPath(sharedSidebarUser);
    boolean sharedSidebarAdmin = "ADMIN".equals(sharedSidebarRole);
    boolean sharedSidebarManager = "MANAGER".equals(sharedSidebarRole);
    boolean sharedSidebarEmployee = "EMPLOYEE".equals(sharedSidebarRole);
%>
<aside class="sidebar">
    <h2>2003 STORE</h2>
    <nav class="sidebar-nav" aria-label="Menu chính">
        <% if (sharedSidebarAdmin || sharedSidebarManager || sharedSidebarEmployee) { %>
            <a class="single-link <%= sharedSidebarPath.equals(sharedSidebarDashboard) ? "active" : "" %>" href="${pageContext.request.contextPath}<%= sharedSidebarDashboard %>">Tổng quan</a>
        <% } %>
        <% if (sharedSidebarAdmin || sharedSidebarManager || (sharedSidebarUser != null && sharedSidebarAuth.hasAccess(sharedSidebarUser, "orders"))) { %>
            <a class="single-link <%= "/orders".equals(sharedSidebarPath) ? "active" : "" %>" href="${pageContext.request.contextPath}/orders"><%= sharedSidebarEmployee ? "Bán hàng & Đơn hàng" : "Đơn hàng" %></a>
        <% } %>
        <% if (sharedSidebarAdmin || (sharedSidebarManager && sharedSidebarUser != null && sharedSidebarAuth.hasAccess(sharedSidebarUser, "orders"))) { %>
            <% if (!sharedSidebarEmployee) { %><a class="single-link <%= "/invoices".equals(sharedSidebarPath) ? "active" : "" %>" href="${pageContext.request.contextPath}/invoices">Hóa đơn</a><% } %>
        <% } %>
        <% if (sharedSidebarAdmin || sharedSidebarManager || (sharedSidebarUser != null && sharedSidebarAuth.hasAccess(sharedSidebarUser, "products"))) { %>
            <a class="single-link <%= "/products".equals(sharedSidebarPath) ? "active" : "" %>" href="${pageContext.request.contextPath}/products"><%= sharedSidebarEmployee ? "Tra cứu sản phẩm" : "Sản phẩm" %></a>
        <% } %>
        <% if (sharedSidebarAdmin || sharedSidebarManager || (sharedSidebarUser != null && sharedSidebarAuth.hasAccess(sharedSidebarUser, "customers"))) { %>
            <a class="single-link <%= "/customers".equals(sharedSidebarPath) ? "active" : "" %>" href="${pageContext.request.contextPath}/customers">Khách hàng</a>
        <% } %>
        <% if (sharedSidebarAdmin || sharedSidebarManager) { %>
            <a class="single-link <%= "/stock".equals(sharedSidebarPath) ? "active" : "" %>" href="${pageContext.request.contextPath}/stock">Nhập kho</a>
            <a class="single-link <%= "/stock-out".equals(sharedSidebarPath) ? "active" : "" %>" href="${pageContext.request.contextPath}/stock-out">Xuất kho</a>
            <a class="single-link <%= "/inventory-check".equals(sharedSidebarPath) ? "active" : "" %>" href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a>
            <a class="single-link <%= "/suppliers".equals(sharedSidebarPath) ? "active" : "" %>" href="${pageContext.request.contextPath}/suppliers">Nhà cung cấp</a>
        <% } %>
        <% if (sharedSidebarAdmin || sharedSidebarManager) { %>
            <a class="single-link <%= "/inventory-report".equals(sharedSidebarPath) ? "active" : "" %>" href="${pageContext.request.contextPath}/inventory-report">Báo cáo kho</a>
            <a class="single-link <%= "/reports".equals(sharedSidebarPath) ? "active" : "" %>" href="${pageContext.request.contextPath}/reports">Doanh thu</a>
            <a class="single-link <%= "/staff-report".equals(sharedSidebarPath) ? "active" : "" %>" href="${pageContext.request.contextPath}/staff-report">Báo cáo nhân viên</a>
        <% } %>
        <% if (sharedSidebarAdmin || (sharedSidebarManager && sharedSidebarUser != null && sharedSidebarAuth.hasAccess(sharedSidebarUser, "employees"))) { %>
            <a class="single-link <%= "/employees".equals(sharedSidebarPath) ? "active" : "" %>" href="${pageContext.request.contextPath}/employees">Nhân viên</a>
        <% } %>
        <% if (sharedSidebarAdmin || (sharedSidebarManager && sharedSidebarUser != null && sharedSidebarAuth.hasAccess(sharedSidebarUser, "login-history"))) { %>
            <a class="single-link <%= "/login-history".equals(sharedSidebarPath) ? "active" : "" %>" href="${pageContext.request.contextPath}/login-history">Lịch sử hệ thống</a>
        <% } %>
        <% if (sharedSidebarEmployee && sharedSidebarUser != null && sharedSidebarAuth.hasAccess(sharedSidebarUser, "payment_confirm")) { %>
            <a class="single-link" href="${pageContext.request.contextPath}/orders">Xác nhận thanh toán</a>
        <% } %>
        <div class="nav-divider"></div>
        <a class="single-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
    </nav>
</aside>
