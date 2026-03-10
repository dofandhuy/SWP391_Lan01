<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="Entity.Question" %>
<%@ page import="Entity.User" %>
<%@ page import="Service.QuestionService" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("Signin.jsp");
        return;
    }
    QuestionService qs = new QuestionService();
    List<Question> questionList = qs.getQuestionsByUserID(currentUser.getUserID());
    List<String> categories = qs.getAllCategories(currentUser.getUserID());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Quiz</title>
    <style>
        body { font-family: "Poppins", sans-serif; background: #f5fafa; color: #333; margin: 0; padding: 0; display: flex; }
        .sidebar { width: 220px; background-color: #009688; color: white; height: 100vh; position: fixed; top: 0; left: 0; padding-top: 20px; box-shadow: 2px 0 6px rgba(0,0,0,0.1); }
        .sidebar .logo { text-align: center; font-size: 22px; font-weight: 700; margin-bottom: 25px; letter-spacing: 1px; }
        .sidebar a { display: block; color: white; padding: 12px 20px; text-decoration: none; font-weight: 500; transition: background 0.3s, padding-left 0.3s; }
        .sidebar a:hover { background-color: #00796b; padding-left: 25px; }
        .main-content { margin-left: 240px; padding: 25px; width: calc(100% - 240px); }
        h2 { text-align: center; color: #009688; }
        form { background: white; max-width: 900px; margin: 20px auto; padding: 25px; border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        label { font-weight: 600; }
        input[type="text"], input[type="number"], select { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 6px; margin-bottom: 12px; }
        button { color: white; border: none; padding: 10px 18px; border-radius: 8px; font-weight: 600; cursor: pointer; transition: background 0.3s; }
        .btn-create { background-color: #009688; }
        .btn-create:hover { background-color: #00796b; }
        .btn-draft { background-color: #ffc107; color: white; margin-left: 10px; }
        .btn-draft:hover { background-color: #e0a800; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #e0e0e0; padding: 8px 10px; text-align: left; }
        th { background-color: #009688; color: white; }
        tr:nth-child(even) { background-color: #f7f7f7; }
        .checkbox-cell { text-align: center; }
        .section-title { margin-top: 20px; color: #00796b; border-bottom: 2px solid #009688; padding-bottom: 4px; font-weight: 600; }
        .message { text-align: center; margin-bottom: 15px; font-weight: 600; }
        .error { color: red; }
        .success { color: green; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="logo">CreateQuiz</div>
    <a href="<%=request.getContextPath()%>/instructor/courses">🏠 Dashboard</a>
    <a href="QuizListServlet">📋 View Quizzes</a>
</div>
<div class="main-content">
    <h2>Create Quiz</h2>
    <%-- Hiển thị thông báo lỗi hoặc thành công --%>
    <%
        String error = request.getParameter("error");
        String success = request.getParameter("success");
        if ("mismatch".equals(error)) {
    %>
        <p class="message error">❌ Tổng số câu không khớp! Vui lòng kiểm tra lại.</p>
    <%
        } else if ("true".equals(success)) {
    %>
        <p class="message success">✅ Quiz created successfully!</p>
    <%
        } else if ("exception".equals(error)) {
    %>
        <p class="message error">⚠️ Có lỗi xảy ra khi tạo quiz. Vui lòng thử lại.</p>
    <%
        }
    %>
    <form action="CreateQuizServlet" method="post" id="quizForm">
        <input type="hidden" name="status" id="quizStatus" value="Pending">
        <label>Title:</label>
        <input type="text" name="title" required>
        <label>Num of Questions:</label>
        <input type="number" name="numQuestions" required>
        <label>Duration (minutes):</label>
        <input type="number" name="duration" required>
        <label>Passing Score:</label>
        <input type="number" name="passingScore" step="0.1" required>
        <label>Point per Question:</label>
        <input type="number" name="pointPerQuestion" step="0.00001" required>
        <label>Max Attempts:</label>
        <input type="number" name="maxAttempt" value="1" min="1" required>
        <label>Cooldown Hours:</label>
        <input type="number" name="cooldownHours" value="0" min="0" required>
        <label><input type="checkbox" name="random"> Generate Random Questions</label>
        <div class="section-title">If Random, enter number per level and optional Category:</div>
        <label>Easy questions:</label>
        <input type="number" name="easy" value="0" min="0">
        <label>Medium questions:</label>
        <input type="number" name="medium" value="0" min="0">
        <label>Hard questions:</label>
        <input type="number" name="hard" value="0" min="0">
        <label>Category (optional):</label>
        <select name="category">
            <option value="">All</option>
            <% if (categories != null) { for (String cat : categories) { %>
                <option value="<%=cat%>"><%=cat%></option>
            <% } } %>
        </select>
        <div class="section-title">Select from Question Bank:</div>
        <table>
            <thead>
            <tr>
                <th>Select</th>
                <th>Question</th>
                <th>Type</th>
                <th>Category</th>
                <th>Difficulty</th>
                <th>Created At</th>
            </tr>
            </thead>
            <tbody>
            <%
                for (Question q : questionList) {
            %>
            <tr>
                <td class="checkbox-cell">
                    <input type="checkbox" name="selectedQuestions" value="<%= q.getQuestionID() %>">
                </td>
                <td><%= q.getQuestionText() %></td>
                <td><%= q.getQuestionType() %></td>
                <td><%= q.getCategory() %></td>
                <td><%= q.getDifficultyLevel() %></td>
                <td><%= q.getCreatedAt() %></td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
        <div style="text-align:center; margin-top:20px;">
            <button type="submit" name="action" class="btn-create" value="save">Create Quiz</button>
            <button type="submit" name="action" class="btn-draft" value="draft">Save to Draft</button>
        </div>
    </form>
</div>
</body>
</html>