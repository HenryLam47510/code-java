<%@ page import="com._2003store.model.Invoice" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa đơn - 2003 Store</title>
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
                    <a class="active" href="${pageContext.request.contextPath}/invoices">Hóa đơn</a>
                    <a href="${pageContext.request.contextPath}/customers">Khách hàng</a>
                </div>
            </div>
            <a class="single-link" href="${pageContext.request.contextPath}/customers">Khách hàng</a>
            <a class="single-link" href="${pageContext.request.contextPath}/stock">Nhập kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/stock-out">Xuất kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/inventory-report">Báo cáo kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/suppliers">Nhà cung cấp</a>
            <a class="single-link" href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a>
            <div class="nav-divider"></div>
            <a class="single-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </aside>

    <main class="main-panel">
        <div class="topbar">
            <h1>Hóa đơn bán hàng</h1>
            <span>Xin chào, ${sessionScope.user.fullName}</span>
        </div>

        <div class="card form-card">
            <h3>Tạo hóa đơn</h3>
            <form action="${pageContext.request.contextPath}/invoices/create" method="post" class="invoice-form">
                <input type="number" name="orderId" placeholder="ID đơn hàng" required>
                <input type="text" name="customerName" placeholder="Tên khách hàng">
                <input type="text" name="phone" placeholder="Số điện thoại">
                <select name="paymentMethod">
                    <option value="Tien mat">Tiền mặt</option>
                    <option value="Chuyen khoan">Chuyển khoản</option>
                    <option value="Quet QR">Quét QR</option>
                </select>
                <button type="submit" class="btn btn-primary">Lập hóa đơn</button>
            </form>
        </div>

        <div class="card table-card">
            <h3>Danh sách hóa đơn</h3>
            <table>
                <thead>
                    <tr>
                        <th>Mã hóa đơn</th>
                        <th>Khách hàng</th>
                        <th>SĐT</th>
                        <th>Phương thức</th>
                        <th>Tổng tiền</th>
                        <th>Ngày</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Invoice> invoices = (List<Invoice>) request.getAttribute("invoices");
                        if (invoices != null) {
                            for (Invoice invoice : invoices) {
                    %>
                    <tr>
                        <td><%= invoice.getInvoiceCode() %></td>
                        <td><%= invoice.getCustomerName() %></td>
                        <td><%= invoice.getPhone() %></td>
                        <td><%= invoice.getPaymentMethod() %></td>
                        <td><%= invoice.getTotalAmount() %>₫</td>
                        <td><%= invoice.getCreatedAt() != null ? new SimpleDateFormat("dd/MM/yyyy HH:mm").format(invoice.getCreatedAt()) : "--" %></td>
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
