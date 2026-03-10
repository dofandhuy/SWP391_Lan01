<%-- 
    Document   : resetPassword
    Created on : Sep 27, 2025, 12:39:46 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Reset password</title>

        <!-- Bootstrap -->
        <link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.3/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://unpkg.com/bs-brain@2.0.4/components/logins/login-6/assets/css/login-6.css">

        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

        <style>
            .password-wrapper {
                position: relative;
            }
            .toggle-password {
                position: absolute;
                top: 50%;
                right: 15px;
                transform: translateY(-50%);
                cursor: pointer;
                font-size: 1.2rem;
                color: #666;
            }
        </style>
    </head>
    <body style="background-color: #96DED1;">
        <section class="p-3 p-md-4 p-xl-5">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-12 col-md-9 col-lg-7 col-xl-6 col-xxl-5">
                        <div class="card border-0 shadow-sm rounded-4" style="margin-top: 170px">
                            <div class="card-body p-3 p-md-4 p-xl-5">
                                <div class="row">
                                    <div class="col-12">
                                        <div class="mb-5">
                                            <h3>Reset password</h3>
                                        </div>
                                    </div>
                                </div>
                                <form action="ResetPasswordServlet" method="POST">
                                    <div class="row gy-3 overflow-hidden">

                                        <!-- Email -->
                                        <div class="col-12">
                                            <div class="form-floating mb-3">
                                                <input type="email" class="form-control" value="${email}" name="email" id="email" placeholder="name@example.com" required>
                                                <label for="email" class="form-label">Email</label>
                                            </div>
                                        </div>

                                        <!-- Password -->
                                        <div class="col-12">
                                            <div class="form-floating mb-3 password-wrapper">
                                                <input type="password" class="form-control" name="password" id="password" placeholder="Password" required>
                                                <label for="password" class="form-label">Password</label>
                                                <i class="bi bi-eye-slash toggle-password" onclick="togglePassword('password', this)"></i>
                                            </div>
                                        </div>

                                        <!-- Confirm Password -->
                                        <div class="col-12">
                                            <div class="form-floating mb-3 password-wrapper">
                                                <input type="password" class="form-control" name="confirm_password" id="confirm_password" placeholder="Confirm Password" required>
                                                <label for="confirm_password" class="form-label">Confirm Password</label>
                                                <i class="bi bi-eye-slash toggle-password" onclick="togglePassword('confirm_password', this)"></i>
                                            </div>
                                        </div>

                                        <!-- Submit -->
                                        <div class="col-12">
                                            <div class="d-grid">
                                                <button class="btn bsb-btn-2xl btn-primary" style="background-color:#39A78E" type="submit">Reset password</button>
                                            </div>
                                        </div>
                                    </div>
                                    <p class="text-danger">${mess}</p>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Toggle JS -->
        <script>
            function togglePassword(fieldId, icon) {
                const input = document.getElementById(fieldId);
                if (input.type === "password") {
                    input.type = "text";
                    icon.classList.remove("bi-eye-slash");
                    icon.classList.add("bi-eye");
                } else {
                    input.type = "password";
                    icon.classList.remove("bi-eye");
                    icon.classList.add("bi-eye-slash");
                }
            }
        </script>
    </body>
</html>
