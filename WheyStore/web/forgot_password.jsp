<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên Mật Khẩu - GymLife</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 🔧 SAME: Background as login.jsp */
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Segoe UI', sans-serif;
        }

        /* 🔧 SAME: Card design as login.jsp */
        .forgot-password-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            padding: 40px 30px;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            color: #333;
            text-align: center;
        }

        /* 🔧 SAME: Logo section as login */
        .logo-container {
            margin-bottom: 30px;
        }
        
        .logo-icon {
            font-size: 4rem;
            color: #b02a20;
            margin-bottom: 15px;
        }
        
        .brand-name {
            font-size: 2.5rem;
            font-weight: 700;
            color: #b02a20;
            margin-bottom: 5px;
            letter-spacing: 1px;
        }
        
        .brand-subtitle {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 20px;
            font-weight: 500;
        }

        /* Form styles same as login */
        .form-control {
            border-radius: 25px;
            padding: 12px 40px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #b02a20;
            box-shadow: 0 0 0 0.2rem rgba(176, 42, 32, 0.25);
        }
        
        .form-item-icon {
            position: absolute;
            top: 50%;
            left: 15px;
            transform: translateY(-50%);
            color: #b02a20;
            z-index: 10;
        }
        
        .form-group {
            position: relative;
            margin-bottom: 20px;
        }
        
        .btn-primary {
            border-radius: 25px;
            background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
            border: none;
            font-weight: 600;
            padding: 12px 30px;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #8b1e16 0%, #6d1611 100%);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(176, 42, 32, 0.4);
        }
        
        .text-muted a {
            color: #b02a20;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .text-muted a:hover {
            color: #8b1e16;
            text-decoration: underline;
        }
        
        .error-message {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            border-radius: 10px;
            padding: 10px;
            margin-top: 15px;
            font-size: 0.9rem;
        }

        .success-message {
            background: #d1e7dd;
            color: #0f5132;
            border: 1px solid #badbcc;
            border-radius: 10px;
            padding: 10px;
            margin-top: 15px;
            font-size: 0.9rem;
        }
        
        .divider {
            margin: 20px 0;
            text-align: center;
            position: relative;
        }
        
        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #e9ecef;
        }
        
        .divider span {
            background: rgba(255, 255, 255, 0.95);
            padding: 0 15px;
            color: #666;
            font-size: 0.9rem;
        }
        
        .quick-links {
            margin-top: 20px;
        }
        
        .quick-links a {
            display: inline-block;
            margin: 5px 10px;
            padding: 8px 15px;
            background: #f8f9fa;
            color: #666;
            text-decoration: none;
            border-radius: 20px;
            font-size: 0.85rem;
            transition: all 0.3s ease;
        }
        
        .quick-links a:hover {
            background: #b02a20;
            color: white;
            transform: translateY(-2px);
        }

        .info-box {
            background: #e7f3ff;
            border: 1px solid #b8daff;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            text-align: left;
        }

        .info-box i {
            color: #0066cc;
            margin-right: 8px;
        }
        
        @media (max-width: 576px) {
            .forgot-password-card {
                margin: 20px;
                padding: 30px 20px;
            }
            
            .brand-name {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>

<div class="forgot-password-card">
    <!-- 🔧 SAME: Logo Section as login -->
    <div class="logo-container">
        <div class="logo-icon">
            <i class="fas fa-dumbbell"></i>
        </div>
        <div class="brand-name">GymLife</div>
        <div class="brand-subtitle">Chuyên cung cấp thực phẩm bổ sung</div>
    </div>

    <h3 style="margin-bottom: 10px; color: #333;">Quên Mật Khẩu</h3>
    <p class="text-muted mb-4">Nhập email để lấy lại mật khẩu của bạn</p>

    <!-- Info box -->
    <div class="info-box">
        <i class="fas fa-info-circle"></i>
        <strong>Hướng dẫn:</strong><br>
        Nhập địa chỉ email đã đăng ký. Chúng tôi sẽ gửi mật khẩu mới về email của bạn.
    </div>

    <form action="MainController" method="post">
        <input type="hidden" name="action" value="forgotPassword">

        <div class="form-group">
            <span class="material-symbols-rounded form-item-icon">mail</span>
            <input type="email" name="email" class="form-control" placeholder="Nhập địa chỉ email" required autofocus>
        </div>

        <button type="submit" class="btn btn-primary w-100">
            <i class="fas fa-paper-plane me-2"></i>Gửi mã đặt lại mật khẩu
        </button>
    </form>

    <%
        Object objMessage = request.getAttribute("message");
        String message = (objMessage == null) ? "" : objMessage.toString();
        if (!message.isEmpty()) {
            // Check if it's a success message (contains "Mật khẩu mới")
            boolean isSuccess = message.contains("Mật khẩu mới") || message.contains("thành công");
    %>
        <div class="<%= isSuccess ? "success-message" : "error-message" %>">
            <i class="fas fa-<%= isSuccess ? "check-circle" : "exclamation-triangle" %> me-2"></i><%= message %>
        </div>
    <% } %>

    <div class="divider">
        <span>hoặc</span>
    </div>

    <div class="text-muted">
        Nhớ mật khẩu? <a href="login.jsp">Đăng nhập ngay</a>
    </div>

    <div class="text-muted mt-2">
        Chưa có tài khoản? <a href="register.jsp">Đăng ký mới</a>
    </div>

    <div class="quick-links">
        <a href="MainController?action=home">
            <i class="fas fa-home me-1"></i>Về trang chủ
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Add loading effect to submit button
        const forgotForm = document.querySelector('form');
        const submitBtn = document.querySelector('.btn-primary');
        
        forgotForm.addEventListener('submit', function() {
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang gửi...';
            submitBtn.disabled = true;
        });
        
        // Add floating animation to logo (same as login)
        const logoIcon = document.querySelector('.logo-icon');
        setInterval(() => {
            logoIcon.style.transform = 'translateY(-5px)';
            setTimeout(() => {
                logoIcon.style.transform = 'translateY(0)';
            }, 1000);
        }, 2000);

        // Auto focus email input
        const emailInput = document.querySelector('input[name="email"]');
        if (emailInput) {
            emailInput.focus();
        }
        
        console.log('✅ Forgot Password page loaded with GymLife branding!');
    });
</script>
</body>
</html>