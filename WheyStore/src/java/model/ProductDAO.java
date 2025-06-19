package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

public class ProductDAO {

    private static final String GET_ALL_PRODUCTS
            = "SELECT ProductID, ProductName, Description, Brand, Price, ImageURL, CategoryID, Status FROM tblProducts";
    private static final String GET_PRODUCT_BY_ID = "SELECT ProductID, ProductName, Description, Brand, Price, ImageURL, CategoryID, Status FROM tblProducts WHERE ProductID = ?";
    private static final String CREATE_PRODUCT
            = "INSERT INTO tblProducts (ProductID, ProductName, Description, Brand, Price, ImageURL, CategoryID, Status) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_PRODUCT = "UPDATE tblProducts SET ProductName = ?, Description = ?, Brand = ?, Price = ?, ImageURL = ?, CategoryID = ?, Status = ? WHERE ProductID = ?";
    private static final String DELETE_PRODUCT = "DELETE FROM tblProducts WHERE ProductID = ?";

    public List<ProductDTO> getAllProducts() {
        List<ProductDTO> products = new ArrayList<>();
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(GET_ALL_PRODUCTS);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String id = rs.getString("ProductID");
                String name = rs.getString("ProductName");
                String description = rs.getString("Description");
                String brand = rs.getString("Brand");
                double price = rs.getDouble("Price");
                String image = rs.getString("ImageURL");
                int categoryId = rs.getInt("CategoryID");
                boolean status = rs.getBoolean("Status");

                ProductDTO product = new ProductDTO(id, name, description, brand, price, image, categoryId, status);
                products.add(product);
            }
        } catch (Exception e) {
            System.err.println("Error in getAllProducts(): " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    public ProductDTO getProductByID(String id) {
        ProductDTO product = null;
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(GET_PRODUCT_BY_ID)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                product = new ProductDTO(
                        rs.getString("ProductID"),
                        rs.getString("ProductName"),
                        rs.getString("Description"),
                        rs.getString("Brand"),
                        rs.getDouble("Price"),
                        rs.getString("ImageURL"),
                        rs.getInt("CategoryID"),
                        rs.getBoolean("Status")
                );
            }
        } catch (Exception e) {
            System.err.println("Error in getProductByID(): " + e.getMessage());
            e.printStackTrace();
        }
        return product;
    }

    public boolean create(ProductDTO product) {
        boolean success = false;
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(CREATE_PRODUCT)) {

            ps.setString(1, product.getId());
            ps.setString(2, product.getName());
            ps.setString(3, product.getDescription());
            ps.setString(4, product.getBrand());
            ps.setDouble(5, product.getPrice());
            ps.setString(6, product.getImage());
            ps.setInt(7, product.getCategoryId());
            ps.setBoolean(8, product.isStatus());

            int rows = ps.executeUpdate();
            success = rows > 0;

        } catch (Exception e) {
            System.err.println("Error in create(): " + e.getMessage());
            e.printStackTrace();
        }
        return success;
    }

    public boolean update(ProductDTO product) {
        boolean success = false;
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(UPDATE_PRODUCT)) {

            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setString(3, product.getBrand());
            ps.setDouble(4, product.getPrice());
            ps.setString(5, product.getImage());
            ps.setInt(6, product.getCategoryId());
            ps.setBoolean(7, product.isStatus());
            ps.setString(8, product.getId());

            int rows = ps.executeUpdate();
            success = rows > 0;

        } catch (Exception e) {
            System.err.println("Error in update(): " + e.getMessage());
            e.printStackTrace();
        }
        return success;
    }

    public boolean delete(String id) {
        boolean success = false;
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(DELETE_PRODUCT)) {

            ps.setString(1, id);
            int rows = ps.executeUpdate();
            success = rows > 0;

        } catch (Exception e) {
            System.err.println("Error in delete(): " + e.getMessage());
            e.printStackTrace();
        }
        return success;
    }

    public boolean isProductExists(String id) {
        return getProductByID(id) != null;
    }
<<<<<<< Updated upstream

=======
    public List<ProductDTO> getProductsByPriceRange(double minPrice, double maxPrice) {
    List<ProductDTO> products = new ArrayList<>();
    String sql = "SELECT ProductID, ProductName, Description, Price, ImageURL, Brand, StockQuantity, ProductCode, CategoryID "
               + "FROM Products WHERE Price BETWEEN ? AND ?";
    try (Connection conn = DbUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setDouble(1, minPrice);
        ps.setDouble(2, maxPrice);
        ResultSet rs = ps.executeQuery();
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
        System.err.println("Error in getProductsByPriceRange(): " + e.getMessage());
        e.printStackTrace();
    }
    return products;
}

    
    
>>>>>>> Stashed changes
    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (Exception e) {
            System.err.println("Error closing resources: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public List<ProductDTO> getProductsByName(String name) {
        List<ProductDTO> products = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        //String query = GET_ALL_PRODUCTS + " WHERE name like ?";
        String query = "SELECT * FROM tblProducts WHERE ProductName LIKE ?";
        System.out.println(query);
        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, "%" + name + "%");
            rs = ps.executeQuery();

            while (rs.next()) {
                ProductDTO product = new ProductDTO();
                product.setId(rs.getString("productID"));
                product.setName(rs.getString("ProductName"));
                product.setDescription(rs.getString("Description"));
                product.setBrand(rs.getString("Brand"));
                product.setPrice(rs.getDouble("Price"));
                product.setImage(rs.getString("ImageURL"));
                product.setCategoryId(rs.getInt("CategoryID"));
                product.setStatus(rs.getBoolean("Status"));
                products.add(product);
            }
        } catch (Exception e) {
            System.err.println("Error in getProductsByStatus(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return products;
    }
}
