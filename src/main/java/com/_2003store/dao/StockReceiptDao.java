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
    public void createReceipt(StockReceipt receipt) {
        String sql = "INSERT INTO stock_receipts (product_id, product_name, supplier, quantity, unit_price, total_cost, note) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, receipt.getProductId());
            stmt.setString(2, receipt.getProductName());
            stmt.setString(3, receipt.getSupplier());
            stmt.setInt(4, receipt.getQuantity());
            stmt.setBigDecimal(5, receipt.getUnitPrice());
            stmt.setBigDecimal(6, receipt.getTotalCost());
            stmt.setString(7, receipt.getNote());
            stmt.executeUpdate();

            Product product = new ProductDao().getProductById(receipt.getProductId());
            if (product != null) {
                product.setStock(product.getStock() + receipt.getQuantity());
                new ProductDao().updateProduct(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
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
