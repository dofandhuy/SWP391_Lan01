package Entity; // Hoặc package Model của bạn

import java.util.Date;
import java.util.List;

/**
 * DTO (Data Transfer Object) này chứa TẤT CẢ dữ liệu
 * cho Giai đoạn 2: Bắt đầu làm một lượt thi (Attempt).
 */
public class QuizAttemptData {

    // === Thông tin chính ===
    private int attemptId; // ID của lượt làm bài (RẤT QUAN TRỌNG)
    private int quizId;
    private String quizTitle;
    
    // === Thông tin quy tắc ===
    private int durationMinutes; // Thời gian làm bài (để JS đếm ngược)
    private double pointPerQuestion;
    private Date deadline;

    // === Nội dung bài làm ===
    // Đây là danh sách các câu hỏi, 
    // MỖI câu hỏi đã chứa danh sách lựa chọn (options) của riêng nó
    private List<Question> questions;

    // === Constructors, Getters & Setters ===
    
    public QuizAttemptData() { }

    // (Tạo getters và setters cho tất cả các trường trên)

    public int getAttemptId() { return attemptId; }
    public void setAttemptId(int attemptId) { this.attemptId = attemptId; }
    public int getQuizId() { return quizId; }
    public void setQuizId(int quizId) { this.quizId = quizId; }
    public String getQuizTitle() { return quizTitle; }
    public void setQuizTitle(String quizTitle) { this.quizTitle = quizTitle; }
    public int getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }
    public double getPointPerQuestion() { return pointPerQuestion; }
    public void setPointPerQuestion(double pointPerQuestion) { this.pointPerQuestion = pointPerQuestion; }
    public Date getDeadline() { return deadline; }
    public void setDeadline(Date deadline) { this.deadline = deadline; }
    public List<Question> getQuestions() { return questions; }
    public void setQuestions(List<Question> questions) { this.questions = questions; }
}