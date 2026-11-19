<%@ page import="com._2003store.model.Order" %>
<%@ page import="com._2003store.model.OrderNotification" %>
<%@ page import="com._2003store.model.RevenuePoint" %>
<%@ page import="com._2003store.model.User" %>
<%@ page import="com._2003store.service.AuthService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.math.BigDecimal" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String dashboardKey = (String) request.getAttribute("dashboardKey");
    AuthService authService = new AuthService();
    if (dashboardKey == null && currentUser != null) {
        dashboardKey = AuthService.getDashboardKey(currentUser);
    }
    if (dashboardKey == null) {
        dashboardKey = "employee";
    }
    boolean isAdmin = currentUser != null && authService.isAdmin(currentUser);
    boolean isManager = currentUser != null && authService.isManager(currentUser);
    boolean isEmployee = currentUser != null && authService.isEmployee(currentUser);
    boolean canAccessOrders = currentUser != null && authService.hasAccess(currentUser, "orders");
    boolean canAccessProducts = currentUser != null && authService.hasAccess(currentUser, "products");
    boolean canAccessCustomers = currentUser != null && authService.hasAccess(currentUser, "customers");
    boolean canAccessReports = currentUser != null && authService.hasAccess(currentUser, "reports");
    boolean canAccessStaffReport = currentUser != null && authService.hasAccess(currentUser, "staff-report");
    boolean canAccessEmployees = currentUser != null && authService.hasAccess(currentUser, "employees");
    boolean canAccessInventory = currentUser != null && authService.hasAccess(currentUser, "inventory-check");
    boolean canAccessSuppliers = currentUser != null && authService.hasAccess(currentUser, "suppliers");
    boolean canAccessLoginHistory = currentUser != null && authService.hasAccess(currentUser, "login-history");
    boolean canConfirmPayment = currentUser != null && authService.hasAccess(currentUser, "payment_confirm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - 2003 Store</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2003store-20260921">
</head>
<body class="dashboard-page">
    <%@ include file="/WEB-INF/sidebar.jsp" %>

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
                        <span class="badge-count">${pendingOrdersCount}</span>
                    </button>
                    <div class="user-mini">
                        <div class="avatar">${sessionScope.user.fullName.substring(0,1)}</div>
                        <div>
                            <strong>${sessionScope.user.fullName}</strong>
                            <small>
                                <% if ("admin".equals(dashboardKey)) { %>
                                    ADMIN
                                <% } else if ("manager".equals(dashboardKey)) { %>
                                    MANAGER
                                <% } else { %>
                                    EMPLOYEE
                                <% } %>
                            </small>
                        </div>
                    </div>
                </div>
            </header>

            <section class="stat-grid">
                <% com._2003store.model.RevenueSummary todayRevenue = (com._2003store.model.RevenueSummary) request.getAttribute("todayRevenue"); %>
                <article class="stat-card accent-blue">
                    <div class="stat-meta">
                        <p class="label">Doanh thu hôm nay</p>
                        <span class="icon-pill">↗</span>
                    </div>
                    <p class="value"><%= NumberFormat.getNumberInstance(new Locale("vi", "VN")).format(todayRevenue.getTotalRevenue()) %>₫</p>
                    <span class="trend">Đơn thanh toán thành công</span>
                </article>
                <article class="stat-card accent-green">
                    <div class="stat-meta">
                        <p class="label">Đơn đã thanh toán</p>
                        <span class="icon-pill">✓</span>
                    </div>
                    <p class="value"><%= todayRevenue.getPaidOrders() %></p>
                    <span class="trend">Trong ngày hôm nay</span>
                </article>
                <article class="stat-card accent-orange">
                    <div class="stat-meta">
                        <p class="label">Tiền mặt</p>
                        <span class="icon-pill">◔</span>
                    </div>
                    <p class="value"><%= NumberFormat.getNumberInstance(new Locale("vi", "VN")).format(todayRevenue.getCashRevenue()) %>₫</p>
                    <span class="trend">COD trong ngày</span>
                </article>
                <article class="stat-card accent-purple">
                    <div class="stat-meta">
                        <p class="label">Chuyển khoản</p>
                        <span class="icon-pill">⬢</span>
                    </div>
                    <p class="value"><%= NumberFormat.getNumberInstance(new Locale("vi", "VN")).format(todayRevenue.getTransferRevenue()) %>₫</p>
                    <span class="trend">Chuyển khoản và ví điện tử</span>
                </article>
            </section>

            <section class="analytics-section" aria-labelledby="analyticsTitle">
                <div class="analytics-heading">
                    <div>
                        <span class="panel-kicker">Thống kê / Phân tích dữ liệu</span>
                        <h2 id="analyticsTitle">Hiệu quả sản phẩm</h2>
                    </div>
                    <form class="analytics-filter" method="get" action="${pageContext.request.contextPath}/dashboard">
                        <label for="salesPeriod">Khoảng thời gian</label>
                        <select id="salesPeriod" name="period">
                            <option value="today" ${salesPeriod == 'today' ? 'selected' : ''}>Hôm nay</option>
                            <option value="week" ${salesPeriod == 'week' ? 'selected' : ''}>7 ngày qua</option>
                            <option value="month" ${salesPeriod == 'month' ? 'selected' : ''}>Tháng này</option>
                            <option value="year" ${salesPeriod == 'year' ? 'selected' : ''}>Năm nay</option>
                            <option value="custom" ${salesPeriod == 'custom' ? 'selected' : ''}>Tùy chọn</option>
                        </select>
                        <div class="analytics-date-range" id="salesDateRange" ${salesPeriod != 'custom' ? 'hidden' : ''}>
                            <label class="visually-hidden" for="salesFrom">Từ ngày</label>
                            <input id="salesFrom" type="date" name="from" value="${salesFrom}">
                            <span aria-hidden="true">đến</span>
                            <label class="visually-hidden" for="salesTo">Đến ngày</label>
                            <input id="salesTo" type="date" name="to" value="${salesTo}">
                        </div>
                        <button class="btn btn-primary" type="submit">Cập nhật</button>
                    </form>
                </div>

                <div class="analytics-stats">
                    <article class="analytics-stat">
                        <span>Tổng sản phẩm</span>
                        <strong>${totalProducts}</strong>
                    </article>
                    <article class="analytics-stat">
                        <span>Tổng thể loại</span>
                        <strong>${totalCategories}</strong>
                    </article>
                    <article class="analytics-stat">
                        <span>Đã bán trong kỳ</span>
                        <strong>${totalUnitsSold}</strong>
                    </article>
                    <article class="analytics-stat">
                        <span>Bán chạy nhất trong kỳ</span>
                        <c:choose>
                            <c:when test="${not empty bestSeller}">
                                <strong class="analytics-stat-name" title="${fn:escapeXml(bestSeller.productName)}"><c:out value="${bestSeller.productName}"/></strong>
                                <small>${bestSeller.quantitySold} đôi</small>
                            </c:when>
                            <c:otherwise><strong class="analytics-stat-name">Chưa có dữ liệu</strong></c:otherwise>
                        </c:choose>
                    </article>
                    <article class="analytics-stat">
                        <span>Thể loại nhiều sản phẩm nhất</span>
                        <c:choose>
                            <c:when test="${not empty topCategory}">
                                <strong class="analytics-stat-name"><c:out value="${topCategory.categoryName}"/></strong>
                                <small>${topCategory.productCount} sản phẩm</small>
                            </c:when>
                            <c:otherwise><strong class="analytics-stat-name">Chưa có dữ liệu</strong></c:otherwise>
                        </c:choose>
                    </article>
                </div>

                <div class="analytics-grid">
                    <article class="analytics-panel">
                        <div class="section-head">
                            <h3>Top 5 sản phẩm bán chạy</h3>
                            <span class="muted">${salesFrom} - ${salesTo}</span>
                        </div>
                        <div class="sales-ranking-table-wrap">
                            <table class="sales-ranking-table">
                                <thead>
                                    <tr><th scope="col">#</th><th scope="col">Sản phẩm</th><th scope="col">Đã bán</th><th scope="col">Doanh thu</th></tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty topProducts}">
                                            <c:forEach items="${topProducts}" var="item" varStatus="loop">
                                                <tr>
                                                    <td>${loop.count}</td>
                                                    <td><c:out value="${item.productName}"/></td>
                                                    <td><fmt:formatNumber value="${item.quantitySold}" type="number"/> đôi</td>
                                                    <td><fmt:formatNumber value="${item.revenue}" type="number" maxFractionDigits="0"/>₫</td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr><td colspan="4" class="sales-ranking-empty">Chưa có sản phẩm được bán trong kỳ này.</td></tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </article>

                    <article class="analytics-panel">
                        <div class="section-head">
                            <h3>Top 5 sản phẩm bán chậm</h3>
                            <span class="muted">${salesFrom} - ${salesTo}</span>
                        </div>
                        <div class="sales-ranking-table-wrap">
                            <table class="sales-ranking-table">
                                <thead>
                                    <tr><th scope="col">#</th><th scope="col">Sản phẩm</th><th scope="col">Đã bán</th><th scope="col">Doanh thu</th></tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty slowProducts}">
                                            <c:forEach items="${slowProducts}" var="item" varStatus="loop">
                                                <tr>
                                                    <td>${loop.count}</td>
                                                    <td><c:out value="${item.productName}"/></td>
                                                    <td><fmt:formatNumber value="${item.quantitySold}" type="number"/> đôi</td>
                                                    <td><fmt:formatNumber value="${item.revenue}" type="number" maxFractionDigits="0"/>₫</td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr><td colspan="4" class="sales-ranking-empty">Chưa có sản phẩm để thống kê.</td></tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </article>

                    <article class="analytics-panel category-analytics-panel">
                        <div class="section-head">
                            <h3>Cơ cấu sản phẩm theo thể loại</h3>
                            <span class="muted">Sản phẩm đang hoạt động</span>
                        </div>
                        <c:choose>
                            <c:when test="${not empty categories}">
                                <div class="category-chart-layout">
                                    <div class="category-chart"><canvas id="categoryChart" aria-label="Biểu đồ tỷ trọng sản phẩm theo thể loại" role="img"></canvas></div>
                                    <ul class="category-legend">
                                        <c:forEach items="${categories}" var="category">
                                            <li><span class="category-name"><c:out value="${category.categoryName}"/></span><strong>${category.productCount}</strong><small><fmt:formatNumber value="${category.percentage}" maxFractionDigits="1"/>%</small></li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </c:when>
                            <c:otherwise><p class="empty-chart">Chưa có sản phẩm để thống kê thể loại.</p></c:otherwise>
                        </c:choose>
                        <div class="chart-data" id="categoryData">
                            <c:forEach items="${categories}" var="category"><span data-label="${fn:escapeXml(category.categoryName)}" data-value="${category.productCount}"></span></c:forEach>
                        </div>
                    </article>
                </div>
            </section>

            <section class="panel revenue-overview-panel" aria-labelledby="revenueOverviewTitle">
                <div class="panel-header revenue-panel-header">
                    <div>
                        <span class="panel-kicker">Báo cáo</span>
                        <h3 id="revenueOverviewTitle">Tổng quan doanh thu</h3>
                    </div>
                    <div class="segmented-control" aria-label="Chọn kỳ doanh thu">
                        <a href="${pageContext.request.contextPath}/dashboard?view=day" class="segment-button <%= "day".equals(request.getAttribute("revenueView")) ? "active" : "" %>">Ngày</a>
                        <a href="${pageContext.request.contextPath}/dashboard?view=month" class="segment-button <%= "month".equals(request.getAttribute("revenueView")) ? "active" : "" %>">Tháng</a>
                        <a href="${pageContext.request.contextPath}/dashboard?view=year" class="segment-button <%= "year".equals(request.getAttribute("revenueView")) ? "active" : "" %>">Năm</a>
                    </div>
                </div>

                <div class="revenue-summary">
                    <div>
                        <span class="revenue-summary-label">Doanh thu trong kỳ</span>
                        <strong class="revenue-summary-value"><%= NumberFormat.getNumberInstance(new Locale("vi", "VN")).format((BigDecimal) request.getAttribute("periodRevenue")) %>₫</strong>
                    </div>
                    <%
                        BigDecimal previousRevenue = (BigDecimal) request.getAttribute("previousPeriodRevenue");
                        BigDecimal currentRevenue = (BigDecimal) request.getAttribute("periodRevenue");
                        String changeClass = "trend-neutral";
                        String changeText = "Chưa có dữ liệu so sánh";
                        if (previousRevenue != null && previousRevenue.compareTo(BigDecimal.ZERO) > 0 && currentRevenue != null) {
                            BigDecimal change = currentRevenue.subtract(previousRevenue)
                                    .multiply(BigDecimal.valueOf(100))
                                    .divide(previousRevenue, 1, java.math.RoundingMode.HALF_UP);
                            if (change.compareTo(BigDecimal.ZERO) > 0) {
                                changeClass = "trend-up";
                                changeText = "↑ " + change.toPlainString().replace(".0", "") + "% so với kỳ trước";
                            } else if (change.compareTo(BigDecimal.ZERO) < 0) {
                                changeClass = "trend-down";
                                changeText = "↓ " + change.abs().toPlainString().replace(".0", "") + "% so với kỳ trước";
                            } else {
                                changeText = "Không thay đổi so với kỳ trước";
                            }
                        }
                    %>
                    <span class="revenue-change <%= changeClass %>"><%= changeText %></span>
                </div>

                <div class="revenue-chart-container">
                    <%
                        List<RevenuePoint> revenueSeries = (List<RevenuePoint>) request.getAttribute("revenueSeries");
                        boolean hasRevenue = revenueSeries != null && revenueSeries.stream().anyMatch(p -> p.getValue() != null && p.getValue().compareTo(BigDecimal.ZERO) > 0);
                    %>
                    <% if (hasRevenue) { %>
                        <canvas id="revenueChart" aria-label="Biểu đồ doanh thu theo thời gian" role="img"></canvas>
                        <div class="chart-data" id="revenueData">
                            <c:forEach items="${revenueSeries}" var="point">
                                <span data-label="<c:out value='${point.label}'/>" data-value="${point.value}"></span>
                            </c:forEach>
                        </div>
                    <% } else { %>
                        <div class="empty-chart empty-revenue-chart">
                            <span class="empty-chart-icon">↗</span>
                            <strong>Chưa có giao dịch trong kỳ</strong>
                            <small>Doanh thu sẽ hiển thị tại đây khi có đơn thanh toán.</small>
                        </div>
                    <% } %>
                </div>

                <div class="revenue-panel-footer">
                    <c:choose>
                        <c:when test="<%= canAccessReports %>">
                            <a class="table-link" href="${pageContext.request.contextPath}/reports?view=<%= request.getAttribute("revenueView") %>">Xem báo cáo chi tiết →</a>
                        </c:when>
                        <c:otherwise>
                            <span class="muted">Báo cáo chi tiết chỉ dành cho vai trò được cấp quyền</span>
                        </c:otherwise>
                    </c:choose>
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
            <div class="notification-card" id="dashboardNotificationCard">
                <div class="notification-header">
                    <h4>Thông báo</h4>
                    <button class="dismiss-btn" type="button" onclick="document.getElementById('dashboardNotificationCard').style.display='none'">Tắt</button>
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
            <script>
                setTimeout(function () {
                    const card = document.getElementById('dashboardNotificationCard');
                    if (card) card.style.display = 'none';
                }, 15000);
            </script>

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
    <script>
        const salesPeriod = document.getElementById('salesPeriod');
        const salesDateRange = document.getElementById('salesDateRange');
        const salesDates = salesDateRange.querySelectorAll('input[type="date"]');
        function updateSalesDateRange() {
            const isCustom = salesPeriod.value === 'custom';
            salesDateRange.hidden = !isCustom;
            salesDates.forEach(function (input) {
                input.required = isCustom;
                input.disabled = !isCustom;
            });
        }
        salesPeriod.addEventListener('change', updateSalesDateRange);
        updateSalesDateRange();

        const revenueCanvas = document.getElementById('revenueChart');
        const revenueDataElement = document.getElementById('revenueData');
        if (revenueCanvas && revenueDataElement) {
            const revenueData = readChartData('revenueData');
            new Chart(revenueCanvas, {
                type: 'line',
                data: {
                    labels: revenueData.map(function (item) { return item.label; }),
                    datasets: [{
                        label: 'Doanh thu',
                        data: revenueData.map(function (item) { return item.value; }),
                        borderColor: '#2563eb',
                        backgroundColor: 'rgba(37, 99, 235, 0.12)',
                        pointBackgroundColor: '#2563eb',
                        pointBorderColor: '#ffffff',
                        pointBorderWidth: 2,
                        pointRadius: 4,
                        pointHoverRadius: 6,
                        borderWidth: 3,
                        tension: 0.35,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    interaction: { mode: 'index', intersect: false },
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            backgroundColor: '#0f172a',
                            titleColor: '#e2e8f0',
                            bodyColor: '#ffffff',
                            padding: 12,
                            cornerRadius: 10,
                            callbacks: {
                                label: function (context) {
                                    return 'Doanh thu: ' + new Intl.NumberFormat('vi-VN').format(context.parsed.y) + ' ₫';
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            title: { display: true, text: '<%= "year".equals(request.getAttribute("revenueView")) ? "Năm" : ("month".equals(request.getAttribute("revenueView")) ? "Tháng" : "Ngày") %>', color: '#64748b' },
                            grid: { display: false },
                            ticks: { color: '#64748b', maxRotation: 0 }
                        },
                        y: {
                            beginAtZero: true,
                            title: { display: true, text: 'Doanh thu (₫)', color: '#64748b' },
                            grid: { color: 'rgba(148, 163, 184, 0.16)' },
                            ticks: {
                                color: '#64748b',
                                callback: function (value) {
                                    if (value >= 1000000000) return (value / 1000000000).toFixed(1).replace('.0', '') + ' tỷ';
                                    if (value >= 1000000) return (value / 1000000).toFixed(1).replace('.0', '') + ' tr';
                                    if (value >= 1000) return (value / 1000).toFixed(1).replace('.0', '') + 'k';
                                    return value;
                                }
                            }
                        }
                    }
                }
            });
        }

        const chartColors = ['#2563eb', '#f97316', '#16a34a', '#dc2626', '#0d9488', '#ca8a04', '#64748b'];
        function readChartData(elementId) {
            return Array.from(document.querySelectorAll('#' + elementId + ' span')).map(function (item) {
                return {
                    label: item.dataset.label,
                    value: Number(item.dataset.value),
                    revenue: Number(item.dataset.revenue || 0)
                };
            });
        }
        const categoryCanvas = document.getElementById('categoryChart');
        const categoryData = readChartData('categoryData');
        if (categoryCanvas && categoryData.length > 0) {
            new Chart(categoryCanvas, {
                type: 'pie',
                data: {
                    labels: categoryData.map(function (item) { return item.label; }),
                    datasets: [{
                        data: categoryData.map(function (item) { return item.value; }),
                        backgroundColor: categoryData.map(function (_, index) { return chartColors[index % chartColors.length]; }),
                        borderColor: '#ffffff',
                        borderWidth: 2
                    }]
                },
                options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } } }
            });
        }
    </script>
</body>
</html>
