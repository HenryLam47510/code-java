package com._2003store.dao;

import com._2003store.config.DatabaseConfig;
import com._2003store.model.LoginHistory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class LoginHistoryDao {
    public void logLogin(String username, String fullName, String status, String ipAddress) {
        String sql = "INSERT INTO login_history (username, full_name, status, ip_address) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, fullName);
            stmt.setString(3, status);
            stmt.setString(4, ipAddress);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<LoginHistory> getRecentLogins() {
        List<LoginHistory> histories = new ArrayList<>();
        String sql = "SELECT * FROM login_history ORDER BY login_time DESC LIMIT 20";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                LoginHistory history = new LoginHistory();
                history.setId(rs.getInt("id"));
                history.setUsername(rs.getString("username"));
                history.setFullName(rs.getString("full_name"));
                history.setLoginTime(rs.getTimestamp("login_time"));
                history.setStatus(rs.getString("status"));
                history.setIpAddress(rs.getString("ip_address"));
                histories.add(history);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return histories;
    }
}
