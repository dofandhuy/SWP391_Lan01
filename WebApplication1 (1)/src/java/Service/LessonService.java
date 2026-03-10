package Service;

import Dao.LessonDAO;
import Entity.Lesson;
import java.util.List;

public class LessonService {

    private LessonDAO lessonDAO = new LessonDAO();

    public List<Lesson> getLessonsByModuleId(int moduleId) throws Exception {
        return lessonDAO.getLessonsByModuleId(moduleId);
    }

    public boolean deleteLesson(int lessonId) throws Exception {
        return lessonDAO.deleteLesson(lessonId);
    }

    public boolean moveLessonUp(int lessonId, int moduleId) throws Exception {
        return lessonDAO.moveLessonUp(lessonId, moduleId);
    }

    public boolean moveLessonDown(int lessonId, int moduleId) throws Exception {
        return lessonDAO.moveLessonDown(lessonId, moduleId);
    }

    public void createLesson(Lesson lesson) throws Exception {
        lessonDAO.insertLesson(lesson);
    }

    public Lesson getLessonById(int id) {
        return lessonDAO.getLessonById(id);
    }

    public void updateLesson(Lesson lesson) {
        lessonDAO.updateLesson(lesson);
    }

}
