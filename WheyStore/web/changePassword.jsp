<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.UserDTO" %>
<%
    UserDTO user = (UserDTO) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("MainController?action=login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thay đổi mật khẩu - GymLife</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', sans-serif;
            padding: 20px 0;
        }
        
        .change-password-container {
            max-width: 500px;
            margin: 50px auto;
        }
        
        .password-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .card-header {
            background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
            color: white;
            padding: 25px 30px;
            text-align: center;
            border: none;
        }
        
        .header-icon {
            font-size: 3rem;
            margin-bottom: 15px;
        }
        
        .card-title {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .card-subtitle {
            opacity: 0.9;
            font-size: 0.95rem;
        }
        
        .card-body {
            padding: 40px 30px;
        }
        
        .user-info {
            background: #f8f9fa;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border-left: 4px solid #b02a20;
        }
        
        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        
        .form-control {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            transition: all 0.3s ease;
            font-size: 14px;
        }
        
        .form-control:focus {
            border-color: #b02a20;
            box-shadow: 0 0 0 0.2rem rgba(176, 42, 32, 0.25);
        }
        
        .input-group {
            position: relative;
        }
        
        .input-group .form-control {
            padding-right: 45px;
        }
        
        .password-toggle {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: none;
            color: #666;
            cursor: pointer;
            z-index: 10;
            padding: 5px;
        }
        
        .password-toggle:hover {
            color: #b02a20;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
            border: none;
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #8b1e16 0%, #6d1611 100%);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(176, 42, 32, 0.4);
        }
        
        .btn-secondary {
            background: #6c757d;
            border: none;
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            background: #545b62;
            transform: translateY(-2px);
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            font-weight: 500;
        }
        
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
        }
        
        .alert-success {
            background: #d1e7dd;
            color: #0f5132;
        }
        
        .password-requirements {
            background: #e7f3ff;
            border: 1px solid #b8daff;
            border-radius: 8px;
            padding: 15px;
            margin-top: 10px;
            font-size: 0.85rem;
        }
        
        .requirement-item {
            display: flex;
            align-items: center;
            margin-bottom: 5px;
        }
        
        .requirement-item:last-child {
            margin-bottom: 0;
        }
        
        .requirement-icon {
            width: 16px;
            margin-right: 8px;
            color: #0066cc;
        }
        
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        
        .back-link a {
            color: #b02a20;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .back-link a:hover {
            color: #8b1e16;
            text-decoration: underline;
        }
        
        @media (max-width: 576px) {
            .change-password-container {
                margin: 20px auto;
            }
            
            .card-body {
                padding: 30px 20px;
            }
            
            .card-header {
                padding: 20px;
            }
        }
        
        btn-back:hover {
    background-color: rgba(255, 255, 255, 0.1) !important;
    transform: translateX(-3px);
    color: #f8f9fa !important;
}

.btn-back {
    transition: all 0.3s ease;
}
    </style>
