package com._2003store.servlet;

import com._2003store.dao.LoginHistoryDao;
import com._2003store.model.LoginHistory;
import com._2003store.model.User;
import com._2003store.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/login-history")
public class LoginHistoryServlet extends HttpServlet {
    private final LoginHistoryDao loginHistoryDao = new LoginHistoryDao();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!authService.hasAccess(user, "login-history")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem lịch sử đăng nhập.");
            return;
        }

        List<LoginHistory> histories = loginHistoryDao.getRecentLogins();
        request.setAttribute("histories", histories);
        request.getRequestDispatcher("/login-history.jsp").forward(request, response);
    }
}
