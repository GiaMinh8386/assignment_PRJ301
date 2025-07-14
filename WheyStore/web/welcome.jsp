<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    response.setHeader("Pragma", "no-cache"); 
    response.setDateHeader("Expires", 0); 
%>
<%@page import="model.UserDTO"%>
<%@page import="utils.AuthUtils"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chào mừng - GymLife</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', sans-serif;
        }
        
        .welcome-container {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }
        
        .welcome-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            max-width: 500px;
            width: 100%;
        }
        
        .welcome-icon {
            font-size: 4rem;
            color: #b02a20;
            margin-bottom: 20px;
        }
        
        .welcome-title {
            color: #333;
            font-weight: 700;
            margin-bottom: 10px;
            font-size: 2rem;
        }
        
        .welcome-subtitle {
            color: #666;
            margin-bottom: 30px;
            font-size: 1.1rem;
        }
        
        .user-info-box {
            background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
            color: white;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 30px;
        }
        
        .user-info-box h5 {
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .user-detail {
            font-size: 0.9rem;
            opacity: 0.9;
            margin-bottom: 5px;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn-custom {
            padding: 12px 25px;
            border-radius: 25px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        
        .btn-primary-custom {
            background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
            color: white;
        }
        
        .btn-primary-custom:hover {
            background: linear-gradient(135deg, #8b1e16 0%, #6d1611 100%);
            transform: translateY(-2px);
            color: white;
        }
        
        .btn-outline-custom {
            background: transparent;
            border: 2px solid #b02a20;
            color: #b02a20;
        }
        
        .btn-outline-custom:hover {
            background: #b02a20;
            color: white;
            transform: translateY(-2px);
        }
        
        .btn-logout {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }
        
        .btn-logout:hover {
            background: linear-gradient(135deg, #c82333 0%, #bd2130 100%);
            transform: translateY(-2px);
            color: white;
        }
        
        @media (max-width: 768px) {
            .welcome-card {
                padding: 30px 20px;
            }
            
            .welcome-title {
                font-size: 1.5rem;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-custom {
                width: 100%;
                max-width: 300px;
            }
        }
    </style>
</head>
<body>

<%
    UserDTO user = AuthUtils.getCurrentUser(request);
    if (!AuthUtils.isLoggedIn(request)) {
        response.sendRedirect("MainController");
    } else {
%>

<div class="welcome-container">
    <div class="welcome-card">
        <div class="welcome-icon">
            <i class="fas fa-user-check"></i>
        </div>
        
        <h1 class="welcome-title">Chào mừng trở lại!</h1>
        <p class="welcome-subtitle">Bạn đã đăng nhập thành công vào hệ thống GymLife</p>
        
        <div class="user-info-box">
            <h5><i class="fas fa-user-circle me-2"></i><%= user.getFullName() %></h5>
            <div class="user-detail">
                <i class="fas fa-at me-2"></i>Username: <%= user.getUsername() %>
            </div>
            <%
                if (user.getEmail() != null && !user.getEmail().isEmpty()) {
            %>
            <div class="user-detail">
                <i class="fas fa-envelope me-2"></i>Email: <%= user.getEmail() %>
            </div>
            <%
                }
            %>
            <%
                if (user.getPhone() != null && !user.getPhone().isEmpty()) {
            %>
            <div class="user-detail">
                <i class="fas fa-phone me-2"></i>Phone: <%= user.getPhone() %>
            </div>
            <%
                }
            %>
            <div class="user-detail">
                <i class="fas fa-shield-alt me-2"></i>Role: 
                <%
                    if ("AD".equals(user.getRoleID())) {
                        out.print("Administrator");
                    } else if ("ST".equals(user.getRoleID())) {
                        out.print("Staff");
                    } else {
                        out.print("Member");
                    }
                %>
            </div>
        </div>
        
        <div class="action-buttons">
            <a href="MainController?action=home" class="btn btn-custom btn-primary-custom">
                <i class="fas fa-home me-2"></i>Về trang chủ
            </a>
            
           
            
            <%
                try {
                    if (AuthUtils.isAdmin(request)) {
            %>
                <a href="productForm.jsp" class="btn btn-custom btn-outline-custom">
                    <i class="fas fa-plus me-2"></i>Thêm sản phẩm
                </a>
            <%
                    }
                } catch (Exception e) {
                    // Handle exception silently
                }
            %>
            
            <button onclick="confirmLogout()" class="btn btn-custom btn-logout">
                <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
            </button>
        </div>
    </div>
</div>

<%
    }
%>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
function confirmLogout() {
    if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
        // Show loading state
        const btn = event.target;
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang đăng xuất...';
        btn.disabled = true;
        
        // Redirect to logout
        window.location.href = 'MainController?action=logout';
    }
}

document.addEventListener('DOMContentLoaded', function() {
    console.log('✅ Welcome page loaded successfully!');
    
    // Add smooth animations
    const card = document.querySelector('.welcome-card');
    if (card) {
        card.style.opacity = '0';
        card.style.transform = 'translateY(30px)';
        
        setTimeout(() => {
            card.style.transition = 'all 0.6s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, 100);
    }
    
    // Add hover effects to buttons
    const buttons = document.querySelectorAll('.btn-custom');
    buttons.forEach(btn => {
        btn.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-3px)';
        });
        
        btn.addEventListener('mouseleave', function() {
            if (!this.disabled) {
                this.style.transform = 'translateY(0)';
            }
        });
    });
});
</script>

</body>
</html>