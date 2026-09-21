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
        USERS.put("staff", new User("staff", "123456", "Nhân viên bán hàng", "STAFF"));
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

        String role = user.getRole() == null ? "" : user.getRole().toUpperCase(Locale.ROOT);
        String normalizedModule = module.trim().toLowerCase(Locale.ROOT);

        if ("ADMIN".equals(role)) {
            return true;
        }

        if ("MANAGER".equals(role)) {
            boolean defaultAccess = switch (normalizedModule) {
                case "dashboard", "products", "orders", "customers", "stock", "stock-out", "reports", "inventory-report", "suppliers", "inventory-check", "warehouse-detail", "employees", "login-history", "sales", "payment" -> true;
                default -> false;
            };
            if (defaultAccess) {
                return true;
            }
            return user.getUsername() != null && employeeDao.hasPermission(user.getUsername(), normalizedModule);
        }

        if ("STAFF".equals(role)) {
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

    public Map<String, User> getAllUsers() {
        return new HashMap<>(USERS);
    }
}
