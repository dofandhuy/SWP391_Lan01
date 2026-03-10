<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Edit Course</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #fafafa;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 80px auto;
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        input, textarea {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }
        button {
            background: #22c1c3;
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 8px;
            cursor: pointer;
            margin-top: 15px;
            transition: 0.3s;
        }
        button:hover {
            background: #1aa3a5;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Edit Course</h2>

    <form action="${pageContext.request.contextPath}/instructor/courses" method="post">
        <input type="hidden" name="action" value="edit">
        <input type="hidden" name="courseId" value="${param.courseId}">

        <label>Title</label>
        <input type="text" name="title" value="${param.title}" required>

        <label>Description</label>
        <textarea name="description" rows="4">${param.description}</textarea>

        <button type="submit">Save Changes</button>
    </form>
</div>
</body>
</html>
