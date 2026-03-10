package Entity;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class Course {

    private int id;
    private int instructorId;
    private String title;
    private String description;
    private Date createdAt;
    private String thumbnail; // 🆕 thêm dòng này
    private int courseID;

    private String instructorName;
    private String status;
    private int enrolledCount;
    private String image;
    private double progress;
    private List<Module> modules;
    private String deadline;
    private String categoryName;
    private BigDecimal price;

    public Course() {
    }

    public Course(int id, int instructorId, String title, String description, Date createdAt, String thumbnail) {
        this.id = id;
        this.instructorId = instructorId;
        this.title = title;
        this.description = description;
        this.createdAt = createdAt;
        this.thumbnail = thumbnail;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }



    // Getters & setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getInstructorId() {
        return instructorId;
    }

    public void setInstructorId(int instructorId) {
        this.instructorId = instructorId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getThumbnail() {
        return thumbnail;
    }  // 🆕 getter

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }  // 🆕 setter

    public int getCourseID() {
        return courseID;
    }

    public void setCourseID(int courseID) {
        this.courseID = courseID;
    }

    public String getInstructorName() {
        return instructorName;
    }

    public void setInstructorName(String instructorName) {
        this.instructorName = instructorName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getEnrolledCount() {
        return enrolledCount;
    }

    public void setEnrolledCount(int enrolledCount) {
        this.enrolledCount = enrolledCount;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public double getProgress() {
        return progress;
    }

    public void setProgress(double progress) {
        this.progress = progress;
    }

    public List<Module> getModules() {
        return modules;
    }

    public void setModules(List<Module> modules) {
        this.modules = modules;
    }

    public String getDeadline() {
        return deadline;
    }

    public void setDeadline(String deadline) {
        this.deadline = deadline;
    }

}
