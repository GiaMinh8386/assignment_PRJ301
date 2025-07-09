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
        <title>Đặt hàng thành công</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .success-container {
                max-width: 600px;
                margin: 80px auto;
                background: #f1f1f1;
                border-radius: 12px;
                padding: 40px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
            }

            .success-icon {
                font-size: 50px;
                color: green;
            }

            .btn-group-custom {
                margin-top: 30px;
            }

            .btn-group-custom a {
                margin-right: 15px;
            }
        </style>
    </head>
    <body>
        <div class="success-container text-center">
            <div class="success-icon mb-3">
                ✅
            </div>
            <h3>Đặt hàng thành công!</h3>
            <hr/>
            <p><strong>Mã đơn hàng:</strong> ${newOrderId}</p>
            <p><strong>Tổng tiền:</strong> ${orderTotal} VNĐ</p>
            <p><strong>Trạng thái:</strong> <span class="text-warning">Chờ xử lý</span></p>

            <div class="btn-group-custom">
                <a href="MainController?action=home" class="btn btn-primary">🏠 Về Trang chủ</a>
                <a href="OrderController?action=viewOrders" class="btn btn-success">📦 Xem đơn hàng</a>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
