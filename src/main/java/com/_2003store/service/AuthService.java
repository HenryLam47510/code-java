package com._2003store.service;

import com._2003store.model.User;

import java.util.HashMap;
import java.util.Map;

public class AuthService {
    private static final Map<String, User> USERS = new HashMap<>();

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

        String role = user.getRole() == null ? "STAFF" : user.getRole().toUpperCase();
        return switch (module.toLowerCase()) {
            case "dashboard", "products", "orders", "customers", "stock", "stock-out", "reports", "inventory-report", "suppliers", "inventory-check" ->
                    role.equals("ADMIN") || role.equals("MANAGER") || role.equals("STAFF");
            case "employees", "warehouse-detail" -> role.equals("ADMIN") || role.equals("MANAGER");
            default -> false;
        };
    }

    public Map<String, User> getAllUsers() {
        return new HashMap<>(USERS);
    }
}
