<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Entity.Lesson" %>
<%
    Lesson lesson = (Lesson) request.getAttribute("lesson");
%>
<html>
<head>
    <title>Edit Lesson</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #fafafa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            width: 420px;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #1b1f3b;
        }
        input, textarea, select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        input[type="checkbox"] {
            transform: scale(1.2);
            margin-right: 8px;
        }
        button {
            width: 100%;
            padding: 10px;
            background: #22c1c3;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
        }
        button:hover {
            background: #1aa3a5;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Edit Lesson</h2>

    <form action="${pageContext.request.contextPath}/instructor/EditLessonServlet" 
          method="post" enctype="multipart/form-data">

        <input type="hidden" name="lessonId" value="<%= lesson.getLessonID() %>">

        <label>Lesson Title</label>
        <input type="text" name="title" value="<%= lesson.getTitle() %>" required>

        <label>Description</label>
        <textarea name="content" rows="4"><%= lesson.getContent() %></textarea>

        <label>Lesson Type</label>
        <select name="lessonType">
            <option value="video" <%= "video".equals(lesson.getLessonType()) ? "selected" : "" %>>Video</option>
            <option value="document" <%= "document".equals(lesson.getLessonType()) ? "selected" : "" %>>Document</option>
            <option value="quiz" <%= "quiz".equals(lesson.getLessonType()) ? "selected" : "" %>>Quiz</option>
        </select>

        <label>
            <input type="checkbox" id="addFile" name="addFile" checked onchange="toggleFileUpload()"> Add/Replace file
        </label>

        <div id="file-section">
            <input type="file" name="file">
        </div>

        <% if (lesson.getVideoUrl() != null) { %>
            <p>Current file: <a href="<%= request.getContextPath() + "/" + lesson.getVideoUrl() %>" target="_blank">View File</a></p>
        <% } %>

        <button type="submit">Save Changes</button>
    </form>

    <a href="${pageContext.request.contextPath}/CourseDetailServlet?courseId=${courseId}" 
   class="back-link">← Back to Course</a>


</div>

<script>
    function toggleFileUpload() {
        const checked = document.getElementById("addFile").checked;
        document.getElementById("file-section").style.display = checked ? "block" : "none";
    }
</script>
</body>
</html>
