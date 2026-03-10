<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Edit Class</title>
  <style>
    body { font-family: Arial; background: #f4f6f9; display: flex; justify-content: center; align-items: center; height: 100vh; }
    .form-container { background: #fff; padding: 30px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 400px; }
    h2 { text-align: center; margin-bottom: 25px; }
    label { display: block; margin-top: 12px; font-weight: bold; }
    input, textarea { width: 100%; padding: 10px; border-radius: 20px; border: 1px solid #2bb6b6; margin-top: 5px; outline: none; }
    textarea { border-radius: 10px; resize: none; height: 100px; }
    .submit-btn { margin-top: 20px; width: 100%; padding: 12px; border: none; border-radius: 6px; background: #2bb6b6; color: white; font-size: 16px; cursor: pointer; }
    .submit-btn:hover { background: #239a9a; }
  </style>
</head>
<body>
  <div class="form-container">
    <h2>Edit Class</h2>

    <!-- Hiển thị error nếu có -->
    <c:if test="${error eq 'UpdateFailed'}">
      <div style="background: #ffe5e5; color: #d60000; padding: 10px; border-radius: 6px; margin-bottom: 15px; text-align: center;">
        ❌ Update class failed. Please try again.
      </div>
    </c:if>

    <form action="editClass" method="post">
      <input type="hidden" name="classId" value="${classObj.classId}">

      <label>Class name</label>
      <input type="text" name="className" value="${classObj.className}" required>

      <label>Description</label>
      <textarea name="description">${classObj.description}</textarea>

      <button type="submit" class="submit-btn">Update class</button>
    </form>
  </div>
</body>
</html>