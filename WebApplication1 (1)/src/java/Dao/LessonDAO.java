package Dao;

import Context.DBContext;
import Entity.Lesson;
import java.sql.*;
import java.util.*;

public class LessonDAO {

    public List<Lesson> getLessonsByModuleId(int moduleId) throws Exception {
        List<Lesson> list = new ArrayList<>();
        String sql = "SELECT LessonID, ModuleID, Title, LessonType, OrderIndex, VideoUrl FROM Lessons WHERE ModuleID=? ORDER BY OrderIndex";
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
                l.setVideoUrl(rs.getString("VideoUrl"));
                list.add(l);
            }
        }
        return list;
    }

    public boolean deleteLesson(int lessonId) throws Exception {
        String sql = "DELETE FROM Lessons WHERE LessonID=?";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, lessonId);
            return ps.executeUpdate() > 0;
        }
    }

    public Lesson getLessonById(int id) {
    Lesson l = null;
    try { Connection con = DBContext.getConnection();
        String sql = "SELECT * FROM Lessons WHERE lessonID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            l = new Lesson();
            l.setLessonID(rs.getInt("lessonID"));
            l.setModuleID(rs.getInt("moduleID"));
            l.setTitle(rs.getString("title"));
            l.setContent(rs.getString("content"));
            l.setLessonType(rs.getString("lessonType"));
            l.setVideoUrl(rs.getString("videoUrl"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return l;
}

    // ================= MOVE UP / DOWN =================
    public boolean moveLessonUp(int lessonId, int moduleId) throws Exception {
        Lesson cur = getLessonById(lessonId);
        if (cur == null) return false;

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
        if (cur == null) return false;

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
        String sql = "UPDATE Lessons SET OrderIndex = ? WHERE LessonID = ?";
        try (Connection con = DBContext.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, -999);
                ps.setInt(2, idA);
                ps.executeUpdate();

                ps.setInt(1, orderA);
                ps.setInt(2, idB);
                ps.executeUpdate();

                ps.setInt(1, orderB);
                ps.setInt(2, idA);
                ps.executeUpdate();

                con.commit();
                return true;
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    // ================= INSERT NEW LESSON =================
    public void insertLesson(Lesson lesson) throws Exception {
        String sql = "INSERT INTO Lessons (ModuleID, Title, Content, LessonType, VideoUrl, OrderIndex) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int nextIndex = getNextOrderIndex(lesson.getModuleID());
            ps.setInt(1, lesson.getModuleID());
            ps.setString(2, lesson.getTitle());
            ps.setString(3, lesson.getContent());
            ps.setString(4, lesson.getLessonType());
            ps.setString(5, lesson.getVideoUrl());
            ps.setInt(6, nextIndex);

            ps.executeUpdate();
        }
    }
    public void updateLesson(Lesson l) {
    try {Connection con = DBContext.getConnection();
        String sql = "UPDATE Lessons SET title=?, content=?, lessonType=?, videoUrl=? WHERE lessonID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, l.getTitle());
        ps.setString(2, l.getContent());
        ps.setString(3, l.getLessonType());
        ps.setString(4, l.getVideoUrl());
        ps.setInt(5, l.getLessonID());
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

    public int getNextOrderIndex(int moduleId) throws Exception {
        String sql = "SELECT ISNULL(MAX(OrderIndex), 0) + 1 AS NextIndex FROM Lessons WHERE ModuleID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("NextIndex");
        }
        return 1;
    }
}
