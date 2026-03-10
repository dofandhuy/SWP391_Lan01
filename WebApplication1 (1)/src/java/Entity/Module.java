package Entity;

import java.util.List;

public class Module {
    private int id;
    private int courseId;
    private String title;
    private String description; // ✅ thêm mới
    private Integer orderIndex;
    private List<Lesson> lessons;

    public Module() {
    }



    public Module(int id, int courseId, String title, String description, int orderIndex) {
        this.id = id;
        this.courseId = courseId;
        this.title = title;
        this.description = description;
        this.orderIndex = orderIndex;
    }

    public Module(int id, int courseId, String title, String description, Integer orderIndex, List<Lesson> lessons) {
        this.id = id;
        this.courseId = courseId;
        this.title = title;
        this.description = description;
        this.orderIndex = orderIndex;
        this.lessons = lessons;
    }

    public List<Lesson> getLessons() {
        return lessons;
    }

    public void setLessons(List<Lesson> lessons) {
        this.lessons = lessons;
    }
    
    

    // --- Getters & Setters ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Integer getOrderIndex() { return orderIndex; }
    public void setOrderIndex(Integer orderIndex) { this.orderIndex = orderIndex; }

    
    

    @Override
    public String toString() {
        return "Module{" +
                "id=" + id +
                ", courseId=" + courseId +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", orderIndex=" + orderIndex +
                '}';
    }
}
