package Entity;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Lưu thông tin câu hỏi trong một lượt làm quiz.
 * Hỗ trợ cả:
 * - MCQ 1 đáp án
 * - MCQ nhiều đáp án
 * - True/False
 * - FillBlank
 */
public class QuizAttemptQuestion {

    private int attemptId;        // FK -> QuizAttempts
    private int questionId;       // FK -> QuestionBank

    // Dành cho câu hỏi có nhiều đáp án được chọn (checkbox)
    private List<Integer> selectedAnswerIds;

    // Giữ nguyên để tương thích với FillBlank hoặc MCQ 1 đáp án
    private String studentAnswer;

    private boolean isCorrect;    // Câu này đúng hay sai

    // --- Constructor ---
    public QuizAttemptQuestion() {
        this.selectedAnswerIds = new ArrayList<>();
    }

    // --- Getters & Setters ---
    public int getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(int attemptId) {
        this.attemptId = attemptId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getStudentAnswer() {
        return studentAnswer;
    }

    public void setStudentAnswer(String studentAnswer) {
        this.studentAnswer = studentAnswer;
        // Đồng bộ: nếu là dạng "1,2,4" thì tự parse ra list
        if (studentAnswer != null && studentAnswer.contains(",")) {
            this.selectedAnswerIds = parseAnswerIds(studentAnswer);
        }
    }

    public boolean isCorrect() {
        return isCorrect;
    }

    public void setCorrect(boolean correct) {
        isCorrect = correct;
    }

    public List<Integer> getSelectedAnswerIds() {
        return selectedAnswerIds;
    }

    public void setSelectedAnswerIds(List<Integer> selectedAnswerIds) {
        this.selectedAnswerIds = selectedAnswerIds;
        // Đồng bộ: lưu lại dạng chuỗi "1,2,3"
        this.studentAnswer = joinAnswerIds(selectedAnswerIds);
    }

    // --- Helper methods ---
    private List<Integer> parseAnswerIds(String csv) {
        List<Integer> ids = new ArrayList<>();
        if (csv != null && !csv.trim().isEmpty()) {
            String[] parts = csv.split(",");
            for (String p : parts) {
                try {
                    ids.add(Integer.parseInt(p.trim()));
                } catch (NumberFormatException ignored) {
                }
            }
        }
        return ids;
    }

    private String joinAnswerIds(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) return "";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < ids.size(); i++) {
            sb.append(ids.get(i));
            if (i < ids.size() - 1) sb.append(",");
        }
        return sb.toString();
    }

    @Override
    public String toString() {
        return "QuizAttemptQuestion{" +
                "attemptId=" + attemptId +
                ", questionId=" + questionId +
                ", selectedAnswerIds=" + selectedAnswerIds +
                ", studentAnswer='" + studentAnswer + '\'' +
                ", isCorrect=" + isCorrect +
                '}';
    }
}
