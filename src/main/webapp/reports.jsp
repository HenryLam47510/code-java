<%@ page import="com._2003store.model.RevenuePoint" %>
<%@ page import="com._2003store.model.RevenueDetail" %>
<%@ page import="com._2003store.dao.ReportDao" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.math.BigDecimal" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <%@ include file="/WEB-INF/sidebar.jsp" %>

    <main class="main-panel dashboard-shell">
        <div class="workspace-col report-workspace">
            <header class="topbar modern-topbar">
                <div class="search-box">
                    <span>⌕</span>
                    <input type="text" placeholder="Tìm báo cáo theo thời gian...">
                </div>
                <div class="topbar-actions">
                    <button class="icon-button" type="button" aria-label="Thông báo">
                        🔔
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

            <section class="report-filter-card card">
                <div class="report-filter-heading">
                    <div>
                        <span class="panel-kicker">Báo cáo doanh thu</span>
                        <h3>Thời gian thống kê</h3>
                    </div>
                    <button type="button" class="btn export-report-btn" id="exportReport">⇩ Xuất báo cáo</button>
                </div>
                <form class="report-filter report-filter-wide" method="get" action="${pageContext.request.contextPath}/reports">
                    <label>
                        <span>Từ ngày</span>
                        <input type="date" name="from" value="${from}">
                    </label>
                    <label>
                        <span>Đến ngày</span>
                        <input type="date" name="to" value="${to}">
                    </label>
                    <input type="hidden" name="view" value="${selectedView != null ? selectedView : 'day'}">
                    <button type="submit" class="btn btn-primary">Lọc báo cáo</button>
                </form>
                <div class="segmented-control report-mode">
                    <a href="${pageContext.request.contextPath}/reports?view=day&from=${from}&to=${to}" class="segment-button ${selectedView == 'day' ? 'active' : ''}">Theo ngày</a>
                    <a href="${pageContext.request.contextPath}/reports?view=month&from=${from}&to=${to}" class="segment-button ${selectedView == 'month' ? 'active' : ''}">Theo tháng</a>
                    <a href="${pageContext.request.contextPath}/reports?view=year&from=${from}&to=${to}" class="segment-button ${selectedView == 'year' ? 'active' : ''}">Theo năm</a>
                </div>
            </section>

            <section class="report-kpi-grid" aria-label="Chỉ số doanh thu">
                <article class="report-kpi-card">
                    <span class="report-kpi-icon blue">₫</span>
                    <div><span>Tổng doanh thu</span><strong><fmt:formatNumber value="${reportSummary.totalRevenue}" pattern="#,##0"/>₫</strong><small>Đơn thanh toán thành công</small></div>
                </article>
                <article class="report-kpi-card">
                    <span class="report-kpi-icon green">✓</span>
                    <div><span>Số đơn đã thanh toán</span><strong>${reportSummary.paidOrders}</strong><small>Tổng đơn hợp lệ trong kỳ</small></div>
                </article>
                <article class="report-kpi-card">
                    <span class="report-kpi-icon orange">◔</span>
                    <div><span>Doanh thu tiền mặt</span><strong><fmt:formatNumber value="${reportSummary.cashRevenue}" pattern="#,##0"/>₫</strong><small>Phương thức COD</small></div>
                </article>
                <article class="report-kpi-card">
                    <span class="report-kpi-icon purple">⬢</span>
                    <div><span>Doanh thu chuyển khoản</span><strong><fmt:formatNumber value="${reportSummary.transferRevenue}" pattern="#,##0"/>₫</strong><small>Chuyển khoản và ví điện tử</small></div>
                </article>
            </section>

            <section class="card report-chart-card">
                <div class="section-head">
                    <div><span class="panel-kicker">Xu hướng</span><h3>Biểu đồ doanh thu</h3></div>
                    <span class="muted">${selectedView == 'month' ? 'Theo tháng' : selectedView == 'year' ? 'Theo năm' : 'Theo ngày'}</span>
                </div>
                <div class="report-chart-container">
                    <%
                        List<RevenuePoint> revenueSeries = (List<RevenuePoint>) request.getAttribute("revenueSeries");
                        boolean hasRevenue = revenueSeries != null && revenueSeries.stream().anyMatch(p -> p.getValue() != null && p.getValue().compareTo(BigDecimal.ZERO) > 0);
                    %>
                    <% if (hasRevenue) { %>
                        <canvas id="reportRevenueChart" aria-label="Biểu đồ doanh thu theo thời gian" role="img"></canvas>
                        <div class="chart-data" id="reportRevenueData">
                            <c:forEach items="${revenueSeries}" var="point">
                                <span data-label="<c:out value='${point.label}'/>" data-value="${point.value}"></span>
                            </c:forEach>
                        </div>
                    <% } else { %>
                        <div class="empty-chart empty-revenue-chart">
                            <span class="empty-chart-icon">↗</span>
                            <strong>Chưa có doanh thu trong khoảng thời gian đã chọn</strong>
                            <small>Các đơn chờ thanh toán hoặc đã hủy không được tính.</small>
                        </div>
                    <% } %>
                </div>
            </section>

            <section class="card report-detail-card">
                <div class="section-head">
                    <div><span class="panel-kicker">Chi tiết</span><h3>Doanh thu theo kỳ</h3></div>
                </div>
                <div class="table-scroll">
                    <table class="report-detail-table">
                        <thead><tr><th>${selectedView == 'month' ? 'Tháng' : selectedView == 'year' ? 'Năm' : 'Ngày'}</th><th>Số đơn đã thanh toán</th><th>Tiền mặt</th><th>Chuyển khoản</th><th>Tổng doanh thu</th></tr></thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty revenueDetails}">
                                    <c:set var="totalCash" value="0"/>
                                    <c:set var="totalTransfer" value="0"/>
                                    <c:set var="totalAll" value="0"/>
                                    <c:set var="totalOrders" value="0"/>
                                    <c:forEach items="${revenueDetails}" var="row">
                                        <tr>
                                            <td><strong><c:out value="${row.label}"/></strong></td>
                                            <td>${row.paidOrders}</td>
                                            <td><fmt:formatNumber value="${row.cashRevenue}" pattern="#,##0"/>₫</td>
                                            <td><fmt:formatNumber value="${row.transferRevenue}" pattern="#,##0"/>₫</td>
                                            <td><strong><fmt:formatNumber value="${row.totalRevenue}" pattern="#,##0"/>₫</strong></td>
                                        </tr>
                                        <c:set var="totalCash" value="${totalCash + row.cashRevenue}"/>
                                        <c:set var="totalTransfer" value="${totalTransfer + row.transferRevenue}"/>
                                        <c:set var="totalAll" value="${totalAll + row.totalRevenue}"/>
                                        <c:set var="totalOrders" value="${totalOrders + row.paidOrders}"/>
                                    </c:forEach>
                                    <tr class="report-total-row">
                                        <td>Tổng cộng</td><td>${totalOrders}</td>
                                        <td><fmt:formatNumber value="${totalCash}" pattern="#,##0"/>₫</td>
                                        <td><fmt:formatNumber value="${totalTransfer}" pattern="#,##0"/>₫</td>
                                        <td><strong><fmt:formatNumber value="${totalAll}" pattern="#,##0"/>₫</strong></td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="5" class="report-empty-row">Không có dữ liệu doanh thu trong khoảng thời gian đã chọn.</td></tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
    </main>

    <script>
        const reportCanvas = document.getElementById('reportRevenueChart');
        const reportDataElement = document.getElementById('reportRevenueData');
        if (reportCanvas && reportDataElement) {
            const reportData = Array.from(reportDataElement.querySelectorAll('span')).map(function (item) {
                return { label: item.dataset.label, value: Number(item.dataset.value) };
            });
            new Chart(reportCanvas, {
                type: 'line',
                data: {
                    labels: reportData.map(function (item) { return item.label; }),
                    datasets: [{
                        label: 'Doanh thu',
                        data: reportData.map(function (item) { return item.value; }),
                        borderColor: '#2563eb',
                        backgroundColor: 'rgba(37, 99, 235, 0.10)',
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
                            callbacks: {
                                label: function (context) {
                                    return 'Doanh thu: ' + new Intl.NumberFormat('vi-VN').format(context.parsed.y) + ' ₫';
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            title: { display: true, text: '${selectedView == 'month' ? 'Tháng' : selectedView == 'year' ? 'Năm' : 'Ngày'}', color: '#64748b' },
                            grid: { display: false },
                            ticks: { color: '#64748b' }
                        },
                        y: {
                            beginAtZero: true,
                            title: { display: true, text: 'Doanh thu (₫)', color: '#64748b' },
                            grid: { color: 'rgba(148, 163, 184, 0.16)' },
                            ticks: {
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

        document.getElementById('exportReport').addEventListener('click', function () {
            const table = document.querySelector('.report-detail-table');
            if (!table) return;
            const lines = [];
            table.querySelectorAll('tr').forEach(function (row) {
                const cells = Array.from(row.querySelectorAll('th, td')).map(function (cell) {
                    return '"' + cell.innerText.replace(/"/g, '""') + '"';
                });
                if (cells.length) lines.push(cells.join(','));
            });
            const blob = new Blob(['\ufeff' + lines.join('\n')], { type: 'text/csv;charset=utf-8' });
            const url = URL.createObjectURL(blob);
            const link = document.createElement('a');
            link.href = url;
            link.download = 'bao-cao-doanh-thu.csv';
            link.click();
            URL.revokeObjectURL(url);
        });
    </script>
</body>
</html>
