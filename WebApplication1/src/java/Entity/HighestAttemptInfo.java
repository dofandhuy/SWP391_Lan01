/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

/**
 *
 * @author doanh
 */
public class HighestAttemptInfo {
    private Double score; // Điểm số (Double để có thể null)
    private Integer attemptId; // ID của lượt làm bài (Integer để có thể null)

    // Constructor
    public HighestAttemptInfo(Double score, Integer attemptId) {
        this.score = score;
        this.attemptId = attemptId;
    }

    // Getters
    public Double getScore() {
        return score;
    }

    public Integer getAttemptId() {
        return attemptId;
    }
}
