<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Entity.Question" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Create Question</title>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <style>
      body {margin:0;font-family:'Segoe UI',sans-serif;background:#f4f6f9;color:#333;}
      .app-container{display:grid;grid-template-columns:250px 1fr;min-height:100vh;}
      .sidebar{background:#009688;color:white;padding:20px 0;}
      .logo{font-size:1.5em;font-weight:700;text-align:center;margin-bottom:20px;}
      .nav-item{display:flex;align-items:center;padding:12px 20px;color:#b2dfdb;text-decoration:none;transition:.3s;}
      .nav-item:hover,.nav-item.active{background:#00796b;color:white;}
      .nav-item .material-icons{margin-right:10px;}
      .main-content{padding:30px;}
      .page-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:25px;border-bottom:1px solid #ddd;padding-bottom:15px;}
      .page-header h1{margin:0;font-size:1.6em;font-weight:600;}
      section{background:#fff;border-radius:8px;padding:20px;margin-bottom:25px;box-shadow:0 4px 10px rgba(0,0,0,.05);}
      section h2{margin-top:0;font-size:1.3em;color:#009688;border-bottom:1px solid #eee;padding-bottom:10px;margin-bottom:20px;}
      .form-group{margin-bottom:15px;}
      .form-group label{display:block;font-weight:600;margin-bottom:6px;}
      input[type="text"],textarea,select{width:100%;padding:10px;border:1px solid #ccc;border-radius:6px;font-size:1em;}
      textarea{resize:vertical;min-height:80px;}
      .btn{padding:10px 15px;border:none;border-radius:5px;cursor:pointer;font-weight:600;margin:5px;}
      .btn-primary{background:#009688;color:white;}
      .btn-primary:hover{background:#00796b;}
      .option-item { display:flex; align-items:center; gap:10px; margin-bottom:8px; }
      .btn-remove { background:#e53935; color:white; border:none; padding:5px 8px; border-radius:4px; cursor:pointer; }
      .btn-remove:hover { background:#c62828; }
  </style>
</head>
<body>
<div class="app-container">
  <aside class="sidebar">
    <div class="logo">LMS Instructor</div>
    <a href="<%=request.getContextPath()%>/instructor/courses" class="nav-item">Dashboard</a>
    <a href="<%=request.getContextPath()%>/CreateQuestionServlet" class="nav-item active"><span class="material-icons">quiz</span>Create Question</a>
    <a href="questionBank.jsp" class="nav-item"><span class="material-icons">help</span>Question Bank</a>
  </aside>

  <main class="main-content">
    <header class="page-header">
      <h1>Create New Question</h1>
    </header>

    <% 
      String msg = (String) request.getAttribute("message");
      String err = (String) request.getAttribute("error");
      if (msg != null) { %>
        <p style="color:green;font-weight:600"><%= msg %></p>
    <% } else if (err != null) { %>
        <p style="color:red;font-weight:600"><%= err %></p>
    <% } %>

    <form action="CreateQuestionServlet" method="post" id="questionForm">
      <section>
        <h2>Question Details</h2>

        <div class="form-group">
          <label>Question Content</label>
          <textarea name="q1-text" placeholder="Enter question text..." required></textarea>
        </div>

        <div class="form-group">
          <label>Question Type</label>
          <select name="q1-type" id="questionType" required>
            <option value="MCQ">Multiple Choice</option>
         
            <option value="FillBlank">Fill in the Blank</option>
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
          <label for="category">Category</label>
          <select name="q1-category" id="category">
            <option value="">-- Select Category --</option>
            <%
              List<String> categories = (List<String>) request.getAttribute("categories");
              if (categories != null && !categories.isEmpty()) {
                for (String c : categories) {
            %>
              <option value="<%= c %>"><%= c %></option>
            <%
                }
              } else {
            %>
              <option value="">(No category available)</option>
            <%
              }
            %>
          </select>
        </div>

        <div class="form-group">
          <label><strong>Answer Options</strong></label>
          <div id="options-container"></div>
          <button type="button" class="btn btn-primary" id="addOptionBtn">➕ Add Option</button>
        </div>

      </section>

      <button type="submit" name="action" class="btn btn-primary" value="save">Save Question</button>
      <button type="submit" name="action" class="btn btn-primary" value="draft">Save to Draft</button>
    </form>
  </main>
</div>

<script>
let optionIndex = 0;
const optionsContainer = document.getElementById('options-container');
const addBtn = document.getElementById('addOptionBtn');
const typeSelect = document.getElementById('questionType');
const form = document.getElementById('questionForm');

function addOption(text = '') {
  const div = document.createElement('div');
  div.className = 'option-item';
  div.innerHTML = `
    <input type="text" name="optionText" placeholder="Enter answer text..." required value="${text}">
    <label><input type="checkbox" name="correctOption" value="${optionIndex}"> Correct</label>
    <button type="button" class="btn btn-remove" onclick="removeOption(this)">❌</button>
  `;
  optionsContainer.appendChild(div);
  optionIndex++;
  updateCheckboxValues();
}

function removeOption(btn) {
  btn.parentElement.remove();
  updateCheckboxValues();
}

function updateCheckboxValues() {
  const checkboxes = document.querySelectorAll('#options-container input[type="checkbox"]');
  checkboxes.forEach((cb, idx) => cb.value = idx);
}

function updateOptionsByType() {
  const type = typeSelect.value;
  optionsContainer.innerHTML = '';
  optionIndex = 0;

  if (type === 'TrueFalse') {
    ['True', 'False'].forEach((text, idx) => {
      const div = document.createElement('div');
      div.className = 'option-item';
      div.innerHTML = `
        <input type="text" name="optionText" value="${text}" readonly>
        <label><input type="checkbox" name="correctOption" value="${idx}"> Correct</label>
      `;
      optionsContainer.appendChild(div);
    });
    addBtn.style.display = 'none';

  } else if (type === 'FillBlank') {
    const div = document.createElement('div');
    div.className = 'option-item';
    div.innerHTML = `
      <input type="text" name="optionText" placeholder="Enter answer..." required>
      <input type="hidden" name="correctOption" value="0">
    `;
    optionsContainer.appendChild(div);
    addBtn.style.display = 'none';

  } else { // MCQ
    addBtn.style.display = 'inline-block';
    addOption();
  }
}

// Validate MCQ: ít nhất 1 checkbox tick
form.addEventListener('submit', function(e) {
  if (typeSelect.value === 'MCQ') {
    const checked = Array.from(document.querySelectorAll('#options-container input[type="checkbox"]')).some(cb => cb.checked);
    if (!checked) {
      alert('❌ Bạn phải chọn ít nhất 1 đáp án đúng cho câu hỏi trắc nghiệm!');
      e.preventDefault();
    }
  }
});

typeSelect.addEventListener('change', updateOptionsByType);
addBtn.addEventListener('click', () => addOption());
window.addEventListener('DOMContentLoaded', updateOptionsByType);
</script>

</body>
</html>
