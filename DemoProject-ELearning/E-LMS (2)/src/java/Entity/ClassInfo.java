package Entity;

public class ClassInfo {
    private int classId;
    private String className;
    private int studentCount;
    private int lessonCount;
    private int assignmentCount;
    private int documentCount;

    public ClassInfo(int classId, String className, int studentCount, int lessonCount, int assignmentCount, int documentCount) {
        this.classId = classId;
        this.className = className;
        this.studentCount = studentCount;
        this.lessonCount = lessonCount;
        this.assignmentCount = assignmentCount;
        this.documentCount = documentCount;
    }

    public int getClassId() {
        return classId;
    }

    public String getClassName() {
        return className;
    }

    public int getStudentCount() {
        return studentCount;
    }

    public int getLessonCount() {
        return lessonCount;
    }

    public int getAssignmentCount() {
        return assignmentCount;
    }

    public int getDocumentCount() {
        return documentCount;
    }
}
