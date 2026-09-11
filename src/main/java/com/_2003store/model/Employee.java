package com._2003store.model;

import java.util.ArrayList;
import java.util.List;

public class Employee {
    private int id;
    private String fullName;
    private String username;
    private String password;
    private String role;
    private String position;
    private String phone;
    private List<String> permissions = new ArrayList<>();

    public Employee() {
    }

    public Employee(int id, String fullName, String username, String password, String role, String position, String phone) {
        this.id = id;
        this.fullName = fullName;
        this.username = username;
        this.password = password;
        this.role = role;
        this.position = position;
        this.phone = phone;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public List<String> getPermissions() { return permissions; }
    public void setPermissions(List<String> permissions) { this.permissions = permissions == null ? new ArrayList<>() : permissions; }
}