</head>
<body>

    <div class="container">
        <div class="change-password-container">
            <div class="password-card">
                <!-- Header -->
                <div class="card-header">
                    <div class="header-icon">
                        <i class="fas fa-key"></i>
                    </div>
                    <h2 class="card-title">Thay đổi mật khẩu</h2>
                    <p class="card-subtitle">Bảo mật tài khoản của bạn</p>
                </div>
                
                <!-- Body -->
                <div class="card-body">
                    <!-- User Info -->
                    <div class="user-info">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-user-circle fa-2x me-3 text-primary"></i>
                            <div>
                                <h6 class="mb-1"><%= user.getFullName() %></h6>
                                <small class="text-muted">@<%= user.getUsername() %></small>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Change Password Form -->
                    <form action="MainController" method="post" id="changePasswordForm">
                        <input type="hidden" name="action" value="changePassword">
                        
                        <!-- Current Password -->
                        <div class="mb-3">
                            <label for="currentPassword" class="form-label">
                                <i class="fas fa-lock me-2"></i>Mật khẩu hiện tại
                            </label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                <button type="button" class="password-toggle" onclick="togglePassword('currentPassword')">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                        
                        <!-- New Password -->
                        <div class="mb-3">
                            <label for="newPassword" class="form-label">
                                <i class="fas fa-key me-2"></i>Mật khẩu mới
                            </label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                <button type="button" class="password-toggle" onclick="togglePassword('newPassword')">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            
                            <!-- Password Requirements -->
                            <div class="password-requirements">
                                <h6 class="mb-2"><i class="fas fa-info-circle me-2"></i>Yêu cầu mật khẩu:</h6>
                                <div class="requirement-item">
                                    <i class="fas fa-check requirement-icon"></i>
                                    <span>Ít nhất 6 ký tự</span>
                                </div>
                                <div class="requirement-item">
                                    <i class="fas fa-check requirement-icon"></i>
                                    <span>Khác với mật khẩu hiện tại</span>
                                </div>
                                <div class="requirement-item">
                                    <i class="fas fa-check requirement-icon"></i>
                                    <span>Nên kết hợp chữ và số</span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Confirm Password -->
                        <div class="mb-4">
                            <label for="confirmPassword" class="form-label">
                                <i class="fas fa-check-double me-2"></i>Xác nhận mật khẩu mới
                            </label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                        
                        <!-- Buttons -->
                        <div class="d-flex gap-3">
                            <button type="submit" class="btn btn-primary flex-fill">
                                <i class="fas fa-save me-2"></i>Cập nhật mật khẩu
                            </button>
                            <a href="welcome.jsp" class="btn btn-secondary">
                                <i class="fas fa-times me-2"></i>Hủy
                            </a>
                        </div>
                    </form>
                    
                    <!-- Messages -->
                    <%
                        String errorMessage = (String) request.getAttribute("message");
                        String successMessage = (String) request.getAttribute("success");
                    %>
                    
                    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                    <div class="alert alert-danger mt-3">
                        <i class="fas fa-exclamation-triangle me-2"></i><%= errorMessage %>
                    </div>
                    <% } %>
                    
                    <% if (successMessage != null && !successMessage.isEmpty()) { %>
                    <div class="alert alert-success mt-3">
                        <i class="fas fa-check-circle me-2"></i><%= successMessage %>
                    </div>
                    <% } %>
                </div>
            </div>
            
            <!-- Back Link -->
            <div class="mb-3">
    <a href="welcome.jsp" class="btn-back text-white fw-bold text-decoration-none d-inline-flex align-items-center px-3 py-2 rounded">
        <i class="fas fa-arrow-left me-2"></i>Quay lại trang chủ
    </a>
</div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Toggle password visibility
        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            const icon = input.nextElementSibling.querySelector('i');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
        
        // Form validation
        document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const currentPassword = document.getElementById('currentPassword').value;
            
            // Check if new password matches confirm password
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu mới và xác nhận mật khẩu không khớp!');
                return false;
            }
            
            // Check if new password is different from current
            if (newPassword === currentPassword) {
                e.preventDefault();
                alert('Mật khẩu mới phải khác với mật khẩu hiện tại!');
                return false;
            }
            
            // Check password length
            if (newPassword.length < 6) {
                e.preventDefault();
                alert('Mật khẩu mới phải có ít nhất 6 ký tự!');
                return false;
            }
            
            // Show loading state
            const submitBtn = this.querySelector('button[type="submit"]');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang cập nhật...';
            submitBtn.disabled = true;
        });
        
        // Auto-logout redirect after successful password change
        const successMessage = document.querySelector(".alert-success");
        if (successMessage && successMessage.textContent.trim().length > 0) {
            let countdown = 5;
            const countdownElement = document.createElement('div');
            countdownElement.className = 'mt-2 text-center';
            countdownElement.innerHTML = `<small>Tự động đăng xuất sau <strong>${countdown}</strong> giây...</small>`;
            successMessage.appendChild(countdownElement);
            
            const timer = setInterval(() => {
                countdown--;
                countdownElement.innerHTML = `<small>Tự động đăng xuất sau <strong>${countdown}</strong> giây...</small>`;
                
                if (countdown <= 0) {
                    clearInterval(timer);
                    window.location.href = "MainController?action=logout&destination=login";
                }
            }, 1000);
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            console.log('✅ Change Password page loaded successfully!');
        });
    </script>

</body>
</html>