<%@ page import="com._2003store.model.Product" %>
<%@ page import="com._2003store.model.StockReceipt" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý nhập kho - 2003 Store</title>
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
                    <a href="${pageContext.request.contextPath}/stock">Nhập kho</a>
                    <a href="${pageContext.request.contextPath}/stock-out">Xuất kho</a>
                </div>
            </div>
            <div class="nav-group">
                <a class="nav-main" href="${pageContext.request.contextPath}/orders">Đơn hàng</a>
                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/orders">Danh sách</a>
                    <a href="${pageContext.request.contextPath}/invoices">Hóa đơn</a>
                    <a href="${pageContext.request.contextPath}/customers">Khách hàng</a>
                </div>
            </div>
            <a class="single-link" href="${pageContext.request.contextPath}/customers">Khách hàng</a>
            <a class="single-link active" href="${pageContext.request.contextPath}/stock">Nhập kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/stock-out">Xuất kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/inventory-report">Báo cáo kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/suppliers">Nhà cung cấp</a>
            <a class="single-link" href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/employees">Nhân viên</a>
            <div class="nav-divider"></div>
            <a class="single-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </aside>

    <main class="main-panel dashboard-shell">
        <div class="workspace-col">
            <header class="topbar modern-topbar">
                <div class="search-box">
                    <span>⌕</span>
                    <input type="text" placeholder="Tìm phiếu nhập, sản phẩm, nhà cung cấp...">
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

            <section class="stat-grid">
                <article class="stat-card accent-blue">
                    <div class="stat-meta">
                        <p class="label">Giá trị nhập kho</p>
                        <span class="icon-pill">◫</span>
                    </div>
                    <p class="value">${totalImportValue}₫</p>
                    <span class="trend">▲ 7.4%</span>
                </article>
                <article class="stat-card accent-green">
                    <div class="stat-meta">
                        <p class="label">Sản phẩm tồn</p>
                        <span class="icon-pill">✓</span>
                    </div>
                    <p class="value">${totalStock}</p>
                    <span class="trend">▲ 3.9%</span>
                </article>
                <article class="stat-card accent-orange">
                    <div class="stat-meta">
                        <p class="label">Sắp hết</p>
                        <span class="icon-pill">!</span>
                    </div>
                    <p class="value">${lowStockCount}</p>
                    <span class="trend">⚠ Cảnh báo</span>
                </article>
                <article class="stat-card accent-purple">
                    <div class="stat-meta">
                        <p class="label">Hợp đồng</p>
                        <span class="icon-pill">⬢</span>
                    </div>
                    <p class="value">18</p>
                    <span class="trend">▲ 2.5%</span>
                </article>
            </section>

            <div class="card form-card">
                <div class="panel-header">
                    <div>
                        <span class="panel-kicker">Kho hàng</span>
                        <h3>Phiếu nhập hàng</h3>
                    </div>
                </div>
                <form action="${pageContext.request.contextPath}/stock/add" method="post" class="stock-form">
                    <select name="productId" required>
                        <option value="">-- Chọn sản phẩm --</option>
                        <%
                            List<Product> products = (List<Product>) request.getAttribute("products");
                            if (products != null) {
                                for (Product product : products) {
                        %>
                        <option value="<%= product.getId() %>"><%= product.getName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                    <input type="text" name="supplier" placeholder="Nhà cung cấp" required>
                    <input type="number" name="quantity" min="1" placeholder="Số lượng nhập" required>
                    <input type="number" step="1000" name="unitPrice" placeholder="Đơn giá nhập" required>
                    <textarea name="note" placeholder="Ghi chú"></textarea>
                    <button type="submit" class="btn btn-primary">Lưu phiếu nhập</button>
                </form>
            </div>

            <div class="card table-card">
                <div class="section-head">
                    <h3>Lịch sử nhập kho</h3>
                    <a href="#" class="table-link">Xuất báo cáo</a>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Sản phẩm</th>
                            <th>Nhà cung cấp</th>
                            <th>Số lượng</th>
                            <th>Đơn giá</th>
                            <th>Tổng tiền</th>
                            <th>Ngày</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<StockReceipt> receipts = (List<StockReceipt>) request.getAttribute("receipts");
                            if (receipts != null) {
                                for (StockReceipt receipt : receipts) {
                        %>
                        <tr>
                            <td><%= receipt.getId() %></td>
                            <td><%= receipt.getProductName() %></td>
                            <td><%= receipt.getSupplier() %></td>
                            <td><%= receipt.getQuantity() %></td>
                            <td><%= receipt.getUnitPrice() %>₫</td>
                            <td><%= receipt.getTotalCost() %>₫</td>
                            <td><%= receipt.getCreatedAt() != null ? new SimpleDateFormat("dd/MM/yyyy HH:mm").format(receipt.getCreatedAt()) : "--" %></td>
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
                    <h4>Thông báo kho</h4>
                    <button class="dismiss-btn" type="button">Tắt</button>
                </div>
                <div class="notice">
                    <div class="avatar">SP</div>
                    <div>
                        <h5>Nhập hàng mới</h5>
                        <p>Phiếu nhập đã được cập nhật thành công trong ngày.</p>
                    </div>
                </div>
                <div class="notice critical">
                    <div class="avatar">!</div>
                    <div>
                        <h5>Hàng sắp hết</h5>
                        <p>Có <strong>${lowStockCount}</strong> mặt hàng cần bổ sung gấp.</p>
                    </div>
                </div>
            </div>

            <div class="order-card">
                <div class="mini-row">
                    <h4>Phân bổ kho</h4>
                    <span class="pill pill-success">Ổn định</span>
                </div>
                <div class="order-item">
                    <div class="product-thumb">📦</div>
                    <div class="order-info">
                        <h5>Tổng tồn kho</h5>
                        <p>Đủ cho 7 ngày làm việc</p>
                    </div>
                    <div class="order-price">${totalStock}</div>
                </div>
                <button class="primary-action" type="button">Xem báo cáo</button>
            </div>
        </aside>
    </main>
</body>
</html>
