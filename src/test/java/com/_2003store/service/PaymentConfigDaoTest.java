package com._2003store.service;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class PaymentConfigDaoTest {

    @Test
    void shouldPersistAndLoadBankConfiguration() {
        PaymentConfig.setBankId("TCB");
        PaymentConfig.setAccountNumber("190123456789");
        PaymentConfig.setAccountName("Test Receiver");

        PaymentConfigDao dao = new PaymentConfigDao();
        dao.savePaymentConfig("TCB", "190123456789", "Test Receiver");

        assertEquals("TCB", dao.loadPaymentConfig().getBankId());
        assertEquals("190123456789", dao.loadPaymentConfig().getAccountNumber());
        assertEquals("Test Receiver", dao.loadPaymentConfig().getAccountName());
    }
}
