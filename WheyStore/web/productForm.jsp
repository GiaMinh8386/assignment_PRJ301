<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%@page import="model.UserDTO"%>
<%@page import="model.ProductDTO"%>
<%@page import="utils.AuthUtils"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thêm Sản Phẩm</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', sans-serif;
            }

            .form-wrapper {
                max-width: 700px;
                margin: 60px auto;
            }

            .card-custom {
                background: #b02a20;
                border: none;
                border-radius: 20px;
                padding: 35px;
                color: white;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            }

            h3.form-title {
                font-weight: bold;
                text-align: center;
                margin-bottom: 30px;
                color: #fff;
                letter-spacing: 1px;
            }

            .form-label {
                color: #fff;
                font-weight: 600;
            }

            .form-control {
                border-radius: 10px;
                font-size: 16px;
            }

            .btn-custom {
                border-radius: 10px;
                font-weight: 600;
                padding: 10px 25px;
                transition: all 0.3s ease;
            }

            .btn-submit {
                background-color: #000;
                color: #fff;
                border: none;
            }

            .btn-submit:hover {
                background-color: #222;
                transform: scale(1.03);
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
            }

            .btn-reset {
                background-color: #fff;
                color: #b02a20;
                border: 2px solid #fff;
            }

            .btn-reset:hover {
                background-color: #e5e5e5;
                color: #000;
                transform: scale(1.02);
            }

            .error-msg {
                color: #fff;
                padding-left: 2px;
                font-weight: bold;
                font-size: 14px;
                margin-top: 5px;
            }

            .success-msg {
                color: #d4edda;
                background-color: #155724;
                border-left: 6px solid #28a745;
                padding: 12px 16px;
                border-radius: 10px;
                margin-top: 20px;
            }

            /* FIX 2: ✅ FIXED - Enhanced success action buttons styling */
            .success-actions {
                background-color: rgba(255, 255, 255, 0.1);
                border-radius: 15px;
                padding: 20px;
                margin-top: 20px;
                text-align: center;
            }

            .success-actions h6 {
                color: #fff;
                margin-bottom: 15px;
                font-weight: 600;
            }

            .success-btn {
                background: linear-gradient(135deg, #28a745, #20c997);
                color: white;
                border: none;
                border-radius: 25px;
                padding: 12px 25px;
                margin: 5px;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
                display: inline-block;
            }

            .success-btn:hover {
                background: linear-gradient(135deg, #218838, #17a2b8);
                color: white;
                text-decoration: none;
                transform: translateY(-2px);
            }

            .success-btn.btn-dashboard {
                background: linear-gradient(135deg, #007bff, #6610f2);
            }

            .success-btn.btn-dashboard:hover {
                background: linear-gradient(135deg, #0056b3, #520dc2);
            }

            .success-btn.btn-home {
                background: linear-gradient(135deg, #17a2b8, #138496);
            }

            .success-btn.btn-home:hover {
                background: linear-gradient(135deg, #138496, #0f6674);
            }

            .success-btn.btn-add-more {
                background: linear-gradient(135deg, #ffc107, #e0a800);
                color: #333;
            }

            .success-btn.btn-add-more:hover {
                background: linear-gradient(135deg, #e0a800, #d39e00);
                color: #333;
            }

            .back-btn {
                background: rgba(255, 255, 255, 0.1);
                color: white;
                border: 2px solid rgba(255, 255, 255, 0.3);
                border-radius: 25px;
                padding: 10px 20px;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
                display: inline-block;
                margin-bottom: 20px;
            }

            .back-btn:hover {
                background: rgba(255, 255, 255, 0.2);
                border-color: rgba(255, 255, 255, 0.5);
                color: white;
                text-decoration: none;
                transform: translateY(-2px);
            }

            /* Access denied styles */
            .access-denied {
                text-align: center;
                padding: 60px 30px;
                color: #e74c3c;
                font-size: 18px;
                font-weight: 500;
                background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
                color: white;
                border-radius: 15px;
                margin: 20px;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            }

            /* FIX 2: ✅ FIXED - Navigation buttons styling */
            .nav-buttons {
                display: flex;
                gap: 10px;
                justify-content: center;
                flex-wrap: wrap;
                margin-top: 15px;
            }

            .nav-btn {
                padding: 10px 20px;
                border-radius: 25px;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
                border: 2px solid rgba(255, 255, 255, 0.3);
                color: white;
                background: rgba(255, 255, 255, 0.1);
                font-size: 14px;
            }

            .nav-btn:hover {
                background: rgba(255, 255, 255, 0.2);
                color: white;
                text-decoration: none;
                transform: translateY(-2px);
            }

            .nav-btn.primary {
                background: linear-gradient(135deg, #007bff, #0056b3);
                border-color: transparent;
            }

            .nav-btn.primary:hover {
                background: linear-gradient(135deg, #0056b3, #004085);
            }
        </style>
    </head>
    <body>
        <%
            if (AuthUtils.isAdmin(request)) {
                ProductDTO product = (ProductDTO) request.getAttribute("product");
                String message = (String) request.getAttribute("message");
                Boolean showSuccessActions = (Boolean) request.getAttribute("showSuccessActions");
                Boolean isEdit = (Boolean) request.getAttribute("isEdit");
        %>

        <div class="form-wrapper">
            <!-- FIX 2: ✅ FIXED - Enhanced back to Dashboard button -->
            <div class="text-center">
                <a href="ProductController?action=adminDashboard" class="back-btn">
                    <i class="fas fa-arrow-left me-2"></i>Quay về Dashboard
                </a>
            </div>

            <div class="card-custom">
                <h3 class="form-title">
                    <%= (isEdit != null && isEdit) ? "Chỉnh sửa sản phẩm" : "Thêm Sản Phẩm Mới" %>
                </h3>
                
                <form action="MainController" method="post">
                    <input type="hidden" name="action" value="<%= (isEdit != null && isEdit) ? "updateProduct" : "addProduct" %>"/>
                    
                    <!-- If editing, include product ID as hidden field -->
                    <% if (isEdit != null && isEdit && product != null) { %>
                        <input type="hidden" name="id" value="<%= product.getId() %>"/>
                    <% } %>

                    <!-- Product ID field (only show for new products) -->
                    <% if (isEdit == null || !isEdit) { %>
                    <div class="mb-3">
                        <label for="id" class="form-label">Mã sản phẩm *</label>
                        <input type="text" class="form-control" id="id" name="id" required
                               value="<%= product != null ? product.getId() : "" %>"/>
                        <% if (request.getAttribute("idError") != null) { %>
                        <div class="error-msg"><%= request.getAttribute("idError") %></div>
                        <% } %>
                    </div>
                    <% } else { %>
                    <div class="mb-3">
                        <label class="form-label">Mã sản phẩm</label>
                        <input type="text" class="form-control" value="<%= product != null ? product.getId() : "" %>" readonly/>
                        <small class="text-white-50">Mã sản phẩm không thể thay đổi</small>
                    </div>
                    <% } %>

                    <div class="mb-3">
                        <label for="name" class="form-label">Tên sản phẩm *</label>
                        <input type="text" class="form-control" id="name" name="name" required
                               value="<%= product != null ? product.getName() : "" %>"/>
                        <% if (request.getAttribute("nameError") != null) { %>
                        <div class="error-msg"><%= request.getAttribute("nameError") %></div>
                        <% } %>
                    </div>

                    <div class="mb-3">
                        <label for="image" class="form-label">Link ảnh</label>
                        <input type="text" class="form-control" id="image" name="image"
                               value="<%= product != null && product.getImage() != null ? product.getImage() : "" %>"/>
                        <small class="text-white-50">Để trống nếu không có hình ảnh</small>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">Mô tả</label>
                        <textarea class="form-control" id="description" name="description" rows="3"><%= product != null && product.getDescription() != null ? product.getDescription() : "" %></textarea>
                    </div>

                    <div class="mb-3">
                        <label for="price" class="form-label">Giá *</label>
                        <input type="number" class="form-control" id="price" name="price" min="0" step="0.01" required
                               value="<%= product != null ? product.getPrice() : "" %>"/>
                        <% if (request.getAttribute("priceError") != null) { %>
                        <div class="error-msg"><%= request.getAttribute("priceError") %></div>
                        <% } %>
                    </div>

                    <div class="mb-3">
                        <label for="brand" class="form-label">Thương hiệu</label>
                        <input type="text" class="form-control" id="brand" name="brand"
                               value="<%= product != null && product.getBrand() != null ? product.getBrand() : "" %>"/>
                    </div>

                    <div class="mb-3">
                        <label for="categoryId" class="form-label">Mã danh mục *</label>
                        <select class="form-control" id="categoryId" name="categoryId" required>
                            <option value="">-- Chọn danh mục --</option>
                            <option value="1" <%= (product != null && product.getCategoryId() == 1) ? "selected" : "" %>>1 - Whey Protein</option>
                            <option value="2" <%= (product != null && product.getCategoryId() == 2) ? "selected" : "" %>>2 - Protein</option>
                            <option value="3" <%= (product != null && product.getCategoryId() == 3) ? "selected" : "" %>>3 - Sức Mạnh & Sức Bền</option>
                            <option value="4" <%= (product != null && product.getCategoryId() == 4) ? "selected" : "" %>>4 - Hỗ Trợ Giảm Mỡ</option>
                            <option value="5" <%= (product != null && product.getCategoryId() == 5) ? "selected" : "" %>>5 - Vitamin & Khoáng Chất</option>
                        </select>
                        <% if (request.getAttribute("categoryError") != null) { %>
                        <div class="error-msg"><%= request.getAttribute("categoryError") %></div>
                        <% } %>
                    </div>

                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="status" name="status" value="true"
                               <%= (product == null || product.isStatus()) ? "checked" : "" %>/>
                        <label class="form-check-label" for="status">Hiển thị sản phẩm</label>
                    </div>

                    <div class="d-flex justify-content-between">
                        <button type="submit" class="btn btn-success btn-custom">
                            <%= (isEdit != null && isEdit) ? "Cập nhật" : "Thêm" %>
                        </button>
                        <button type="reset" class="btn btn-light btn-custom btn-reset">Reset</button>
                    </div>

                    <% if (request.getAttribute("createError") != null) { %>
                    <div class="error-msg mt-3"><%= request.getAttribute("createError") %></div>
                    <% } %>

                    <% if (request.getAttribute("updateError") != null) { %>
                    <div class="error-msg mt-3"><%= request.getAttribute("updateError") %></div>
                    <% } %>

                    <% if (message != null) { %>
                    <div class="success-msg mt-3">
                        <i class="fas fa-check-circle me-2"></i><%= message %>
                    </div>
                    <% } %>

                </form>

                <!-- FIX 2: ✅ FIXED - Enhanced success action buttons -->
                <% if (showSuccessActions != null && showSuccessActions && message != null) { %>
                <div class="success-actions">
                    <h6><i class="fas fa-rocket me-2"></i>Bạn muốn làm gì tiếp theo?</h6>
                    <div class="nav-buttons">
                        <a href="ProductController?action=adminDashboard" class="success-btn btn-dashboard">
                            <i class="fas fa-tachometer-alt me-2"></i>Về Dashboard
                        </a>
                        <a href="MainController?action=home" class="success-btn btn-home">
                            <i class="fas fa-home me-2"></i>Về Trang chủ
                        </a>
                        <a href="productForm.jsp" class="success-btn btn-add-more">
                            <i class="fas fa-plus me-2"></i>Thêm sản phẩm khác
                        </a>
                    </div>
                </div>
                <% } else if (message == null) { %>
                <!-- FIX 2: ✅ FIXED - Show navigation buttons even when no success message -->
                <div class="nav-buttons">
                    <a href="ProductController?action=adminDashboard" class="nav-btn primary">
                        <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                    </a>
                    <a href="MainController?action=home" class="nav-btn">
                        <i class="fas fa-home me-2"></i>Trang chủ
                    </a>
                </div>
                <% } %>
            </div>
        </div>

        <% } else { %>
        <div class="container mt-5">
            <div class="alert alert-danger text-center">
                <%= AuthUtils.getAccessDeniedMessage("product-form page") %>
            </div>
            <div class="text-center mt-3">
                <a href="MainController?action=home" class="btn btn-primary">
                    <i class="fas fa-home me-2"></i>Về Trang chủ
                </a>
            </div>
        </div>
        <% } %>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                console.log('✅ Product Form loaded successfully!');
                
                // Auto-hide success message after 10 seconds
                const successMsg = document.querySelector('.success-msg');
                if (successMsg) {
                    setTimeout(() => {
                        successMsg.style.transition = 'opacity 0.5s ease';
                        successMsg.style.opacity = '0.7';
                    }, 10000);
                }
                
                // Form validation enhancement
                const form = document.querySelector('form');
                if (form) {
                    form.addEventListener('submit', function(e) {
                        const submitBtn = this.querySelector('button[type="submit"]');
                        const originalText = submitBtn.innerHTML;
                        
                        // Show loading state
                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
                        submitBtn.disabled = true;
                        
                        // Re-enable button after 5 seconds as fallback
                        setTimeout(() => {
                            if (submitBtn.disabled) {
                                submitBtn.innerHTML = originalText;
                                submitBtn.disabled = false;
                            }
                        }, 5000);
                    });
                }
                
                // Image preview functionality
                const imageInput = document.getElementById('image');
                if (imageInput) {
                    imageInput.addEventListener('blur', function() {
                        const url = this.value;
                        if (url && (url.startsWith('http') || url.startsWith('assets/'))) {
                            // Could add image preview here
                            console.log('Image URL entered:', url);
                        }
                    });
                }

                // FIX 2: ✅ FIXED - Enhanced navigation button effects
                const navButtons = document.querySelectorAll('.nav-btn, .success-btn');
                navButtons.forEach(btn => {
                    btn.addEventListener('mouseenter', function() {
                        this.style.transform = 'translateY(-3px) scale(1.05)';
                    });
                    
                    btn.addEventListener('mouseleave', function() {
                        this.style.transform = 'translateY(0) scale(1)';
                    });
                });
            });
        </script>
    </body>
</html>