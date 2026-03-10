package Entity;

import java.sql.Timestamp;

public class LinkedStudent {
    private int linkID;
    private int parentID;
    private int studentID;
    private String studentName;
    private String email;
    private String relationshipName;
    private String note;
    private Timestamp linkDate;
    private String status;

    public LinkedStudent() {}

    public LinkedStudent(int linkID, int parentID, int studentID, String studentName,
                         String email, String relationshipName, String note,
                         Timestamp linkDate, String status) {
        this.linkID = linkID;
        this.parentID = parentID;
        this.studentID = studentID;
        this.studentName = studentName;
        this.email = email;
        this.relationshipName = relationshipName;
        this.note = note;
        this.linkDate = linkDate;
        this.status = status;
    }

    // Getters
    public int getLinkID() { return linkID; }
    public int getParentID() { return parentID; }
    public int getStudentID() { return studentID; }
    public String getStudentName() { return studentName; }
    public String getEmail() { return email; }
    public String getRelationshipName() { return relationshipName; }
    public String getNote() { return note; }
    public Timestamp getLinkDate() { return linkDate; }
    public String getStatus() { return status; }

    // Setters
    public void setLinkID(int linkID) { this.linkID = linkID; }
    public void setParentID(int parentID) { this.parentID = parentID; }
    public void setStudentID(int studentID) { this.studentID = studentID; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public void setEmail(String email) { this.email = email; }
    public void setRelationshipName(String relationshipName) { this.relationshipName = relationshipName; }
    public void setNote(String note) { this.note = note; }
    public void setLinkDate(Timestamp linkDate) { this.linkDate = linkDate; }
    public void setStatus(String status) { this.status = status; }
}
