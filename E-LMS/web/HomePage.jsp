<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>E-LMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 text-gray-800">

    <!-- Header -->
    <header class="flex justify-between items-center px-10 py-4 bg-white shadow-md sticky top-0 z-50">
        <h1 class="text-2xl font-bold text-blue-600">E-LMS</h1>
        <nav class="hidden md:flex gap-6 text-sm font-medium">
            <a href="#" class="hover:text-blue-700 transition">Trang chủ</a>
            <a href="#" class="hover:text-blue-700 transition">Tính năng</a>
            <a href="#" class="hover:text-blue-700 transition">Giá</a>
            <a href="#" class="hover:text-blue-700 transition">Liên hệ</a>
        </nav>
        <div class="flex gap-3">
            <a href="signin" class="px-4 py-2 border rounded-lg hover:bg-gray-100 transition">Sign In</a>
            <a href="signup" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition">Sign Up</a>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="grid grid-cols-1 md:grid-cols-2 px-10 py-20 gap-10 items-center bg-white rounded-b-3xl shadow-lg mx-10 mt-6">
        <div>
            <h2 class="text-4xl md:text-5xl font-bold mb-6 leading-tight text-gray-800">
                Một cách hiệu quả để <br /> quản lý lớp học
            </h2>
            <p class="text-gray-600 mb-6 text-lg">
                ✔ Hơn 10,000 lớp học đang sử dụng<br/>
                ✔ Hỗ trợ đa nền tảng<br/>
                ✔ Được tin tưởng bởi nhiều trường học
            </p>
            <a href="Signup.jsp" class="px-8 py-4 bg-blue-600 text-white rounded-lg font-semibold hover:bg-blue-700 transition">
                Tham gia ngay
            </a>
        </div>
        <div class="flex justify-center">
            <img src="pictures/bandovn.png" alt="Vietnam Map" class="w-full max-w-md rounded-lg shadow-md">
        </div>
    </section>

    <!-- Features Section -->
    <section class="px-10 py-16 text-center">
        <h3 class="text-3xl font-bold mb-12">Kho học liệu số khổng lồ</h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
            <div class="p-6 bg-white rounded-lg shadow hover:shadow-lg transition">Quản lý lớp học dễ dàng</div>
            <div class="p-6 bg-white rounded-lg shadow hover:shadow-lg transition">Theo dõi tiến độ học tập</div>
            <div class="p-6 bg-white rounded-lg shadow hover:shadow-lg transition">Tích hợp nhiều công cụ</div>
            <div class="p-6 bg-white rounded-lg shadow hover:shadow-lg transition">Bảo mật và an toàn dữ liệu</div>
            <div class="p-6 bg-white rounded-lg shadow hover:shadow-lg transition">Truy cập mọi lúc mọi nơi</div>
            <div class="p-6 bg-white rounded-lg shadow hover:shadow-lg transition">Thống kê chi tiết và trực quan</div>
            <div class="p-6 bg-white rounded-lg shadow hover:shadow-lg transition">Quản lý học sinh và giáo viên</div>
            <div class="p-6 bg-white rounded-lg shadow hover:shadow-lg transition">Tối ưu hóa trải nghiệm người dùng</div>
        </div>
    </section>

    <!-- Trusted Section -->
    <section class="px-10 py-16 text-center bg-gray-50">
        <h3 class="text-2xl font-bold mb-8">Đồng hành và tin cậy</h3>
        <div class="flex justify-center gap-8 flex-wrap">
            <div class="w-28 h-14 bg-gray-100 rounded shadow-sm flex items-center justify-center">Logo 1</div>
            <div class="w-28 h-14 bg-gray-100 rounded shadow-sm flex items-center justify-center">Logo 2</div>
            <div class="w-28 h-14 bg-gray-100 rounded shadow-sm flex items-center justify-center">Logo 3</div>
            <div class="w-28 h-14 bg-gray-100 rounded shadow-sm flex items-center justify-center">Logo 4</div>
            <div class="w-28 h-14 bg-gray-100 rounded shadow-sm flex items-center justify-center">Logo 5</div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-white mt-6 shadow-inner py-6 text-center text-gray-600">
        <%@ include file="footer.jsp" %>
    </footer>

</body>
</html>
