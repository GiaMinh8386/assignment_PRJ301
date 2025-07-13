<%-- 
    Document   : checkoutSuccess
    Created on : Jul 9, 2025, 6:09:12 PM
    Author     : PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="model.OrderDTO"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đặt hàng thành công - GymLife</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .success-container {
                max-width: 500px;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 20px;
                padding: 40px;
                box-shadow: 
                    0 25px 50px rgba(0, 0, 0, 0.1),
                    0 0 0 1px rgba(255, 255, 255, 0.2);
                text-align: center;
                position: relative;
                overflow: hidden;
                animation: slideUp 0.8s ease-out;
            }

            .success-container::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, #28a745, #20c997, #17a2b8);
                border-radius: 20px 20px 0 0;
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(50px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .success-icon {
                font-size: 80px;
                color: #28a745;
                margin-bottom: 20px;
                animation: bounce 1s ease-in-out;
                text-shadow: 0 4px 8px rgba(40, 167, 69, 0.3);
            }

            @keyframes bounce {
                0%, 20%, 50%, 80%, 100% {
                    transform: translateY(0);
                }
                40% {
                    transform: translateY(-20px);
                }
                60% {
                    transform: translateY(-10px);
                }
            }

            .success-title {
                color: #2c3e50;
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 25px;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .order-info {
                background: linear-gradient(135deg, #f8f9fa, #e9ecef);
                border-radius: 15px;
                padding: 25px;
                margin: 25px 0;
                border: 1px solid rgba(0, 0, 0, 0.1);
            }

            .order-info p {
                margin: 10px 0;
                font-size: 16px;
                color: #495057;
            }

            .order-info strong {
                color: #2c3e50;
            }

            .order-id {
                font-size: 24px;
                color: #007bff !important;
                font-weight: 700;
            }

            .order-total {
                font-size: 20px;
                color: #28a745 !important;
                font-weight: 700;
            }

            .status-badge {
                background: linear-gradient(135deg, #ffc107, #ff8c00);
                color: white;
                padding: 8px 16px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 14px;
                text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
            }

            .btn-group-custom {
                margin-top: 30px;
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
                position: relative;
                overflow: hidden;
                min-width: 150px;
            }

            .btn-home {
                background: linear-gradient(135deg, #007bff, #0056b3);
                color: white;
                box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
            }

            .btn-home:hover {
                color: white;
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(0, 123, 255, 0.4);
            }

            .btn-orders {
                background: linear-gradient(135deg, #28a745, #20c997);
                color: white;
                box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
            }

            .btn-orders:hover {
                color: white;
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(40, 167, 69, 0.4);
            }

            .btn-custom::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                transition: left 0.5s;
            }

            .btn-custom:hover::before {
                left: 100%;
            }

            .confetti {
                position: absolute;
                width: 10px;
                height: 10px;
                background: #f39c12;
                animation: confetti-fall 3s linear infinite;
            }

            @keyframes confetti-fall {
                to {
                    transform: translateY(100vh) rotate(360deg);
                }
            }

            .back-to-site {
                position: absolute;
                top: 20px;
                left: 20px;
                color: white;
                text-decoration: none;
                font-size: 14px;
                opacity: 0.8;
                transition: opacity 0.3s;
            }

            .back-to-site:hover {
                color: white;
                opacity: 1;
            }

            @media (max-width: 576px) {
                .success-container {
                    margin: 20px;
                    padding: 30px 20px;
                }
                
                .btn-group-custom {
                    flex-direction: column;
                    align-items: center;
                }
                
                .btn-custom {
                    width: 100%;
                    max-width: 200px;
                }
            }
        </style>
    </head>
    <body>
        <a href="MainController?action=home" class="back-to-site">
            <i class="fas fa-arrow-left me-1"></i>Quay lại trang chủ
        </a>

        <div class="success-container">
            <div class="success-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            
            <h1 class="success-title">Đặt hàng thành công!</h1>
            
            <div class="order-info">
                <p><strong>Mã đơn hàng:</strong></p>
                <p class="order-id">#${newOrderId}</p>
                
                <hr style="margin: 20px 0; border-color: rgba(0,0,0,0.1);">
                
                <p><strong>Tổng tiền:</strong></p>
                <p class="order-total">${String.format("%,.0f", orderTotal)} VNĐ</p>
                
                <p style="margin-top: 20px;"><strong>Trạng thái:</strong></p>
                <span class="status-badge">Chờ xử lý</span>
            </div>

            <div class="btn-group-custom">
                <a href="MainController?action=home" class="btn-custom btn-home">
                    <i class="fas fa-home me-2"></i>Về trang chủ
                </a>
                <a href="OrderController?action=viewOrders" class="btn-custom btn-orders">
                    <i class="fas fa-box me-2"></i>Xem đơn hàng
                </a>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Tạo hiệu ứng confetti
            function createConfetti() {
                const colors = ['#f39c12', '#e74c3c', '#9b59b6', '#3498db', '#2ecc71'];
                
                for (let i = 0; i < 50; i++) {
                    setTimeout(() => {
                        const confetti = document.createElement('div');
                        confetti.className = 'confetti';
                        confetti.style.left = Math.random() * 100 + 'vw';
                        confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                        confetti.style.animationDuration = (Math.random() * 2 + 2) + 's';
                        confetti.style.animationDelay = Math.random() + 's';
                        document.body.appendChild(confetti);
                        
                        setTimeout(() => {
                            confetti.remove();
                        }, 5000);
                    }, i * 100);
                }
            }

            // Khởi chạy confetti khi trang load
            window.addEventListener('load', () => {
                setTimeout(createConfetti, 500);
            });

            // Thêm hiệu ứng hover cho icon
            const successIcon = document.querySelector('.success-icon i');
            successIcon.addEventListener('mouseenter', () => {
                successIcon.style.transform = 'scale(1.1) rotate(5deg)';
            });
            
            successIcon.addEventListener('mouseleave', () => {
                successIcon.style.transform = 'scale(1) rotate(0deg)';
            });

            console.log('✅ Checkout success page loaded with enhanced animations!');
        </script>
    </body>
</html>