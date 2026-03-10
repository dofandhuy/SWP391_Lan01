<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Sign Up</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 text-gray-800 flex flex-col min-h-screen">

        <!-- Header -->
        <header class="flex items-center p-6 bg-white shadow-md">
            <a href="signin" class="flex items-center text-gray-600 hover:text-teal-600 font-semibold">
                <span class="mr-2">&larr;</span> SIGN IN
            </a>
        </header>

        <!-- Main Content -->
        <main class="flex-1 flex justify-center items-center px-4 py-12">
            <div class="w-full max-w-6xl bg-white shadow-lg rounded-xl p-8">

                <h2 class="text-3xl font-bold text-center mb-6 text-gray-800">CREATE A NEW ACCOUNT</h2>

                <!-- Hiển thị thông báo từ Servlet -->
                <c:if test="${not empty mess}">
                    <div class="text-red-600 text-center mb-6 font-medium">${mess}</div>
                </c:if>

                <!-- Form đăng ký -->
                <form action="signup" method="post" class="grid grid-cols-1 md:grid-cols-2 gap-8">

                    <!-- Cột trái: bắt buộc -->
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium mb-1">User name *</label>
                            <input type="text" name="username" placeholder="Enter your User name"
                                   class="w-full border border-teal-400 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-teal-500" required/>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-1">Email Address *</label>
                            <input type="email" name="email" placeholder="Enter your Email Address"
                                   class="w-full border border-teal-400 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-teal-500" required/>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-1">Password *</label>
                            <input type="password" name="password" placeholder="Enter your Password"
                                   class="w-full border border-teal-400 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-teal-500" required/>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-1">Confirm password *</label>
                            <input type="password" name="confirmPassword" placeholder="Confirm your Password"
                                   class="w-full border border-teal-400 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-teal-500" required/>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-1">I am: *</label>
                            <select name="roleId" required
                                    class="w-full border border-teal-400 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-teal-500">
                                <option value="">-- Select Role --</option>
                                <c:forEach var="r" items="${roles}">
                                    <option value="${r.roleID}">${r.roleName}</option>
                                </c:forEach>
                            </select>
                        </div>

                    </div>

                    <!-- Cột phải: không bắt buộc -->
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium mb-1">Phone number</label>
                            <input type="text" name="phone" placeholder="Enter your Phone number"
                                   class="w-full border border-teal-400 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-teal-500"/>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-1">Date of Birth</label>
                            <input type="date" name="dob"
                                   class="w-full border border-teal-400 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-teal-500"/>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-1">Sex</label>
                            <div class="flex space-x-4 mt-2">
                                <label class="flex items-center gap-1"><input type="radio" name="sex" value="Male"> Male</label>
                                <label class="flex items-center gap-1"><input type="radio" name="sex" value="Female"> Female</label>
                            </div>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-1">Address</label>
                            <input type="text" name="address" placeholder="Enter your Address"
                                   class="w-full border border-teal-400 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-teal-500"/>
                        </div>
                    </div>

                    <!-- Button submit (chiếm cả 2 cột) -->
                    <div class="md:col-span-2 mt-6 flex justify-center">
                        <button type="submit"
                                class="px-10 py-3 bg-gradient-to-r from-teal-500 to-teal-600 text-white rounded-full font-semibold hover:from-teal-600 hover:to-teal-700 transition-all duration-300">
                            SIGN UP
                        </button>
                    </div>

                </form>
                <script>
                    document.querySelector("form").addEventListener("submit", function (e) {
                        let email = document.querySelector("input[name='email']").value.trim();
                        let password = document.querySelector("input[name='password']").value;
                        let confirmPassword = document.querySelector("input[name='confirmPassword']").value;
                        let role = document.querySelector("select[name='roleId'], input[name='role']:checked");
                        // Hỗ trợ cả dropdown (roleId) hoặc radio (role)

                        // Check Gmail
                        if (!/^[a-zA-Z0-9._%+-]+@gmail\.com$/.test(email)) {
                            alert("Vui lòng nhập địa chỉ Gmail hợp lệ (chỉ @gmail.com)!");
                            e.preventDefault();
                            return;
                        }

                        // Check password strength
                        let passRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;
                        if (!passRegex.test(password)) {
                            alert("Mật khẩu phải ≥ 8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt!");
                            e.preventDefault();
                            return;
                        }

                        // Check confirm password
                        if (password !== confirmPassword) {
                            alert("Mật khẩu xác nhận không khớp!");
                            e.preventDefault();
                            return;
                        }

                        // Check role
                        if (!role || role.value === "") {
                            alert("Vui lòng chọn Role!");
                            e.preventDefault();
                            return;
                        }
                    });
                </script>
            </div>
        </main>

        <!-- Footer -->
        <footer class="mt-auto">
            <jsp:include page="footer.jsp"/>
        </footer>

    </body>
</html>
