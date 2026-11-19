package com._2003store.service;

import com._2003store.model.RevenueSummary;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.assertEquals;

class RevenueSummaryTest {
    @Test
    void totalRevenueEqualsCashAndTransferRevenue() {
        RevenueSummary summary = new RevenueSummary(
                new BigDecimal("500000"),
                3,
                new BigDecimal("200000"),
                new BigDecimal("300000")
        );

        assertEquals(summary.getCashRevenue().add(summary.getTransferRevenue()), summary.getTotalRevenue());
    }

    @Test
    void summarySupportsNoTransactions() {
        RevenueSummary summary = new RevenueSummary(BigDecimal.ZERO, 0, BigDecimal.ZERO, BigDecimal.ZERO);

        assertEquals(BigDecimal.ZERO, summary.getTotalRevenue());
        assertEquals(0, summary.getPaidOrders());
    }
}
