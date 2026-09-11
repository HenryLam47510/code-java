package com._2003store.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Invoice {
    private int id;
    private int orderId;
    private String invoiceCode;
    private String customerName;
    private String phone;
    private BigDecimal totalAmount;
    private String paymentMethod;
    private Timestamp createdAt;

    public Invoice() {
    }

    public Invoice(int id, int orderId, String invoiceCode, String customerName, String phone, BigDecimal totalAmount, String paymentMethod, Timestamp createdAt) {
        this.id = id;
        this.orderId = orderId;
        this.invoiceCode = invoiceCode;
        this.customerName = customerName;
        this.phone = phone;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getInvoiceCode() {
        return invoiceCode;
    }

    public void setInvoiceCode(String invoiceCode) {
        this.invoiceCode = invoiceCode;
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

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
