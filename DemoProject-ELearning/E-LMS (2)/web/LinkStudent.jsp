<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Link a New Student</title>
        <style>
            body {
                font-family: "Segoe UI", Arial, sans-serif;
                background: #eef3f9;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                margin: 0;
            }

            .form-container {
                width: 100%;
                max-width: 480px;
                background: #fff;
                padding: 35px 40px;
                border-radius: 16px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.08);
                animation: fadeIn 0.4s ease-in-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            h1 {
                font-size: 22px;
                margin-bottom: 8px;
                color: #1a237e;
                text-align: center;
            }

            .description {
                font-size: 14px;
                color: #555;
                text-align: center;
                margin-bottom: 25px;
            }

            .form-group {
                margin-bottom: 18px;
            }

            label {
                display: block;
                font-weight: 600;
                color: #333;
                margin-bottom: 6px;
            }

            input, select, textarea {
                width: 100%;
                padding: 10px 12px;
                font-size: 14px;
                border: 1px solid #cfd8dc;
                border-radius: 6px;
                transition: all 0.2s ease;
                background-color: #fafafa;
            }

            input:focus, select:focus, textarea:focus {
                border-color: #1976d2;
                background-color: #fff;
                box-shadow: 0 0 0 2px rgba(25,118,210,0.1);
                outline: none;
            }

            select {
                appearance: none;
                background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"><path fill="%23666" d="M7 10l5 5 5-5z"/></svg>');
                background-repeat: no-repeat;
                background-position: right 10px center;
                padding-right: 35px;
            }

            textarea {
                min-height: 80px;
                resize: vertical;
            }

            .button-group {
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                margin-top: 25px;
            }

            .btn {
                padding: 10px 20px;
                border-radius: 6px;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                transition: background 0.2s ease;
            }

            .btn-cancel {
                background: #eceff1;
                color: #455a64;
                border: none;
            }

            .btn-cancel:hover {
                background: #dfe3e6;
            }

            .btn-link {
                background: #1976d2;
                color: white;
                border: none;
            }

            .btn-link:hover {
                background: #1565c0;
            }

            .message {
                margin-bottom: 15px;
                padding: 10px 12px;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
            }

            .error {
                background-color: #fdecea;
                color: #c62828;
                border: 1px solid #f5c6cb;
            }

            .success {
                background-color: #e8f5e9;
                color: #2e7d32;
                border: 1px solid #c8e6c9;
            }
        </style>
    </head>
    <body>

        <div class="form-container">
            <h1>Link a New Student</h1>
            <p class="description">Enter your child's username and email to link their account.</p>

            <!-- Thông báo -->
            <c:if test="${not empty error}">
                <div class="message error">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="message success">${message}</div>
            </c:if>

            <form action="link" method="post">
                <div class="form-group">
                    <label for="student-username">Student Username *</label>
                    <input type="text" id="student-username" name="student-username" placeholder="Enter student's username" required>
                </div>

                <div class="form-group">
                    <label for="student-email">Student Email *</label>
                    <input type="email" id="student-email" name="student-email" placeholder="Enter student's email" required>
                </div>

                <div class="form-group">
                    <label for="relationship">Relationship *</label>
                    <select id="relationship" name="relationship" required>
                        <option value="" disabled selected>Select relationship</option>
                        <c:forEach var="r" items="${relationships}">
                            <option value="${r.relationshipName}">${r.relationshipName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="note">Note (optional)</label>
                    <textarea id="note" name="note" placeholder="Add a note..."></textarea>
                </div>

                <div class="button-group">
                    <a href="manage" class="btn btn-cancel">Cancel</a>
                    <button type="submit" class="btn btn-link">Link</button>
                </div>
            </form>
        </div>

    </body>
</html>
