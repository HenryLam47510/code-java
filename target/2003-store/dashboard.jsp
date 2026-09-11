<%@ page import="com._2003store.model.Order" %>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="dashboard-page">
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
            <div class="summary-chip success">+12.5% so với tháng trước</div>
        </section>

        <div class="chart-box card">
            <div class="section-head">
                <h3>Báo cáo doanh thu</h3>
                <span class="muted">Tuần gần nhất</span>
            </div>
            <div class="chart-bars">
                <div class="bar" style="height: 45%"></div>
                <div class="bar" style="height: 58%"></div>
                <div class="bar" style="height: 40%"></div>
                <div class="bar" style="height: 68%"></div>
                <div class="bar" style="height: 88%"></div>
                <div class="bar" style="height: 78%"></div>
                <div class="bar" style="height: 96%"></div>
            </div>
        </div>

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
                    <h3>Sản phẩm sắp hết</h3>
                    <span class="mini-badge warning-badge">Cảnh báo</span>
                </div>
                <p>${lowStockCount}</p>
            </div>
        </div>

        <div class="stats secondary-stats">
            <div class="card stat">
                <div class="stat-top">
                    <h3>Đơn chờ xử lý</h3>
                    <span class="mini-badge">Cần xử lý</span>
                </div>
                <p>${pendingOrdersCount}</p>
            </div>
            <div class="card stat">
                <div class="stat-top">
                    <h3>Tỷ lệ hoạt động</h3>
                    <span class="mini-badge success">Ổn định</span>
                </div>
                <p>94%</p>
            </div>
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
