package com._2003store.servlet;

import com._2003store.dao.InventoryReportDao;
import com._2003store.model.InventoryReportItem;
import com._2003store.model.User;
import com._2003store.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/inventory-report")
public class InventoryReportServlet extends HttpServlet {
    private final InventoryReportDao inventoryReportDao = new InventoryReportDao();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!authService.hasAccess(user, "inventory-report")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem báo cáo kho.");
            return;
        }

        List<InventoryReportItem> report = inventoryReportDao.getInventoryReport();
        request.setAttribute("report", report);
        request.getRequestDispatcher("/inventory-report.jsp").forward(request, response);
    }
}
