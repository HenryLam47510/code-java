package com._2003store.servlet;

import com._2003store.dao.InventoryCheckDao;
import com._2003store.dao.ProductDao;
import com._2003store.model.InventoryCheck;
import com._2003store.model.Product;
import com._2003store.model.User;
import com._2003store.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet({"/inventory-check", "/inventory-check/add"})
public class InventoryCheckServlet extends HttpServlet {
    private final ProductDao productDao = new ProductDao();
    private final InventoryCheckDao inventoryCheckDao = new InventoryCheckDao();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!authService.hasAccess(user, "inventory-check")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền kiểm kho.");
            return;
        }

        List<Product> products = productDao.getAllProducts();
        List<InventoryCheck> checks = inventoryCheckDao.getAllChecks();
        request.setAttribute("products", products);
        request.setAttribute("checks", checks);
        request.getRequestDispatcher("/inventory-check.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!authService.hasAccess(user, "inventory-check")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền kiểm kho.");
            return;
        }

        String productIdParam = request.getParameter("productId");
        String countedParam = request.getParameter("countedQuantity");
        String countedBy = request.getParameter("countedBy");
        String note = request.getParameter("note");

        if (productIdParam == null || countedParam == null) {
            response.sendRedirect(request.getContextPath() + "/inventory-check");
            return;
        }

        int productId = Integer.parseInt(productIdParam);
        int countedQuantity = Integer.parseInt(countedParam);
        Product product = productDao.getProductById(productId);

        if (product != null) {
            InventoryCheck check = new InventoryCheck();
            check.setProductId(productId);
            check.setProductName(product.getName());
            check.setExpectedQuantity(product.getStock());
            check.setCountedQuantity(countedQuantity);
            check.setVariance(countedQuantity - product.getStock());
            check.setCountedBy(countedBy == null || countedBy.isBlank() ? "Nhân viên" : countedBy);
            check.setNote(note == null ? "" : note);
            inventoryCheckDao.saveCheck(check);
        }

        response.sendRedirect(request.getContextPath() + "/inventory-check");
    }
}
