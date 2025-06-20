package test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DbUtils;
import model.UserDAO;
import model.ProductDAO;
import model.UserDTO;
import model.ProductDTO;
import java.util.List;

public class FullDatabaseTest {
    
    public static void main(String[] args) {
        System.out.println("🚀 FULL DATABASE TEST STARTING...");
        System.out.println("==================================================");
        
        // Test 1: Basic Connection
        testBasicConnection();
        
        // Test 2: Users Table & Login
        testUsersAndLogin();
        
        // Test 3: Products Table & Search
        testProductsAndSearch();
        
        // Test 4: Categories
        testCategories();
        
        System.out.println("");
        System.out.println("==================================================");
        System.out.println("🎯 ALL TESTS COMPLETED!");
    }
    
    private static void testBasicConnection() {
        System.out.println("");
        System.out.println("🔍 TEST 1: DATABASE CONNECTION");
        System.out.println("------------------------------");
        
        try (Connection conn = DbUtils.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ Connection: SUCCESS");
                System.out.println("📊 Database: " + conn.getMetaData().getDatabaseProductName());
                System.out.println("📋 Version: " + conn.getMetaData().getDatabaseProductVersion());
                System.out.println("🏢 URL: " + conn.getMetaData().getURL());
                System.out.println("👤 User: " + conn.getMetaData().getUserName());
            } else {
                System.out.println("❌ Connection: FAILED");
            }
        } catch (Exception e) {
            System.err.println("❌ Connection error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static void testUsersAndLogin() {
        System.out.println("");
        System.out.println("👥 TEST 2: USERS & LOGIN");
        System.out.println("------------------------------");
        
        try {
            // Test user count
            String countSql = "SELECT COUNT(*) as total FROM tblUsers";
            try (Connection conn = DbUtils.getConnection();
                 PreparedStatement ps = conn.prepareStatement(countSql);
                 ResultSet rs = ps.executeQuery()) {
                
                if (rs.next()) {
                    int total = rs.getInt("total");
                    System.out.println("👥 Total users in database: " + total);
                }
            }
            
            // Test UserDAO login functionality
            UserDAO userDAO = new UserDAO();
            
            // Test login with admin account
            System.out.println("");
            System.out.println("🔐 Testing login functionality:");
            
            String[] testAccounts = {
                "admin:1:AD",
                "huynq:1:MB", 
                "haunt:1:MB",
                "minhnng:1:MB"
            };
            
            for (String account : testAccounts) {
                String[] parts = account.split(":");
                String username = parts[0];
                String password = parts[1];
                String expectedRole = parts[2];
                
                System.out.println("");
                System.out.println("👤 Testing: " + username);
                
                // Test getUserById
                UserDTO user = userDAO.getUserById(username);
                if (user != null) {
                    System.out.println("   ✅ User found: " + user.getFullName());
                    System.out.println("   🎭 Role: " + user.getRoleID());
                    System.out.println("   📧 Email: " + user.getEmail());
                    System.out.println("   📱 Phone: " + user.getPhone());
                    System.out.println("   🔐 Password in DB: " + user.getPassword());
                    
                    // Test login
                    boolean loginResult = userDAO.login(username, password);
                    System.out.println("   🔑 Login test: " + (loginResult ? "SUCCESS" : "FAILED"));
                    
                    if (!loginResult) {
                        System.out.println("   ⚠️  Login failed - check password matching");
                    }
                } else {
                    System.out.println("   ❌ User not found: " + username);
                }
            }
            
        } catch (Exception e) {
            System.err.println("❌ Users test error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static void testProductsAndSearch() {
        System.out.println("");
        System.out.println("📦 TEST 3: PRODUCTS & SEARCH");
        System.out.println("------------------------------");
        
        try {
            ProductDAO productDAO = new ProductDAO();
            
            // Test get all products
            System.out.println("🔍 Testing getAllProducts():");
            List<ProductDTO> allProducts = productDAO.getAllProducts();
            System.out.println("   📦 Total products found: " + allProducts.size());
            
            if (!allProducts.isEmpty()) {
                System.out.println("   📋 Sample products:");
                for (int i = 0; i < Math.min(3, allProducts.size()); i++) {
                    ProductDTO p = allProducts.get(i);
                    System.out.println("     " + (i+1) + ". " + p.getName() + 
                                     " - " + p.getBrand() + 
                                     " - " + p.getFormattedPrice());
                }
            }
            
            // Test search functionality
            System.out.println("");
            System.out.println("🔍 Testing search functionality:");
            String[] searchTerms = {"whey", "protein", "creatine", "vitamin"};
            
            for (String term : searchTerms) {
                List<ProductDTO> searchResults = productDAO.searchProducts(term);
                System.out.println("   🔍 '" + term + "': " + searchResults.size() + " products found");
            }
            
            // Test category filter
            System.out.println("");
            System.out.println("📂 Testing category filter:");
            for (int catId = 1; catId <= 5; catId++) {
                List<ProductDTO> categoryProducts = productDAO.getProductsByCategory(catId);
                System.out.println("   📂 Category " + catId + ": " + categoryProducts.size() + " products");
            }
            
            // Test price filter
            System.out.println("");
            System.out.println("💰 Testing price filter:");
            List<ProductDTO> cheapProducts = productDAO.getProductsByPriceRange(0, 500000);
            List<ProductDTO> expensiveProducts = productDAO.getProductsByPriceRange(1000000, 10000000);
            System.out.println("   💰 Under 500k: " + cheapProducts.size() + " products");
            System.out.println("   💰 Over 1M: " + expensiveProducts.size() + " products");
            
        } catch (Exception e) {
            System.err.println("❌ Products test error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static void testCategories() {
        System.out.println("");
        System.out.println("📂 TEST 4: CATEGORIES");
        System.out.println("------------------------------");
        
        try {
            String sql = "SELECT categoryID, categoryName, description FROM tblCategories ORDER BY categoryID";
            
            try (Connection conn = DbUtils.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                
                System.out.println("📂 Available categories:");
                while (rs.next()) {
                    int id = rs.getInt("categoryID");
                    String name = rs.getString("categoryName");
                    String desc = rs.getString("description");
                    
                    System.out.println("   " + id + ". " + name);
                    if (desc != null && !desc.trim().isEmpty()) {
                        String shortDesc = desc.length() > 100 ? desc.substring(0, 100) + "..." : desc;
                        System.out.println("      📝 " + shortDesc);
                    }
                }
            }
            
        } catch (Exception e) {
            System.err.println("❌ Categories test error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}