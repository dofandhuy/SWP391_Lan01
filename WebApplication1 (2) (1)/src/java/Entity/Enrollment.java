/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import java.sql.Date;
import java.time.LocalDateTime;

/**
 *
 * @author Admin
 */
public class Enrollment {
    private int enrollmentId;
    private int studentId;
    private int courseId;
    private LocalDateTime enrollDate;
    private String status;
    private java.sql.Date deadline;

    public Enrollment() {
    }

    public Enrollment(int enrollmentId, int studentId, int courseId, LocalDateTime enrollDate, String status, Date deadline) {
        this.enrollmentId = enrollmentId;
        this.studentId = studentId;
        this.courseId = courseId;
        this.enrollDate = enrollDate;
        this.status = status;
        this.deadline = deadline;
    }

    public int getEnrollmentId() {
        return enrollmentId;
    }

    public void setEnrollmentId(int enrollmentId) {
        this.enrollmentId = enrollmentId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public LocalDateTime getEnrollDate() {
        return enrollDate;
    }

    public void setEnrollDate(LocalDateTime enrollDate) {
        this.enrollDate = enrollDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getDeadline() {
        return deadline;
    }

    public void setDeadline(Date deadline) {
        this.deadline = deadline;
    }

    @Override
    public String toString() {
        return "Enrollment{" + "enrollmentId=" + enrollmentId + ", studentId=" + studentId + ", courseId=" + courseId + ", enrollDate=" + enrollDate + ", status=" + status + ", deadline=" + deadline + '}';
    }
    
    
}
