<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">

        <title>Quiz Details: <c:out value="${data.quizTitle}" /></title>

        <style>
            /* Your CSS remains unchanged */
            body {
                font-family: sans-serif;
                background-color: #f9f9f9;
                display: flex;
                justify-content: center;
                padding-top: 50px;
            }
            .container {
                width: 800px;
            }
            .quiz-header h1 {
                font-size: 2.5rem;
                font-weight: bold;
                color: #333;
            }
            .instructor-info {
                font-size: 1.2rem;
                color: #555;
                margin-bottom: 20px;
            }
            .card {
                background-color: #ffffff;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
                padding: 24px;
                margin-bottom: 20px;
            }
            .assignment-details {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background-color: #f0f5ff;
                border: 1px solid #d6e4ff;
            }
            .details-group p {
                margin: 4px 0;
            }
            .details-group .label {
                font-size: 0.9rem;
                font-weight: bold;
                color: #333;
            }
            .details-group .value {
                font-size: 1rem;
                color: #555;
            }
            .details-group .value-highlight {
                font-size: 1rem;
                color: #008000;
                font-weight: bold;
            }
            .start-button {
                background-color: #0056d6;
                color: white;
                font-size: 1rem;
                font-weight: bold;
                padding: 12px 30px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
            }
            .start-button:disabled {
                background-color: #a0a0a0;
                cursor: not-allowed;
            }
            .wait-message {
                color: #d90000;
                font-size: 0.9rem;
                text-align: right;
                margin-top: 5px;
            }
            .grade-details .status {
                color: #666;
                font-size: 0.9rem;
            }
            .grade-details .score {
                font-size: 2rem;
                font-weight: bold;
                color: #333;
                margin-top: 10px;
            }
            .grade-details .score-and-review {
                display: flex; /* Bật Flexbox */
                align-items: center; /* Căn giữa các phần tử theo chiều dọc */
                justify-content: space-between; /* Đẩy điểm sang trái, nút sang phải */
                margin-top: 15px; /* Thêm khoảng cách phía trên */
            }

            .grade-details .score {
                margin-top: 0; /* Xóa margin-top mặc định của score */
                margin-bottom: 0; /* Xóa margin-bottom nếu có */
            }

            .grade-details .review-button {
                /* Điều chỉnh kích thước/margin nút nếu cần */
                padding: 10px 20px; /* Làm nút nhỏ hơn một chút */
                font-size: 0.9rem;
                margin-left: 20px; /* Thêm khoảng cách bên trái nút */
            }
            /* Style cũ cho .result-action vẫn được giữ */
            .result-action {
                display: inline-block;
                text-decoration: none;
                background-color: #007bff;
                color: #ffffff;
                padding: 12px 25px; /* Giữ padding gốc nếu review-button không ghi đè */
                border-radius: 6px;
                font-size: 1rem; /* Giữ font gốc nếu review-button không ghi đè */
                font-weight: 500;
                transition: background-color 0.2s ease;
                margin: 5px; /* Giữ margin gốc nếu review-button không ghi đè */
            }
            .result-action:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>

        <div class="container">

            <div class="quiz-header">
                <h1><c:out value="${data.quizTitle}" /></h1>
            </div>




            <div class="card assignment-details">

                <div class="details-group">
                    <p class="label">Due Date</p>
                    <c:choose>
                        <c:when test="${not empty data.deadline}">
                            <p class="value">
                                <fmt:formatDate value="${data.deadline}" pattern="MMM d, yyyy, hh:mm a Z" />
                            </p>
                        </c:when>
                        <c:otherwise>
                            <p class="value">No due date</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="details-group">
                    <p class="label">Attempts</p>

                    <c:choose>
                        <c:when test="${data.maxAttempts > 0}">
                            <p class="value-highlight">${data.attemptsLeft} left</p>
                            <p class="value">(Max ${data.maxAttempts} attempts
                                <c:if test="${data.attemptCooldownHours > 0}">
                                    , ${data.attemptCooldownHours} hours apart
                                </c:if>
                                )</p>
                            </c:when>
                            <c:otherwise>
                            <p class="value-highlight">Unlimited</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="details-group">
                    <p class="label">Time Limit</p>
                    <p class="value">${data.durationMinutes} minutes</p>
                </div>

                <div class="start-action">
                    <c:choose>
                        <c:when test="${data.canStart}">

                            <a href="DoQuizServlet?quizId=${data.quizId}" class="start-button">Start</a>
                        </c:when>
                        <c:otherwise>
                            <button class="start-button" disabled>Start</button>
                            <p class="wait-message"><c:out value="${data.waitMessage}" /></p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="card grade-details">
                <p class="label">Your Grade</p>

                <c:choose>
                    <c:when test="${not empty data.highestScore}">
                        <p class="status">Your highest score is recorded.</p>

                        <%-- === BỌC ĐIỂM SỐ VÀ NÚT TRONG DIV MỚI === --%>
                        <div class="score-and-review">
                            <p class="score">
                                <fmt:formatNumber value="${data.highestScore.score}" maxFractionDigits="2" />
                            </p>
                            <a href="reviewQuizAttempt?attemptId=${data.highestScore.attemptId}" class="result-action review-button">Review Highest Attempt</a>
                        </div>
                        <%-- ======================================= --%>

                    </c:when>
                    <c:otherwise>
                        <p class="status">You haven't submitted this yet. We keep your highest score.</p>
                        <p class="score">--</p>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>

    </body>
</html>