<%@ page import="com._2003store.model.RevenuePoint" %>
<%@ page import="com._2003store.model.LoginHistory" %>
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
    <title>Báo cáo nhân sự - 2003 Store</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2003store-20260921">
</head>
<body class="dashboard-page">
    <%@ include file="/WEB-INF/sidebar.jsp" %>

    <main class="main-panel">
        <div class="topbar">
            <h1>Báo cáo nhân sự & hoạt động</h1>
            <span class="welcome-pill">Xin chào, ${sessionScope.user.fullName}</span>
        </div>

        <div class="card form-card">
            <h3>Chọn khoảng thời gian</h3>
            <form class="report-filter" method="get" action="${pageContext.request.contextPath}/staff-report">
                <input type="date" name="from" value="${from}">
                <input type="date" name="to" value="${to}">
                <button type="submit" class="btn btn-primary">Lọc báo cáo</button>
            </form>
        </div>

        <div class="stats">
            <div class="card stat stat-blue">
                <div class="stat-top">
                    <h3>Tổng nhân viên</h3>
                    <span class="mini-badge">Hiện tại</span>
                </div>
                <p>${totalEmployees}</p>
            </div>
            <div class="card stat stat-green">
                <div class="stat-top">
                    <h3>Đăng nhập thành công</h3>
                    <span class="mini-badge success">Thời gian lọc</span>
                </div>
                <p>${successfulLogins}</p>
            </div>
            <div class="card stat stat-orange">
                <div class="stat-top">
                    <h3>Đăng nhập thất bại</h3>
                    <span class="mini-badge warning-badge">Cảnh báo</span>
                </div>
                <p>${failedLogins}</p>
            </div>
            <div class="card stat stat-purple">
                <div class="stat-top">
                    <h3>Nhân viên hoạt động</h3>
                    <span class="mini-badge">Trong khoảng</span>
                </div>
                <p>${activeEmployees}</p>
            </div>
        </div>

        <div class="card chart-box">
            <div class="section-head">
                <h3>Xu hướng đăng nhập</h3>
                <span class="muted">Theo ngày</span>
            </div>
            <canvas id="activityChart" height="110"></canvas>
        </div>

        <div class="card table-card">
            <h3>Nhân viên tích cực nhất</h3>
            <div class="summary-chip success">${topEmployee}</div>
        </div>

        <div class="card table-card">
            <h3>Hoạt động gần đây</h3>
            <table>
                <thead>
                    <tr>
                        <th>Username</th>
                        <th>Họ tên</th>
                        <th>Thời gian</th>
                        <th>Trạng thái</th>
                        <th>IP</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<LoginHistory> recentActivities = (List<LoginHistory>) request.getAttribute("recentActivities");
                        if (recentActivities != null) {
                            for (LoginHistory item : recentActivities) {
                    %>
                    <tr>
                        <td><%= item.getUsername() %></td>
                        <td><%= item.getFullName() %></td>
                        <td><%= item.getLoginTime() %></td>
                        <td><span class="badge"><%= item.getStatus() %></span></td>
                        <td><%= item.getIpAddress() %></td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </main>

    <script>
        const labels = [
            <%
                List<RevenuePoint> trend = (List<RevenuePoint>) request.getAttribute("loginTrend");
                if (trend != null) {
                    for (int i = 0; i < trend.size(); i++) {
                        RevenuePoint point = trend.get(i);
                        out.print("'" + point.getLabel() + "'");
                        if (i < trend.size() - 1) out.print(",");
                    }
                }
            %>
        ];

        const values = [
            <%
                if (trend != null) {
                    for (int i = 0; i < trend.size(); i++) {
                        RevenuePoint point = trend.get(i);
                        out.print(point.getValue());
                        if (i < trend.size() - 1) out.print(",");
                    }
                }
            %>
        ];

        new Chart(document.getElementById('activityChart'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Số lần đăng nhập',
                    data: values,
                    borderColor: '#7c3aed',
                    backgroundColor: 'rgba(124, 58, 237, 0.18)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.35
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>
