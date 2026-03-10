<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .container-fluid { padding: 2rem; }
        .card { border: none; border-radius: 0.75rem; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .card-header { background-color: #ffffff; border-bottom: 1px solid #e0e0e0; font-weight: 600; padding: 1rem 1.5rem; font-size: 1.2rem; }
        .table thead th { background-color: #f1f3f5; border: none; font-weight: 600; }
        .table td, .table th { vertical-align: middle; }
        .filter-form .form-control, .filter-form .btn { height: calc(1.5em + .75rem + 2px); }
        .status-badge { padding: 0.4em 0.8em; border-radius: 1rem; font-size: 0.8em; font-weight: 600; }
        .status-active { background-color: #d4edda; color: #155724; }
        .status-inactive { background-color: #f8d7da; color: #721c24; }
        .header-buttons .btn { margin-left: 10px; }
        .input-group-prepend .custom-select { border-right: 0; }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <span><i class="fas fa-users mr-2"></i>User Management</span>
            <div class="header-buttons">
                <a href="${pageContext.request.contextPath}/adminDashboard.jsp" class="btn btn-light"><i class="fas fa-home mr-1"></i> Home</a>
                <a href="${pageContext.request.contextPath}/admin/users?action=export&role=${selectedRoleId}&gender=${selectedGender}&status=${selectedStatus}&searchCategory=${searchCategory}&searchValue=${searchValue}" class="btn btn-success"><i class="fas fa-file-excel mr-1"></i> Export</a>
                <a href="${pageContext.request.contextPath}/signin" class="btn btn-danger"><i class="fas fa-sign-out-alt mr-1"></i> Log out</a>
            </div>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/users" method="get" class="filter-form mb-4">
                <div class="row">
                    <div class="col-md-3">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <%-- CHỈ dropdown này có onchange để tự động submit --%>
                                <select name="searchCategory" class="custom-select" onchange="this.form.submit()">
                                    <option value="">Search By</option>
                                    <option value="username" ${"username".equalsIgnoreCase(searchCategory) ? 'selected' : ''}>Username</option>
                                    <option value="email" ${"email".equalsIgnoreCase(searchCategory) ? 'selected' : ''}>Email</option>
                                </select>
                            </div>
                            <input type="text" name="searchValue" class="form-control" placeholder="Enter keyword..." value="${searchValue}">
                        </div>
                    </div>
                    
                    <div class="col-md-2">
                        <select name="role" class="form-control">
                            <option value="0">All Roles</option>
                            <c:forEach var="role" items="${roleList}">
                                <option value="${role.roleID}" ${role.roleID == selectedRoleId ? 'selected' : ''}>${role.roleName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <select name="gender" class="form-control">
                            <option value="">All Genders</option>
                            <option value="Male" ${"Male".equalsIgnoreCase(selectedGender) ? 'selected' : ''}>Male</option>
                            <option value="Female" ${"Female".equalsIgnoreCase(selectedGender) ? 'selected' : ''}>Female</option>
                             
                        </select>
                    </div>
                    <div class="col-md-2">
                        <select name="status" class="form-control">
                            <option value="-1">All Statuses</option>
                            <option value="1" ${1 == selectedStatus ? 'selected' : ''}>Active</option>
                            <option value="0" ${0 == selectedStatus ? 'selected' : ''}>Inactive</option>
                        </select>
                    </div>
                    <div class="col-md-3 d-flex">
                        <button type="submit" class="btn btn-primary mr-2"><i class="fas fa-filter mr-1"></i> Filter</button>
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary"><i class="fas fa-sync-alt mr-1"></i> Refresh </a>
                    </div>
                </div>
            </form>

            <div class="table-responsive">
                 <table class="table table-hover text-center">
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Gender</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${userList}">
                            <tr>
                                <td>${user.userID}</td>
                                <td>${user.username}</td>
                                <td>${user.email}</td>
                                <td>${not empty user.sex ? user.sex : 'N/A'}</td>
                                <td>${user.role.roleName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.status}"><span class="status-badge status-active">Active</span></c:when>
                                        <c:otherwise><span class="status-badge status-inactive">Inactive</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
    <button type="button" 
            class="btn btn-info btn-sm view-details-btn" 
            data-userid="${user.userID}" 
            data-toggle="modal" 
            data-target="#userDetailsModal">
        <i class="fas fa-eye"></i> Details
    </button>
</td>

                            </tr>
                        </c:forEach>
                        <c:if test="${empty userList}">
                            <tr>
                                <td colspan="7" class="text-center text-muted">No users found matching your criteria.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

                    <div class="modal fade" id="userDetailsModal" tabindex="-1" aria-labelledby="userDetailsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="userDetailsModalLabel">User Details</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="updateUserForm" action="${pageContext.request.contextPath}/admin/updateUser" method="post">
                    <input type="hidden" id="modalUserId" name="userId">
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="modalUsername">Username</label>
                                <input type="text" class="form-control" id="modalUsername" name="username" readonly>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="modalEmail">Email</label>
                                <input type="email" class="form-control" id="modalEmail" name="email">
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="modalFullName">Full Name</label>
                        <input type="text" class="form-control" id="modalFullName" name="fullName">
                    </div>
                    
                     <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="modalPhone">Phone</label>
                                <input type="text" class="form-control" id="modalPhone" name="phone">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="modalSex">Gender</label>
                                <select class="form-control" id="modalSex" name="sex">
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="modalAddress">Address</label>
                        <input type="text" class="form-control" id="modalAddress" name="address">
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="modalRole">Role</label>
                                <select class="form-control" id="modalRole" name="roleId">
                                    <c:forEach var="role" items="${roleList}">
                                        <option value="${role.roleID}">${role.roleName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="modalStatus">Status</label>
                                <select class="form-control" id="modalStatus" name="status">
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-primary" form="updateUserForm">Update Changes</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Sử dụng fetch API thay vì jQuery.ajax để không cần thêm thư viện lớn
    document.addEventListener('DOMContentLoaded', function () {
        // Khi một nút "Details" được click
        document.querySelectorAll('.view-details-btn').forEach(button => {
            button.addEventListener('click', function () {
                const userId = this.getAttribute('data-userid');
                
                // Gọi UserDetailsServlet để lấy dữ liệu
                fetch('${pageContext.request.contextPath}/admin/userDetails?id=' + userId)
                    .then(response => response.json())
                    .then(user => {
                        // Đổ dữ liệu vào các trường trong modal
                        document.getElementById('modalUserId').value = user.userID;
                        document.getElementById('modalUsername').value = user.username;
                        document.getElementById('modalEmail').value = user.email;
                        document.getElementById('modalFullName').value = user.fullName || '';
                        document.getElementById('modalPhone').value = user.phone || '';
                        document.getElementById('modalSex').value = user.sex || 'Male';
                        document.getElementById('modalAddress').value = user.address || '';
                        document.getElementById('modalRole').value = user.role.roleID;
                        document.getElementById('modalStatus').value = user.status ? '1' : '0';
                    })
                    .catch(error => console.error('Error fetching user details:', error));
            });
        });

        // Xử lý xác nhận khi update trạng thái
        const updateUserForm = document.getElementById('updateUserForm');
        const statusSelect = document.getElementById('modalStatus');
        let originalStatus;

        // Lưu lại trạng thái gốc khi modal mở
        $('#userDetailsModal').on('show.bs.modal', function () {
            originalStatus = statusSelect.value;
        });

        updateUserForm.addEventListener('submit', function (event) {
            // Kiểm tra nếu trạng thái được đổi thành "Inactive"
            if (statusSelect.value === '0' && originalStatus === '1') {
                const confirmation = confirm("Inactive account can't log in to the system. Are you sure?");
                if (!confirmation) {
                    event.preventDefault(); // Ngăn form submit
                }
            }
        });
    });
</script>

</body>
</html>