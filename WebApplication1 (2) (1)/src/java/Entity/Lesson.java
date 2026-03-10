package Entity;

public class Lesson {

    private int lessonID;
    private int moduleID;
    private String title;
    private String content;
    private int orderIndex;
    private String lessonType;

    public Lesson() {
    }

    public Lesson(int lessonID, int moduleID, String title, String lessonType) {
        this.lessonID = lessonID;
        this.moduleID = moduleID;
        this.title = title;
        this.lessonType = lessonType;
    }

    // --- Getters & Setters ---
    public int getLessonID() {
        return lessonID;
    }

    public void setLessonID(int lessonID) {
        this.lessonID = lessonID;
    }

    public int getModuleID() {
        return moduleID;
    }

    public void setModuleID(int moduleID) {
        this.moduleID = moduleID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(int orderIndex) {
        this.orderIndex = orderIndex;
    }

    public String getLessonType() {
        return lessonType;
    }

    public void setLessonType(String lessonType) {
        this.lessonType = lessonType;
    }

   

}
