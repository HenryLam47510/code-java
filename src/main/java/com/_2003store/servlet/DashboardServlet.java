package com._2003store.servlet;

import com._2003store.dao.OrderDao;
import com._2003store.dao.ReportDao;
import com._2003store.model.CategoryStat;
import com._2003store.model.ProductSalesStat;
import com._2003store.model.User;
import com._2003store.service.AuthService;
import com._2003store.service.StatsService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;
import java.math.BigDecimal;

@WebServlet({"/dashboard", "/dashboard/admin", "/dashboard/manager", "/dashboard/employee"})
public class DashboardServlet extends HttpServlet {
    private final StatsService statsService = new StatsService();
    private final AuthService authService = new AuthService();
    private final ReportDao reportDao = new ReportDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!authService.hasAccess(user, "dashboard")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập dashboard.");
            return;
        }

        String dashboardKey = AuthService.getDashboardKey(user);
        String requestedPath = request.getServletPath();
        if ("/dashboard/admin".equals(requestedPath) && !"ADMIN".equals(AuthService.normalizeRole(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + AuthService.getDashboardPath(user));
            return;
        }
        if ("/dashboard/manager".equals(requestedPath) && !"MANAGER".equals(AuthService.normalizeRole(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + AuthService.getDashboardPath(user));
            return;
        }
        if ("/dashboard/employee".equals(requestedPath) && !"EMPLOYEE".equals(AuthService.normalizeRole(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + AuthService.getDashboardPath(user));
            return;
        }

        request.setAttribute("dashboardKey", dashboardKey);
        request.setAttribute("products", statsService.getRecentOrders());
        request.setAttribute("totalProducts", statsService.getTotalProducts());
        request.setAttribute("totalStock", statsService.getTotalStock());
        request.setAttribute("lowStockCount", statsService.getLowStockCount());
        request.setAttribute("pendingOrdersCount", statsService.getPendingOrdersCount());
        request.setAttribute("averageOrderValue", statsService.getAverageOrderValue());
        request.setAttribute("totalRevenue", statsService.getTotalRevenue());
        request.setAttribute("totalOrders", statsService.getTotalOrders());
        com._2003store.model.RevenueSummary todayRevenue = statsService.getTodayRevenueSummary();
        request.setAttribute("todayRevenue", todayRevenue);
        request.setAttribute("thisMonthRevenue", statsService.getThisMonthRevenue());

        String revenueView = request.getParameter("view");
        if (!"month".equals(revenueView) && !"year".equals(revenueView)) {
            revenueView = "day";
        }
        List<com._2003store.model.RevenuePoint> revenueSeries = reportDao.getRevenueSeries(revenueView);
        BigDecimal periodRevenue = BigDecimal.ZERO;
        if (revenueSeries != null) {
            for (com._2003store.model.RevenuePoint point : revenueSeries) {
                if (point.getValue() != null) {
                    periodRevenue = periodRevenue.add(point.getValue());
                }
            }
        }
        BigDecimal previousPeriodRevenue = reportDao.getPreviousPeriodRevenue(revenueView);
        request.setAttribute("revenueSeries", revenueSeries);
        request.setAttribute("revenueView", revenueView);
        request.setAttribute("periodRevenue", periodRevenue);
        request.setAttribute("previousPeriodRevenue", previousPeriodRevenue);
        request.setAttribute("recentOrders", statsService.getRecentOrders());
        request.setAttribute("notifications", new OrderDao().getOrderNotifications());

        LocalDate today = LocalDate.now();
        String period = request.getParameter("period");
        String fromValue = request.getParameter("from");
        String toValue = request.getParameter("to");
        LocalDate fromDate;
        LocalDate toDate;
        try {
            if ("today".equals(period)) {
                fromDate = today;
                toDate = today;
            } else if ("month".equals(period)) {
                fromDate = YearMonth.from(today).atDay(1);
                toDate = today;
            } else if ("year".equals(period)) {
                fromDate = today.withDayOfYear(1);
                toDate = today;
            } else if ("custom".equals(period)) {
                fromDate = LocalDate.parse(fromValue);
                toDate = LocalDate.parse(toValue);
                if (fromDate.isAfter(toDate)) {
                    throw new IllegalArgumentException("Invalid date range");
                }
            } else {
                period = "week";
                fromDate = today.minusDays(6);
                toDate = today;
            }
        } catch (RuntimeException e) {
            period = "week";
            fromDate = today.minusDays(6);
            toDate = today;
        }

        Timestamp rangeStart = Timestamp.valueOf(fromDate.atStartOfDay());
        Timestamp rangeEnd = Timestamp.valueOf(toDate.plusDays(1).atStartOfDay());
        List<ProductSalesStat> topProducts = reportDao.getTopSellingProducts(rangeStart, rangeEnd);
        List<ProductSalesStat> slowProducts = reportDao.getSlowSellingProducts(rangeStart, rangeEnd);
        List<CategoryStat> categories = reportDao.getProductCategoryDistribution();
        request.setAttribute("salesPeriod", period);
        request.setAttribute("salesFrom", fromDate);
        request.setAttribute("salesTo", toDate);
        request.setAttribute("topProducts", topProducts);
        request.setAttribute("slowProducts", slowProducts);
        request.setAttribute("totalUnitsSold", reportDao.getTotalUnitsSold(rangeStart, rangeEnd));
        request.setAttribute("categories", categories);
        request.setAttribute("totalCategories", categories.size());
        request.setAttribute("topCategory", categories.isEmpty() ? null : categories.get(0));
        request.setAttribute("bestSeller", topProducts.isEmpty() ? null : topProducts.get(0));
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
