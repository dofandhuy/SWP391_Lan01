package Dao;

import Context.DBContext;
import Entity.Lesson;
import Entity.LessonDocument;
import Entity.LessonVideo;
import Entity.Quiz;
import java.sql.*;
import java.util.*;

public class LessonDAO {

    // ================= GET LESSONS BY MODULE =================
    public List<Lesson> getLessonsByModuleId(int moduleId) throws Exception {
        List<Lesson> list = new ArrayList<>();
        String sql = "SELECT LessonID, ModuleID, Title, LessonType, OrderIndex, Content FROM Lessons WHERE ModuleID=? ORDER BY OrderIndex";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Lesson l = new Lesson();
                l.setLessonID(rs.getInt("LessonID"));
                l.setModuleID(rs.getInt("ModuleID"));
                l.setTitle(rs.getString("Title"));
                l.setLessonType(rs.getString("LessonType"));
                l.setOrderIndex(rs.getInt("OrderIndex"));
                l.setContent(rs.getString("Content"));
                list.add(l);
            }
        }
        return list;
    }

    // ================= DELETE LESSON =================
    public boolean deleteLesson(int lessonId) throws Exception {
        String sql = "DELETE FROM Lessons WHERE LessonID=?";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, lessonId);
            return ps.executeUpdate() > 0;
        }
    }

    // ================= GET LESSON BY ID =================
    public Lesson getLessonById(int id) {
        Lesson l = null;
        String sql = "SELECT * FROM Lessons WHERE LessonID=?";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                l = new Lesson();
                l.setLessonID(rs.getInt("LessonID"));
                l.setModuleID(rs.getInt("ModuleID"));
                l.setTitle(rs.getString("Title"));
                l.setContent(rs.getString("Content"));
                l.setLessonType(rs.getString("LessonType"));
                l.setOrderIndex(rs.getInt("OrderIndex"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return l;
    }

    // ================= MOVE UP / DOWN =================
    public boolean moveLessonUp(int lessonId, int moduleId) throws Exception {
        Lesson cur = getLessonById(lessonId);
        if (cur == null) {
            return false;
        }

        String sql = "SELECT TOP 1 LessonID, OrderIndex FROM Lessons WHERE ModuleID=? AND OrderIndex < ? ORDER BY OrderIndex DESC";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            ps.setInt(2, cur.getOrderIndex());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return swapLessonOrders(cur.getLessonID(), cur.getOrderIndex(), rs.getInt("LessonID"), rs.getInt("OrderIndex"));
            }
        }
        return false;
    }

    public boolean moveLessonDown(int lessonId, int moduleId) throws Exception {
        Lesson cur = getLessonById(lessonId);
        if (cur == null) {
            return false;
        }

        String sql = "SELECT TOP 1 LessonID, OrderIndex FROM Lessons WHERE ModuleID=? AND OrderIndex > ? ORDER BY OrderIndex ASC";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            ps.setInt(2, cur.getOrderIndex());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return swapLessonOrders(cur.getLessonID(), cur.getOrderIndex(), rs.getInt("LessonID"), rs.getInt("OrderIndex"));
            }
        }
        return false;
    }

    private boolean swapLessonOrders(int idA, int orderA, int idB, int orderB) throws Exception {
        String sql1 = "UPDATE Lessons SET OrderIndex = ? WHERE LessonID = ?";
        try (Connection con = DBContext.getConnection()) {
            con.setAutoCommit(false);

            try (PreparedStatement ps1 = con.prepareStatement(sql1); PreparedStatement ps2 = con.prepareStatement(sql1); PreparedStatement ps3 = con.prepareStatement(sql1)) {

                // Bước 1: Gán tạm -999 để tránh trùng key
                ps1.setInt(1, -999);
                ps1.setInt(2, idA);
                ps1.executeUpdate();

                // Bước 2: Gán orderA cho bài B
                ps2.setInt(1, orderA);
                ps2.setInt(2, idB);
                ps2.executeUpdate();

                // Bước 3: Gán orderB cho bài A
                ps3.setInt(1, orderB);
                ps3.setInt(2, idA);
                ps3.executeUpdate();

                con.commit();
                return true;
            } catch (Exception e) {
                con.rollback();
                e.printStackTrace();
                return false;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    // ================= INSERT NEW LESSON =================
    public void insertLesson(Lesson lesson) throws Exception {
        String sql = "INSERT INTO Lessons (ModuleID, Title, Content, LessonType, OrderIndex) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int nextIndex = getNextOrderIndex(lesson.getModuleID());
            ps.setInt(1, lesson.getModuleID());
            ps.setString(2, lesson.getTitle());
            ps.setString(3, lesson.getContent());
            ps.setString(4, lesson.getLessonType());
            ps.setInt(5, nextIndex);

            ps.executeUpdate();
        }
    }

    // ================= UPDATE LESSON =================
    public void updateLesson(Lesson l) {
        String sql = "UPDATE Lessons SET Title=?, Content=?, LessonType=? WHERE LessonID=?";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, l.getTitle());
            ps.setString(2, l.getContent());
            ps.setString(3, l.getLessonType());
            ps.setInt(4, l.getLessonID());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= GET NEXT ORDER INDEX =================
    public int getNextOrderIndex(int moduleId) throws Exception {
        String sql = "SELECT ISNULL(MAX(OrderIndex), 0) + 1 AS NextIndex FROM Lessons WHERE ModuleID = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("NextIndex");
            }
        }
        return 1;
    }

    // ================= GET LESSON VIDEOS =================
    public List<LessonVideo> getLessonVideos(int lessonId) {
        List<LessonVideo> list = new ArrayList<>();
        String sql = "SELECT * FROM LessonVideos WHERE LessonID = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lessonId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                LessonVideo v = new LessonVideo();
                v.setVideoID(rs.getInt("VideoID"));
                v.setLessonID(rs.getInt("LessonID"));
                v.setVideoTitle(rs.getString("VideoTitle"));
                v.setFileName(rs.getString("FileName"));
                v.setFilePath(rs.getString("FilePath"));
                v.setVideoUrl(rs.getString("VideoUrl"));
                v.setVideoType(rs.getString("VideoType"));
                v.setFileSizeMB(rs.getDouble("FileSizeMB"));
                v.setVideoFormat(rs.getString("VideoFormat"));
                v.setUploadedAt(rs.getTimestamp("UploadedAt"));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================= GET LESSON DOCUMENTS =================
    public List<LessonDocument> getLessonDocuments(int lessonId) {
        List<LessonDocument> list = new ArrayList<>();
        String sql = "SELECT * FROM LessonDocuments WHERE LessonID = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lessonId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                LessonDocument d = new LessonDocument();
                d.setDocumentID(rs.getInt("DocumentID"));
                d.setLessonID(rs.getInt("LessonID"));
                d.setFileName(rs.getString("FileName"));
                d.setFilePath(rs.getString("FilePath"));
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Quiz getLessonQuiz(int lessonId) {
        String sql = """
        SELECT q.QuizID, q.Title, q.NumQuestions, q.DurationMinutes
        FROM Lessons l
        LEFT JOIN Quizzes q ON l.QuizID = q.QuizID
        WHERE l.LessonID = ?
    """;
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lessonId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Quiz q = new Quiz();
                q.setQuizID(rs.getInt("QuizID"));
                q.setTitle(rs.getString("Title"));
                q.setNumQuestions(rs.getInt("NumQuestions"));
                q.setDurationMinutes(rs.getInt("DurationMinutes"));
                q.setPassingScore(rs.getDouble("PassingScore"));
                q.setStatus(rs.getString("Status"));
                q.setRejectionReason(rs.getString("RejectionReason"));
                q.setCreatedByName(rs.getString("CreatedByName"));
                q.setCategoryName(rs.getString("CategoryName"));
                return q;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateQuizAssignment(int lessonId, int quizId) {
        String sql = "UPDATE Lessons SET QuizID = ? WHERE LessonID = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quizId);
            ps.setInt(2, lessonId);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeQuizAssignment(int lessonId) {
        String sql = "UPDATE Lessons SET QuizID = NULL WHERE LessonID = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, lessonId);
            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
