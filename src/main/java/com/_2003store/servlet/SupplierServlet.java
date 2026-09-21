package com._2003store.servlet;

import com._2003store.dao.SupplierDao;
import com._2003store.model.Supplier;
import com._2003store.model.User;
import com._2003store.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet({"/suppliers", "/suppliers/add", "/suppliers/update"})
public class SupplierServlet extends HttpServlet {
    private final SupplierDao supplierDao = new SupplierDao();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!authService.hasAccess(user, "suppliers")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền quản lý nhà cung cấp.");
            return;
        }

        List<Supplier> suppliers = supplierDao.getAllSuppliers();
        request.setAttribute("suppliers", suppliers);
        request.getRequestDispatcher("/suppliers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!authService.hasAccess(user, "suppliers")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền quản lý nhà cung cấp.");
            return;
        }

        String action = request.getParameter("action");
        Supplier supplier = new Supplier();
        supplier.setId(request.getParameter("id") == null || request.getParameter("id").isBlank() ? 0 : Integer.parseInt(request.getParameter("id")));
        supplier.setName(request.getParameter("name"));
        supplier.setPhone(request.getParameter("phone"));
        supplier.setEmail(request.getParameter("email"));
        supplier.setAddress(request.getParameter("address"));
        supplier.setNote(request.getParameter("note"));

        if ("update".equals(action) && supplier.getId() > 0) {
            supplierDao.updateSupplier(supplier);
        } else {
            supplierDao.addSupplier(supplier);
        }

        response.sendRedirect(request.getContextPath() + "/suppliers");
    }
}
