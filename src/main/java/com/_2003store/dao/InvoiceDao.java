package com._2003store.dao;

import com._2003store.config.DatabaseConfig;
import com._2003store.model.Invoice;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDao {
    public void createInvoice(Invoice invoice) {
        String sql = "INSERT INTO invoices (order_id, invoice_code, customer_name, phone, total_amount, payment_method) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, invoice.getOrderId());
            stmt.setString(2, invoice.getInvoiceCode());
            stmt.setString(3, invoice.getCustomerName());
            stmt.setString(4, invoice.getPhone());
            stmt.setBigDecimal(5, invoice.getTotalAmount());
            stmt.setString(6, invoice.getPaymentMethod());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Invoice> getAllInvoices() {
        List<Invoice> invoices = new ArrayList<>();
        String sql = "SELECT * FROM invoices ORDER BY created_at DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setId(rs.getInt("id"));
                invoice.setOrderId(rs.getInt("order_id"));
                invoice.setInvoiceCode(rs.getString("invoice_code"));
                invoice.setCustomerName(rs.getString("customer_name"));
                invoice.setPhone(rs.getString("phone"));
                invoice.setTotalAmount(rs.getBigDecimal("total_amount"));
                invoice.setPaymentMethod(rs.getString("payment_method"));
                invoice.setCreatedAt(rs.getTimestamp("created_at"));
                invoices.add(invoice);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invoices;
    }

    public BigDecimal getRevenueByDay(String date) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM invoices WHERE DATE(created_at) = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, date);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal getRevenueByMonth(String month) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM invoices WHERE DATE_FORMAT(created_at, '%Y-%m') = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, month);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
}
