package Entity;
import java.time.LocalDateTime;
import java.util.List;

public class Question {
    private int questionID;
    private String questionText;
    private String questionType;       // MCQ, TrueFalse, FillBlank
    private String difficultyLevel;    // Easy, Medium, Hard
    private String category;           // SQL, Java, Math
    private String status;             // Draft, Pending, Approved, Rejected
    private LocalDateTime createdAt;
    private int createdBy;
    private Integer updatedBy;
    private LocalDateTime updatedAt;
    private List<AnswerOption> options;

    public List<AnswerOption> getOptions() {
        return options;
    }

    public void setOptions(List<AnswerOption> options) {
        this.options = options;
    }
    // Mới thêm để hiển thị review
    private Integer reviewedBy;       // ai review
    private LocalDateTime reviewedAt; // khi nào review
    private String rejectionReason;   // lý do bị từ chối

    // Getter và Setter
    public int getQuestionID() { return questionID; }
    public void setQuestionID(int questionID) { this.questionID = questionID; }

    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }

    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }

    public String getDifficultyLevel() { return difficultyLevel; }
    public void setDifficultyLevel(String difficultyLevel) { this.difficultyLevel = difficultyLevel; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

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
    @Override
public boolean equals(Object obj) {
    if (this == obj) return true;
    if (obj == null || getClass() != obj.getClass()) return false;
    Question other = (Question) obj;
    return this.questionID == other.questionID;
}

@Override
public int hashCode() {
    return Integer.hashCode(questionID);
}
}