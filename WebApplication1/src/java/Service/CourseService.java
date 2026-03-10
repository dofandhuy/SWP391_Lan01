package Service;

import Dao.CourseDAO;
import Entity.Course;
import java.util.List;

public class CourseService {

    private CourseDAO dao = new CourseDAO();

    public List<Course> getPagedCourses(int instructorId, int page, int pageSize, String search) {
        return dao.getCoursesByInstructor(instructorId, page, pageSize, search);
    }

    public int getTotalPages(int instructorId, int pageSize, String search) {
        int totalCourses = dao.countCoursesByInstructor(instructorId, search);
        return (int) Math.ceil((double) totalCourses / pageSize);
    }

    public boolean createCourse(Course course) {
        if (course.getTitle() == null || course.getTitle().isEmpty()) {
            return false;
        }
        return dao.addCourse(course);
    }

    public boolean deleteCourseWithModules(int courseId) {
        try {
            return dao.deleteCourseWithModules(courseId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCourse(Course course) {
        if (course.getTitle() == null || course.getTitle().isEmpty()) {
            return false;
        }
        return dao.updateCourse(course);
    }

    public Course getCourseById(int courseId) {
        return dao.getCourseById(courseId);
    }

    public Course getCourseById1(int courseId) {
        return dao.getCourseById(courseId);
    }

    public boolean updateCourseStatus(int courseId, String newStatus) {
        return dao.updateCourseStatus(courseId, newStatus);
    }

}
