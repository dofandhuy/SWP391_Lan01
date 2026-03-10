<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Create Question</title>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <style>
      body { 
    margin:0; 
    font-family: 'Segoe UI', sans-serif; 
    background:#f4f6f9; 
    color:#333; 
  }

  .app-container { 
    display:grid; 
    grid-template-columns:250px 1fr; 
    min-height:100vh; 
  }

  /* ✅ Sidebar xanh ngọc bích */
  .sidebar { 
    background:#009688; /* teal chính */
    color:white; 
    padding:20px 0; 
  }

  .logo { 
    font-size:1.5em; 
    font-weight:700; 
    text-align:center; 
    margin-bottom:20px; 
  }

  .nav-item { 
    display:flex; 
    align-items:center; 
    padding:12px 20px; 
    color:#b2dfdb; /* xanh nhạt hơn cho chữ */
    text-decoration:none; 
    transition:.3s; 
  }

  .nav-item:hover, 
  .nav-item.active { 
    background:#00796b; /* đậm hơn khi hover/active */
    color:white; 
  }

  .nav-item .material-icons { 
    margin-right:10px; 
  }

  .main-content { 
    padding:30px; 
  }

  .page-header { 
    display:flex; 
    justify-content:space-between; 
    align-items:center; 
    margin-bottom:25px; 
    border-bottom:1px solid #ddd; 
    padding-bottom:15px; 
  }

  .page-header h1 { 
    margin:0; 
    font-size:1.6em; 
    font-weight:600; 
  }

  section { 
    background:#fff; 
    border-radius:8px; 
    padding:20px; 
    margin-bottom:25px; 
    box-shadow:0 4px 10px rgba(0,0,0,.05); 
  }

  section h2 { 
    margin-top:0; 
    font-size:1.3em; 
    color:#009688; /* đồng bộ với màu chủ đạo */
    border-bottom:1px solid #eee; 
    padding-bottom:10px; 
    margin-bottom:20px; 
  }

  .form-group { margin-bottom:15px; }
  .form-group label { display:block; font-weight:600; margin-bottom:6px; }
  input[type="text"], textarea, select { 
    width:100%; 
    padding:10px; 
    border:1px solid #ccc; 
    border-radius:6px; 
    font-size:1em; 
  }
  textarea { resize:vertical; min-height:80px; }

  .btn { 
    padding:10px 15px; 
    border:none; 
    border-radius:5px; 
    cursor:pointer; 
    font-weight:600; 
    margin:5px; 
  }

  .btn-primary { 
    background:#009688; /* nút cùng màu sidebar */
    color:white; 
  }

  .btn-primary:hover { 
    background:#00796b; /* đậm hơn khi hover */
  }
   
  </style>
</head>
<body>
<div class="app-container">
  <aside class="sidebar">
    <div class="logo">LMS Instructor</div>
   <a href="<%=request.getContextPath()%>/instructor/courses" class="nav-item">Dashboard</a>
    <a href="createQuestion.jsp" class="nav-item active"><span class="material-icons">quiz</span>Create Question</a>
    <a href="questionBank.jsp" class="nav-item"><span class="material-icons">help</span>Question Bank</a>
   
  </aside>
  <main class="main-content">
    <header class="page-header">
      <h1>Create New Question</h1>
    </header>
    <form action="CreateQuestionServlet" method="post">
      <section>
        <h2>Question Details</h2>
        <div class="form-group">
          <label>Question Content</label>
          <textarea name="q1-text" placeholder="Enter question text..." required></textarea>
        </div>
        <div class="form-group">
          <label>Question Type</label>
          <select name="q1-type" required>
            <option value="MCQ">Multiple Choice</option>
            <option value="TrueFalse">True/False</option>
          </select>
        </div>
        <div class="form-group">
          <label>Difficulty</label>
          <select name="q1-difficulty" required>
            <option value="Easy">Easy</option>
            <option value="Medium">Medium</option>
            <option value="Hard">Hard</option>
          </select>
        </div>
        <div class="form-group">
          <label>Category</label>
          <input type="text" name="q1-category" placeholder="e.g. SQL, Java, Math">
        </div>
        <div class="form-group">
          <label>Option A</label>
          <input type="text" name="q1-optA" >
        </div>
        <div class="form-group">
          <label>Option B</label>
          <input type="text" name="q1-optB" >
        </div>
        <div class="form-group">
          <label>Option C</label>
          <input type="text" name="q1-optC" >   
        </div>
        <div class="form-group">
          <label>Option D</label>
          <input type="text" name="q1-optD" >
        </div>
        <div class="form-group">
          <label>Correct Answer</label>
          <select name="q1-correct" required>
            <option value="A">A</option>
            <option value="B">B</option>
            <option value="C">C</option>
            <option value="D">D</option>
          </select>
        </div>
      </section>
      <button type="submit" name="action" class="btn btn-primary" value ="save">Save Question</button>
      <button type="submit" name="action" class="btn btn-primary" value="close">Save to draft</button>
    </form>
  </main>
</div>
</body>
</html>
