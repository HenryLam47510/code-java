package com._2003store.servlet;

import com._2003store.dao.StaffReportDao;
import com._2003store.model.LoginHistory;
import com._2003store.model.RevenuePoint;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/staff-report")
public class StaffReportServlet extends HttpServlet {
    private final StaffReportDao staffReportDao = new StaffReportDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String from = request.getParameter("from");
        String to = request.getParameter("to");

        if (from == null || from.isBlank()) {
            from = LocalDate.now().minusDays(6).toString();
        }
        if (to == null || to.isBlank()) {
            to = LocalDate.now().toString();
        }

        int totalEmployees = staffReportDao.getTotalEmployees();
        int successfulLogins = staffReportDao.getSuccessfulLogins(from, to);
        int failedLogins = staffReportDao.getFailedLogins(from, to);
        int activeEmployees = staffReportDao.getActiveEmployees(from, to);
        String topEmployee = staffReportDao.getTopEmployee(from, to);
        List<RevenuePoint> loginTrend = staffReportDao.getLoginTrendByDate(from, to);
        List<LoginHistory> recentActivities = staffReportDao.getRecentActivities(from, to);

        request.setAttribute("totalEmployees", totalEmployees);
        request.setAttribute("successfulLogins", successfulLogins);
        request.setAttribute("failedLogins", failedLogins);
        request.setAttribute("activeEmployees", activeEmployees);
        request.setAttribute("topEmployee", topEmployee);
        request.setAttribute("loginTrend", loginTrend);
        request.setAttribute("recentActivities", recentActivities);
        request.setAttribute("from", from);
        request.setAttribute("to", to);

        request.getRequestDispatcher("/staff-report.jsp").forward(request, response);
    }
}
