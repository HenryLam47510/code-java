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
    public void createIssue(StockIssue issue) {
        String sql = "INSERT INTO stock_issues (product_id, product_name, quantity, reason, note) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, issue.getProductId());
            stmt.setString(2, issue.getProductName());
            stmt.setInt(3, issue.getQuantity());
            stmt.setString(4, issue.getReason());
            stmt.setString(5, issue.getNote());
            stmt.executeUpdate();

            Product product = new ProductDao().getProductById(issue.getProductId());
            if (product != null && product.getStock() >= issue.getQuantity()) {
                product.setStock(product.getStock() - issue.getQuantity());
                new ProductDao().updateProduct(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
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
