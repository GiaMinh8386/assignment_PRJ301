/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.*;
import java.util.*;
import utils.DbUtils;

public class CategoryDAO {

    private static final String GET_ALL
            = "SELECT categoryID, categoryName, description "
            + "FROM tblCategories ORDER BY categoryName";

    public List<CategoryDTO> getAll() throws SQLException, ClassNotFoundException {
        List<CategoryDTO> list = new ArrayList<>();
        try ( Connection con = DbUtils.getConnection();  PreparedStatement ps = con.prepareStatement(GET_ALL);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new CategoryDTO(
                        rs.getInt("categoryID"),
                        rs.getString("categoryName"),
                        rs.getString("description")));
            }
        }
        return list;
    }

    public CategoryDTO getById(int id) throws SQLException, ClassNotFoundException {
        String sql = "SELECT categoryID, categoryName, description "
                + "FROM tblCategories WHERE categoryID=?";
        try ( Connection con = DbUtils.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try ( ResultSet rs = ps.executeQuery()) {
                return rs.next()
                        ? new CategoryDTO(rs.getInt(1), rs.getString(2), rs.getString(3))
                        : null;
            }
        }
    }
}
