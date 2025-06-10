/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package model;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;


public class UserDAO {

    public UserDAO() {
    }

    public boolean login(String userID, String password) {
    try {
        UserDTO user = getUserById(userID); 
        if (user != null && user.getPassword().equals(password)) {
            return true;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}

public UserDTO getUserById(String userID) {
    String sqlAdmin = "SELECT Username, Password, RoleID FROM Admins WHERE Username = ?";
    String sqlCustomer = "SELECT * FROM Customers WHERE Username = ?";

    try (Connection conn = DbUtils.getConnection()) {
        // Ưu tiên kiểm tra Admins trước
        try (PreparedStatement pr = conn.prepareStatement(sqlAdmin)) {
            pr.setString(1, userID);
            try (ResultSet rs = pr.executeQuery()) {
                if (rs.next()) {
                    String pwd = rs.getString("Password");
                    String roleID = rs.getString("RoleID");

                    return new UserDTO(null, "Admin", "", "", "", userID, pwd, roleID, null);
                }
            }
        }

        // Sau đó kiểm tra Customers
        try (PreparedStatement pr = conn.prepareStatement(sqlCustomer)) {
            pr.setString(1, userID);
            try (ResultSet rs = pr.executeQuery()) {
                if (rs.next()) {
                    int customerID = rs.getInt("CustomerID");
                    String fullName = rs.getString("FullName");
                    String email = rs.getString("Email");
                    String phone = rs.getString("Phone");
                    String address = rs.getString("Address");
                    String pwd = rs.getString("Password");
                    String roleID = rs.getString("RoleID");
                    Timestamp ts = rs.getTimestamp("CreatedDate");
                    LocalDateTime createdDate = ts != null ? ts.toLocalDateTime() : null;

                    return new UserDTO(String.valueOf(customerID), fullName, email, phone, address,
                            userID, pwd, roleID, createdDate);
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return null;
}

}

     