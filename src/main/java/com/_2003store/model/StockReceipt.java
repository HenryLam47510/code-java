package com._2003store.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class StockReceipt {
    private int id;
    private int productId;
    private String productName;
    private String supplier;
    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal totalCost;
    private String note;
    private Timestamp createdAt;

    public StockReceipt() {
    }

    public StockReceipt(int id, int productId, String productName, String supplier, int quantity,
                       BigDecimal unitPrice, BigDecimal totalCost, String note, Timestamp createdAt) {
        this.id = id;
        this.productId = productId;
        this.productName = productName;
        this.supplier = supplier;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalCost = totalCost;
        this.note = note;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getSupplier() {
        return supplier;
    }

    public void setSupplier(String supplier) {
        this.supplier = supplier;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(BigDecimal totalCost) {
        this.totalCost = totalCost;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
