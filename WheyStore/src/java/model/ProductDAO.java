package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

public class ProductDAO {
    
    // SQL Server queries for your database structure
    private static final String GET_ALL_PRODUCTS
            = "SELECT productID, productName, description, brand, price, imageURL, categoryID, status FROM tblProducts WHERE status = 1 ORDER BY productName";
    private static final String GET_PRODUCT_BY_ID = "SELECT productID, productName, description, brand, price, imageURL, categoryID, status FROM tblProducts WHERE productID = ?";
    private static final String CREATE_PRODUCT
            = "INSERT INTO tblProducts (productID, productName, description, brand, price, imageURL, categoryID, status) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_PRODUCT = "UPDATE tblProducts SET productName = ?, description = ?, brand = ?, price = ?, imageURL = ?, categoryID = ?, status = ? WHERE productID = ?";
    private static final String DELETE_PRODUCT = "DELETE FROM tblProducts WHERE productID = ?";
    
    // Search queries - SQL Server compatible
    private static final String SEARCH_PRODUCTS = "SELECT productID, productName, description, brand, price, imageURL, categoryID, status FROM tblProducts WHERE status = 1 AND (LOWER(productName) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?) OR LOWER(brand) LIKE LOWER(?)) ORDER BY productName";
    private static final String GET_PRODUCTS_BY_CATEGORY = "SELECT productID, productName, description, brand, price, imageURL, categoryID, status FROM tblProducts WHERE status = 1 AND categoryID = ? ORDER BY productName";
    private static final String GET_PRODUCTS_BY_PRICE_RANGE = "SELECT productID, productName, description, brand, price, imageURL, categoryID, status FROM tblProducts WHERE status = 1 AND price BETWEEN ? AND ? ORDER BY price";
    private static final String GET_PRODUCTS_BY_BRAND = "SELECT productID, productName, description, brand, price, imageURL, categoryID, status FROM tblProducts WHERE status = 1 AND LOWER(brand) LIKE LOWER(?) ORDER BY productName";

