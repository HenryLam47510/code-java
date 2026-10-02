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
    <title>Lịch sử đăng nhập - 2003 Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2003store-20260921">
</head>
<body class="dashboard-page">
    <%@ include file="/WEB-INF/sidebar.jsp" %>

    <main class="main-panel dashboard-shell">
        <div class="workspace-col">
            <header class="topbar modern-topbar">
                <div class="search-box">
                    <span>⌕</span>
                    <input type="text" placeholder="Tìm lịch sử đăng nhập theo tên hoặc IP...">
                </div>
                <div class="topbar-actions">
                    <button class="icon-button" type="button" aria-label="Thông báo">
                        🔔
                        <span class="badge-count">2</span>
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

            <div class="card table-card">
                <div class="section-head">
                    <h3>Hoạt động gần đây</h3>
                    <a href="#" class="table-link">Xuất log</a>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Họ tên</th>
                            <th>Thời gian</th>
                            <th>Trạng thái</th>
                            <th>IP</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<LoginHistory> histories = (List<LoginHistory>) request.getAttribute("histories");
                            if (histories != null) {
                                for (LoginHistory history : histories) {
                        %>
                        <tr>
                            <td><%= history.getId() %></td>
                            <td><%= history.getUsername() %></td>
                            <td><%= history.getFullName() %></td>
                            <td><%= history.getLoginTime() %></td>
                            <td><span class="badge"><%= history.getStatus() %></span></td>
                            <td><%= history.getIpAddress() %></td>
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
                    <h4>Giám sát</h4>
                    <button class="dismiss-btn" type="button">Bật</button>
                </div>
                <div class="notice">
                    <div class="avatar">⚑</div>
                    <div>
                        <h5>Đăng nhập thành công</h5>
                        <p>Toàn bộ hoạt động trong 24 giờ gần đây không có sự cố.</p>
                    </div>
                </div>
            </div>
        </aside>
    </main>
</body>
</html>
