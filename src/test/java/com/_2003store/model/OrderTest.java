package com._2003store.model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class OrderTest {

    @Test
    void shouldNormalizeCashAndBankPaymentMethods() {
        assertEquals("Tiền mặt", Order.normalizePaymentMethod("Tien mat"));
        assertEquals("Tiền mặt", Order.normalizePaymentMethod("tiền mặt"));
        assertEquals("Chuyển khoản", Order.normalizePaymentMethod("Chuyển khoản"));
        assertEquals("Chuyển khoản", Order.normalizePaymentMethod("bank transfer"));
    }

    @Test
    void shouldNormalizeOrderLifecycleStatus() {
        assertEquals("Chờ thanh toán", Order.normalizeStatus("Chờ thanh toán"));
        assertEquals("Đã xác nhận", Order.normalizeStatus("Đã xác nhận"));
        assertEquals("Đã hoàn tất", Order.normalizeStatus("Hoan thanh"));
    }
}
