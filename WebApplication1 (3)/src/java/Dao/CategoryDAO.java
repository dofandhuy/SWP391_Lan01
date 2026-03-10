package Dao;

import Entity.Category;
import Context.DBContext;
import Context.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    // Lấy danh sách tất cả Category
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT CategoryID, CategoryName FROM Category";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("CategoryID"));
                c.setCategoryName(rs.getString("CategoryName"));
                list.add(c);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy Category theo ID
    public Category getCategoryById(int id) {
        String sql = "SELECT CategoryID, CategoryName FROM Category WHERE CategoryID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category c = new Category();
                    c.setCategoryId(rs.getInt("CategoryID"));
                    c.setCategoryName(rs.getString("CategoryName"));
                    return c;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
