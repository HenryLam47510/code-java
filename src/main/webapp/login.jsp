<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - 2003 Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">
    <div class="auth-shell">
        <div class="auth-visual">
            <div class="brand-mark">2003</div>
            <h1>2003 Store</h1>
            <p>Hệ thống quản lý bán hàng và kho vận</p>
            <ul>
                <li>Quản lý đơn hàng</li>
                <li>Quản lý kho hàng</li>
                <li>Thanh toán nhanh chóng</li>
            </ul>
        </div>

        <div class="auth-box">
            <div class="auth-header">
                <span class="auth-badge">Admin Portal</span>
                <h2>Đăng nhập</h2>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert"><%= request.getAttribute("error") %></div>
            <% } %>

            <form method="post" action="${pageContext.request.contextPath}/login" class="auth-form">
                <label class="form-field">
                    <span>Tài khoản</span>
                    <input type="text" name="username" placeholder="Nhập tên đăng nhập" required>
                </label>

                <label class="form-field">
                    <span>Mật khẩu</span>
                    <input type="password" name="password" placeholder="Nhập mật khẩu" required>
                </label>

                <button type="submit" class="btn btn-primary auth-submit">Đăng nhập</button>
            </form>
        </div>
    </div>
</body>
</html>
