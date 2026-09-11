package com._2003store.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Order {
    private int id;
    private String customerName;
    private String phone;
    private String status;
    private BigDecimal totalAmount;
    private Timestamp createdAt;

    public Order() {
    }

    public Order(int id, String customerName, String phone, String status, BigDecimal totalAmount, Timestamp createdAt) {
        this.id = id;
        this.customerName = customerName;
        this.phone = phone;
        this.status = status;
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
}
