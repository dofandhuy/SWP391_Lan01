package Service;

import Dao.LessonDAO;
import Entity.Lesson;
import Entity.LessonDocument;
import Entity.LessonVideo;
import Entity.Quiz;
import java.util.List;

public class LessonService {

    private LessonDAO lessonDAO = new LessonDAO();

    // ================= LESSON =================
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

    // ================= VIDEO =================
    public List<LessonVideo> getLessonVideos(int lessonId) {
        return lessonDAO.getLessonVideos(lessonId);
    }

    // ================= DOCUMENT =================
    public List<LessonDocument> getLessonDocuments(int lessonId) {
        return lessonDAO.getLessonDocuments(lessonId);
    }

    // ================= QUIZ =================
    public Quiz getLessonQuiz(int lessonId) {
        return lessonDAO.getLessonQuiz(lessonId);
    }
    public boolean assignQuizToLesson(int lessonId, int quizId) {
        return lessonDAO.updateQuizAssignment(lessonId, quizId);
    }

    public boolean unassignQuizFromLesson(int lessonId) {
        return lessonDAO.removeQuizAssignment(lessonId);
    }
}
