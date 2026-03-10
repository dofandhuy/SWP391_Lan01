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
                margin: 0;
                padding: 0;
                display: flex;
                height: 100vh;
            }

            /* ===== Sidebar ===== */
            .sidebar {
                width: 220px;
                background-color: #fff;
                border-right: 1px solid #eee;
                padding: 20px;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .sidebar h3 {
                font-weight: 600;
                text-align: center;
                margin-bottom: 20px;
                color: #1b1f3b;
            }

            .sidebar ul {
                list-style: none;
                padding: 0;
            }

            .sidebar li {
                padding: 10px;
                cursor: pointer;
                border-radius: 8px;
                transition: 0.3s;
                color: #333;
            }

            .sidebar li:hover {
                background: #22c1c3;
                color: #fff;
            }

            /* ===== Main ===== */
            .main {
                flex: 1;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .form-container {
                background: #fff;
                padding: 40px 50px;
                border-radius: 16px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.08);
                width: 480px;
            }

            h2 {
                text-align: center;
                margin-bottom: 25px;
                color: #1b1f3b;
            }

            label {
                font-weight: 500;
                color: #333;
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
                outline: none;
                font-size: 15px;
            }

            textarea {
                height: 120px;
                resize: none;
            }

            input[type="file"] {
                width: 100%;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 6px;
                background: #fafafa;
            }

            .checkbox-group {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 15px;
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
        </style>
    </head>

    <body>
        <!-- Sidebar -->
        <div class="sidebar">
            <div>
                <h3>ELMS</h3>
                <ul>
                    <li onclick="history.back()">← Back</li>
                </ul>
            </div>
        </div>

        <!-- Main -->
        <div class="main">
            <div class="form-container">
                <h2>Create Lesson</h2>
                <form action="${pageContext.request.contextPath}/instructor/CreateLessonServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="moduleId" value="${param.moduleId}" />

                    <label>Lesson Title:</label>
                    <input type="text" name="title" placeholder="Enter title..." required />

                    <label>Description:</label>
                    <textarea name="content" placeholder="Enter description..."></textarea>

                    <label>Select Type:</label>
                    <select name="lessonType" required>
                        <option value="video">Video</option>
                        <option value="doc">Document</option>
                        <option value="quiz">Quiz</option>
                    </select>

                    <div class="checkbox-group">
                        <input type="checkbox" id="addFile" name="addFile" onchange="toggleFileUpload(this)">
                        <label for="addFile">Add file</label>
                    </div>

                    <div id="fileUpload" style="display:none;">
                        <label>Select file:</label>
                        <input type="file" name="file" />
                    </div>

                    <button type="submit">Save</button>
                </form>
            </div>
        </div>

        <script>
            function toggleFileUpload(checkbox) {
                document.getElementById('fileUpload').style.display = checkbox.checked ? 'block' : 'none';
            }
        </script>
    </body>
</html>
