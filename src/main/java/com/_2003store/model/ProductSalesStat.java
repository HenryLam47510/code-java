package com._2003store.model;

import java.math.BigDecimal;

public class ProductSalesStat {
    private final String productName;
    private final int quantitySold;
    private final BigDecimal revenue;

    public ProductSalesStat(String productName, int quantitySold, BigDecimal revenue) {
        this.productName = productName;
        this.quantitySold = quantitySold;
        this.revenue = revenue;
    }

    public String getProductName() {
        return productName;
    }

    public int getQuantitySold() {
        return quantitySold;
    }

    public BigDecimal getRevenue() {
        return revenue;
    }
}