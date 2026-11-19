package com._2003store.dao;

import com._2003store.config.DatabaseConfig;
import com._2003store.model.Order;
import com._2003store.model.OrderItem;
import com._2003store.model.OrderNotification;
import com._2003store.service.OrderStatus;

import com._2003store.service.OrderCodeGenerator;
import com._2003store.service.VietQrService;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class OrderDao {
    public OrderDao() {
    }

    public List<Order> getRecentOrders() {
        try (Connection conn = DatabaseConfig.getConnection()) {
            String sql = "SELECT * FROM orders WHERE is_hidden IS NULL OR is_hidden = false ORDER BY created_at DESC LIMIT 5";
            List<Order> orders = new ArrayList<>();
            try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrder(rs));
                }
            }
            return orders;
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public BigDecimal getRevenueByDate(String dateSql) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE DATE(created_at) = ? AND status IN (?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, dateSql);
            stmt.setString(2, OrderStatus.PAID);
            stmt.setString(3, OrderStatus.COMPLETED);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal getRevenueByDateAndPaymentMethods(String dateSql, String... paymentMethods) {
        if (paymentMethods == null || paymentMethods.length == 0) {
            throw new IllegalArgumentException("At least one payment method is required.");
        }

        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < paymentMethods.length; i++) {
            if (i > 0) {
                placeholders.append(", ");
            }
            placeholders.append("?");
        }

        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders " +
                "WHERE DATE(created_at) = ? AND status IN (?, ?) AND payment_method IN (" + placeholders + ")";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, dateSql);
            stmt.setString(2, OrderStatus.PAID);
            stmt.setString(3, OrderStatus.COMPLETED);
            for (int i = 0; i < paymentMethods.length; i++) {
                stmt.setString(i + 4, paymentMethods[i]);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal getRevenueByMonth(String monthSql) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE DATE_FORMAT(created_at, '%Y-%m') = ? AND status IN (?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, monthSql);
            stmt.setString(2, OrderStatus.PAID);
            stmt.setString(3, OrderStatus.COMPLETED);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection()) {
            String sql = "SELECT * FROM orders WHERE is_hidden IS NULL OR is_hidden = false ORDER BY created_at DESC";
            try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrder(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
        return orders;
    }

    public List<Order> getPendingOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE (status = ? OR status = ?) AND (is_hidden IS NULL OR is_hidden = false) ORDER BY created_at DESC LIMIT 5";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, OrderStatus.PENDING_CONFIRMATION);
            stmt.setString(2, OrderStatus.IN_TRANSIT);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrder(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapOrder(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public BigDecimal getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status IN (?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, OrderStatus.PAID);
            stmt.setString(2, OrderStatus.COMPLETED);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return BigDecimal.ZERO;
        }
        return BigDecimal.ZERO;
    }

    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM orders WHERE status IN (?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, OrderStatus.PAID);
            stmt.setString(2, OrderStatus.COMPLETED);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
        return 0;
    }

    public int getPendingOrdersCount() {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = ? OR status = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, OrderStatus.PENDING_CONFIRMATION);
            stmt.setString(2, OrderStatus.IN_TRANSIT);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public static class CreateOrderResult {
        private final boolean success;
        private final String message;

        public CreateOrderResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }

        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
    }

    public CreateOrderResult createOrder(Order order, List<OrderItem> items) {
        String dateKey = LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE);
        String orderSql = "INSERT INTO orders (customer_name, phone, status, payment_method, payment_status, transaction_note, qr_code, is_hidden, cancel_reason, total_amount, order_code, stock_deducted) VALUES (?, ?, ?, ?, ?, ?, ?, false, null, ?, ?, true)";
        try (Connection conn = DatabaseConfig.getConnection()) {
            conn.setAutoCommit(false);

            Map<Integer, OrderItem> aggregatedItems = new LinkedHashMap<>();
            for (OrderItem item : items) {
                OrderItem existing = aggregatedItems.get(item.getProductId());
                if (existing == null) {
                    aggregatedItems.put(item.getProductId(), item);
                } else {
                    existing.setQuantity(existing.getQuantity() + item.getQuantity());
                }
            }

            for (OrderItem item : aggregatedItems.values()) {
                if (item.getQuantity() <= 0) {
                    conn.rollback();
                    return new CreateOrderResult(false, "Số lượng sản phẩm phải lớn hơn 0.");
                }

                try (PreparedStatement lockStmt = conn.prepareStatement(
                        "SELECT stock, name FROM products WHERE id = ? AND (is_deleted IS NULL OR is_deleted = false) FOR UPDATE")) {
                    lockStmt.setInt(1, item.getProductId());
                    try (ResultSet rs = lockStmt.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return new CreateOrderResult(false, "Sản phẩm không tồn tại hoặc đã bị khóa.");
                        }
                        int currentStock = rs.getInt("stock");
                        if (currentStock < item.getQuantity()) {
                            conn.rollback();
                            return new CreateOrderResult(false,
                                    "Không đủ tồn kho cho sản phẩm " + rs.getString("name")
                                            + ". Tồn kho hiện tại: " + currentStock);
                        }
                    }
                }

                try (PreparedStatement stockStmt = conn.prepareStatement(
                        "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ? AND (is_deleted IS NULL OR is_deleted = false)")) {
                    stockStmt.setInt(1, item.getQuantity());
                    stockStmt.setInt(2, item.getProductId());
                    stockStmt.setInt(3, item.getQuantity());
                    if (stockStmt.executeUpdate() != 1) {
                        conn.rollback();
                        return new CreateOrderResult(false, "Tồn kho thay đổi trong lúc tạo đơn. Vui lòng thử lại.");
                    }
                }
            }

            String lockSql = "SELECT next_sequence FROM order_code_sequence WHERE date_key = ? FOR UPDATE";
            int nextSequence;
            try (PreparedStatement lockStmt = conn.prepareStatement(lockSql)) {
                lockStmt.setString(1, dateKey);
                try (ResultSet rs = lockStmt.executeQuery()) {
                    if (rs.next()) {
                        nextSequence = rs.getInt("next_sequence") + 1;
                        try (PreparedStatement updateStmt = conn.prepareStatement("UPDATE order_code_sequence SET next_sequence = ? WHERE date_key = ?")) {
                            updateStmt.setInt(1, nextSequence);
                            updateStmt.setString(2, dateKey);
                            updateStmt.executeUpdate();
                        }
                    } else {
                        nextSequence = 1;
                        try (PreparedStatement insertStmt = conn.prepareStatement("INSERT INTO order_code_sequence (date_key, next_sequence) VALUES (?, ?)")) {
                            insertStmt.setString(1, dateKey);
                            insertStmt.setInt(2, nextSequence);
                            insertStmt.executeUpdate();
                        }
                    }
                }
            }

            String orderCode = OrderCodeGenerator.generateForDate(LocalDate.now(), nextSequence);
            try (PreparedStatement stmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, order.getCustomerName());
                stmt.setString(2, order.getPhone());
                stmt.setString(3, OrderStatus.PENDING_CONFIRMATION);
                stmt.setString(4, order.getPaymentMethod());
                stmt.setString(5, order.getPaymentStatus() == null ? "CHUA_THANH_TOAN" : order.getPaymentStatus());
                stmt.setString(6, order.getTransactionNote());
                String qrCode = order.getQrCode();
                if ("BANK_TRANSFER".equalsIgnoreCase(order.getPaymentMethod()) && (qrCode == null || qrCode.isBlank())) {
                    qrCode = VietQrService.generateQrUrl(order.getTotalAmount(), orderCode);
                }
                stmt.setString(7, qrCode);
                stmt.setBigDecimal(8, order.getTotalAmount());
                stmt.setString(9, orderCode);
                stmt.executeUpdate();

                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (!keys.next()) {
                        throw new SQLException("Không thể lấy mã đơn hàng vừa tạo.");
                    }
                    int orderId = keys.getInt(1);
                    try (PreparedStatement itemStmt = conn.prepareStatement(
                            "INSERT INTO order_items (order_id, product_id, product_name, quantity, unit_price) VALUES (?, ?, ?, ?, ?)")) {
                        for (OrderItem item : aggregatedItems.values()) {
                            itemStmt.setInt(1, orderId);
                            itemStmt.setInt(2, item.getProductId());
                            itemStmt.setString(3, item.getProductName());
                            itemStmt.setInt(4, item.getQuantity());
                            itemStmt.setBigDecimal(5, item.getUnitPrice());
                            itemStmt.addBatch();
                        }
                        itemStmt.executeBatch();
                    }
                }
            }
            conn.commit();
            return new CreateOrderResult(true, "Tạo đơn hàng thành công.");
        } catch (SQLException e) {
            e.printStackTrace();
            return new CreateOrderResult(false, "Không thể tạo đơn hàng do lỗi cơ sở dữ liệu.");
        }
    }

    public void updatePaymentStatus(int orderId, String paymentMethod, String paymentStatus, String transactionNote, String qrCode) {
        String sql = "UPDATE orders SET payment_method = ?, payment_status = ?, transaction_note = ?, qr_code = ?, confirmed_at = CASE WHEN ? IN ('DA_THANH_TOAN', 'paid', 'completed', 'Thanh toan thanh cong') THEN COALESCE(confirmed_at, CURRENT_TIMESTAMP) ELSE NULL END WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String effectivePaymentStatus = paymentStatus == null || paymentStatus.isBlank() ? "DA_THANH_TOAN" : paymentStatus;
            stmt.setString(1, paymentMethod);
            stmt.setString(2, effectivePaymentStatus);
            stmt.setString(3, transactionNote);
            stmt.setString(4, qrCode);
            stmt.setString(5, effectivePaymentStatus);
            stmt.setInt(6, orderId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void hideOrder(int orderId, String reason) {
        String sql = "UPDATE orders SET is_hidden = true, cancel_reason = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, reason == null || reason.isBlank() ? "Ẩn đơn theo yêu cầu" : reason);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean confirmCashPayment(int orderId, String transactionNote) {
        try (Connection conn = DatabaseConfig.getConnection()) {
            conn.setAutoCommit(false);
            try {
                boolean stockAlreadyDeducted = false;
                String lockOrderSql = "SELECT status, payment_status, COALESCE(stock_deducted,false) stock_deducted FROM orders WHERE id = ? FOR UPDATE";
                try (PreparedStatement lockStmt = conn.prepareStatement(lockOrderSql)) {
                    lockStmt.setInt(1, orderId);
                    try (ResultSet rs = lockStmt.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return false;
                        }
                        if (OrderStatus.isPaidStatus(rs.getString("status"))) {
                            conn.rollback();
                            return false;
                        }
                        stockAlreadyDeducted = rs.getBoolean("stock_deducted");
                    }
                }

                if (!stockAlreadyDeducted) {
                    String itemsSql = "SELECT product_id, quantity FROM order_items WHERE order_id = ?";
                    try (PreparedStatement itemsStmt = conn.prepareStatement(itemsSql)) {
                        itemsStmt.setInt(1, orderId);
                        try (ResultSet rs = itemsStmt.executeQuery()) {
                            while (rs.next()) {
                                int productId = rs.getInt("product_id");
                                int quantity = rs.getInt("quantity");
                                try (PreparedStatement stockStmt = conn.prepareStatement("UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ? AND (is_deleted IS NULL OR is_deleted = false)")) {
                                    stockStmt.setInt(1, quantity);
                                    stockStmt.setInt(2, productId);
                                    stockStmt.setInt(3, quantity);
                                    if (stockStmt.executeUpdate() != 1) {
                                        conn.rollback();
                                        return false;
                                    }
                                }
                            }
                        }
                    }
                }

                try (PreparedStatement updateStmt = conn.prepareStatement("UPDATE orders SET status = ?, payment_method = 'COD', payment_status = 'DA_THANH_TOAN', transaction_note = ?, stock_deducted = true, confirmed_at = COALESCE(confirmed_at, CURRENT_TIMESTAMP) WHERE id = ?")) {
                    updateStmt.setString(1, OrderStatus.COMPLETED);
                    updateStmt.setString(2, transactionNote);
                    updateStmt.setInt(3, orderId);
                    updateStmt.executeUpdate();
                }
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cancelOrder(int orderId, String reason) {
        try (Connection conn = DatabaseConfig.getConnection()) {
            conn.setAutoCommit(false);
            try {
                boolean restoreStock = false;
                try (PreparedStatement lockStmt = conn.prepareStatement("SELECT COALESCE(stock_deducted,false) FROM orders WHERE id = ? FOR UPDATE")) {
                    lockStmt.setInt(1, orderId);
                    try (ResultSet rs = lockStmt.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return false;
                        }
                        restoreStock = rs.getBoolean(1);
                    }
                }

                if (restoreStock) {
                    try (PreparedStatement itemsStmt = conn.prepareStatement("SELECT product_id, quantity FROM order_items WHERE order_id = ?")) {
                        itemsStmt.setInt(1, orderId);
                        try (ResultSet rs = itemsStmt.executeQuery()) {
                            while (rs.next()) {
                                try (PreparedStatement stockStmt = conn.prepareStatement("UPDATE products SET stock = stock + ? WHERE id = ?")) {
                                    stockStmt.setInt(1, rs.getInt("quantity"));
                                    stockStmt.setInt(2, rs.getInt("product_id"));
                                    stockStmt.executeUpdate();
                                }
                            }
                        }
                    }
                }

                try (PreparedStatement updateStmt = conn.prepareStatement("UPDATE orders SET status = ?, payment_status = 'DA_HUY', cancel_reason = ?, is_hidden = true, stock_deducted = false, confirmed_at = NULL WHERE id = ?")) {
                    updateStmt.setString(1, OrderStatus.CANCELLED);
                    updateStmt.setString(2, reason);
                    updateStmt.setInt(3, orderId);
                    updateStmt.executeUpdate();
                }
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void updateOrderStatus(int orderId, String status, String paymentMethod, String paymentStatus, String transactionNote, String cancelReason) {
        String sql = "UPDATE orders SET status = ?, payment_method = ?, payment_status = ?, transaction_note = ?, cancel_reason = ?, confirmed_at = CASE WHEN (? IN ('Da thanh toan', 'Hoan thanh', 'paid', 'completed') OR ? IN ('DA_THANH_TOAN', 'paid', 'completed', 'Thanh toan thanh cong')) THEN COALESCE(confirmed_at, CURRENT_TIMESTAMP) ELSE NULL END WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String effectivePaymentStatus = paymentStatus == null || paymentStatus.isBlank() ? "CHUA_THANH_TOAN" : paymentStatus;
            stmt.setString(1, status);
            stmt.setString(2, paymentMethod == null || paymentMethod.isBlank() ? "COD" : paymentMethod);
            stmt.setString(3, effectivePaymentStatus);
            stmt.setString(4, transactionNote);
            stmt.setString(5, cancelReason);
            stmt.setString(6, status);
            stmt.setString(7, effectivePaymentStatus);
            stmt.setInt(8, orderId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("product_name"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getBigDecimal("unit_price"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public List<OrderNotification> getOrderNotifications() {
        List<OrderNotification> notifications = new ArrayList<>();
        String sql = "SELECT id, order_code, customer_name, status, payment_method, payment_status, created_at FROM orders WHERE is_hidden IS NULL OR is_hidden = false ORDER BY created_at DESC LIMIT 10";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String orderCode = rs.getString("order_code");
                String orderStatus = rs.getString("status");
                String paymentMethod = rs.getString("payment_method");
                String paymentStatus = rs.getString("payment_status");
                String code = orderCode == null || orderCode.isBlank() ? "DH" + rs.getInt("id") : orderCode;

                if (OrderStatus.PENDING_CONFIRMATION.equalsIgnoreCase(orderStatus) || OrderStatus.PENDING_PAYMENT.equalsIgnoreCase(orderStatus)) {
                    OrderNotification notification = new OrderNotification();
                    notification.setOrderId(rs.getInt("id"));
                    notification.setOrderCode(code);
                    notification.setType("Đơn hàng mới");
                    notification.setTitle("Đơn hàng mới cần xử lý");
                    notification.setMessage("Đơn hàng " + code + " đang chờ xác nhận thanh toán.");
                    notification.setStatus("Chờ xác nhận");
                    notification.setCreatedAt(rs.getTimestamp("created_at"));
                    notifications.add(notification);
                }

                if (OrderStatus.BANK_TRANSFER.equalsIgnoreCase(paymentMethod) && (OrderStatus.PAID_PAYMENT.equalsIgnoreCase(paymentStatus) || OrderStatus.PAID.equalsIgnoreCase(orderStatus) || OrderStatus.COMPLETED.equalsIgnoreCase(orderStatus))) {
                    OrderNotification notification = new OrderNotification();
                    notification.setOrderId(rs.getInt("id"));
                    notification.setOrderCode(code);
                    notification.setType("Chuyển khoản");
                    notification.setTitle("Đã nhận thanh toán chuyển khoản");
                    notification.setMessage("Đơn hàng " + code + " đã xác nhận thanh toán qua VietQR.");
                    notification.setStatus("Đã xác nhận");
                    notification.setCreatedAt(rs.getTimestamp("created_at"));
                    notifications.add(notification);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setOrderCode(rs.getString("order_code"));
        order.setCustomerName(rs.getString("customer_name"));
        order.setPhone(rs.getString("phone"));
        order.setStatus(rs.getString("status"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setPaymentStatus(rs.getString("payment_status"));
        order.setTransactionNote(rs.getString("transaction_note"));
        order.setQrCode(rs.getString("qr_code"));
        order.setHidden(rs.getBoolean("is_hidden"));
        order.setCancelReason(rs.getString("cancel_reason"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        return order;
    }
}
