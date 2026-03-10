package Entity;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

public class Question {
    private int questionID;
    private String questionText;
    private String questionType;
    private String difficultyLevel;
    private String status;
    private LocalDateTime createdAt;
    private int createdBy;
    private Integer updatedBy;
    private LocalDateTime updatedAt;
    private Integer reviewedBy;
    private LocalDateTime reviewedAt;
    private String rejectionReason;
private String createdByName;

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }
    private int categoryID;
    private String categoryName;

    private Integer moduleID;
    private Integer lessonID;

    private List<AnswerOption> options;

    public Question() {}

    public Question(int questionID, String questionText, String questionType, String difficultyLevel,
                    String status, int categoryID, String categoryName,
                    Integer moduleID, Integer lessonID) {
        this.questionID = questionID;
        this.questionText = questionText;
        this.questionType = questionType;
        this.difficultyLevel = difficultyLevel;
        this.status = status;
        this.categoryID = categoryID;
        this.categoryName = categoryName;
        this.moduleID = moduleID;
        this.lessonID = lessonID;
    }

    public int getQuestionID() { return questionID; }
    public void setQuestionID(int questionID) { this.questionID = questionID; }

    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }

    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }

    public String getDifficultyLevel() { return difficultyLevel; }
    public void setDifficultyLevel(String difficultyLevel) { this.difficultyLevel = difficultyLevel; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public Integer getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(Integer updatedBy) { this.updatedBy = updatedBy; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public Integer getReviewedBy() { return reviewedBy; }
    public void setReviewedBy(Integer reviewedBy) { this.reviewedBy = reviewedBy; }

    public LocalDateTime getReviewedAt() { return reviewedAt; }
    public void setReviewedAt(LocalDateTime reviewedAt) { this.reviewedAt = reviewedAt; }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    public int getCategoryID() { return categoryID; }
    public void setCategoryID(int categoryID) { this.categoryID = categoryID; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public Integer getModuleID() { return moduleID; }
    public void setModuleID(Integer moduleID) { this.moduleID = moduleID; }

    public Integer getLessonID() { return lessonID; }
    public void setLessonID(Integer lessonID) { this.lessonID = lessonID; }

    public List<AnswerOption> getOptions() { return options; }
    public void setOptions(List<AnswerOption> options) { this.options = options; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Question)) return false;
        Question q = (Question) o;
        return questionID == q.questionID;
    }

    @Override
    public int hashCode() {
        return Objects.hash(questionID);
    }

    @Override
    public String toString() {
        return "Question{" +
                "questionID=" + questionID +
                ", questionText='" + questionText + '\'' +
                ", difficultyLevel='" + difficultyLevel + '\'' +
                ", category='" + categoryName + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
