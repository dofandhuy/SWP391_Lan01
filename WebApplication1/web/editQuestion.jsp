<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Entity.Question, Entity.AnswerOption, java.util.List, Entity.User" %>

<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("Signin.jsp");
        return;
    }

    Question question = (Question) request.getAttribute("question");
    List<AnswerOption> options = (List<AnswerOption>) request.getAttribute("options");
    List<String> categories = (List<String>) request.getAttribute("categories");

    if (question == null || options == null) {
        response.sendRedirect("questionBank.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Question</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f4f6f9; margin:0; padding:0; display:flex; }
        .sidebar { width:220px; background:#009688; min-height:100vh; padding:20px 0; color:white; box-shadow:2px 0 5px rgba(0,0,0,0.1); }
        .logo { font-size:1.5em; font-weight:700; text-align:center; padding:0 0 30px 0; border-bottom:1px solid rgba(255,255,255,0.1); margin-bottom:15px; }
        .sidebar a { display:block; padding:12px 20px; margin:5px 10px; color:#e0f2f1; text-decoration:none; border-radius:6px; transition:0.3s; font-weight:500; }
        .sidebar a:hover { background:#00796b; color:#fff; }
        .sidebar a.active { background:#4db6ac; color:#fff; box-shadow:0 2px 5px rgba(0,0,0,0.2); }
        .main { flex:1; padding:30px; }
        .container { background:white; padding:20px; border-radius:8px; box-shadow:0 4px 6px rgba(0,0,0,0.1); max-width:800px; margin:auto; }
        h2 { text-align:center; margin-bottom:20px; color:#333; }
        .form-group { margin-bottom:15px; }
        label { display:block; margin-bottom:5px; font-weight:600; }
        input[type="text"], select { width:100%; padding:8px; border:1px solid #ccc; border-radius:5px; }
        .answer-option { display:flex; align-items:center; margin-bottom:8px; gap:10px; }
        .btn { padding:8px 16px; border:none; border-radius:5px; cursor:pointer; font-size:14px; }
        .btn-submit { background:#28a745; color:white; }
        .btn-back { background:#007bff; color:white; text-decoration:none; display:inline-block; margin-top:10px; padding:8px 16px; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="logo">QuizMaster</div>
    <a href="<%=request.getContextPath()%>/instructor/courses">Dashboard</a>
    <a href="<%=request.getContextPath()%>/CreateQuestionServlet">Create Question</a>
    <a href="questionBank.jsp" class="active">Question Bank</a>
</div>

<div class="main">
    <div class="container">
        <h2>Edit Question</h2>
        <form action="EditQuestionServlet" method="post">
            <input type="hidden" name="questionID" value="<%= question.getQuestionID() %>">

            <div class="form-group">
                <label for="questionText">Question Text</label>
                <input type="text" id="questionText" name="questionText" value="<%= question.getQuestionText() %>" required>
            </div>

            <div class="form-group">
                <label for="category">Category</label>
                <select id="category" name="category" required>
                    <% if (categories != null && !categories.isEmpty()) {
                           for (String c : categories) { %>
                        <option value="<%= c %>" <%= c.equals(question.getCategoryName()) ? "selected" : "" %>><%= c %></option>
                    <%   }
                       } else { %>
                        <option value="">No Available Category</option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label for="difficulty">Difficulty Level</label>
                <select id="difficulty" name="difficulty" required>
                    <option value="Easy" <%= "Easy".equals(question.getDifficultyLevel()) ? "selected" : "" %>>Easy</option>
                    <option value="Medium" <%= "Medium".equals(question.getDifficultyLevel()) ? "selected" : "" %>>Medium</option>
                    <option value="Hard" <%= "Hard".equals(question.getDifficultyLevel()) ? "selected" : "" %>>Hard</option>
                </select>
            </div>

            <div class="form-group">
                <label>Answer Options</label>
                <% for (AnswerOption o : options) { %>
                    <div class="answer-option">
                        <input type="hidden" name="answerID" value="<%= o.getAnswerID() %>">
                        <input type="text" name="answerText" value="<%= o.getAnswerText() %>" required>
                        <input type="radio" name="correctAnswer" value="<%= o.getAnswerID() %>"
                               <%= o.isCorrect() ? "checked" : "" %> > Correct
                    </div>
                <% } %>
            </div>

            <input type="hidden" name="status" id="status" value="<%= question.getStatus() %>">

            <button type="submit" class="btn btn-submit" onclick="document.getElementById('status').value='Draft';">
                Update with Draft
            </button>
            <button type="submit" class="btn btn-submit" style="background:#007bff;"
                    onclick="document.getElementById('status').value='Pending';">
                Update with Complete
            </button>

            <a href="questionBank.jsp" class="btn-back">Back</a>
        </form>
    </div>
</div>
</body>
</html>