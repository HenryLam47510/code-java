package com._2003store.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConfig {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/2003_store?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "lambeo123";

    public static Connection getConnection() throws SQLException {
        String url = System.getenv().getOrDefault("DB_URL", DEFAULT_URL);
        String user = System.getenv().getOrDefault("DB_USER", DEFAULT_USER);
        String password = System.getenv().getOrDefault("DB_PASSWORD", DEFAULT_PASSWORD);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found", e);
        }

        try {
            return DriverManager.getConnection(url, user, password);
        } catch (SQLException e) {
            if (!url.contains("/2003_store")) {
                throw e;
            }

            String bootstrapUrl = url.replace("/2003_store", "/");
            try (Connection bootstrapConn = DriverManager.getConnection(bootstrapUrl, user, password);
                 java.sql.Statement statement = bootstrapConn.createStatement()) {
                statement.executeUpdate("CREATE DATABASE IF NOT EXISTS `2003_store` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            } catch (SQLException ignored) {
                // Ignore bootstrap failures and retry the original url; a later SQLException will still surface the root cause clearly.
            }

            return DriverManager.getConnection(url, user, password);
        }
    }
}
