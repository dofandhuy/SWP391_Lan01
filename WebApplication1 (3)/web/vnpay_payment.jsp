<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Summary - VNPAY</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        body {
            margin: 0;
            font-family: "Poppins", sans-serif;
            background-color: #f7f9fb;
        }
        .sidebar {
            width: 220px;
            height: 100vh;
            background: #fff;
            box-shadow: 2px 0 6px rgba(0,0,0,0.1);
            position: fixed;
            padding: 20px;
        }
        .sidebar h2 {
            text-align: center;
            color: #1c2a5e;
        }
        .sidebar a {
            display: block;
            margin: 15px 0;
            color: #333;
            text-decoration: none;
            font-weight: 500;
        }
        .sidebar a:hover {
            color: #1c2a5e;
        }
        .content {
            margin-left: 250px;
            padding: 30px;
        }
        h1 {
            font-size: 22px;
            color: #1c2a5e;
        }
        .section-title {
            font-size: 18px;
            font-weight: 600;
            margin-top: 20px;
            color: #333;
        }
        .form-section {
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            width: 600px;
        }
        .form-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }
        .form-row label {
            flex: 1;
            font-weight: 500;
            color: #444;
        }
        .form-row input {
            flex: 2;
            padding: 8px;
            border-radius: 8px;
            border: 1px solid #ddd;
            outline: none;
        }
        .btn {
            background: #1c2a5e;
            color: white;
            padding: 10px 18px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: 0.3s;
        }
        .btn:hover {
            background: #2b3c8a;
        }
        .total {
            font-weight: bold;
            color: #1c2a5e;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>LMS</h2>
    <a href="dashboard.jsp"><i class="fa-solid fa-gauge"></i> Dash Board</a>
    <a href="students.jsp"><i class="fa-solid fa-user-graduate"></i> Student Management</a>
    <a href="requests.jsp"><i class="fa-solid fa-book"></i> Course Requests</a>
    <a href="payments.jsp"><i class="fa-solid fa-clock-rotate-left"></i> Payment History</a>
    <a href="logout.jsp" style="color:red;"><i class="fa-solid fa-right-from-bracket"></i> Log Out</a>
</div>

<div class="content">
    <h1>Course request &gt; Payment Summary</h1>

    <div class="form-section">
        <div class="section-title">Course Information</div>
        <div class="form-row">
            <label>Course Name:</label>
            <input type="text" name="courseName" value="${course.name}" readonly>
        </div>
        <div class="form-row">
            <label>Student:</label>
            <input type="text" name="studentName" value="${student.name}" readonly>
        </div>

        <div class="section-title">Payment Details</div>
        <form action="vnpay_payment" method="post">
            <div class="form-row">
                <label>Course Price:</label>
                <input type="number" id="price" name="amount" value="${course.price}" readonly>
            </div>
            <div class="form-row">
                <label>Discount:</label>
                <input type="number" id="discount" name="discount" value="0">
            </div>
            <div class="form-row">
                <label>Tax (5%):</label>
                <input type="number" id="tax" name="tax" readonly>
            </div>
            <div class="form-row total">
                <label>Total Amount:</label>
                <input type="number" id="total" name="total" readonly>
            </div>
            <div style="text-align:center; margin-top:20px;">
                <button type="button" class="btn" onclick="calculateTotal()">Calculate</button>
                <button type="submit" class="btn">Pay with VNPAY</button>
            </div>
        </form>
    </div>
</div>

<script>
function calculateTotal() {
    const price = parseFloat(document.getElementById('price').value) || 0;
    const discount = parseFloat(document.getElementById('discount').value) || 0;
    const tax = (price - discount) * 0.05;
    const total = (price - discount) + tax;

    document.getElementById('tax').value = tax.toFixed(2);
    document.getElementById('total').value = total.toFixed(2);
}
</script>

</body>
</html>
