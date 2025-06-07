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
                return true; // Nếu đúng mật khẩu, đăng nhập thành công
            }
        } catch (Exception e) {
            e.printStackTrace(); // Ghi log lỗi (tùy bạn có thể xóa dòng này)
        }
        return false;
    }
    
     public UserDTO getUserById(String userID) {
        try {
            String sql = "SELECT * FROM tblUsers "
                    + " WHERE userID=?";
            // B1 - Ket noi
            Connection conn = DbUtils.getConnection();
            //
            // B2 - Tao cong cu thuc thi cau lenh
            PreparedStatement pr = conn.prepareStatement(sql);
            pr.setString(1, userID);
            ResultSet rs = pr.executeQuery();
            
            if (rs.next()) {
                int customerID = rs.getInt("CustomerID");
                String fullName = rs.getString("FullName");
                String email = rs.getString("Email");
                String phone = rs.getString("Phone");
                String address = rs.getString("Address");
                String uname = rs.getString("Username");
                String pwd = rs.getString("Password");
                String roleID = rs.getString("RoleID");
                Timestamp ts = rs.getTimestamp("CreatedDate");
                LocalDateTime createdDate = ts != null ? ts.toLocalDateTime() : null;
                
                return new UserDTO(userID, fullName, email, phone, address, uname, pwd, roleID, createdDate);
            }

        } catch (Exception e) {
            e.printStackTrace(); // Ghi log lỗi
        }
        return null;
    }
}
     