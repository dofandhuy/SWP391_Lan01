<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quiz Result: <c:out value="${quizTitle}"/></title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #f4f7f6;
            color: #333;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
            box-sizing: border-box;
        }
        .result-container {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            padding: 40px;
            max-width: 600px;
            width: 100%;
            text-align: center;
        }
        .result-icon {
            font-size: 4rem;
            line-height: 1;
            margin-bottom: 20px;
        }
        .result-icon.pass { color: #5cb85c; } /* Green for pass */
        .result-icon.fail { color: #d9534f; } /* Red for fail */
        .result-title {
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .result-quiz-title {
            font-size: 1.1rem;
            color: #555;
            margin-bottom: 25px;
        }
        .result-summary {
            font-size: 1.2rem;
            color: #333;
            margin-bottom: 15px;
        }
        .result-score {
            font-size: 2.5rem;
            font-weight: bold;
            color: #007bff; /* Blue */
            margin-bottom: 30px;
        }
        .result-action {
            display: inline-block;
            text-decoration: none;
            background-color: #007bff;
            color: #ffffff;
            padding: 12px 25px;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 500;
            transition: background-color 0.2s ease;
            margin: 5px;
        }
        .result-action:hover {
            background-color: #0056b3;
        }
        .result-action.secondary {
             background-color: #6c757d; /* Gray */
        }
         .result-action.secondary:hover {
             background-color: #5a6268;
        }
    </style>
</head>
<body>

    <div class="result-container">
        
        <%-- Determine if the student passed --%>
        <c:set var="passed" value="${score >= passingScore}" />

        <div class="result-icon ${passed ? 'pass' : 'fail'}">
            <c:choose>
                <c:when test="${passed}">✅</c:when> <%-- Checkmark for pass --%>
                <c:otherwise>❌</c:otherwise> <%-- Cross mark for fail --%>
            </c:choose>
        </div>

        <h1 class="result-title">
            <c:choose>
                <c:when test="${passed}">Congratulations!</c:when>
                <c:otherwise>Submission Received</c:otherwise>
            </c:choose>
        </h1>
        
        <p class="result-quiz-title">Quiz: <c:out value="${quizTitle}"/></p>

        <p class="result-summary">
            You answered <strong>${correctCount}</strong> out of <strong>${totalQuestions}</strong> questions correctly.
        </p>

        <div class="result-score">
            Your Score: <fmt:formatNumber value="${score}" maxFractionDigits="2" />
        </div>

        <p class="result-status">
            <c:choose>
                <c:when test="${passed}">
                    You have passed the quiz (Passing Score: <fmt:formatNumber value="${passingScore}" maxFractionDigits="2" />).
                </c:when>
                <c:otherwise>
                    You did not meet the passing score (Passing Score: <fmt:formatNumber value="${passingScore}" maxFractionDigits="2" />).
                </c:otherwise>
            </c:choose>
        </p>
        
        <div class="actions">
             <%-- Link back to course/lesson page (adjust URL as needed) --%>
            <a href="ModuleDetailServlet" class="result-action secondary">Back to Course</a> 
            
            <%-- Optional: Link to review the attempt (requires another servlet/JSP) --%>
             <a href="reviewQuizAttempt?attemptId=${attemptId}" class="result-action">Review Attempt</a> 
        </div>

    </div>

</body>
</html>