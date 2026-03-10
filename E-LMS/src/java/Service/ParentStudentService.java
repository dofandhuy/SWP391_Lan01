package Service;

import Dao.ParentStudentDAO;
import Entity.LinkedStudent;
import Entity.Relationship;
import Entity.User;


import java.util.List;

public class ParentStudentService {
    
    private final ParentStudentDAO dao = new ParentStudentDAO();
    public User getStudentDetailByLinkId(int linkId) {
        // Gọi DAO để lấy thông tin chi tiết sinh viên
    return dao.findStudentByLinkId(linkId);
    }


    public List<Relationship> getAllRelationships() {
        return dao.getAllRelationships();
    }
    public int getStudentIDByEmail(String email) {
        User student = dao.getStudentByEmail(email);
        if (student != null) {
            return student.getUserID();
        }
        return -1; // không tìm thấy
    }
    public int findRelationshipID(String name) {
        return dao.findRelationshipID(name);
    }

    public boolean checkLinkExists(int parentID, int studentID) {
        return dao.checkLinkExists(parentID, studentID);
    }

    public boolean createLinkRequest(int parentID, int studentID, int relationshipID, String note) {
        return dao.createLinkRequest(parentID, studentID, relationshipID, note);
    }
    public List<LinkedStudent> getLinkedStudents(int parentID) {
    return dao.getLinkedStudentsByParentID(parentID);
}
    public boolean deleteLink(int linkID) {
        return dao.deleteLink(linkID);
    }

    public boolean updateRelationship(int linkID, int relationshipID) {
        return dao.updateRelationship(linkID, relationshipID);
    }

    public boolean approveLinkRequest(int linkID) {
        return dao.approveLinkRequest(linkID);
    }

    public boolean rejectLinkRequest(int linkID) {
        return dao.rejectLinkRequest(linkID);
    }
   public boolean isStudentAlreadyLinked(int studentID) {
        return dao.isStudentAlreadyLinked(studentID);
    }

}

