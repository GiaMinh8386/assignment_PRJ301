<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng Ký</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded" rel="stylesheet" />
    <style>
        body {
   background: linear-gradient(to right, #ffffff, #a94455);

    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    font-family: 'Segoe UI', sans-serif;
}

        .register-card {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(12px);
            border-radius: 20px;
            padding: 40px 30px;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        }

        .register-card .logo {
            width: 230px;
            height: auto;
            margin-bottom: 25px;
        }

        .form-control {
            border-radius: 30px;
            padding-left: 40px;
        }

        .form-group {
            position: relative;
            margin-bottom: 20px;
        }

        .form-item-icon {
            position: absolute;
            top: 50%;
            left: 15px;
            transform: translateY(-50%);
            color: #999;
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

        .error-message {
            color: #ff4444;
            font-size: 0.9rem;
        }

        .text-muted a {
            text-decoration: none;
        }
    </style>
</head>
<body>

<div class="register-card text-center">
    <img src="assets/img/gymstore.webp" alt="Gymstore Logo" class="logo">
    <h3>Đăng Ký</h3>
    <p class="text-muted mb-4">Tạo tài khoản của bạn ngay hôm nay</p>

    <form action="MainController" method="post">
        <input type="hidden" name="action" value="register" />

        <div class="form-group">
            <span class="material-symbols-rounded form-item-icon">badge</span>
            <input type="text" name="fullName" class="form-control" placeholder="Họ và tên" required>
        </div>

        <div class="form-group">
            <span class="material-symbols-rounded form-item-icon">call</span>
            <input type="text" name="phone" class="form-control" placeholder="Số điện thoại" required>
        </div>

        <div class="form-group">
            <span class="material-symbols-rounded form-item-icon">home</span>
            <input type="text" name="address" class="form-control" placeholder="Địa chỉ" required>
        </div>

        <div class="form-group">
            <span class="material-symbols-rounded form-item-icon">mail</span>
            <input type="email" name="email" class="form-control" placeholder="Email" required>
        </div>

        <div class="form-group">
            <span class="material-symbols-rounded form-item-icon">person</span>
            <input type="text" name="username" class="form-control" placeholder="Tên đăng nhập" required>
        </div>

        <div class="form-group">
            <span class="material-symbols-rounded form-item-icon">lock</span>
            <input type="password" name="password" class="form-control" placeholder="Mật khẩu" required>
        </div>

        <div class="form-group">
            <span class="material-symbols-rounded form-item-icon">lock</span>
            <input type="password" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu" required>
        </div>

        <button type="submit" class="btn btn-primary w-100">Đăng Ký</button>
    </form>

    <% 
        Object objMessage = request.getAttribute("message");
        String message = (objMessage == null) ? "" : objMessage.toString();
        if (!message.isEmpty()) {
    %>
        <div class="mt-3 error-message">
            <%= message %>
        </div>
    <% } %>

    <div class="mt-3 text-muted">
        Đã có tài khoản? <a href="login.jsp">Đăng nhập ngay</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
