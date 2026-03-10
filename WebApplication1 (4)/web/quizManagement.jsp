<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Entity.Quiz" %>
<%@ page import="Entity.User" %>
<%
    List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");
    User currentUser = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quiz Management | EMLS</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary: #009688;
            --primary-dark: #00796b;
            --danger: #ef4444;
            --success: #10b981;
            --warning: #f59e0b;
            --gray: #9ca3af;
            --bg-light: #f6faf9;
            --text-dark: #1e293b;
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            display: flex;
            background: var(--bg-light);
            color: var(--text-dark);
            min-height: 100vh;
        }

        /* ===== Sidebar ===== */
        .sidebar {
            width: 240px;
            background: var(--primary);
            color: white;
            display: flex;
            flex-direction: column;
            padding-top: 25px;
            position: fixed;
            top: 0; left: 0; bottom: 0;
            box-shadow: 2px 0 6px rgba(0,0,0,0.1);
        }

        .sidebar .logo {
            text-align: center;
            font-weight: 600;
            font-size: 22px;
            margin-bottom: 30px;
        }

        .sidebar a {
            display: flex;
            align-items: center;
            gap: 10px;
            color: white;
            padding: 12px 20px;
            text-decoration: none;
            font-weight: 500;
            transition: 0.25s;
        }

        .sidebar a:hover, .sidebar a.active {
            background: var(--primary-dark);
            padding-left: 25px;
        }

        /* ===== Main ===== */
        .main-content {
            flex: 1;
            margin-left: 240px;
            padding: 40px;
            transition: 0.3s;
        }

        .container {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            padding: 30px 40px;
        }

        h2 {
            text-align: center;
            font-size: 28px;
            color: var(--primary);
            margin-bottom: 30px;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 25px;
        }

        .search-box input {
            width: 280px;
            padding: 10px 15px;
            border-radius: 8px;
            border: 1px solid #ccc;
            outline: none;
            transition: 0.25s;
        }

        .search-box input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 6px rgba(0,150,136,0.2);
        }

        .btn {
            border: none;
            border-radius: 8px;
            padding: 9px 16px;
            cursor: pointer;
            color: white;
            font-weight: 500;
            font-size: 14px;
            transition: 0.25s;
        }

        .btn:hover { transform: translateY(-2px); opacity: 0.9; }

        .btn-add { background: var(--primary); }
        .btn-edit { background: var(--success); }
        .btn-delete { background: var(--danger); }
        .btn-view { background: var(--warning); }
        .btn-gray { background: var(--gray); }

        /* ===== Table ===== */
        table {
            width: 100%;
            border-collapse: collapse;
            border-radius: 12px;
            overflow: hidden;
        }

        thead {
            background: var(--primary);
            color: white;
        }

        th, td {
            text-align: center;
            padding: 14px 10px;
            font-size: 15px;
        }

        tbody tr:nth-child(even) { background: #f8f9fa; }

        tbody tr:hover {
            background: #e0f2f1;
            transition: 0.3s;
        }

        .actions a, .actions button {
            margin: 0 3px;
        }

        .no-data {
            text-align: center;
            padding: 25px 0;
            color: var(--gray);
            font-style: italic;
        }

        /* ===== Modal ===== */
        .modal {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.45);
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .modal-content {
            background: white;
            border-radius: 12px;
            padding: 25px 30px;
            width: 380px;
            text-align: center;
            box-shadow: 0 5px 25px rgba(0,0,0,0.15);
            animation: fadeIn 0.3s ease-in-out;
        }

        .modal-content p { font-size: 15px; color: #333; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .close-btn {
            margin-top: 18px;
            background: var(--danger);
            border: none;
            border-radius: 8px;
            padding: 8px 15px;
            color: white;
            font-weight: 500;
            cursor: pointer;
            transition: 0.25s;
        }

        .close-btn:hover { opacity: 0.9; }

        /* ===== Responsive ===== */
        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main-content { margin: 0; padding: 20px; }
            .search-box input { width: 100%; }
            table th, table td { font-size: 13px; padding: 10px; }
        }
    </style>
</head>

<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="logo"><i class="fa-solid fa-brain"></i> EMLS</div>
        <a href="<%=request.getContextPath()%>/instructor/courses"><i class="fa-solid fa-book"></i> My Courses</a>
        <a href="createQuiz.jsp"><i class="fa-solid fa-circle-plus"></i> Create Quiz</a>
        <a href="QuizListServlet" class="active"><i class="fa-solid fa-list-check"></i> Manage Quizzes</a>
    </div>

    <!-- Main -->
    <div class="main-content">
        <div class="container">
            <h2>Quiz Management</h2>

            <div class="top-bar">
                <div class="search-box">
                    <input type="text" placeholder="🔍 Search quiz by name...">
                </div>
                <a href="createQuiz.jsp" class="btn btn-add"><i class="fa fa-plus"></i> Create New Quiz</a>
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
                    if (quizzes == null || quizzes.isEmpty()) {
                %>
                    <tr><td colspan="9" class="no-data">No quizzes found.</td></tr>
                <%
                    } else {
                        for (Quiz q : quizzes) {
                            boolean isOwner = (currentUser != null && q.getCreatedBy() == currentUser.getUserID());
                %>
                    <tr>
                        <td><%= q.getQuizID() %></td>
                        <td><%= q.getTitle() %></td>
                        <td><%= q.getCategoryName() != null ? q.getCategoryName() : "All" %></td>
                        <td><%= q.getDurationMinutes() != null ? q.getDurationMinutes() : "-" %> min</td>
                        <td><%= q.getNumQuestions() %></td>
                        <td><%= q.getPassingScore() != null ? q.getPassingScore() : "-" %></td>
                        <td><%= q.getCreatedByName() != null ? q.getCreatedByName() : "Unknown" %></td>
                        <td><%= q.getStatus() %></td>
                        <td class="actions">
                            <a href="QuizDetailServlet?id=<%=q.getQuizID()%>" class="btn btn-view"><i class="fa fa-eye"></i></a>
                            <% if (isOwner) { %>
                                <a href="EditQuizServlet?id=<%=q.getQuizID()%>" class="btn btn-edit"><i class="fa fa-pen"></i></a>
                                <a href="DeleteQuizServlet?id=<%=q.getQuizID()%>" class="btn btn-delete"
                                   onclick="return confirm('Delete this quiz?')"><i class="fa fa-trash"></i></a>
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

    <!-- Modal -->
    <div id="reasonModal" class="modal">
        <div class="modal-content">
            <p id="reasonText"></p>
            <button class="close-btn" onclick="closeModal()">Close</button>
        </div>
    </div>

    <script>
        function showReasonModal(reason) {
            document.getElementById("reasonText").innerText = reason || "No reason provided.";
            document.getElementById("reasonModal").style.display = "flex";
        }
        function closeModal() {
            document.getElementById("reasonModal").style.display = "none";
        }
        window.onclick = function(e) {
            const modal = document.getElementById("reasonModal");
            if (e.target === modal) modal.style.display = "none";
        }
    </script>
</body>
</html>
