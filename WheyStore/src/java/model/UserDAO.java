package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;
/* import utils.PasswordUtils; // ❌ COMMENTED OUT - Không dùng hash */

public class UserDAO {

    public UserDTO getUserById(String username) {
        String sql = "SELECT * FROM tblUsers WHERE username = ?";
        try (Connection conn = DbUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            System.out.println("DEBUG getUserById - Searching for username: " + username);

            try (ResultSet rs = ps.executeQuery()) {
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

    public List<UserDTO> getAllUsers() {
        List<UserDTO> userList = new ArrayList<>();
        String sql = "SELECT userID, fullname, email, phone, address, username, password, roleID, status, createdDate FROM tblUsers ORDER BY userID";
        try {
            Connection conn = DbUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserDTO user = new UserDTO();
                user.setUserID(rs.getString("userID"));
                user.setFullName(rs.getString("fullname"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRoleID(rs.getString("roleID"));
                user.setStatus(rs.getBoolean("status"));
                Timestamp ts = rs.getTimestamp("createdDate");
                user.setCreatedDate(ts != null ? ts.toLocalDateTime() : null);
                userList.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userList;
    }

    /**
     * ✅ SIMPLE LOGIN - No password hashing, plain text comparison
     */
    public boolean login(String username, String plainPassword) {
        System.out.println("🔐 DEBUG login - Attempting login for: " + username);
        System.out.println("🔑 DEBUG login - Plain password: " + plainPassword);
        
        UserDTO user = getUserById(username);

        if (user == null) {
            System.out.println("❌ DEBUG login - User not found: " + username);
            return false;
        }
        
        System.out.println("👤 DEBUG login - User found: " + user.getFullName());
        System.out.println("🔑 DEBUG login - Stored password: " + user.getPassword());
        System.out.println("✅ DEBUG login - User status: " + user.isStatus());
        System.out.println("🏷️ DEBUG login - User role: " + user.getRoleID());

        if (!user.isStatus()) {
            System.out.println("❌ DEBUG login - User account is deactivated");
            return false;
        }

        String storedPassword = user.getPassword();
        if (storedPassword == null) {
            System.out.println("❌ DEBUG login - Stored password is null");
            return false;
        }

        // ✅ SIMPLE COMPARISON: Plain text passwords
        boolean passwordMatch = storedPassword.equals(plainPassword);
        
        System.out.println("🔍 DEBUG login - Password comparison:");
        System.out.println("   Stored: '" + storedPassword + "'");
        System.out.println("   Input:  '" + plainPassword + "'");
        System.out.println("   Match:  " + passwordMatch);

        System.out.println("🎯 DEBUG login - Final result: " + passwordMatch);
        return passwordMatch;
    }

    public boolean isUsernameExist(String username) {
        String sql = "SELECT 1 FROM tblUsers WHERE username = ?";
        try (Connection conn = DbUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
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
        try (Connection conn = DbUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
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

    /**
     * ✅ REGISTER CUSTOMER - No password hashing, store plain text
     */
    public boolean registerCustomer(String fullName, String email, String phone, String address, String username, String password) {
        String sql = "INSERT INTO tblUsers (userID, fullname, email, phone, address, username, password, roleID, status, createdDate) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DbUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String userID = "USER" + System.currentTimeMillis();

            System.out.println("DEBUG registerCustomer - Storing plain password: " + password);

            ps.setString(1, userID);
            ps.setString(2, fullName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, address);
            ps.setString(6, username);
            ps.setString(7, password); // ✅ Store password as plain text
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
        try (Connection conn = DbUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
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
    
    /**
     * ✅ UPDATE PASSWORD - No hashing, store plain text
     */
    public boolean updatePassword(String userID, String newPassword) {
        String sql = "UPDATE tblUsers SET password = ? WHERE userID = ?";
        try {
            Connection conn = DbUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            // ✅ No hash: Store password as plain text
            ps.setString(1, newPassword);
            ps.setString(2, userID);
            int result = ps.executeUpdate();
            System.out.println("DEBUG updatePassword - Updated password for userID: " + userID);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * ✅ UPDATE PASSWORD BY EMAIL - No hashing
     */
    public boolean updatePasswordByEmail(String email, String newPassword) {
        String sql = "UPDATE tblUsers SET password = ? WHERE email = ?";
        try (Connection conn = DbUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            System.out.println("DEBUG updatePasswordByEmail - Updating password for email: " + email);
            
            ps.setString(1, newPassword); // ✅ Store as plain text
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

    /**
     * ✅ UPDATE PASSWORD BY USERNAME - No hashing
     */
    public boolean updatePasswordByUsername(String username, String newPassword) {
        String sql = "UPDATE tblUsers SET password = ? WHERE username = ?";
        try (Connection conn = DbUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("DEBUG updatePasswordByUsername - Updating password for username: " + username);

            ps.setString(1, newPassword); // ✅ Store as plain text
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

    /*
    ================================================================================
    🔒 HASH PASSWORD METHODS - COMMENTED OUT FOR FUTURE USE
    ================================================================================
    
    // TODO: Uncomment these methods when ready to use password hashing
    
    // public boolean loginWithHash(String username, String hashedInputPassword) {
    //     UserDTO user = getUserById(username);
    //     if (user != null && user.isStatus()) {
    //         String storedPassword = user.getPassword();
    //         if (storedPassword.length() == 64) {
    //             return storedPassword.equals(hashedInputPassword);
    //         } else {
    //             String hashedStored = PasswordUtils.encryptSHA256(storedPassword);
    //             if (hashedStored.equals(hashedInputPassword)) {
    //                 updatePassword(user.getUserID(), hashedInputPassword);
    //                 return true;
    //             }
    //         }
    //     }
    //     return false;
    // }
    
    // public boolean registerCustomerWithHash(String fullName, String email, String phone, 
    //                                        String address, String username, String password) {
    //     String hashedPassword = PasswordUtils.encryptSHA256(password);
    //     if (hashedPassword == null) return false;
    //     // ... rest of registration logic with hashedPassword
    // }
    
    ================================================================================
    */
}