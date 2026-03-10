package Service;

import Dao.LessonDocumentDAO;
import Entity.LessonDocument;
import java.util.List;

public class LessonDocumentService {
    private LessonDocumentDAO documentDAO = new LessonDocumentDAO();

    public List<LessonDocument> getDocumentsByLesson(int lessonId) {
        return documentDAO.getDocumentsByLesson(lessonId);
    }

    public void addDocument(int lessonId, String filePath, String fileName) {
        documentDAO.addDocument(lessonId, filePath, fileName);
    }
    public List<LessonDocument> getDocumentsByLesson1(int lessonId) {
        return documentDAO.getDocumentsByLesson1(lessonId);
    }

    public boolean deleteDocument(int documentId) {
        return documentDAO.deleteDocument(documentId);
    }
}
