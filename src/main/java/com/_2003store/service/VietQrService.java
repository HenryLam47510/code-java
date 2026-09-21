package com._2003store.service;

import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public final class VietQrService {
    private VietQrService() {
    }

    public static String generateQrUrl(BigDecimal amount, String orderCode) {
        String normalizedAmount = amount == null ? "0" : amount.stripTrailingZeros().toPlainString();
        String normalizedOrderCode = orderCode == null || orderCode.isBlank() ? "ORDER" : orderCode.trim();
        String bankId = PaymentConfig.getBankId();
        String accountNumber = PaymentConfig.getAccountNumber();
        String accountName = PaymentConfig.getAccountName();
        String addInfo = "Thanh toan don " + normalizedOrderCode;

        String base = "https://img.vietqr.io/image/" + bankId + "-" + accountNumber + "-compact2.png";
        StringBuilder builder = new StringBuilder(base);
        builder.append("?amount=").append(URLEncoder.encode(normalizedAmount, StandardCharsets.UTF_8));
        builder.append("&addInfo=").append(URLEncoder.encode(addInfo, StandardCharsets.UTF_8));
        builder.append("&accountName=").append(URLEncoder.encode(accountName, StandardCharsets.UTF_8));
        return builder.toString();
    }

    public static String generateQrImageUrl(BigDecimal amount, String orderCode) {
        return generateQrUrl(amount, orderCode);
    }
}
