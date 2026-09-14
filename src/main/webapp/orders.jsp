<%@ page import="com._2003store.model.Order" %>
<%@ page import="com._2003store.model.OrderItem" %>
<%@ page import="com._2003store.model.Product" %>
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
<body class="dashboard-page orders-theme">
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
                <label class="field-label">
                    <span>Tên khách hàng</span>
                    <input type="text" name="customerName" placeholder="Nhập tên khách hàng" required>
                </label>
                <label class="field-label">
                    <span>Số điện thoại</span>
                    <input type="text" name="phone" placeholder="Nhập số điện thoại" required>
                </label>
                <label class="field-label">
                    <span>Trạng thái</span>
                    <select name="status">
                        <option value="Chờ thanh toán">Chờ thanh toán</option>
                        <option value="Đã xác nhận">Đã xác nhận</option>
                        <option value="Đã hoàn tất">Đã hoàn tất</option>
                    </select>
                </label>
                <label class="field-label">
                    <span>Phương thức thanh toán</span>
                    <select name="paymentMethod" required>
                        <option value="Tiền mặt">Tiền mặt</option>
                        <option value="Chuyển khoản">Chuyển khoản</option>
                    </select>
                </label>
                <label class="field-label full-width">
                    <span>Số tiền khách thanh toán</span>
                    <input type="number" name="paymentAmount" placeholder="Nhập số tiền" min="0" step="1000" required>
                </label>
                <label class="field-label">
                    <span>Sản phẩm</span>
                    <select name="productId" required>
                        <option value="">-- Chọn sản phẩm --</option>
                        <%
                            List<Product> products = (List<Product>) request.getAttribute("products");
                            if (products != null) {
                                for (Product product : products) {
                        %>
                        <option value="<%= product.getId() %>">
                            <%= product.getId() %> - <%= product.getName() %>
                        </option>
                        <%
                                }
                            }
                        %>
                    </select>
                </label>
                <label class="field-label">
                    <span>Số lượng</span>
                    <input type="number" name="quantity" placeholder="Nhập số lượng" min="1" required>
                </label>
                <button type="submit" class="btn btn-primary full-width-btn">Tạo đơn</button>
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
                <div><strong>Thanh toán:</strong> <%= selectedOrder.getPaymentMethod() %></div>
                <div><strong>Ngày tạo:</strong> <%= selectedOrder.getCreatedAt() %></div>
                <div><strong>Tổng tiền:</strong> <%= selectedOrder.getTotalAmount() %>₫</div>
            </div>

            <table class="order-items-table">
                <thead>
                    <tr>
                        <th>Tên sản phẩm</th>
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

        <div class="card table-card pending-card">
            <div class="section-header-inline">
                <h3>Đơn hàng cần xử lý</h3>
                <span class="section-tag">Chờ xác nhận thanh toán</span>
            </div>
            <table class="pending-orders-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Khách hàng</th>
                        <th>Thanh toán</th>
                        <th>Số tiền</th>
                        <th>Trạng thái</th>
                        <th>QR</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Order> pendingOrders = (List<Order>) request.getAttribute("pendingOrders");
                        if (pendingOrders != null && !pendingOrders.isEmpty()) {
                            for (Order pendingOrder : pendingOrders) {
                    %>
                    <tr class="pending-row">
                        <td>#<%= pendingOrder.getId() %></td>
                        <td>
                            <div class="customer-stack">
                                <strong><%= pendingOrder.getCustomerName() %></strong>
                                <small><%= pendingOrder.getPhone() %></small>
                            </div>
                        </td>
                        <td>
                            <span class="payment-pill <%= (pendingOrder.getPaymentMethod() != null && pendingOrder.getPaymentMethod().contains("Chuyển")) ? "bank" : "cash" %>">
                                <%= pendingOrder.getPaymentMethod() %>
                            </span>
                        </td>
                        <td class="amount-cell"><%= pendingOrder.getPaymentAmount() %>₫</td>
                        <td><span class="badge <%= "Đã xác nhận".equals(pendingOrder.getPaymentStatus()) ? "status-confirmed" : ("Hoàn thành".equals(pendingOrder.getStatus()) ? "status-completed" : "status-pending") %>"><%= pendingOrder.getPaymentStatus() %></span></td>
                        <td class="qr-cell">
                            <% if (pendingOrder.getPaymentMethod() != null && pendingOrder.getPaymentMethod().contains("Chuyển")) { %>
                                <% if (pendingOrder.getQrCode() != null && !pendingOrder.getQrCode().isBlank()) { %>
                                    <div class="qr-box">
                                        <img src="<%= pendingOrder.getQrCode() %>" alt="QR thanh toán" width="70" height="70" />
                                    </div>
                                <% } else { %>
                                    <span class="empty-state">Chưa tạo</span>
                                <% } %>
                            <% } else { %>
                                <span class="empty-state">Tiền mặt</span>
                            <% } %>
                        </td>
                        <td class="action-cell">
                            <div class="inline-actions compact-actions">
                                <% if (pendingOrder.getPaymentMethod() != null && pendingOrder.getPaymentMethod().contains("Chuyển")) { %>
                                <a class="btn btn-small confirm-bank" href="${pageContext.request.contextPath}/orders?confirmId=<%= pendingOrder.getId() %>&confirmType=Chuyển%20khoản">Xác nhận</a>
                                <% } else { %>
                                <a class="btn btn-small confirm-cash" href="${pageContext.request.contextPath}/orders?confirmId=<%= pendingOrder.getId() %>&confirmType=Tiền%20mặt">Xác nhận</a>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="7" class="empty-row">Không có đơn hàng cần xử lý.</td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>

        <div class="card table-card compact-order-list">
            <div class="section-header-inline">
                <h3>Danh sách đơn hàng</h3>
                <span class="section-tag muted-tag">Tổng quan</span>
            </div>
            <table class="order-main-table">
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
                        <td>#<%= order.getId() %></td>
                        <td class="customer-name-cell"><%= order.getCustomerName() %></td>
                        <td><%= order.getPhone() %></td>
                        <td>
                            <span class="badge <%= "Đã xác nhận".equals(order.getStatus()) ? "status-confirmed" : ("Đã hoàn tất".equals(order.getStatus()) ? "status-completed" : "status-pending") %>">
                                <%= order.getStatus() %>
                            </span>
                        </td>
                        <td class="amount-cell"><%= order.getTotalAmount() %>₫</td>
                        <td>
                            <div class="inline-actions compact-actions">
                                <a class="btn btn-small btn-secondary" href="${pageContext.request.contextPath}/orders?detailId=<%= order.getId() %>">Chi tiết</a>
                                <% if ("Đã xác nhận".equals(order.getStatus())) { %>
                                <a class="btn btn-small confirm-bank" href="${pageContext.request.contextPath}/orders?completeId=<%= order.getId() %>">Hoàn thành</a>
                                <% } %>
                            </div>
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
