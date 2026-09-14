package com._2003store.dao;

import com._2003store.config.DatabaseConfig;
import com._2003store.model.Product;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ProductDao {
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY id";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                products.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return products;
    }

    public int countProducts() {
        String sql = "SELECT COUNT(*) FROM products";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalStock() {
        String sql = "SELECT COALESCE(SUM(stock), 0) FROM products";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getLowStockCount(int threshold) {
        String sql = "SELECT COUNT(*) FROM products WHERE stock <= ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, threshold);
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

    public Product getProductById(int id) {
        String sql = "SELECT * FROM products WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapProduct(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void addProduct(Product product) {
        String sql = "INSERT INTO products (name, category, brand, supplier, color, size, status, origin, price, stock, image, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getCategory());
            stmt.setString(3, product.getBrand());
            stmt.setString(4, product.getSupplier() == null || product.getSupplier().isBlank() ? "Chưa xác định" : product.getSupplier());
            stmt.setString(5, product.getColor() == null || product.getColor().isBlank() ? "Không xác định" : product.getColor());
            stmt.setString(6, product.getSize() == null || product.getSize().isBlank() ? "39" : product.getSize());
            stmt.setString(7, product.getStatus() == null || product.getStatus().isBlank() ? "Còn hàng" : product.getStatus());
            stmt.setString(8, product.getOrigin() == null || product.getOrigin().isBlank() ? "Chưa xác định" : product.getOrigin());
            stmt.setBigDecimal(9, product.getPrice());
            stmt.setInt(10, product.getStock());
            stmt.setString(11, product.getImage());
            stmt.setString(12, product.getDescription());
            stmt.executeUpdate();

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    product.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateProduct(Product product) {
        if (product == null || product.getId() <= 0) {
            return;
        }

        String sql = "UPDATE products SET name = ?, category = ?, brand = ?, supplier = ?, color = ?, size = ?, status = ?, origin = ?, price = ?, stock = ?, image = ?, description = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getCategory());
            stmt.setString(3, product.getBrand());
            stmt.setString(4, product.getSupplier() == null || product.getSupplier().isBlank() ? "Chưa xác định" : product.getSupplier());
            stmt.setString(5, product.getColor() == null || product.getColor().isBlank() ? "Không xác định" : product.getColor());
            stmt.setString(6, product.getSize() == null || product.getSize().isBlank() ? "39" : product.getSize());
            stmt.setString(7, product.getStatus() == null || product.getStatus().isBlank() ? "Còn hàng" : product.getStatus());
            stmt.setString(8, product.getOrigin() == null || product.getOrigin().isBlank() ? "Chưa xác định" : product.getOrigin());
            stmt.setBigDecimal(9, product.getPrice());
            stmt.setInt(10, product.getStock());
            stmt.setString(11, product.getImage());
            stmt.setString(12, product.getDescription());
            stmt.setInt(13, product.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Product mapProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setCategory(rs.getString("category"));
        product.setBrand(rs.getString("brand"));
        product.setSupplier(rs.getString("supplier"));
        product.setColor(rs.getString("color"));
        product.setSize(rs.getString("size"));
        product.setStatus(rs.getString("status"));
        product.setOrigin(rs.getString("origin"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setStock(rs.getInt("stock"));
        product.setImage(rs.getString("image"));
        product.setDescription(rs.getString("description"));
        return product;
    }
}
