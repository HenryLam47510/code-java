package com._2003store.servlet;

import com._2003store.dao.WarehouseDetailDao;
import com._2003store.model.User;
import com._2003store.model.WarehouseDetail;
import com._2003store.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/warehouse-detail")
public class WarehouseDetailServlet extends HttpServlet {
    private final WarehouseDetailDao warehouseDetailDao = new WarehouseDetailDao();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!authService.isAdmin(user) && !authService.isManager(user)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem chi tiết kho.");
            return;
        }

        List<WarehouseDetail> warehouseDetail = warehouseDetailDao.getWarehouseDetail();
        request.setAttribute("warehouseDetail", warehouseDetail);
        request.getRequestDispatcher("/warehouse-detail.jsp").forward(request, response);
    }
}
