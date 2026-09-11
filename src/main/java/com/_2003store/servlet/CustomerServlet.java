package com._2003store.servlet;

import com._2003store.dao.CustomerDao;
import com._2003store.model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet({"/customers", "/customers/add"})
public class CustomerServlet extends HttpServlet {
    private final CustomerDao customerDao = new CustomerDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("customers", customerDao.getAllCustomers());
        request.getRequestDispatcher("/customers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String note = request.getParameter("note");

        Customer exists = customerDao.findByPhone(phone);
        if (exists == null) {
            Customer customer = new Customer();
            customer.setName(name);
            customer.setPhone(phone);
            customer.setEmail(email);
            customer.setNote(note);
            customerDao.addCustomer(customer);
        }

        response.sendRedirect(request.getContextPath() + "/customers");
    }
}
