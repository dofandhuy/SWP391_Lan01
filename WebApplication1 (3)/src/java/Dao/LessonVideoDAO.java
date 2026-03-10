package Dao;

import Context.DBContext;
import Entity.LessonVideo;
import java.sql.*;
import java.util.*;

public class LessonVideoDAO {

    public boolean insert(LessonVideo video) {
        String sql = "INSERT INTO LessonVideos (LessonID, VideoTitle, FileName, FilePath, VideoUrl, VideoType, UploadedAt) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, video.getLessonID());
            ps.setString(2, video.getVideoTitle());
            ps.setString(3, video.getFileName());
            ps.setString(4, video.getFilePath());
            ps.setString(5, video.getVideoUrl());
            ps.setString(6, video.getVideoType());
            ps.setTimestamp(7, new Timestamp(video.getUploadedAt().getTime()));
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int videoId) {
        String sql = "DELETE FROM LessonVideos WHERE VideoID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, videoId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<LessonVideo> getByLessonId(int lessonId) {
        List<LessonVideo> list = new ArrayList<>();
        String sql = "SELECT * FROM LessonVideos WHERE LessonID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
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
                v.setUploadedAt(rs.getTimestamp("UploadedAt"));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
