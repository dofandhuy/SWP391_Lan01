package Service;

import Dao.LessonVideoDAO;
import Entity.LessonVideo;
import java.util.Date;
import java.util.List;

public class LessonVideoService {
    private LessonVideoDAO dao = new LessonVideoDAO();

    // Thêm video local (upload)
    public boolean addLocalVideo(int lessonId, String filePath, String fileName) {
        LessonVideo video = new LessonVideo();
        video.setLessonID(lessonId);
        video.setVideoTitle(fileName);
        video.setFileName(fileName);
        video.setFilePath(filePath);
        video.setVideoType("Local");
        video.setUploadedAt(new Date());
        return dao.insert(video);
    }

    // Thêm video external (link)
    public boolean addExternalVideo(int lessonId, String videoUrl) {
        LessonVideo video = new LessonVideo();
        video.setLessonID(lessonId);
        video.setVideoTitle("External Video");
        video.setVideoUrl(videoUrl);
        video.setVideoType("External");
        video.setUploadedAt(new Date());
        return dao.insert(video);
    }

    // Xoá video
    public boolean deleteVideo(int videoId) {
        return dao.delete(videoId);
    }

    // Lấy danh sách video theo lesson
    public List<LessonVideo> getVideosByLessonId(int lessonId) {
        return dao.getByLessonId(lessonId);
    }
}
