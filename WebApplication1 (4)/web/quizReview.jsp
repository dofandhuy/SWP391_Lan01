<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Quiz Review: <c:out value="${reviewData.quizTitle}"/></title>
        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                background-color: #f6f8fa;
                color: #333;
                display: flex;
                justify-content: center;
                padding: 40px 15px;
            }
            .container {
                width: 100%;
                max-width: 900px;
                background-color: #fff;
                border-radius: 14px;
                box-shadow: 0 4px 16px rgba(0,0,0,0.1);
                overflow: hidden;
            }
            /* ========== HEADER ========== */
            .review-header {
                padding: 25px 35px;
                background: linear-gradient(135deg, #d7f8e4, #b8ebcb);
                border-bottom: 1px solid #e0e0e0;
            }
            .header-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 10px;
            }
            .back-btn-inline {
                background-color: #007bff;
                color: white;
                padding: 8px 14px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: 600;
                transition: background-color 0.25s;
            }
            .back-btn-inline:hover {
                background-color: #0056b3;
            }
            .review-header h1 {
                font-size: 1.4rem;
                font-weight: 700;
                color: #222;
                margin: 0;
                text-align: center;
                flex: 1;
            }
            .score-inline {
                font-size: 1.3rem;
                font-weight: 700;
                color: #222;
                background: white;
                border: 3px solid #28a745;
                padding: 8px 16px;
                border-radius: 50px;
                min-width: 70px;
                text-align: center;
            }
            .review-header .desc {
                margin-top: 10px;
                font-size: 0.95rem;
                color: #555;
                text-align: center;
            }
            /* ========== QUESTIONS ========== */
            .question-list {
                padding: 30px 40px;
            }
            .question-item {
                border: 1px solid #e2e8f0;
                border-radius: 12px;
                padding: 20px 25px;
                margin-bottom: 25px;
                background-color: #fafafa;
                transition: box-shadow 0.2s, transform 0.2s;
            }
            .question-item:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.05);
            }
            .question-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 12px;
                flex-wrap: wrap;
            }
            .question-number {
                font-weight: 700;
                color: #007bff;
                margin-right: 10px;
            }
            .question-text {
                flex: 1;
                font-size: 1.05rem;
                color: #222;
            }
            .points-fraction {
                font-size: 0.9rem;
                color: #666;
                white-space: nowrap;
            }

            /* ========== OPTIONS ========== */
            .option-item {
                display: flex;
                align-items: flex-start;
                padding: 10px 14px;
                border-radius: 8px;
                border: 1px solid #ddd;
                margin-bottom: 10px;
            }
            .option-item label {
                flex: 1;
                font-size: 0.95rem;
                cursor: default;
            }
            .option-item.correct-answer {
                border-color: #5cb85c;
                background-color: #e8f6e8;
                font-weight: 600;
            }
            .option-item.incorrect-selection {
                border-color: #d9534f;
                background-color: #fae8e8;
            }
            .option-item input[type="radio"] {
                margin-right: 10px;
            }

            /* ========== FILL BLANK ========== */
            .fill-blank-review {
                margin-top: 8px;
                font-size: 1rem;
            }
            .fill-blank-review .student-answer {
                padding: 3px 6px;
                border-radius: 4px;
            }
            .fill-blank-review .student-answer.correct {
                background-color: #dff0d8;
                color: #3c763d;
                font-weight: 600;
            }
            .fill-blank-review .student-answer.incorrect {
                background-color: #f2dede;
                color: #a94442;
            }

            /* ========== FEEDBACK ========== */
            .feedback {
                margin-top: 12px;
                padding: 10px 12px;
                border-radius: 8px;
                font-size: 0.9rem;
                font-weight: 600;
            }
            .feedback.correct {
                background-color: #e8f6e8;
                border: 1px solid #c6e3c6;
                color: #2f6f2f;
            }
            .feedback.incorrect {
                background-color: #fae8e8;
                border: 1px solid #e2b4b4;
                color: #842029;
            }
            @media (max-width: 600px) {
                .review-header, .question-list {
                    padding: 20px;
                }
                .question-item {
                    padding: 15px;
                }
                .back-btn-inline {
                    padding: 8px 14px;
                    font-size: 0.9rem;
                }
            }
        </style>
    </head>

    <body>
        <!-- ========== TÍNH TOÁN SỐ CÂU ĐÚNG ========== -->
        <c:set var="correctCount" value="0" />
        <c:set var="totalCount" value="${fn:length(reviewData.questions)}" />

        <c:forEach var="q" items="${reviewData.questions}">
            <c:set var="a" value="${reviewData.studentAnswersMap[q.questionID]}" />
            <c:if test="${a != null && a.correct}">
                <c:set var="correctCount" value="${correctCount + 1}" />
            </c:if>
        </c:forEach>

        <c:set var="scorePercent" value="${(correctCount * 10.0) / totalCount}" />

        <div class="container">
            <!-- ========== HEADER ========== -->
            <div class="review-header">
                <div class="header-row">
                    <a href="javascript:history.back()" class="back-btn-inline">← Back</a>
                    <h1>Quiz Review: <c:out value="${reviewData.quizTitle}"/></h1>
                    <div class="score-inline">
                        <fmt:formatNumber value="${scorePercent}" maxFractionDigits="2" />
                    </div>
                </div>
                <p class="desc">
                    You answered 
                    <strong>${correctCount}</strong> / <strong>${totalCount}</strong> questions correctly 

                </p>
            </div>

            <!-- ========== QUESTIONS ========== -->
            <div class="question-list">
                <c:forEach var="question" items="${reviewData.questions}" varStatus="loop">
                    <c:set var="studentAttempt" value="${reviewData.studentAnswersMap[question.questionID]}" />
                    <c:set var="allOptions" value="${reviewData.allOptionsMap[question.questionID]}" />

                    <div class="question-item">
                        <div class="question-header">
                            <span class="question-number">Q${loop.count}</span>
                            <div class="question-text"><c:out value="${question.questionText}" /></div>

                        </div>

                        <div class="options-group">
                            <c:choose>
                                <c:when test="${question.questionType eq 'MCQ' || question.questionType eq 'TrueFalse'}">
                                    <c:forEach var="option" items="${allOptions}">
                                        <c:set var="isSelected" value="${studentAttempt != null && studentAttempt.studentAnswer eq option.answerID}" />
                                        <c:set var="optionStyle" value="" />
                                        <c:choose>
                                            <c:when test="${isSelected && option.correct}">
                                                <c:set var="optionStyle" value="correct-answer" />
                                            </c:when>
                                            <c:when test="${isSelected && !option.correct}">
                                                <c:set var="optionStyle" value="incorrect-selection" />
                                            </c:when>
                                        </c:choose>
                                        <div class="option-item ${optionStyle}">
                                            <input type="radio" disabled <c:if test="${isSelected}">checked</c:if>>
                                            <label><c:out value="${option.answerText}" /></label>
                                        </div>
                                    </c:forEach>
                                </c:when>

                                <c:when test="${question.questionType eq 'FillBlank'}">
                                    <div class="fill-blank-review">
                                        Your answer:
                                        <span class="student-answer ${studentAttempt != null && studentAttempt.correct ? 'correct' : 'incorrect'}">
                                            <c:out value="${studentAttempt.studentAnswer}" />
                                        </span>
                                    </div>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </body>
</html>
