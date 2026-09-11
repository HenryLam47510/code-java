package com._2003store.dao;

import com._2003store.config.DatabaseConfig;
import com._2003store.model.Employee;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDao {
    public void createEmployee(Employee employee) {
        String sql = "INSERT INTO employees (full_name, username, password, role, position, phone) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, employee.getFullName());
            stmt.setString(2, employee.getUsername());
            stmt.setString(3, employee.getPassword());
            stmt.setString(4, employee.getRole());
            stmt.setString(5, employee.getPosition());
            stmt.setString(6, employee.getPhone());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateEmployee(Employee employee) {
        String sql = "UPDATE employees SET full_name = ?, username = ?, password = ?, role = ?, position = ?, phone = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, employee.getFullName());
            stmt.setString(2, employee.getUsername());
            stmt.setString(3, employee.getPassword());
            stmt.setString(4, employee.getRole());
            stmt.setString(5, employee.getPosition());
            stmt.setString(6, employee.getPhone());
            stmt.setInt(7, employee.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteEmployee(int id) {
        String sql = "DELETE FROM employees WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Employee getEmployeeById(int id) {
        String sql = "SELECT * FROM employees WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Employee employee = new Employee();
                    employee.setId(rs.getInt("id"));
                    employee.setFullName(rs.getString("full_name"));
                    employee.setUsername(rs.getString("username"));
                    employee.setPassword(rs.getString("password"));
                    employee.setRole(rs.getString("role"));
                    employee.setPosition(rs.getString("position"));
                    employee.setPhone(rs.getString("phone"));
                    employee.setPermissions(getPermissionsForEmployee(id));
                    return employee;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<String> getPermissionsForEmployee(int employeeId) {
        List<String> permissions = new ArrayList<>();
        String sql = "SELECT module_name FROM employee_permissions WHERE employee_id = ? ORDER BY module_name ASC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, employeeId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    permissions.add(rs.getString("module_name"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return permissions;
    }

    public void savePermissions(int employeeId, List<String> permissions) {
        String deleteSql = "DELETE FROM employee_permissions WHERE employee_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
            deleteStmt.setInt(1, employeeId);
            deleteStmt.executeUpdate();

            if (permissions != null && !permissions.isEmpty()) {
                String insertSql = "INSERT INTO employee_permissions (employee_id, module_name, allowed) VALUES (?, ?, true)";
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    for (String module : permissions) {
                        if (module != null && !module.isBlank()) {
                            insertStmt.setInt(1, employeeId);
                            insertStmt.setString(2, module);
                            insertStmt.addBatch();
                        }
                    }
                    insertStmt.executeBatch();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Employee> getAllEmployees() {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT * FROM employees ORDER BY id ASC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Employee employee = new Employee();
                employee.setId(rs.getInt("id"));
                employee.setFullName(rs.getString("full_name"));
                employee.setUsername(rs.getString("username"));
                employee.setPassword(rs.getString("password"));
                employee.setRole(rs.getString("role"));
                employee.setPosition(rs.getString("position"));
                employee.setPhone(rs.getString("phone"));
                employee.setPermissions(getPermissionsForEmployee(employee.getId()));
                employees.add(employee);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return employees;
    }
}
