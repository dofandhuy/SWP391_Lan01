<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Entity.Question" %>
<%@ page import="Service.QuestionService" %>
<%@ page import="Entity.User" %>
<%
    // Lấy user hiện tại từ session
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("Signin.jsp");
        return;
    }
    int userID = currentUser.getUserID();
    QuestionService qs = new QuestionService();
    
    // Danh sách question lấy từ Servlet, nếu null thì lấy tất cả question
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    if (questions == null) {
        questions = qs.getAllQuestions(); // lấy tất cả câu hỏi
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Question Bank</title>
<style>
    body { 
        font-family: Arial, sans-serif; 
        margin:0; 
        padding:0; 
        background:#f4f6f9; 
        display:flex; 
    }
    .sidebar { 
        width:220px; 
        background:#009688; 
        min-height:100vh; 
        padding:20px 0; 
        color:white; 
        box-shadow:2px 0 5px rgba(0,0,0,0.1); 
    }
    .logo { 
        font-size:1.5em; 
        font-weight:700; 
        text-align:center; 
        padding:0 0 30px 0; 
        border-bottom:1px solid rgba(255,255,255,0.1); 
        margin-bottom:15px; 
    }
    .sidebar a { 
        display:block; 
        padding:12px 20px; 
        margin:5px 10px; 
        color:#e0f2f1; 
        text-decoration:none; 
        border-radius:6px; 
        transition:0.3s; 
        font-weight:500; 
    }
    .sidebar a:hover { 
        background:#00796b; 
        color:#fff; 
    }
    .sidebar a.active { 
        background:#4db6ac; 
        color:#fff; 
        box-shadow:0 2px 5px rgba(0,0,0,0.2); 
    }
    .main { flex:1; padding:30px; } 
    .container { 
        background:white; 
        padding:20px; 
        border-radius:8px; 
        box-shadow:0 4px 6px rgba(0,0,0,0.1); 
    }
    h2 { text-align:center; margin-bottom:20px; color:#333; }
    .actions-bar { display:flex; justify-content:flex-end; align-items:center; gap:10px; margin-bottom:15px; }
    .btn { padding:8px 16px; border:none; border-radius:5px; cursor:pointer; font-size:14px; }
    .btn-view { background: #ffc107; color: white; padding:5px 10px; border-radius:4px; display:inline-block; text-decoration:none; }
    .btn-view:hover { background: #e0a800; }
    .btn-reason { background: #6c757d; color: white; padding:5px 10px; border-radius:4px; display:inline-block; text-decoration:none; }
    .btn-reason:hover { background: #5a6268; }
    .btn-add { background:#28a745; color:white; }
    .btn-edit { background:#007bff; color:white; }
    .btn-delete { background:#dc3545; color:white; }
    .search-box, .sort-box { padding:6px; border:1px solid #ccc; border-radius:5px; }
table { width:100%; border-collapse:collapse; margin-top:15px; }
    table th, table td { border:1px solid #ddd; padding:12px; text-align:center; }
    table th { background:#007bff; color:white; }
    table tr:nth-child(even) { background:#f9f9f9; }
    table tr:hover { background:#f1f1f1; }
    .actions a { margin:0 5px; display:inline-block; text-decoration:none; padding:5px 10px; border-radius:4px; color:white; }
    .actions a.btn-edit { background:#007bff; }
    .actions a.btn-delete { background:#dc3545; }
    /* Popup */
    .modal { display:none; position:fixed; z-index:1000; left:0; top:0; width:100%; height:100%; overflow:auto; background-color:rgba(0,0,0,0.4); }
    .modal-content { background-color:#fefefe; margin:15% auto; padding:20px; border:1px solid #888; width:40%; border-radius:8px; position:relative; }
    .close { color:#aaa; float:right; font-size:28px; font-weight:bold; cursor:pointer; }
    .close:hover, .close:focus { color:black; text-decoration:none; cursor:pointer; }
</style>
</head>
<body>
<div class="sidebar">
    <div class="logo">QuizMaster</div>
    <a href="<%=request.getContextPath()%>/instructor/courses">Dashboard</a>
    <a href="<%=request.getContextPath()%>/CreateQuestionServlet">Create Question</a>
    <a href="questionBank.jsp" class="active">Question Bank</a>
</div>
<div class="main">
    <div class="container">
        <h2>Question Bank</h2>
        <div class="actions-bar">
            <a href="<%=request.getContextPath()%>/CreateQuestionServlet" class="btn btn-add">+ Add Question</a>
            <form method="get" action="QuestionSearchServlet" style="display:inline-block;">
                <input type="text" name="keyword" placeholder="Search question..." class="search-box"
                       value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
                <select name="sort" class="sort-box">
                    <option value="id" <%= "id".equals(request.getParameter("sort")) ? "selected" : "" %>>Sort by ID</option>
                    <option value="a-z" <%= "a-z".equals(request.getParameter("sort")) ? "selected" : "" %>>Question A-Z</option>
                    <option value="z-a" <%= "z-a".equals(request.getParameter("sort")) ? "selected" : "" %>>Question Z-A</option>
                    <option value="category" <%= "category".equals(request.getParameter("sort")) ? "selected" : "" %>>Sort by Category</option>
                </select>
                <button type="submit" class="btn btn-add">Apply</button>
            </form>
        </div>
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
if (questions != null) {
                    for (Question q : questions) {
                        String createdByName = qs.getUserNameByID(q.getCreatedBy());
            %>
                <tr>
                    <td><%= q.getQuestionID() %></td>
                    <td><%= q.getQuestionText() %></td>
                    <td><%= q.getCategoryName() %></td>
                    <td><%= q.getDifficultyLevel() %></td>
                    <td><%= createdByName %></td>
                    <td><%= q.getStatus() != null ? q.getStatus() : "Unknown" %></td>
                    <td class="actions">
                        <a href="ViewQuestionServlet?id=<%= q.getQuestionID() %>" class="btn-view">View</a>
                        <%
                            if (q.getCreatedBy() == userID) {
                        %>
                        <a href="EditQuestionServlet?id=<%= q.getQuestionID() %>" class="btn-edit">Edit</a>
                        <a href="DeleteQuestionServlet?id=<%= q.getQuestionID() %>" class="btn-delete"
                           onclick="return confirm('Bạn có chắc muốn xóa câu hỏi này?');">Delete</a>
                        <% if ("Rejected".equalsIgnoreCase(q.getStatus()) && q.getRejectionReason() != null) { %>
                        <a href="javascript:void(0)" class="btn-reason" onclick="showReason('<%= q.getRejectionReason().replace("'", "\\'") %>')">Reason</a>
                        <% } %>
                        <%
                            } else {
                                out.print("-"); 
                            }
                        %>
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

<!-- Popup -->
<div id="reasonModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeReason()">&times;</span>
    <p id="reasonText"></p>
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
// Đóng modal khi click ra ngoài
window.onclick = function(event) {
    let modal = document.getElementById('reasonModal');
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
</script>
</body>
</html>