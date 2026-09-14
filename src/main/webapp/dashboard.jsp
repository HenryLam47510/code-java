<%@ page import="com._2003store.model.Order" %>
<%@ page import="com._2003store.model.Product" %>
<%@ page import="com._2003store.model.RevenuePoint" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - 2003 Store</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="dashboard-page dashboard-theme">
    <aside class="sidebar">
        <h2>2003 STORE</h2>
        <nav class="sidebar-nav">
            <div class="nav-group active">
                <a class="nav-main" href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
                <div class="nav-submenu">
                    <a class="active" href="${pageContext.request.contextPath}/dashboard">Tổng quan</a>
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
            <a class="single-link" href="${pageContext.request.contextPath}/stock">Nhập kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/stock-out">Xuất kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/inventory-report">Báo cáo kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/suppliers">Nhà cung cấp</a>
            <a class="single-link" href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/employees">Nhân viên</a>
            <a class="single-link" href="${pageContext.request.contextPath}/login-history">Lịch sử đăng nhập</a>
            <div class="nav-divider"></div>
            <a class="single-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </aside>

    <main class="main-panel">
        <div class="topbar">
            <h1>Dashboard</h1>
            <span class="welcome-pill">Xin chào, ${sessionScope.user.fullName}</span>
        </div>

        <section class="overview-header card">
            <div>
                <span class="eyebrow">Tổng quan cửa hàng</span>
                <h2>Hiệu suất bán hàng trong ngày</h2>
            </div>
            <div class="summary-chip success">
                <%=
                    java.math.BigDecimal totalRevenue = (java.math.BigDecimal) request.getAttribute("totalRevenue");
                    java.math.BigDecimal todayRevenue = (java.math.BigDecimal) request.getAttribute("todayRevenue");
                    String revenueSummary = totalRevenue != null && totalRevenue.compareTo(java.math.BigDecimal.ZERO) > 0
                            ? NumberFormat.getNumberInstance(new Locale("vi", "VN")).format(totalRevenue) + "₫ tổng doanh thu"
                            : "Chưa có doanh thu";
                    out.print(revenueSummary);
                %>
            </div>
        </section>

        <div class="chart-box card">
            <div class="section-head">
                <h3>Báo cáo doanh thu</h3>
                <span class="muted">Tuần gần nhất</span>
            </div>
            <canvas id="dashboardRevenueChart" height="100"></canvas>
        </div>

        <script>
            const revenuePoints = [
                <%
                    List<RevenuePoint> revenueSeries = (List<RevenuePoint>) request.getAttribute("dailyRevenue");
                    if (revenueSeries != null) {
                        for (int i = 0; i < revenueSeries.size(); i++) {
                            RevenuePoint point = revenueSeries.get(i);
                            out.print("{ label: '" + point.getLabel() + "', value: " + (point.getValue() == null ? 0 : point.getValue()) + " }");
                            if (i < revenueSeries.size() - 1) out.print(",");
                        }
                    }
                %>
            ];

            const revenueSeriesLabels = revenuePoints.map(item => item.label);
            const revenueSeriesValues = revenuePoints.map(item => Number(item.value || 0));

            new Chart(document.getElementById('dashboardRevenueChart'), {
                type: 'line',
                data: {
                    labels: revenueSeriesLabels,
                    datasets: [{
                        label: 'Doanh thu (VNĐ)',
                        data: revenueSeriesValues,
                        borderColor: '#1b66f2',
                        backgroundColor: 'rgba(27, 102, 242, 0.15)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.35
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: false,
                            ticks: {
                                callback: function(value) {
                                    return Number(value).toLocaleString('vi-VN') + '₫';
                                }
                            }
                        }
                    }
                }
            });
        </script>

        <div class="stats">
            <div class="card stat stat-blue">
                <div class="stat-top">
                    <h3>Tổng sản phẩm</h3>
                    <span class="mini-badge">SKU</span>
                </div>
                <p>${totalProducts}</p>
            </div>
            <div class="card stat stat-green">
                <div class="stat-top">
                    <h3>Hàng tồn</h3>
                    <span class="mini-badge">Tổng</span>
                </div>
                <p>${totalStock}</p>
            </div>
            <div class="card stat stat-orange">
                <div class="stat-top">
                    <h3>Doanh thu</h3>
                    <span class="mini-badge">Tổng</span>
                </div>
                <p><%= NumberFormat.getNumberInstance(new Locale("vi", "VN")).format((java.math.BigDecimal) request.getAttribute("totalRevenue")) %>₫</p>
            </div>
            <div class="card stat stat-purple">
                <div class="stat-top">
                    <h3>Đơn hàng</h3>
                    <span class="mini-badge">Đã tạo</span>
                </div>
                <p>${totalOrders}</p>
            </div>
        </div>

        <div class="stats secondary-stats">
            <div class="card stat">
                <div class="stat-top">
                    <h3>Lợi nhuận đã thực thu</h3>
                    <span class="mini-badge success">Thực tế</span>
                </div>
                <p><%= NumberFormat.getNumberInstance(new Locale("vi", "VN")).format((java.math.BigDecimal) request.getAttribute("completedRevenue")) %>₫</p>
            </div>
            <div class="card stat">
                <div class="stat-top">
                    <h3>Số đơn hoàn tất</h3>
                    <span class="mini-badge">Hoàn tất</span>
                </div>
                <p>${completedOrdersCount}</p>
            </div>
            <div class="card stat">
                <div class="stat-top">
                    <h3>Tỷ lệ thanh toán</h3>
                    <span class="mini-badge success">Đã xác nhận</span>
                </div>
                <p><%= NumberFormat.getNumberInstance(new Locale("vi", "VN")).format((java.math.BigDecimal) request.getAttribute("paymentRate")) %>%</p>
            </div>
            <div class="card stat">
                <div class="stat-top">
                    <h3>Sản phẩm sắp hết</h3>
                    <span class="mini-badge warning-badge">Cảnh báo</span>
                </div>
                <p>${lowStockCount}</p>
            </div>
        </div>

        <div class="stats secondary-stats">
            <div class="card stat">
                <div class="stat-top">
                    <h3>Doanh thu hôm nay</h3>
                    <span class="mini-badge alert-badge">Hôm nay</span>
                </div>
                <p><%= NumberFormat.getNumberInstance(new Locale("vi", "VN")).format((java.math.BigDecimal) request.getAttribute("todayRevenue")) %>₫</p>
            </div>
            <div class="card stat">
                <div class="stat-top">
                    <h3>Doanh thu tháng này</h3>
                    <span class="mini-badge">Tháng</span>
                </div>
                <p><%= NumberFormat.getNumberInstance(new Locale("vi", "VN")).format((java.math.BigDecimal) request.getAttribute("thisMonthRevenue")) %>₫</p>
            </div>
            <div class="card stat">
                <div class="stat-top">
                    <h3>Giá trị đơn trung bình</h3>
                    <span class="mini-badge">TB</span>
                </div>
                <p><%= NumberFormat.getNumberInstance(new Locale("vi", "VN")).format((java.math.BigDecimal) request.getAttribute("averageOrderValue")) %>₫</p>
            </div>
            <div class="card stat">
                <div class="stat-top">
                    <h3>Đơn chờ xử lý</h3>
                    <span class="mini-badge">Cần xử lý</span>
                </div>
                <p>${pendingOrdersCount}</p>
            </div>
        </div>

        <div class="card table-card">
            <div class="section-head">
                <h3>Sản phẩm gần đây</h3>
                <a href="${pageContext.request.contextPath}/products" class="table-link">Xem tất cả</a>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên</th>
                        <th>Nhà cung cấp</th>
                        <th>Màu sắc</th>
                        <th>Size</th>
                        <th>Xuất xứ</th>
                        <th>Trạng thái</th>
                        <th>Tồn kho</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Product> products = (List<Product>) request.getAttribute("products");
                        if (products != null) {
                            for (Product product : products) {
                    %>
                    <tr>
                        <td><%= product.getId() %></td>
                        <td><%= product.getName() %></td>
                        <td><%= product.getSupplier() == null ? "Chưa xác định" : product.getSupplier() %></td>
                        <td><%= product.getColor() == null ? "Không xác định" : product.getColor() %></td>
                        <td><%= product.getSize() == null ? "39" : product.getSize() %></td>
                        <td><%= product.getOrigin() == null ? "Chưa xác định" : product.getOrigin() %></td>
                        <td><span class="badge"><%= product.getStatus() == null ? "Còn hàng" : product.getStatus() %></span></td>
                        <td><%= product.getStock() %></td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>

        <div class="card table-card">
            <div class="section-head">
                <h3>Đơn hàng gần đây</h3>
                <a href="${pageContext.request.contextPath}/orders" class="table-link">Xem tất cả</a>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Khách hàng</th>
                        <th>SĐT</th>
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
                        <td><%= order.getId() %></td>
                        <td><%= order.getCustomerName() %></td>
                        <td><%= order.getPhone() %></td>
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
    </main>
</body>
</html>
