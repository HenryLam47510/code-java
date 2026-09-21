package com._2003store.servlet;

import com._2003store.dao.ProductDao;
import com._2003store.dao.StockReceiptDao;
import com._2003store.model.Product;
import com._2003store.model.StockReceipt;
import com._2003store.model.User;
import com._2003store.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet({"/stock", "/stock/add"})
public class StockReceiptServlet extends HttpServlet {
    private final StockReceiptDao stockReceiptDao = new StockReceiptDao();
    private final ProductDao productDao = new ProductDao();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!authService.isAdmin(user) && !authService.isManager(user)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền nhập kho.");
            return;
        }

        List<Product> products = productDao.getAllProducts();
        List<StockReceipt> receipts = stockReceiptDao.getAllReceipts();
        request.setAttribute("products", products);
        request.setAttribute("receipts", receipts);
        request.setAttribute("totalImportValue", stockReceiptDao.getTotalImportValue());
        request.getRequestDispatcher("/stock.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!authService.isAdmin(user) && !authService.isManager(user)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền nhập kho.");
            return;
        }

        String productIdParam = request.getParameter("productId");
        String supplier = request.getParameter("supplier");
        String quantityParam = request.getParameter("quantity");
        String unitPriceParam = request.getParameter("unitPrice");
        String note = request.getParameter("note");

        if (productIdParam == null || quantityParam == null || unitPriceParam == null) {
            response.sendRedirect(request.getContextPath() + "/stock");
            return;
        }

        int productId = Integer.parseInt(productIdParam);
        int quantity = Integer.parseInt(quantityParam);
        BigDecimal unitPrice = new BigDecimal(unitPriceParam);
        Product product = productDao.getProductById(productId);

        if (product != null) {
            StockReceipt receipt = new StockReceipt();
            receipt.setProductId(productId);
            receipt.setProductName(product.getName());
            receipt.setSupplier(supplier == null || supplier.isBlank() ? "Nhà cung cấp" : supplier);
            receipt.setQuantity(quantity);
            receipt.setUnitPrice(unitPrice);
            receipt.setTotalCost(unitPrice.multiply(BigDecimal.valueOf(quantity)));
            receipt.setNote(note == null ? "" : note);
            stockReceiptDao.createReceipt(receipt);
        }

        response.sendRedirect(request.getContextPath() + "/stock");
    }
}
