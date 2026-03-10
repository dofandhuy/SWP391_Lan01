<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Create Lesson</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fc;
            display: flex;
            height: 100vh;
        }
        .sidebar { width: 220px; background: #fff; border-right: 1px solid #eee; padding: 20px; }
        .main { flex: 1; display: flex; justify-content: center; align-items: center; }
        .form-container { background: #fff; padding: 40px 50px; border-radius: 16px; box-shadow: 0 4px 15px rgba(0,0,0,0.08); width: 480px; }
        h2 { text-align: center; margin-bottom: 25px; color: #1b1f3b; }
        label { font-weight: 500; color: #333; }
        input[type="text"], textarea, select {
            width: 100%; padding: 10px 12px; margin-top: 5px; margin-bottom: 15px;
            border: 1px solid #ccc; border-radius: 8px; font-size: 15px;
        }
        button { width: 100%; background: #22c1c3; border: none; padding: 12px;
            border-radius: 8px; color: #fff; font-size: 16px; font-weight: 500; cursor: pointer; }
    </style>
</head>

<body>
    <div class="sidebar">
        <h3>ELMS</h3>
        <ul><li onclick="history.back()">← Back</li></ul>
    </div>

    <div class="main">
        <div class="form-container">
            <h2>Create Lesson</h2>
            <form action="${pageContext.request.contextPath}/instructor/CreateLessonServlet" method="post">
                <input type="hidden" name="moduleId" value="${param.moduleId}" />

                <label>Lesson Title:</label>
                <input type="text" name="title" placeholder="Enter title..." required />

                <label>Description:</label>
                <textarea name="content" placeholder="Enter description..."></textarea>

                <label>Select Type:</label>
                <select name="lessonType" required>
                    <option value="video">Video</option>
                    <option value="document">Document</option>
                    <option value="quiz">Quiz</option>
                </select>

                <button type="submit">Save</button>
            </form>
        </div>
    </div>
</body>
</html>
