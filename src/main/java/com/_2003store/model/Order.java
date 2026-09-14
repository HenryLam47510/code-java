package com._2003store.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Order {
    private int id;
    private String customerName;
    private String phone;
    private String status;
    private String paymentMethod;
    private BigDecimal paymentAmount;
    private String paymentStatus;
    private String qrCode;
    private BigDecimal totalAmount;
    private Timestamp createdAt;

    public Order() {
    }

    public Order(int id, String customerName, String phone, String status, BigDecimal totalAmount, Timestamp createdAt) {
        this(id, customerName, phone, status, "Tiền mặt", totalAmount, createdAt);
    }

    public Order(int id, String customerName, String phone, String status, String paymentMethod, BigDecimal totalAmount, Timestamp createdAt) {
        this.id = id;
        this.customerName = customerName;
        this.phone = phone;
        this.status = status;
        this.paymentMethod = normalizePaymentMethod(paymentMethod);
        this.paymentAmount = totalAmount;
        this.paymentStatus = "Chờ thanh toán";
        this.qrCode = "";
        this.totalAmount = totalAmount;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = normalizePaymentMethod(paymentMethod);
    }

    public BigDecimal getPaymentAmount() {
        return paymentAmount == null ? totalAmount : paymentAmount;
    }

    public void setPaymentAmount(BigDecimal paymentAmount) {
        this.paymentAmount = paymentAmount;
    }

    public String getPaymentStatus() {
        return paymentStatus == null || paymentStatus.isBlank() ? "Chờ thanh toán" : paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getQrCode() {
        return qrCode == null ? "" : qrCode;
    }

    public void setQrCode(String qrCode) {
        this.qrCode = qrCode;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public static String normalizePaymentMethod(String paymentMethod) {
        if (paymentMethod == null || paymentMethod.isBlank()) {
            return "Tiền mặt";
        }

        String normalized = paymentMethod.trim();
        String lower = removeDiacritics(normalized).toLowerCase();

        if (lower.contains("chuyen") || lower.contains("bank") || lower.contains("transfer")) {
            return "Chuyển khoản";
        }

        return "Tiền mặt";
    }

    public static String normalizeStatus(String status) {
        if (status == null || status.isBlank()) {
            return "Chờ thanh toán";
        }

        String normalized = removeDiacritics(status.trim()).toLowerCase();
        if (normalized.contains("xac nhan") || normalized.contains("confirmed") || normalized.contains("da xac nhan")) {
            return "Đã xác nhận";
        }
        if (normalized.contains("hoan tat") || normalized.contains("hoan thanh") || normalized.contains("completed") || normalized.contains("done")) {
            return "Đã hoàn tất";
        }
        return "Chờ thanh toán";
    }

    private static String removeDiacritics(String value) {
        String normalized = java.text.Normalizer.normalize(value, java.text.Normalizer.Form.NFD);
        return normalized.replaceAll("\\p{M}", "");
    }
}
