package com._2003store.model;

import java.math.BigDecimal;

public class RevenueDetail {
    private final String label;
    private final int paidOrders;
    private final BigDecimal cashRevenue;
    private final BigDecimal transferRevenue;
    private final BigDecimal totalRevenue;

    public RevenueDetail(String label, int paidOrders, BigDecimal cashRevenue, BigDecimal transferRevenue, BigDecimal totalRevenue) {
        this.label = label;
        this.paidOrders = paidOrders;
        this.cashRevenue = cashRevenue;
        this.transferRevenue = transferRevenue;
        this.totalRevenue = totalRevenue;
    }

    public String getLabel() { return label; }
    public int getPaidOrders() { return paidOrders; }
    public BigDecimal getCashRevenue() { return cashRevenue; }
    public BigDecimal getTransferRevenue() { return transferRevenue; }
    public BigDecimal getTotalRevenue() { return totalRevenue; }
}
