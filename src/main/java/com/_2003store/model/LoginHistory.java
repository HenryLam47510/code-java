package com._2003store.model;

import java.sql.Timestamp;

public class LoginHistory {
    private int id;
    private String username;
    private String fullName;
    private Timestamp loginTime;
    private String status;
    private String ipAddress;

    public LoginHistory() {
    }

    public LoginHistory(int id, String username, String fullName, Timestamp loginTime, String status, String ipAddress) {
        this.id = id;
        this.username = username;
        this.fullName = fullName;
        this.loginTime = loginTime;
        this.status = status;
        this.ipAddress = ipAddress;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public Timestamp getLoginTime() { return loginTime; }
    public void setLoginTime(Timestamp loginTime) { this.loginTime = loginTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }
}
