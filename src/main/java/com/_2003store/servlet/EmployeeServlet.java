package com._2003store.servlet;

import com._2003store.dao.EmployeeDao;
import com._2003store.model.Employee;
import com._2003store.model.User;
import com._2003store.service.AuthService;
import com._2003store.service.PaymentConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet({"/employees", "/employee"})
public class EmployeeServlet extends HttpServlet {
    private final EmployeeDao employeeDao = new EmployeeDao();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!authService.hasAccess(user, "employees")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền quản lý nhân sự.");
            return;
        }

        String action = request.getParameter("action");
        String employeeId = request.getParameter("id");

        if ("delete".equals(action) && employeeId != null) {
            employeeDao.deleteEmployee(Integer.parseInt(employeeId));
            response.sendRedirect(request.getContextPath() + "/employees");
            return;
        }

        if ("edit".equals(action) && employeeId != null) {
            Employee employee = employeeDao.getEmployeeById(Integer.parseInt(employeeId));
            request.setAttribute("employeeEdit", employee);
        }

        List<Employee> employees = employeeDao.getAllEmployees();
        request.setAttribute("employees", employees);
        request.getRequestDispatcher("/employees.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!authService.hasAccess(user, "employees")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền quản lý nhân sự.");
            return;
        }

        String action = request.getParameter("action");
        if ("save-bank-config".equals(action)) {
            String bankId = request.getParameter("bankId");
            String accountNumber = request.getParameter("accountNumber");
            String accountName = request.getParameter("accountName");

            if (bankId == null || bankId.isBlank() || accountNumber == null || accountNumber.isBlank() || accountName == null || accountName.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/employees?error=" + java.net.URLEncoder.encode("Vui lòng nhập đầy đủ thông tin ngân hàng.", java.nio.charset.StandardCharsets.UTF_8));
                return;
            }

            PaymentConfig.setBankId(bankId);
            PaymentConfig.setAccountNumber(accountNumber);
            PaymentConfig.setAccountName(accountName);
            PaymentConfig.saveToDatabase();
            response.sendRedirect(request.getContextPath() + "/employees?success=" + java.net.URLEncoder.encode("Đã lưu thông tin tài khoản nhận tiền VietQR.", java.nio.charset.StandardCharsets.UTF_8));
            return;
        }

        String idParam = request.getParameter("id");
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String position = request.getParameter("position");
        String phone = request.getParameter("phone");

        if (fullName != null && !fullName.isBlank() && username != null && !username.isBlank()) {
            Employee employee = new Employee();
            if (idParam != null && !idParam.isBlank()) {
                employee.setId(Integer.parseInt(idParam));
            }
            employee.setFullName(fullName);
            employee.setUsername(username);
            employee.setPassword(password == null || password.isBlank() ? "123456" : password);
            employee.setRole(role == null || role.isBlank() ? "STAFF" : role.toUpperCase());
            employee.setPosition(position == null || position.isBlank() ? "Nhân viên" : position);
            employee.setPhone(phone);

            if (idParam != null && !idParam.isBlank()) {
                employeeDao.updateEmployee(employee);
            } else {
                employeeDao.createEmployee(employee);
            }
        }

        response.sendRedirect(request.getContextPath() + "/employees");
    }
}
