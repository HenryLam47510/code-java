package com._2003store.servlet;

import com._2003store.dao.ProductDao;
import com._2003store.model.Product;
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/products/delete".equals(path)) {
            int id = Integer.parseInt(request.getParameter("id"));
            productDao.deleteProduct(id);
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
        List<Product> allProducts = productDao.getAllProducts();
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
        String path = request.getServletPath();
        String action = request.getParameter("action");

        Product product = new Product();
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isBlank()) {
            product.setId(Integer.parseInt(idParam));
        }

        product.setName(request.getParameter("name"));
        product.setCategory(request.getParameter("category"));
        product.setBrand(request.getParameter("brand"));
        product.setSupplier(request.getParameter("supplier"));
        product.setColor(request.getParameter("color"));
        product.setSize(request.getParameter("size"));
        product.setStatus(request.getParameter("status"));
        product.setOrigin(request.getParameter("origin"));
        product.setPrice(new BigDecimal(request.getParameter("price")));
        product.setStock(Integer.parseInt(request.getParameter("stock")));
        product.setImage(request.getParameter("image"));
        product.setDescription(request.getParameter("description"));

        if (("update".equals(action) || "/products/update".equals(path)) && product.getId() > 0) {
            productDao.updateProduct(product);
        } else {
            productDao.addProduct(product);
        }

        response.sendRedirect(request.getContextPath() + "/products");
    }
}
