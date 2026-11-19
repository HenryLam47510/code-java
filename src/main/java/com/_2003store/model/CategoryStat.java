package com._2003store.model;

public class CategoryStat {
    private final String categoryName;
    private final int productCount;
    private double percentage;

    public CategoryStat(String categoryName, int productCount) {
        this.categoryName = categoryName;
        this.productCount = productCount;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public int getProductCount() {
        return productCount;
    }

    public double getPercentage() {s
        return percentage;
    }

    public void setPercentage(double percentage) {
        this.percentage = percentage;
    }
}