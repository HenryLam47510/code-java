<%@ page import="com._2003store.model.Product" %>
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

    com._2003store.service.AuthService authService = new com._2003store.service.AuthService();
    boolean canAccessOrders = sessionUser != null && authService.hasAccess(sessionUser, "orders");
    boolean canAccessProducts = sessionUser != null && authService.hasAccess(sessionUser, "products");
    boolean canAccessCustomers = sessionUser != null && authService.hasAccess(sessionUser, "customers");
    boolean canAccessReports = sessionUser != null && authService.hasAccess(sessionUser, "reports");
    boolean canAccessStaffReport = sessionUser != null && authService.hasAccess(sessionUser, "staff-report");
    boolean canAccessEmployees = sessionUser != null && authService.hasAccess(sessionUser, "employees");
    boolean canAccessInventory = sessionUser != null && authService.hasAccess(sessionUser, "inventory-check");
    boolean canAccessSuppliers = sessionUser != null && authService.hasAccess(sessionUser, "suppliers");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sản phẩm - 2003 Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2003store-20260921">
</head>
<body class="dashboard-page">
    <aside class="sidebar">
        <h2>2003 STORE</h2>
        <nav class="sidebar-nav">
            <% if ("ADMIN".equalsIgnoreCase(userRole)) { %>
                <div class="nav-group active manager-shell">
                    <a class="nav-main" href="${pageContext.request.contextPath}/dashboard/admin">Admin</a>
                    <div class="nav-submenu">
                        <a href="${pageContext.request.contextPath}/dashboard/admin">Tổng quan</a>
                        <a href="${pageContext.request.contextPath}/employees">Quản lý nhân sự</a>
                        <a href="${pageContext.request.contextPath}/orders">Đơn hàng</a>
                        <a class="active" href="${pageContext.request.contextPath}/products">Sản phẩm</a>
                        <a href="${pageContext.request.contextPath}/customers">Khách hàng</a>
                        <a href="${pageContext.request.contextPath}/reports">Doanh thu</a>
                        <a href="${pageContext.request.contextPath}/staff-report">Báo cáo nhân viên</a>
                        <a href="${pageContext.request.contextPath}/login-history">Nhật ký hệ thống</a>
                    </div>
                </div>
                <% if (canAccessInventory) { %><a class="single-link" href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a><% } %>
                <% if (canAccessSuppliers) { %><a class="single-link" href="${pageContext.request.contextPath}/suppliers">Nhà cung cấp</a><% } %>
            <% } else if ("MANAGER".equalsIgnoreCase(userRole)) { %>
                <div class="nav-group active manager-shell">
                    <a class="nav-main" href="${pageContext.request.contextPath}/dashboard/manager">Quản lý</a>
                    <div class="nav-submenu">
                        <a href="${pageContext.request.contextPath}/dashboard/manager">Tổng quan</a>
                        <% if (canAccessOrders) { %><a href="${pageContext.request.contextPath}/orders">Bán hàng & Đơn hàng</a><% } %>
                        <% if (canAccessProducts) { %><a class="active" href="${pageContext.request.contextPath}/products">Sản phẩm</a><% } %>
                        <% if (canAccessCustomers) { %><a href="${pageContext.request.contextPath}/customers">Khách hàng</a><% } %>
                        <% if (canAccessInventory) { %><a href="${pageContext.request.contextPath}/stock">Nhập kho</a><a href="${pageContext.request.contextPath}/stock-out">Xuất kho</a><a href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a><% } %>
                        <% if (canAccessSuppliers) { %><a href="${pageContext.request.contextPath}/suppliers">Nhà cung cấp</a><% } %>
                        <% if (canAccessReports) { %><a href="${pageContext.request.contextPath}/inventory-report">Báo cáo kho</a><a href="${pageContext.request.contextPath}/reports">Doanh thu</a><% } %>
                        <% if (canAccessStaffReport) { %><a href="${pageContext.request.contextPath}/staff-report">Nhân sự</a><% } %>
                        <% if (canAccessEmployees) { %><a href="${pageContext.request.contextPath}/employees">Nhân viên</a><% } %>
                    </div>
                </div>
            <% } else { %>
                <div class="nav-group active manager-shell">
                    <a class="nav-main" href="${pageContext.request.contextPath}/dashboard/employee">Bán hàng</a>
                    <div class="nav-submenu">
                        <a href="${pageContext.request.contextPath}/dashboard/employee">Tổng quan</a>
                        <% if (canAccessOrders) { %><a href="${pageContext.request.contextPath}/orders">Tạo đơn</a><a href="${pageContext.request.contextPath}/orders">Đơn hàng</a><% } %>
                        <% if (canAccessProducts) { %><a class="active" href="${pageContext.request.contextPath}/products">Sản phẩm</a><% } %>
                        <% if (canAccessCustomers) { %><a href="${pageContext.request.contextPath}/customers">Khách hàng</a><% } %>
                    </div>
                </div>
            <% } %>
            <div class="nav-divider"></div>
            <a class="single-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </aside>

    <main class="main-panel dashboard-shell">
        <div class="workspace-col">
            <header class="topbar modern-topbar">
                <div class="search-box">
                    <span>⌕</span>
                    <input type="text" placeholder="Tìm sản phẩm, thương hiệu hoặc danh mục...">
                </div>
                <div class="topbar-actions">
                    <button class="icon-button" type="button" aria-label="Thông báo">
                        🔔
                        <span class="badge-count">3</span>
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
                        <p class="label">Tổng sản phẩm</p>
                        <span class="icon-pill">◫</span>
                    </div>
                    <p class="value">${totalProducts}</p>
                    <span class="trend">▲ 8.2%</span>
                </article>
                <article class="stat-card accent-green">
                    <div class="stat-meta">
                        <p class="label">Hàng tồn</p>
                        <span class="icon-pill">✓</span>
                    </div>
                    <p class="value">${totalStock}</p>
                    <span class="trend">▲ 3.6%</span>
                </article>
                <article class="stat-card accent-orange">
                    <div class="stat-meta">
                        <p class="label">Sắp hết</p>
                        <span class="icon-pill">!</span>
                    </div>
                    <p class="value">${lowStockCount}</p>
                    <span class="trend">⚠ Cần kiểm tra</span>
                </article>
                <article class="stat-card accent-purple">
                    <div class="stat-meta">
                        <p class="label">Doanh thu</p>
                        <span class="icon-pill">↗</span>
                    </div>
                    <p class="value"><%= request.getAttribute("totalRevenue") != null ? request.getAttribute("totalRevenue") : "0" %>₫</p>
                    <span class="trend">▲ 11.1%</span>
                </article>
            </section>

            <div class="card form-card">
                <div class="panel-header">
                    <div>
                        <span class="panel-kicker">Quản lý</span>
                        <h3>Thêm / cập nhật sản phẩm</h3>
                    </div>
                </div>
                <form action="${pageContext.request.contextPath}/products" method="post" class="product-form">
                    <input type="hidden" name="action" id="productAction" value="add">
                    <input type="number" name="id" id="productId" placeholder="ID" required>
                    <input type="text" name="name" id="productName" placeholder="Tên sản phẩm" required>
                    <input type="text" name="category" id="productCategory" placeholder="Danh mục" required>
                    <input type="text" name="brand" id="productBrand" placeholder="Thương hiệu" required>
                    <input type="number" step="1000" name="price" id="productPrice" placeholder="Giá" required>
                    <input type="number" name="stock" id="productStock" placeholder="Tồn kho" required>
                    <input type="text" name="image" id="productImage" placeholder="URL hình ảnh" required>
                    <textarea name="description" id="productDescription" placeholder="Mô tả" required></textarea>
                    <button type="submit" class="btn btn-primary" id="submitButton">Thêm mới</button>
                </form>
            </div>

            <div class="card table-card">
                <div class="section-head">
                    <h3>Danh sách sản phẩm</h3>
                    <a href="#" class="table-link">Xuất dữ liệu</a>
                </div>

                <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/products">
                    <input type="text" name="keyword" placeholder="Tìm theo tên hoặc thương hiệu" value="${keyword}">
                    <select name="category">
                        <option value="all">Tất cả danh mục</option>
                        <option value="Running" ${category == 'Running' ? 'selected' : ''}>Running</option>
                        <option value="Lifestyle" ${category == 'Lifestyle' ? 'selected' : ''}>Lifestyle</option>
                        <option value="Sneaker" ${category == 'Sneaker' ? 'selected' : ''}>Sneaker</option>
                        <option value="Sport" ${category == 'Sport' ? 'selected' : ''}>Sport</option>
                    </select>
                    <select name="brand">
                        <option value="all">Tất cả thương hiệu</option>
                        <option value="Nike" ${brand == 'Nike' ? 'selected' : ''}>Nike</option>
                        <option value="Adidas" ${brand == 'Adidas' ? 'selected' : ''}>Adidas</option>
                        <option value="New Balance" ${brand == 'New Balance' ? 'selected' : ''}>New Balance</option>
                        <option value="Puma" ${brand == 'Puma' ? 'selected' : ''}>Puma</option>
                    </select>
                    <button type="submit" class="btn btn-primary">Lọc</button>
                </form>

                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Hình</th>
                            <th>Tên</th>
                            <th>Danh mục</th>
                            <th>Giá</th>
                            <th>Tồn kho</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Product> products = (List<Product>) request.getAttribute("products");
                            if (products != null) {
                                for (Product p : products) {
                        %>
                        <tr data-id="<%= p.getId() %>"
                            data-name="<%= p.getName() %>"
                            data-category="<%= p.getCategory() %>"
                            data-brand="<%= p.getBrand() %>"
                            data-price="<%= p.getPrice() %>"
                            data-stock="<%= p.getStock() %>"
                            data-image="<%= p.getImage() %>"
                            data-description="<%= p.getDescription() %>">
                            <td><%= p.getId() %></td>
                            <td><img src="<%= p.getImage() %>" alt="" class="thumb"></td>
                            <td><%= p.getName() %></td>
                            <td><%= p.getCategory() %></td>
                            <td><%= p.getPrice() %>₫</td>
                            <td>
                                <% if (p.getStock() <= 3) { %>
                                    <span class="pill pill-danger">Còn <%= p.getStock() %></span>
                                <% } else { %>
                                    <span class="pill pill-success">Còn <%= p.getStock() %></span>
                                <% } %>
                            </td>
                            <td>
                                <a href="#" class="link-btn edit-btn">Sửa</a>
                                <a class="link-btn" href="${pageContext.request.contextPath}/products/delete?id=<%= p.getId() %>">Xóa</a>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>

                <div class="pagination">
                    <%
                        Integer currentPage = (Integer) request.getAttribute("currentPage");
                        Integer totalPages = (Integer) request.getAttribute("totalPages");
                        if (currentPage == null) currentPage = 1;
                        if (totalPages == null) totalPages = 1;
                        for (int i = 1; i <= totalPages; i++) {
                    %>
                        <a href="${pageContext.request.contextPath}/products?page=<%= i %>&keyword=${keyword}&category=${category}&brand=${brand}" class="page-btn <%= (i == currentPage ? "active" : "") %>"><%= i %></a>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>

        <aside class="right-rail">
            <div class="notification-card">
                <div class="notification-header">
                    <h4>Thông báo kho</h4>
                    <button class="dismiss-btn" type="button">Xem</button>
                </div>
                <div class="notice critical">
                    <div class="avatar">!</div>
                    <div>
                        <h5>Kho cảnh báo</h5>
                        <p>Có <strong>${lowStockCount}</strong> sản phẩm sắp hết hàng cần kiểm tra.</p>
                    </div>
                </div>
                <div class="notice">
                    <div class="avatar">SP</div>
                    <div>
                        <h5>Phiếu nhập mới</h5>
                        <p>Đã cập nhật hàng tồn cho các mặt hàng đang hoạt động.</p>
                    </div>
                </div>
            </div>

            <div class="order-card">
                <div class="mini-row">
                    <h4>Top sản phẩm</h4>
                    <span class="pill pill-success">Hot</span>
                </div>
                <div class="order-item">
                    <div class="product-thumb">👟</div>
                    <div class="order-info">
                        <h5>Air Max 270</h5>
                        <p>Cửa hàng 2003 Store</p>
                    </div>
                    <div class="order-price">3.200.000₫</div>
                </div>
                <button class="primary-action" type="button">Xem báo cáo</button>
            </div>
        </aside>
    </main>
</body>
<script>
    document.querySelectorAll('.edit-btn').forEach(function(button) {
        button.addEventListener('click', function(event) {
            event.preventDefault();
            const row = this.closest('tr');
            document.getElementById('productAction').value = 'update';
            document.getElementById('productId').value = row.dataset.id;
            document.getElementById('productName').value = row.dataset.name;
            document.getElementById('productCategory').value = row.dataset.category;
            document.getElementById('productBrand').value = row.dataset.brand;
            document.getElementById('productPrice').value = row.dataset.price;
            document.getElementById('productStock').value = row.dataset.stock;
            document.getElementById('productImage').value = row.dataset.image;
            document.getElementById('productDescription').value = row.dataset.description;
            document.getElementById('submitButton').textContent = 'Cập nhật';
            document.getElementById('productName').focus();
        });
    });
</script>
</html>
