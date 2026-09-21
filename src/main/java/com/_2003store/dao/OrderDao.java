package com._2003store.dao;

import com._2003store.config.DatabaseConfig;
import com._2003store.model.Order;
import com._2003store.model.OrderItem;
import com._2003store.model.OrderNotification;
import com._2003store.service.OrderStatus;

import com._2003store.service.OrderCodeGenerator;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {
    private final List<Order> fallbackOrders = new ArrayList<>();

    public OrderDao() {
        fallbackOrders.add(new Order(1001, "Nguyen Van A", "0901234567", OrderStatus.COMPLETED, new BigDecimal("5499000"), Timestamp.valueOf("2026-09-10 10:15:00")));
        fallbackOrders.add(new Order(1002, "Tran Thi B", "0912345678", OrderStatus.IN_TRANSIT, new BigDecimal("3999000"), Timestamp.valueOf("2026-09-09 16:20:00")));
        fallbackOrders.add(new Order(1003, "Le Van C", "0987654321", OrderStatus.PENDING_CONFIRMATION, new BigDecimal("7990000"), Timestamp.valueOf("2026-09-08 09:00:00")));
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
            return fallbackOrders;
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
            return fallbackOrders;
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
            BigDecimal total = BigDecimal.ZERO;
            for (Order order : fallbackOrders) {
                if (OrderStatus.isRevenueEligible(order.getStatus())) {
                    total = total.add(order.getTotalAmount());
                }
            }
            return total;
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
            int count = 0;
            for (Order order : fallbackOrders) {
                if (OrderStatus.isRevenueEligible(order.getStatus())) {
                    count++;
                }
            }
            return count;
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

    public void createOrder(Order order, List<OrderItem> items) {
        String dateKey = LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE);
        String orderSql = "INSERT INTO orders (customer_name, phone, status, payment_method, payment_status, transaction_note, qr_code, is_hidden, cancel_reason, total_amount, order_code) VALUES (?, ?, ?, ?, ?, ?, ?, false, null, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection()) {
            conn.setAutoCommit(false);
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
                stmt.setString(3, OrderStatus.isPaidStatus(order.getStatus()) ? order.getStatus() : OrderStatus.PENDING_CONFIRMATION);
                stmt.setString(4, order.getPaymentMethod());
                stmt.setString(5, order.getPaymentStatus() == null ? "CHUA_THANH_TOAN" : order.getPaymentStatus());
                stmt.setString(6, order.getTransactionNote());
                stmt.setString(7, order.getQrCode());
                stmt.setBigDecimal(8, order.getTotalAmount());
                stmt.setString(9, orderCode);
                stmt.executeUpdate();

                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) {
                        int orderId = keys.getInt(1);
                        String itemSql = "INSERT INTO order_items (order_id, product_id, product_name, quantity, unit_price) VALUES (?, ?, ?, ?, ?)";
                        try (PreparedStatement itemStmt = conn.prepareStatement(itemSql)) {
                            for (OrderItem item : items) {
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
            }
            conn.commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updatePaymentStatus(int orderId, String paymentMethod, String paymentStatus, String transactionNote, String qrCode) {
        String sql = "UPDATE orders SET payment_method = ?, payment_status = ?, transaction_note = ?, qr_code = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, paymentMethod);
            stmt.setString(2, paymentStatus == null || paymentStatus.isBlank() ? "DA_THANH_TOAN" : paymentStatus);
            stmt.setString(3, transactionNote);
            stmt.setString(4, qrCode);
            stmt.setInt(5, orderId);
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

    public void updateOrderStatus(int orderId, String status, String paymentMethod, String paymentStatus, String transactionNote, String cancelReason) {
        String sql = "UPDATE orders SET status = ?, payment_method = ?, payment_status = ?, transaction_note = ?, cancel_reason = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setString(2, paymentMethod == null || paymentMethod.isBlank() ? "COD" : paymentMethod);
            stmt.setString(3, paymentStatus == null || paymentStatus.isBlank() ? "CHUA_THANH_TOAN" : paymentStatus);
            stmt.setString(4, transactionNote);
            stmt.setString(5, cancelReason);
            stmt.setInt(6, orderId);
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

                if (OrderStatus.PENDING_CONFIRMATION.equals(orderStatus) || OrderStatus.IN_TRANSIT.equals(orderStatus)) {
                    OrderNotification notification = new OrderNotification();
                    notification.setOrderId(rs.getInt("id"));
                    notification.setOrderCode(code);
                    notification.setType("Đơn hàng mới cần xử lý");
                    notification.setTitle("Đơn hàng mới cần xử lý");
                    notification.setMessage("Đơn hàng " + code + " đang chờ thanh toán.");
                    notification.setStatus("Chờ thanh toán");
                    notification.setCreatedAt(rs.getTimestamp("created_at"));
                    notifications.add(notification);
                }

                if ("BANK_TRANSFER".equalsIgnoreCase(paymentMethod) && ("DA_THANH_TOAN".equalsIgnoreCase(paymentStatus) || OrderStatus.PAID.equalsIgnoreCase(orderStatus) || OrderStatus.COMPLETED.equalsIgnoreCase(orderStatus))) {
                    OrderNotification notification = new OrderNotification();
                    notification.setOrderId(rs.getInt("id"));
                    notification.setOrderCode(code);
                    notification.setType("Đã nhận thanh toán");
                    notification.setTitle("Đã nhận thanh toán");
                    notification.setMessage("Đơn hàng " + code + " đã nhận được thanh toán chuyển khoản.");
                    notification.setStatus("Đã thanh toán");
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
