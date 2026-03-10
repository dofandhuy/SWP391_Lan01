//package Entity;
//
//import java.math.BigDecimal;
//import java.util.Date;
//import java.util.List;
//
//public class Course {
//
//    private int id;
//    private int instructorId;
//    private int categoryId;
//    private String title;
//    private String description;
//    private Date createdAt;
//    private String thumbnail;
//    private int courseID;
//
//    private String instructorName;
//    private String status; // 🔹 "Pending", "Approved", "Rejected", "Draft"
//    private int enrolledCount;
//    private String image;
//    private double progress;
//    private List<Module> modules;
//    private String deadline;
//    private BigDecimal price; // 🆕 Giá khóa học
//    private String categoryName;
//
//    public Course() {
//    }
//
//    public Course(int id, int instructorId, int categoryId, String title, String description, Date createdAt, String thumbnail) {
//        this.id = id;
//        this.instructorId = instructorId;
//        this.categoryId = categoryId;
//        this.title = title;
//        this.description = description;
//        this.createdAt = createdAt;
//        this.thumbnail = thumbnail;
//        this.status = "Draft"; // 🆕 mặc định ban đầu
//    }
//
//    // === Getters & Setters ===
//    public int getId() {
//        return id;
//    }
//
//    public void setId(int id) {
//        this.id = id;
//    }
//
//    public int getInstructorId() {
//        return instructorId;
//    }
//
//    public void setInstructorId(int instructorId) {
//        this.instructorId = instructorId;
//    }
//
//    public String getTitle() {
//        return title;
//    }
//
//    public void setTitle(String title) {
//        this.title = title;
//    }
//
//    public String getDescription() {
//        return description;
//    }
//
//    public void setDescription(String description) {
//        this.description = description;
//    }
//
//    public Date getCreatedAt() {
//        return createdAt;
//    }
//
//    public void setCreatedAt(Date createdAt) {
//        this.createdAt = createdAt;
//    }
//
//    public String getThumbnail() {
//        return thumbnail;
//    }
//
//    public void setThumbnail(String thumbnail) {
//        this.thumbnail = thumbnail;
//    }
//
//    public int getCourseID() {
//        return courseID;
//    }
//
//    public void setCourseID(int courseID) {
//        this.courseID = courseID;
//    }
//
//    public String getInstructorName() {
//        return instructorName;
//    }
//
//    public void setInstructorName(String instructorName) {
//        this.instructorName = instructorName;
//    }
//
//    public String getStatus() {
//        return status;
//    }
//
//    public void setStatus(String status) {
//        this.status = status;
//    }
//
//    public int getEnrolledCount() {
//        return enrolledCount;
//    }
//
//    public void setEnrolledCount(int enrolledCount) {
//        this.enrolledCount = enrolledCount;
//    }
//
//    public String getImage() {
//        return image;
//    }
//
//    public void setImage(String image) {
//        this.image = image;
//    }
//
//    public double getProgress() {
//        return progress;
//    }
//
//    public void setProgress(double progress) {
//        this.progress = progress;
//    }
//
//    public List<Module> getModules() {
//        return modules;
//    }
//
//    public void setModules(List<Module> modules) {
//        this.modules = modules;
//    }
//
//    public String getDeadline() {
//        return deadline;
//    }
//
//    public void setDeadline(String deadline) {
//        this.deadline = deadline;
//    }
//
//    public int getCategoryId() {
//        return categoryId;
//    }
//
//    public void setCategoryId(int categoryId) {
//        this.categoryId = categoryId;
//    }
//
//    public BigDecimal getPrice() {
//        return price;
//    }
//
//    public void setPrice(BigDecimal price) {
//        this.price = price;
//    }
//
//    public String getCategoryName() {
//        return categoryName;
//    }
//
//    public void setCategoryName(String categoryName) {
//        this.categoryName = categoryName;
//    }
//   
//}
package Entity;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Objects;

public class Course {

    private int id;
    private int instructorId;
    private int categoryId;
    private int categoryID;
    private String title;

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }
    private String description;
    private Date createdAt;
    private String thumbnail;
    private int courseID;
private int InstructorID;

    public int getInstructorID() {
        return InstructorID;
    }

    public void setInstructorID(int InstructorID) {
        this.InstructorID = InstructorID;
    }
    private String instructorName;
    private String status; // "Pending", "Approved", "Rejected", "Draft"
    private int enrolledCount;
    private String image;
    private double progress;
    private List<Module> modules;
    private String deadline;
    private BigDecimal price; // Giá khóa học
    private String categoryName;
 private String rejectionReason;

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }
    public Course() {
        this.status = "Draft";
    }

    public Course(int id, int instructorId, int categoryId, String title, String description, Date createdAt, String thumbnail) {
        this.id = id;
        this.instructorId = instructorId;
        this.categoryId = categoryId;
        this.title = title;
        this.description = description;
        this.createdAt = createdAt;
        this.thumbnail = thumbnail;
        this.status = "Draft";
    }

    // === Getters & Setters ===
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getInstructorId() { return instructorId; }
    public void setInstructorId(int instructorId) { this.instructorId = instructorId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getThumbnail() { return thumbnail; }
    public void setThumbnail(String thumbnail) { this.thumbnail = thumbnail; }

    public int getCourseID() { return courseID; }
    public void setCourseID(int courseID) { this.courseID = courseID; }

    public String getInstructorName() { return instructorName; }
    public void setInstructorName(String instructorName) { this.instructorName = instructorName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getEnrolledCount() { return enrolledCount; }
    public void setEnrolledCount(int enrolledCount) { this.enrolledCount = enrolledCount; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public double getProgress() { return progress; }
    public void setProgress(double progress) { this.progress = progress; }

    public List<Module> getModules() { return modules; }
    public void setModules(List<Module> modules) { this.modules = modules; }

    public String getDeadline() { return deadline; }
    public void setDeadline(String deadline) { this.deadline = deadline; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    @Override
    public String toString() {
        return "Course{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", instructorName='" + instructorName + '\'' +
                ", categoryName='" + categoryName + '\'' +
                ", status='" + status + '\'' +
                ", price=" + price +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Course)) return false;
        Course c = (Course) o;
        return id == c.id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
