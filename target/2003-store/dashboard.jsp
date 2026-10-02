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
                        <span class="badge-count">10+</span>
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
                        <div class="analytics-chart">
                            <c:choose>
                                <c:when test="${not empty topProducts}"><canvas id="topProductsChart" aria-label="Biểu đồ top sản phẩm bán chạy" role="img"></canvas></c:when>
                                <c:otherwise><p class="empty-chart">Chưa có đơn đã thanh toán trong khoảng thời gian này.</p></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="chart-data" id="topProductsData">
                            <c:forEach items="${topProducts}" var="item"><span data-label="${fn:escapeXml(item.productName)}" data-value="${item.quantitySold}" data-revenue="${item.revenue}"></span></c:forEach>
                        </div>
                    </article>

                    <article class="analytics-panel">
                        <div class="section-head">
                            <h3>Top 5 sản phẩm bán chậm</h3>
                            <span class="muted">${salesFrom} - ${salesTo}</span>
                        </div>
                        <div class="analytics-chart">
                            <c:choose>
                                <c:when test="${not empty slowProducts}"><canvas id="slowProductsChart" aria-label="Biểu đồ top sản phẩm bán chậm" role="img"></canvas></c:when>
                                <c:otherwise><p class="empty-chart">Chưa có sản phẩm để thống kê.</p></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="chart-data" id="slowProductsData">
                            <c:forEach items="${slowProducts}" var="item"><span data-label="${fn:escapeXml(item.productName)}" data-value="${item.quantitySold}"></span></c:forEach>
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
        function renderRankingChart(canvasId, dataId, showRevenue) {
            const canvas = document.getElementById(canvasId);
            const data = readChartData(dataId);
            if (!canvas || data.length === 0) return;
            new Chart(canvas, {
                type: 'bar',
                data: {
                    labels: data.map(function (item) { return item.label; }),
                    datasets: [{
                        label: 'Số đôi đã bán',
                        data: data.map(function (item) { return item.value; }),
                        backgroundColor: ['#2563eb', '#0d9488', '#16a34a', '#f97316', '#dc2626'],
                        borderRadius: 4,
                        maxBarThickness: 30
                    }]
                },
                options: {
                    indexAxis: 'y',
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: { x: { beginAtZero: true, ticks: { precision: 0 } } },
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            callbacks: {
                                title: function (items) { return items[0].label; },
                                afterLabel: showRevenue ? function (item) {
                                    return 'Doanh thu: ' + new Intl.NumberFormat('vi-VN').format(data[item.dataIndex].revenue) + '₫';
                                } : undefined
                            }
                        }
                    }
                }
            });
        }
        renderRankingChart('topProductsChart', 'topProductsData', true);
        renderRankingChart('slowProductsChart', 'slowProductsData', false);

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
