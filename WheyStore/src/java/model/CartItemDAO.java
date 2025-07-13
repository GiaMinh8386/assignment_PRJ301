package model;

import java.sql.*;
import java.util.*;
import utils.DbUtils;

public class CartItemDAO {

    /* ====== SQL ====== */
    private static final String INSERT_OR_UPDATE =
        "MERGE tblCartItems AS target " +
        "USING (VALUES (?, ?, ?)) AS src(userID, productID, quantity) " +
        "ON target.userID = src.userID AND target.productID = src.productID " +
        "WHEN MATCHED THEN UPDATE SET quantity = target.quantity + src.quantity " +
        "WHEN NOT MATCHED THEN INSERT(userID, productID, quantity) VALUES(src.userID, src.productID, src.quantity);";

    private static final String UPDATE_QUANTITY =
        "UPDATE tblCartItems SET quantity = ? WHERE userID = ? AND productID = ?";

    private static final String DELETE_ITEM =
        "DELETE FROM tblCartItems WHERE userID = ? AND productID = ?";

    private static final String CLEAR_CART =
        "DELETE FROM tblCartItems WHERE userID = ?";

    private static final String GET_BY_USER =
        "SELECT c.productID, p.productName, c.quantity, p.price " +
        "FROM tblCartItems c JOIN tblProducts p ON c.productID = p.productID " +
        "WHERE c.userID = ?";

    /* ====== API ====== */
    public void addOrUpdate(String userID, String productID, int qty) throws Exception {
        try (Connection con = DbUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT_OR_UPDATE)) {
            ps.setString(1, userID);
            ps.setString(2, productID);
            ps.setInt(3, qty);
            ps.executeUpdate();
        }
    }

    public void updateQuantity(String userID, String productID, int qty) throws Exception {
        try (Connection con = DbUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(UPDATE_QUANTITY)) {
            ps.setInt(1, qty);
            ps.setString(2, userID);
            ps.setString(3, productID);
            ps.executeUpdate();
        }
    }

    public void remove(String userID, String productID) throws Exception {
        try (Connection con = DbUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(DELETE_ITEM)) {
            ps.setString(1, userID);
            ps.setString(2, productID);
            ps.executeUpdate();
        }
    }

    public void clear(String userID) throws Exception {
        try (Connection con = DbUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(CLEAR_CART)) {
            ps.setString(1, userID);
            ps.executeUpdate();
        }
    }

    public List<CartItemDTO> getCart(String userID) throws Exception {
        List<CartItemDTO> list = new ArrayList<>();
        try (Connection con = DbUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_BY_USER)) {
            ps.setString(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new CartItemDTO(
                            rs.getString("productID"),
                            rs.getString("productName"),
                            rs.getString("imageURL"),
                            rs.getBigDecimal("price"),
                            rs.getInt("quantity")));
                }
            }
        }
        return list;
    }
}
