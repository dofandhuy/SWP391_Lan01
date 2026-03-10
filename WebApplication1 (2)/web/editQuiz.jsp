<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="Entity.Quiz" %>
<%@ page import="Entity.Question" %>
<%@ page import="Entity.AnswerOption" %>
<%@ page import="Service.QuestionService" %>
<%
    Quiz quiz = (Quiz) request.getAttribute("quiz");
    List<Question> quizQuestions = (List<Question>) request.getAttribute("quizQuestions");
    List<Question> questionBank = (List<Question>) request.getAttribute("questionBank");
    QuestionService qs = new QuestionService();

    if (quiz == null) {
        response.sendRedirect("QuizListServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Quiz</title>
<style>
body { font-family: "Poppins", sans-serif; background: #f5fafa; color: #333; margin:0; display:flex;}
.sidebar { width:220px; background:#009688; color:white; height:100vh; position:fixed; top:0; left:0; padding-top:20px;}
.sidebar .logo {text-align:center; font-size:22px; font-weight:700; margin-bottom:25px;}
.sidebar a {display:block; color:white; padding:12px 20px; text-decoration:none;}
.sidebar a:hover {background:#00796b;}
.main-content {margin-left:240px; padding:25px; width:calc(100% - 240px);}
h2 {text-align:center; color:#009688;}
form {background:white; max-width:1000px; margin:20px auto; padding:25px; border-radius:12px; box-shadow:0 4px 8px rgba(0,0,0,0.1);}
label {font-weight:600;}
input[type="text"], input[type="number"] {width:100%; padding:8px; border:1px solid #ddd; border-radius:6px; margin-bottom:12px;}
button {padding:8px 14px; border:none; border-radius:6px; font-weight:600; cursor:pointer; transition:0.3s;}
button:hover {opacity:0.9;}
button.add-btn {background:#43a047; margin-top:10px; color:white;}
button.delete-btn {background:#e53935; color:white;}
table {width:100%; border-collapse:collapse; margin-top:15px;}
th, td {border:1px solid #e0e0e0; padding:8px 10px; text-align:left;}
th {background:#009688; color:white;}
tr:nth-child(even) {background:#f7f7f7;}
.actions {text-align:center;}
ul {margin:0; padding-left:15px;}
.error {color:red; font-weight:bold; margin-bottom:15px;}
</style>
</head>
<body>
<div class="sidebar">
    <div class="logo">EditQuiz</div>
    <a href="<%=request.getContextPath()%>/instructor/courses">🏠 Dashboard</a>
    <a href="QuizListServlet">📋 View Quizzes</a>
</div>
<div class="main-content">
<h2>Edit Quiz</h2>
<% if(request.getAttribute("errorMessage") != null) { %>
    <div class="error"><%=request.getAttribute("errorMessage") %></div>
<% } %>

<form action="EditQuizServlet" method="post">
    <input type="hidden" name="quizID" value="<%=quiz.getQuizID()%>">
<input type="hidden" name="categoryID" value="<%= quiz.getCategoryID() != null ? quiz.getCategoryID() : "-1" %>">

    <label>Title:</label>
    <input type="text" name="title" value="<%=quiz.getTitle() != null ? quiz.getTitle() : "" %>" required>

    <label>Duration (minutes):</label>
    <input type="number" name="duration" value="<%=quiz.getDurationMinutes() != null ? quiz.getDurationMinutes() : 0 %>" min="0">

    <label>Passing Score:</label>
    <input type="number" name="passingScore" value="<%=quiz.getPassingScore() != null ? quiz.getPassingScore() : 0 %>" step="0.1" min="0">

    <label>Point per Question:</label>
    <input type="number" name="pointPerQuestion" value="<%=quiz.getPointPerQuestion() != null ? quiz.getPointPerQuestion() : 0 %>" step="0.01" min="0">

    <label>Max Attempts (0 = Unlimited):</label>
    <input type="number" name="maxAttempts" value="<%=quiz.getMaxAttempts() != null ? quiz.getMaxAttempts() : 0 %>" min="0">

    <label>Attempt Cooldown (hours):</label>
    <input type="number" name="attemptCooldown" value="<%=quiz.getAttemptCooldownHours() != null ? quiz.getAttemptCooldownHours() : 0 %>" min="0">

    <!-- Current Questions -->
    <h3 style="color:#00796b; border-bottom:2px solid #009688;">Current Questions in Quiz</h3>
    <table>
        <thead>
            <tr>
                <th>Remove?</th>
                <th>Question</th>
                <th>Category</th>
                <th>Options</th>
                <th>Correct Answer(s)</th>
            </tr>
        </thead>
        <tbody>
        <% for (Question q : quizQuestions) { 
               List<AnswerOption> options = qs.getOptionsByQuestionID(q.getQuestionID());
        %>
            <tr>
                <td style="text-align:center;">
                    <input type="checkbox" name="questionsToDelete" value="<%=q.getQuestionID()%>">
                </td>
                <td><%=q.getQuestionText() %></td>
                <td><%=q.getCategoryName() != null ? q.getCategoryName() : "-" %></td>
                <td>
                    <ul>
                        <% for (AnswerOption opt : options) { %>
                            <li><%=opt.getAnswerText()%></li>
                        <% } %>
                    </ul>
                </td>
                <td>
                    <ul>
                        <% for (AnswerOption opt : options) { if(opt.isCorrect()){ %>
                            <li><%=opt.getAnswerText()%></li>
                        <% } } %>
                    </ul>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>

    <!-- Add Questions -->
    <h3 style="color:#00796b; border-bottom:2px solid #009688;">Add Questions from Question Bank</h3>
    <table>
        <thead>
            <tr>
                <th>Add?</th>
                <th>Question</th>
                <th>Category</th>
                <th>Options</th>
                <th>Correct Answer(s)</th>
            </tr>
        </thead>
        <tbody>
        <% for (Question q : questionBank) { 
               List<AnswerOption> options = qs.getOptionsByQuestionID(q.getQuestionID());
        %>
            <tr>
                <td style="text-align:center;">
                    <input type="checkbox" name="questionsToAdd" value="<%=q.getQuestionID()%>">
                </td>
                <td><%=q.getQuestionText() %></td>
                <td><%=q.getCategoryName() != null ? q.getCategoryName() : "-" %></td>
                <td>
                    <ul>
                        <% for (AnswerOption opt : options) { %>
                            <li><%=opt.getAnswerText()%></li>
                        <% } %>
                    </ul>
                </td>
                <td>
                    <ul>
                        <% for (AnswerOption opt : options) { if(opt.isCorrect()){ %>
                            <li><%=opt.getAnswerText()%></li>
                        <% } } %>
                    </ul>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>

    <div style="text-align:center; margin-top:20px;">
        <button type="submit" name="status" value="Draft" class="add-btn">💾 Update to Draft</button>
        <button type="submit" name="status" value="Pending" class="add-btn">💾 Update to Complete</button>
    </div>
</form>
</div>
</body>
</html>
