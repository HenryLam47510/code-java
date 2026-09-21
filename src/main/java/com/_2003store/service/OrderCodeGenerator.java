package com._2003store.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public final class OrderCodeGenerator {
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyyMMdd");

    private OrderCodeGenerator() {
    }

    public static String generateForDate(LocalDate date, int sequence) {
        String sequencePart = String.format("%04d", sequence);
        return "DH" + date.format(FORMATTER) + "-" + sequencePart;
    }
}
