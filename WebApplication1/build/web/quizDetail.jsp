<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Entity.Quiz, Entity.Question, Entity.AnswerOption, Service.QuestionService, java.util.*" %>
<%
    Quiz quiz = (Quiz) request.getAttribute("quiz");
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    QuestionService qs = new QuestionService();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Detail</title>
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background: #f5fafa;
            margin: 0;
            display: flex;
            height: 100vh;
        }
        .sidebar {
            width: 230px;
            background: linear-gradient(180deg, #009688, #00796b);
            color: white;
            height: 100vh;
            padding-top: 30px;
            box-shadow: 2px 0 8px rgba(0,0,0,0.1);
        }
        .sidebar .logo {
            font-size: 22px;
            font-weight: 600;
            text-align: center;
            margin-bottom: 30px;
        }
        .sidebar a {
            display: block;
            color: white;
            padding: 12px 20px;
            text-decoration: none;
            transition: background 0.3s;
            font-weight: 500;
        }
        .sidebar a:hover {
            background: rgba(255, 255, 255, 0.2);
        }
        .main {
            flex: 1;
            padding: 40px;
            background: #ffffff;
            border-radius: 20px 0 0 20px;
            margin: 30px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            overflow-y: auto;
        }
        h2 { color: #009688; text-align: center; margin-bottom: 10px; }
        p { font-size: 15px; color: #333; margin: 6px 0; }
        h3 { color: #00796b; margin-top: 25px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        th { background-color: #009688; color: white; padding: 12px; text-align: left; font-weight: 600; letter-spacing: 0.5px; }
        td { padding: 10px 12px; border-bottom: 1px solid #eee; color: #333; vertical-align: top; }
        tr:hover { background: #f1fdfb; }
        ul { margin: 0; padding-left: 18px; }
        i { color: #666; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="logo">📘 Quiz Detail</div>
    <a href="QuizListServlet">⬅ Back to Quizzes</a>
</div>
<div class="main">
<% if (quiz != null) { %>
    <h2><%= quiz.getTitle() %></h2>
    <p><b>🕒 Duration:</b> <%= quiz.getDurationMinutes() %> minutes</p>
    <p><b>🎯 Passing Score:</b> <%= quiz.getPassingScore() %></p>
    <p><b>💡 Points per Question:</b> <%= quiz.getPointPerQuestion() %></p>
    <p><b>💡 Attempts:</b> <%= quiz.getMaxAttempts() %></p>
    <p><b>💡 Cooldown Hour:</b> <%= quiz.getAttemptCooldownHours() %></p>

    <h3>📋 Questions:</h3>
    <% if (questions != null && !questions.isEmpty()) { %>
    <table>
        <tr>
            <th>ID</th>
            <th>Text</th>
            <th>Options</th>
            <th>Correct Answer</th>
            <th>Category</th>
        </tr>
        <% for (Question q : questions) { 
               List<AnswerOption> options = qs.getOptionsByQuestionID(q.getQuestionID());
        %>
        <tr>
            <td><%= q.getQuestionID() %></td>
            <td><%= q.getQuestionText() %></td>
            <td>
                <ul>
                <% for (AnswerOption opt : options) { %>
                    <li><%= opt.getAnswerText() %></li>
                <% } %>
                </ul>
            </td>
            <td>
                <ul>
                <% for (AnswerOption opt : options) { 
                       if(opt.isCorrect()) { %>
                    <li><%= opt.getAnswerText() %></li>
                <% } } %>
                </ul>
            </td>
            <td><%= q.getCategoryName() %></td>
        </tr>
        <% } %>
    </table>
    <% } else { %>
        <p><i>No questions found for this quiz.</i></p>
    <% } %>
<% } else { %>
    <p style="color:red;">Quiz not found.</p>
<% } %>
</div>
</body>
</html>