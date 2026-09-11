package com._2003store.dao;

import com._2003store.config.DatabaseConfig;
import com._2003store.model.Product;
import com._2003store.model.WarehouseDetail;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WarehouseDetailDao {
    public List<WarehouseDetail> getWarehouseDetail() {
        List<WarehouseDetail> items = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY category, name";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setCategory(rs.getString("category"));
                product.setBrand(rs.getString("brand"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setStock(rs.getInt("stock"));

                WarehouseDetail item = new WarehouseDetail();
                item.setProductId(product.getId());
                item.setProductName(product.getName());
                item.setCategory(product.getCategory());
                item.setBrand(product.getBrand());
                item.setCurrentStock(product.getStock());
                item.setTotalImported(getTotalImported(product.getId()));
                item.setTotalExported(getTotalExported(product.getId()));
                item.setInventoryValue(product.getPrice().multiply(java.math.BigDecimal.valueOf(product.getStock())).longValue());
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public int getTotalImported(int productId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM stock_receipts WHERE product_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalExported(int productId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM stock_issues WHERE product_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
