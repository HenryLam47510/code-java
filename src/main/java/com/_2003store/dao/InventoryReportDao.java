package com._2003store.dao;

import com._2003store.config.DatabaseConfig;
import com._2003store.model.InventoryReportItem;
import com._2003store.model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InventoryReportDao {
    public List<InventoryReportItem> getInventoryReport() {
        List<InventoryReportItem> report = new ArrayList<>();
        ProductDao productDao = new ProductDao();
        List<Product> products = productDao.getAllProducts();

        for (Product product : products) {
            int imported = getTotalImported(product.getId());
            int exported = getTotalExported(product.getId());
            InventoryReportItem item = new InventoryReportItem();
            item.setProductId(product.getId());
            item.setProductName(product.getName());
            item.setCategory(product.getCategory());
            item.setBrand(product.getBrand());
            item.setTotalImported(imported);
            item.setTotalExported(exported);
            item.setCurrentStock(product.getStock());
            report.add(item);
        }

        return report;
    }

    private int getTotalImported(int productId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM stock_receipts WHERE product_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private int getTotalExported(int productId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM stock_issues WHERE product_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
