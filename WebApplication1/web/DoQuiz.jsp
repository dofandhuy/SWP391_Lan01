<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Quiz: <c:out value="${quizData.quizTitle}" /></title>
        <style>
            body {
                font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                background-color: #eef1f5;
                margin: 0;
                padding: 20px;
                display: flex;
                justify-content: center;
            }
            .container {
                width: 100%;
                max-width: 1100px;
                display: flex;
                background: #fff;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                border-radius: 12px;
                overflow: hidden;
                min-height: 90vh;
            }

            /* === SIDEBAR KHU RIÊNG CHO DANH SÁCH CÂU HỎI === */
            .sidebar {
                width: 280px;
                background: #fafbfc;
                border-right: 1px solid #ddd;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                padding: 20px;
            }
            .sidebar h3 {
                text-align: center;
                font-size: 1.1rem;
                color: #222;
                margin-bottom: 15px;
            }

            /* === KHUNG CHỨA DANH SÁCH CÂU HỎI === */
            .question-nav {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(55px, 1fr));
                gap: 10px;
                justify-items: center;
                padding: 10px;
                background-color: #fff;
                border: 1px solid #ddd;
                border-radius: 10px;
                box-shadow: inset 0 1px 3px rgba(0,0,0,0.05);
            }
            .question-btn {
                width: 45px;
                height: 45px;
                border: none;
                border-radius: 10px;
                font-weight: bold;
                cursor: pointer;
                transition: all 0.2s;
            }
            .question-btn.unanswered {
                background-color: #e9ecef;
                color: #333;
            }
            .question-btn.answered {
                background-color: #28a745;
                color: white;
            }
            .question-btn.active {
                background-color: #007bff;
                color: white;
                transform: scale(1.05);
            }

            /* === KHU NÚT Ở DƯỚI SIDEBAR === */
            .control-panel {
                background-color: #fff;
                border: 1px solid #ddd;
                border-radius: 10px;
                padding: 15px;
                margin-top: 15px;
                box-shadow: inset 0 1px 3px rgba(0,0,0,0.05);
            }
            .bottom-controls {
                display: flex;
                justify-content: space-between;
                gap: 8px;
            }
            .nav-btn, .submit-btn {
                flex: 1;
                background-color: #6c757d;
                color: white;
                padding: 10px 0;
                border: none;
                border-radius: 6px;
                font-size: 0.9rem;
                cursor: pointer;
                transition: 0.2s;
            }
            .nav-btn:hover, .submit-btn:hover {
                background-color: #5a6268;
            }
            .nav-btn:disabled {
                opacity: 0.6;
                cursor: not-allowed;
            }
            .submit-btn {
                background-color: #007bff;
            }
            .submit-btn:hover {
                background-color: #0056b3;
            }

            /* === MAIN CONTENT === */
            .main-content {
                flex-grow: 1;
                padding: 30px;
                overflow-y: auto;
            }
            .quiz-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 2px solid #eee;
                padding-bottom: 10px;
                margin-bottom: 20px;
            }
            .quiz-header h2 {
                font-size: 1.4rem;
                color: #333;
            }

            .question-card {
                display: none;
                background: #fff;
                border: 1px solid #ddd;
                border-radius: 10px;
                padding: 25px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.05);
                animation: fadeIn 0.3s ease-in-out;
            }
            .question-card.active {
                display: block;
            }
            .question-text {
                font-size: 1.1rem;
                font-weight: 500;
                color: #333;
                margin-bottom: 15px;
            }
            .question-points {
                background-color: #e0f7fa;
                color: #00796b;
                padding: 5px 10px;
                border-radius: 4px;
                font-size: 0.85rem;
                font-weight: bold;
                display: inline-block;
                margin-bottom: 10px;
            }

            .option-item {
                margin-bottom: 10px;
                display: flex;
                align-items: flex-start;
            }
            .option-item input[type="radio"] {
                margin-right: 10px;
                margin-top: 5px;
            }
            .option-item label {
                cursor: pointer;
                color: #444;
            }
            .fill-blank-input {
                width: 80%;
                padding: 8px 12px;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-size: 1rem;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>
    </head>
    <body>

        <div class="container">

            <!-- === SIDEBAR === -->
            <div class="sidebar">
                <div>
                    <h3>Question List</h3>
                    <div class="question-nav">
                        <c:forEach var="question" items="${quizData.questions}" varStatus="loop">
                            <button type="button"
                                    class="question-btn unanswered ${loop.first ? 'active' : ''}"
                                    id="btn-${loop.index}"
                                    onclick="showQuestion(${loop.index})">
                                ${loop.count}
                            </button>
                        </c:forEach>
                    </div>
                </div>

                <!-- === KHU NÚT BACK / NEXT / SUBMIT === -->
                <div class="control-panel">
                    <div class="bottom-controls">
                        <button type="button" class="nav-btn" onclick="prevQuestion()" id="prevBtn">Back</button>
                        <button type="button" class="nav-btn" onclick="nextQuestion()" id="nextBtn">Next</button>
                        <button type="submit" form="quizForm" class="submit-btn">Submit</button>
                    </div>
                </div>
            </div>

            <!-- === MAIN CONTENT === -->
            <div class="main-content">
                <div class="quiz-header">
                    <h2><c:out value="${quizData.quizTitle}" /></h2>
                </div>

                <form id="quizForm" action="SubmitQuizServlet" method="post">
                    <input type="hidden" name="attemptId" value="${quizData.attemptId}">
                    <input type="hidden" name="quizId" value="${quizData.quizId}">

                    <c:forEach var="question" items="${quizData.questions}" varStatus="loop">
                        <div class="question-card ${loop.first ? 'active' : ''}" id="question-${loop.index}">

                            <div class="question-text">
                                ${loop.count}. <c:out value="${question.questionText}" />
                            </div>

                            <div class="options-group">
                                <c:choose>
                                    <c:when test="${question.questionType eq 'MCQ' || question.questionType eq 'TrueFalse'}">
                                        <c:forEach var="option" items="${question.options}">
                                            <div class="option-item">
                                                <input type="radio"
                                                       id="q${question.questionID}o${option.answerID}"
                                                       name="q${question.questionID}"
                                                       value="${option.answerID}"
                                                       onchange="markAnswered(${loop.index})">
                                                <label for="q${question.questionID}o${option.answerID}">
                                                    <c:out value="${option.answerText}" />
                                                </label>
                                            </div>
                                        </c:forEach>
                                    </c:when>

                                    <c:when test="${question.questionType eq 'FillBlank'}">
                                        <input type="text"
                                               name="q${question.questionID}"
                                               class="fill-blank-input"
                                               placeholder="Your answer"
                                               oninput="markAnswered(${loop.index})" />
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </form>
            </div>
        </div>

        <script>
            let currentIndex = 0;
            const totalQuestions = document.querySelectorAll('.question-card').length;

            function showQuestion(index) {
                document.querySelectorAll('.question-card').forEach(q => q.classList.remove('active'));
                document.getElementById('question-' + index).classList.add('active');

                document.querySelectorAll('.question-btn').forEach(b => b.classList.remove('active'));
                document.getElementById('btn-' + index).classList.add('active');

                currentIndex = index;
                updateNavButtons();
                scrollToTop();
            }

            function nextQuestion() {
                if (currentIndex < totalQuestions - 1)
                    showQuestion(currentIndex + 1);
            }

            function prevQuestion() {
                if (currentIndex > 0)
                    showQuestion(currentIndex - 1);
            }

            function updateNavButtons() {
                document.getElementById('prevBtn').disabled = (currentIndex === 0);
                document.getElementById('nextBtn').disabled = (currentIndex === totalQuestions - 1);
            }

            function scrollToTop() {
                document.querySelector('.main-content').scrollTo({top: 0, behavior: 'smooth'});
            }

            function markAnswered(index) {
                const btn = document.getElementById('btn-' + index);
                btn.classList.remove('unanswered');
                btn.classList.add('answered');
            }

            updateNavButtons();
        </script>

    </body>
</html>
