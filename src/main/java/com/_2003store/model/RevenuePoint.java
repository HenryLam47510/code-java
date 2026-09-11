package com._2003store.model;

import java.math.BigDecimal;

public class RevenuePoint {
    private String label;
    private BigDecimal value;

    public RevenuePoint() {
    }

    public RevenuePoint(String label, BigDecimal value) {
        this.label = label;
        this.value = value;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public BigDecimal getValue() {
        return value;
    }

    public void setValue(BigDecimal value) {
        this.value = value;
    }
}
