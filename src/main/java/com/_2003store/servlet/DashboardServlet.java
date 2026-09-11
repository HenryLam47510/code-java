package com._2003store.servlet;

import com._2003store.model.User;
import com._2003store.service.StatsService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private final StatsService statsService = new StatsService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("products", statsService.getRecentOrders());
        request.setAttribute("totalProducts", statsService.getTotalProducts());
        request.setAttribute("totalStock", statsService.getTotalStock());
        request.setAttribute("lowStockCount", statsService.getLowStockCount());
        request.setAttribute("pendingOrdersCount", statsService.getPendingOrdersCount());
        request.setAttribute("averageOrderValue", statsService.getAverageOrderValue());
        request.setAttribute("totalRevenue", statsService.getTotalRevenue());
        request.setAttribute("totalOrders", statsService.getTotalOrders());
        request.setAttribute("todayRevenue", statsService.getTodayRevenue());
        request.setAttribute("thisMonthRevenue", statsService.getThisMonthRevenue());
        request.setAttribute("recentOrders", statsService.getRecentOrders());
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
