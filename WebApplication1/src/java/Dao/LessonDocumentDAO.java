package Dao;

import Entity.LessonDocument;
import java.sql.*;
import java.util.*;
import Context.DBContext;

public class LessonDocumentDAO {

    // ===== Get all documents by lesson =====
    public List<LessonDocument> getDocumentsByLesson(int lessonId) {
        List<LessonDocument> list = new ArrayList<>();
        String sql = "SELECT * FROM LessonDocuments WHERE LessonID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, lessonId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                LessonDocument d = new LessonDocument();
                d.setDocumentID(rs.getInt("DocumentID"));
                d.setLessonID(rs.getInt("LessonID"));
                d.setDocumentTitle(rs.getString("DocumentTitle"));
                d.setFileName(rs.getString("FileName"));
                d.setFilePath(rs.getString("FilePath"));
                d.setFileSizeMB(rs.getDouble("FileSizeMB"));
                d.setFileType(rs.getString("FileType"));
                d.setUploadedAt(rs.getTimestamp("UploadedAt"));
                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===== Add Document =====
    public void addDocument(int lessonId, String filePath, String fileName) {
        String sql = "INSERT INTO LessonDocuments (LessonID, FileName, FilePath, UploadedAt) " +
                     "VALUES (?, ?, ?, GETDATE())";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, lessonId);
            ps.setString(2, fileName);
            ps.setString(3, filePath);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===== Delete Document =====
    public boolean deleteDocument(int documentId) {
        String sql = "DELETE FROM LessonDocuments WHERE DocumentID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, documentId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
