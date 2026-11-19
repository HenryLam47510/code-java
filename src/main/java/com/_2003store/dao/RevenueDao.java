package com._2003store.dao;

import com._2003store.config.DatabaseConfig;
import com._2003store.model.RevenueSummary;
import com._2003store.service.OrderStatus;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

public class RevenueDao {
    public RevenueSummary getDailyRevenue(LocalDate date) {
        String sql = "SELECT "
                + "COUNT(*) AS paid_orders, "
                + "COALESCE(SUM(total_amount), 0) AS total_revenue, "
                + "COALESCE(SUM(CASE WHEN payment_method = 'COD' THEN total_amount ELSE 0 END), 0) AS cash_revenue, "
                + "COALESCE(SUM(CASE WHEN payment_method IN ('BANK_TRANSFER', 'MOMO') THEN total_amount ELSE 0 END), 0) AS transfer_revenue "
                + "FROM orders WHERE (is_hidden IS NULL OR is_hidden = false) "
                + "AND status IN (?, ?) "
                + "AND payment_status IN (?, ?, ?, ?, ?, ?) "
                + "AND payment_method IN ('COD', 'BANK_TRANSFER', 'MOMO') "
                + "AND DATE(COALESCE(confirmed_at, created_at)) = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, OrderStatus.PAID);
            stmt.setString(2, OrderStatus.COMPLETED);
            stmt.setString(3, OrderStatus.PAID_PAYMENT);
            stmt.setString(4, OrderStatus.PAID);
            stmt.setString(5, OrderStatus.COMPLETED);
            stmt.setString(6, "paid");
            stmt.setString(7, "completed");
            stmt.setString(8, "thanh toan thanh cong");
            stmt.setString(9, date.toString());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new RevenueSummary(
                            rs.getBigDecimal("total_revenue"),
                            rs.getInt("paid_orders"),
                            rs.getBigDecimal("cash_revenue"),
                            rs.getBigDecimal("transfer_revenue"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new RevenueSummary(BigDecimal.ZERO, 0, BigDecimal.ZERO, BigDecimal.ZERO);
    }
}
