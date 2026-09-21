package com._2003store.service;

import com._2003store.dao.EmployeeDao;
import com._2003store.model.User;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

public class AuthService {
    private static final Map<String, User> USERS = new HashMap<>();
    private final EmployeeDao employeeDao = new EmployeeDao();

    static {
        USERS.put("admin", new User("admin", "123456", "Quản trị viên 2003 Store", "ADMIN"));
        USERS.put("manager", new User("manager", "123456", "Quản lý kho 2003 Store", "MANAGER"));
        USERS.put("staff", new User("staff", "123456", "Nhân viên bán hàng", "EMPLOYEE"));
        USERS.put("employee", new User("employee", "123456", "Nhân viên bán hàng", "EMPLOYEE"));
        USERS.put("cashier", new User("cashier", "123456", "Thu ngân 2003 Store", "EMPLOYEE"));
    }

    public static String normalizeRole(String role) {
        if (role == null) {
            return "";
        }
        String normalized = role.trim().toUpperCase(Locale.ROOT);
        if ("STAFF".equals(normalized) || "EMPLOYEE".equals(normalized)) {
            return "EMPLOYEE";
        }
        return normalized;
    }

    public static String normalizeModule(String module) {
        if (module == null) {
            return "";
        }
        String normalized = module.trim().toLowerCase(Locale.ROOT).replace('-', '_').replace(' ', '_');
        if ("payment_confirm".equals(normalized) || "paymentconfirm".equals(normalized) || "payment-confirm".equals(normalized)) {
            return "payment_confirm";
        }
        return normalized;
    }

    public static String getDashboardKey(User user) {
        if (user == null) {
            return "employee";
        }
        String role = normalizeRole(user.getRole());
        if ("ADMIN".equals(role)) {
            return "admin";
        }
        if ("MANAGER".equals(role)) {
            return "manager";
        }
        return "employee";
    }

    public static String getDashboardPath(User user) {
        return "/dashboard/" + getDashboardKey(user);
    }

    public User login(String username, String password) {
        User user = USERS.get(username);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }

    public boolean hasAccess(User user, String module) {
        if (user == null || module == null || module.isBlank()) {
            return false;
        }

        String role = normalizeRole(user.getRole());
        String normalizedModule = normalizeModule(module);

        if ("ADMIN".equals(role)) {
            return true;
        }

        if ("MANAGER".equals(role)) {
            boolean defaultAccess = switch (normalizedModule) {
                case "dashboard", "products", "orders", "customers", "stock", "stock-out", "reports", "staff-report", "inventory-report", "suppliers", "inventory-check", "warehouse-detail", "employees", "login-history", "sales", "payment", "payment_confirm" -> true;
                default -> false;
            };
            if (defaultAccess) {
                return true;
            }
            return user.getUsername() != null && employeeDao.hasPermission(user.getUsername(), normalizedModule);
        }

        if ("EMPLOYEE".equals(role)) {
            boolean defaultAccess = switch (normalizedModule) {
                case "dashboard", "products", "orders", "customers", "sales", "payment", "search-products" -> true;
                default -> false;
            };
            if (defaultAccess) {
                return true;
            }
            return user.getUsername() != null && employeeDao.hasPermission(user.getUsername(), normalizedModule);
        }

        return user.getUsername() != null && employeeDao.hasPermission(user.getUsername(), normalizedModule);
    }

    public boolean isAdmin(User user) {
        return "ADMIN".equals(normalizeRole(user != null ? user.getRole() : null));
    }

    public boolean isManager(User user) {
        return "MANAGER".equals(normalizeRole(user != null ? user.getRole() : null));
    }

    public boolean isEmployee(User user) {
        return "EMPLOYEE".equals(normalizeRole(user != null ? user.getRole() : null));
    }

    public boolean canWriteModule(User user, String module) {
        if (user == null || module == null || module.isBlank()) {
            return false;
        }

        String role = normalizeRole(user.getRole());
        String normalizedModule = normalizeModule(module);
        if ("ADMIN".equals(role)) {
            return true;
        }
        if ("MANAGER".equals(role)) {
            return switch (normalizedModule) {
                case "products", "orders", "customers", "stock", "stock-out", "reports", "staff-report", "inventory-report", "suppliers", "inventory-check", "warehouse-detail", "employees", "login-history", "payment_confirm" -> true;
                default -> false;
            };
        }
        if ("EMPLOYEE".equals(role)) {
            return switch (normalizedModule) {
                case "orders", "customers", "products", "payment_confirm" -> true;
                default -> false;
            };
        }
        return false;
    }

    public Map<String, User> getAllUsers() {
        return new HashMap<>(USERS);
    }
}
