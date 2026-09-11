<%@ page import="com._2003store.model.Order" %>
<%@ page import="com._2003store.model.OrderItem" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng - 2003 Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="dashboard-page">
    <aside class="sidebar">
        <h2>2003 STORE</h2>
        <nav class="sidebar-nav">
            <div class="nav-group">
                <a class="nav-main" href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/dashboard">Tổng quan</a>
                    <a href="${pageContext.request.contextPath}/reports">Báo cáo</a>
                    <a href="${pageContext.request.contextPath}/staff-report">Báo cáo nhân viên</a>
                </div>
            </div>
            <div class="nav-group">
                <a class="nav-main" href="${pageContext.request.contextPath}/products">Sản phẩm</a>
                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/products">Tất cả sản phẩm</a>
                    <a href="${pageContext.request.contextPath}/stock">Nhập kho</a>
                    <a href="${pageContext.request.contextPath}/stock-out">Xuất kho</a>
                </div>
            </div>
            <div class="nav-group active">
                <a class="nav-main" href="${pageContext.request.contextPath}/orders">Đơn hàng</a>
                <div class="nav-submenu">
                    <a class="active" href="${pageContext.request.contextPath}/orders">Danh sách</a>
                    <a href="${pageContext.request.contextPath}/invoices">Hóa đơn</a>
                    <a href="${pageContext.request.contextPath}/customers">Khách hàng</a>
                </div>
            </div>
            <a class="single-link" href="${pageContext.request.contextPath}/customers">Khách hàng</a>
            <a class="single-link" href="${pageContext.request.contextPath}/stock">Nhập kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/stock-out">Xuất kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/reports">Báo cáo</a>
            <a class="single-link" href="${pageContext.request.contextPath}/inventory-report">Báo cáo kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/suppliers">Nhà cung cấp</a>
            <a class="single-link" href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a>
            <div class="nav-divider"></div>
            <a class="single-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </aside>

    <main class="main-panel">
        <div class="topbar">
            <h1>Quản lý đơn hàng</h1>
            <span class="welcome-pill">Xin chào, ${sessionScope.user.fullName}</span>
        </div>

        <div class="card form-card">
            <h3>Tạo đơn hàng mới</h3>
            <form action="${pageContext.request.contextPath}/orders/create" method="post" class="order-form">
                <input type="text" name="customerName" placeholder="Tên khách hàng" required>
                <input type="text" name="phone" placeholder="Số điện thoại" required>
                <select name="status">
                    <option value="Cho xac nhan">Chờ xác nhận</option>
                    <option value="Da thanh toan">Đã thanh toán</option>
                    <option value="Dang giao">Đang giao</option>
                    <option value="Hoan thanh">Hoàn thành</option>
                </select>
                <input type="number" name="productId" placeholder="ID sản phẩm" required>
                <input type="number" name="quantity" placeholder="Số lượng" min="1" required>
                <button type="submit" class="btn btn-primary">Tạo đơn</button>
            </form>
        </div>

        <div class="card detail-panel">
            <h3>Chi tiết đơn hàng</h3>
            <%
                com._2003store.model.Order selectedOrder = (com._2003store.model.Order) request.getAttribute("selectedOrder");
                java.util.List<com._2003store.model.OrderItem> selectedOrderItems = (java.util.List<com._2003store.model.OrderItem>) request.getAttribute("selectedOrderItems");
                if (selectedOrder != null) {
            %>
            <div class="detail-grid">
                <div><strong>Mã đơn:</strong> <%= selectedOrder.getId() %></div>
                <div><strong>Khách hàng:</strong> <%= selectedOrder.getCustomerName() %></div>
                <div><strong>SĐT:</strong> <%= selectedOrder.getPhone() %></div>
                <div><strong>Trạng thái:</strong> <%= selectedOrder.getStatus() %></div>
                <div><strong>Ngày tạo:</strong> <%= selectedOrder.getCreatedAt() %></div>
                <div><strong>Tổng tiền:</strong> <%= selectedOrder.getTotalAmount() %>₫</div>
            </div>

            <table class="order-items-table">
                <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Số lượng</th>
                        <th>Đơn giá</th>
                        <th>Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (selectedOrderItems != null) {
                            for (com._2003store.model.OrderItem item : selectedOrderItems) {
                    %>
                    <tr>
                        <td><%= item.getProductName() %></td>
                        <td><%= item.getQuantity() %></td>
                        <td><%= item.getUnitPrice() %>₫</td>
                        <td><%= item.getUnitPrice().multiply(java.math.BigDecimal.valueOf(item.getQuantity())) %>₫</td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
            <button class="btn btn-secondary" onclick="window.print()">In hóa đơn</button>
            <% } else { %>
            <p>Chọn một đơn hàng để xem chi tiết.</p>
            <% } %>
        </div>

        <div class="card table-card">
            <h3>Danh sách đơn hàng</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Khách hàng</th>
                        <th>SĐT</th>
                        <th>Trạng thái</th>
                        <th>Tổng tiền</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Order> orders = (List<Order>) request.getAttribute("orders");
                        if (orders != null) {
                            for (Order order : orders) {
                    %>
                    <tr>
                        <td><%= order.getId() %></td>
                        <td><%= order.getCustomerName() %></td>
                        <td><%= order.getPhone() %></td>
                        <td><span class="badge"><%= order.getStatus() %></span></td>
                        <td><%= order.getTotalAmount() %>₫</td>
                        <td>
                            <a class="btn btn-small" href="${pageContext.request.contextPath}/orders?detailId=<%= order.getId() %>">Chi tiết</a>
                        </td>
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
