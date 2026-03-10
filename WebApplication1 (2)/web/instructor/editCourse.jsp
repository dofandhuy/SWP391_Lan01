<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    .modal-header h2 {
        text-align: center;
        margin-bottom: 10px;
        color: #1b1f3b;
        font-size: 20px;
    }

    input[type="text"], select, textarea, input[type="file"] {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 14px;
        box-sizing: border-box;
        font-family: 'Poppins', sans-serif;
    }

    input:focus, textarea:focus, select:focus {
        outline: none;
        border-color: #22c1c3;
    }

    label {
        font-weight: 600;
        color: #1b1f3b;
        font-size: 14px;
    }

    button:hover {
        background: #1aa3a5;
    }
</style>
<div class="modal-header">
    <h2>Edit Course</h2>
</div>

<form id="editCourseForm"
      action="${pageContext.request.contextPath}/instructor/courses"
      method="post"
      enctype="multipart/form-data"
      style="display:flex; flex-direction:column; gap:12px;">

    <input type="hidden" name="action" value="edit">
    <input type="hidden" name="courseId" value="${course.id}">

    <label>Course Title:</label>
    <input type="text" name="title" value="${course.title}" placeholder="Enter course title" required>

    <label>Description:</label>
    <textarea name="description" rows="3" placeholder="Write something about this course...">${course.description}</textarea>

    <label>Category:</label>
    <select name="categoryId" required>
        <option value="">-- Select Category --</option>
        <c:forEach var="cat" items="${categories}">
            <option value="${cat.categoryId}"
                    ${cat.categoryId == course.categoryId ? "selected" : ""}>
                ${cat.categoryName}
            </option>
        </c:forEach>
    </select>

    <label>Thumbnail:</label>
    <input type="file" name="thumbnail" accept="image/*">

    <c:if test="${not empty course.thumbnail}">
        <div style="display:flex; align-items:center; gap:10px; margin-top:-5px; font-size:13px;">
            <span>Current:</span>
            <img src="${pageContext.request.contextPath}/uploads/${course.thumbnail}"
                 width="80" height="50" style="border-radius:6px; border:1px solid #ddd;">
        </div>
    </c:if>

    <button type="submit"
            style="margin-top:10px; background:#22c1c3; color:white; border:none;
            padding:10px; border-radius:6px; font-weight:600; cursor:pointer;">
        Save Changes
    </button>
</form>


