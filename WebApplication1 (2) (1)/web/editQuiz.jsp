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
.count {font-weight:700; color:#00796b;}
.count.warning {color:#d32f2f;}
.modal { display: none; position: fixed; z-index:1000; left:0; top:0; width:100%; height:100%; background: rgba(0,0,0,0.4);}
.modal-content { background: white; margin: 5% auto; padding: 20px; border-radius: 10px; width: 80%; max-height: 80vh; overflow-y: auto; box-shadow: 0 5px 15px rgba(0,0,0,0.3);}
.close { color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer;}
.close:hover { color: #000; }
.table-container { max-height: 60vh; overflow-y: auto; }
.search-input { width:50%; padding:6px 10px; border-radius:6px; border:1px solid #ccc; margin-bottom:10px; display:block; margin-left:auto; margin-right:auto;}
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
  
    <label>Max Attempts (0 = Unlimited):</label>
    <input type="number" name="maxAttempts" value="<%=quiz.getMaxAttempts() != null ? quiz.getMaxAttempts() : 0 %>" min="0">
    <label>Attempt Cooldown (hours):</label>
    <input type="number" name="attemptCooldown" value="<%=quiz.getAttemptCooldownHours() != null ? quiz.getAttemptCooldownHours() : 0 %>" min="0">

    <h3 style="color:#00796b; border-bottom:2px solid #009688;">
    Current Questions in Quiz ( Number Question:  <span id="quizCount"><%= quizQuestions.size() %></span>)
    </h3>

    <table id="currentQuestionsTable">
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
            <tr data-questionid="<%=q.getQuestionID()%>">
                <td style="text-align:center;">
                    <input type="checkbox" name="questionsToDeleteCheckbox" value="<%=q.getQuestionID()%>">
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

    <!-- Container lưu input ẩn khi xoá -->
    <div id="deletedQuestionsContainer"></div>

    <div style="text-align:center; margin-top:10px;">
        <button type="button" class="delete-btn" onclick="deleteSelectedQuestions()">🗑 Delete Selected</button>
    </div>

    <div style="text-align:center; margin-top:25px;">
        <button type="button" class="add-btn" onclick="openModal()">➕ Add Questions category</button>
    </div>

    <!-- Modal -->
    <div id="questionModal" class="modal">
      <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <h3 style="color:#00796b; text-align:center;">Select Questions from Question Bank</h3>
        <input type="text" id="questionSearch" class="search-input" placeholder="Search questions...">
        <div class="table-container">
          <table id="questionBankTable">
            <thead>
              <tr>
                <th>Select</th>
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
                  <input type="checkbox" class="modal-checkbox" value="<%=q.getQuestionID()%>">
                </td>
                <td><%=q.getQuestionText()%></td>
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
        </div>
        <div style="text-align:center; margin-top:20px;">
          <button type="button" class="add-btn" onclick="addSelectedQuestions()">✅ Done</button>
        </div>
      </div>
    </div>

    <div style="text-align:center; margin-top:20px;">
        <button type="submit" name="status" value="Draft" class="add-btn">💾 Update to Draft</button>
        <button type="submit" name="status" value="Pending" class="add-btn">💾 Update to Complete</button>
    </div>
</form>
</div>

<script>
// Modal
function openModal(){ document.getElementById("questionModal").style.display="block"; }
function closeModal(){ document.getElementById("questionModal").style.display="none"; }
window.onclick = function(event){
    const modal = document.getElementById("questionModal");
    if(event.target === modal){ closeModal(); }
}

// Add selected questions

function addSelectedQuestions(){
    const checkboxes = document.querySelectorAll(".modal-checkbox:checked");
    const tableBody = document.querySelector("#currentQuestionsTable tbody");
    let currentCount = parseInt(document.getElementById("quizCount").textContent);
    const deletedContainer = document.getElementById("deletedQuestionsContainer");
    checkboxes.forEach(cb=>{
        const questionID = cb.value;
        const existingIDs = Array.from(tableBody.querySelectorAll("tr")).map(r=>r.dataset.questionid);
        if(!existingIDs.includes(questionID)){
            const row = cb.closest("tr").cloneNode(true);
            row.dataset.questionid = questionID;
            const newCheckbox = row.querySelector("input[type='checkbox']");
            newCheckbox.name="questionsToDeleteCheckbox";
            newCheckbox.checked=false;
            // Nếu trước đó câu này bị xoá, remove input ẩn tương ứng
            const deletedInput = deletedContainer.querySelector(`input[name='questionsToDelete'][value='${questionID}']`);
            if(deletedInput) deletedInput.remove();
            // tạo input ẩn gửi server
            const hiddenInput = document.createElement("input");
            hiddenInput.type="hidden";
            hiddenInput.name="questionsToAdd";
            hiddenInput.value=questionID;
            row.appendChild(hiddenInput);
            tableBody.appendChild(row);
            currentCount++;
        }
        // Xoá câu vừa chọn khỏi modal để tránh chọn trùng
        cb.closest("tr").remove();
    });
    document.getElementById("quizCount").textContent=currentCount;
    closeModal();
}
// Search filter
document.getElementById("questionSearch").addEventListener("keyup", function(){
    const filter = this.value.toLowerCase();
    const rows = document.querySelectorAll("#questionBankTable tbody tr");
    rows.forEach(row=>{
        const questionText = row.cells[1].textContent.toLowerCase();
        row.style.display = questionText.includes(filter) ? "" : "none";
    });
});

// Delete selected
function deleteSelectedQuestions(){
    const tableBody = document.querySelector("#currentQuestionsTable tbody");
    const checkboxes = tableBody.querySelectorAll("input[name='questionsToDeleteCheckbox']:checked");
    let currentCount = parseInt(document.getElementById("quizCount").textContent);
    const container = document.getElementById("deletedQuestionsContainer");
    const questionBankTableBody = document.querySelector("#questionBankTable tbody"); // tbody modal

    checkboxes.forEach(cb=>{
        const row = cb.closest("tr");

        // tạo input ẩn gửi server
        const hiddenInput = document.createElement("input");
        hiddenInput.type="hidden";
        hiddenInput.name="questionsToDelete";
        hiddenInput.value=cb.value;
        container.appendChild(hiddenInput);

        // clone row đưa về modal (question bank)
        const cloneForBank = row.cloneNode(true);
        // xóa checkbox trong modal
        const checkboxInClone = cloneForBank.querySelector("input[type='checkbox']");
        checkboxInClone.className = "modal-checkbox";
        checkboxInClone.name = "";
        checkboxInClone.checked = false;
        // xóa input ẩn questionsToAdd trong clone nếu có
        const hiddenInClone = cloneForBank.querySelector("input[name='questionsToAdd']");
        if(hiddenInClone) hiddenInClone.remove();

        questionBankTableBody.appendChild(cloneForBank);

        // xoá row khỏi current questions
        row.remove();
        currentCount--;
    });
    document.getElementById("quizCount").textContent=currentCount;
}
</script>
</body>
</html>
