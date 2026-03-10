package Entity;

import java.util.Date;

public class LessonDocument {
    private int documentID;
    private int lessonID;
    private String documentTitle;
    private String fileName;
    private String filePath;
    private Double fileSizeMB;
    private String fileType;
    private Date uploadedAt;

    // ===== Constructors =====
    public LessonDocument() {}

    public LessonDocument(int documentID, int lessonID, String documentTitle,
                          String fileName, String filePath, Double fileSizeMB,
                          String fileType, Date uploadedAt) {
        this.documentID = documentID;
        this.lessonID = lessonID;
        this.documentTitle = documentTitle;
        this.fileName = fileName;
        this.filePath = filePath;
        this.fileSizeMB = fileSizeMB;
        this.fileType = fileType;
        this.uploadedAt = uploadedAt;
    }

    // ===== Getters & Setters =====
    public int getDocumentID() { return documentID; }
    public void setDocumentID(int documentID) { this.documentID = documentID; }

    public int getLessonID() { return lessonID; }
    public void setLessonID(int lessonID) { this.lessonID = lessonID; }

    public String getDocumentTitle() { return documentTitle; }
    public void setDocumentTitle(String documentTitle) { this.documentTitle = documentTitle; }

    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }

    public Double getFileSizeMB() { return fileSizeMB; }
    public void setFileSizeMB(Double fileSizeMB) { this.fileSizeMB = fileSizeMB; }

    public String getFileType() { return fileType; }
    public void setFileType(String fileType) { this.fileType = fileType; }

    public Date getUploadedAt() { return uploadedAt; }
    public void setUploadedAt(Date uploadedAt) { this.uploadedAt = uploadedAt; }
}
