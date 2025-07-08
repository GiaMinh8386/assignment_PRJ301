<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.ProductDTO" %>
<%@ page import="utils.AuthUtils" %>
<%@ page errorPage="error.jsp" %>

<%
    ProductDTO product = (ProductDTO) request.getAttribute("product");
    if (product == null) {
        response.sendRedirect("MainController?action=home");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%= product.getName() %> - WheyStore</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', sans-serif;
            }

            .product-detail-container {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                overflow: hidden;
                margin: 30px 0;
            }

            .breadcrumb-section {
                background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
                color: white;
                padding: 15px 0;
                margin-bottom: 0;
            }

            .breadcrumb {
                background: none;
                margin: 0;
                padding: 0;
            }

            .breadcrumb-item a {
                color: rgba(255,255,255,0.8);
                text-decoration: none;
            }

            .breadcrumb-item a:hover {
                color: white;
            }

            .breadcrumb-item.active {
                color: white;
            }

            .product-image-section {
                padding: 40px;
                background: #f8f9fa;
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 500px;
            }

            .product-main-image {
                max-width: 100%;
                max-height: 400px;
                object-fit: contain;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                transition: transform 0.3s ease;
            }

            .product-main-image:hover {
                transform: scale(1.05);
            }

            .product-image-placeholder {
                width: 400px;
                height: 400px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                text-align: center;
                flex-direction: column;
            }

            .product-image-placeholder i {
                font-size: 4rem;
                margin-bottom: 20px;
                opacity: 0.7;
            }

            .product-info-section {
                padding: 40px;
            }

            .product-brand {
                color: #6c757d;
                font-size: 14px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-bottom: 10px;
            }

            .product-title {
                font-size: 2rem;
                font-weight: 700;
                color: #333;
                margin-bottom: 20px;
                line-height: 1.3;
            }

            .product-price {
                font-size: 2.5rem;
                font-weight: 700;
                color: #dc3545;
                margin-bottom: 30px;
            }

            .product-id {
                background: #f8f9fa;
                padding: 10px 15px;
                border-radius: 25px;
                display: inline-block;
                font-size: 14px;
                color: #666;
                margin-bottom: 30px;
            }

            .product-description {
                font-size: 16px;
                line-height: 1.6;
                color: #555;
                margin-bottom: 30px;
            }

            .quantity-selector {
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 30px;
            }

            .quantity-input {
                width: 80px;
                text-align: center;
                border: 2px solid #e9ecef;
                border-radius: 8px;
                padding: 10px;
                font-weight: 600;
            }

            .quantity-btn {
                width: 40px;
                height: 40px;
                border: none;
                background: #f8f9fa;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .quantity-btn:hover {
                background: #e9ecef;
                transform: scale(1.1);
            }

            .action-buttons {
                display: flex;
                gap: 15px;
                margin-bottom: 30px;
            }

            .btn-add-cart {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                border: none;
                color: white;
                padding: 15px 30px;
                font-size: 16px;
                font-weight: 600;
                border-radius: 25px;
                transition: all 0.3s ease;
                flex: 1;
            }

            .btn-add-cart:hover {
                background: linear-gradient(135deg, #218838 0%, #17a2b8 100%);
                transform: translateY(-2px);
                color: white;
            }

            .btn-buy-now {
                background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
                border: none;
                color: white;
                padding: 15px 30px;
                font-size: 16px;
                font-weight: 600;
                border-radius: 25px;
                transition: all 0.3s ease;
                flex: 1;
            }

            .btn-buy-now:hover {
                background: linear-gradient(135deg, #8b1e16 0%, #6d1611 100%);
                transform: translateY(-2px);
                color: white;
            }

            .btn-favorite {
                background: linear-gradient(135deg, #e91e63 0%, #c2185b 100%);
                border: none;
                color: white;
                padding: 12px 20px;
                font-size: 14px;
                font-weight: 600;
                border-radius: 25px;
                transition: all 0.3s ease;
                cursor: pointer;
                box-shadow: 0 4px 15px rgba(233, 30, 99, 0.3);
                min-width: 120px;
                text-align: center;
            }

            .btn-favorite:hover {
                background: linear-gradient(135deg, #c2185b 0%, #ad1457 100%);
                transform: translateY(-2px);
                color: white;
                box-shadow: 0 6px 20px rgba(233, 30, 99, 0.4);
            }

            .btn-favorite:active {
                transform: translateY(0);
                box-shadow: 0 2px 10px rgba(233, 30, 99, 0.5);
            }

            .product-features {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 30px;
            }

            .feature-item {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 10px;
            }

            .feature-item:last-child {
                margin-bottom: 0;
            }

            .feature-icon {
                color: #28a745;
                font-size: 16px;
            }

            .related-products {
                background: white;
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                margin-top: 30px;
            }
        </style>
    </head>
    <body>

        <!-- Include Header -->
        <%@ include file="header.jsp" %>

        <!-- Breadcrumb -->
        <div class="breadcrumb-section">
            <div class="container">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="MainController?action=home">
                                <i class="fas fa-home me-1"></i>Trang chủ
                            </a>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="MainController?action=listProducts">Sản phẩm</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">
                            <%= product.getName() %>
                        </li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Product Detail -->
        <div class="container">
            <div class="product-detail-container">
                <div class="row g-0">
                    <!-- Product Image -->
                    <div class="col-lg-6">
                        <div class="product-image-section">
                            <%
                                String contextPath = request.getContextPath();
                                String imageName = product.getImage();
                                String imagePath = null;
                                boolean hasImage = false;
                            
                                if (imageName != null && !imageName.trim().isEmpty()) {
                                    if (imageName.startsWith("http")) {
                                        imagePath = imageName;
                                        hasImage = true;
                                    } else {
                                        imagePath = contextPath + "/assets/images/products/" + imageName;
                                        hasImage = true;
                                    }
                                }
                            %>

                            <% if (hasImage) { %>
                            <img src="<%= imagePath %>"
                                 class="product-main-image"
                                 alt="<%= product.getName() %>"
                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                            <div class="product-image-placeholder" style="display:none;">
                                <i class="fas fa-image"></i>
                                <h5>Hình ảnh không có sẵn</h5>
                                <p><%= product.getBrand() %></p>
                            </div>
                            <% } else { %>
                            <div class="product-image-placeholder">
                                <i class="fas fa-box-open"></i>
                                <h5><%= product.getBrand() != null ? product.getBrand() : "Product" %></h5>
                                <p><%= product.getFormattedPrice() %></p>
                                <small>ID: <%= product.getId() %></small>
                            </div>
                            <% } %>
                        </div>
                    </div>

                    <!-- Product Info -->
                    <div class="col-lg-6">
                        <div class="product-info-section">
                            <!-- Brand -->
                            <% if (product.getBrand() != null && !product.getBrand().trim().isEmpty()) { %>
                            <div class="product-brand">
                                <i class="fas fa-tags me-1"></i><%= product.getBrand() %>
                            </div>
                            <% } %>

                            <!-- Title -->
                            <h1 class="product-title"><%= product.getName() %></h1>

                            <!-- Product ID -->
                            <div class="product-id">
                                <i class="fas fa-barcode me-1"></i>Mã sản phẩm: <%= product.getId() %>
                            </div>

                            <!-- Price -->
                            <div class="product-price">
                                <% if (product.getPrice() > 0) { %>
                                <%= product.getFormattedPrice() %>
                                <% } else { %>
                                <span class="text-muted">Liên hệ</span>
                                <% } %>
                            </div>


                            <!-- Description -->
                            <% if (product.getDescription() != null && !product.getDescription().trim().isEmpty()) { %>
                            <div class="product-description">
                                <h6><i class="fas fa-info-circle me-2"></i>Mô tả sản phẩm:</h6>
                                <p><%= product.getDescription() %></p>
                            </div>
                            <% } %>

                            <!-- Features -->
                            <div class="product-features">
                                <h6 class="mb-3"><i class="fas fa-star me-2"></i>Đặc điểm nổi bật:</h6>
                                <div class="feature-item">
                                    <i class="fas fa-check feature-icon"></i>
                                    <span>Chất lượng cao, nhập khẩu chính hãng</span>
                                </div>
                                <div class="feature-item">
                                    <i class="fas fa-shipping-fast feature-icon"></i>
                                    <span>Giao hàng nhanh toàn quốc</span>
                                </div>
                                <div class="feature-item">
                                    <i class="fas fa-award feature-icon"></i>
                                    <span>Bảo hành chính hãng</span>
                                </div>
                                <div class="feature-item">
                                    <i class="fas fa-phone feature-icon"></i>
                                    <span>Hỗ trợ tư vấn 24/7</span>
                                </div>
                            </div>

                            <!-- Quantity & Actions -->
                            <form action="CartController" method="post" id="addToCartForm">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productID" value="<%= product.getId() %>">

                                <!-- Quantity Selector -->
                                <div class="quantity-selector">
                                    <label class="form-label fw-bold">Số lượng:</label>
                                    <button type="button" class="quantity-btn" onclick="decreaseQuantity()">
                                        <i class="fas fa-minus"></i>
                                    </button>
                                    <input type="number" name="qty" id="quantityInput" class="quantity-input" value="1" min="1" max="99">
                                    <button type="button" class="quantity-btn" onclick="increaseQuantity()">
                                        <i class="fas fa-plus"></i>
                                    </button>
                                </div>

                                <!-- Action Buttons -->
                                <div class="action-buttons">
                                    <button type="submit" class="btn btn-add-cart">
                                        <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ hàng
                                    </button>
                                    <button type="button" class="btn btn-buy-now" onclick="buyNow()">
                                        <i class="fas fa-bolt me-2"></i>Mua ngay
                                    </button>
                                </div>
                            </form>

                            <%--  Form YÊU THÍCH --%>
                            <% if (currentUser != null) { %>
                            <div class="d-flex justify-content-center mt-3">
                                <form action="MainController" method="post" style="display:inline;">
                                    <input type="hidden" name="action"    value="toggleFavorite">
                                    <input type="hidden" name="productID" value="<%= product.getId() %>">
                                    <button type="submit" class="btn-favorite">
                                        <i class="fas fa-heart me-2"></i>Yêu thích
                                    </button>
                                </form>
                            </div>
                            <% } %>

                            <!-- Back to Products -->
                            <div class="text-center">
                                <a href="MainController?action=home" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách sản phẩm
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Related Products Section -->
            <div class="related-products">
                <h4 class="mb-4">
                    <i class="fas fa-heart text-danger me-2"></i>Sản phẩm liên quan
                </h4>
                <div class="row">
                    <!-- You can add related products here -->
                    <div class="col-12 text-center text-muted">
                        <i class="fas fa-box-open fa-3x mb-3"></i>
                        <p>Sản phẩm liên quan sẽ được cập nhật sớm</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Include Footer -->
        <%@ include file="footer.jsp" %>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                        // Quantity controls
                                        function increaseQuantity() {
                                            const input = document.getElementById('quantityInput');
                                            const currentValue = parseInt(input.value);
                                            if (currentValue < 99) {
                                                input.value = currentValue + 1;
                                            }
                                        }

                                        function decreaseQuantity() {
                                            const input = document.getElementById('quantityInput');
                                            const currentValue = parseInt(input.value);
                                            if (currentValue > 1) {
                                                input.value = currentValue - 1;
                                            }
                                        }

                                        // Buy now functionality
                                        function buyNow() {
                                            // Add to cart first, then redirect to cart
                                            const form = document.getElementById('addToCartForm');
                                            const formData = new FormData(form);

                                            fetch(form.action, {
                                                method: 'POST',
                                                body: formData
                                            })
                                                    .then(response => {
                                                        if (response.ok) {
                                                            // Redirect to cart page
                                                            window.location.href = 'CartController?action=view';
                                                        } else {
                                                            // Fallback: submit form normally
                                                            form.submit();
                                                            setTimeout(() => {
                                                                window.location.href = 'CartController?action=view';
                                                            }, 1000);
                                                        }
                                                    })
                                                    .catch(error => {
                                                        console.error('Error:', error);
                                                        // Fallback: submit form normally
                                                        form.submit();
                                                        setTimeout(() => {
                                                            window.location.href = 'CartController?action=view';
                                                        }, 1000);
                                                    });
                                        }

                                        // Enhanced form submission
                                        document.getElementById('addToCartForm').addEventListener('submit', function (e) {
                                            e.preventDefault();

                                            const submitBtn = this.querySelector('.btn-add-cart');
                                            const originalText = submitBtn.innerHTML;

                                            // Show loading state
                                            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang thêm...';
                                            submitBtn.disabled = true;

                                            // Submit form
                                            const formData = new FormData(this);
                                            fetch(this.action, {
                                                method: 'POST',
                                                body: formData
                                            })
                                                    .then(response => {
                                                        if (response.ok) {
                                                            // Show success state
                                                            submitBtn.innerHTML = '<i class="fas fa-check me-2"></i>Đã thêm thành công!';
                                                            submitBtn.classList.remove('btn-add-cart');
                                                            submitBtn.classList.add('btn-success');

                                                            // Show notification if available
                                                            if (window.cartManager) {
                                                                window.cartManager.showCartNotification('<%= product.getName() %>');
                                                            }

                                                            // Reset button after 3 seconds
                                                            setTimeout(() => {
                                                                submitBtn.innerHTML = originalText;
                                                                submitBtn.classList.remove('btn-success');
                                                                submitBtn.classList.add('btn-add-cart');
                                                                submitBtn.disabled = false;
                                                            }, 3000);
                                                        } else {
                                                            throw new Error('Network response was not ok');
                                                        }
                                                    })
                                                    .catch(error => {
                                                        console.error('Error:', error);
                                                        // Reset button and submit normally
                                                        submitBtn.innerHTML = originalText;
                                                        submitBtn.disabled = false;
                                                        this.submit();
                                                    });
                                        });

                                        // Image zoom effect
                                        document.addEventListener('DOMContentLoaded', function () {
                                            const productImage = document.querySelector('.product-main-image');
                                            if (productImage) {
                                                productImage.addEventListener('click', function () {
                                                    // Simple image zoom modal (you can enhance this)
                                                    const modal = document.createElement('div');
                                                    modal.style.cssText = `
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: rgba(0,0,0,0.8);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            z-index: 9999;
                            cursor: pointer;
                        `;

                                                    const zoomedImage = document.createElement('img');
                                                    zoomedImage.src = this.src;
                                                    zoomedImage.style.cssText = `
                            max-width: 90%;
                            max-height: 90%;
                            object-fit: contain;
                        `;

                                                    modal.appendChild(zoomedImage);
                                                    document.body.appendChild(modal);

                                                    modal.addEventListener('click', function () {
                                                        document.body.removeChild(modal);
                                                    });
                                                });
                                            }

                                            console.log('✅ Product Detail page loaded successfully!');
                                        });
        </script>

    </body>
</html>