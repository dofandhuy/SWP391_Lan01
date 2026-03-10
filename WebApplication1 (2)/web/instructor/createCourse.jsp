<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<form action="${pageContext.request.contextPath}/instructor/courses" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="create">

    <label>Course Title:</label>
    <input type="text" name="title" placeholder="Enter course title..." required>

    <label>Description:</label>
    <textarea name="description" rows="4" placeholder="Enter course description..."></textarea>
    
    <label>Thumbnail:</label>
    <input type="file" name="thumbnail" accept="image/*">
    <button type="submit">Save</button>

    <label>Category:</label>
    <select name="categoryId" required>
        <option value="">-- Select Category --</option>
        <c:forEach var="cat" items="${categories}">
            <option value="${cat.categoryId}">${cat.categoryName}</option>
        </c:forEach>
    </select>
    
</form>
