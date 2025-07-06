<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="utils.AuthUtils"%>
<%@page import="model.UserDTO"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng Nhập - GymLife</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- Bootstrap & Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                font-family: 'Segoe UI', sans-serif;
            }
            .login-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(15px);
                border-radius: 20px;
                padding: 40px 30px;
                width: 100%;
                max-width: 400px;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                color: #333;
                text-align: center;
            }
            
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
            
            .form-check-label {
                margin-left: 5px;
                color: #666;
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

            /* 🔧 ADDED: Success message styling */
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
            
            @media (max-width: 576px) {
                .login-card {
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

        <%
            if (AuthUtils.isLoggedIn(request)) {
                response.sendRedirect("welcome.jsp");
            } else {
        %>

        <div class="login-card">
            <!-- Logo Section -->
            <div class="logo-container">
                <div class="logo-icon">
                    <i class="fas fa-dumbbell"></i>
                </div>
                <div class="brand-name">GymLife</div>
                <div class="brand-subtitle">Chuyên cung cấp thực phẩm bổ sung</div>
            </div>

            <h3 style="margin-bottom: 10px; color: #333;">Đăng Nhập</h3>
            <p class="text-muted mb-4">Vui lòng đăng nhập để tiếp tục</p>

            <form action="MainController" method="post">
                <input type="hidden" name="action" value="login" />

                <div class="form-group">
                    <span class="material-symbols-rounded form-item-icon">person</span>
                    <input type="text" name="strUsername" class="form-control" placeholder="Tài khoản" required autofocus>
                </div>
                
                <div class="form-group">
                    <span class="material-symbols-rounded form-item-icon">lock</span>
                    <input type="password" name="strPassword" class="form-control" placeholder="Mật khẩu" required>
                </div>

                <button type="submit" class="btn btn-primary w-100">
                    <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                </button>
            </form>

            <%
                Object objMessage = request.getAttribute("message");
                String message = (objMessage == null) ? "" : objMessage.toString();
                if (!message.isEmpty()) {
                    // 🔧 FIXED: Check if it's a success message
                    boolean isSuccess = message.contains("thành công") || message.contains("Đăng nhập thành công") || 
                                       message.contains("successful") || message.contains("success");
            %>
            <div class="<%= isSuccess ? "success-message" : "error-message" %>">
                <i class="fas fa-<%= isSuccess ? "check-circle" : "exclamation-triangle" %> me-2"></i><%= message %>
            </div>
            <%
                }
            %>

            <div class="divider">
                <span>hoặc</span>
            </div>

            <div class="text-muted">
                Chưa có tài khoản? <a href="register.jsp">Đăng ký ngay</a>
            </div> 

            <div class="text-muted mt-2">
                <a href="forgot_password.jsp">Quên mật khẩu?</a>
            </div>

            <div class="quick-links">
                <a href="MainController?action=home">
                    <i class="fas fa-home me-1"></i>Về trang chủ
                </a>
            </div>
        </div>

        <% } %>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Add loading effect to login button
                const loginForm = document.querySelector('form');
                const loginBtn = document.querySelector('.btn-primary');
                
                loginForm.addEventListener('submit', function() {
                    loginBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang đăng nhập...';
                    loginBtn.disabled = true;
                });
                
                // Add floating animation to logo
                const logoIcon = document.querySelector('.logo-icon');
                setInterval(() => {
                    logoIcon.style.transform = 'translateY(-5px)';
                    setTimeout(() => {
                        logoIcon.style.transform = 'translateY(0)';
                    }, 1000);
                }, 2000);
                
                console.log('✅ Login page loaded with GymLife branding!');
            });
        </script>
    </body>
</html>