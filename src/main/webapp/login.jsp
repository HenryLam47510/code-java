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
    <div class="auth-box">
        <h2>Đăng nhập</h2>
        <p class="subtext">Hệ thống quản lý 2003 Store</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert"><%= request.getAttribute("error") %></div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/login">
            <label>Username</label>
            <input type="text" name="username" required>

            <label>Password</label>
            <input type="password" name="password" required>

            <button type="submit" class="btn btn-primary">Đăng nhập</button>
        </form>

        <div class="demo-account">
            <p>Tài khoản demo:</p>
            <strong>admin / 123456</strong>
        </div>
    </div>
</body>
</html>
