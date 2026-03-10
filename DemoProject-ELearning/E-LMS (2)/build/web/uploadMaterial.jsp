<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Upload Material</title>

    <style>

        body { font-family: Arial, sans-serif; background: #f4f6f9; display: flex; justify-content: center; align-items: center; min-height: 100vh; }

        .container { background:#fff; padding:30px 40px; border-radius:12px; box-shadow:0 4px 12px rgba(0,0,0,0.08); width:420px; }

        label{ font-weight:bold; display:block; margin-bottom:6px; color:#444; }

        input[type="number"], input[type="text"], input[type="file"] { width:100%; padding:10px; margin-bottom:15px; border:1px solid #ccc; border-radius:8px; font-size:14px; }

        input[type="submit"] { width:100%; padding:12px; border:none; background:#4CAF50; color:white; font-size:16px; border-radius:8px; cursor:pointer; }

        .msg { text-align:center; margin-bottom:12px; padding:10px; border-radius:6px; }

        .error { background:#ffe6e6; color:#a33; border:1px solid #f5c6c6; }

        .success { background:#e6ffef; color:#177a3a; border:1px solid #c9f0d9; }

    </style>

</head>

<body>

<div class="container">

    <h2 style="text-align:center; margin-bottom:18px;">Upload Material</h2>

    <% String error = (String) request.getAttribute("error"); %>

    <% if (error != null) { %>

        <div class="msg error"><%= error %></div>

    <% } %>

    <form action="UploadFile" method="post" enctype="multipart/form-data">

        <label>Class Name:</label>

        <input type="text" name="className" value="<%= request.getParameter("className") != null ? request.getParameter("className") : "" %>" required>

        <label>Title:</label>

        <input type="text" name="title" value="<%= request.getParameter("title") != null ? request.getParameter("title") : "" %>" required>

        <label>Person upload:</label>

        <input type="text" name="uploadedBy" value="<%= request.getParameter("uploadedBy") != null ? request.getParameter("uploadedBy") : "" %>" required>

        <label>Select file:</label>

        <input type="file" name="file" required>

        <input type="submit" value="Upload">

    </form>

</div>

</body>

</html>
