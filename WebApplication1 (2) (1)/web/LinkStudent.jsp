<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Link To Parent Account</title>
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: #eef3f9;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background-color: #333; /* Added a dark background to match the screenshot context */
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
            font-size: 28px; /* Slightly increased font size */
            font-weight: 600;
            margin-bottom: 8px;
            color: #2c3e50; /* Darker color */
            text-align: center;
        }

        .description {
            font-size: 14px;
            color: #555;
            text-align: center;
            margin-bottom: 20px;
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
            box-sizing: border-box; /* Ensures padding doesn't affect final width */
            width: 100%;
            padding: 12px 14px; /* Adjusted padding */
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
            min-height: 100px; /* Increased min-height */
            resize: vertical;
        }

        .button-group {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 25px;
        }

        .btn {
            padding: 10px 24px; /* Adjusted padding */
            border-radius: 6px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.2s ease;
            border: 1px solid transparent;
        }

        .btn-back {
            background: #fff;
            color: #455a64;
            border-color: #cfd8dc;
        }

        .btn-back:hover {
            background: #f5f7fa;
        }

        .btn-link {
            background: #007bff; /* Changed to a brighter blue */
            color: white;
            border-color: #007bff;
        }

        .btn-link:hover {
            background: #0069d9;
        }
        
        /* New style for simple error text */
        .error-message {
             text-align: center;
             color: #dc3545; /* Bootstrap's danger color */
             font-size: 14px;
             margin-bottom: 20px;
             min-height: 20px; /* Reserve space to prevent layout shift */
        }
    </style>
</head>
<body>

    <div class="form-container">
        <h1>Link To Parent Account</h1>
        <p class="description">Enter your parent's email to link account for learning and payment management.</p>

        <div class="error-message">
             <c:if test="${not empty error}">
                ${error}
            </c:if>
        </div>

        <form action="link" method="post">
            <div class="form-group">
                <label for="student-email">Parent Email *</label>
                <input type="email" id="student-email" name="student-email" placeholder="Enter parent's Email" required>
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
                <textarea id="note" name="note" placeholder="Content"></textarea>
            </div>

            <div class="button-group">
                <a href="profile" class="btn btn-back">Back</a>
                <button type="submit" class="btn btn-link">Link</button>
            </div>
        </form>
    </div>

</body>
</html>