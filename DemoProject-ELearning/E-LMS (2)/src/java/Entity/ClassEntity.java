

package Entity;

import java.util.Date;

public class ClassEntity {
    private int classId;
    private String className;
    private String description;
    private String classCode;
    private int createdBy; 
    private Date createdAt;

    public ClassEntity() {}

    public ClassEntity(String className, String description, String classCode, int createdBy, Date createdAt) {
        this.className = className;
        this.description = description;
        this.classCode = classCode;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
    }

    // Getters & Setters
    public int getClassId() {
        return classId;
    }

    public void setClassId(int classId) {
        this.classId = classId;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getClassCode() {
        return classCode;
    }

    public void setClassCode(String classCode) {
        this.classCode = classCode;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}