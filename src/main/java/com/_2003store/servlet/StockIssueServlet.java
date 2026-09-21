package com._2003store.servlet;

import com._2003store.dao.ProductDao;
import com._2003store.dao.StockIssueDao;
import com._2003store.model.Product;
import com._2003store.model.StockIssue;
import com._2003store.model.User;
import com._2003store.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet({"/stock-out", "/stock-out/add"})
public class StockIssueServlet extends HttpServlet {
    private final ProductDao productDao = new ProductDao();
    private final StockIssueDao stockIssueDao = new StockIssueDao();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!authService.isAdmin(user) && !authService.isManager(user)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xuất kho.");
            return;
        }

        List<Product> products = productDao.getAllProducts();
        List<StockIssue> issues = stockIssueDao.getAllIssues();
        request.setAttribute("products", products);
        request.setAttribute("issues", issues);
        request.getRequestDispatcher("/stock-out.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!authService.isAdmin(user) && !authService.isManager(user)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xuất kho.");
            return;
        }

        String productIdParam = request.getParameter("productId");
        String quantityParam = request.getParameter("quantity");
        String reason = request.getParameter("reason");
        String note = request.getParameter("note");

        if (productIdParam == null || quantityParam == null) {
            response.sendRedirect(request.getContextPath() + "/stock-out");
            return;
        }

        int productId = Integer.parseInt(productIdParam);
        int quantity = Integer.parseInt(quantityParam);
        Product product = productDao.getProductById(productId);

        if (product != null && quantity > 0 && product.getStock() >= quantity) {
            StockIssue issue = new StockIssue();
            issue.setProductId(productId);
            issue.setProductName(product.getName());
            issue.setQuantity(quantity);
            issue.setReason(reason == null || reason.isBlank() ? "Bán hàng" : reason);
            issue.setNote(note == null ? "" : note);
            stockIssueDao.createIssue(issue);
        }

        response.sendRedirect(request.getContextPath() + "/stock-out");
    }
}
