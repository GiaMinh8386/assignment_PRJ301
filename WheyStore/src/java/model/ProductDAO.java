/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

/**
 *
 * @author ASUS
 */
public class ProductDAO {

    private static final String GET_ALL_PRODUCTS = "SELECT ProductID, ProductName, Description, Price, ImageURL, Brand, StockQuantity, ProductCode, CategoryID FROM Products";
    private static final String GET_PRODUCT_BY_ID = "SELECT ProductID, ProductName, Description, Price, ImageURL, Brand, StockQuantity, ProductCode, CategoryID FROM Products WHERE ProductID = ?";
    private static final String CREATE_PRODUCT = "INSERT INTO Products (ProductID, ProductName, ImageURL, Description, Price, Brand, StockQuantity, ProductCode, CategoryID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_PRODUCT = "UPDATE Products SET ProductName = ?, ImageURL = ?, Description = ?, Price = ?, Brand = ?, StockQuantity = ?, ProductCode = ?, CategoryID = ? WHERE ProductID = ?";
    private static final String DELETE_PRODUCT = "DELETE FROM Products WHERE ProductID = ?";

    public List<ProductDTO> getAllProducts() {
        List<ProductDTO> products = new ArrayList<>();
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_ALL_PRODUCTS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ProductDTO product = new ProductDTO(
                        String.valueOf(rs.getInt("ProductID")),
                        rs.getString("ProductName"),
                        rs.getString("ImageURL"),
                        rs.getString("Description"),
                        rs.getDouble("Price"),
                        rs.getString("Brand"),
                        rs.getInt("StockQuantity"),
                        rs.getString("ProductCode"),
                        rs.getInt("CategoryID")
                );
                products.add(product);
            }
        } catch (Exception e) {
            System.err.println("Error in getAllProducts(): " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /**
     * Get product by ID
     *
     * @param id Product ID to search
     * @return ProductDTO object or null if not found
     */
    public ProductDTO getProductByID(String id) {
        ProductDTO product = null;
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_PRODUCT_BY_ID)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                product = new ProductDTO(
                        String.valueOf(rs.getInt("ProductID")),
                        rs.getString("ProductName"),
                        rs.getString("ImageURL"),
                        rs.getString("Description"),
                        rs.getDouble("Price"),
                        rs.getString("Brand"),
                        rs.getInt("StockQuantity"),
                        rs.getString("ProductCode"),
                        rs.getInt("CategoryID")
                );
            }
        } catch (Exception e) {
            System.err.println("Error in getProductByID(): " + e.getMessage());
            e.printStackTrace();
        }
        return product;
    }

    /**
     * Create new product
     *
     * @param product ProductDTO object to create
     * @return true if successful, false otherwise
     */
    public boolean create(ProductDTO product) {
        boolean success = false;
   
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(CREATE_PRODUCT)) {

            ps.setString(1, product.getId());
            ps.setString(2, product.getName());
            ps.setString(3, product.getImage());
            ps.setString(4, product.getDescription());
            ps.setDouble(5, product.getPrice());
            ps.setString(6, product.getBrand());
            ps.setInt(7, product.getStockQuantity());
            ps.setString(8, product.getProductCode());
            ps.setInt(9, product.getCategoryId());

            int rows = ps.executeUpdate();
            success = rows > 0;

        } catch (Exception e) {
            System.err.println("Error in create(): " + e.getMessage());
            e.printStackTrace();
        }
        return success;
    }

    /**
     * Update existing product
     *
     * @param product ProductDTO object with updated information
     * @return true if successful, false otherwise
     */
    public boolean update(ProductDTO product) {
        boolean success = false;
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_PRODUCT)) {

            ps.setString(1, product.getName());
            ps.setString(2, product.getImage());
            ps.setString(3, product.getDescription());
            ps.setDouble(4, product.getPrice());
            ps.setString(5, product.getBrand());
            ps.setInt(6, product.getStockQuantity());
            ps.setString(7, product.getProductCode());
            ps.setInt(8, product.getCategoryId());
            ps.setString(9, product.getId());

            int rows = ps.executeUpdate();
            success = rows > 0;

        } catch (Exception e) {
            System.err.println("Error in update(): " + e.getMessage());
            e.printStackTrace();
        }
        return success;
    }

    /**
     * Delete product by ID
     *
     * @param id Product ID to delete
     * @return true if successful, false otherwise
     */
    public boolean delete(String id) {
        boolean success = false;
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_PRODUCT)) {

            ps.setString(1, id);
            int rows = ps.executeUpdate();
            success = rows > 0;

        } catch (Exception e) {
            System.err.println("Error in delete(): " + e.getMessage());
            e.printStackTrace();
        }
        return success;
    }

    /**
     * Close database resources safely
     *
     * @param conn Connection to close
     * @param ps PreparedStatement to close
     * @param rs ResultSet to close
     */
    public boolean isProductExists(String id) {
        return getProductByID(id) != null;
    }
    
    
    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null)
                rs.close();
            if (ps != null)
                ps.close();
            if (conn != null)
                conn.close();
        } catch (Exception e) {
            System.err.println("Error closing resources: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

