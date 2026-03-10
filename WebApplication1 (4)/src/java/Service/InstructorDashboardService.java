package Service;

import Dao.InstructorDashboardDao;
import Entity.Course;
import Entity.InstructorStats;
import java.util.List;

public class InstructorDashboardService {
    private InstructorDashboardDao dashboardDao = new InstructorDashboardDao();

    public InstructorStats getStats(int instructorId) {
        return dashboardDao.getInstructorStats(instructorId);
    }

    public List<Course> getRecentCourses(int instructorId, int limit) {
        return dashboardDao.getRecentCourses(instructorId, limit);
    }
}
