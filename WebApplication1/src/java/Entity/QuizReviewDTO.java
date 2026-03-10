/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import java.util.List;
import java.util.Map;

/**
 *
 * @author doanh
 */
public class QuizReviewDTO {

    // --- Summary Info ---
    private int attemptId;
    private String quizTitle;
    private double score;
    private double passingScore;
    private int correctCount;
    private int totalQuestions; // Total number of questions in the quiz
    private double pointPerQuestion;

    public double getPointPerQuestion() {
        return pointPerQuestion;
    }

    public void setPointPerQuestion(double pointPerQuestion) {
        this.pointPerQuestion = pointPerQuestion;
    }
    // --- Detailed Data ---
    private List<Question> questions; // List of questions (includes text, type)
    private Map<Integer, List<AnswerOption>> allOptionsMap; // Map<QuestionID, List<AnswerOption>> (includes isCorrect)
    private Map<Integer, QuizAttemptQuestion> studentAnswersMap; // Map<QuestionID, QuizAttemptQuestion> (student's choice + correctness)

    // --- Getters & Setters ---
    // (Generate getters and setters for all fields)
    public int getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(int attemptId) {
        this.attemptId = attemptId;
    }

    public String getQuizTitle() {
        return quizTitle;
    }

    public void setQuizTitle(String quizTitle) {
        this.quizTitle = quizTitle;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }

    public double getPassingScore() {
        return passingScore;
    }

    public void setPassingScore(double passingScore) {
        this.passingScore = passingScore;
    }

    public int getCorrectCount() {
        return correctCount;
    }

    public void setCorrectCount(int correctCount) {
        this.correctCount = correctCount;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public List<Question> getQuestions() {
        return questions;
    }

    public void setQuestions(List<Question> questions) {
        this.questions = questions;
    }

    public Map<Integer, List<AnswerOption>> getAllOptionsMap() {
        return allOptionsMap;
    }

    public void setAllOptionsMap(Map<Integer, List<AnswerOption>> allOptionsMap) {
        this.allOptionsMap = allOptionsMap;
    }

    public Map<Integer, QuizAttemptQuestion> getStudentAnswersMap() {
        return studentAnswersMap;
    }

    public void setStudentAnswersMap(Map<Integer, QuizAttemptQuestion> studentAnswersMap) {
        this.studentAnswersMap = studentAnswersMap;
    }

}
