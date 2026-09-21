package com._2003store.dao;

import com._2003store.config.DatabaseConfig;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class DatabaseInitializer {
    public void init() {
        try (Connection conn = DatabaseConfig.getConnection(); Statement stmt = conn.createStatement()) {
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS products (" +
                    "id INT PRIMARY KEY, " +
                    "name VARCHAR(255), " +
                    "category VARCHAR(100), " +
                    "brand VARCHAR(100), " +
                    "price DECIMAL(12,0), " +
                    "stock INT, " +
                    "image VARCHAR(500), " +
                    "description TEXT, " +
                    "is_deleted BOOLEAN DEFAULT FALSE, " +
                    "deleted_reason VARCHAR(255))"
            );

            try {
                stmt.executeUpdate("ALTER TABLE products ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE");
            } catch (Exception ignored) {
            }
            try {
                stmt.executeUpdate("ALTER TABLE products ADD COLUMN deleted_reason VARCHAR(255)");
            } catch (Exception ignored) {
            }

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS orders (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "order_code VARCHAR(30) UNIQUE, " +
                    "customer_name VARCHAR(255), " +
                    "phone VARCHAR(20), " +
                    "status VARCHAR(50), " +
                    "payment_method VARCHAR(50), " +
                    "payment_status VARCHAR(50) DEFAULT 'CHUA_THANH_TOAN', " +
                    "transaction_note VARCHAR(255), " +
                    "qr_code TEXT, " +
                    "total_amount DECIMAL(12,0), " +
                    "is_hidden BOOLEAN DEFAULT FALSE, " +
                    "cancel_reason VARCHAR(255), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
            );

            try {
                stmt.executeUpdate("ALTER TABLE orders ADD COLUMN order_code VARCHAR(30)");
            } catch (Exception ignored) {
            }
            try {
                stmt.executeUpdate("CREATE UNIQUE INDEX idx_orders_order_code ON orders(order_code)");
            } catch (Exception ignored) {
            }
            try {
                stmt.executeUpdate("ALTER TABLE orders ADD COLUMN payment_method VARCHAR(50)");
            } catch (Exception ignored) {
            }
            try {
                stmt.executeUpdate("ALTER TABLE orders ADD COLUMN payment_status VARCHAR(50) DEFAULT 'CHUA_THANH_TOAN'");
            } catch (Exception ignored) {
            }
            try {
                stmt.executeUpdate("ALTER TABLE orders ADD COLUMN transaction_note VARCHAR(255)");
            } catch (Exception ignored) {
            }
            try {
                stmt.executeUpdate("ALTER TABLE orders ADD COLUMN qr_code TEXT");
            } catch (Exception ignored) {
            }
            try {
                stmt.executeUpdate("ALTER TABLE orders ADD COLUMN is_hidden BOOLEAN DEFAULT FALSE");
            } catch (Exception ignored) {
            }
            try {
                stmt.executeUpdate("ALTER TABLE orders ADD COLUMN cancel_reason VARCHAR(255)");
            } catch (Exception ignored) {
            }

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS order_items (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "order_id INT, " +
                    "product_id INT, " +
                    "product_name VARCHAR(255), " +
                    "quantity INT, " +
                    "unit_price DECIMAL(12,0), " +
                    "FOREIGN KEY (order_id) REFERENCES orders(id))"
            );

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS customers (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "name VARCHAR(255), " +
                    "phone VARCHAR(20), " +
                    "email VARCHAR(255), " +
                    "note TEXT)"
            );

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS invoices (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "order_id INT, " +
                    "invoice_code VARCHAR(100), " +
                    "customer_name VARCHAR(255), " +
                    "phone VARCHAR(20), " +
                    "total_amount DECIMAL(12,0), " +
                    "payment_method VARCHAR(50), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
            );

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS stock_receipts (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "product_id INT, " +
                    "product_name VARCHAR(255), " +
                    "supplier VARCHAR(255), " +
                    "quantity INT, " +
                    "unit_price DECIMAL(12,0), " +
                    "total_cost DECIMAL(12,0), " +
                    "note TEXT, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
            );

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS stock_issues (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "product_id INT, " +
                    "product_name VARCHAR(255), " +
                    "quantity INT, " +
                    "reason VARCHAR(100), " +
                    "note TEXT, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
            );

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS suppliers (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "name VARCHAR(255), " +
                    "phone VARCHAR(20), " +
                    "email VARCHAR(255), " +
                    "address VARCHAR(255), " +
                    "note TEXT, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
            );

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS inventory_counts (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "product_id INT, " +
                    "product_name VARCHAR(255), " +
                    "expected_quantity INT, " +
                    "counted_quantity INT, " +
                    "variance INT, " +
                    "counted_by VARCHAR(255), " +
                    "note TEXT, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
            );

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS employees (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "full_name VARCHAR(255), " +
                    "username VARCHAR(100) UNIQUE, " +
                    "password VARCHAR(255), " +
                    "role VARCHAR(50), " +
                    "position VARCHAR(100), " +
                    "phone VARCHAR(20), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
            );

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS employee_permissions (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "employee_id INT, " +
                    "module_name VARCHAR(100), " +
                    "allowed BOOLEAN DEFAULT TRUE, " +
                    "FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE)"
            );

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS login_history (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "username VARCHAR(100), " +
                    "full_name VARCHAR(255), " +
                    "login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "status VARCHAR(20), " +
                    "ip_address VARCHAR(100))"
            );

            long count = 0;
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM products")) {
                if (rs.next()) {
                    count = rs.getLong(1);
                }
            }

            if (count == 0) {
                String[] inserts = {
                        "INSERT INTO products (id, name, category, brand, price, stock, image, description) VALUES (1, 'Nike Air Max 2003', 'Running', 'Nike', 2499000, 12, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80', 'Giay chay bo thoang khi, de cao su ben bi.')",
                        "INSERT INTO products (id, name, category, brand, price, stock, image, description) VALUES (2, 'Adidas Ultra Boost', 'Lifestyle', 'Adidas', 2999000, 8, 'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?auto=format&fit=crop&w=800&q=80', 'Phong cach tre trung, phu hop di hoc va di choi.')",
                        "INSERT INTO products (id, name, category, brand, price, stock, image, description) VALUES (3, 'New Balance 530', 'Sneaker', 'New Balance', 2199000, 10, 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?auto=format&fit=crop&w=800&q=80', 'Thiet ke co dien, thoai mai moi hoat dong.')",
                        "INSERT INTO products (id, name, category, brand, price, stock, image, description) VALUES (4, 'Puma RS-X', 'Sport', 'Puma', 2699000, 6, 'https://images.unsplash.com/photo-1543508282-6319a3e2621f?auto=format&fit=crop&w=800&q=80', 'Giay the thao nang dong, ho tro di chuyen nhanh.')"
                };

                for (String sql : inserts) {
                    stmt.executeUpdate(sql);
                }
            }

            long employeeCount = 0;
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM employees")) {
                if (rs.next()) {
                    employeeCount = rs.getLong(1);
                }
            }

            if (employeeCount == 0) {
                stmt.executeUpdate("INSERT INTO employees (full_name, username, password, role, position, phone) VALUES ('Quản trị viên 2003 Store', 'admin', '123456', 'ADMIN', 'Quản trị', '0901000001')");
                stmt.executeUpdate("INSERT INTO employees (full_name, username, password, role, position, phone) VALUES ('Quản lý kho 2003 Store', 'manager', '123456', 'MANAGER', 'Quản lý kho', '0901000002')");
                stmt.executeUpdate("INSERT INTO employees (full_name, username, password, role, position, phone) VALUES ('Nhân viên bán hàng', 'staff', '123456', 'EMPLOYEE', 'Nhân viên', '0901000003')");
                stmt.executeUpdate("INSERT INTO employees (full_name, username, password, role, position, phone) VALUES ('Thu ngân 2003 Store', 'cashier', '123456', 'EMPLOYEE', 'Thu ngân', '0901000004')");

                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (1, 'dashboard', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (1, 'products', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (1, 'orders', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (1, 'customers', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (1, 'stock', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (1, 'stock-out', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (1, 'reports', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (1, 'inventory-report', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (1, 'warehouse-detail', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (1, 'suppliers', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (1, 'inventory-check', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (1, 'employees', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (1, 'login-history', true)");

                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (2, 'dashboard', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (2, 'stock', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (2, 'stock-out', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (2, 'inventory-report', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (2, 'warehouse-detail', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (2, 'suppliers', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (2, 'inventory-check', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (2, 'reports', true)");

                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (3, 'dashboard', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (3, 'orders', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (3, 'customers', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (3, 'products', true)");

                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (4, 'dashboard', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (4, 'orders', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (4, 'customers', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (4, 'products', true)");
                stmt.executeUpdate("INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (4, 'payment_confirm', true)");
            }

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS order_code_sequence (date_key VARCHAR(8) PRIMARY KEY, next_sequence INT NOT NULL DEFAULT 0)");

            try (ResultSet rs = stmt.executeQuery("SELECT id, created_at FROM orders WHERE order_code IS NULL OR order_code = '' ORDER BY created_at, id")) {
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String dateKey = rs.getTimestamp("created_at").toLocalDateTime().toLocalDate().format(java.time.format.DateTimeFormatter.BASIC_ISO_DATE);
                    int sequence = 1;
                    try (ResultSet seqRs = stmt.executeQuery("SELECT COALESCE(MAX(CAST(SUBSTRING(order_code, 11) AS UNSIGNED)), 0) AS max_seq FROM orders WHERE order_code LIKE 'DH" + dateKey + "-%'")) {
                        if (seqRs.next()) {
                            sequence = seqRs.getInt("max_seq") + 1;
                        }
                    }
                    String orderCode = com._2003store.service.OrderCodeGenerator.generateForDate(java.time.LocalDate.parse(dateKey, java.time.format.DateTimeFormatter.BASIC_ISO_DATE), sequence);
                    stmt.executeUpdate("UPDATE orders SET order_code = '" + orderCode + "' WHERE id = " + id);
                }
            } catch (Exception ignored) {
            }

            long orderCount = 0;
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM orders")) {
                if (rs.next()) {
                    orderCount = rs.getLong(1);
                }
            }

            if (orderCount == 0) {
                String[] orderInserts = {
                        "INSERT INTO orders (customer_name, phone, status, payment_method, payment_status, transaction_note, qr_code, total_amount, order_code) VALUES ('Nguyen Van A', '0901234567', 'Hoan thanh', 'BANK_TRANSFER', 'DA_THANH_TOAN', 'Chuyen khoan theo ma HD01', 'QR_001', 5499000, 'DH20260921-0001')",
                        "INSERT INTO orders (customer_name, phone, status, payment_method, payment_status, transaction_note, qr_code, total_amount, order_code) VALUES ('Tran Thi B', '0912345678', 'Dang giao', 'COD', 'CHUA_THANH_TOAN', 'Thanh toan khi nhan hang', 'QR_002', 3999000, 'DH20260921-0002')",
                        "INSERT INTO orders (customer_name, phone, status, payment_method, payment_status, transaction_note, qr_code, total_amount, order_code) VALUES ('Le Van C', '0987654321', 'Cho xac nhan', 'MOMO', 'CHUA_THANH_TOAN', 'Chua xac nhan thanh toan', 'QR_003', 7990000, 'DH20260921-0003')"
                };

                for (String sql : orderInserts) {
                    stmt.executeUpdate(sql);
                }
            }
        } catch (Exception e) {
            System.out.println("Database init skipped: " + e.getMessage());
        }
    }
}
