package Dao;

import Context.DBContext;
import Entity.Module;
import java.sql.*;
import java.util.*;

public class ModuleDAO {

    // --- Lấy danh sách module theo CourseID ---
    public List<Module> getModulesByCourseId(int courseId) {
        List<Module> modules = new ArrayList<>();
        String sql = "SELECT ModuleID, CourseID, Title, Description, OrderIndex "
                + "FROM Modules WHERE CourseID = ? ORDER BY OrderIndex";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, module.getCourseId());
            ps.setString(2, module.getTitle());
            ps.setString(3, module.getDescription());
            ps.setInt(4, module.getOrderIndex());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        module.setId(rs.getInt(1)); // ✅ Gán lại ID cho module
                    }
                }
            }
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- Xóa tất cả module theo courseId ---
    public void deleteModulesByCourseId(int courseId) {
        String sql = "DELETE FROM Modules WHERE CourseID = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // --- Xóa 1 module ---
    public boolean deleteModule(int moduleId) {
        String sql = "DELETE FROM Modules WHERE ModuleID = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Module getModuleById(int moduleId) {
        String sql = "SELECT * FROM Modules WHERE ModuleID = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, module.getTitle());
            ps.setString(2, module.getDescription());
            ps.setInt(3, module.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getCourseId(int moduleId) {
        String sql = "SELECT CourseID FROM Modules WHERE ModuleID = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("CourseID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // nếu không tìm thấy module
    }

    public boolean deleteModuleWithLessons(int moduleId) {
        String getLessonIdsSQL = "SELECT LessonID FROM Lessons WHERE ModuleID = ?";

        String deleteLessonVideosSQL = "DELETE FROM LessonVideos WHERE LessonID = ?";
        String deleteLessonDocumentsSQL = "DELETE FROM LessonDocuments WHERE LessonID = ?";
        String deleteStudentProgressSQL = "DELETE FROM StudentProgress WHERE LessonID = ?";
        String deleteLessonsSQL = "DELETE FROM Lessons WHERE ModuleID = ?";
        String unassignQuizSQL = "UPDATE Quizzes SET ModuleID = NULL WHERE ModuleID = ?";
        String unassignQuestionBankSQL = "UPDATE QuestionBank SET ModuleID = NULL WHERE ModuleID = ?";

        String deleteModuleSQL = "DELETE FROM Modules WHERE ModuleID = ?";

        try (Connection conn = new DBContext().getConnection()) {
            conn.setAutoCommit(false);

            try (
                    PreparedStatement psGetLessons = conn.prepareStatement(getLessonIdsSQL); PreparedStatement psDeleteLessonVideos = conn.prepareStatement(deleteLessonVideosSQL); PreparedStatement psDeleteLessonDocs = conn.prepareStatement(deleteLessonDocumentsSQL); PreparedStatement psDeleteStudentProgress = conn.prepareStatement(deleteStudentProgressSQL); PreparedStatement psDeleteLessons = conn.prepareStatement(deleteLessonsSQL); PreparedStatement psUnassignQuiz = conn.prepareStatement(unassignQuizSQL); PreparedStatement psUnassignQBank = conn.prepareStatement(unassignQuestionBankSQL); PreparedStatement psDeleteModule = conn.prepareStatement(deleteModuleSQL)) {
                psGetLessons.setInt(1, moduleId);
                ResultSet rsLessons = psGetLessons.executeQuery();

                while (rsLessons.next()) {
                    int lessonId = rsLessons.getInt("LessonID");

                    psDeleteLessonVideos.setInt(1, lessonId);
                    psDeleteLessonVideos.executeUpdate();

                    psDeleteLessonDocs.setInt(1, lessonId);
                    psDeleteLessonDocs.executeUpdate();

                    psDeleteStudentProgress.setInt(1, lessonId);
                    psDeleteStudentProgress.executeUpdate();
                }

                psDeleteLessons.setInt(1, moduleId);
                psDeleteLessons.executeUpdate();

                psUnassignQuiz.setInt(1, moduleId);
                psUnassignQuiz.executeUpdate();

                psUnassignQBank.setInt(1, moduleId);
                psUnassignQBank.executeUpdate();

                psDeleteModule.setInt(1, moduleId);
                int affected = psDeleteModule.executeUpdate();

                conn.commit();
                return affected > 0;

            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
