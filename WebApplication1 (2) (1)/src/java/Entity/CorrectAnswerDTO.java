package Entity; // Or your Model package

/**
 * Data Transfer Object (DTO) used by the grading service.
 * It holds the essential information needed to check a student's answer
 * against the correct one.
 */
public class CorrectAnswerDTO {
    private int questionId;         // To match with student's answer
    private String questionType;    // To know HOW to grade (MCQ vs FillBlank)
    private int correctAnwerId;     // The ID of the correct option (for MCQ/TrueFalse)
    private String correctAnswerText; // The correct text content (for FillBlank)

    // --- Getters & Setters ---
    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }

    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }

    public int getCorrectAnwerId() { return correctAnwerId; }
    public void setCorrectAnwerId(int correctAnwerId) { this.correctAnwerId = correctAnwerId; }

    public String getCorrectAnswerText() { return correctAnswerText; }
    public void setCorrectAnswerText(String correctAnswerText) { this.correctAnswerText = correctAnswerText; }
}