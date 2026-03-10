/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

/**
 *
 * @author doanh
 */
public class QuizAttemptQuestion {
    private int attemptId;        // Foreign key referencing QuizAttempts
    private int questionId;       // Foreign key referencing QuestionBank
    private String studentAnswer; // The actual answer submitted (AnswerID for MCQ/TF, Text for FillBlank)
    private boolean isCorrect;    // Whether the submitted answer was correct

    // --- Constructor (optional, but good practice) ---
    public QuizAttemptQuestion() {
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
    }

    public boolean isCorrect() {
        return isCorrect;
    }

    public void setCorrect(boolean correct) {
        isCorrect = correct;
    }

    // --- toString (optional, useful for debugging) ---
    @Override
    public String toString() {
        return "QuizAttemptQuestion{" +
               "attemptId=" + attemptId +
               ", questionId=" + questionId +
               ", studentAnswer='" + studentAnswer + '\'' +
               ", isCorrect=" + isCorrect +
               '}';
    }
}
