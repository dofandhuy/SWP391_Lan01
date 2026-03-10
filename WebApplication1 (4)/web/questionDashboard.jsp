<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Question Approval Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .card { border: none; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .status-badge { padding: 0.4em 0.8em; border-radius: 1rem; font-size: 0.8em; font-weight: 600; color: white; }
        .status-Pending { background-color: #ffc107; color: black; }
        .status-Approved { background-color: #198754; }
        .status-Rejected { background-color: #dc3545; }
    </style>
</head>
<body>
<div class="container py-4">
    <div class="card shadow-sm">
        
                  <div class="card-header d-flex justify-content-between align-items-center">
            <span><i class="fas fa-book-open mr-2"></i>Question Approval Management</span>
            <div class="header-buttons">
                <a href="${pageContext.request.contextPath}/adminDashboard.jsp" class="btn btn-light"><i class="fas fa-home mr-1"></i> Home</a>
    <a href="${pageContext.request.contextPath}/admin/question-bank" class="btn btn-outline-info">
                <i class="fas fa-database me-1"></i> View Full Bank
            </a>
                <a href="${pageContext.request.contextPath}/signin" class="btn btn-danger"><i class="fas fa-sign-out-alt mr-1"></i> Log out</a>
            </div>
        </div>
        <div class="card-body">
            <c:if test="${not empty sessionScope.updateMessage}">
                <div class="alert alert-success alert-dismissible fade show">
                    ${sessionScope.updateMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% session.removeAttribute("updateMessage"); %>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/questionAction" method="get" class="mb-4">
                <div class="row g-3">
                    <div class="col-md-3"><input type="text" name="searchText" class="form-control" placeholder="Search by question..." value="${searchText}"></div>
                    <div class="col-md-2"><input type="text" name="createdBy" class="form-control" placeholder="Search by instructor..." value="${createdBy}"></div>
                    <div class="col-md-2"><select name="categoryId" class="form-select"><option value="0">All Categories</option><c:forEach var="cat" items="${categoryList}"><option value="${cat.categoryID}" ${cat.categoryID == selectedCategoryId ? 'selected' : ''}>${cat.categoryName}</option></c:forEach></select></div>
                    <div class="col-md-2"><select name="type" class="form-select"><option value="">All Types</option><option value="MCQ" ${"MCQ" eq selectedType ? 'selected' : ''}>MCQ</option><option value="TrueFalse" ${"TrueFalse" eq selectedType ? 'selected' : ''}>True/False</option><option value="FillBlank" ${"FillBlank" eq selectedType ? 'selected' : ''}>Fill Blank</option></select></div>
                    <div class="col-md-2"><select name="status" class="form-select"><option value="">All Statuses</option><option value="Pending" ${"Pending" eq selectedStatus ? 'selected' : ''}>Pending</option><option value="Approved" ${"Approved" eq selectedStatus ? 'selected' : ''}>Approved</option><option value="Rejected" ${"Rejected" eq selectedStatus ? 'selected' : ''}>Rejected</option></select></div>
                    <div class="col-md-1 d-flex"><button type="submit" class="btn btn-primary me-2" title="Filter"><i class="fas fa-filter"></i></button><a href="${pageContext.request.contextPath}/admin/questionAction" class="btn btn-secondary" title="Reset"><i class="fas fa-sync-alt"></i></a></div>
                </div>
            </form>

            <table class="table table-hover align-middle text-center">
                <thead class="table-light"><tr><th>ID</th><th style="width: 40%;">Question</th><th>Category</th><th>Type</th><th>Created By</th><th>Status</th><th>Action</th></tr></thead>
                <tbody id="question-table-body">
                    <c:forEach var="q" items="${questionList}">
                        <tr class="question-row" data-questionid="${q.questionID}">
                            <td>${q.questionID}</td><td class="text-start">${q.questionText}</td><td>${q.categoryName}</td><td>${q.questionType}</td><td>${q.createdByName}</td><td><span class="status-badge status-${q.status}">${q.status}</span></td>
                            <td>
                                <button class="btn btn-sm btn-info view-details-btn">
                                    <i class="fas fa-pencil-alt"></i> View & Approve
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty questionList}"><tr><td colspan="7" class="text-muted p-3">No questions found.</td></tr></c:if>
                </tbody>
            </table>

            <nav><ul class="pagination justify-content-center"><c:forEach begin="1" end="${totalPages}" var="i"><li class="page-item ${i == currentPage ? 'active' : ''}"><a class="page-link" href="${pageContext.request.contextPath}/admin/questionAction?page=${i}&searchText=${searchText}&categoryId=${selectedCategoryId}&createdBy=${createdBy}&type=${selectedType}&status=${selectedStatus}">${i}</a></li></c:forEach></ul></nav>
        </div>
    </div>
</div>

<div class="modal fade" id="approvalModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form id="updateQuestionForm" action="${pageContext.request.contextPath}/admin/questionAction" method="post">
        <div class="modal-header bg-info text-white">
            <h5 class="modal-title">Question Details & Approval</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
            <input type="hidden" id="formQuestionId" name="questionId">
            <p><strong>ID:</strong> <span id="modalQuestionId"></span></p>
            <p><strong>Question:</strong> <span id="modalQuestionText"></span></p>
            <p><strong>Category:</strong> <span id="modalCategory"></span> | <strong>Created By:</strong> <span id="modalCreatedBy"></span></p>
            <hr>
            <h6>Answer Options:</h6>
            <ul id="modalAnswers" class="list-group mb-3"></ul>
            <hr>
            <div class="row">
                <div class="col-md-6">
                    <label for="modalFormStatus" class="form-label fw-bold">Change Status</label>
                    <select id="modalFormStatus" name="status" class="form-select">
                        <option value="Approved">Approve</option>
                        <option value="Rejected">Reject</option>
                    </select>
                </div>
            </div>
            <div class="mt-3" id="rejectionReasonGroup" style="display:none;">
                <label for="modalRejectionReason" class="form-label fw-bold">Rejection Reason <span class="text-danger">*</span></label>
                <textarea class="form-control" id="modalRejectionReason" name="rejectionReason" rows="3"></textarea>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="submit" class="btn btn-primary">Update Status</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    const tableBody = document.getElementById('question-table-body');
    const approvalModal = new bootstrap.Modal(document.getElementById('approvalModal'));
    const contextPath = '<%= request.getContextPath() %>';

    tableBody.addEventListener('click', function (event) {
        const viewButton = event.target.closest('.view-details-btn');
        if (!viewButton) return;

        const questionRow = viewButton.closest('tr');
        const questionId = questionRow.dataset.questionid;
        
        if (!questionId) {
            alert("Cannot find Question ID!");
            return;
        }

        // ✅ Fetch từ servlet JSON đúng
        const fetchUrl = contextPath + '/admin/questionDetail?id=' + questionId;
        console.log('Fetching URL:', fetchUrl);

        fetch(fetchUrl)
            .then(function(response) {
                if (!response.ok) throw new Error('HTTP Error! Status: ' + response.status);
                return response.json();
            })
            .then(function(data) {
                console.log('Question data:', data);

                // Fill modal with question data
                document.getElementById('formQuestionId').value = data.questionID;
                document.getElementById('modalQuestionId').textContent = data.questionID;
                document.getElementById('modalQuestionText').textContent = data.questionText;
                document.getElementById('modalCategory').textContent = data.categoryName;
                document.getElementById('modalCreatedBy').textContent = data.createdByName;
                  // ✅ Fill lại status
                const statusSelect = document.getElementById('modalFormStatus');
                if (statusSelect && data.status) {
                    statusSelect.value = data.status;
                }

                // ✅ Fill lý do từ chối (nếu có)
                const rejectionGroup = document.getElementById('rejectionReasonGroup');
                const rejectionReason = document.getElementById('modalRejectionReason');
                if (data.status === 'Rejected') {
                    rejectionGroup.style.display = 'block';
                    rejectionReason.required = true;
                    rejectionReason.value = data.rejectionReason || '';
                } else {
                    rejectionGroup.style.display = 'none';
                    rejectionReason.required = false;
                    rejectionReason.value = '';
                }

                // Display answer options
                const answersContainer = document.getElementById('modalAnswers');
                answersContainer.innerHTML = '';
                
                if (data.options && data.options.length > 0) {
                    data.options.forEach(function(option) {
                        const li = document.createElement('li');
                        const answerText = option.answerText || option.text || '(No content)';
                        const isCorrect = option.isCorrect === true || option.correct === true;
                        
                        li.className = 'list-group-item';
                        
                        if (isCorrect) {
                            li.classList.add('border-2', 'border-success');
                            li.style.backgroundColor = '#d4edda';
                            li.innerHTML = '<i class="fas fa-check-circle text-success me-2"></i><strong class="text-success">' + answerText + '</strong>';
                        } else {
                            li.innerHTML = '<i class="far fa-circle text-muted me-2"></i><span>' + answerText + '</span>';
                        }
                        
                        answersContainer.appendChild(li);
                    });
                } else {
                    answersContainer.innerHTML = '<li class="list-group-item text-muted">No answer options available.</li>';
                }

                // Show modal
                approvalModal.show();
            })
            .catch(function(error) {
                console.error('Fetch Error:', error);
                alert('Cannot load question data. Please check console for details.');
            });
    });

    // Handle status change (show/hide rejection reason)
    const modalFormStatus = document.getElementById('modalFormStatus');
    if (modalFormStatus) {
        modalFormStatus.addEventListener('change', function () {
            const isRejected = this.value === 'Rejected';
            const rejectionGroup = document.getElementById('rejectionReasonGroup');
            const rejectionReason = document.getElementById('modalRejectionReason');
            
            if (rejectionGroup && rejectionReason) {
                rejectionGroup.style.display = isRejected ? 'block' : 'none';
                rejectionReason.required = isRejected;
            }
        });
    }
});
</script>

</body>
</html>