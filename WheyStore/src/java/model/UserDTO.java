/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package model;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDateTime;



public class UserDTO {
    private String userID;
    private String fullName;
    private String email;
    private String phone;
    private String address;
    private String username;
    private String password;
    private String roleID;
    private boolean status;
    private LocalDateTime createdDate;
    
    public UserDTO() {
    }
    
    public UserDTO(String userID, String fullName, String email, String phone, String address, 
                   String username, String password, String roleID, boolean status, LocalDateTime createdDate) {
        this.userID = userID;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.username = username;
        this.password = password;
        this.roleID = roleID;
        this.status = status;
        this.createdDate = createdDate;
    }
    
    // Getters and Setters
    public String getUserID() {
        return userID;
    }
    
    public void setUserID(String userID) {
        this.userID = userID;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getRoleID() {
        return roleID;
    }
    
    public void setRoleID(String roleID) {
        this.roleID = roleID;
    }
    
    public boolean isStatus() {
        return status;
    }
    
    public void setStatus(boolean status) {
        this.status = status;
    }
    
    public LocalDateTime getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }
    
    @Override
    public String toString() {
        return "UserDTO{"
                + "userID='" + userID + '\''
                + ", fullName='" + fullName + '\''
                + ", email='" + email + '\''
                + ", phone='" + phone + '\''
                + ", address='" + address + '\''
                + ", username='" + username + '\''
                + ", password='" + password + '\''
                + ", roleID='" + roleID + '\''
                + ", status=" + status
                + ", createdDate=" + createdDate
                + '}';
    }
}