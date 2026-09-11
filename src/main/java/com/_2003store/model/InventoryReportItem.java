package com._2003store.model;

public class InventoryReportItem {
    private int productId;
    private String productName;
    private String category;
    private String brand;
    private int totalImported;
    private int totalExported;
    private int currentStock;

    public InventoryReportItem() {
    }

    public InventoryReportItem(int productId, String productName, String category, String brand,
                              int totalImported, int totalExported, int currentStock) {
        this.productId = productId;
        this.productName = productName;
        this.category = category;
        this.brand = brand;
        this.totalImported = totalImported;
        this.totalExported = totalExported;
        this.currentStock = currentStock;
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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public int getTotalImported() {
        return totalImported;
    }

    public void setTotalImported(int totalImported) {
        this.totalImported = totalImported;
    }

    public int getTotalExported() {
        return totalExported;
    }

    public void setTotalExported(int totalExported) {
        this.totalExported = totalExported;
    }

    public int getCurrentStock() {
        return currentStock;
    }

    public void setCurrentStock(int currentStock) {
        this.currentStock = currentStock;
    }
}
