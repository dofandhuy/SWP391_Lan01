package Service;

import Dao.ParentStudentDAO;
import Entity.LinkedStudent;
import Entity.ParentStudentLink;
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

    public int getParentIDByEmail(String email) {
        User parent = dao.getParentByEmail(email);
        if (parent != null) {
            return parent.getUserID();
        }
        return -1; // không tìm thấy
    }

    public User findParentByStudentId(int studentId) {
        // Phương thức này chỉ đơn giản là gọi phương thức tương ứng từ DAO
        // và trả về kết quả của nó.
        return dao.findParentByStudentId(studentId);
    }

    public List<LinkedStudent> getPendingRequests(int parentID) {
        return dao.getPendingRequestsByParentID(parentID);
    }

    public List<LinkedStudent> getActiveLinkedStudents(int parentID) {
        return dao.getActiveLinkedStudentsByParentID(parentID);
    }

    public boolean deactivateLink(int linkID) {
        return dao.deactivateLink(linkID);
    }

    public ParentStudentLink getLinkByStudentId(int studentId) {
        return dao.getLinkByStudentId(studentId);
    }
    public ParentStudentLink getLinkByParentAndStudentId(int parentID, int studentID) {
    return dao.getLinkByParentAndStudentId(parentID, studentID);
}

public boolean updateRejectedLink(int parentID, int studentID, int relationshipID, String note) {
    return dao.updateRejectedLink(parentID, studentID, relationshipID, note);
}
public List<LinkedStudent> getAllLinksByStudentId(int studentId) {
    return dao.getAllLinksByStudentId(studentId);
}
}
