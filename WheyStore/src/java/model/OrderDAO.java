package model;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

public class OrderDAO {

    /* =============== SQL CONSTANTS =============== */
    private static final String INSERT_ORDER
            = "INSERT INTO tblOrders (userID, totalAmount, status) VALUES (?, ?, ?)";

    private static final String INSERT_ORDER_DETAIL
            = "INSERT INTO tblOrderDetails (orderID, productID, quantity, unitPrice) VALUES (?, ?, ?, ?)";

    private static final String GET_ORDERS_BY_USER
            = "SELECT orderID, userID, orderDate, totalAmount, status FROM tblOrders WHERE userID = ? ORDER BY orderDate DESC";

    private static final String GET_ALL_ORDERS
            = "SELECT orderID, userID, orderDate, totalAmount, status FROM tblOrders ORDER BY orderDate DESC";

    private static final String GET_ORDER_DETAILS
            = "SELECT od.orderDetailID, od.orderID, od.productID, od.quantity, od.unitPrice, "
            + "p.productName, p.imageURL "
            + "FROM tblOrderDetails od "
            + "JOIN tblProducts p ON od.productID = p.productID "
            + "WHERE od.orderID = ?";

    private static final String UPDATE_STATUS
            = "UPDATE tblOrders SET status = ? WHERE orderID = ?";

    private static final String GET_ORDER_BY_ID
            = "SELECT * FROM tblOrders WHERE orderID = ?";

    /* =============== 1. CREATE ORDER (transaction) =============== */
    /**
     * Tạo đơn hàng kèm danh sách chi tiết. Trả về ID đơn hàng vừa tạo.
     */
    public int createOrder(OrderDTO order, List<OrderDetailDTO> items) throws Exception {
        int generatedOrderId = -1;
        Connection con = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;
        ResultSet rsKeys = null;

        try {
            con = DbUtils.getConnection();
            con.setAutoCommit(false);                             // B1: bắt đầu transaction

            // B2: Insert vào tblOrders
            psOrder = con.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS);
            psOrder.setString(1, order.getUserID());
            psOrder.setBigDecimal(2, order.getTotalAmount());
            psOrder.setString(3, order.getStatus());
            psOrder.executeUpdate();

            rsKeys = psOrder.getGeneratedKeys();
            if (rsKeys.next()) {
                generatedOrderId = rsKeys.getInt(1);
            } else {
                throw new SQLException("Cannot obtain generated Order ID.");
            }

            // B3: Insert từng OrderDetail
            psDetail = con.prepareStatement(INSERT_ORDER_DETAIL);
            for (OrderDetailDTO d : items) {
                psDetail.setInt(1, generatedOrderId);
                psDetail.setString(2, d.getProductID());
                psDetail.setInt(3, d.getQuantity());
                psDetail.setBigDecimal(4, d.getUnitPrice());
                psDetail.addBatch();
            }
            psDetail.executeBatch();

            con.commit();                                         // B4: commit nếu OK
        } catch (Exception e) {
            if (con != null) {
                con.rollback();                      // Rollback nếu lỗi
            }
            throw e;
        } finally {
            if (rsKeys != null) {
                rsKeys.close();
            }
            if (psDetail != null) {
                psDetail.close();
            }
            if (psOrder != null) {
                psOrder.close();
            }
            if (con != null) {
                con.setAutoCommit(true);
            }
            if (con != null) {
                con.close();
            }
        }
        return generatedOrderId;
    }

    /* =============== 2. LẤY ĐƠN THEO USER =============== */
    public List<OrderDTO> getOrdersByUser(String userID) throws Exception {
        List<OrderDTO> list = new ArrayList<>();
        try ( Connection con = DbUtils.getConnection();  PreparedStatement ps = con.prepareStatement(GET_ORDERS_BY_USER)) {

            ps.setString(1, userID);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new OrderDTO(
                            rs.getInt("orderID"),
                            rs.getString("userID"),
                            rs.getTimestamp("orderDate"),
                            rs.getBigDecimal("totalAmount"),
                            rs.getString("status")
                    ));
                }
            }
        }
        return list;
    }

    /* =============== 3. LẤY TOÀN BỘ ĐƠN (ADMIN) =============== */
    public List<OrderDTO> getAllOrders() throws Exception {
        List<OrderDTO> list = new ArrayList<>();
        try ( Connection con = DbUtils.getConnection();  PreparedStatement ps = con.prepareStatement(GET_ALL_ORDERS);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new OrderDTO(
                        rs.getInt("orderID"),
                        rs.getString("userID"),
                        rs.getTimestamp("orderDate"),
                        rs.getBigDecimal("totalAmount"),
                        rs.getString("status")
                ));
            }
        }
        return list;
    }

    /* =============== 4. LẤY CHI TIẾT 1 ĐƠN =============== */
    public List<OrderDetailDTO> getOrderDetails(int orderID) throws Exception {
        List<OrderDetailDTO> list = new ArrayList<>();
        try ( Connection con = DbUtils.getConnection();  PreparedStatement ps = con.prepareStatement(GET_ORDER_DETAILS)) {

            ps.setInt(1, orderID);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetailDTO detail = new OrderDetailDTO(
                            rs.getInt("orderDetailID"),
                            rs.getInt("orderID"),
                            rs.getString("productID"),
                            rs.getString("productName"),
                            rs.getString("imageURL"),
                            rs.getInt("quantity"),
                            rs.getBigDecimal("unitPrice")
                    );

                    // Bạn có thể set thêm productName vào DTO riêng nếu cần
                    list.add(detail);
                }
            }
        }
        return list;
    }

    /* =============== 5. CẬP NHẬT TRẠNG THÁI =============== */
    public boolean updateStatus(int orderID, String newStatus) throws Exception {
        try ( Connection con = DbUtils.getConnection();  PreparedStatement ps = con.prepareStatement(UPDATE_STATUS)) {

            ps.setString(1, newStatus);
            ps.setInt(2, orderID);
            return ps.executeUpdate() > 0;
        }
    }

    /* =============== 6. LAY DON HANG BANG ID =============== */
    public OrderDTO getOrderById(int orderID) throws Exception {
        try ( Connection con = DbUtils.getConnection();  PreparedStatement ps = con.prepareStatement(GET_ORDER_BY_ID)) {
            ps.setInt(1, orderID);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new OrderDTO(
                            rs.getInt("orderID"),
                            rs.getString("userID"),
                            rs.getTimestamp("orderDate"),
                            rs.getBigDecimal("totalAmount"),
                            rs.getString("status"));
                }
            }
        }
        return null;
    }

}
