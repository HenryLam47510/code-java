package com._2003store.dao;

import com._2003store.config.DatabaseConfig;
import com._2003store.model.LoginHistory;
import com._2003store.model.RevenuePoint;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StaffReportDao {
    public int getTotalEmployees() {
        String sql = "SELECT COUNT(*) FROM employees";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getSuccessfulLogins(String from, String to) {
        String sql = "SELECT COUNT(*) FROM login_history WHERE status = 'SUCCESS' AND login_time BETWEEN ? AND ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, from + " 00:00:00");
            stmt.setString(2, to + " 23:59:59");
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getFailedLogins(String from, String to) {
        String sql = "SELECT COUNT(*) FROM login_history WHERE status = 'FAILED' AND login_time BETWEEN ? AND ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, from + " 00:00:00");
            stmt.setString(2, to + " 23:59:59");
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getActiveEmployees(String from, String to) {
        String sql = "SELECT COUNT(DISTINCT username) FROM login_history WHERE status = 'SUCCESS' AND login_time BETWEEN ? AND ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, from + " 00:00:00");
            stmt.setString(2, to + " 23:59:59");
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public String getTopEmployee(String from, String to) {
        String sql = "SELECT full_name, COUNT(*) AS total FROM login_history WHERE status = 'SUCCESS' AND login_time BETWEEN ? AND ? GROUP BY full_name ORDER BY total DESC LIMIT 1";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, from + " 00:00:00");
            stmt.setString(2, to + " 23:59:59");
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("full_name");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Chưa có dữ liệu";
    }

    public List<RevenuePoint> getLoginTrendByDate(String from, String to) {
        List<RevenuePoint> points = new ArrayList<>();
        String sql = "SELECT DATE(login_time) AS label, COUNT(*) AS total FROM login_history WHERE status = 'SUCCESS' AND login_time BETWEEN ? AND ? GROUP BY DATE(login_time) ORDER BY DATE(login_time) ASC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, from + " 00:00:00");
            stmt.setString(2, to + " 23:59:59");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    points.add(new RevenuePoint(rs.getString("label"), java.math.BigDecimal.valueOf(rs.getLong("total"))));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return points;
    }

    public List<LoginHistory> getRecentActivities(String from, String to) {
        List<LoginHistory> activities = new ArrayList<>();
        String sql = "SELECT * FROM login_history WHERE login_time BETWEEN ? AND ? ORDER BY login_time DESC LIMIT 20";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, from + " 00:00:00");
            stmt.setString(2, to + " 23:59:59");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    LoginHistory history = new LoginHistory();
                    history.setId(rs.getInt("id"));
                    history.setUsername(rs.getString("username"));
                    history.setFullName(rs.getString("full_name"));
                    history.setLoginTime(rs.getTimestamp("login_time"));
                    history.setStatus(rs.getString("status"));
                    history.setIpAddress(rs.getString("ip_address"));
                    activities.add(history);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return activities;
    }
}
