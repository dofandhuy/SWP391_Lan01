<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Entity.Question"%>
<%@ page import="Entity.AnswerOption"%>
<%@ page import="java.util.List"%>
<%
    Question question = (Question) request.getAttribute("question");
    List<AnswerOption> options = (List<AnswerOption>) request.getAttribute("options");
    String createdByName = (String) request.getAttribute("createdByName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Question</title>
    <style>
        body { font-family: Arial; background:#f4f6f9; margin:0; padding:20px; }
        .container { background:white; padding:20px; border-radius:8px; box-shadow:0 4px 6px rgba(0,0,0,0.1); max-width:800px; margin:auto; }
        h2 { text-align:center; color:#333; margin-bottom:20px; }
        table { width:100%; border-collapse:collapse; margin-top:10px; }
        table th, table td { border:1px solid #ddd; padding:10px; text-align:left; }
        table th { background:#007bff; color:white; }
        .back-btn { display:inline-block; margin-top:20px; padding:8px 16px; background:#28a745; color:white; text-decoration:none; border-radius:5px; }
    </style>
</head>
<body>
<div class="container">
    <h2>Question Details</h2>
    <p><strong>ID:</strong> <%= question.getQuestionID() %></p>
    <p><strong>Question:</strong> <%= question.getQuestionText() %></p>
    <p><strong>Subject:</strong> <%= question.getCategoryName() %></p>
    <p><strong>Difficulty:</strong> <%= question.getDifficultyLevel() %></p>
    <p><strong>Created By:</strong> <%= createdByName %></p>
    <p><strong>Status:</strong> <%= question.getStatus() != null ? question.getStatus() : "Unknown" %></p>

    <h3>Answer Options</h3>
    <table>
        <thead>
            <tr>
                <th>Answer Text</th>
                <th>Correct</th>
            </tr>
        </thead>
        <tbody>
            <%
                if (options != null) {
                    for (AnswerOption o : options) {
            %>
            <tr>
                <td><%= o.getAnswerText() %></td>
                <td><%= o.isCorrect() ? "Yes" : "No" %></td>
            </tr>
            <%
                    }
                }
            %>
        </tbody>
    </table>

    <a href="questionBank.jsp" class="back-btn">Back to Question Bank</a>
</div>
</body>
</html>