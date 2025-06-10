<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="utils.AuthUtils"%>
<%@page import="model.UserDTO"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng Nhập</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded" rel="stylesheet" />
    <style>
        body {
            background: linear-gradient(to right, #ffffff, #5b1776);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Segoe UI', sans-serif;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(12px);
            border-radius: 20px;
            padding: 40px 30px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        }
        .login-card .logo {
            width: 230px;
            height: auto;
            margin-bottom: 25px;
        }
        .form-control {
            border-radius: 30px;
            padding-left: 40px;
        }
        .form-item-icon {
            position: absolute;
            top: 50%;
            left: 15px;
            transform: translateY(-50%);
            color: #999;
        }
        .form-group {
            position: relative;
            margin-bottom: 20px;
        }
        .btn-primary {
            border-radius: 30px;
            background-color: #000;
            border: none;
            font-weight: bold;
        }
        .btn-primary:hover {
            background-color: #333;
        }
        .form-check-label {
            margin-left: 5px;
        }
        .text-muted a {
            text-decoration: none;
        }
        .error-message {
            color: #ff4444;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

<%
    if (AuthUtils.isLoggedIn(request)) {
        response.sendRedirect("welcome.jsp");
    } else {
%>

    <div class="login-card text-center">
        <img src="assets/img/gymstore.webp" alt="Gymstore Logo" class="logo">
        <h3>Đăng Nhập</h3>
        <p class="text-muted mb-4">Vui lòng Đăng Nhập Ở Đây</p>

        <form action="MainController" method="post">
            <input type="hidden" name="action" value="login" />
            
            <div class="form-group">
                <span class="material-symbols-rounded form-item-icon">person</span>
                <input type="text" name="strUsername" class="form-control" placeholder="Tài Khoản" required autofocus>
            </div>
            <div class="form-group">
                <span class="material-symbols-rounded form-item-icon">lock</span>
                <input type="password" name="strPassword" class="form-control" placeholder="Mật khẩu" required>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="form-check d-flex align-items-center">
                    <input type="checkbox" class="form-check-input" id="rememberMe" checked>
                    <label class="form-check-label" for="rememberMe">Nhớ mật khẩu</label>
                </div>
                <a href="#" class="text-muted">Quên mật khẩu!</a>
            </div>

            <button type="submit" class="btn btn-primary w-100">Đăng nhập</button>
        </form>

        <%
            Object objMessage = request.getAttribute("message");
            String message = (objMessage == null) ? "" : objMessage.toString();
            if (!message.isEmpty()) {
        %>
            <div class="mt-3 error-message">
                <%= message %>
            </div>
        <%
            }
        %>

        <div class="mt-3 text-muted">
            Tôi chưa có tài khoản? <a href="register.jsp">Tạo tài khoản</a>
        </div>
    </div>

<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
