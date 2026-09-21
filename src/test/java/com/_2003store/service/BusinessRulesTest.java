package com._2003store.service;

import com._2003store.model.User;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

class BusinessRulesTest {

    @Test
    void shouldEnforceRoleBasedPermissions() {
        AuthService service = new AuthService();

        User staff = new User("staff", "123456", "Nhân viên", "STAFF");
        User manager = new User("manager", "123456", "Quản lý", "MANAGER");
        User admin = new User("admin", "123456", "Admin", "ADMIN");

        assertTrue(service.hasAccess(staff, "orders"));
        assertFalse(service.hasAccess(staff, "employees"));
        assertTrue(service.hasAccess(manager, "employees"));
        assertTrue(service.hasAccess(admin, "employees"));
        assertTrue(service.hasAccess(admin, "reports"));
    }

    @Test
    void shouldOnlyCountPaidOrdersAsRevenue() {
        assertTrue(OrderStatus.isPaidStatus("Da thanh toan"));
        assertTrue(OrderStatus.isPaidStatus("HOAN THANH"));
        assertFalse(OrderStatus.isPaidStatus("Cho xac nhan"));
        assertFalse(OrderStatus.isPaidStatus("Da huy"));
        assertFalse(OrderStatus.isRevenueEligible("Cho xac nhan"));
        assertTrue(OrderStatus.isRevenueEligible("Da thanh toan"));
    }

    @Test
    void shouldRecognizeTransferPaymentState() {
        assertTrue(OrderStatus.isTransferPayment("BANK_TRANSFER"));
        assertTrue(OrderStatus.isPaymentConfirmed("DA_THANH_TOAN"));
        assertTrue(OrderStatus.isRevenueEligible("Da thanh toan", "DA_THANH_TOAN"));
    }

    @Test
    void shouldNormalizeCashierPaymentPermission() {
        assertEquals("payment_confirm", AuthService.normalizeModule("PAYMENT_CONFIRM"));
        assertEquals("payment_confirm", AuthService.normalizeModule("payment-confirm"));
        assertEquals("EMPLOYEE", AuthService.normalizeRole("staff"));
    }

    @Test
    void shouldGenerateOrderCodeInRequiredFormat() {
        String code = OrderCodeGenerator.generateForDate(LocalDate.of(2026, 9, 21), 1);
        assertEquals("DH20260921-0001", code);
        assertTrue(code.matches("DH\\d{8}-\\d{4}"));
    }
}
