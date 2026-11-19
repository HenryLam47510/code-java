package com._2003store.dao;

import com._2003store.config.DatabaseConfig;
import com._2003store.model.Product;
import com._2003store.model.StockIssue;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StockIssueDao {
    public boolean createIssue(StockIssue issue) {
        if (issue == null || issue.getQuantity() <= 0 || issue.getProductId() <= 0) {
            return false;
        }
        String insertSql = "INSERT INTO stock_issues (product_id, product_name, quantity, reason, note) VALUES (?, ?, ?, ?, ?)";
        String stockSql = "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ? AND (is_deleted IS NULL OR is_deleted = false)";
        try (Connection conn = DatabaseConfig.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement stockStmt = conn.prepareStatement(stockSql)) {
                stockStmt.setInt(1, issue.getQuantity());
                stockStmt.setInt(2, issue.getProductId());
                stockStmt.setInt(3, issue.getQuantity());
                if (stockStmt.executeUpdate() != 1) {
                    conn.rollback();
                    return false;
                }
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    insertStmt.setInt(1, issue.getProductId());
                    insertStmt.setString(2, issue.getProductName());
                    insertStmt.setInt(3, issue.getQuantity());
                    insertStmt.setString(4, issue.getReason());
                    insertStmt.setString(5, issue.getNote());
                    insertStmt.executeUpdate();
                }
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<StockIssue> getAllIssues() {
        List<StockIssue> issues = new ArrayList<>();
        String sql = "SELECT * FROM stock_issues ORDER BY created_at DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                StockIssue issue = new StockIssue();
                issue.setId(rs.getInt("id"));
                issue.setProductId(rs.getInt("product_id"));
                issue.setProductName(rs.getString("product_name"));
                issue.setQuantity(rs.getInt("quantity"));
                issue.setReason(rs.getString("reason"));
                issue.setNote(rs.getString("note"));
                issue.setCreatedAt(rs.getTimestamp("created_at"));
                issues.add(issue);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return issues;
    }
}
