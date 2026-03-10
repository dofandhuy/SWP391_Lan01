<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Entity.Module, Entity.Course, Entity.Quiz, Service.ModuleService, Service.CourseService, Service.QuizService, java.util.*" %>

<%
    int moduleId = Integer.parseInt(request.getParameter("moduleId"));

    ModuleService moduleService = new ModuleService();
    Module module = moduleService.getModuleById(moduleId);

    CourseService courseService = new CourseService();
    Course course = courseService.getCourseById(module.getCourseId());

    QuizService quizService = new QuizService();
    List<Quiz> availableQuizzes = quizService.getQuizzesByCategory(course.getCategoryId());

    Quiz assignedQuiz = quizService.getQuizByModuleId(moduleId);
    Integer assignedQuizId = (assignedQuiz != null) ? assignedQuiz.getQuizID() : null;
%>

<html>
<head>
    <title>Edit Module</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: rgba(0,0,0,0.4);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .modal {
            background: rgba(0, 0, 0, 0.4);
            width: 100%;
            height: 100%;
            position: fixed;
            top: 0; left: 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background: #fff;
            padding: 30px 40px;
            border-radius: 12px;
            width: 450px;
            position: relative;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            animation: fadeIn 0.3s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        h2 {
            text-align: center;
            color: #1b1f3b;
            margin-bottom: 20px;
        }
        label {
            font-weight: 500;
            color: #333;
            display: block;
            margin-top: 10px;
        }
        input[type="text"],
        textarea,
        select {
            width: 100%;
            padding: 10px 12px;
            margin-top: 5px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 15px;
            outline: none;
            transition: 0.2s;
        }
        input[type="text"]:focus,
        textarea:focus,
        select:focus {
            border-color: #22c1c3;
            box-shadow: 0 0 4px rgba(34,193,195,0.3);
        }
        textarea {
            height: 100px;
            resize: none;
        }
        button {
            width: 100%;
            background: #22c1c3;
            border: none;
            padding: 12px;
            border-radius: 8px;
            color: #fff;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.3s;
        }
        button:hover {
            background: #1aa0a3;
        }
        .close-btn {
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 22px;
            color: #555;
            cursor: pointer;
            transition: color 0.2s;
        }
        .close-btn:hover {
            color: #000;
        }
    </style>

    <script>
        function closeEditModuleModal() {
            window.history.back(); // Quay lại trang trước
        }
    </script>
</head>

<body>
    <div class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeEditModuleModal()">&times;</span>
            <h2><i class="fa-solid fa-pen-to-square"></i> Edit Module</h2>

            <form action="${pageContext.request.contextPath}/EditModuleServlet" method="post">
                <input type="hidden" name="moduleId" value="<%= module.getId() %>">
                <input type="hidden" name="courseId" value="<%= module.getCourseId() %>">

                <label>Module Title:</label>
                <input type="text" name="title" value="<%= module.getTitle() %>" required>

                <label>Description:</label>
                <textarea name="description"><%= module.getDescription() != null ? module.getDescription() : "" %></textarea>

                <label>Select Quiz To Assign:</label>
                <select name="quizId">
                    <option value="">-- None --</option>
                    <% for (Quiz q : availableQuizzes) {
                           String selected = (assignedQuizId != null && assignedQuizId.equals(q.getQuizID())) ? "selected" : "";
                    %>
                        <option value="<%= q.getQuizID() %>" <%= selected %>><%= q.getTitle() %></option>
                    <% } %>
                </select>

                <button type="submit">Update Module</button>
            </form>
        </div>
    </div>
</body>
</html>