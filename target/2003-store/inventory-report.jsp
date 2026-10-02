<%@ page import="com._2003store.model.InventoryReportItem" %>
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
    <title>Báo cáo nhập - xuất - tồn - 2003 Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2003store-20260921">
</head>
<body class="dashboard-page">
    <%@ include file="/WEB-INF/sidebar.jsp" %>

    <main class="main-panel">
        <div class="topbar">
            <h1>Báo cáo nhập - xuất - tồn</h1>
            <span>Xin chào, ${sessionScope.user.fullName}</span>
        </div>

        <div class="card table-card">
            <h3>Thống kê theo sản phẩm</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Sản phẩm</th>
                        <th>Danh mục</th>
                        <th>Thương hiệu</th>
                        <th>Nhập</th>
                        <th>Xuất</th>
                        <th>Tồn kho</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<InventoryReportItem> report = (List<InventoryReportItem>) request.getAttribute("report");
                        if (report != null) {
                            for (InventoryReportItem item : report) {
                    %>
                    <tr>
                        <td><%= item.getProductId() %></td>
                        <td><%= item.getProductName() %></td>
                        <td><%= item.getCategory() %></td>
                        <td><%= item.getBrand() %></td>
                        <td><%= item.getTotalImported() %></td>
                        <td><%= item.getTotalExported() %></td>
                        <td><%= item.getCurrentStock() %></td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>
