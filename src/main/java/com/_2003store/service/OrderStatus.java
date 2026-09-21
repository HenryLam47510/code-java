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

    private OrderStatus() {
    }

    public static String normalize(String status) {
        if (status == null) {
            return "";
        }
        String value = Normalizer.normalize(status.trim(), Normalizer.Form.NFD);
        value = value.replaceAll("\\p{M}", "");
        return value.toLowerCase(Locale.ROOT).replaceAll("\\s+", " ");
    }

    public static boolean isPaidStatus(String status) {
        String normalized = normalize(status);
        return "da thanh toan".equals(normalized)
                || "hoan thanh".equals(normalized)
                || "paid".equals(normalized)
                || "completed".equals(normalized);
    }

    public static boolean isRevenueEligible(String status) {
        return isPaidStatus(status);
    }
}
