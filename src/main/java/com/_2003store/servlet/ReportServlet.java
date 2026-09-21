package com._2003store.servlet;

import com._2003store.dao.ReportDao;
import com._2003store.model.RevenuePoint;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {
    private final ReportDao reportDao = new ReportDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String from = request.getParameter("from");
        String to = request.getParameter("to");
        String view = request.getParameter("view");
        if (view == null || view.isBlank()) {
            view = "day";
        }

        if ("day".equals(view)) {
            if (from == null || from.isBlank()) {
                from = java.time.LocalDate.now().minusDays(6).toString();
            }
            if (to == null || to.isBlank()) {
                to = java.time.LocalDate.now().toString();
            }
            List<RevenuePoint> dailyRevenue = reportDao.getRevenueByDateRange(from, to);
            request.setAttribute("revenueSeries", dailyRevenue);
            request.setAttribute("dailyRevenue", dailyRevenue);
        } else {
            request.setAttribute("revenueSeries", reportDao.getRevenueSeries(view));
        }

        request.setAttribute("from", from);
        request.setAttribute("to", to);
        request.setAttribute("selectedView", view);
        request.getRequestDispatcher("/reports.jsp").forward(request, response);
    }
}
