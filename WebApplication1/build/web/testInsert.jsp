<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Test Insert Question</title>
</head>
<body>
<h2>Test Insert Question</h2>
<form action="TestInsertQuestionServlet" method="post">
    <input type="hidden" name="lessonId" value="1"> <!-- thay lessonID theo DB của bạn -->
    <label>Question Content:</label><br>
    <textarea name="questionContent" rows="3" style="width:400px;"></textarea><br><br>

    <label>Question Type:</label><br>
    <select name="questionType">
        <option value="MCQ">Multiple Choice</option>
    <option value="TrueFalse">True / False</option>
    <option value="FillBlank">Short Answer</option>
    </select><br><br>

    <label>Difficulty:</label><br>
    <select name="difficulty">
        <option value="Easy">Easy</option>
        <option value="Medium">Medium</option>
        <option value="Hard">Hard</option>
    </select><br><br>

    <div id="answerInputs">
        <div>
            <input type="text" name="answer1" placeholder="Answer 1">
            <input type="checkbox" name="correct1"> Correct
        </div>
        <div>
            <input type="text" name="answer2" placeholder="Answer 2">
            <input type="checkbox" name="correct2"> Correct
        </div>
    </div>
    <button type="button" onclick="addAnswerInput()">+ Add Option</button>
    <br><br>
    <button type="submit">Insert into DB</button>
</form>

<script>
let answerCount = 2;
function addAnswerInput() {
    answerCount++;
    const container = document.getElementById("answerInputs");
    const div = document.createElement("div");
    div.innerHTML = `
        <input type="text" name="answer${answerCount}" placeholder="Answer ${answerCount}">
        <input type="checkbox" name="correct${answerCount}"> Correct
    `;
    container.appendChild(div);
}
</script>
</body>
</html>