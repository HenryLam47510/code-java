<%@ page import="com._2003store.model.Order" %>
<%@ page import="com._2003store.model.OrderItem" %>
<%@ page import="com._2003store.model.OrderNotification" %>
<%@ page import="com._2003store.model.Product" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng - 2003 Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2003store-20260921">
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
                    <a href="${pageContext.request.contextPath}/inventory-report">Báo cáo kho</a>
                    <a href="${pageContext.request.contextPath}/suppliers">Nhà cung cấp</a>
                </div>
            </div>
            <div class="nav-group active">
                <a class="nav-main" href="${pageContext.request.contextPath}/orders">Đơn hàng</a>
                <div class="nav-submenu">
                    <a class="active" href="${pageContext.request.contextPath}/orders">Danh sách đơn hàng</a>
                    <a href="${pageContext.request.contextPath}/invoices">Hóa đơn</a>
                </div>
            </div>
            <a class="single-link" href="${pageContext.request.contextPath}/reports">Báo cáo</a>
            <a class="single-link" href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a>
            <div class="nav-divider"></div>
            <a class="single-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </aside>

    <main class="main-panel dashboard-shell">
        <div class="workspace-col">
            <header class="topbar modern-topbar">
                <div class="search-box">
                    <span>⌕</span>
                    <input type="text" placeholder="Tìm kiếm đơn hàng, khách hàng, trạng thái...">
                </div>
                <div class="topbar-actions">
                    <button class="icon-button" type="button" aria-label="Thông báo">
                        🔔
                        <span class="badge-count">5</span>
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
                        <p class="label">Doanh thu</p>
                        <span class="icon-pill">↗</span>
                    </div>
                    <p class="value"><%= request.getAttribute("totalRevenue") != null ? request.getAttribute("totalRevenue") : "0" %>₫</p>
                    <span class="trend">▲ 9.6%</span>
                </article>
                <article class="stat-card accent-green">
                    <div class="stat-meta">
                        <p class="label">Đã thanh toán</p>
                        <span class="icon-pill">✓</span>
                    </div>
                    <p class="value">${totalOrders}</p>
                    <span class="trend">▲ 5.8%</span>
                </article>
                <article class="stat-card accent-orange">
                    <div class="stat-meta">
                        <p class="label">Chờ xử lý</p>
                        <span class="icon-pill">⏳</span>
                    </div>
                    <p class="value">${pendingOrdersCount}</p>
                    <span class="trend">▼ 2.1%</span>
                </article>
                <article class="stat-card accent-purple">
                    <div class="stat-meta">
                        <p class="label">Tổng tiền mặt</p>
                        <span class="icon-pill">◔</span>
                    </div>
                    <p class="value"><%= request.getAttribute("todayRevenue") != null ? request.getAttribute("todayRevenue") : "0" %>₫</p>
                    <span class="trend">▲ 4.7%</span>
                </article>
            </section>

            <div class="card form-card">
                <div class="panel-header">
                    <div>
                        <span class="panel-kicker">Tạo mới</span>
                        <h3>Tạo đơn hàng mới</h3>
                    </div>
                </div>
                <p class="muted">Trạng thái mặc định: <strong>Chờ xác nhận</strong>. Khách hàng không chọn trạng thái thanh toán khi tạo đơn.</p>
                <%
                    String orderError = request.getParameter("error");
                    if (orderError != null && !orderError.isBlank()) {
                %>
                <div class="alert-box"><%= orderError %></div>
                <% } %>
                <form action="${pageContext.request.contextPath}/orders/create" method="post" class="order-form">
                    <input type="text" name="customerName" placeholder="Tên khách hàng" required>
                    <input type="text" name="phone" placeholder="Số điện thoại" required>
                    <select name="paymentMethod" required>
                        <option value="COD">Thanh toán khi nhận hàng</option>
                        <option value="BANK_TRANSFER">Chuyển khoản</option>
                        <option value="MOMO">Momo</option>
                    </select>
                    <input type="text" name="transactionNote" placeholder="Ghi chú thanh toán (nếu có)">
                    <select name="productId" required>
                        <option value="">-- Chọn sản phẩm --</option>
                        <%
                            List<Product> availableProducts = (List<Product>) request.getAttribute("availableProducts");
                            if (availableProducts != null) {
                                for (Product product : availableProducts) {
                        %>
                        <option value="<%= product.getId() %>"><%= product.getName() %> - <%= product.getBrand() %> (còn <%= product.getStock() %>)</option>
                        <%
                                }
                            }
                        %>
                    </select>
                    <input type="number" name="quantity" placeholder="Số lượng" min="1" required>
                    <button type="submit" class="btn btn-primary">Tạo đơn</button>
                </form>
            </div>

            <div class="card table-card">
                <div class="section-head">
                    <h3>Danh sách đơn hàng</h3>
                    <a href="#" class="table-link">Xuất báo cáo</a>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Khách hàng</th>
                            <th>Ngày tạo</th>
                            <th>Trạng thái</th>
                            <th>Tổng tiền</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Order> orders = (List<Order>) request.getAttribute("orders");
                            if (orders != null) {
                                for (Order order : orders) {
                        %>
                        <tr>
                            <td><%= order.getOrderCode() != null ? order.getOrderCode() : "DH" + order.getId() %></td>
                            <td><%= order.getCustomerName() %></td>
                            <td><%= order.getCreatedAt() != null ? new SimpleDateFormat("dd/MM/yyyy HH:mm").format(order.getCreatedAt()) : "--" %></td>
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
        </div>

        <aside class="right-rail">
            <div class="notification-card" id="orderNotificationCard">
                <div class="notification-header">
                    <h4>Đơn cần xử lý</h4>
                    <button class="dismiss-btn" type="button" onclick="document.getElementById('orderNotificationCard').style.display='none'">Xem tất cả</button>
                </div>
                <%
                    List<OrderNotification> notifications = (List<OrderNotification>) request.getAttribute("notifications");
                    if (notifications != null && !notifications.isEmpty()) {
                        for (OrderNotification notification : notifications) {
                %>
                <a class="notice" href="${pageContext.request.contextPath}/orders?detailId=<%= notification.getOrderId() %>">
                    <div class="avatar"><%= notification.getType().substring(0, 1).toUpperCase() %></div>
                    <div>
                        <h5><%= notification.getOrderCode() %></h5>
                        <p><%= notification.getMessage() %></p>
                        <small class="notification-status"><%= notification.getStatus() %></small>
                    </div>
                </a>
                <%
                        }
                    }
                %>
            </div>
            <script>
                setTimeout(function () {
                    const card = document.getElementById('orderNotificationCard');
                    if (card) card.style.display = 'none';
                }, 15000);
            </script>

            <div class="order-card">
                <div class="mini-row">
                    <h4>Danh sách hàng tồn</h4>
                    <span class="pill pill-warning">${lowStockCount}</span>
                </div>
                <%
                    if (availableProducts != null) {
                        int count = 0;
                        for (Product product : availableProducts) {
                            if (count >= 3) break;
                            count++;
                %>
                <div class="order-item">
                    <div class="product-thumb">👟</div>
                    <div class="order-info">
                        <h5><%= product.getName() %></h5>
                        <p>Còn <%= product.getStock() %> đôi</p>
                    </div>
                    <div class="order-price"><%= product.getPrice() %>₫</div>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </aside>
    </main>

    <%
        Order selectedOrder = (Order) request.getAttribute("selectedOrder");
        if (selectedOrder != null) {
    %>
    <div class="order-detail-overlay">
        <div class="order-detail-panel">
            <button class="order-detail-close" type="button" onclick="location.href='${pageContext.request.contextPath}/orders'">×</button>
            <div class="detail-header">
                <h3>Xử lý đơn hàng <%= selectedOrder.getOrderCode() != null ? selectedOrder.getOrderCode() : "#" + selectedOrder.getId() %></h3>
            </div>
            <div class="detail-body">
                <div class="detail-payment">
                    <h4>Phương thức thanh toán</h4>
                    <form method="post" action="${pageContext.request.contextPath}/orders/create">
                        <input type="hidden" name="orderId" value="<%= selectedOrder.getId() %>">
                        <label class="radio-row"><input type="radio" name="paymentMethod" value="COD" <%= "COD".equalsIgnoreCase(selectedOrder.getPaymentMethod()) || selectedOrder.getPaymentMethod() == null ? "checked" : "" %>> Tiền mặt</label>
                        <label class="radio-row"><input type="radio" name="paymentMethod" value="BANK_TRANSFER" <%= "BANK_TRANSFER".equalsIgnoreCase(selectedOrder.getPaymentMethod()) ? "checked" : "" %>> Chuyển khoản</label>
                        <div class="payment-status-box">
                            <strong>Trạng thái:</strong> <%= selectedOrder.getPaymentStatus() != null ? selectedOrder.getPaymentStatus() : "CHUA_THANH_TOAN" %>
                        </div>
                        <% if ("BANK_TRANSFER".equalsIgnoreCase(selectedOrder.getPaymentMethod())) { %>
                        <div class="qr-box">
                            <span>QR thanh toán VietQR</span>
                            <div class="qr-placeholder qr-clickable" data-qr-src="<%= selectedOrder.getQrCode() != null && !selectedOrder.getQrCode().isBlank() ? selectedOrder.getQrCode() : "https://img.vietqr.io/image/MB-050117052004-compact2.png?amount=0&addInfo=Thanh+toan+don+test" %>" onclick="openQrModal(this.dataset.qrSrc)" tabindex="0" role="button" aria-label="Phóng to mã QR thanh toán">
                                <img class="qr-image" src="<%= selectedOrder.getQrCode() != null && !selectedOrder.getQrCode().isBlank() ? selectedOrder.getQrCode() : "https://img.vietqr.io/image/MB-050117052004-compact2.png?amount=0&addInfo=Thanh+toan+don+test" %>" alt="VietQR" />
                            </div>
                            <small>Ngân hàng: MB - 050117052004</small>
                            <small>Người nhận: Hoang Manh Dung</small>
                            <small>Ghi chú: <%= selectedOrder.getTransactionNote() != null && !selectedOrder.getTransactionNote().isBlank() ? selectedOrder.getTransactionNote() : "Thanh toan don " + (selectedOrder.getOrderCode() != null ? selectedOrder.getOrderCode() : "#" + selectedOrder.getId()) %></small>
                        </div>
                        <% } %>
                        <textarea name="transactionNote" placeholder="Ghi chú xác nhận thanh toán"><%= selectedOrder.getTransactionNote() != null ? selectedOrder.getTransactionNote() : "" %></textarea>
                        <div class="detail-actions">
                            <button type="submit" name="action" value="cancel-order" class="btn btn-danger">Hủy đơn</button>
                            <button type="submit" name="action" value="confirm-payment" class="btn btn-primary">Xác nhận</button>
                            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/orders">Quay lại</a>
                        </div>
                    </form>
                </div>
                <div class="detail-info">
                    <h4>Thông tin đơn hàng</h4>
                    <div class="detail-product-card">
                        <div class="detail-product-thumb">🧾</div>
                        <div class="detail-product-meta">
                            <strong><%= selectedOrder.getCustomerName() %></strong>
                            <span><%= selectedOrder.getOrderCode() != null ? selectedOrder.getOrderCode() : "#" + selectedOrder.getId() %></span>
                            <span>Khách hàng: <%= selectedOrder.getPhone() %></span>
                        </div>
                    </div>
                    <div class="detail-specs">
                        <div><span>Mã đơn</span><strong><%= selectedOrder.getOrderCode() != null ? selectedOrder.getOrderCode() : "#" + selectedOrder.getId() %></strong></div>
                        <div><span>Tên khách hàng</span><strong><%= selectedOrder.getCustomerName() %></strong></div>
                        <div><span>Thời gian mua</span><strong><%= selectedOrder.getCreatedAt() != null ? new SimpleDateFormat("dd/MM/yyyy HH:mm").format(selectedOrder.getCreatedAt()) : "--" %></strong></div>
                        <div><span>Trạng thái</span><strong><%= selectedOrder.getStatus() %></strong></div>
                        <div><span>Tổng tiền</span><strong><%= selectedOrder.getTotalAmount() %>₫</strong></div>
                    </div>
                    <div class="order-item-list">
                        <%
                            List<OrderItem> detailItems = (List<OrderItem>) request.getAttribute("selectedOrderItems");
                            if (detailItems != null && !detailItems.isEmpty()) {
                                for (OrderItem item : detailItems) {
                        %>
                        <div class="mini-product-row">
                            <span><%= item.getProductName() %></span>
                            <span>Số lượng: <%= item.getQuantity() %></span>
                            <span><%= item.getUnitPrice() %>₫</span>
                        </div>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <div id="qrModal" class="qr-modal" aria-hidden="true" role="dialog" aria-modal="true">
        <div class="qr-modal-backdrop" onclick="closeQrModal()"></div>
        <div class="qr-modal-content">
            <button type="button" class="qr-modal-close" aria-label="Đóng" onclick="closeQrModal()">×</button>
            <img id="qrModalImage" src="" alt="Mã QR thanh toán VietQR" />
        </div>
    </div>

    <script>
        function openQrModal(src) {
            const modal = document.getElementById('qrModal');
            const img = document.getElementById('qrModalImage');
            if (!modal || !img) return;
            img.src = src;
            modal.classList.add('show');
            modal.setAttribute('aria-hidden', 'false');
            document.body.style.overflow = 'hidden';
        }

        function closeQrModal() {
            const modal = document.getElementById('qrModal');
            if (!modal) return;
            modal.classList.remove('show');
            modal.setAttribute('aria-hidden', 'true');
            document.body.style.overflow = '';
        }

        document.addEventListener('keydown', function (event) {
            if (event.key === 'Escape') {
                closeQrModal();
            }
        });
    </script>
</body>
</html>
