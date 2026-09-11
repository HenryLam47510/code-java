package com._2003store.servlet;

import com._2003store.dao.LoginHistoryDao;
import com._2003store.model.User;
import com._2003store.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final AuthService authService = new AuthService();
    private final LoginHistoryDao loginHistoryDao = new LoginHistoryDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = authService.login(username, password);
        if (user != null) {
            request.getSession().setAttribute("user", user);
            loginHistoryDao.logLogin(username, user.getFullName(), "SUCCESS", request.getRemoteAddr());
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            if (username != null && !username.isBlank()) {
                loginHistoryDao.logLogin(username, username, "FAILED", request.getRemoteAddr());
            }
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
