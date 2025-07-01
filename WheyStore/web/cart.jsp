<%@ page import="java.util.*, model.CartItemDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chỉnh sửa giỏ hàng - GymLife</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* ... (giữ nguyên style cũ) ... */
        body {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', sans-serif;
        }
        
        .cart-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin: 30px auto;
            max-width: 1200px;
            overflow: hidden;
        }
        
        .cart-header {
            background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
            color: white;
            padding: 25px 30px;
            text-align: center;
        }
        
        .quantity-controls {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .quantity-btn {
            width: 35px;
            height: 35px;
            border: 2px solid #e9ecef;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            color: #666;
        }
        
        .quantity-btn:hover {
            border-color: #b02a20;
            color: #b02a20;
            transform: scale(1.1);
        }
        
        .quantity-input {
            width: 60px;
            text-align: center;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 8px;
            font-weight: 600;
            background: #f8f9fa;
        }
        
        .quantity-input:focus {
            border-color: #b02a20;
            outline: none;
            background: white;
        }
        
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 9999;
            display: none;
            align-items: center;
            justify-content: center;
        }

        .loading-content {
            background: white;
            padding: 40px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }

        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #b02a20;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Success/Error notification styles */
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 10px;
            color: white;
            font-weight: 600;
            z-index: 10000;
            transform: translateX(400px);
            transition: all 0.3s ease;
            max-width: 350px;
        }

        .notification.show {
            transform: translateX(0);
        }

        .notification.success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }

        .notification.error {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
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

        .btn-remove:hover {
            background: #c82333;
            transform: scale(1.1);
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
                <p>Quản lý sản phẩm yêu thích</p>
            </div>
            
            <div class="text-center py-5">
                <i class="fas fa-shopping-cart fa-5x text-muted mb-3"></i>
                <h3>Giỏ hàng trống!</h3>
                <p>Bạn chưa có sản phẩm nào trong giỏ hàng.<br>
                Hãy khám phá các sản phẩm tuyệt vời của chúng tôi.</p>
                <a href="MainController?action=home" class="btn btn-primary btn-lg">
                    <i class="fas fa-shopping-bag me-2"></i>Bắt đầu mua sắm
                </a>
            </div>
            
            <%
                } else {
            %>
            <!-- Cart with Items -->
            <div class="cart-header">
                <h2><i class="fas fa-edit me-3"></i>Chỉnh sửa giỏ hàng</h2>
                <p>Bạn có <%= totalItems != null ? totalItems : cart.size() %> sản phẩm trong giỏ hàng</p>
            </div>
            
            <div class="p-4">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 5%;">#</th>
                                <th style="width: 35%;">Sản phẩm</th>
                                <th style="width: 15%;">Đơn giá</th>
                                <th style="width: 15%;">Số lượng</th>
                                <th style="width: 15%;">Tạm tính</th>
                                <th style="width: 15%;">Thao tác</th>
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
                                <td class="text-center">
                                    <strong><%= idx %></strong>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="me-3">
                                            <div style="width: 50px; height: 50px; background: #f8f9fa; border-radius: 8px; display: flex; align-items: center; justify-content: center;">
                                                <i class="fas fa-box text-muted"></i>
                                            </div>
                                        </div>
                                        <div>
                                            <h6 class="mb-1"><%= item.getProductName() %></h6>
                                            <small class="text-muted">ID: <%= item.getProductID() %></small>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <strong class="text-primary">
                                        <%= String.format("%,.0f", item.getUnitPrice()) %> ₫
                                    </strong>
                                </td>
                                <td>
                                    <div class="quantity-controls">
                                        <button type="button" class="quantity-btn" onclick="decreaseQuantity('<%= item.getProductID() %>')">
                                            <i class="fas fa-minus"></i>
                                        </button>
                                        <input type="number" 
                                               id="qty-<%= item.getProductID() %>"
                                               value="<%= item.getQuantity() %>" 
                                               min="1" 
                                               max="99"
                                               class="quantity-input"
                                               data-product-id="<%= item.getProductID() %>"
                                               data-original-value="<%= item.getQuantity() %>">
                                        <button type="button" class="quantity-btn" onclick="increaseQuantity('<%= item.getProductID() %>')">
                                            <i class="fas fa-plus"></i>
                                        </button>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <strong class="text-success" id="total-<%= item.getProductID() %>">
                                        <%= String.format("%,.0f", lineTotal) %> ₫
                                    </strong>
                                </td>
                                <td class="text-center">
                                    <button type="button" class="btn-remove" onclick="removeItem('<%= item.getProductID() %>')" title="Xóa sản phẩm">
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
                <div class="row mt-4">
                    <div class="col-8">
                        <h5><i class="fas fa-calculator me-2"></i>Tóm tắt đơn hàng</h5>
                        <p class="text-muted">Kiểm tra thông tin trước khi thanh toán</p>
                        
                        <div class="d-flex gap-2 mt-3">
                            <a href="MainController?action=home" class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Tiếp tục mua sắm
                            </a>
                            <button type="button" class="btn btn-outline-danger" onclick="clearCart()">
                                <i class="fas fa-trash me-2"></i>Xóa toàn bộ
                            </button>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="bg-light p-3 rounded">
                            <div class="d-flex justify-content-between mb-2">
                                <span>Số sản phẩm:</span>
                                <strong id="totalItemsDisplay"><%= totalItems != null ? totalItems : "0" %></strong>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Phí vận chuyển:</span>
                                <strong class="text-success">Miễn phí</strong>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between">
                                <span class="h5">Tổng cộng:</span>
                                <span class="h5 text-primary" id="grandTotalDisplay">
                                    <%= String.format("%,.0f", totalAmount != null ? totalAmount : grandTotal) %> ₫
                                </span>
                            </div>
                            
                            <!-- Checkout Button -->
                            <%
                                model.UserDTO currentUser = (model.UserDTO) session.getAttribute("user");
                                if (currentUser != null) {
                            %>
                            <button type="button" class="btn btn-success w-100 mt-3" onclick="proceedCheckout()">
                                <i class="fas fa-credit-card me-2"></i>Tiến hành thanh toán
                            </button>
                            <%
                                } else {
                            %>
                            <div class="text-center mt-3">
                                <p class="text-muted small">Vui lòng đăng nhập để thanh toán</p>
                                <a href="login.jsp" class="btn btn-primary w-100">
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
            <h5>Đang cập nhật giỏ hàng...</h5>
            <p>Vui lòng đợi trong giây lát</p>
        </div>
    </div>

    <!-- Notification -->
    <div class="notification" id="notification">
        <div class="d-flex align-items-center">
            <i class="fas fa-check-circle me-2" id="notificationIcon"></i>
            <span id="notificationText">Thông báo</span>
            <button type="button" class="btn-close btn-close-white ms-auto" onclick="hideNotification()"></button>
        </div>
    </div>

    <!-- Include Footer -->
    <%@ include file="footer.jsp" %>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // 🔧 FIXED: Improved cart management functions
        const CartManager = {
            contextPath: '<%= request.getContextPath() %>',
            
            // Show/Hide loading overlay
            showLoading() {
                document.getElementById('loadingOverlay').style.display = 'flex';
            },

            hideLoading() {
                document.getElementById('loadingOverlay').style.display = 'none';
            },

            // Show notification
            showNotification(message, type = 'success') {
                const notification = document.getElementById('notification');
                const icon = document.getElementById('notificationIcon');
                const text = document.getElementById('notificationText');
                
                // Set icon and style based on type
                if (type === 'success') {
                    notification.className = 'notification success show';
                    icon.className = 'fas fa-check-circle me-2';
                } else {
                    notification.className = 'notification error show';
                    icon.className = 'fas fa-exclamation-circle me-2';
                }
                
                text.textContent = message;
                
                // Auto hide after 4 seconds
                setTimeout(() => {
                    this.hideNotification();
                }, 4000);
            },

            hideNotification() {
                const notification = document.getElementById('notification');
                notification.classList.remove('show');
            },

            // 🔧 FIXED: Enhanced AJAX request function
            async makeRequest(action, data) {
                console.log(`🔄 Making ${action} request:`, data);
                
                this.showLoading();
                
                try {
                    const formData = new FormData();
                    formData.append('action', action);
                    
                    // Add all data to form
                    for (const [key, value] of Object.entries(data)) {
                        formData.append(key, value);
                    }

                    const response = await fetch(`${this.contextPath}/CartController`, {
                        method: 'POST',
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest'  // Important for AJAX detection
                        },
                        body: formData
                    });

                    this.hideLoading();

                    if (response.ok) {
                        const result = await response.json();
                        console.log('✅ Request successful:', result);
                        
                        if (result.success) {
                            this.showNotification(result.message);
                            
                            // Reload page after successful update/remove to show changes
                            if (action === 'update' || action === 'remove' || action === 'clear') {
                                setTimeout(() => {
                                    window.location.reload();
                                }, 1000);
                            }
                            
                            return true;
                        } else {
                            this.showNotification(result.message || 'Có lỗi xảy ra!', 'error');
                            return false;
                        }
                    } else {
                        // Try to get error message from response
                        try {
                            const errorResult = await response.json();
                            this.showNotification(errorResult.message || 'Có lỗi xảy ra!', 'error');
                        } catch {
                            this.showNotification('Có lỗi xảy ra khi kết nối server!', 'error');
                        }
                        return false;
                    }
                } catch (error) {
                    this.hideLoading();
                    console.error('❌ Request error:', error);
                    this.showNotification('Có lỗi xảy ra: ' + error.message, 'error');
                    return false;
                }
            },

            // Update quantity
            async updateQuantity(productId, newQuantity) {
                console.log(`🔄 Updating quantity for ${productId} to ${newQuantity}`);
                
                if (newQuantity < 1) {
                    if (confirm('Bạn có muốn xóa sản phẩm này khỏi giỏ hàng?')) {
                        return await this.removeItem(productId);
                    } else {
                        // Reset input value
                        document.getElementById(`qty-${productId}`).value = 1;
                        return false;
                    }
                }
                
                return await this.makeRequest('update', {
                    productID: productId,
                    qty: newQuantity
                });
            },

            // Remove item
            async removeItem(productId) {
                console.log(`🗑️ Removing product: ${productId}`);
                
                return await this.makeRequest('remove', {
                    productID: productId
                });
            },

            // Clear cart
            async clearCart() {
                console.log('🗑️ Clearing entire cart');
                
                return await this.makeRequest('clear', {});
            }
        };

        // 🔧 FIXED: Global functions for easier calling from HTML
        function increaseQuantity(productId) {
            const input = document.getElementById(`qty-${productId}`);
            const currentValue = parseInt(input.value) || 1;
            if (currentValue < 99) {
                const newValue = currentValue + 1;
                input.value = newValue;
                CartManager.updateQuantity(productId, newValue);
            }
        }

        function decreaseQuantity(productId) {
            const input = document.getElementById(`qty-${productId}`);
            const currentValue = parseInt(input.value) || 1;
            if (currentValue > 1) {
                const newValue = currentValue - 1;
                input.value = newValue;
                CartManager.updateQuantity(productId, newValue);
            }
        }

        function removeItem(productId) {
            if (confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?')) {
                CartManager.removeItem(productId);
            }
        }

        function clearCart() {
            if (confirm('Bạn có chắc muốn xóa toàn bộ giỏ hàng?\nHành động này không thể hoàn tác!')) {
                CartManager.clearCart();
            }
        }

        function proceedCheckout() {
            // Show development message
            alert('⚠️ Chức năng thanh toán đang được phát triển!\n\nHiện tại chỉ có thể chỉnh sửa giỏ hàng.\nVui lòng quay lại sau để sử dụng tính năng này.');
            console.log('💳 Checkout clicked but not implemented yet');
        }

        function hideNotification() {
            CartManager.hideNotification();
        }

        // 🔧 FIXED: Enhanced event listeners
        document.addEventListener('DOMContentLoaded', function() {
            console.log('✅ Cart page loaded successfully!');
            
            // Handle quantity input changes with improved debouncing
            const quantityInputs = document.querySelectorAll('.quantity-input');
            let typingTimers = {};
            
            quantityInputs.forEach(input => {
                const productId = input.dataset.productId;
                
                // Handle direct input changes with debouncing
                input.addEventListener('input', function() {
                    const value = parseInt(this.value) || 1;
                    
                    // Clear existing timer
                    if (typingTimers[productId]) {
                        clearTimeout(typingTimers[productId]);
                    }
                    
                    // Validate input
                    if (value < 1) {
                        this.value = 1;
                        return;
                    }
                    if (value > 99) {
                        this.value = 99;
                        return;
                    }
                    
                    // Set new timer
                    typingTimers[productId] = setTimeout(() => {
                        const originalValue = parseInt(this.dataset.originalValue) || 1;
                        if (value !== originalValue) {
                            console.log(`📝 Input changed for ${productId}: ${originalValue} → ${value}`);
                            CartManager.updateQuantity(productId, value);
                        }
                    }, 1500); // Wait 1.5 seconds after user stops typing
                });

                // Handle enter key for immediate update
                input.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        if (typingTimers[productId]) {
                            clearTimeout(typingTimers[productId]);
                        }
                        
                        const value = parseInt(this.value) || 1;
                        const originalValue = parseInt(this.dataset.originalValue) || 1;
                        
                        if (value !== originalValue) {
                            console.log(`⏎ Enter pressed for ${productId}: updating to ${value}`);
                            CartManager.updateQuantity(productId, value);
                        }
                    }
                });

                // Handle focus events for better UX
                input.addEventListener('focus', function() {
                    this.select(); // Select all text when focused
                });

                input.addEventListener('blur', function() {
                    // Ensure minimum value on blur
                    if (parseInt(this.value) < 1) {
                        this.value = 1;
                    }
                });
            });
            
            // Add smooth animations to table rows
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach((row, index) => {
                row.style.opacity = '0';
                row.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    row.style.transition = 'all 0.5s ease';
                    row.style.opacity = '1';
                    row.style.transform = 'translateY(0)';
                }, index * 100);
            });
            
            // Keyboard shortcuts
            document.addEventListener('keydown', function(e) {
                // Ctrl/Cmd + D = Clear cart
                if ((e.ctrlKey || e.metaKey) && e.key === 'd') {
                    e.preventDefault();
                    clearCart();
                }
                
                // Escape = Go back to shopping
                if (e.key === 'Escape') {
                    window.location.href = 'MainController?action=home';
                }
            });
            
            console.log('🛒 Cart management system ready!');
            console.log('💡 Keyboard shortcuts: Ctrl+D (clear), Escape (back)');
        });
        
        // Performance monitoring
        window.addEventListener('load', function() {
            const loadTime = performance.now();
            console.log(`⚡ Cart page loaded in ${Math.round(loadTime)}ms`);
        });
    </script>

</body>
</html>