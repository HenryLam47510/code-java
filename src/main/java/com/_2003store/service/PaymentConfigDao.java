package com._2003store.service;

import com._2003store.config.DatabaseConfig;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PaymentConfigDao {
    private static final String TABLE_NAME = "payment_configs";

    public void savePaymentConfig(String bankId, String accountNumber, String accountName) {
        ensureTableExists();
        String sql = "INSERT INTO " + TABLE_NAME + " (id, bank_id, account_number, account_name, updated_at) VALUES (1, ?, ?, ?, CURRENT_TIMESTAMP) " +
                "ON DUPLICATE KEY UPDATE bank_id = VALUES(bank_id), account_number = VALUES(account_number), account_name = VALUES(account_name), updated_at = CURRENT_TIMESTAMP";

        try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, bankId);
            stmt.setString(2, accountNumber);
            stmt.setString(3, accountName);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public PaymentConfigRecord loadPaymentConfig() {
        ensureTableExists();
        String sql = "SELECT bank_id, account_number, account_name FROM " + TABLE_NAME + " WHERE id = 1";

        try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return new PaymentConfigRecord(rs.getString("bank_id"), rs.getString("account_number"), rs.getString("account_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return new PaymentConfigRecord(PaymentConfig.getBankId(), PaymentConfig.getAccountNumber(), PaymentConfig.getAccountName());
    }

    private void ensureTableExists() {
        String sql = "CREATE TABLE IF NOT EXISTS " + TABLE_NAME + " (" +
                "id INT PRIMARY KEY, " +
                "bank_id VARCHAR(20), " +
                "account_number VARCHAR(50), " +
                "account_name VARCHAR(255), " +
                "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";

        try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
            try (PreparedStatement defaultStmt = conn.prepareStatement("INSERT INTO " + TABLE_NAME + " (id, bank_id, account_number, account_name) VALUES (1, ?, ?, ?) ON DUPLICATE KEY UPDATE id = id")) {
                defaultStmt.setString(1, PaymentConfig.getBankId());
                defaultStmt.setString(2, PaymentConfig.getAccountNumber());
                defaultStmt.setString(3, PaymentConfig.getAccountName());
                defaultStmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static class PaymentConfigRecord {
        private final String bankId;
        private final String accountNumber;
        private final String accountName;

        public PaymentConfigRecord(String bankId, String accountNumber, String accountName) {
            this.bankId = bankId;
            this.accountNumber = accountNumber;
            this.accountName = accountName;
        }

        public String getBankId() {
            return bankId;
        }

        public String getAccountNumber() {
            return accountNumber;
        }

        public String getAccountName() {
            return accountName;
        }
    }
}
