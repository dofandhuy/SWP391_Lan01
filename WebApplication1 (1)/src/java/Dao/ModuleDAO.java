package Dao;

import Context.DBContext;
import Entity.Module;
import java.sql.*;
import java.util.*;

public class ModuleDAO {

    // --- Lấy danh sách module theo CourseID ---
    public List<Module> getModulesByCourseId(int courseId) {
        List<Module> modules = new ArrayList<>();
        String sql = "SELECT ModuleID, CourseID, Title, Description, OrderIndex " +
                     "FROM Modules WHERE CourseID = ? ORDER BY OrderIndex";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Module m = new Module();
                m.setId(rs.getInt("ModuleID"));
                m.setCourseId(rs.getInt("CourseID"));
                m.setTitle(rs.getString("Title"));
                m.setDescription(rs.getString("Description"));
                m.setOrderIndex(rs.getInt("OrderIndex"));
                modules.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return modules;
    }

    // --- Thêm module mới ---
    public boolean addModule(Module module) {
        String sql = "INSERT INTO Modules (CourseID, Title, Description, OrderIndex) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, module.getCourseId());
            ps.setString(2, module.getTitle());
            ps.setString(3, module.getDescription());
            ps.setObject(4, module.getOrderIndex());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // --- Xóa tất cả module theo courseId ---
    public void deleteModulesByCourseId(int courseId) {
        String sql = "DELETE FROM Modules WHERE CourseID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // --- Xóa 1 module ---
    public boolean deleteModule(int moduleId) {
        String sql = "DELETE FROM Modules WHERE ModuleID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public Module getModuleById(int moduleId) {
    String sql = "SELECT * FROM Modules WHERE ModuleID = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, moduleId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            Module m = new Module();
            m.setId(rs.getInt("ModuleID"));
            m.setCourseId(rs.getInt("CourseID"));
            m.setTitle(rs.getString("Title")); // ✅ Đúng cột
            m.setDescription(rs.getString("Description"));
            m.setOrderIndex(rs.getInt("OrderIndex"));
            return m;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
    public boolean updateModule(Module module) {
    String sql = "UPDATE Modules SET Title = ?, Description = ? WHERE ModuleID = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, module.getTitle());
        ps.setString(2, module.getDescription());
        ps.setInt(3, module.getId());

        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

}
