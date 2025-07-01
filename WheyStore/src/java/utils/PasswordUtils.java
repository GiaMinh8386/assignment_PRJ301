/*
================================================================================
🔒 PASSWORD HASHING UTILITY - CURRENTLY NOT IN USE
================================================================================
This class is kept for future reference when implementing password security.
All methods are commented out to prevent accidental usage.

To enable password hashing:
1. Uncomment all methods in this class
2. Update UserController.java to use PasswordUtils.encryptSHA256()
3. Update UserDAO.java to use hashed password methods
4. Run migration to hash existing passwords
================================================================================
*/

package utils;

/*
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;
import model.UserDAO;
import model.UserDTO;
*/

/**
 * Password encryption utility using SHA-256
 * ❌ CURRENTLY DISABLED - All methods commented out
 */
public class PasswordUtils {

    /*
    // Encrypt password using SHA-256
    public static String encryptSHA256(String password) {
        if (password == null || password.isEmpty()) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            
            StringBuilder hexString = new StringBuilder();
            for (byte hashByte : hashBytes) {
                String hex = Integer.toHexString(0xff & hashByte);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            System.err.println("SHA-256 algorithm not available: " + e.getMessage());
            return null;
        } catch (Exception e) {
            System.err.println("Error during SHA-256 encryption: " + e.getMessage());
            return null;
        }
    }

    // Verify if plain password matches encrypted password
    public static boolean verifyPassword(String plainPassword, String encryptedPassword) {
        if (plainPassword == null || encryptedPassword == null) {
            return false;
        }
        String hashedInput = encryptSHA256(plainPassword);
        return encryptedPassword.equals(hashedInput);
    }

    // Password migration utility - Convert plain passwords to hashed
    public static void migratePasswords() {
        try {
            System.out.println("🔄 Starting password migration...");
            UserDAO udao = new UserDAO();
            List<UserDTO> list = udao.getAllUsers();
            
            int successCount = 0;
            int failCount = 0;
            int alreadyHashedCount = 0;
            
            for (UserDTO user : list) {
                String currentPassword = user.getPassword();
                
                // Check if password is already hashed (SHA-256 = 64 characters)
                if (currentPassword != null && currentPassword.length() == 64) {
                    System.out.println("✅ Password already hashed for user: " + user.getUsername());
                    alreadyHashedCount++;
                    continue;
                }
                
                System.out.println("🔄 Migrating password for user: " + user.getUsername());
                
                // Hash the plain password
                String hashedPassword = encryptSHA256(currentPassword);
                if (hashedPassword != null) {
                    boolean updated = updatePasswordDirectly(user.getUserID(), hashedPassword);
                    if (updated) {
                        System.out.println("✅ Updated password for user: " + user.getUsername());
                        successCount++;
                    } else {
                        System.out.println("❌ Failed to update password for user: " + user.getUsername());
                        failCount++;
                    }
                } else {
                    System.out.println("❌ Failed to hash password for user: " + user.getUsername());
                    failCount++;
                }
            }
            
            System.out.println("📊 Password migration completed:");
            System.out.println("✅ Success: " + successCount);
            System.out.println("🔄 Already hashed: " + alreadyHashedCount);
            System.out.println("❌ Failed: " + failCount);
            
        } catch (Exception e) {
            System.err.println("❌ Error during password migration: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Direct SQL update to avoid circular dependency during migration
    private static boolean updatePasswordDirectly(String userID, String hashedPassword) {
        try {
            java.sql.Connection conn = utils.DbUtils.getConnection();
            java.sql.PreparedStatement ps = conn.prepareStatement("UPDATE tblUsers SET password = ? WHERE userID = ?");
            ps.setString(1, hashedPassword);
            ps.setString(2, userID);
            int result = ps.executeUpdate();
            ps.close();
            conn.close();
            return result > 0;
        } catch (Exception e) {
            System.err.println("❌ Direct password update failed: " + e.getMessage());
            return false;
        }
    }

    // Test password hashing functionality
    public static void testPasswordHash() {
        System.out.println("🧪 TESTING PASSWORD HASHES:");
        System.out.println("=====================================");
        
        String[] testPasswords = {"1", "123", "admin", "password"};
        
        for (String pwd : testPasswords) {
            String hashed = encryptSHA256(pwd);
            System.out.println("Plain: '" + pwd + "' -> Hash: " + hashed);
        }
        
        System.out.println("=====================================");
        System.out.println("✅ Copy hash value tương ứng để test login!");
    }

    // Main method for testing and migration
    public static void main(String[] args) {
        System.out.println("🔧 Password Utils - Debug & Migration Tool");
        System.out.println("==========================================");
        
        // 1. Test hash generation
        testPasswordHash();
        
        System.out.println("\\n🚀 Starting password migration...");
        
        // 2. Run migration
        migratePasswords();
        
        System.out.println("\\n✅ All done! You can now test login with:");
        System.out.println("   Username: admin");
        System.out.println("   Password: 1");
    }
    */

    // ✅ TEMPORARY METHOD - Just for demonstration that class exists
    public static void showMessage() {
        System.out.println("🔒 PasswordUtils is currently disabled.");
        System.out.println("💡 All password operations use plain text for now.");
        System.out.println("📚 Hash methods are commented out for future use.");
    }

    public static void main(String[] args) {
        showMessage();
    }
}