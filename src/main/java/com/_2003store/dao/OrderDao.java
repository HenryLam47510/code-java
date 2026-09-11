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
        fallbackOrders.add(new Order(1001, "Nguyen Van A", "0901234567", "Hoan thanh", new BigDecimal("5499000"), Timestamp.valueOf("2026-09-10 10:15:00")));
        fallbackOrders.add(new Order(1002, "Tran Thi B", "0912345678", "Dang giao", new BigDecimal("3999000"), Timestamp.valueOf("2026-09-09 16:20:00")));
        fallbackOrders.add(new Order(1003, "Le Van C", "0987654321", "Cho xac nhan", new BigDecimal("7990000"), Timestamp.valueOf("2026-09-08 09:00:00")));
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

    public int getPendingOrdersCount() {
        String sql = "SELECT COUNT(*) FROM orders WHERE status IN ('Cho xac nhan', 'Dang giao')";
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
        String orderSql = "INSERT INTO orders (customer_name, phone, status, total_amount) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, order.getCustomerName());
                stmt.setString(2, order.getPhone());
                stmt.setString(3, order.getStatus());
                stmt.setBigDecimal(4, order.getTotalAmount());
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

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setCustomerName(rs.getString("customer_name"));
        order.setPhone(rs.getString("phone"));
        order.setStatus(rs.getString("status"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        return order;
    }
}
