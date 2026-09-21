package com._2003store.service;

import java.text.Normalizer;
import java.util.Locale;

public final class OrderStatus {
    public static final String PENDING_CONFIRMATION = "Cho xac nhan";
    public static final String PENDING_PAYMENT = "Cho thanh toan";
    public static final String PAID = "Da thanh toan";
    public static final String COMPLETED = "Hoan thanh";
    public static final String CANCELLED = "Da huy";
    public static final String IN_TRANSIT = "Dang giao";
    public static final String UNPAID = "CHUA_THANH_TOAN";
    public static final String PAID_PAYMENT = "DA_THANH_TOAN";
    public static final String FAILED_PAYMENT = "THANH_TOAN_THAT_BAI";
    public static final String CASH = "COD";
    public static final String BANK_TRANSFER = "BANK_TRANSFER";
    public static final String MOMO = "MOMO";

    private OrderStatus() {
    }

    public static String normalize(String status) {
        if (status == null) {
            return "";
        }
        String value = Normalizer.normalize(status.trim(), Normalizer.Form.NFD);
        value = value.replaceAll("\\p{M}", "");
        return value.toLowerCase(Locale.ROOT).replaceAll("\\s+", " ").replace("_", " ");
    }

    public static boolean isPaidStatus(String status) {
        String normalized = normalize(status);
        return "da thanh toan".equals(normalized)
                || "hoan thanh".equals(normalized)
                || "paid".equals(normalized)
                || "completed".equals(normalized)
                || "da thanh toan".equals(normalized)
                || "chuyen khoan da thanh toan".equals(normalized)
                || "payment successful".equals(normalized);
    }

    public static boolean isPaymentConfirmed(String paymentStatus) {
        String normalized = normalize(paymentStatus);
        return !UNPAID.equalsIgnoreCase(paymentStatus)
                && !FAILED_PAYMENT.equalsIgnoreCase(paymentStatus)
                && ("da thanh toan".equals(normalized)
                || "paid".equals(normalized)
                || "hoan thanh".equals(normalized)
                || "completed".equals(normalized)
                || "thanh toan thanh cong".equals(normalized));
    }

    public static boolean isRevenueEligible(String status, String paymentStatus) {
        if (status == null && paymentStatus == null) {
            return false;
        }

        String normalizedStatus = normalize(status);
        String normalizedPayment = normalize(paymentStatus);
        boolean validStatus = isPaidStatus(status) || "hoan thanh".equals(normalizedStatus) || "da thanh toan".equals(normalizedStatus);
        boolean validPayment = isPaymentConfirmed(paymentStatus) || "da thanh toan".equals(normalizedPayment) || "paid".equals(normalizedPayment);
        return validStatus && validPayment;
    }

    public static boolean isRevenueEligible(String status) {
        return isPaidStatus(status);
    }

    public static boolean isCashPayment(String paymentMethod) {
        if (paymentMethod == null) {
            return false;
        }
        String normalized = normalize(paymentMethod);
        return "cod".equals(normalized)
                || "cash".equals(normalized)
                || "tien mat".equals(normalized)
                || "tien-mat".equals(normalized);
    }

    public static boolean isTransferPayment(String paymentMethod) {
        if (paymentMethod == null) {
            return false;
        }
        String normalized = normalize(paymentMethod);
        return "bank transfer".equals(normalized)
                || "bank".equals(normalized)
                || "transfer".equals(normalized)
                || "momo".equals(normalized)
                || "zalopay".equals(normalized)
                || "vnpay".equals(normalized)
                || "credit card".equals(normalized)
                || "card".equals(normalized);
    }
}
