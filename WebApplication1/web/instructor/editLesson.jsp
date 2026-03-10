<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Entity.Lesson" %>
<%
    Lesson lesson = (Lesson) request.getAttribute("lesson");
    int courseId = (Integer) request.getAttribute("courseId");
%>

<form action="${pageContext.request.contextPath}/instructor/EditLessonServlet" 
      method="post" style="display:flex; flex-direction:column; gap:10px;">

    <input type="hidden" name="lessonId" value="<%= lesson.getLessonID() %>">

    <label><strong>Lesson Title</strong></label>
    <input type="text" name="title" value="<%= lesson.getTitle() %>" required>

    <label><strong>Description</strong></label>
    <textarea name="content" rows="4"><%= lesson.getContent() %></textarea>

    <label><strong>Lesson Type</strong></label>
    <select name="lessonType">
        <option value="video" <%= "video".equals(lesson.getLessonType()) ? "selected" : "" %>>Video</option>
        <option value="document" <%= "document".equals(lesson.getLessonType()) ? "selected" : "" %>>Document</option>
        <option value="quiz" <%= "quiz".equals(lesson.getLessonType()) ? "selected" : "" %>>Quiz</option>
    </select>

    <label><strong>Video or Document URL</strong></label>
  
    <button type="submit" style="background:#22c1c3; color:white; border:none; padding:10px; border-radius:6px; cursor:pointer;">
        Save Changes
    </button>

    <a href="${pageContext.request.contextPath}/CourseDetailServlet?courseId=<%=courseId%>" 
       style="text-align:center; display:block; margin-top:10px;">← Back to Course</a>
</form>
