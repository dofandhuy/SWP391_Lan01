package Entity;
public class InstructorClass {
    private int classId;
    private String classCode;
    private String className;
    private int studentCount;
    private int lessonCount;
    private int assignmentCount;
    private int documentCount;

    public int getClassId() { return classId; }
    public void setClassId(int classId) { this.classId = classId; }

    public String getClassCode() { return classCode; }
    public void setClassCode(String classCode) { this.classCode = classCode; }

    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }

    public int getStudentCount() { return studentCount; }
    public void setStudentCount(int studentCount) { this.studentCount = studentCount; }

    public int getLessonCount() { return lessonCount; }
    public void setLessonCount(int lessonCount) { this.lessonCount = lessonCount; }

    public int getAssignmentCount() { return assignmentCount; }
    public void setAssignmentCount(int assignmentCount) { this.assignmentCount = assignmentCount; }

    public int getDocumentCount() { return documentCount; }
    public void setDocumentCount(int documentCount) { this.documentCount = documentCount; }
}
