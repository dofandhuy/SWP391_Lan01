<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Course Management</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .container-fluid {
                padding: 2rem;
            }
            .card {
                border: none;
                border-radius: 0.75rem;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }
            .card-header {
                background-color: #ffffff;
                border-bottom: 1px solid #e0e0e0;
                font-weight: 600;
                padding: 1rem 1.5rem;
                font-size: 1.2rem;
            }
            .table thead th {
                background-color: #f1f3f5;
                border: none;
                font-weight: 600;
            }
            .table td, .table th {
                vertical-align: middle;
            }
            .filter-form .form-control, .filter-form .btn {
                height: calc(1.5em + .75rem + 2px);
            }
            .status-badge {
                padding: 0.4em 0.8em;
                border-radius: 1rem;
                font-size: 0.8em;
                font-weight: 600;
            }
            .status-Pending {
                background-color: #fff3cd;
                color: #856404;
            }
            .status-Approved {
                background-color: #d4edda;
                color: #155724;
            }
            .status-Rejected {
                background-color: #f8d7da;
                color: #721c24;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span><i class="fas fa-book-open mr-2"></i>Course Approval Management</span>
                    <div class="header-buttons">
                        <a href="${pageContext.request.contextPath}/adminDashboard.jsp" class="btn btn-light"><i class="fas fa-home mr-1"></i> Home</a>

                        <a href="${pageContext.request.contextPath}/signin" class="btn btn-danger"><i class="fas fa-sign-out-alt mr-1"></i> Log out</a>
                    </div>
                </div>

                <div class="card-body">

                    <%-- Hiển thị thông báo sau khi cập nhật --%>
                    <c:if test="${not empty sessionScope.updateMessage}">
                        <div class="alert alert-info alert-dismissible fade show" role="alert">
                            ${sessionScope.updateMessage}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        </div>
                        <% session.removeAttribute("updateMessage"); %>
                    </c:if>

                    <%-- Form Lọc và Tìm kiếm --%>
                    <form action="${pageContext.request.contextPath}/admin/courses" method="get" class="filter-form mb-4">
                        <div class="row">
                            <div class="col-md-2"><input type="text" name="courseName" class="form-control" placeholder="Search course..." value="${courseName}"></div>
                            <div class="col-md-2"><input type="text" name="instructorName" class="form-control" placeholder="Search instructor..." value="${instructorName}"></div>
                            <div class="col-md-2">
                                <select name="categoryId" class="form-control">
                                    <option value="0">All Categories</option>
                                    <c:forEach var="cat" items="${categoryList}">
                                        <option value="${cat.categoryID}" ${cat.categoryID == selectedCategoryId ? 'selected' : ''}>${cat.categoryName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select name="status" class="form-control">
                                    <option value="">All Statuses</option>
                                    <option value="Pending" ${"Pending".equalsIgnoreCase(selectedStatus) ? 'selected' : ''}>Pending</option>
                                    <option value="Approved" ${"Approved".equalsIgnoreCase(selectedStatus) ? 'selected' : ''}>Approved</option>
                                    <option value="Rejected" ${"Rejected".equalsIgnoreCase(selectedStatus) ? 'selected' : ''}>Rejected</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select name="priceSort" class="form-control">
                                    <option value="">Sort by Price</option>
                                    <option value="asc" ${"asc".equalsIgnoreCase(selectedPriceSort) ? 'selected' : ''}>Lowest First</option>
                                    <option value="desc" ${"desc".equalsIgnoreCase(selectedPriceSort) ? 'selected' : ''}>Highest First</option>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex">
                                <button type="submit" class="btn btn-primary mr-2" title="Filter"><i class="fas fa-filter"></i></button>
                                <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-secondary" title="Reset Filters"><i class="fas fa-sync-alt"></i></a>
                            </div>
                        </div>
                    </form>

                    <%-- Bảng Danh sách Khóa học --%>
                    <div class="table-responsive">
                        <table class="table table-hover text-center">
                            <thead>
                                <tr>
                                    <th>ID</th><th>Course Name</th><th>Instructor</th><th>Category</th>
                                    <th>Price</th><th>Status</th><th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="course" items="${courseList}">
                                    <tr>
                                        <td>${course.courseID}</td>
                                        <td>${course.title}</td>
                                        <td>${course.instructorName}</td>
                                        <td>${not empty course.categoryName ? course.categoryName : 'N/A'}</td>
                                        <td>$${String.format("%.2f", course.price)}</td>
                                        <td><span class="status-badge status-${course.status}">${course.status}</span></td>
                                        <td>
                                            <button class="btn btn-info btn-sm view-details-btn" data-toggle="modal" data-target="#courseDetailsModal" data-courseid="${course.courseID}" title="View/Edit Details">
                                                <i class="fas fa-pencil-alt"></i> Edit
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty courseList}">
                                    <tr><td colspan="7" class="text-center text-muted">No courses found matching criteria.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <%-- Modal Chi tiết/Cập nhật Khóa học --%>
        <div class="modal fade" id="courseDetailsModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Course Details & Approval</h5>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <form id="updateCourseForm" action="${pageContext.request.contextPath}/admin/courseAction" method="post">
                        <div class="modal-body">
                            <input type="hidden" id="modalCourseId" name="courseId">

                            <div class="form-row">
                                <div class="form-group col-md-8">
                                    <label>Title</label>
                                    <input type="text" class="form-control" id="modalTitle" name="title">
                                </div>
                                <div class="form-group col-md-4">
                                    <label>Price</label>
                                    <input type="number" step="0.01" class="form-control" id="modalPrice" name="price">
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label>Instructor</label>
                                    <input type="text" class="form-control" id="modalInstructor" readonly>
                                </div>
                                <div class="form-group col-md-6">
                                    <label>Category</label>
                                    <select id="modalCategory" name="categoryId" class="form-control">
                                        <c:forEach var="cat" items="${categoryList}">
                                            <option value="${cat.categoryID}">${cat.categoryName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Description</label>
                                <textarea class="form-control" id="modalDescription" rows="3" readonly></textarea>
                            </div>

                            <hr>

                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="modalStatus"><strong>Change Status</strong></label>
                                    <select id="modalStatus" name="status" class="form-control">
                                        <option value="Pending">Pending</option>
                                        <option value="Approved">Approved</option>
                                        <option value="Rejected">Rejected</option>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group" id="adminFeedbackGroup" style="display: none;">
                                <label for="modalAdminFeedback">Rejection Reason (Required)</label>
                                <textarea class="form-control" id="modalAdminFeedback" name="adminFeedback" rows="3"></textarea>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                            <button type="button" id="updateCourseBtn" class="btn btn-primary">Update Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            $(document).ready(function () {

                // === 1️⃣ Khi click "View Details" ===
                $('.view-details-btn').on('click', function () {
                    const courseId = $(this).data('courseid');

                    // Reset form trước
                    $('#updateCourseForm')[0].reset();
                    $('#adminFeedbackGroup').hide();
                    $('#modalAdminFeedback').prop('required', false).val('');

                    fetch('${pageContext.request.contextPath}/admin/courseAction?id=' + courseId)
                            .then(response => response.json())
                            .then(course => {
                                $('#modalCourseId').val(course.courseID);
                                $('#modalTitle').val(course.title);
                                $('#modalPrice').val(course.price);
                                $('#modalInstructor').val(course.instructorName);
                                $('#modalCategory').val(course.categoryID);
                                $('#modalDescription').val(course.description || '');
                                $('#modalStatus').val(course.status);

                                // ✅ Fill lý do từ chối
                                if (course.status === "Rejected") {
                                    $('#adminFeedbackGroup').show();
                                    $('#modalAdminFeedback').prop('required', true)
                                            .val(course.rejectionReason || '');
                                } else {
                                    $('#adminFeedbackGroup').hide();
                                    $('#modalAdminFeedback').prop('required', false).val('');
                                }

                                // Hiển thị modal
                                $('#courseDetailsModal').modal('show');
                            })
                            .catch(error => console.error('Error loading course:', error));
                });

                // === 2️⃣ Khi admin thay đổi trạng thái ===
                $('#modalStatus').on('change', function () {
                    if ($(this).val() === 'Rejected') {
                        $('#adminFeedbackGroup').slideDown();
                        $('#modalAdminFeedback').prop('required', true);
                    } else {
                        $('#adminFeedbackGroup').slideUp();
                        $('#modalAdminFeedback').prop('required', false).val('');
                    }
                });

                // === 3️⃣ Khi click "Update Changes" ===
                $('#updateCourseBtn').on('click', function () {
                    const form = $('#updateCourseForm')[0];

                    if (!form.checkValidity()) {
                        form.reportValidity();
                        return;
                    }

                    // ✅ Gửi form thật sự (POST tới Servlet)
                    form.submit();
                });
            });
        </script>


    </body>
</html>