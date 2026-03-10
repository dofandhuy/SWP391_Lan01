<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Entity.Quiz" %>
<%@ page import="Entity.User" %>
<%
    List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Management</title>
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background: #f5fafa;
            color: #333;
            margin: 0;
            padding: 0;
            display: flex;
        }
        /* SIDEBAR */
        .sidebar {
            width: 220px;
            background-color: #009688;
            color: white;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            padding-top: 20px;
            box-shadow: 2px 0 6px rgba(0,0,0,0.1);
        }
        .sidebar .logo {
            text-align: center;
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 25px;
            letter-spacing: 1px;
        }
        .sidebar a {
            display: block;
            color: white;
            padding: 12px 20px;
            text-decoration: none;
            font-weight: 500;
            transition: background 0.3s, padding-left 0.3s;
        }
        .sidebar a:hover {
            background-color: #00796b;
            padding-left: 25px;
        }
        /* MAIN CONTENT */
        .main-content {
            margin-left: 240px;
            padding: 25px;
            width: calc(100% - 240px);
        }
        .container {
            width: 100%;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.08);
            padding: 40px 50px;
        }
        h2 {
            text-align: center;
            color: #009688;
            font-size: 28px;
            margin-bottom: 30px;
        }
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }
        .search-box input {
            width: 250px;
            padding: 10px 15px;
            border: 1px solid #ccc;
            border-radius: 10px;
            outline: none;
            transition: 0.3s;
        }
        .search-box input:focus {
            border-color: #009688;
            box-shadow: 0 0 5px rgba(0,150,136,0.3);
        }
        .btn {
            border: none;
            border-radius: 8px;
            padding: 10px 18px;
            cursor: pointer;
            color: white;
            font-weight: 500;
            font-size: 14px;
            text-decoration: none;
            transition: 0.3s;
        }
        .btn-add { background: #009688; }
        .btn-edit { background: #10b981; }
        .btn-delete { background: #ef4444; }
        .btn-view { background: #f59e0b; }
        .btn-gray { background-color: #9ca3af; } /* nút Rejection Reason */
        .btn:hover { transform: scale(1.05); opacity: 0.9; }
        table {
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
            border-radius: 12px;
        }
        thead {
            background: #009688;
            color: white;
        }
        th, td {
            text-align: center;
            padding: 14px 10px;
            font-size: 15px;
        }
        tbody tr:nth-child(even) { background: #f3f4f6; }
        tbody tr:hover {
            background: #e0f2f1;
            transition: 0.3s;
        }
        .actions a, .actions button { margin: 0 3px; }
        .no-data {
            text-align: center;
            color: #9ca3af;
            padding: 25px 0;
        }

        /* Modal popup */
        .modal {
            display: none;
            position: fixed;
            z-index: 999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border-radius: 10px;
            width: 400px;
            text-align: center;
            box-shadow: 0 5px 25px rgba(0,0,0,0.2);
        }
        .close-btn {
            background-color: #ef4444;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 15px;
        }
    </style>
</head>
<body>
<!-- SIDEBAR -->
<div class="sidebar">
    <div class="logo">QuizManager</div>
    <a href="<%=request.getContextPath()%>/instructor/courses">🏠 Dashboard</a>
    <a href="createQuiz.jsp">➕ Create Quiz</a>
    <a href="QuizListServlet">📋 View Quizzes</a>
</div>
<!-- MAIN CONTENT -->
<div class="main-content">
    <div class="container">
        <h2>Quiz Management</h2>
        <div class="top-bar">
            <div class="search-box">
                <input type="text" placeholder="🔍 Search quiz by name...">
            </div>
            <a href="createQuiz.jsp" class="btn btn-add">+ Create New Quiz</a>
        </div>
        <table>
            <thead>
            <tr>
                <th>#</th>
                <th>Quiz Title</th>
                <th>Subject</th>
                <th>Time Limit</th>
                <th>Questions</th>
                <th>Passing Score</th>
                <th>Created By</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
<%
    User currentUser = (User) session.getAttribute("user");
    if (quizzes == null || quizzes.isEmpty()) {
%>
<tr><td colspan="9" class="no-data">No quizzes found.</td></tr>
<%
    } else {
        for (Quiz q : quizzes) {
            boolean isOwner = false;
            if (currentUser != null) {
               
                isOwner = q.getCreatedBy() == currentUser.getUserID();
            } else {
               
            }
%>
<tr>
    <td><%= q.getQuizID() %></td>
    <td><%= q.getTitle() %></td>
    <td><%= q.getCategoryName() %></td>
    <td><%= q.getDurationMinutes() != null ? q.getDurationMinutes() : "-" %> min</td>
    <td><%= q.getNumQuestions() %></td>
    <td><%= q.getPassingScore() != null ? q.getPassingScore() : "-" %></td>
    <td><%= q.getCreatedByName() != null ? q.getCreatedByName() : "Unknown" %></td>
    <td><%= q.getStatus() %></td>
    <td class="actions">
        <!-- Nút View luôn hiển thị -->
        <a href="QuizDetailServlet?id=<%=q.getQuizID()%>" class="btn btn-view">View</a>
        <% if (isOwner) { %>
            <!-- Nếu là người tạo quiz thì có quyền Edit & Delete -->
            <a href="EditQuizServlet?id=<%=q.getQuizID()%>" class="btn btn-edit">Edit</a>
            <a href="DeleteQuizServlet?id=<%=q.getQuizID()%>" class="btn btn-delete"
               onclick="return confirm('Delete this quiz?')">Delete</a>
        <% } %>
        <% if ("Rejected".equalsIgnoreCase(q.getStatus())) { %>
            <button class="btn btn-gray" onclick="showReasonModal('<%=q.getRejectionReason()%>')">Reason</button>
        <% } %>
    </td>
</tr>
<%
        }
    }
%>

</tbody>
        </table>
    </div>
</div>

<!-- Modal HTML -->
<div id="reasonModal" class="modal">
    <div class="modal-content">
        <p id="reasonText"></p>
        <button class="close-btn" onclick="closeModal()">Close</button>
    </div>
</div>

<script>
    function showReasonModal(reason) {
        document.getElementById("reasonText").innerText = reason || "No reason provided.";
        document.getElementById("reasonModal").style.display = "block";
    }
    function closeModal() {
        document.getElementById("reasonModal").style.display = "none";
    }
    // click ngoài modal cũng đóng
    window.onclick = function(event) {
        const modal = document.getElementById("reasonModal");
        if(event.target === modal) {
            modal.style.display = "none";
        }
    }
</script>
</body>
</html>
