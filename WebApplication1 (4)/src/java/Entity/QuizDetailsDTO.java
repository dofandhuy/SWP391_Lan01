package Entity; // Hoặc package Model

import java.util.Date;

public class QuizDetailsDTO {

    // === Dữ liệu lấy trực tiếp từ DAO ===
    private int quizId;
    private String quizTitle;
    private String instructorName;
    private Date deadline;
    private Integer maxAttempts; // Kiểu Integer để có thể là null (không giới hạn)
    private Integer attemptCooldownHours; // Kiểu Integer để có thể là null
    private int durationMinutes;
    private HighestAttemptInfo highestScore; // Kiểu Double để có thể là null (chưa làm)

    public HighestAttemptInfo getHighestScore() {
        return highestScore;
    }

    public void setHighestScore(HighestAttemptInfo highestScore) {
        this.highestScore = highestScore;
    }

    // === Dữ liệu được Service tính toán (Logic) ===
    private int attemptsLeft;
    private boolean canStart; // Quyết định nút "Start" có được nhấn hay không
    private String waitMessage; // Thông báo lỗi (ví dụ: "Hết lượt")

    // === Constructors, Getters & Setters ===
    public QuizDetailsDTO() {
    }

    // (Tạo đầy đủ getters và setters cho tất cả các trường trên)
    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public String getQuizTitle() {
        return quizTitle;
    }

    public void setQuizTitle(String quizTitle) {
        this.quizTitle = quizTitle;
    }

    public String getInstructorName() {
        return instructorName;
    }

    public void setInstructorName(String instructorName) {
        this.instructorName = instructorName;
    }

    public Date getDeadline() {
        return deadline;
    }

    public void setDeadline(Date deadline) {
        this.deadline = deadline;
    }

    public Integer getMaxAttempts() {
        return maxAttempts;
    }

    public void setMaxAttempts(Integer maxAttempts) {
        this.maxAttempts = maxAttempts;
    }

    public Integer getAttemptCooldownHours() {
        return attemptCooldownHours;
    }

    public void setAttemptCooldownHours(Integer attemptCooldownHours) {
        this.attemptCooldownHours = attemptCooldownHours;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }



    // Logic Getters/Setters
    public int getAttemptsLeft() {
        return attemptsLeft;
    }

    public void setAttemptsLeft(int attemptsLeft) {
        this.attemptsLeft = attemptsLeft;
    }

    // Rất quan trọng: JSTL (c:if test="${data.canStart}") sẽ gọi hàm "isCanStart()"
    public boolean isCanStart() {
        return canStart;
    }

    public void setCanStart(boolean canStart) {
        this.canStart = canStart;
    }

    public String getWaitMessage() {
        return waitMessage;
    }

    public void setWaitMessage(String waitMessage) {
        this.waitMessage = waitMessage;
    }
}
