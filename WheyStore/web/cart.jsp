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
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

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

            .table th {
                background-color: #f8f9fa;
                border: none;
                font-weight: 600;
                color: #333;
                padding: 15px;
            }

            .table td {
                border: none;
                padding: 15px;
                vertical-align: middle;
            }

            .table tbody tr {
                border-bottom: 1px solid #e9ecef;
            }
        </style>
    </head>
    <body>

        <!-- Include Header -->
        <%@ include file="header.jsp" %>

        <div class="container">
            <div class="cart-container">
                <%
                    // 🔧 FIX: Use exact same logic as debug version that worked
                    Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) request.getAttribute("cartItems");
                    Integer totalItems = (Integer) request.getAttribute("totalItems");
                    java.math.BigDecimal totalAmount = (java.math.BigDecimal) request.getAttribute("totalAmount");
                
                    // Debug info (remove this later)
                    System.out.println("🔍 DEBUG cart.jsp - cart is null: " + (cart == null));
                    if (cart != null) {
                        System.out.println("🔍 DEBUG cart.jsp - cart size: " + cart.size());
                        System.out.println("🔍 DEBUG cart.jsp - cart class: " + cart.getClass().getName());
                    }
                
                    if (cart == null || cart.isEmpty()) {
                %>
                <!-- Empty Cart State -->
                <div class="cart-header">
                    <h2><i class="fas fa-shopping-cart me-3"></i>Giỏ hàng của bạn</h2>

                </div>

                <div class="text-center py-5">
                    <i class="fas fa-shopping-cart fa-5x text-muted mb-3"></i>
                    <h3>Giỏ hàng trống!</h3>
                    <p>Bạn chưa có sản phẩm nào trong giỏ hàng.<br>
                        Hãy tiếp tục quay trở về trang chủ xem những sản phẩm khác nhá <3</p>
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
                                            <button type="button" class="quantity-btn" data-action="decrease" data-product-id="<%= item.getProductID() %>">
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
                                            <button type="button" class="quantity-btn" data-action="increase" data-product-id="<%= item.getProductID() %>">
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
                                    UserDTO checkoutUser = (UserDTO) session.getAttribute("user");
                                    if (checkoutUser != null) {
                                %>
                                <button type="button" class="btn btn-success w-100 mt-3" onclick="proceedCheckout()">
                                    <i class="fas fa-credit-card me-2"></i>Xác nhận đơn hàng
                                </button>
                                <%
                                    } else {
                                %>
                                <div class="text-center mt-3">
                                    <p class="text-muted small">Vui lòng đăng nhập để đặt</p>
                                    <a href="login.jsp" class="btn btn-primary w-100">
                                        <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập để đặt
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
                    // 🔧 FIXED: Simple functions for button clicks
                    function increaseQuantity(productId) {
                        console.log('🔄 Increase quantity for:', productId);
                        const input = document.getElementById('qty-' + productId);
                        if (!input) {
                            console.error('❌ Input not found for product:', productId);
                            return;
                        }

                        const currentValue = parseInt(input.value) || 1;
                        console.log('📊 Current value:', currentValue);

                        if (currentValue < 99) {
                            const newValue = currentValue + 1;
                            input.value = newValue;
                            console.log('📈 New value:', newValue);

                            // Submit form immediately
                            submitQuantityUpdate(productId, newValue);
                        } else {
                            alert('Số lượng tối đa là 99!');
                        }
                    }

                    function decreaseQuantity(productId) {
                        console.log('🔄 Decrease quantity for:', productId);
                        const input = document.getElementById('qty-' + productId);
                        if (!input) {
                            console.error('❌ Input not found for product:', productId);
                            return;
                        }

                        const currentValue = parseInt(input.value) || 1;
                        console.log('📊 Current value:', currentValue);

                        if (currentValue > 1) {
                            const newValue = currentValue - 1;
                            input.value = newValue;
                            console.log('📉 New value:', newValue);

                            // Submit form immediately
                            submitQuantityUpdate(productId, newValue);
                        } else {
                            // Ask if user wants to remove item
                            if (confirm('Bạn có muốn xóa sản phẩm này khỏi giỏ hàng?')) {
                                removeItem(productId);
                            }
                        }
                    }

                    function submitQuantityUpdate(productId, newQuantity) {
                        console.log('📝 Submitting quantity update:', productId, '=', newQuantity);

                        // Create and submit form
                        const form = document.createElement('form');
                        form.method = 'POST';
                        form.action = '<%= request.getContextPath() %>/CartController';
                        form.style.display = 'none';

                        // Add action parameter
                        const actionInput = document.createElement('input');
                        actionInput.type = 'hidden';
                        actionInput.name = 'action';
                        actionInput.value = 'update';
                        form.appendChild(actionInput);

                        // Add product ID parameter
                        const productInput = document.createElement('input');
                        productInput.type = 'hidden';
                        productInput.name = 'productID';
                        productInput.value = productId;
                        form.appendChild(productInput);

                        // Add quantity parameter
                        const qtyInput = document.createElement('input');
                        qtyInput.type = 'hidden';
                        qtyInput.name = 'qty';
                        qtyInput.value = newQuantity;
                        form.appendChild(qtyInput);

                        // Add to DOM and submit
                        document.body.appendChild(form);
                        form.submit();
                    }

                    function removeItem(productId) {
                        console.log('🗑️ Remove item:', productId);

                        if (confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?')) {
                            const form = document.createElement('form');
                            form.method = 'POST';
                            form.action = '<%= request.getContextPath() %>/CartController';
                            form.style.display = 'none';

                            const actionInput = document.createElement('input');
                            actionInput.type = 'hidden';
                            actionInput.name = 'action';
                            actionInput.value = 'remove';
                            form.appendChild(actionInput);

                            const productInput = document.createElement('input');
                            productInput.type = 'hidden';
                            productInput.name = 'productID';
                            productInput.value = productId;
                            form.appendChild(productInput);

                            document.body.appendChild(form);
                            form.submit();
                        }
                    }

                    function clearCart() {
                        console.log('🗑️ Clear entire cart');

                        if (confirm('Bạn có chắc muốn xóa toàn bộ giỏ hàng?\nHành động này không thể hoàn tác!')) {
                            const form = document.createElement('form');
                            form.method = 'POST';
                            form.action = '<%= request.getContextPath() %>/CartController';
                            form.style.display = 'none';

                            const actionInput = document.createElement('input');
                            actionInput.type = 'hidden';
                            actionInput.name = 'action';
                            actionInput.value = 'clear';
                            form.appendChild(actionInput);

                            document.body.appendChild(form);
                            form.submit();
                        }
                    }

                    function proceedCheckout() {
                        const form = document.createElement('form');
                        form.method = 'POST';
                        form.action = '<%= request.getContextPath() %>/OrderController';

                        const actionInput = document.createElement('input');
                        actionInput.type = 'hidden';
                        actionInput.name = 'action';
                        actionInput.value = 'createOrder';
                        form.appendChild(actionInput);

                        document.body.appendChild(form);
                        form.submit();
                    }

                    // Event listeners
                    document.addEventListener('DOMContentLoaded', function () {
                        console.log('✅ Cart page loaded successfully!');

                        // 🔧 FIXED: Use data attributes instead of onclick to avoid double execution
                        const quantityButtons = document.querySelectorAll('.quantity-btn');
                        quantityButtons.forEach(button => {
                            button.addEventListener('click', function (e) {
                                e.preventDefault();
                                e.stopPropagation(); // Prevent any bubbling

                                const action = this.dataset.action; // 'increase' or 'decrease'
                                const productId = this.dataset.productId;

                                console.log('🖱️ Button clicked:', action, 'for product:', productId);

                                if (action === 'increase') {
                                    console.log('➕ Increase button clicked');
                                    increaseQuantity(productId);
                                } else if (action === 'decrease') {
                                    console.log('➖ Decrease button clicked');
                                    decreaseQuantity(productId);
                                }
                            });
                        });

                        // Handle manual quantity input changes
                        const quantityInputs = document.querySelectorAll('.quantity-input');
                        quantityInputs.forEach(input => {
                            let originalValue = parseInt(input.value) || 1;

                            input.addEventListener('change', function () {
                                const productId = this.dataset.productId;
                                const newValue = parseInt(this.value) || 1;

                                console.log('📝 Manual input change:', productId, 'from', originalValue, 'to', newValue);

                                if (newValue < 1) {
                                    this.value = 1;
                                    return;
                                }
                                if (newValue > 99) {
                                    this.value = 99;
                                    return;
                                }

                                if (newValue !== originalValue) {
                                    submitQuantityUpdate(productId, newValue);
                                }
                            });

                            // Update original value when focused
                            input.addEventListener('focus', function () {
                                originalValue = parseInt(this.value) || 1;
                            });
                        });

                        console.log('🎯 Found', quantityButtons.length, 'quantity buttons');
                        console.log('🎯 Found', quantityInputs.length, 'quantity inputs');
                    });
        </script>

    </body>
</html>