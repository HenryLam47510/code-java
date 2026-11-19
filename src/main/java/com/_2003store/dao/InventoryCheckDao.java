package com._2003store.dao;

import com._2003store.config.DatabaseConfig;
import com._2003store.model.InventoryCheck;
import com._2003store.model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InventoryCheckDao {
    public boolean saveCheck(InventoryCheck check) {
        if (check == null || check.getCountedQuantity() < 0) {
            return false;
        }
        String sql = "INSERT INTO inventory_counts (product_id, product_name, expected_quantity, counted_quantity, variance, counted_by, note) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String stockSql = "UPDATE products SET stock = ? WHERE id = ? AND (is_deleted IS NULL OR is_deleted = false)";
        try (Connection conn = DatabaseConfig.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 PreparedStatement stockStmt = conn.prepareStatement(stockSql)) {
                stmt.setInt(1, check.getProductId());
                stmt.setString(2, check.getProductName());
                stmt.setInt(3, check.getExpectedQuantity());
                stmt.setInt(4, check.getCountedQuantity());
                stmt.setInt(5, check.getVariance());
                stmt.setString(6, check.getCountedBy());
                stmt.setString(7, check.getNote());
                stmt.executeUpdate();

                stockStmt.setInt(1, check.getCountedQuantity());
                stockStmt.setInt(2, check.getProductId());
                if (stockStmt.executeUpdate() != 1) {
                    conn.rollback();
                    return false;
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

    public List<InventoryCheck> getAllChecks() {
        List<InventoryCheck> checks = new ArrayList<>();
        String sql = "SELECT * FROM inventory_counts ORDER BY created_at DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                InventoryCheck check = new InventoryCheck();
                check.setId(rs.getInt("id"));
                check.setProductId(rs.getInt("product_id"));
                check.setProductName(rs.getString("product_name"));
                check.setExpectedQuantity(rs.getInt("expected_quantity"));
                check.setCountedQuantity(rs.getInt("counted_quantity"));
                check.setVariance(rs.getInt("variance"));
                check.setCountedBy(rs.getString("counted_by"));
                check.setNote(rs.getString("note"));
                check.setCreatedAt(rs.getTimestamp("created_at"));
                checks.add(check);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return checks;
    }
}
