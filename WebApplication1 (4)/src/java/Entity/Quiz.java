//package Entity;
//import java.time.LocalDateTime;
//
//public class Quiz {
//    private int quizID;
//    private Integer moduleID;        // có thể null
//    private Integer categoryID;      // 🔹 Thêm cột này cho phù hợp DB
//    private String categoryName;     // 🔹 Dễ hiển thị khi join
//
//    private String title;
//    private int numQuestions;
//    private boolean isRandom;
//    private Integer durationMinutes; // có thể null
//    private Double passingScore;     // có thể null
//    private String difficultyLevel;  // Easy, Medium, Hard
//    private int createdBy;
//    private LocalDateTime createdAt;
//    private String status;           // Draft, Pending, Approved, Rejected
//    private Integer reviewedBy;      // có thể null
//    private LocalDateTime reviewedAt;// có thể null
//    private String rejectionReason;  // có thể null
//    private String createdByName;
//    private Integer maxAttempts;          // có thể null
//    private Integer attemptCooldownHours; // có thể null
//
//    // Getters & Setters
//    public int getQuizID() { return quizID; }
//    public void setQuizID(int quizID) { this.quizID = quizID; }
//
//    public Integer getModuleID() { return moduleID; }
//    public void setModuleID(Integer lessonID) { this.moduleID = lessonID; }
//
//    public Integer getCategoryID() { return categoryID; }
//    public void setCategoryID(Integer categoryID) { this.categoryID = categoryID; }
//
//    public String getCategoryName() { return categoryName; }
//    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
//
//    public String getTitle() { return title; }
//    public void setTitle(String title) { this.title = title; }
//
//    public int getNumQuestions() { return numQuestions; }
//    public void setNumQuestions(int numQuestions) { this.numQuestions = numQuestions; }
//
//    public boolean isRandom() { return isRandom; }
//    public void setRandom(boolean random) { isRandom = random; }
//
//    public Integer getDurationMinutes() { return durationMinutes; }
//    public void setDurationMinutes(Integer durationMinutes) { this.durationMinutes = durationMinutes; }
//
//    public Double getPassingScore() { return passingScore; }
//    public void setPassingScore(Double passingScore) { this.passingScore = passingScore; }
//
//
//    public String getDifficultyLevel() { return difficultyLevel; }
//    public void setDifficultyLevel(String difficultyLevel) { this.difficultyLevel = difficultyLevel; }
//
//    public int getCreatedBy() { return createdBy; }
//    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }
//
//    public LocalDateTime getCreatedAt() { return createdAt; }
//    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
//
//    public String getStatus() { return status; }
//    public void setStatus(String status) { this.status = status; }
//
//    public Integer getReviewedBy() { return reviewedBy; }
//    public void setReviewedBy(Integer reviewedBy) { this.reviewedBy = reviewedBy; }
//
//    public LocalDateTime getReviewedAt() { return reviewedAt; }
//    public void setReviewedAt(LocalDateTime reviewedAt) { this.reviewedAt = reviewedAt; }
//
//    public String getRejectionReason() { return rejectionReason; }
//    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }
//
//    public String getCreatedByName() { return createdByName; }
//    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }
//
//    public Integer getMaxAttempts() { return maxAttempts; }
//    public void setMaxAttempts(Integer maxAttempts) { this.maxAttempts = maxAttempts; }
//
//    public Integer getAttemptCooldownHours() { return attemptCooldownHours; }
//    public void setAttemptCooldownHours(Integer attemptCooldownHours) { this.attemptCooldownHours = attemptCooldownHours; }
//}

package Entity;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

public class Quiz {
    private int quizID;
    private Integer moduleID;
    private Integer categoryID;
    private String categoryName;
private double pointPerQuestion;

    public double getPointPerQuestion() {
        return pointPerQuestion;
    }

    public void setPointPerQuestion(double pointPerQuestion) {
        this.pointPerQuestion = pointPerQuestion;
    }
    private String title;
    private int numQuestions;
    private boolean isRandom;
    private Integer durationMinutes;
    private Double passingScore;
    private String difficultyLevel;
    private int createdBy;
    private LocalDateTime createdAt;
    private String status;
    private Integer reviewedBy;
    private LocalDateTime reviewedAt;
    private String rejectionReason;
    private String createdByName;
    private Integer maxAttempts;
    private Integer attemptCooldownHours;
private List<Question> questions;

    public List<Question> getQuestions() {
        return questions;
    }

    public void setQuestions(List<Question> questions) {
        this.questions = questions;
    }
    public int getQuizID() { return quizID; }
    public void setQuizID(int quizID) { this.quizID = quizID; }

    public Integer getModuleID() { return moduleID; }
    public void setModuleID(Integer moduleID) { this.moduleID = moduleID; }

    public Integer getCategoryID() { return categoryID; }
    public void setCategoryID(Integer categoryID) { this.categoryID = categoryID; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public int getNumQuestions() { return numQuestions; }
    public void setNumQuestions(int numQuestions) { this.numQuestions = numQuestions; }

    public boolean isRandom() { return isRandom; }
    public void setRandom(boolean random) { isRandom = random; }

    public Integer getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(Integer durationMinutes) { this.durationMinutes = durationMinutes; }

    public Double getPassingScore() { return passingScore; }
    public void setPassingScore(Double passingScore) { this.passingScore = passingScore; }

    public String getDifficultyLevel() { return difficultyLevel; }
    public void setDifficultyLevel(String difficultyLevel) { this.difficultyLevel = difficultyLevel; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Integer getReviewedBy() { return reviewedBy; }
    public void setReviewedBy(Integer reviewedBy) { this.reviewedBy = reviewedBy; }

    public LocalDateTime getReviewedAt() { return reviewedAt; }
    public void setReviewedAt(LocalDateTime reviewedAt) { this.reviewedAt = reviewedAt; }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }

    public Integer getMaxAttempts() { return maxAttempts; }
    public void setMaxAttempts(Integer maxAttempts) { this.maxAttempts = maxAttempts; }

    public Integer getAttemptCooldownHours() { return attemptCooldownHours; }
    public void setAttemptCooldownHours(Integer attemptCooldownHours) { this.attemptCooldownHours = attemptCooldownHours; }

    @Override
    public String toString() {
        return "Quiz{" +
                "quizID=" + quizID +
                ", title='" + title + '\'' +
                ", categoryName='" + categoryName + '\'' +
                ", difficultyLevel='" + difficultyLevel + '\'' +
                ", status='" + status + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Quiz)) return false;
        Quiz q = (Quiz) o;
        return quizID == q.quizID;
    }

    @Override
    public int hashCode() {
        return Objects.hash(quizID);
    }
}
