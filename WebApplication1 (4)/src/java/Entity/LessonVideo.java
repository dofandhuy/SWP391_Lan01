package Entity;

import java.util.Date;

public class LessonVideo {
    private int videoID;
    private int lessonID;
    private String videoTitle;
    private String fileName;
    private String filePath;
    private String videoUrl;
    private String videoType; // Local / External
    private Double fileSizeMB;
    private String videoFormat;
    private Date uploadedAt;

    // ===== Constructors =====
    public LessonVideo() {}

    public LessonVideo(int videoID, int lessonID, String videoTitle, String fileName,
                       String filePath, String videoUrl, String videoType,
                       Double fileSizeMB, String videoFormat, Date uploadedAt) {
        this.videoID = videoID;
        this.lessonID = lessonID;
        this.videoTitle = videoTitle;
        this.fileName = fileName;
        this.filePath = filePath;
        this.videoUrl = videoUrl;
        this.videoType = videoType;
        this.fileSizeMB = fileSizeMB;
        this.videoFormat = videoFormat;
        this.uploadedAt = uploadedAt;
    }

    // ===== Getters & Setters =====
    public int getVideoID() { return videoID; }
    public void setVideoID(int videoID) { this.videoID = videoID; }

    public int getLessonID() { return lessonID; }
    public void setLessonID(int lessonID) { this.lessonID = lessonID; }

    public String getVideoTitle() { return videoTitle; }
    public void setVideoTitle(String videoTitle) { this.videoTitle = videoTitle; }

    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }

    public String getVideoUrl() { return videoUrl; }
    public void setVideoUrl(String videoUrl) { this.videoUrl = videoUrl; }

    public String getVideoType() { return videoType; }
    public void setVideoType(String videoType) { this.videoType = videoType; }

    public Double getFileSizeMB() { return fileSizeMB; }
    public void setFileSizeMB(Double fileSizeMB) { this.fileSizeMB = fileSizeMB; }

    public String getVideoFormat() { return videoFormat; }
    public void setVideoFormat(String videoFormat) { this.videoFormat = videoFormat; }

    public Date getUploadedAt() { return uploadedAt; }
    public void setUploadedAt(Date uploadedAt) { this.uploadedAt = uploadedAt; }
}
