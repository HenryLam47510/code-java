<%@ page import="com._2003store.model.Product" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sản phẩm - 2003 Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="dashboard-page inventory-theme">
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
            <div class="nav-group active">
                <a class="nav-main" href="${pageContext.request.contextPath}/products">Sản phẩm</a>
                <div class="nav-submenu">
                    <a class="active" href="${pageContext.request.contextPath}/products">Tất cả sản phẩm</a>
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
            <a class="single-link" href="${pageContext.request.contextPath}/reports">Báo cáo</a>
            <a class="single-link" href="${pageContext.request.contextPath}/inventory-report">Báo cáo kho</a>
            <a class="single-link" href="${pageContext.request.contextPath}/suppliers">Nhà cung cấp</a>
            <a class="single-link" href="${pageContext.request.contextPath}/inventory-check">Kiểm kho</a>
            <div class="nav-divider"></div>
            <a class="single-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </aside>

    <main class="main-panel">
        <div class="topbar">
            <h1>Quản lý sản phẩm</h1>
            <span class="welcome-pill">Xin chào, ${sessionScope.user.fullName}</span>
        </div>

        <div class="card form-card">
            <h3>Quản lý sản phẩm</h3>
            <form action="${pageContext.request.contextPath}/products" method="post" class="product-form">
                <input type="hidden" name="action" id="productAction" value="add">
                <input type="number" name="id" id="productId" placeholder="ID (tùy chọn)">
                <input type="text" name="name" id="productName" placeholder="Tên sản phẩm" required>
                <input type="text" name="category" id="productCategory" placeholder="Danh mục" required>
                <input type="text" name="brand" id="productBrand" placeholder="Thương hiệu" required>
                <input type="text" name="supplier" id="productSupplier" placeholder="Nhà cung cấp" required>
                <input type="text" name="color" id="productColor" placeholder="Màu sắc" required>
                <input type="text" name="size" id="productSize" placeholder="Size" required>
                <input type="text" name="origin" id="productOrigin" placeholder="Xuất xứ" required>
                <select name="status" id="productStatus" required>
                    <option value="Còn hàng">Còn hàng</option>
                    <option value="Hết hàng">Hết hàng</option>
                    <option value="Sắp về">Sắp về</option>
                </select>
                <input type="number" step="1000" name="price" id="productPrice" placeholder="Giá" required>
                <input type="number" name="stock" id="productStock" placeholder="Tồn kho" required>
                <input type="text" name="image" id="productImage" placeholder="URL hình ảnh" required>
                <textarea name="description" id="productDescription" placeholder="Mô tả" required></textarea>
                <button type="submit" class="btn btn-primary" id="submitButton">Thêm mới</button>
            </form>
        </div>

        <div class="card table-card">
            <h3>Danh sách sản phẩm</h3>

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
                        <th>Nhà cung cấp</th>
                        <th>Màu sắc</th>
                        <th>Size</th>
                        <th>Xuất xứ</th>
                        <th>Trạng thái</th>
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
                        data-supplier="<%= p.getSupplier() == null ? "" : p.getSupplier() %>"
                        data-color="<%= p.getColor() == null ? "" : p.getColor() %>"
                        data-size="<%= p.getSize() == null ? "" : p.getSize() %>"
                        data-origin="<%= p.getOrigin() == null ? "" : p.getOrigin() %>"
                        data-status="<%= p.getStatus() == null ? "" : p.getStatus() %>"
                        data-price="<%= p.getPrice() %>"
                        data-stock="<%= p.getStock() %>"
                        data-image="<%= p.getImage() %>"
                        data-description="<%= p.getDescription() %>">
                        <td><%= p.getId() %></td>
                        <td><img src="<%= p.getImage() %>" alt="" class="thumb"></td>
                        <td><%= p.getName() %></td>
                        <td><%= p.getSupplier() == null ? "Chưa xác định" : p.getSupplier() %></td>
                        <td><%= p.getColor() == null ? "Không xác định" : p.getColor() %></td>
                        <td><%= p.getSize() == null ? "39" : p.getSize() %></td>
                        <td><%= p.getOrigin() == null ? "Chưa xác định" : p.getOrigin() %></td>
                        <td><%= p.getStatus() == null ? "Còn hàng" : p.getStatus() %></td>
                        <td><%= p.getPrice() %>₫</td>
                        <td><%= p.getStock() %></td>
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
            document.getElementById('productSupplier').value = row.dataset.supplier || '';
            document.getElementById('productColor').value = row.dataset.color || '';
            document.getElementById('productSize').value = row.dataset.size || '';
            document.getElementById('productOrigin').value = row.dataset.origin || '';
            document.getElementById('productStatus').value = row.dataset.status || 'Còn hàng';
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
