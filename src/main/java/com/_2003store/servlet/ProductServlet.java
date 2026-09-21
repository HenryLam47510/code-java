package com._2003store.servlet;

import com._2003store.dao.ProductDao;
import com._2003store.model.Product;
import com._2003store.model.User;
import com._2003store.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet({"/products", "/products/add", "/products/update", "/products/delete"})
public class ProductServlet extends HttpServlet {
    private final ProductDao productDao = new ProductDao();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!authService.hasAccess(user, "products")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền quản lý sản phẩm.");
            return;
        }

        String path = request.getServletPath();
        if ("/products/delete".equals(path)) {
            int id = Integer.parseInt(request.getParameter("id"));
            productDao.softDeleteProduct(id, "Xóa khỏi danh sách sản phẩm");
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");
        String brand = request.getParameter("brand");
        String pageParam = request.getParameter("page");

        int page = 1;
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {
            }
        }

        int pageSize = 5;
        List<Product> allProducts = "STAFF".equalsIgnoreCase(user.getRole()) ? productDao.getVisibleProducts() : productDao.getAllProducts();
        List<Product> filteredProducts = new ArrayList<>();

        for (Product product : allProducts) {
            boolean matchesKeyword = keyword == null || keyword.isBlank() ||
                    product.getName().toLowerCase().contains(keyword.toLowerCase()) ||
                    product.getBrand().toLowerCase().contains(keyword.toLowerCase());
            boolean matchesCategory = category == null || category.isBlank() || category.equals("all") ||
                    category.equals(product.getCategory());
            boolean matchesBrand = brand == null || brand.isBlank() || brand.equals("all") ||
                    brand.equals(product.getBrand());

            if (matchesKeyword && matchesCategory && matchesBrand) {
                filteredProducts.add(product);
            }
        }

        int totalPages = Math.max(1, (int) Math.ceil(filteredProducts.size() / (double) pageSize));
        if (page > totalPages) page = totalPages;

        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, filteredProducts.size());
        List<Product> productsForPage = fromIndex >= filteredProducts.size() ? new ArrayList<>() : filteredProducts.subList(fromIndex, toIndex);

        request.setAttribute("products", productsForPage);
        request.setAttribute("allProducts", allProducts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("category", category);
        request.setAttribute("brand", brand);
        request.getRequestDispatcher("/products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!authService.hasAccess(user, "products")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền sửa sản phẩm.");
            return;
        }

        String path = request.getServletPath();
        String action = request.getParameter("action");

        Product product = new Product();
        product.setId(Integer.parseInt(request.getParameter("id")));
        product.setName(request.getParameter("name"));
        product.setCategory(request.getParameter("category"));
        product.setBrand(request.getParameter("brand"));
        product.setPrice(new BigDecimal(request.getParameter("price")));
        product.setStock(Integer.parseInt(request.getParameter("stock")));
        product.setImage(request.getParameter("image"));
        product.setDescription(request.getParameter("description"));

        if ("update".equals(action) || "/products/update".equals(path)) {
            productDao.updateProduct(product);
        } else {
            productDao.addProduct(product);
        }

        response.sendRedirect(request.getContextPath() + "/products");
    }
}