    public List<ProductDTO> getAllProducts() {
        List<ProductDTO> products = new ArrayList<>();
        System.out.println("🔍 ProductDAO: Getting all products from SQL Server...");
        
        try (Connection conn = DbUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(GET_ALL_PRODUCTS); 
             ResultSet rs = ps.executeQuery()) {
            
            System.out.println("✅ ProductDAO: Query executed successfully");
            
            while (rs.next()) {
                String id = rs.getString("productID");
                String name = rs.getString("productName");
                String description = rs.getString("description");
                String brand = rs.getString("brand");
                double price = rs.getDouble("price");
                String image = rs.getString("imageURL");
                int categoryId = rs.getInt("categoryID");
                boolean status = rs.getBoolean("status");
                
                ProductDTO product = new ProductDTO(id, name, description, brand, price, image, categoryId, status);
                products.add(product);
                System.out.println("📦 Found product: " + name + " (ID: " + id + ", Price: " + price + "₫)");
            }
            
            System.out.println("✅ ProductDAO: Total products loaded: " + products.size());
            
        } catch (Exception e) {
            System.err.println("❌ Error in getAllProducts(): " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    public ProductDTO getProductByID(String id) {
        ProductDTO product = null;
        System.out.println("🔍 ProductDAO: Getting product by ID: " + id);
        
        try (Connection conn = DbUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(GET_PRODUCT_BY_ID)) {
            
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                product = new ProductDTO(
                        rs.getString("productID"),
                        rs.getString("productName"),
                        rs.getString("description"),
                        rs.getString("brand"),
                        rs.getDouble("price"),
                        rs.getString("imageURL"),
                        rs.getInt("categoryID"),
                        rs.getBoolean("status")
                );
                System.out.println("✅ Found product: " + product.getName());
            } else {
                System.out.println("❌ Product not found with ID: " + id);
            }
        } catch (Exception e) {
            System.err.println("❌ Error in getProductByID(): " + e.getMessage());
            e.printStackTrace();
        }
        return product;
    }

    /**
     * Search products by keyword (case insensitive) - SQL Server compatible
     */
    public List<ProductDTO> searchProducts(String keyword) {
        List<ProductDTO> products = new ArrayList<>();
        System.out.println("🔍 ProductDAO: Searching products with keyword: " + keyword);
        
        if (keyword == null || keyword.trim().isEmpty()) {
            System.out.println("🔄 Empty keyword, returning all products");
            return getAllProducts();
        }
        
        try (Connection conn = DbUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(SEARCH_PRODUCTS)) {
            
            String searchPattern = "%" + keyword.trim() + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            
            System.out.println("🔍 Search pattern: " + searchPattern);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductDTO product = new ProductDTO(
                        rs.getString("productID"),
                        rs.getString("productName"),
                        rs.getString("description"),
                        rs.getString("brand"),
                        rs.getDouble("price"),
                        rs.getString("imageURL"),
                        rs.getInt("categoryID"),
                        rs.getBoolean("status")
                );
                products.add(product);
                System.out.println("📦 Found product: " + product.getName());
            }
            
            System.out.println("✅ Search completed. Found: " + products.size() + " products");
        } catch (Exception e) {
            System.err.println("❌ Error in searchProducts(): " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /**
     * Get products by category
     */
    public List<ProductDTO> getProductsByCategory(int categoryId) {
        List<ProductDTO> products = new ArrayList<>();
        System.out.println("🔍 ProductDAO: Getting products by category: " + categoryId);
        
        try (Connection conn = DbUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(GET_PRODUCTS_BY_CATEGORY)) {
            
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ProductDTO product = new ProductDTO(
                        rs.getString("productID"),
                        rs.getString("productName"),
                        rs.getString("description"),
                        rs.getString("brand"),
                        rs.getDouble("price"),
                        rs.getString("imageURL"),
                        rs.getInt("categoryID"),
                        rs.getBoolean("status")
                );
                products.add(product);
                System.out.println("📦 Found product: " + product.getName());
            }
            
            System.out.println("✅ Category filter completed. Found: " + products.size() + " products");
        } catch (Exception e) {
            System.err.println("❌ Error in getProductsByCategory(): " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /**
     * Get products by price range
     */
    public List<ProductDTO> getProductsByPriceRange(double minPrice, double maxPrice) {
        List<ProductDTO> products = new ArrayList<>();
        System.out.println("🔍 ProductDAO: Getting products by price range: " + minPrice + " - " + maxPrice);
        
        try (Connection conn = DbUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(GET_PRODUCTS_BY_PRICE_RANGE)) {
            
            ps.setDouble(1, minPrice);
            ps.setDouble(2, maxPrice);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ProductDTO product = new ProductDTO(
                        rs.getString("productID"),
                        rs.getString("productName"),
                        rs.getString("description"),
                        rs.getString("brand"),
                        rs.getDouble("price"),
                        rs.getString("imageURL"),
                        rs.getInt("categoryID"),
                        rs.getBoolean("status")
                );
                products.add(product);
                System.out.println("📦 Found product: " + product.getName() + " - " + product.getFormattedPrice());
            }
            
            System.out.println("✅ Price filter completed. Found: " + products.size() + " products");
        } catch (Exception e) {
            System.err.println("❌ Error in getProductsByPriceRange(): " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /**
     * Get products by brand (case insensitive)
     */
    public List<ProductDTO> getProductsByBrand(String brand) {
        List<ProductDTO> products = new ArrayList<>();
        System.out.println("🔍 ProductDAO: Getting products by brand: " + brand);
        
        try (Connection conn = DbUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(GET_PRODUCTS_BY_BRAND)) {
            
            ps.setString(1, "%" + brand + "%");
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ProductDTO product = new ProductDTO(
                        rs.getString("productID"),
                        rs.getString("productName"),
                        rs.getString("description"),
                        rs.getString("brand"),
                        rs.getDouble("price"),
                        rs.getString("imageURL"),
                        rs.getInt("categoryID"),
                        rs.getBoolean("status")
                );
                products.add(product);
                System.out.println("📦 Found product: " + product.getName());
            }
            
            System.out.println("✅ Brand filter completed. Found: " + products.size() + " products");
        } catch (Exception e) {
            System.err.println("❌ Error in getProductsByBrand(): " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /**
     * Advanced filter with multiple criteria
     */
    public List<ProductDTO> filterProducts(String keyword, Integer categoryId, Double minPrice, Double maxPrice, String brand) {
        List<ProductDTO> products = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT productID, productName, description, brand, price, imageURL, categoryID, status FROM tblProducts WHERE status = 1");
        List<Object> params = new ArrayList<>();
        
        System.out.println("🔍 ProductDAO: Advanced filter - keyword:" + keyword + ", category:" + categoryId + ", price:" + minPrice + "-" + maxPrice + ", brand:" + brand);
        
        // Build dynamic query
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.append(" AND (LOWER(productName) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?) OR LOWER(brand) LIKE LOWER(?))");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        if (categoryId != null && categoryId > 0) {
            query.append(" AND categoryID = ?");
            params.add(categoryId);
        }
        
        if (minPrice != null && maxPrice != null) {
            query.append(" AND price BETWEEN ? AND ?");
            params.add(minPrice);
            params.add(maxPrice);
        }
        
        if (brand != null && !brand.trim().isEmpty()) {
            query.append(" AND LOWER(brand) LIKE LOWER(?)");
            params.add("%" + brand.trim() + "%");
        }
        
        query.append(" ORDER BY productName");
        
        System.out.println("🔍 Final query: " + query.toString());
        
        try (Connection conn = DbUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
                System.out.println("📝 Parameter " + (i + 1) + ": " + params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductDTO product = new ProductDTO(
                        rs.getString("productID"),
                        rs.getString("productName"),
                        rs.getString("description"),
                        rs.getString("brand"),
                        rs.getDouble("price"),
                        rs.getString("imageURL"),
                        rs.getInt("categoryID"),
                        rs.getBoolean("status")
                );
                products.add(product);
                System.out.println("📦 Found product: " + product.getName());
            }
            
            System.out.println("✅ Advanced filter completed. Found: " + products.size() + " products");
        } catch (Exception e) {
            System.err.println("❌ Error in filterProducts(): " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    public boolean create(ProductDTO product) {
        boolean success = false;
        System.out.println("➕ ProductDAO: Creating product: " + product.getName());
        
        try (Connection conn = DbUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(CREATE_PRODUCT)) {
            
            ps.setString(1, product.getId());
            ps.setString(2, product.getName());
            ps.setString(3, product.getDescription());
            ps.setString(4, product.getBrand());
            ps.setDouble(5, product.getPrice());
            ps.setString(6, product.getImageURL());
            ps.setInt(7, product.getCategoryId());
            ps.setBoolean(8, product.isStatus());
            
            int rows = ps.executeUpdate();
            success = rows > 0;
            
            if (success) {
                System.out.println("✅ Product created successfully: " + product.getName());
            } else {
                System.out.println("❌ Failed to create product: " + product.getName());
            }
        } catch (Exception e) {
            System.err.println("❌ Error in create(): " + e.getMessage());
            e.printStackTrace();
        }
        return success;
    }

    public boolean update(ProductDTO product) {
        boolean success = false;
        System.out.println("✏️ ProductDAO: Updating product: " + product.getName());
        
        try (Connection conn = DbUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(UPDATE_PRODUCT)) {
            
            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setString(3, product.getBrand());
            ps.setDouble(4, product.getPrice());
            ps.setString(5, product.getImageURL());
            ps.setInt(6, product.getCategoryId());
            ps.setBoolean(7, product.isStatus());
            ps.setString(8, product.getId());
            
            int rows = ps.executeUpdate();
            success = rows > 0;
            
            if (success) {
                System.out.println("✅ Product updated successfully: " + product.getName());
            } else {
                System.out.println("❌ Failed to update product: " + product.getName());
            }
        } catch (Exception e) {
            System.err.println("❌ Error in update(): " + e.getMessage());
            e.printStackTrace();
        }
        return success;
    }

    public boolean delete(String id) {
        boolean success = false;
        System.out.println("🗑️ ProductDAO: Deleting product with ID: " + id);
        
        try (Connection conn = DbUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(DELETE_PRODUCT)) {
            
            ps.setString(1, id);
            int rows = ps.executeUpdate();
            success = rows > 0;
            
            if (success) {
                System.out.println("✅ Product deleted successfully with ID: " + id);
            } else {
                System.out.println("❌ Failed to delete product with ID: " + id);
            }
        } catch (Exception e) {
            System.err.println("❌ Error in delete(): " + e.getMessage());
            e.printStackTrace();
        }
        return success;
    }

    public boolean isProductExists(String id) {
        boolean exists = getProductByID(id) != null;
        System.out.println("🔍 Product exists check for ID " + id + ": " + exists);
        return exists;
    }
}