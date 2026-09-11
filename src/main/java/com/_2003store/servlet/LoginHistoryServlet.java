package com._2003store.servlet;

import com._2003store.dao.LoginHistoryDao;
import com._2003store.model.LoginHistory;
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<LoginHistory> histories = loginHistoryDao.getRecentLogins();
        request.setAttribute("histories", histories);
        request.getRequestDispatcher("/login-history.jsp").forward(request, response);
    }
}
