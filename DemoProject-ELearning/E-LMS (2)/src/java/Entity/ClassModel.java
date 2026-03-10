/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

/**
 *
 * @author Admin
 */
public class ClassModel {
    private int classId;
    private String className;
    private String classCode;
    private int createdBy;

    public ClassModel() {
    }

    public ClassModel(int classId, String className, String classCode, int createdBy) {
        this.classId = classId;
        this.className = className;
        this.classCode = classCode;
        this.createdBy = createdBy;
    }

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

    @Override
    public String toString() {
        return "ClassModel{" + "classId=" + classId + ", className=" + className + ", classCode=" + classCode + ", createdBy=" + createdBy + '}';
    }
    
    
}
