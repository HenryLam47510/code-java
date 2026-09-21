package com._2003store.servlet;

import com._2003store.dao.OrderDao;
import com._2003store.dao.ProductDao;
import com._2003store.model.Order;
import com._2003store.model.OrderItem;
import com._2003store.model.Product;
import com._2003store.model.User;
import com._2003store.service.AuthService;
import com._2003store.service.OrderStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@WebServlet({"/orders", "/orders/create", "/orders/detail"})
public class OrderServlet extends HttpServlet {
    private final OrderDao orderDao = new OrderDao();
    private final ProductDao productDao = new ProductDao();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!authService.hasAccess(user, "orders")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền quản lý đơn hàng.");
            return;
        }

        String detailId = request.getParameter("detailId");
        List<Order> orders = orderDao.getAllOrders();
        List<Order> pendingOrders = orderDao.getPendingOrders();
        List<Product> availableProducts = productDao.getVisibleProducts();
        request.setAttribute("orders", orders);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("notifications", orderDao.getOrderNotifications());
        request.setAttribute("availableProducts", availableProducts);

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
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!authService.hasAccess(user, "orders")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền tạo đơn hàng.");
            return;
        }

        String action = request.getParameter("action");
        if ("confirm-payment".equals(action)) {
            if (!authService.hasAccess(user, "payment_confirm")) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xác nhận thanh toán.");
                return;
            }
        }
        if ("confirm-payment".equals(action) || "cancel-order".equals(action)) {
            String orderIdParam = request.getParameter("orderId");
            if (orderIdParam == null || orderIdParam.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }
            try {
                int orderId = Integer.parseInt(orderIdParam);
                String paymentMethod = request.getParameter("paymentMethod");
                String paymentStatus = request.getParameter("paymentStatus");
                String transactionNote = request.getParameter("transactionNote");
                if ("cancel-order".equals(action)) {
                    String cancelReason = request.getParameter("cancelReason");
                    orderDao.updateOrderStatus(orderId, OrderStatus.CANCELLED, paymentMethod, "DA_HUY", transactionNote, cancelReason);
                    orderDao.hideOrder(orderId, cancelReason);
                    response.sendRedirect(request.getContextPath() + "/orders?detailId=" + orderId + "&success=" + URLEncoder.encode("Đơn hàng đã được hủy.", StandardCharsets.UTF_8));
                    return;
                }
                String resolvedPaymentMethod = paymentMethod == null || paymentMethod.isBlank() ? "COD" : paymentMethod;
                String resolvedStatus = "BANK_TRANSFER".equalsIgnoreCase(resolvedPaymentMethod) ? OrderStatus.PAID : OrderStatus.COMPLETED;
                String resolvedPayment = paymentStatus == null || paymentStatus.isBlank() ? "DA_THANH_TOAN" : paymentStatus;
                orderDao.updateOrderStatus(orderId, resolvedStatus, resolvedPaymentMethod, resolvedPayment, transactionNote, null);
                response.sendRedirect(request.getContextPath() + "/orders?detailId=" + orderId + "&success=" + URLEncoder.encode("Đơn hàng đã được xác nhận thanh toán.", StandardCharsets.UTF_8));
                return;
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/orders?error=" + URLEncoder.encode("Mã đơn hàng không hợp lệ.", StandardCharsets.UTF_8));
                return;
            }
        }

        String customerName = request.getParameter("customerName");
        String phone = request.getParameter("phone");
        String paymentMethod = request.getParameter("paymentMethod");
        String transactionNote = request.getParameter("transactionNote");
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");

        if (customerName == null || customerName.isBlank() || phone == null || phone.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/orders?error=" + URLEncoder.encode("Vui lòng nhập tên khách hàng và số điện thoại.", StandardCharsets.UTF_8));
            return;
        }

        List<OrderItem> items = new ArrayList<>();
        BigDecimal total = BigDecimal.ZERO;

        if (productIds == null || quantities == null || productIds.length == 0 || quantities.length == 0) {
            response.sendRedirect(request.getContextPath() + "/orders?error=" + URLEncoder.encode("Vui lòng chọn ít nhất một sản phẩm để tạo đơn.", StandardCharsets.UTF_8));
            return;
        }

        for (int i = 0; i < productIds.length; i++) {
            String rawProductId = productIds[i];
            String rawQuantity = quantities[i];
            if (rawProductId == null || rawQuantity == null || rawProductId.isBlank() || rawQuantity.isBlank()) {
                continue;
            }
            try {
                int productId = Integer.parseInt(rawProductId);
                int quantity = Integer.parseInt(rawQuantity);
                if (quantity <= 0) {
                    continue;
                }

                Product product = productDao.getProductById(productId);
                if (product == null) {
                    response.sendRedirect(request.getContextPath() + "/orders?error=" + URLEncoder.encode("Sản phẩm không tồn tại.", StandardCharsets.UTF_8));
                    return;
                }
                if (product.getStock() < quantity) {
                    response.sendRedirect(request.getContextPath() + "/orders?error=" + URLEncoder.encode("Không đủ tồn kho cho sản phẩm " + product.getName() + ". Tồn kho hiện tại: " + product.getStock(), StandardCharsets.UTF_8));
                    return;
                }

                BigDecimal lineTotal = product.getPrice().multiply(BigDecimal.valueOf(quantity));
                total = total.add(lineTotal);
                OrderItem item = new OrderItem();
                item.setProductId(productId);
                item.setProductName(product.getName());
                item.setQuantity(quantity);
                item.setUnitPrice(product.getPrice());
                items.add(item);
            } catch (NumberFormatException ignored) {
                response.sendRedirect(request.getContextPath() + "/orders?error=" + URLEncoder.encode("Dữ liệu sản phẩm không hợp lệ.", StandardCharsets.UTF_8));
                return;
            }
        }

        if (items.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orders?error=" + URLEncoder.encode("Đơn hàng không có sản phẩm hợp lệ.", StandardCharsets.UTF_8));
            return;
        }

        Order order = new Order();
        order.setCustomerName(customerName);
        order.setPhone(phone);
        order.setStatus(OrderStatus.PENDING_CONFIRMATION);
        order.setPaymentMethod(paymentMethod == null || paymentMethod.isBlank() ? "COD" : paymentMethod);
        order.setPaymentStatus("CHUA_THANH_TOAN");
        order.setTransactionNote(transactionNote);
        order.setTotalAmount(total);

        orderDao.createOrder(order, items);
        response.sendRedirect(request.getContextPath() + "/orders");
    }
}
