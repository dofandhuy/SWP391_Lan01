/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

/**
 *
 * @author Acer
 */

public class Material {

     private int classId;

     private String className; 

    private String title;

    private String filePath;

    private String uploadedBy;



    // Getters and Setters

    

    public int getClassId() { return classId; }

    public void setClassId(int classId) { this.classId = classId; }

 public String getClassName() { return className; }

    public void setClassName(String className) { this.className = className; }



    public String getTitle() { return title; }

    public void setTitle(String title) { this.title = title; }



    public String getFilePath() { return filePath; }

    public void setFilePath(String filePath) { this.filePath = filePath; }



    public String getUploadedBy() { return uploadedBy; }

    public void setUploadedBy(String uploadedBy) { this.uploadedBy = uploadedBy;} }