package com._2003store.model;

public class WarehouseDetail {
    private int productId;
    private String productName;
    private String category;
    private String brand;
    private int currentStock;
    private int totalImported;
    private int totalExported;
    private long inventoryValue;

    public WarehouseDetail() {
    }

    public WarehouseDetail(int productId, String productName, String category, String brand,
                          int currentStock, int totalImported, int totalExported, long inventoryValue) {
        this.productId = productId;
        this.productName = productName;
        this.category = category;
        this.brand = brand;
        this.currentStock = currentStock;
        this.totalImported = totalImported;
        this.totalExported = totalExported;
        this.inventoryValue = inventoryValue;
    }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public int getCurrentStock() { return currentStock; }
    public void setCurrentStock(int currentStock) { this.currentStock = currentStock; }

    public int getTotalImported() { return totalImported; }
    public void setTotalImported(int totalImported) { this.totalImported = totalImported; }

    public int getTotalExported() { return totalExported; }
    public void setTotalExported(int totalExported) { this.totalExported = totalExported; }

    public long getInventoryValue() { return inventoryValue; }
    public void setInventoryValue(long inventoryValue) { this.inventoryValue = inventoryValue; }
}
