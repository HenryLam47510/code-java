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
    private static final String ELIGIBLE_ORDER_CONDITION =
            "(is_hidden IS NULL OR is_hidden = false) AND status IN (?, ?) " +
                    "AND payment_status IN (?, ?, ?, ?, ?, ?)";
    private static final String ELIGIBLE_SALES = "SELECT oi.product_id, SUM(oi.quantity) AS quantity_sold, " +
            "SUM(oi.quantity * oi.unit_price) AS revenue FROM order_items oi " +
            "JOIN orders o ON o.id = oi.order_id " +
            "WHERE " + ELIGIBLE_ORDER_CONDITION + " " +
            "AND o.created_at >= ? AND o.created_at < ? GROUP BY oi.product_id";

    public List<RevenuePoint> getDailyRevenueForLast7Days() {
        List<RevenuePoint> points = new ArrayList<>();
        String sql = "SELECT DATE(created_at) AS label, COALESCE(SUM(total_amount), 0) AS total " +
                "FROM orders WHERE " + ELIGIBLE_ORDER_CONDITION +
                " AND created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) " +
                "GROUP BY DATE(created_at) ORDER BY DATE(created_at) ASC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            bindEligibleOrderStatuses(stmt, 1);
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

    public List<RevenuePoint> getMonthlyRevenueForLast6Months() {
        List<RevenuePoint> points = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(created_at, '%Y-%m') AS label, COALESCE(SUM(total_amount), 0) AS total " +
                "FROM orders WHERE " + ELIGIBLE_ORDER_CONDITION +
                " AND created_at >= DATE_SUB(CURDATE(), INTERVAL 5 MONTH) " +
                "GROUP BY DATE_FORMAT(created_at, '%Y-%m') ORDER BY DATE_FORMAT(created_at, '%Y-%m') ASC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            bindEligibleOrderStatuses(stmt, 1);
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

    public List<RevenuePoint> getRevenueByDateRange(String from, String to) {
        List<RevenuePoint> points = new ArrayList<>();
        String sql = "SELECT DATE(created_at) AS label, COALESCE(SUM(total_amount), 0) AS total " +
                "FROM orders WHERE " + ELIGIBLE_ORDER_CONDITION +
                " AND created_at >= ? AND created_at < DATE_ADD(?, INTERVAL 1 DAY) " +
                "GROUP BY DATE(created_at) ORDER BY DATE(created_at) ASC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            bindEligibleOrderStatuses(stmt, 1);
            stmt.setString(9, from);
            stmt.setString(10, to);
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
            sql = "SELECT DATE_FORMAT(created_at, '%Y-%m') AS label, COALESCE(SUM(total_amount), 0) AS total " +
                    "FROM orders WHERE " + ELIGIBLE_ORDER_CONDITION +
                    " AND created_at >= DATE_SUB(CURDATE(), INTERVAL 11 MONTH) " +
                    "GROUP BY DATE_FORMAT(created_at, '%Y-%m') ORDER BY DATE_FORMAT(created_at, '%Y-%m') ASC";
        } else if ("year".equals(view)) {
            sql = "SELECT YEAR(created_at) AS label, COALESCE(SUM(total_amount), 0) AS total " +
                    "FROM orders WHERE " + ELIGIBLE_ORDER_CONDITION +
                    " GROUP BY YEAR(created_at) ORDER BY YEAR(created_at) ASC";
        } else {
            sql = "SELECT DATE(created_at) AS label, COALESCE(SUM(total_amount), 0) AS total " +
                    "FROM orders WHERE " + ELIGIBLE_ORDER_CONDITION +
                    " AND created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) " +
                    "GROUP BY DATE(created_at) ORDER BY DATE(created_at) ASC";
        }
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            bindEligibleOrderStatuses(stmt, 1);
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
                "WHERE " + ELIGIBLE_ORDER_CONDITION + " " +
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
        bindEligibleOrderStatuses(stmt, 1);
        stmt.setTimestamp(9, from);
        stmt.setTimestamp(10, toExclusive);
    }

    private void bindEligibleOrderStatuses(PreparedStatement stmt, int firstParameter) throws SQLException {
        stmt.setString(firstParameter, OrderStatus.PAID);
        stmt.setString(firstParameter + 1, OrderStatus.COMPLETED);
        stmt.setString(firstParameter + 2, OrderStatus.PAID_PAYMENT);
        stmt.setString(firstParameter + 3, OrderStatus.PAID);
        stmt.setString(firstParameter + 4, OrderStatus.COMPLETED);
        stmt.setString(firstParameter + 5, "paid");
        stmt.setString(firstParameter + 6, "completed");
        stmt.setString(firstParameter + 7, "thanh toan thanh cong");
    }
}
