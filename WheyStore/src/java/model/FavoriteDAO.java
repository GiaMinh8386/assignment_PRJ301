/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

public class FavoriteDAO {

    // Thêm (chỉ thêm khi chưa có)
    public void addFavorite(String userID, String productID) throws Exception {
        String sql = "IF NOT EXISTS (SELECT 1 FROM tblFavorites "
                + "WHERE userID = ? AND productID = ?) "
                + "INSERT INTO tblFavorites(userID, productID) VALUES(?, ?)";
        try ( Connection con = DbUtils.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userID);
            ps.setString(2, productID);
            ps.setString(3, userID);
            ps.setString(4, productID);
            ps.executeUpdate();
        }
    }

    // Xoá
    public void removeFavorite(String userID, String productID) throws Exception {
        String sql = "DELETE FROM tblFavorites WHERE userID = ? AND productID = ?";
        try ( Connection con = DbUtils.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userID);
            ps.setString(2, productID);
            ps.executeUpdate();
        }
    }

    // Kiểm tra đã thích chưa
    public boolean isFavorite(String userID, String productID) throws Exception {
        String sql = "SELECT 1 FROM tblFavorites WHERE userID = ? AND productID = ?";
        try ( Connection con = DbUtils.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userID);
            ps.setString(2, productID);
            try ( ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // Lấy danh sách sản phẩm yêu thích của user
    public List<ProductDTO> getFavorites(String userID) throws Exception {
        String sql = "SELECT p.* FROM tblProducts p "
                + "JOIN tblFavorites f ON p.productID = f.productID "
                + "WHERE f.userID = ?";
        List<ProductDTO> list = new ArrayList<>();
        try ( Connection con = DbUtils.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userID);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new ProductDTO(
                            rs.getString("productID"),
                            rs.getString("productName"),
                            rs.getString("description"),
                            rs.getString("brand"),
                            rs.getBigDecimal("price").doubleValue(), // ép BigDecimal → double
                            rs.getString("imageURL"),
                            rs.getInt("categoryID"),
                            rs.getBoolean("status")
                    ));
                }
            }
        }
        return list;
    }

    // Toggle (trả về true nếu vừa thêm, false nếu vừa xoá)
    public boolean toggle(String userID, String productID) throws Exception {
        if (isFavorite(userID, productID)) {
            removeFavorite(userID, productID);
            return false;
        } else {
            addFavorite(userID, productID);
            return true;
        }
    }
}
