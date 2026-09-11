package com._2003store.servlet;

import com._2003store.dao.OrderDao;
import com._2003store.dao.ProductDao;
import com._2003store.model.Order;
import com._2003store.model.OrderItem;
import com._2003store.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet({"/orders", "/orders/create", "/orders/detail"})
public class OrderServlet extends HttpServlet {
    private final OrderDao orderDao = new OrderDao();
    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String detailId = request.getParameter("detailId");
        List<Order> orders = orderDao.getAllOrders();
        request.setAttribute("orders", orders);

        List<OrderItem> items = new ArrayList<>();
        for (Order order : orders) {
            items.addAll(orderDao.getOrderItems(order.getId()));
        }
        request.setAttribute("orderItemsMap", items);

        if (detailId != null && !detailId.isBlank()) {
            try {
                int orderId = Integer.parseInt(detailId);
                Order selectedOrder = orderDao.getOrderById(orderId);
                List<OrderItem> selectedItems = orderDao.getOrderItems(orderId);
                request.setAttribute("selectedOrder", selectedOrder);
                request.setAttribute("selectedOrderItems", selectedItems);
            } catch (NumberFormatException ignored) {
                request.setAttribute("selectedOrder", null);
                request.setAttribute("selectedOrderItems", new ArrayList<OrderItem>());
            }
        }

        request.getRequestDispatcher("/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String customerName = request.getParameter("customerName");
        String phone = request.getParameter("phone");
        String status = request.getParameter("status");
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");

        List<OrderItem> items = new ArrayList<>();
        BigDecimal total = BigDecimal.ZERO;

        if (productIds != null && quantities != null) {
            for (int i = 0; i < productIds.length; i++) {
                int productId = Integer.parseInt(productIds[i]);
                int quantity = Integer.parseInt(quantities[i]);
                if (quantity <= 0) continue;

                Product product = productDao.getProductById(productId);
                if (product != null) {
                    BigDecimal lineTotal = product.getPrice().multiply(BigDecimal.valueOf(quantity));
                    total = total.add(lineTotal);
                    OrderItem item = new OrderItem();
                    item.setProductId(productId);
                    item.setProductName(product.getName());
                    item.setQuantity(quantity);
                    item.setUnitPrice(product.getPrice());
                    items.add(item);
                }
            }
        }

        Order order = new Order();
        order.setCustomerName(customerName);
        order.setPhone(phone);
        order.setStatus(status == null || status.isBlank() ? "Cho xac nhan" : status);
        order.setTotalAmount(total);

        orderDao.createOrder(order, items);
        response.sendRedirect(request.getContextPath() + "/orders");
    }
}
