<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Entity.Question" %>
<%@ page import="Service.QuestionService" %>
<%@ page import="Entity.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("Signin.jsp");
        return;
    }
    int userID = currentUser.getUserID();
    QuestionService qs = new QuestionService();

    List<Question> questions = (List<Question>) request.getAttribute("questions");
    if (questions == null) {
        questions = qs.getAllQuestions();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Question Bank</title>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<style>
/* ======= GLOBAL ======= */
body {
    margin: 0;
    font-family: 'Segoe UI', sans-serif;
    background-color: #f4f6f9;
    color: #333;
    display: flex;
    height: 100vh;
}

/* ======= SIDEBAR ======= */
.sidebar {
    width: 250px;
    background-color: #009688;
    color: white;
    padding: 20px 0;
    display: flex;
    flex-direction: column;
    box-shadow: 2px 0 5px rgba(0,0,0,0.1);
}
.logo {
    font-size: 1.7em;
    font-weight: 700;
    text-align: center;
    margin-bottom: 30px;
}
.nav-item {
    display: flex;
    align-items: center;
    padding: 12px 25px;
    color: #e0f7f4;
    text-decoration: none;
    font-weight: 500;
    transition: 0.3s;
}
.nav-item .material-icons {
    margin-right: 10px;
}
.nav-item:hover, .nav-item.active {
    background-color: #00796b;
    color: white;
}

/* ======= MAIN ======= */
.main {
    flex: 1;
    padding: 40px;
    overflow-y: auto;
}
.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 25px;
    border-bottom: 2px solid #009688;
    padding-bottom: 10px;
}
.header h1 {
    color: #00796b;
    margin: 0;
}
.btn {
    border: none;
    border-radius: 6px;
    padding: 8px 14px;
    cursor: pointer;
    font-weight: 600;
    transition: 0.3s;
}
.btn-add {
    background: #009688;
    color: white;
}
.btn-add:hover {
    background: #00796b;
}
.btn-view {
    background: #ffc107;
    color: white;
}
.btn-view:hover {
    background: #e0a800;
}
.btn-edit {
    background: #2196f3;
    color: white;
}
.btn-edit:hover {
    background: #1976d2;
}
.btn-delete {
    background: #dc3545;
    color: white;
}
.btn-delete:hover {
    background: #b71c1c;
}
.btn-reason {
    background: #6c757d;
    color: white;
}
.btn-reason:hover {
    background: #5a6268;
}

/* ======= SEARCH BAR ======= */
.search-bar {
    display: flex;
    gap: 10px;
    align-items: center;
}
.search-box {
    padding: 8px 10px;
    border-radius: 6px;
    border: 1px solid #ccc;
    width: 240px;
}

/* ======= TABLE ======= */
.table-wrapper {
    background: #fff;
    border-radius: 10px;
    box-shadow: 0 3px 10px rgba(0,0,0,0.05);
    padding: 20px;
}
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
}
th, td {
    border: 1px solid #e0e0e0;
    padding: 10px 12px;
    text-align: center;
}
th {
    background: #009688;
    color: white;
}
tr:nth-child(even) {
    background: #f9f9f9;
}
tr:hover {
    background: #e0f2f1;
}
.actions a {
    display: inline-block;
    margin: 2px 4px;
    padding: 6px 10px;
    text-decoration: none;
    border-radius: 6px;
    font-size: 13px;
}

/* ======= MODAL ======= */
.modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0; top: 0;
    width: 100%; height: 100%;
    background-color: rgba(0,0,0,0.4);
}
.modal-content {
    background-color: #fff;
    margin: 10% auto;
    padding: 25px;
    border-radius: 8px;
    width: 40%;
    box-shadow: 0 5px 20px rgba(0,0,0,0.3);
    position: relative;
}
.close {
    position: absolute;
    right: 15px; top: 10px;
    color: #888;
    font-size: 25px;
    cursor: pointer;
}
.close:hover { color: black; }
</style>
</head>
<body>
<div class="sidebar">
    <div class="logo">LMS Instructor</div>
    <a href="<%=request.getContextPath()%>/instructor/courses" class="nav-item">
        <span class="material-icons">dashboard</span> Dashboard
    </a>
    <a href="<%=request.getContextPath()%>/CreateQuestionServlet" class="nav-item">
        <span class="material-icons">quiz</span> Create Question
    </a>
    <a href="questionBank.jsp" class="nav-item active">
        <span class="material-icons">inventory_2</span> Question Bank
    </a>
</div>

<div class="main">
    <div class="header">
        <h1>📚 Question Bank</h1>
        <div class="search-bar">
            <form method="get" action="QuestionSearchServlet" style="display:flex; gap:10px; align-items:center;">
                <input type="text" name="keyword" placeholder="Search question..." class="search-box"
                       value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>">
                <button type="submit" class="btn btn-add">Search</button>
            </form>
            <a href="<%=request.getContextPath()%>/CreateQuestionServlet" class="btn btn-add">+ Add</a>
        </div>
    </div>

    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Question</th>
                    <th>Subject</th>
                    <th>Difficulty</th>
                    <th>Created By</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
                if (questions != null && !questions.isEmpty()) {
                    for (Question q : questions) {
                        String createdByName = qs.getUserNameByID(q.getCreatedBy());
                        String status = q.getStatus() != null ? q.getStatus().trim() : "Unknown";
            %>
                <tr>
                    <td><%= q.getQuestionID() %></td>
                    <td style="text-align:left;"><%= q.getQuestionText() %></td>
                    <td><%= q.getCategoryName() %></td>
                    <td><%= q.getDifficultyLevel() %></td>
                    <td><%= createdByName %></td>
                    <td><%= status %></td>
                    <td class="actions">
                        <a href="ViewQuestionServlet?id=<%= q.getQuestionID() %>" class="btn-view">View</a>
                        <% if (q.getCreatedBy() == userID) { %>
                            <a href="EditQuestionServlet?id=<%= q.getQuestionID() %>" class="btn-edit">Edit</a>
                            <a href="DeleteQuestionServlet?id=<%= q.getQuestionID() %>" class="btn-delete"
                               onclick="return confirm('Are you sure you want to delete this question?');">Delete</a>
                            <% 
                                String reason = q.getRejectionReason();
                                if ("Rejected".equalsIgnoreCase(status) && reason != null && !reason.isEmpty()) {
                            %>
                                <a href="javascript:void(0)" class="btn-reason"
                                   onclick="showReason('<%= reason.replace("'", "\\'") %>')">Reason</a>
                            <% } %>
                        <% } else { %>
                            <span style="color:#888;">—</span>
                        <% } %>
                    </td>
                </tr>
            <%
                    }
                } else {
            %>
                <tr><td colspan="7" style="color:#777;">No questions available.</td></tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</div>

<!-- MODAL -->
<div id="reasonModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeReason()">&times;</span>
    <h3 style="margin-top:0;color:#00796b;">Rejection Reason</h3>
    <p id="reasonText" style="line-height:1.6;"></p>
  </div>
</div>

<script>
function showReason(reason) {
    document.getElementById('reasonText').innerText = reason;
    document.getElementById('reasonModal').style.display = 'block';
}
function closeReason() {
    document.getElementById('reasonModal').style.display = 'none';
}
window.onclick = function(e) {
    let modal = document.getElementById('reasonModal');
    if (e.target == modal) modal.style.display = "none";
}
</script>
</body>
</html>
