package com._2003store.model;

import java.sql.Timestamp;

public class InventoryCheck {
    private int id;
    private int productId;
    private String productName;
    private int expectedQuantity;
    private int countedQuantity;
    private int variance;
    private String countedBy;
    private String note;
    private Timestamp createdAt;

    public InventoryCheck() {
    }

    public InventoryCheck(int id, int productId, String productName, int expectedQuantity, int countedQuantity,
                          int variance, String countedBy, String note, Timestamp createdAt) {
        this.id = id;
        this.productId = productId;
        this.productName = productName;
        this.expectedQuantity = expectedQuantity;
        this.countedQuantity = countedQuantity;
        this.variance = variance;
        this.countedBy = countedBy;
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

    public int getExpectedQuantity() {
        return expectedQuantity;
    }

    public void setExpectedQuantity(int expectedQuantity) {
        this.expectedQuantity = expectedQuantity;
    }

    public int getCountedQuantity() {
        return countedQuantity;
    }

    public void setCountedQuantity(int countedQuantity) {
        this.countedQuantity = countedQuantity;
    }

    public int getVariance() {
        return variance;
    }

    public void setVariance(int variance) {
        this.variance = variance;
    }

    public String getCountedBy() {
        return countedBy;
    }

    public void setCountedBy(String countedBy) {
        this.countedBy = countedBy;
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
