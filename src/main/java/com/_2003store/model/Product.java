package com._2003store.model;

import java.math.BigDecimal;

public class Product {
    private int id;
    private String name;
    private String category;
    private String brand;
    private String supplier;
    private String color;
    private String size;
    private String status;
    private String origin;
    private BigDecimal price;
    private int stock;
    private String image;
    private String description;

    public Product() {
    }

    public Product(int id, String name, String category, String brand, String supplier, String color, String size, String status, String origin, BigDecimal price, int stock, String image, String description) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.brand = brand;
        this.supplier = supplier;
        this.color = color;
        this.size = size;
        this.status = status;
        this.origin = origin;
        this.price = price;
        this.stock = stock;
        this.image = image;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public String getSupplier() {
        return supplier;
    }

    public void setSupplier(String supplier) {
        this.supplier = supplier;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
