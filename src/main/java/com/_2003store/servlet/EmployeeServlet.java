package com._2003store.servlet;

import com._2003store.dao.EmployeeDao;
import com._2003store.model.Employee;
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
