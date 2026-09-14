package com._2003store.dao;

import com._2003store.config.DatabaseConfig;
import com._2003store.model.Order;
import com._2003store.model.OrderItem;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {
    private final List<Order> fallbackOrders = new ArrayList<>();

    public OrderDao() {
        fallbackOrders.add(new Order(1001, "Nguyen Van A", "0901234567", "Đã hoàn tất", new BigDecimal("5499000"), Timestamp.valueOf("2026-09-10 10:15:00")));
        fallbackOrders.add(new Order(1002, "Tran Thi B", "0912345678", "Đã xác nhận", new BigDecimal("3999000"), Timestamp.valueOf("2026-09-09 16:20:00")));
        fallbackOrders.add(new Order(1003, "Le Van C", "0987654321", "Chờ thanh toán", new BigDecimal("7990000"), Timestamp.valueOf("2026-09-08 09:00:00")));
    }

    public List<Order> getRecentOrders() {
        try (Connection conn = DatabaseConfig.getConnection()) {
            String sql = "SELECT * FROM orders ORDER BY created_at DESC LIMIT 5";
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
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE DATE(created_at) = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, dateSql);
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
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE DATE_FORMAT(created_at, '%Y-%m') = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, monthSql);
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
            String sql = "SELECT * FROM orders ORDER BY created_at DESC";
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
        try (Connection conn = DatabaseConfig.getConnection()) {
            String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders";
            try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (SQLException e) {
            BigDecimal total = BigDecimal.ZERO;
            for (Order order : fallbackOrders) {
                total = total.add(order.getTotalAmount());
            }
            return total;
        }
        return BigDecimal.ZERO;
    }

    public int getTotalOrders() {
        try (Connection conn = DatabaseConfig.getConnection()) {
            String sql = "SELECT COUNT(*) FROM orders";
            try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            return fallbackOrders.size();
        }
        return 0;
    }

    public int getCompletedOrdersCount() {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = 'Đã hoàn tất'";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public BigDecimal getCompletedRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status = 'Đã hoàn tất'";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal getPaymentCompletionRate() {
        String sql = "SELECT CASE WHEN COUNT(*) = 0 THEN 0 ELSE ROUND((SUM(CASE WHEN payment_status IN ('Đã xác nhận', 'Đã hoàn tất') THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) END FROM orders";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public int getPendingOrdersCount() {
        String sql = "SELECT COUNT(*) FROM orders WHERE status IN ('Chờ thanh toán', 'Đã xác nhận')";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public void createOrder(Order order, List<OrderItem> items) {
        String orderSql = "INSERT INTO orders (customer_name, phone, status, payment_method, payment_amount, payment_status, qr_code, total_amount) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, order.getCustomerName());
                stmt.setString(2, order.getPhone());
                stmt.setString(3, order.getStatus());
                stmt.setString(4, Order.normalizePaymentMethod(order.getPaymentMethod()));
                stmt.setBigDecimal(5, order.getPaymentAmount());
                stmt.setString(6, order.getPaymentStatus());
                stmt.setString(7, order.getQrCode());
                stmt.setBigDecimal(8, order.getTotalAmount());
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Order> getPendingPaymentOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE status IN ('Chờ thanh toán', 'Đã xác nhận') ORDER BY created_at DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                orders.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public boolean confirmPayment(int orderId) {
        return confirmPayment(orderId, null);
    }

    public boolean confirmPayment(int orderId, String paymentMethod) {
        String sql = "UPDATE orders SET status = ?, payment_status = ?, payment_method = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String normalizedMethod = Order.normalizePaymentMethod(paymentMethod);
            stmt.setString(1, "Đã xác nhận");
            stmt.setString(2, "Đã xác nhận");
            stmt.setString(3, normalizedMethod);
            stmt.setInt(4, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean completeOrder(int orderId) {
        String sql = "UPDATE orders SET status = ?, payment_status = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "Đã hoàn tất");
            stmt.setString(2, "Đã hoàn tất");
            stmt.setInt(3, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.name AS product_name FROM order_items oi LEFT JOIN products p ON p.id = oi.product_id WHERE oi.order_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setProductId(rs.getInt("product_id"));
                    String productName = rs.getString("product_name");
                    if (productName == null || productName.isBlank()) {
                        productName = "Sản phẩm ID " + rs.getInt("product_id");
                    }
                    item.setProductName(productName);
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

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setCustomerName(rs.getString("customer_name"));
        order.setPhone(rs.getString("phone"));
        order.setStatus(rs.getString("status"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setPaymentAmount(rs.getBigDecimal("payment_amount"));
        order.setPaymentStatus(rs.getString("payment_status"));
        order.setQrCode(rs.getString("qr_code"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        return order;
    }
}
