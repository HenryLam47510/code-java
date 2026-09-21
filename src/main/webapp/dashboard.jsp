<%@ page import="com._2003store.model.Order" %>
<%@ page import="com._2003store.model.OrderNotification" %>
<%@ page import="com._2003store.model.RevenuePoint" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - 2003 Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2003store-20260921">
</head>
<body class="dashboard-page">
    <aside class="sidebar">
        <h2>2003 STORE</h2>
        <nav class="sidebar-nav">
            <div class="nav-group active">
                <a class="nav-main" href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
                <div class="nav-submenu">
                    <a class="active" href="${pageContext.request.contextPath}/dashboard">Tổng quan</a>
                    <a href="${pageContext.request.contextPath}/reports">Báo cáo</a>
                    <a href="${pageContext.request.contextPath}/staff-report">Báo cáo nhân viên</a>
                </div>
            </div>
            <div class="nav-group">
                <a class="nav-main" href="${pageContext.request.contextPath}/products">Sản phẩm</a>
                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/products">Tất cả sản phẩm</a>
                    <a href="${pageContext.request.contextPath}/inventory-report">Báo cáo kho</a>
                    <a href="${pageContext.request.contextPath}/suppliers">Nhà cung cấp</a>
                </div>
            </div>
            <div class="nav-group">
                <a class="nav-main" href="${pageContext.request.contextPath}/orders">Đơn hàng</a>
                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/orders">Danh sách đơn hàng</a>
                    <a href="${pageContext.request.contextPath}/invoices">Hóa đơn</a>
                </div>
            </div>
            <a class="single-link" href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/employees">Nhân viên</a>
            <a class="single-link" href="${pageContext.request.contextPath}/login-history">Lịch sử đăng nhập</a>
            <div class="nav-divider"></div>
            <a class="single-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </aside>

    <main class="main-panel dashboard-shell">
        <div class="workspace-col">
            <header class="topbar modern-topbar">
                <div class="search-box">
                    <span>⌕</span>
                    <input type="text" value="" placeholder="Tìm kiếm đơn hàng, khách hàng, sản phẩm...">
                </div>
                <div class="topbar-actions">
                    <button class="icon-button" type="button" aria-label="Thông báo">
                        🔔
                        <span class="badge-count">10+</span>
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

            <section class="stat-grid">
                <article class="stat-card accent-blue">
                    <div class="stat-meta">
                        <p class="label">Doanh thu hôm nay</p>
                        <span class="icon-pill">↗</span>
                    </div>
                    <p class="value"><%= NumberFormat.getNumberInstance(new Locale("vi", "VN")).format((java.math.BigDecimal) request.getAttribute("todayRevenue")) %>₫</p>
                    <span class="trend">▲ 12.4%</span>
                </article>
                <article class="stat-card accent-green">
                    <div class="stat-meta">
                        <p class="label">Đơn đã thanh toán</p>
                        <span class="icon-pill">✓</span>
                    </div>
                    <p class="value">${totalOrders}</p>
                    <span class="trend">▲ 8.2%</span>
                </article>
                <article class="stat-card accent-orange">
                    <div class="stat-meta">
                        <p class="label">Tiền mặt</p>
                        <span class="icon-pill">◔</span>
                    </div>
                    <p class="value"><%= NumberFormat.getNumberInstance(new Locale("vi", "VN")).format((java.math.BigDecimal) request.getAttribute("todayRevenue")) %>₫</p>
                    <span class="trend">▲ 5.1%</span>
                </article>
                <article class="stat-card accent-purple">
                    <div class="stat-meta">
                        <p class="label">Chuyển khoản</p>
                        <span class="icon-pill">⬢</span>
                    </div>
                    <p class="value"><%= NumberFormat.getNumberInstance(new Locale("vi", "VN")).format((java.math.BigDecimal) request.getAttribute("thisMonthRevenue")) %>₫</p>
                    <span class="trend">▲ 9.3%</span>
                </article>
            </section>

            <section class="panel chart-panel">
                <div class="panel-header">
                    <div>
                        <span class="panel-kicker">Báo cáo</span>
                        <h3>Biểu đồ doanh thu</h3>
                    </div>
                    <div class="segmented-control">
                        <a href="${pageContext.request.contextPath}/reports?view=day" class="segment-button active">Ngày</a>
                        <a href="${pageContext.request.contextPath}/reports?view=month" class="segment-button">Tháng</a>
                        <a href="${pageContext.request.contextPath}/reports?view=year" class="segment-button">Năm</a>
                    </div>
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
                    <div class="empty-chart">Chưa có dữ liệu doanh thu trong khoảng thời gian hiện tại.</div>
                    <% } %>
                </div>
            </section>

            <div class="table-card">
                <div class="section-head">
                    <h3>Đơn hàng gần đây</h3>
                    <a href="${pageContext.request.contextPath}/orders" class="table-link">Xem tất cả</a>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>Mã đơn</th>
                            <th>Khách hàng</th>
                            <th>Ngày tạo</th>
                            <th>Trạng thái</th>
                            <th>Tổng tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Order> orders = (List<Order>) request.getAttribute("recentOrders");
                            if (orders != null) {
                                for (Order order : orders) {
                        %>
                        <tr>
                            <td>#<%= order.getId() %></td>
                            <td><%= order.getCustomerName() %></td>
                            <td><%= order.getCreatedAt() != null ? new SimpleDateFormat("dd/MM/yyyy HH:mm").format(order.getCreatedAt()) : "--" %></td>
                            <td><span class="badge"><%= order.getStatus() %></span></td>
                            <td><%= order.getTotalAmount() %>₫</td>
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
                    <h4>Thông báo</h4>
                    <button class="dismiss-btn" type="button">Tắt</button>
                </div>
                <%
                    List<OrderNotification> notifications = (List<OrderNotification>) request.getAttribute("notifications");
                    if (notifications != null && !notifications.isEmpty()) {
                        for (OrderNotification notification : notifications) {
                %>
                <a class="notice" href="${pageContext.request.contextPath}/orders?detailId=<%= notification.getOrderId() %>">
                    <div class="avatar"><%= notification.getType().substring(0, 1).toUpperCase() %></div>
                    <div>
                        <h5><%= notification.getTitle() %></h5>
                        <p><%= notification.getMessage() %></p>
                        <small><%= notification.getStatus() %></small>
                    </div>
                </a>
                <%
                        }
                    }
                %>
            </div>

            <div class="order-card">
                <div class="mini-row">
                    <h4>Đơn cần xử lý</h4>
                    <span class="pill pill-warning">${pendingOrdersCount}</span>
                </div>
                <div class="order-item">
                    <div class="product-thumb">👟</div>
                    <div class="order-info">
                        <h5>DH001</h5>
                        <p>Nguyễn Văn A</p>
                    </div>
                    <div class="order-price">1.250.000₫</div>
                </div>
                <button class="primary-action" type="button">Xem chi tiết</button>
            </div>

            <div class="quick-card">
                <div class="mini-row">
                    <h4>Sản phẩm sắp hết</h4>
                    <span class="pill pill-danger">${lowStockCount}</span>
                </div>
                <div class="product-preview">
                    <div class="preview-box">👟</div>
                    <div class="mini-row">
                        <div>
                            <h5>Air Max 270</h5>
                            <p>Còn 3 đôi</p>
                        </div>
                        <span class="pill pill-success">Cảnh báo</span>
                    </div>
                </div>
            </div>
        </aside>
    </main>
</body>
</html>
