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
    List<Question> questionList = qs.getAllQuestions(); 
    List<String> categories = qs.getAllCategories();

    String[] selectedQuestionsFromRequest = (String[]) request.getAttribute("selectedQuestions");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Create Quiz</title>
        <style>
            body {
                font-family: "Poppins", sans-serif;
                background: #f5fafa;
                color: #333;
                margin:0;
                padding:0;
                display:flex;
            }
            .sidebar {
                width: 220px;
                background-color: #009688;
                color: white;
                height:100vh;
                position:fixed;
                top:0;
                left:0;
                padding-top:20px;
                box-shadow:2px 0 6px rgba(0,0,0,0.1);
            }
            .sidebar .logo {
                text-align:center;
                font-size:22px;
                font-weight:700;
                margin-bottom:25px;
                letter-spacing:1px;
            }
            .sidebar a {
                display:block;
                color:white;
                padding:12px 20px;
                text-decoration:none;
                font-weight:500;
                transition: background 0.3s, padding-left 0.3s;
            }
            .sidebar a:hover {
                background-color:#00796b;
                padding-left:25px;
            }
            .main-content {
                margin-left:240px;
                padding:25px;
                width:calc(100% - 240px);
            }
            h2 {
                text-align:center;
                color:#009688;
            }
            form {
                background:white;
                max-width:900px;
                margin:20px auto;
                padding:25px;
                border-radius:12px;
                box-shadow:0 4px 8px rgba(0,0,0,0.1);
            }
            label {
                font-weight:600;
            }
            input[type="text"], input[type="number"], select {
                width:100%;
                padding:8px;
                border:1px solid #ddd;
                border-radius:6px;
                margin-bottom:12px;
            }
            button {
                color:white;
                border:none;
                padding:10px 18px;
                border-radius:8px;
                font-weight:600;
                cursor:pointer;
                transition:background 0.3s;
            }
            .btn-create {
                background-color:#009688;
            }
            .btn-create:hover {
                background-color:#00796b;
            }
            .btn-draft {
                background-color:#ffc107;
                color:white;
                margin-left:10px;
            }
            .btn-draft:hover {
                background-color:#e0a800;
            }
            table {
                width:100%;
                border-collapse:collapse;
                margin-top:15px;
            }
            th, td {
                border:1px solid #e0e0e0;
                padding:8px 10px;
                text-align:left;
            }
            th {
                background-color:#009688;
                color:white;
            }
            tr:nth-child(even) {
                background-color:#f7f7f7;
            }
            .checkbox-cell {
                text-align:center;
            }
            .section-title {
                margin-top:20px;
                color:#00796b;
                border-bottom:2px solid #009688;
                padding-bottom:4px;
                font-weight:600;
            }
            .message {
                text-align:center;
                margin-bottom:15px;
                font-weight:600;
            }
            .error {
                color:red;
            }
            .success {
                color:green;
            }
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

            <%
                String error = (String) request.getAttribute("error");
                String success = request.getParameter("success");
                if ("mismatch".equals(error)) { %>
            <p class="message error">❌ Tổng số câu không khớp! Vui lòng kiểm tra lại.</p>
            <% } else if ("true".equals(success)) { %>
            <p class="message success">✅ Quiz created successfully!</p>
            <% } else if ("exception".equals(error)) { %>
            <p class="message error">⚠️ Có lỗi xảy ra khi tạo quiz. Vui lòng thử lại.</p>
            <% } else if ("passingRange".equals(error)) { %>
            <p class="message error">❌ Passing Score phải nằm trong 0 → 10!</p>
            <% } else if ("notEnoughQuestions".equals(error)) { %>
            <p class="message error">❌ Không đủ số câu theo mức độ để tạo quiz!</p>
            <% } %>

            <form action="CreateQuizServlet" method="post" id="quizForm">
                <input type="hidden" name="status" value="Pending">

                <label>Title:</label>
                <input type="text" name="title" required value="<%= request.getAttribute("title") != null ? request.getAttribute("title") : "" %>">

                <label>Num of Questions:</label>
                <input type="number" name="numQuestions" required value="<%= request.getAttribute("numQuestions") != null ? request.getAttribute("numQuestions") : "" %>">

                <label>Duration (minutes):</label>
                <input type="number" name="duration" required value="<%= request.getAttribute("duration") != null ? request.getAttribute("duration") : "" %>">

                <label>Passing Score (0 - 10):</label>
                <input type="number" name="passingScore" step="0.1" min="0" max="10" required
                       value="<%= request.getAttribute("passingScore") != null ? request.getAttribute("passingScore") : "" %>">

                <label>Max Attempts:</label>
                <input type="number" name="maxAttempt" min="1" required
                       value="<%= request.getAttribute("maxAttempt") != null ? request.getAttribute("maxAttempt") : "1" %>">

                <label>Cooldown Hours:</label>
                <input type="number" name="cooldownHours" min="0" required
                       value="<%= request.getAttribute("cooldownHours") != null ? request.getAttribute("cooldownHours") : "0" %>">

                <label><input type="checkbox" name="random" id="randomCheck"
                              <%= "true".equals(request.getAttribute("randomChecked")) ? "checked" : "" %> > Generate Random Questions</label>

                <label>Category:</label>
                <select id="categorySelect" name="category">
                    <option value="">All</option>
                    <% for (String cat : categories) { %>
                    <option value="<%=cat%>" <%= cat.equals(request.getAttribute("category")) ? "selected" : "" %>><%=cat%></option>
                    <% } %>
                </select>

                <!-- Random Question Section -->
                <div class="section-title">🎲 Câu hỏi ngẫu nhiên (tùy chọn)</div>
                <p style="font-style: italic; color: #555; margin-bottom: 10px;">
                    Nếu chọn “Generate Random Questions”, hệ thống sẽ tự chọn ngẫu nhiên số lượng câu hỏi theo từng mức độ khó mà bạn nhập bên dưới.
                </p>

                <div style="display: flex; gap: 20px; flex-wrap: wrap;">
                    <div style="flex: 1; min-width: 200px;">
                        <label for="easyInput">Số câu dễ:</label>
                        <input id="easyInput" type="number" name="easy" min="0" title="Số lượng câu dễ"
                               value="<%= request.getAttribute("easy") != null ? request.getAttribute("easy") : "0" %>"
                               <%= !"true".equals(request.getAttribute("randomChecked")) ? "disabled" : "" %>>
                    </div>
                    <div style="flex: 1; min-width: 200px;">
                        <label for="mediumInput">Số câu trung bình:</label>
                        <input id="mediumInput" type="number" name="medium" min="0" title="Số lượng câu trung bình"
                               value="<%= request.getAttribute("medium") != null ? request.getAttribute("medium") : "0" %>"
                               <%= !"true".equals(request.getAttribute("randomChecked")) ? "disabled" : "" %>>
                    </div>
                    <div style="flex: 1; min-width: 200px;">
                        <label for="hardInput">Số câu khó: </label>
                        <input id="hardInput" type="number" name="hard" min="0" title="Số lượng câu khó"
                               value="<%= request.getAttribute("hard") != null ? request.getAttribute("hard") : "0" %>"
                               <%= !"true".equals(request.getAttribute("randomChecked")) ? "disabled" : "" %>>
                    </div>
                </div>

                <p id="totalDisplay" style="text-align:right; margin-top:10px; font-weight:bold; color:#009688;">Tổng: 0 câu</p>

                <!-- Question Table -->
                <div class="section-title">📚 Chọn từ ngân hàng câu hỏi:</div>
                <table id="questionTable">
                    <thead>
                        <tr>
                            <th>Select</th>
                            <th>Question</th>
                            <th>Type</th>
                            <th>Category</th>
                            <th>Difficulty</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Question q : questionList) { 
                            boolean checked = selectedQuestionsFromRequest != null && Arrays.asList(selectedQuestionsFromRequest).contains(String.valueOf(q.getQuestionID()));
                        %>
                        <tr>
                            <td class="checkbox-cell">
                                <input type="checkbox" name="selectedQuestions" value="<%= q.getQuestionID() %>"
                                       <%= checked ? "checked" : "" %>>
                            </td>
                            <td><%= q.getQuestionText() %></td>
                            <td><%= q.getQuestionType() %></td>
                            <td><%= q.getCategoryName() %></td>
                            <td><%= q.getDifficultyLevel() %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <script>
                    // Bật/tắt input random
                    const randomCheck = document.getElementById("randomCheck");
                    const easyInput = document.getElementById("easyInput");
                    const mediumInput = document.getElementById("mediumInput");
                    const hardInput = document.getElementById("hardInput");
                    const totalDisplay = document.getElementById("totalDisplay");

                    function updateTotal() {
                        const total = (parseInt(easyInput.value || 0) +
                                       parseInt(mediumInput.value || 0) +
                                       parseInt(hardInput.value || 0));
                        totalDisplay.textContent = "Tổng: " + total + " câu";
                    }

                    [easyInput, mediumInput, hardInput].forEach(input => {
                        input.addEventListener("input", updateTotal);
                    });
                    updateTotal();

                    randomCheck.addEventListener("change", () => {
                        const enabled = randomCheck.checked;
                        [easyInput, mediumInput, hardInput].forEach(input => input.disabled = !enabled);
                    });

                    // Lọc theo category
                    document.getElementById("categorySelect").addEventListener("change", function () {
                        const selectedCategory = this.value.toLowerCase();
                        const rows = document.querySelectorAll("#questionTable tbody tr");
                        rows.forEach(row => {
                            const category = row.cells[3].textContent.toLowerCase();
                            row.style.display = (selectedCategory === "" || category === selectedCategory) ? "" : "none";
                        });
                    });
                </script>

                <div style="text-align:center; margin-top:20px;">
                    <button type="submit" name="action" class="btn-create" value="save">Create Quiz</button>
                    <button type="submit" name="action" class="btn-draft" value="draft">Save to Draft</button>
                </div>
            </form>
        </div>
    </body>
</html>
