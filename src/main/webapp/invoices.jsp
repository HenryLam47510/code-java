<%@ page import="com._2003store.model.Invoice" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
    <title>Hóa đơn - 2003 Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2003store-20260921">
</head>
<body class="dashboard-page">
    <%@ include file="/WEB-INF/sidebar.jsp" %>

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
