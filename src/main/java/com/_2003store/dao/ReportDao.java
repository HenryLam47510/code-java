package com._2003store.dao;

import com._2003store.config.DatabaseConfig;
import com._2003store.model.RevenuePoint;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReportDao {
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
}
