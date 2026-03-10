/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dao;

import Context.DBContext;
import Entity.Lesson;
import Entity.Role;
import Entity.User;
import Entity.Module;
import java.sql.Timestamp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ASUS
 */
public class OtpDAO {

    /**
     * Lưu mã OTP vào database cho admin
     */
    public void saveAdminOtp(String email, String otp, LocalDateTime expiryTime) {
        String sql = "INSERT INTO dbo.AdminOTP (Email, OtpCode, ExpiryTime, IsUsed) VALUES (?, ?, ?, 0)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, otp);
            ps.setTimestamp(3, Timestamp.valueOf(expiryTime));
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Xác thực mã OTP từ database
     *
     * @return true nếu OTP hợp lệ, ngược lại false
     */
    public boolean verifyAdminOtp(String email, String otp) {
        // GETDATE() sẽ lấy thời gian hiện tại của SQL Server
        String sql = "SELECT OtpID FROM dbo.AdminOTP WHERE Email = ? AND OtpCode = ? AND ExpiryTime > GETDATE() AND IsUsed = 0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, otp);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // Nếu tìm thấy, đánh dấu OTP đã được sử dụng và trả về true
                int otpId = rs.getInt("OtpID");
                updateOtpAsUsed(otpId);
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Helper: Đánh dấu OTP đã được sử dụng
     */
    private void updateOtpAsUsed(int otpId) {
        String sql = "UPDATE dbo.AdminOTP SET IsUsed = 1 WHERE OtpID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, otpId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Module> getModulesByCourseID(int courseID) throws Exception {
        List<Module> modules = new ArrayList<>();
        String sql = "SELECT * FROM Modules WHERE CourseID = ? ORDER BY OrderIndex";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseID);
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
        }
        return modules;
    }

    public Module getModuleWithLessons(int moduleID) throws Exception {
        Module module = null;
        String sql = "SELECT * FROM Modules WHERE ModuleID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, moduleID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                module = new Module();
                module.setId(rs.getInt("ModuleID"));
                module.setCourseId(rs.getInt("CourseID"));
                module.setTitle(rs.getString("Title"));
                module.setDescription(rs.getString("Description"));
                module.setOrderIndex(rs.getInt("OrderIndex"));
            }
        }
        if (module != null) {
            module.setLessons(getLessonsByModule(moduleID));
        }
        return module;
    }

    private List<Lesson> getLessonsByModule(int moduleID) throws Exception {
        List<Lesson> lessons = new ArrayList<>();
        String sql = "SELECT * FROM Lessons WHERE ModuleID = ? ORDER BY OrderIndex";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, moduleID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Lesson l = new Lesson();
                l.setLessonID(rs.getInt("LessonID"));
                l.setModuleID(rs.getInt("ModuleID"));
                l.setTitle(rs.getString("Title"));
                l.setContent(rs.getString("Content"));
                l.setOrderIndex(rs.getInt("OrderIndex"));
                l.setLessonType(rs.getString("LessonType"));
                l.setVideoUrl(rs.getString("VideoUrl"));
                lessons.add(l);
            }
        }
        return lessons;
    }
}
