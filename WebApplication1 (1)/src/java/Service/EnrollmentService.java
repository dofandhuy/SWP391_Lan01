/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Service;

import Dao.EnrollmentDAO;
import Entity.Course;
import java.util.List;

/**
 *
 * @author doanh
 */
public class EnrollmentService {
     private final EnrollmentDAO enrollment = new EnrollmentDAO();
     public List<Course> getEnrolledCoursesByStudent(int studentId) {
     return enrollment.getEnrolledCoursesByStudentId(studentId);
    }
}
