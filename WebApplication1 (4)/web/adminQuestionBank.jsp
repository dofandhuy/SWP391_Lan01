<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Full Question Bank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .card { border: none; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .answers-row td { background-color: #e9ecef; }
    </style>
</head>
<body>
<div class="container py-4">
    <div class="card shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <h4 class="mb-0"><i class="fas fa-database me-2"></i>Full Question Bank</h4>
            <a href="${pageContext.request.contextPath}/admin/questionAction" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-1"></i> Back to Approval Page
            </a>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/question-bank" method="get" class="mb-4">
                <div class="row g-3">
                    <div class="col-md-4"><input type="text" name="searchText" class="form-control" placeholder="Search by question..." value="${searchText}"></div>
                    <div class="col-md-3"><input type="text" name="createdBy" class="form-control" placeholder="Search by instructor..." value="${createdBy}"></div>
                    <div class="col-md-2"><select name="categoryId" class="form-select"><option value="0">All Categories</option><c:forEach var="cat" items="${categoryList}"><option value="${cat.categoryID}" ${cat.categoryID == selectedCategoryId ? 'selected' : ''}>${cat.categoryName}</option></c:forEach></select></div>
                    <div class="col-md-2"><select name="type" class="form-select"><option value="">All Types</option><option value="MCQ" ${"MCQ" eq selectedType ? 'selected' : ''}>MCQ</option><option value="TrueFalse" ${"TrueFalse" eq selectedType ? 'selected' : ''}>True/False</option><option value="FillBlank" ${"FillBlank" eq selectedType ? 'selected' : ''}>Fill Blank</option></select></div>
                    <div class="col-md-1 d-flex"><button type="submit" class="btn btn-primary me-2" title="Filter"><i class="fas fa-filter"></i></button><a href="${pageContext.request.contextPath}/admin/question-bank" class="btn btn-secondary" title="Reset"><i class="fas fa-sync-alt"></i></a></div>
                </div>
            </form>

            <table class="table table-hover align-middle text-center">
                <thead class="table-light"><tr><th>ID</th><th style="width: 50%;">Question</th><th>Category</th><th>Type</th><th>Created By</th><th>Actions</th></tr></thead>
                <tbody id="bank-table-body">
                    <c:forEach var="q" items="${questionList}">
                        <tr class="question-row" data-questionid="${q.questionID}">
                            <td>${q.questionID}</td><td class="text-start">${q.questionText}</td><td>${q.categoryName}</td><td>${q.questionType}</td><td>${q.createdByName}</td>
                            <td>
                                <button class="btn btn-sm btn-outline-primary toggle-answers-btn">
                                    <i class="fas fa-chevron-down"></i> Answers
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty questionList}"><tr><td colspan="7" class="text-muted p-3">No questions found.</td></tr></c:if>
                </tbody>
            </table>
            
            <nav><ul class="pagination justify-content-center"><c:forEach begin="1" end="${totalPages}" var="i"><li class="page-item ${i == currentPage ? 'active' : ''}"><a class="page-link" href="${pageContext.request.contextPath}/admin/question-bank?page=${i}&searchText=${searchText}&categoryId=${selectedCategoryId}&createdBy=${createdBy}&type=${selectedType}">${i}</a></li></c:forEach></ul></nav>
        </div>
    </div>
</div>
        
        <!-- 🔹 MODAL hiển thị chi tiết câu hỏi -->
<div class="modal fade" id="questionDetailModal" tabindex="-1" aria-labelledby="questionDetailLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title" id="questionDetailLabel">Question Details</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p><strong>ID:</strong> <span id="modalQuestionId"></span></p>
        <p><strong>Text:</strong> <span id="modalQuestionText"></span></p>
        <p><strong>Type:</strong> <span id="modalQuestionType"></span></p>
        <p><strong>Category:</strong> <span id="modalCategory"></span></p>
        <p><strong>Created By:</strong> <span id="modalCreatedBy"></span></p>
       
        <hr>
        <h6>Answer Options:</h6>
        <ul id="modalAnswers" class="list-group"></ul>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script>

document.addEventListener('DOMContentLoaded', function () {
    const tableBody = document.getElementById('bank-table-body');

    tableBody.addEventListener('click', function (event) {
        const toggleButton = event.target.closest('.toggle-answers-btn');
        if (!toggleButton) return;

        const questionRow = toggleButton.closest('.question-row');
        const questionId = questionRow.dataset.questionid;
        if (!questionId) {
            alert("Không tìm thấy ID câu hỏi!");
            return;
        }

        const fetchUrl = '<%= request.getContextPath() %>/admin/questionDetail?id=' + questionId;
        console.log("🟢 fetchUrl =", fetchUrl);

        fetch(fetchUrl)
            .then(response => {
                if (!response.ok) throw new Error(`HTTP Error! Status: ${response.status}`);
                return response.json();
            })
            .then(data => {
                console.log("✅ Nhận dữ liệu:", data);

                // Điền dữ liệu câu hỏi
                document.getElementById('modalQuestionId').textContent = data.questionID;
                document.getElementById('modalQuestionText').textContent = data.questionText;
                document.getElementById('modalQuestionType').textContent = data.questionType;
                document.getElementById('modalCategory').textContent = data.categoryName;
                document.getElementById('modalCreatedBy').textContent = data.createdByName;

                // Xóa container cũ
                const answersContainer = document.getElementById('modalAnswers');
                answersContainer.innerHTML = '';

                if (data.options && data.options.length > 0) {
                    data.options.forEach(opt => {
                        const li = document.createElement('li');
                        li.className = 'list-group-item d-flex justify-content-between align-items-center';

                        const answerText = opt.answerText || opt.text || '(No content)';
                        li.textContent = answerText;

                        const isCorrect = opt.correct === true || opt.isCorrect === true;
                        if (isCorrect) {
                            const checkIcon = document.createElement('i');
                            checkIcon.className = 'fas fa-check-circle text-success ms-2';
                            checkIcon.style.fontSize = '1.1rem';
                            li.appendChild(checkIcon);

                            // Optional: highlight background xanh nhạt
                            li.style.backgroundColor = '#e7f9ec';
                            li.classList.add('fw-bold', 'text-success');
                        }

                        answersContainer.appendChild(li);
                    });
                } else {
                    const li = document.createElement('li');
                    li.className = 'list-group-item text-muted';
                    li.textContent = 'Không có đáp án';
                    answersContainer.appendChild(li);
                }

                // Mở modal
                const modal = new bootstrap.Modal(document.getElementById('questionDetailModal'));
                modal.show();
            })
            .catch(error => {
                console.error('❌ Fetch Error:', error);
                alert("Không thể tải dữ liệu câu hỏi. Kiểm tra console để biết chi tiết.");
            });
    });
});

</script>



</body>
</html>