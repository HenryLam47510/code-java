package com._2003store.dao;

import com._2003store.config.DatabaseConfig;
import com._2003store.model.CategoryStat;
import com._2003store.model.ProductSalesStat;
import com._2003store.model.RevenuePoint;
import com._2003store.service.OrderStatus;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ReportDao {
    private static final String ELIGIBLE_SALES = "SELECT oi.product_id, SUM(oi.quantity) AS quantity_sold, " +
            "SUM(oi.quantity * oi.unit_price) AS revenue FROM order_items oi " +
            "JOIN orders o ON o.id = oi.order_id " +
            "WHERE o.status IN (?, ?) AND o.payment_status IN (?, ?, ?, ?, ?, ?) " +
            "AND o.created_at >= ? AND o.created_at < ? GROUP BY oi.product_id";

    public List<RevenuePoint> getDailyRevenueForLast7Days() {
        List<RevenuePoint> points = new ArrayList<>();
        String sql = "SELECT DATE(created_at) AS label, COALESCE(SUM(total_amount), 0) AS total " +
                "FROM orders WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) " +
                "GROUP BY DATE(created_at) ORDER BY DATE(created_at) ASC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                points.add(new RevenuePoint(rs.getString("label"), rs.getBigDecimal("total")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return points;
    }

    public List<RevenuePoint> getMonthlyRevenueForLast6Months() {
        List<RevenuePoint> points = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(created_at, '%Y-%m') AS label, COALESCE(SUM(total_amount), 0) AS total " +
                "FROM orders WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 5 MONTH) " +
                "GROUP BY DATE_FORMAT(created_at, '%Y-%m') ORDER BY DATE_FORMAT(created_at, '%Y-%m') ASC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                points.add(new RevenuePoint(rs.getString("label"), rs.getBigDecimal("total")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return points;
    }

    public List<RevenuePoint> getRevenueByDateRange(String from, String to) {
        List<RevenuePoint> points = new ArrayList<>();
        String sql = "SELECT DATE(created_at) AS label, COALESCE(SUM(total_amount), 0) AS total " +
                "FROM orders WHERE DATE(created_at) BETWEEN ? AND ? AND status IN (?, ?) GROUP BY DATE(created_at) ORDER BY DATE(created_at) ASC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, from);
            stmt.setString(2, to);
            stmt.setString(3, "Da thanh toan");
            stmt.setString(4, "Hoan thanh");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    points.add(new RevenuePoint(rs.getString("label"), rs.getBigDecimal("total")));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return points;
    }

    public List<RevenuePoint> getRevenueSeries(String view) {
        List<RevenuePoint> points = new ArrayList<>();
        String sql;
        if ("month".equals(view)) {
            sql = "SELECT DATE_FORMAT(created_at, '%Y-%m') AS label, COALESCE(SUM(total_amount), 0) AS total FROM orders WHERE status IN (?, ?) AND created_at >= DATE_SUB(CURDATE(), INTERVAL 11 MONTH) GROUP BY DATE_FORMAT(created_at, '%Y-%m') ORDER BY DATE_FORMAT(created_at, '%Y-%m') ASC";
        } else if ("year".equals(view)) {
            sql = "SELECT YEAR(created_at) AS label, COALESCE(SUM(total_amount), 0) AS total FROM orders WHERE status IN (?, ?) GROUP BY YEAR(created_at) ORDER BY YEAR(created_at) ASC";
        } else {
            sql = "SELECT DATE(created_at) AS label, COALESCE(SUM(total_amount), 0) AS total FROM orders WHERE status IN (?, ?) AND created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) GROUP BY DATE(created_at) ORDER BY DATE(created_at) ASC";
        }
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "Da thanh toan");
            stmt.setString(2, "Hoan thanh");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    points.add(new RevenuePoint(rs.getString("label"), rs.getBigDecimal("total")));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return points;
    }

    public List<ProductSalesStat> getTopSellingProducts(Timestamp from, Timestamp toExclusive) {
        String sql = "SELECT p.name, sales.quantity_sold, sales.revenue FROM products p " +
                "JOIN (" + ELIGIBLE_SALES + ") sales ON sales.product_id = p.id " +
                "WHERE (p.is_deleted IS NULL OR p.is_deleted = false) " +
                "ORDER BY sales.quantity_sold DESC, p.name ASC LIMIT 5";
        List<ProductSalesStat> products = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            bindEligibleSalesRange(stmt, from, toExclusive);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(new ProductSalesStat(rs.getString("name"), rs.getInt("quantity_sold"), rs.getBigDecimal("revenue")));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public List<ProductSalesStat> getSlowSellingProducts(Timestamp from, Timestamp toExclusive) {
        String sql = "SELECT p.name, COALESCE(sales.quantity_sold, 0) AS quantity_sold, " +
                "COALESCE(sales.revenue, 0) AS revenue FROM products p " +
                "LEFT JOIN (" + ELIGIBLE_SALES + ") sales ON sales.product_id = p.id " +
                "WHERE (p.is_deleted IS NULL OR p.is_deleted = false) " +
                "ORDER BY quantity_sold ASC, p.name ASC LIMIT 5";
        List<ProductSalesStat> products = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            bindEligibleSalesRange(stmt, from, toExclusive);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(new ProductSalesStat(rs.getString("name"), rs.getInt("quantity_sold"), rs.getBigDecimal("revenue")));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public int getTotalUnitsSold(Timestamp from, Timestamp toExclusive) {
        String sql = "SELECT COALESCE(SUM(oi.quantity), 0) FROM order_items oi " +
                "JOIN orders o ON o.id = oi.order_id " +
                "WHERE o.status IN (?, ?) AND o.payment_status IN (?, ?, ?, ?, ?, ?) " +
                "AND o.created_at >= ? AND o.created_at < ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            bindEligibleSalesRange(stmt, from, toExclusive);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<CategoryStat> getProductCategoryDistribution() {
        String sql = "SELECT COALESCE(NULLIF(TRIM(category), ''), 'Khác') AS category_name, COUNT(*) AS product_count " +
                "FROM products WHERE is_deleted IS NULL OR is_deleted = false " +
                "GROUP BY COALESCE(NULLIF(TRIM(category), ''), 'Khác') ORDER BY product_count DESC, category_name ASC";
        List<CategoryStat> categories = new ArrayList<>();
        int totalProducts = 0;
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                int count = rs.getInt("product_count");
                totalProducts += count;
                categories.add(new CategoryStat(rs.getString("category_name"), count));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        if (totalProducts > 0) {
            for (CategoryStat category : categories) {
                category.setPercentage(category.getProductCount() * 100.0 / totalProducts);
            }
        }
        return categories;
    }

    private void bindEligibleSalesRange(PreparedStatement stmt, Timestamp from, Timestamp toExclusive) throws SQLException {
        stmt.setString(1, OrderStatus.PAID);
        stmt.setString(2, OrderStatus.COMPLETED);
        stmt.setString(3, OrderStatus.PAID_PAYMENT);
        stmt.setString(4, OrderStatus.PAID);
        stmt.setString(5, OrderStatus.COMPLETED);
        stmt.setString(6, "paid");
        stmt.setString(7, "completed");
        stmt.setString(8, "thanh toan thanh cong");
        stmt.setTimestamp(9, from);
        stmt.setTimestamp(10, toExclusive);
    }
}
