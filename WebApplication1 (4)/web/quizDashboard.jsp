<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz Approval Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .card { border: none; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .status-badge { padding: 0.4em 0.8em; border-radius: 1rem; font-size: 0.8em; font-weight: 600; color: white; }
        .status-Pending { background-color: #ffc107; color: black; }
        .status-Approved { background-color: #28a745; }
        .status-Rejected { background-color: #dc3545; }
    </style>
</head>
<body>
<div class="container py-4">
    <div class="card shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <h4 class="mb-0"><i class="fas fa-file-alt mr-2"></i>Quiz Approval Management</h4>
             <a href="${pageContext.request.contextPath}/adminDashboard.jsp" class="btn btn-light"><i class="fas fa-home mr-1"></i> Home</a>
        </div>
        <div class="card-body">
            <c:if test="${not empty sessionScope.updateMessage}"><div class="alert alert-success alert-dismissible fade show">${sessionScope.updateMessage}<button type="button" class="close" data-dismiss="alert">&times;</button></div><% session.removeAttribute("updateMessage"); %></c:if>
            <form action="${pageContext.request.contextPath}/admin/quizzes" method="get" class="mb-4"><div class="form-row"><div class="col-md-3 mb-2"><input type="text" name="quizName" class="form-control" placeholder="Search by quiz title..." value="${quizName}"></div><div class="col-md-3 mb-2"><input type="text" name="instructorName" class="form-control" placeholder="Search by instructor..." value="${instructorName}"></div><div class="col-md-2 mb-2"><select name="categoryId" class="form-control"><option value="0">All Subjects</option><c:forEach var="cat" items="${categoryList}"><option value="${cat.categoryID}" ${cat.categoryID == selectedCategoryId ? 'selected' : ''}>${cat.categoryName}</option></c:forEach></select></div><div class="col-md-2 mb-2"><select name="status" class="form-control"><option value="">All Statuses</option><option value="Pending" ${"Pending" eq selectedStatus ? 'selected' : ''}>Pending</option><option value="Approved" ${"Approved" eq selectedStatus ? 'selected' : ''}>Approved</option><option value="Rejected" ${"Rejected" eq selectedStatus ? 'selected' : ''}>Rejected</option></select></div><div class="col-md-2 mb-2 d-flex"><button type="submit" class="btn btn-primary mr-2" title="Filter"><i class="fas fa-filter"></i> Filter</button><a href="${pageContext.request.contextPath}/admin/quizzes" class="btn btn-secondary" title="Reset"><i class="fas fa-sync-alt"></i></a></div></div></form>
            <table class="table table-hover align-middle text-center"><thead class="thead-light"><tr><th>ID</th><th>Title</th><th>Subject</th><th>Created By</th><th>Status</th><th>Action</th></tr></thead><tbody id="quiz-table-body"><c:forEach var="quiz" items="${quizList}"><tr data-quizid="${quiz.quizID}"><td>${quiz.quizID}</td><td>${quiz.title}</td><td>${quiz.categoryName}</td><td>${quiz.createdByName}</td><td><span class="status-badge status-${quiz.status}">${quiz.status}</span></td><td><button class="btn btn-sm btn-info view-details-btn"><i class="fas fa-eye"></i> View Details</button></td></tr></c:forEach><c:if test="${empty quizList}"><tr><td colspan="6" class="text-muted p-3">No quizzes found.</td></tr></c:if></tbody></table>
        </div>
    </div>
</div>

<div class="modal fade" id="quizDetailsModal" tabindex="-1">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <form id="updateQuizForm" action="${pageContext.request.contextPath}/admin/quizAction" method="post">
        <div class="modal-header bg-info text-white"><h5 class="modal-title">Quiz Details & Approval</h5><button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button></div>
        <div class="modal-body"><input type="hidden" id="modalQuizId" name="quizId"><div class="row"><div class="col-md-6"><h5>Quiz Information</h5><p><strong>ID:</strong> <span id="q-id"></span></p><p><strong>Title:</strong> <span id="q-title"></span></p><p><strong>Subject:</strong> <span id="q-subject"></span></p><p><strong>Created By:</strong> <span id="q-createdby"></span></p><p><strong>Questions:</strong> <span id="q-num-questions"></span> | <strong>Difficulty:</strong> <span id="q-difficulty"></span></p><p><strong>Passing Score:</strong> <span id="q-passing-score"></span>% | <strong>Points/Q:</strong> <span id="q-points"></span></p><hr><div class="row"><div class="col-md-6"><label for="modalStatus" class="font-weight-bold">Change Status</label><select id="modalStatus" name="status" class="form-control"><option value="Approved">Approve</option><option value="Rejected">Reject</option></select></div></div><div class="mt-3" id="rejectionReasonGroup" style="display:none;"><label for="modalRejectionReason" class="font-weight-bold">Rejection Reason <span class="text-danger">*</span></label><textarea class="form-control" id="modalRejectionReason" name="rejectionReason" rows="3"></textarea></div></div><div class="col-md-6 border-left"><h5>Questions & Answers</h5><div id="questionsContainer" style="max-height: 400px; overflow-y: auto;"></div></div></div></div>
        <div class="modal-footer"><button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button><button type="submit" class="btn btn-primary">Update Status</button></div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function () {
    try {
        const tableBody = document.getElementById('quiz-table-body');
        if (!tableBody) {
            console.error("❌ Không tìm thấy phần tử #quiz-table-body");
            return;
        }

        const detailsModal = new bootstrap.Modal(document.getElementById('quizDetailsModal'));
        const contextPath = '<%= request.getContextPath() %>';

        // 👉 Bắt sự kiện click vào nút "View Details"
        tableBody.addEventListener('click', function (event) {
            try {
                const viewButton = event.target.closest('.view-details-btn');
                if (!viewButton) return;

                const quizRow = viewButton.closest('tr');
                if (!quizRow) {
                    console.error("❌ Không tìm thấy thẻ <tr> chứa nút bấm");
                    return;
                }

                const quizId = quizRow.dataset.quizid;
                console.log("🔹 quizId =", quizId);

                if (!quizId) {
                    alert("Không tìm thấy Quiz ID!");
                    return;
                }

                const fetchUrl = contextPath + '/admin/quizAction?id=' + quizId;
                console.log("🟢 Fetch URL =", fetchUrl);

                fetch(fetchUrl)
                    .then(response => {
                        if (!response.ok) throw new Error('HTTP Error! Status: ' + response.status);
                        return response.json();
                    })
                    .then(data => {
                        console.log("✅ Dữ liệu nhận được:", data);

                        const quiz = data.quiz;
                        const questions = data.questions;

                        // --- Gán thông tin quiz ---
                        document.getElementById('modalQuizId').value = quiz.quizID;
                        document.getElementById('q-id').textContent = quiz.quizID;
                        document.getElementById('q-title').textContent = quiz.title;
                        document.getElementById('q-subject').textContent = quiz.categoryName;
                        document.getElementById('q-createdby').textContent = quiz.createdByName;
                        document.getElementById('q-num-questions').textContent = quiz.numQuestions;
                        document.getElementById('q-difficulty').textContent = quiz.difficultyLevel;
                        document.getElementById('q-passing-score').textContent = quiz.passingScore;
                        document.getElementById('q-points').textContent = quiz.pointPerQuestion;
                        
                // ✅ Fill lại status và rejection reason (đọc từ data.quiz)
const statusSelect = document.getElementById('modalStatus');
const rejectionGroup = document.getElementById('rejectionReasonGroup');
const rejectionReason = document.getElementById('modalRejectionReason');

const status = data.quiz?.status || '';
const reason = data.quiz?.rejectionReason || '';

if (statusSelect) {
    statusSelect.value = status;
}

if (status === 'Rejected') {
    rejectionGroup.style.display = 'block';
    rejectionReason.required = true;
    rejectionReason.value = reason || '';
} else {
    rejectionGroup.style.display = 'none';
    rejectionReason.required = false;
    rejectionReason.value = '';
}





                        // --- Hiển thị danh sách câu hỏi & đáp án ---
                        const questionsContainer = document.getElementById('questionsContainer');
                        if (!questionsContainer) {
                            console.error("❌ Không tìm thấy phần tử #questionsContainer");
                            return;
                        }

                        console.log("🟡 Tổng số câu hỏi:", questions?.length || 0);

                        let html = '';
                        if (questions && questions.length > 0) {
                            questions.forEach(function(question, index) {
                                console.log('➡️ Câu hỏi ' + (index + 1) + ':', question);

                                // Get question text
                                const questionText = question.questionText || question.text || '(Không có nội dung câu hỏi)';
                                const questionType = question.questionType || '';

                                html += '<div class="card mb-3 shadow-sm">';
                                html += '  <div class="card-header bg-light">';
                                html += '    <div class="d-flex justify-content-between align-items-start">';
                                html += '      <strong class="text-primary">Câu ' + (index + 1) + ': ' + questionText + '</strong>';
                                
                                if (questionType) {
                                    html += '      <span class="badge bg-info">' + questionType + '</span>';
                                }
                                
                                html += '    </div>';
                                html += '  </div>';
                                html += '  <div class="card-body p-2">';

                                // Display options if they exist
                                if (question.options && question.options.length > 0) {
                                    html += '<ul class="list-group list-group-flush">';
                                    
                                    question.options.forEach(function(option) {
                                        const answerText = option.answerText || option.text || '(Không có nội dung)';
                                        const isCorrect = option.isCorrect === true;
                                        
                                        if (isCorrect) {
                                            html += '<li class="list-group-item border-2 border-success" style="background-color: #d4edda;">';
                                            html += '  <i class="fas fa-check-circle text-success me-2"></i>';
                                            html += '  <strong class="text-success">' + answerText + '</strong>';
                                            html += '</li>';
                                        } else {
                                            html += '<li class="list-group-item">';
                                            html += '  <i class="far fa-circle text-muted me-2"></i>';
                                            html += '  <span>' + answerText + '</span>';
                                            html += '</li>';
                                        }
                                    });
                                    
                                    html += '</ul>';
                                } else {
                                    html += '<p class="text-muted mb-0">Không có đáp án nào.</p>';
                                }

                                html += '  </div>';
                                html += '</div>';
                            });
                        } else {
                            html = '<div class="alert alert-info">Không tìm thấy câu hỏi nào cho quiz này.</div>';
                        }

                        questionsContainer.innerHTML = html;

                        // --- Hiển thị modal ---
                        detailsModal.show();
                    })
                    .catch(function(fetchError) {
                        console.error("❌ Fetch Error:", fetchError);
                        alert("Không thể tải dữ liệu quiz. Vui lòng kiểm tra console để biết chi tiết.");
                    });

            } catch (clickError) {
                console.error("❌ Lỗi sự kiện click:", clickError);
            }
        });

        // --- Xử lý thay đổi trạng thái (Approve/Reject) ---
        const modalStatus = document.getElementById('modalStatus');
        if (modalStatus) {
            modalStatus.addEventListener('change', function () {
                const isRejected = this.value === 'Rejected';
                const rejectionGroup = document.getElementById('rejectionReasonGroup');
                const rejectionReason = document.getElementById('modalRejectionReason');

                if (rejectionGroup && rejectionReason) {
                    rejectionGroup.style.display = isRejected ? 'block' : 'none';
                    rejectionReason.required = isRejected;
                } else {
                    console.warn("⚠️ Không tìm thấy phần tử nhập lý do từ chối");
                }
            });
        } else {
            console.warn("⚠️ Không tìm thấy phần tử #modalStatus");
        }

    } catch (domError) {
        console.error("❌ Lỗi DOMContentLoaded:", domError);
    }
});
</script>

</body>
</html>