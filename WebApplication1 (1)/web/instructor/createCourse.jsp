<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Create Course</title>
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
            width: 400px;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #1b1f3b;
        }
        input, textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
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
    <h2>Create New Course</h2>
    <form action="${pageContext.request.contextPath}/instructor/courses" method="post">
        <input type="hidden" name="action" value="create">

        <label>Title</label>
        <input type="text" name="title" required>

        <label>Description</label>
        <textarea name="description" rows="4"></textarea>

        <button type="submit">Save</button>
    </form>

    <a href="${pageContext.request.contextPath}/instructor/courses" class="back-link">← Back to Course List</a>
</div>
</body>
</html>
