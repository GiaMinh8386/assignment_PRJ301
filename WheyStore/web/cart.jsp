<%@ page import="java.util.*, model.CartItemDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng - GymLife</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', sans-serif;
        }
        
        .cart-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            padding: 30px;
            margin: 30px auto;
            max-width: 1000px;
        }
        
        .cart-header {
            background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .cart-table {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .cart-table th {
            background: #f8f9fa;
            border: none;
            font-weight: 600;
            color: #333;
            padding: 15px;
        }
        
        .cart-table td {
            border: none;
            padding: 15px;
            vertical-align: middle;
        }
        
        .cart-table tr {
            border-bottom: 1px solid #e9ecef;
        }
        
        .cart-table tr:last-child {
            border-bottom: none;
        }
        
        .product-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .product-name {
            font-weight: 600;
            color: #333;
            margin: 0;
        }
        
        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .quantity-input {
            width: 70px;
            text-align: center;
            border: 2px solid #e9ecef;
            border-radius: 5px;
            font-weight: 600;
        }
        
        .btn-quantity {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        
        .btn-update {
            background: #28a745;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .btn-remove {
            background: #dc3545;
            color: white;
            border: none;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .cart-summary {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            margin-top: 30px;
        }
        
        .total-row {
            font-size: 1.25rem;
            font-weight: 700;
            color: #b02a20;
            border-top: 2px solid #b02a20;
            padding-top: 15px;
            margin-top: 15px;
        }
        
        .checkout-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            padding: 15px 40px;
            border-radius: 25px;
            color: white;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .checkout-btn:hover {
            background: linear-gradient(135deg, #218838 0%, #17a2b8 100%);
            transform: translateY(-2px);
            color: white;
            text-decoration: none;
        }
        
        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        
        .empty-cart i {
            font-size: 5rem;
            margin-bottom: 20px;
            color: #dee2e6;
        }
        
        .continue-shopping {
            background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .continue-shopping:hover {
            background: linear-gradient(135deg, #8b1e16 0%, #6d1611 100%);
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
        }

        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9999;
            display: none;
            align-items: center;
            justify-content: center;
        }

        .loading-content {
            background: white;
            padding: 30px;
            border-radius: 10px;
            text-align: center;
        }

        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #b02a20;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 2s linear infinite;
            margin: 0 auto 15px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>

    <!-- Include Header -->
    <%@ include file="header.jsp" %>
    
    <div class="container">
        <div class="cart-container">
            <%
                Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) request.getAttribute("cartItems");
                Integer totalItems = (Integer) request.getAttribute("totalItems");
                java.math.BigDecimal totalAmount = (java.math.BigDecimal) request.getAttribute("totalAmount");
                
                if (cart == null || cart.isEmpty()) {
            %>
            <!-- Empty Cart State -->
            <div class="cart-header">
                <h2><i class="fas fa-shopping-cart me-3"></i>Giỏ hàng của bạn</h2>
            </div>
            
            <div class="empty-cart">
                <i class="fas fa-shopping-cart"></i>
                <h3>Giỏ hàng trống!</h3>
                <p>Bạn chưa có sản phẩm nào trong giỏ hàng. Hãy tiếp tục mua sắm để thêm sản phẩm.</p>
                <a href="MainController?action=home" class="continue-shopping">
                    <i class="fas fa-arrow-left me-2"></i>Tiếp tục mua sắm
                </a>
            </div>
            <%
                } else {
            %>
            <!-- Cart with Items -->
            <div class="cart-header">
                <h2><i class="fas fa-shopping-cart me-3"></i>Giỏ hàng của bạn</h2>
                <p class="mb-0">Bạn có <%= totalItems != null ? totalItems : cart.size() %> sản phẩm trong giỏ hàng</p>
            </div>
            
            <div class="table-responsive">
                <table class="table cart-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Sản phẩm</th>
                            <th>Đơn giá</th>
                            <th>Số lượng</th>
                            <th>Tạm tính</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int idx = 0;
                            java.math.BigDecimal grandTotal = java.math.BigDecimal.ZERO;
                            
                            for (CartItemDTO item : cart.values()) {
                                idx++;
                                java.math.BigDecimal lineTotal = item.getLineTotal();
                                grandTotal = grandTotal.add(lineTotal);
                        %>
                        <tr id="row-<%= item.getProductID() %>">
                            <td><strong><%= idx %></strong></td>
                            <td>
                                <div class="product-info">
                                    <div>
                                        <h6 class="product-name"><%= item.getProductName() %></h6>
                                        <small class="text-muted">ID: <%= item.getProductID() %></small>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <strong class="text-primary">
                                    <%= String.format("%,.0f", item.getUnitPrice()) %> ₫
                                </strong>
                            </td>
                            <td>
                                <div class="quantity-controls">
                                    <button type="button" class="btn btn-outline-secondary btn-quantity" onclick="decreaseQuantity('<%= item.getProductID() %>')">
                                        <i class="fas fa-minus"></i>
                                    </button>
                                    <input type="number" 
                                           id="qty-<%= item.getProductID() %>"
                                           value="<%= item.getQuantity() %>" 
                                           min="1" 
                                           max="99"
                                           class="form-control quantity-input"
                                           onchange="updateQuantity('<%= item.getProductID() %>', this.value)">
                                    <button type="button" class="btn btn-outline-secondary btn-quantity" onclick="increaseQuantity('<%= item.getProductID() %>')">
                                        <i class="fas fa-plus"></i>
                                    </button>
                                </div>
                            </td>
                            <td>
                                <strong class="text-success" id="total-<%= item.getProductID() %>">
                                    <%= String.format("%,.0f", lineTotal) %> ₫
                                </strong>
                            </td>
                            <td>
                                <button type="button" class="btn btn-remove" onclick="removeItem('<%= item.getProductID() %>')" title="Xóa sản phẩm">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <!-- Cart Summary -->
            <div class="cart-summary">
                <div class="row">
                    <div class="col-8">
                        <h5>Tóm tắt đơn hàng</h5>
                        <p class="text-muted">Kiểm tra lại thông tin trước khi thanh toán</p>
                        
                        <div class="d-flex gap-2 mt-3">
                            <a href="MainController?action=home" class="continue-shopping">
                                <i class="fas fa-arrow-left me-2"></i>Tiếp tục mua sắm
                            </a>
                            <button type="button" class="btn btn-outline-danger" onclick="clearCart()">
                                <i class="fas fa-trash me-2"></i>Xóa tất cả
                            </button>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="text-end">
                            <div class="mb-2">
                                <span>Tổng số lượng: </span>
                                <strong id="totalItemsDisplay"><%= totalItems != null ? totalItems : "0" %> sản phẩm</strong>
                            </div>
                            <div class="mb-2">
                                <span>Phí vận chuyển: </span>
                                <strong class="text-success">Miễn phí</strong>
                            </div>
                            <hr>
                            <div class="total-row">
                                <span>Tổng cộng: </span>
                                <span id="grandTotalDisplay"><%= String.format("%,.0f", totalAmount != null ? totalAmount : grandTotal) %> ₫</span>
                            </div>
                            
                            <!-- Check if user is logged in for checkout -->
                            <%
                                model.UserDTO currentUser = (model.UserDTO) session.getAttribute("user");
                                if (currentUser != null) {
                            %>
                            <form action="OrderController" method="post" class="mt-4">
                                <input type="hidden" name="action" value="createOrder">
                                <button type="submit" class="checkout-btn w-100">
                                    <i class="fas fa-credit-card me-2"></i>Thanh toán ngay
                                </button>
                            </form>
                            <%
                                } else {
                            %>
                            <div class="mt-4">
                                <p class="text-muted small">Vui lòng đăng nhập để thanh toán</p>
                                <a href="login.jsp" class="checkout-btn w-100 text-center">
                                    <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập để thanh toán
                                </a>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>
            <%
                }
            %>
        </div>
    </div>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-content">
            <div class="spinner"></div>
            <p>Đang cập nhật giỏ hàng...</p>
        </div>
    </div>

    <!-- Include Footer -->
    <%@ include file="footer.jsp" %>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Show/Hide loading overlay
        function showLoading() {
            document.getElementById('loadingOverlay').style.display = 'flex';
        }

        function hideLoading() {
            document.getElementById('loadingOverlay').style.display = 'none';
        }

        // Increase quantity
        function increaseQuantity(productId) {
            const input = document.getElementById('qty-' + productId);
            const currentValue = parseInt(input.value);
            if (currentValue < 99) {
                input.value = currentValue + 1;
                updateQuantity(productId, input.value);
            }
        }

        // Decrease quantity
        function decreaseQuantity(productId) {
            const input = document.getElementById('qty-' + productId);
            const currentValue = parseInt(input.value);
            if (currentValue > 1) {
                input.value = currentValue - 1;
                updateQuantity(productId, input.value);
            }
        }

        // Update quantity via AJAX
        function updateQuantity(productId, newQuantity) {
            showLoading();

            const formData = new FormData();
            formData.append('action', 'update');
            formData.append('productID', productId);
            formData.append('qty', newQuantity);

            fetch('<%= request.getContextPath() %>/CartController', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    // Reload page to show updated cart
                    setTimeout(() => {
                        window.location.reload();
                    }, 500);
                } else {
                    throw new Error('Network response was not ok');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                hideLoading();
                alert('Có lỗi xảy ra khi cập nhật số lượng!');
                // Reset input value
                document.getElementById('qty-' + productId).value = <%= "'+currentQuantity+'" %>;
            });
        }

        // Remove item from cart
        function removeItem(productId) {
            if (confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?')) {
                showLoading();

                const formData = new FormData();
                formData.append('action', 'remove');
                formData.append('productID', productId);

                fetch('<%= request.getContextPath() %>/CartController', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (response.ok) {
                        // Remove row with animation
                        const row = document.getElementById('row-' + productId);
                        row.style.transition = 'opacity 0.3s ease';
                        row.style.opacity = '0';
                        
                        setTimeout(() => {
                            window.location.reload();
                        }, 300);
                    } else {
                        throw new Error('Network response was not ok');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    hideLoading();
                    alert('Có lỗi xảy ra khi xóa sản phẩm!');
                });
            }
        }

        // Clear entire cart
        function clearCart() {
            if (confirm('Bạn có chắc muốn xóa toàn bộ giỏ hàng?')) {
                showLoading();

                const formData = new FormData();
                formData.append('action', 'clear');

                fetch('<%= request.getContextPath() %>/CartController', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (response.ok) {
                        setTimeout(() => {
                            window.location.reload();
                        }, 500);
                    } else {
                        throw new Error('Network response was not ok');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    hideLoading();
                    alert('Có lỗi xảy ra khi xóa giỏ hàng!');
                });
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            console.log('✅ Cart page loaded successfully!');
            
            // Handle quantity input changes
            const quantityInputs = document.querySelectorAll('.quantity-input');
            quantityInputs.forEach(input => {
                input.addEventListener('change', function() {
                    if (this.value < 1) {
                        this.value = 1;
                    }
                    const productId = this.id.replace('qty-', '');
                    updateQuantity(productId, this.value);
                });

                // Handle enter key
                input.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        this.blur(); // Trigger change event
                    }
                });
            });

            // Auto-save when user stops typing (debounce)
            let typingTimer;
            quantityInputs.forEach(input => {
                input.addEventListener('keyup', function() {
                    clearTimeout(typingTimer);
                    const productId = this.id.replace('qty-', '');
                    const value = this.value;
                    
                    typingTimer = setTimeout(() => {
                        if (value !== this.defaultValue) {
                            updateQuantity(productId, value);
                        }
                    }, 1000); // Wait 1 second after user stops typing
                });
            });
        });
    </script>

</body>
</html>