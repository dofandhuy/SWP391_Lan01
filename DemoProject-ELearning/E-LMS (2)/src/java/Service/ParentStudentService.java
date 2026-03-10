package Service;

import DAO.ParentStudentDAO;
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
//     public static void main(String[] args) {
//        ParentStudentService service = new ParentStudentService();
//
//        // Test 1: Lấy danh sách Relationship
//        System.out.println("=== TEST getAllRelationships() ===");
//        List<Relationship> relationships = service.getAllRelationships();
//        for (Relationship r : relationships) {
//            System.out.println(r.getRelationshipID() + " - " + r.getRelationshipName());
//        }

//        // Test 2: Tìm studentID theo email
//        System.out.println("\n=== TEST getStudentIDByEmail() ===");
//        String testEmail = "doanhuy05@gmail.com"; // thay bằng email có trong DB
//        int studentID = service.getStudentIDByEmail(testEmail);
//        System.out.println("StudentID for " + testEmail + ": " + studentID);
//
//        // Test 3: Tìm relationshipID theo tên
//        System.out.println("\n=== TEST findRelationshipID() ===");
//        String relationName = "Grandparent"; // thay bằng tên có trong bảng Relationship
//        int relID = service.findRelationshipID(relationName);
//        System.out.println("RelationshipID for '" + relationName + "': " + relID);
//
//        // Test 4: Kiểm tra liên kết tồn tại chưa
//        System.out.println("\n=== TEST checkLinkExists() ===");
//        int parentID = 4;  // thay bằng ID thật trong DB
//        boolean exists = service.checkLinkExists(parentID, studentID);
//        System.out.println("Link exists? " + exists);
//
//        // Test 5: Tạo link mới
//        System.out.println("\n=== TEST createLinkRequest() ===");
//        boolean created = service.createLinkRequest(parentID, studentID, relID, "Testing link");
//        System.out.println("Create link result: " + created);
//  
// public static void main(String[] args) {
//        ParentStudentService service = new ParentStudentService();
//
//        int testParentID = 4; // Ví dụ parentID = 4
//        List<LinkedStudent> list = service.getLinkedStudents(testParentID);
//
//        if (list == null || list.isEmpty()) {
//            System.out.println("❌ Không tìm thấy học sinh liên kết cho ParentID = " + testParentID);
//        } else {
//            System.out.println("✅ Danh sách học sinh liên kết:");
//            for (LinkedStudent s : list) {
//                System.out.println("------------------------------------");
//                System.out.println("StudentID: " + s.getStudentID());
//                System.out.println("Student Name: " + s.getStudentName());
//                System.out.println("Email: " + s.getEmail());              
//                System.out.println("Relationship: " + s.getRelationshipName());
//                System.out.println("Note:"+ s.getNote());
//                System.out.println("Link Date:" + s.getLinkDate());
//                System.out.println("Status: " + s.getStatus());
//            }
//        }
//    }
//    public static void main(String[] args) {
//    ParentStudentService service = new ParentStudentService();
//
//    int testLinkID = 15; // ID thật có trong DB
//    int newRelationshipID = 2; // ví dụ Guardian
//
//    System.out.println("=== TEST updateRelationship() ===");
//    if (service.updateRelationship(testLinkID, newRelationshipID)) {
//        System.out.println("✅ Relationship updated successfully!");
//    } else {
//        System.out.println("❌ Failed to update relationship.");
//    }
//
//    System.out.println("=== TEST approveLinkRequest() ===");
//    if (service.approveLinkRequest(testLinkID)) {
//        System.out.println("✅ Link approved successfully!");
//    } else {
//        System.out.println("❌ Failed to approve link.");
//    }
//
//    System.out.println("=== TEST rejectLinkRequest() ===");
//    if (service.rejectLinkRequest(testLinkID)) {
//        System.out.println("✅ Link rejected successfully!");
//    } else {
//        System.out.println("❌ Failed to reject link.");
//    }
//
//    System.out.println("=== TEST deleteLink() ===");
//    if (service.deleteLink(testLinkID)) {
//        System.out.println("✅ Link deleted successfully!");
//    } else {
//        System.out.println("❌ Failed to delete link.");
//    }
//}

}

