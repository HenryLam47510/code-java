package com._2003store.servlet;

import com._2003store.dao.InvoiceDao;
import com._2003store.dao.OrderDao;
import com._2003store.model.Invoice;
import com._2003store.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet({"/invoices", "/invoices/create"})
public class InvoiceServlet extends HttpServlet {
    private final InvoiceDao invoiceDao = new InvoiceDao();
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Invoice> invoices = invoiceDao.getAllInvoices();
        request.setAttribute("invoices", invoices);
        request.getRequestDispatcher("/invoices.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderIdParam = request.getParameter("orderId");
        String paymentMethod = request.getParameter("paymentMethod");
        String customerName = request.getParameter("customerName");
        String phone = request.getParameter("phone");

        if (orderIdParam == null || orderIdParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/invoices");
            return;
        }

        int orderId = Integer.parseInt(orderIdParam);
        Order order = orderDao.getAllOrders().stream()
                .filter(o -> o.getId() == orderId)
                .findFirst()
                .orElse(null);

        if (order != null) {
            Invoice invoice = new Invoice();
            invoice.setOrderId(orderId);
            invoice.setInvoiceCode("INV-" + LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE) + "-" + orderId);
            invoice.setCustomerName(customerName == null || customerName.isBlank() ? order.getCustomerName() : customerName);
            invoice.setPhone(phone == null || phone.isBlank() ? order.getPhone() : phone);
            invoice.setTotalAmount(order.getTotalAmount());
            invoice.setPaymentMethod(paymentMethod == null || paymentMethod.isBlank() ? "Tiền mặt" : paymentMethod);
            invoiceDao.createInvoice(invoice);
        }

        response.sendRedirect(request.getContextPath() + "/invoices");
    }
}
