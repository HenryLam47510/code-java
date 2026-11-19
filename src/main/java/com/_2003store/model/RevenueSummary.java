package com._2003store.model;

import java.math.BigDecimal;

public class RevenueSummary {
    private final BigDecimal totalRevenue;
    private final int paidOrders;
    private final BigDecimal cashRevenue;
    private final BigDecimal transferRevenue;

    public RevenueSummary(BigDecimal totalRevenue, int paidOrders, BigDecimal cashRevenue, BigDecimal transferRevenue) {
        this.totalRevenue = totalRevenue;
        this.paidOrders = paidOrders;
        this.cashRevenue = cashRevenue;
        this.transferRevenue = transferRevenue;
    }

    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public int getPaidOrders() { return paidOrders; }
    public BigDecimal getCashRevenue() { return cashRevenue; }
    public BigDecimal getTransferRevenue() { return transferRevenue; }
}
