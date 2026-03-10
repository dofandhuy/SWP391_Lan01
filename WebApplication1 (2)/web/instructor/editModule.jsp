<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Entity.Module, Service.ModuleService" %>

<%
    int moduleId = Integer.parseInt(request.getParameter("moduleId"));
    ModuleService moduleService = new ModuleService();
    Module module = moduleService.getModuleById(moduleId);
%>

<html>
<head>
    <title>Edit Module</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        form {
            background: white;
            padding: 30px;
            border-radius: 10px;
            width: 400px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        input, textarea, button {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
        }
        button {
            background: #22c1c3;
            color: white;
            border: none;
            font-weight: bold;
            cursor: pointer;
        }
        button:hover {
            background: #1aa1a3;
        }
    </style>
</head>
<body>
    <form action="${pageContext.request.contextPath}/EditModuleServlet" method="post">
        <h2>Edit Module</h2>
        <input type="hidden" name="moduleId" value="<%= module.getId() %>">
        <input type="hidden" name="courseId" value="<%= module.getCourseId() %>">

        <label>Module Title:</label>
        <input type="text" name="title" value="<%= module.getTitle() %>" required>

        <label>Description:</label>
        <textarea name="description" rows="4"><%= module.getDescription() != null ? module.getDescription() : "" %></textarea>
        
        

        <button type="submit">Update Module</button>
    </form>
</body>
</html>
