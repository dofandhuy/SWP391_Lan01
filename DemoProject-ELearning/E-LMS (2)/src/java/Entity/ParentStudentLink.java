/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import java.time.LocalDateTime;

/**
 *
 * @author doanh
 */
public class ParentStudentLink {
    private int linkID;
    private int parentID;
    private int studentID;
    private int relationshipID; // Khóa ngoại đến Relationship
    private String note;
    private LocalDateTime linkDate;
    private String status; // 'Active' hoặc 'Inactive'

    // Constructor, Getters and Setters

    public ParentStudentLink() {}

    // Getters
    public int getLinkID() { return linkID; }
    public int getParentID() { return parentID; }
    public int getStudentID() { return studentID; }
    public int getRelationshipID() { return relationshipID; }
    public String getNote() { return note; }
    public LocalDateTime getLinkDate() { return linkDate; }
    public String getStatus() { return status; }

    // Setters
    public void setLinkID(int linkID) { this.linkID = linkID; }
    public void setParentID(int parentID) { this.parentID = parentID; }
    public void setStudentID(int studentID) { this.studentID = studentID; }
    public void setRelationshipID(int relationshipID) { this.relationshipID = relationshipID; }
    public void setNote(String note) { this.note = note; }
    public void setLinkDate(LocalDateTime linkDate) { this.linkDate = linkDate; }
    public void setStatus(String status) { this.status = status; }
}
