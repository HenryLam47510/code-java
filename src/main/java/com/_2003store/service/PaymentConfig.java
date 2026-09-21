package com._2003store.service;

public final class PaymentConfig {
    private static final String DEFAULT_BANK_ID = "MB";
    private static final String DEFAULT_ACCOUNT_NUMBER = "050117052004";
    private static final String DEFAULT_ACCOUNT_NAME = "Hoang Manh Dung";

    private static String bankId = getValue("STORE_BANK_ID", DEFAULT_BANK_ID);
    private static String accountNumber = getValue("STORE_ACCOUNT_NUMBER", DEFAULT_ACCOUNT_NUMBER);
    private static String accountName = getValue("STORE_ACCOUNT_NAME", DEFAULT_ACCOUNT_NAME);

    private PaymentConfig() {
    }

    private static String getValue(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value == null || value.isBlank()) ? defaultValue : value.trim();
    }

    public static String getBankId() {
        return bankId;
    }

    public static void setBankId(String bankId) {
        PaymentConfig.bankId = (bankId == null || bankId.isBlank()) ? DEFAULT_BANK_ID : bankId.trim();
    }

    public static String getAccountNumber() {
        return accountNumber;
    }

    public static void setAccountNumber(String accountNumber) {
        PaymentConfig.accountNumber = (accountNumber == null || accountNumber.isBlank()) ? DEFAULT_ACCOUNT_NUMBER : accountNumber.trim();
    }

    public static String getAccountName() {
        return accountName;
    }

    public static void setAccountName(String accountName) {
        PaymentConfig.accountName = (accountName == null || accountName.isBlank()) ? DEFAULT_ACCOUNT_NAME : accountName.trim();
    }

    public static void refreshFromDatabase() {
        PaymentConfigDao dao = new PaymentConfigDao();
        PaymentConfigDao.PaymentConfigRecord config = dao.loadPaymentConfig();
        if (config != null) {
            bankId = config.getBankId() == null || config.getBankId().isBlank() ? DEFAULT_BANK_ID : config.getBankId().trim();
            accountNumber = config.getAccountNumber() == null || config.getAccountNumber().isBlank() ? DEFAULT_ACCOUNT_NUMBER : config.getAccountNumber().trim();
            accountName = config.getAccountName() == null || config.getAccountName().isBlank() ? DEFAULT_ACCOUNT_NAME : config.getAccountName().trim();
        }
    }

    public static void saveToDatabase() {
        PaymentConfigDao dao = new PaymentConfigDao();
        dao.savePaymentConfig(bankId, accountNumber, accountName);
    }

    public static void resetToDefaults() {
        bankId = DEFAULT_BANK_ID;
        accountNumber = DEFAULT_ACCOUNT_NUMBER;
        accountName = DEFAULT_ACCOUNT_NAME;
    }
}
