<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sign In</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 text-gray-800 flex flex-col min-h-screen">

    <!-- Header -->
    <header class="flex items-center p-6 bg-white shadow-md">
        <a href="HomePage.jsp" class="flex items-center text-gray-600 hover:text-blue-600 font-semibold">
            <span class="mr-2">&larr;</span> HOME
        </a>
    </header>

    <!-- Main Content -->
    <main class="flex-1 flex justify-center items-center px-4 py-12">
        <div class="w-full max-w-6xl bg-white shadow-lg rounded-xl p-8 grid grid-cols-1 md:grid-cols-2 gap-8">

            <!-- Form login -->
            <div class="flex flex-col justify-center space-y-4">
                <h2 class="text-3xl font-bold text-gray-800 mb-2 text-center md:text-left">SIGN IN</h2>
                <p class="text-sm text-center md:text-left mb-4">Don't have an account? 
                    <a href="signup" class="text-blue-600">Sign up</a>
                </p>

                <!-- Hiển thị thông báo từ Servlet -->
                <c:if test="${not empty mess}">
                    <div class="text-red-600 text-center md:text-left mb-4 font-medium">${mess}</div>
                </c:if>

                <form action="signin" method="post" class="space-y-4" onsubmit="return validateForm()">

                    <div>
                        <label class="block text-sm font-medium mb-1">Email</label>
                        <input type="text" name="email" id="email"
                               value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                               class="w-full border border-blue-400 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"/>
                    </div>

                    <div>
                        <label class="block text-sm font-medium mb-1">Password</label>
                        <input type="password" name="password" id="password"
                               class="w-full border border-blue-400 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"/>
                    </div>

                    <a href="forgotPassword.jsp" class="text-sm text-gray-500">Forgot Password?</a>

                    <button type="submit"
                            class="w-full py-3 bg-gradient-to-r from-blue-500 to-blue-600 text-white rounded-full font-semibold hover:from-blue-600 hover:to-blue-700 transition-all duration-300">
                        SIGN IN
                    </button>

                </form>

                <script>
                    function validateForm() {
                        let email = document.getElementById("email").value.trim();
                        let password = document.getElementById("password").value;

                        if(email === "" || password === "") {
                            alert("Vui lòng nhập đầy đủ email và mật khẩu!");
                            return false;
                        }

                        let emailRegex = /^[\w._%+-]+@[\w.-]+\.[A-Za-z]{2,6}$/;
                        if(!emailRegex.test(email)) {
                            alert("Email không hợp lệ!");
                            return false;
                        }

                        if(password.length < 6) {
                            alert("Mật khẩu phải có ít nhất 6 ký tự!");
                            return false;
                        }

                        return true;
                    }
                </script>
            </div>

            <!-- Hình ảnh minh họa -->
            <div class="hidden md:flex justify-center items-center">
                <img src="image/classroom.jpg" alt="Classroom" class="rounded-lg shadow-lg">
            </div>

        </div>
    </main>

    <!-- Footer -->
    <footer class="mt-auto">
        <jsp:include page="footer.jsp"/>
    </footer>

</body>
</html>
