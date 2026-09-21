<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - 2003 Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2003store-20260921">
</head>
<body class="auth-page">
    <div class="auth-shell">
        <div class="auth-panel">
            <div class="brand-block">
                <div class="brand-mark">2003</div>
                <div>
                    <p class="eyebrow light">Hệ thống nội bộ</p>
                    <h1>2003 STORE</h1>
                </div>
            </div>
            <h2>Đăng nhập</h2>
            <p class="subtext">Quản lý cửa hàng, kho hàng và doanh thu</p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert"><%= request.getAttribute("error") %></div>
            <% } %>

            <form method="post" action="${pageContext.request.contextPath}/login" class="login-form">
                <label>Username</label>
                <input type="text" name="username" placeholder="Nhập tên đăng nhập" required>

                <label>Password</label>
                <input type="password" name="password" placeholder="Nhập mật khẩu" required>

                <button type="submit" class="btn btn-primary">Đăng nhập</button>
            </form>

            <div class="demo-account">
                <p>Tài khoản demo</p>
                <strong>admin / 123456</strong>
            </div>
        </div>
    </div>
</body>
</html>
