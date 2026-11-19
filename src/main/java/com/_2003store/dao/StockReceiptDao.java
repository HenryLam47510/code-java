package com._2003store.dao;

import com._2003store.config.DatabaseConfig;
import com._2003store.model.Product;
import com._2003store.model.StockReceipt;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StockReceiptDao {
    public boolean createReceipt(StockReceipt receipt) {
        if (receipt == null || receipt.getQuantity() <= 0 || receipt.getProductId() <= 0) {
            return false;
        }
        String insertSql = "INSERT INTO stock_receipts (product_id, product_name, supplier, quantity, unit_price, total_cost, note) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String stockSql = "UPDATE products SET stock = stock + ? WHERE id = ? AND (is_deleted IS NULL OR is_deleted = false)";
        try (Connection conn = DatabaseConfig.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                 PreparedStatement stockStmt = conn.prepareStatement(stockSql)) {
                insertStmt.setInt(1, receipt.getProductId());
                insertStmt.setString(2, receipt.getProductName());
                insertStmt.setString(3, receipt.getSupplier());
                insertStmt.setInt(4, receipt.getQuantity());
                insertStmt.setBigDecimal(5, receipt.getUnitPrice());
                insertStmt.setBigDecimal(6, receipt.getTotalCost());
                insertStmt.setString(7, receipt.getNote());
                insertStmt.executeUpdate();

                stockStmt.setInt(1, receipt.getQuantity());
                stockStmt.setInt(2, receipt.getProductId());
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

    public List<StockReceipt> getAllReceipts() {
        List<StockReceipt> receipts = new ArrayList<>();
        String sql = "SELECT * FROM stock_receipts ORDER BY created_at DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                StockReceipt receipt = new StockReceipt();
                receipt.setId(rs.getInt("id"));
                receipt.setProductId(rs.getInt("product_id"));
                receipt.setProductName(rs.getString("product_name"));
                receipt.setSupplier(rs.getString("supplier"));
                receipt.setQuantity(rs.getInt("quantity"));
                receipt.setUnitPrice(rs.getBigDecimal("unit_price"));
                receipt.setTotalCost(rs.getBigDecimal("total_cost"));
                receipt.setNote(rs.getString("note"));
                receipt.setCreatedAt(rs.getTimestamp("created_at"));
                receipts.add(receipt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return receipts;
    }

    public BigDecimal getTotalImportValue() {
        String sql = "SELECT COALESCE(SUM(total_cost), 0) FROM stock_receipts";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
}
