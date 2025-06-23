package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import utils.DbUtils;

public class UserDAO {

    public UserDTO getUserById(String username) {
        String sql = "SELECT * FROM tblUsers WHERE username = ?";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            System.out.println("DEBUG getUserById - Searching for username: " + username);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String userID = rs.getString("userID");
                    String fullName = rs.getString("fullname");
                    String email = rs.getString("email");
                    String phone = rs.getString("phone");
                    String address = rs.getString("address");
                    String password = rs.getString("password");
                    String roleID = rs.getString("roleID");
                    boolean status = rs.getBoolean("status");
                    Timestamp ts = rs.getTimestamp("createdDate");
                    LocalDateTime createdDate = ts != null ? ts.toLocalDateTime() : null;

                    System.out.println("DEBUG getUserById - Found user: " + fullName + " (Role: " + roleID + ")");
                    return new UserDTO(userID, fullName, email, phone, address, username, password, roleID, status, createdDate);
                } else {
                    System.out.println("DEBUG getUserById - User not found: " + username);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG getUserById - Error: " + e.getMessage());
        }
        return null;
    }

    public boolean login(String username, String password) {
        System.out.println("DEBUG login - Attempting login for: " + username);
        UserDTO user = getUserById(username);

        if (user != null) {
            System.out.println("DEBUG login - User found, checking password");
            System.out.println("DEBUG login - User password: " + user.getPassword());
            System.out.println("DEBUG login - Input password: " + password);
            System.out.println("DEBUG login - User status: " + user.isStatus());

            boolean passwordMatch = user.getPassword().equals(password);
            boolean userActive = user.isStatus();

            System.out.println("DEBUG login - Password match: " + passwordMatch);
            System.out.println("DEBUG login - User active: " + userActive);

            return passwordMatch && userActive;
        } else {
            System.out.println("DEBUG login - User not found");
            return false;
        }
    }

    public boolean isUsernameExist(String username) {
        String sql = "SELECT 1 FROM tblUsers WHERE username = ?";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            try ( ResultSet rs = ps.executeQuery()) {
                boolean exists = rs.next();
                System.out.println("DEBUG isUsernameExist - Username '" + username + "' exists: " + exists);
                return exists;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG isUsernameExist - Error: " + e.getMessage());
        }
        return false;
    }

    public boolean isEmailExist(String email) {
        String sql = "SELECT 1 FROM tblUsers WHERE email = ?";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try ( ResultSet rs = ps.executeQuery()) {
                boolean exists = rs.next();
                System.out.println("DEBUG isEmailExist - Email '" + email + "' exists: " + exists);
                return exists;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG isEmailExist - Error: " + e.getMessage());
        }
        return false;
    }

    public boolean registerCustomer(String fullName, String email, String phone, String address, String username, String password) {
        String sql = "INSERT INTO tblUsers (userID, fullname, email, phone, address, username, password, roleID, status, createdDate) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            // Generate userID (you can implement your own logic)
            String userID = "USER" + System.currentTimeMillis();

            ps.setString(1, userID);
            ps.setString(2, fullName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, address);
            ps.setString(6, username);
            ps.setString(7, password); // Note: Should hash password in production
            ps.setString(8, "MB"); // Member role
            ps.setBoolean(9, true); // Active status
            ps.setTimestamp(10, Timestamp.valueOf(LocalDateTime.now()));

            boolean success = ps.executeUpdate() > 0;
            System.out.println("DEBUG registerCustomer - Registration " + (success ? "successful" : "failed") + " for: " + username);
            return success;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG registerCustomer - Error: " + e.getMessage());
        }
        return false;
    }

    public String findUsernameByEmail(String email) {
        String sql = "SELECT username FROM tblUsers WHERE email = ?";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String foundUsername = rs.getString("username");
                    System.out.println("DEBUG findUsernameByEmail - Found username: " + foundUsername);
                    return foundUsername;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG findUsernameByEmail - Error: " + e.getMessage());
        }
        return null;
    }

    public boolean updatePasswordByEmail(String email, String newPassword) {
        String sql = "UPDATE tblUsers SET password = ? WHERE email = ?";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setString(2, email);
            boolean updated = ps.executeUpdate() > 0;
            System.out.println("DEBUG updatePasswordByEmail - Password update " + (updated ? "successful" : "failed") + " for email: " + email);
            return updated;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG updatePasswordByEmail - Error: " + e.getMessage());
        }
        return false;
    }

    public boolean updatePasswordByUsername(String username, String newPassword) {
        String sql = "UPDATE tblUsers SET password = ? WHERE username = ?";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setString(2, username);

            boolean updated = ps.executeUpdate() > 0;
            System.out.println("DEBUG updatePasswordByUsername - Password updated: " + updated);
            return updated;

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG updatePasswordByUsername - Error: " + e.getMessage());
        }
        return false;
    }
}
