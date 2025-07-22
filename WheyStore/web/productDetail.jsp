<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.ProductDTO" %>
<%@ page import="model.ReviewDAO" %>
<%@ page import="model.ReviewDTO" %>
<%@ page import="utils.AuthUtils" %>
<%@ page import="java.util.List" %>
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
        <title><%= product.getName() %> - GymLife</title>

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

            /* ===== REVIEW SECTION STYLES ===== */
            .reviews-section {
                background: white;
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                margin-top: 30px;
            }

            .review-summary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 25px;
                border-radius: 10px;
                margin-bottom: 30px;
                text-align: center;
            }

            .average-rating {
                font-size: 3rem;
                font-weight: 700;
                margin-bottom: 10px;
            }

            .rating-stars {
                font-size: 1.5rem;
                color: #ffc107;
                margin-bottom: 10px;
            }

            .review-count {
                font-size: 1.1rem;
                opacity: 0.9;
            }

            .review-form {
                background: #f8f9fa;
                padding: 25px;
                border-radius: 10px;
                margin-bottom: 30px;
            }

            .star-rating {
                display: flex;
                gap: 5px;
                margin-bottom: 15px;
            }

            .star-rating input[type="radio"] {
                display: none;
            }

            .star-rating label {
                font-size: 2rem;
                color: #ddd;
                cursor: pointer;
                transition: color 0.3s ease;
            }

            .star-rating input[type="radio"]:checked ~ label,
            .star-rating label:hover,
            .star-rating label:hover ~ label {
                color: #ffc107;
            }

            .review-item {
                border-bottom: 1px solid #e9ecef;
                padding: 20px 0;
            }

            .review-item:last-child {
                border-bottom: none;
            }

            .review-header {
                display: flex;
                justify-content: between;
                align-items: center;
                margin-bottom: 10px;
            }

            .reviewer-info {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .reviewer-avatar {
                width: 40px;
                height: 40px;
                background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: 600;
            }

            .reviewer-name {
                font-weight: 600;
                color: #333;
            }

            .review-date {
                color: #666;
                font-size: 0.9rem;
            }

            .review-rating {
                color: #ffc107;
                font-size: 1.2rem;
            }

            .review-comment {
                color: #555;
                line-height: 1.6;
                margin-top: 10px;
            }

            .review-actions {
                margin-top: 15px;
                display: flex;
                gap: 10px;
            }

            .btn-review-action {
                padding: 5px 15px;
                border: none;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-edit-review {
                background: #17a2b8;
                color: white;
            }

            .btn-edit-review:hover {
                background: #138496;
                color: white;
            }

            .btn-delete-review {
                background: #dc3545;
                color: white;
            }

            .btn-delete-review:hover {
                background: #c82333;
                color: white;
            }

            .alert-review {
                border-radius: 10px;
                margin-bottom: 20px;
            }
            
            textarea.form-control,
            textarea#comment {
                background-color: #ffffff !important;    /* nền trắng */
                color: #000000 !important;               /* chữ đen rõ ràng */
                border: 1px solid #ccc;
                padding: 10px;
                border-radius: 10px;
                min-height: 150px;
                font-size: 15px;
            }

            /* Màu placeholder */
            textarea::placeholder,
            textarea.form-control::placeholder {
            color: #6c757d !important;               /* placeholder xám đậm */
            opacity: 1 !important;
            }
            
            .star-rating {
                display: flex;
                flex-direction: row; /* trái -> phải */
                gap: 5px;
            }

            .star-rating input[type="radio"] {
                display: none;
            }

            .star-rating label {
                font-size: 24px;
                color: #ddd;
                cursor: pointer;
                transition: color 0.2s;
            }

            .star-rating label:hover,
            .star-rating label:hover ~ label {
                color: #ffc107; /* khi hover */
            }

            .star-rating input[type="radio"]:checked ~ label {
                color: #ddd;
            }

            .star-rating input[type="radio"]:checked + label,
            .star-rating input[type="radio"]:checked + label ~ label {
                color: #ffc107; /* khi chọn */
            }
            
            .star-rating {
                direction: rtl; /* quan trọng để đảo ngược thứ tự hiển thị */
                unicode-bidi: bidi-override;
                display: inline-flex;
            }

            .star-rating input[type="radio"] {
                display: none;
            }   

            .star-rating label {
                font-size: 2rem;
                color: #ddd;
                cursor: pointer;
                transition: color 0.2s;
            }

            .star-rating label:hover,
            .star-rating label:hover ~ label {
                color: #ffc107; /* vàng khi hover */
            }

            .star-rating input[type="radio"]:checked ~ label {
                color: #ddd; /* reset màu nếu chọn lại sao thấp hơn */
            }

            .star-rating input[type="radio"]:checked + label,
            .star-rating input[type="radio"]:checked + label ~ label {
                color: #ffc107; /* sao đã chọn */
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
                                String imageName = product.getImageURL();
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

                            <!-- Favorite Button -->
                            <% if (currentUser != null) { %>
                            <div class="d-flex justify-content-center mt-3">
                                <form action="FavoriteController" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="toggleFavorite">
                                    <input type="hidden" name="productID" value="<%= product.getId() %>">
                                    <button type="submit" class="btn-favorite">
                                        <i class="fas fa-heart me-2"></i>Yêu thích
                                    </button>
                                </form>
                            </div>
                            <% } %>

                            <!-- Back to Products -->
                            <div class="text-center mt-3">
                                <a href="MainController?action=home" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách sản phẩm
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ===== REVIEWS SECTION ===== -->
            <div class="reviews-section">
                <h4 class="mb-4">
                    <i class="fas fa-star text-warning me-2"></i>Đánh giá sản phẩm
                </h4>

                <%
                    // Lấy thông tin review summary và danh sách reviews
                    ReviewDAO reviewDAO = new ReviewDAO();
                    ReviewDAO.ReviewSummaryDTO reviewSummary = null;
                    List<ReviewDTO> reviews = null;
                    boolean hasUserReviewed = false;
                    
                    try {
                        reviewSummary = reviewDAO.getReviewSummary(product.getId());
                        reviews = reviewDAO.getReviewsByProduct(product.getId());
                        
                        if (currentUser != null) {
                            hasUserReviewed = reviewDAO.hasUserReviewed(product.getId(), currentUser.getUserID());
                        }
                    } catch (Exception e) {
                        System.out.println("Error loading reviews: " + e.getMessage());
                        reviewSummary = new ReviewDAO.ReviewSummaryDTO(0.0, 0);
                        reviews = new java.util.ArrayList<>();
                    }
                %>

                <!-- Review Summary -->
                <div class="review-summary">
                    <div class="row">
                        <div class="col-4 text-center">
                            <div class="average-rating"><%= reviewSummary.getFormattedRating() %></div>
                            <div class="rating-stars"><%= reviewSummary.getStarDisplay() %></div>
                            <div class="review-count"><%= reviewSummary.getTotalReviews() %> đánh giá</div>
                        </div>
                        <div class="col-8 d-flex align-items-center">
                            <div>
                                <h5 class="mb-2">Điểm đánh giá trung bình</h5>
                                <p class="mb-0">Dựa trên <%= reviewSummary.getTotalReviews() %> đánh giá từ khách hàng đã mua sản phẩm</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Review Form -->
                <% if (currentUser != null && !hasUserReviewed) { %>
                <div class="review-form">
                    <h5 class="mb-3"><i class="fas fa-edit me-2"></i>Viết đánh giá của bạn</h5>
                    
                    <!-- Show messages -->
                    <%
                        String error = request.getParameter("error");
                        String success = request.getParameter("success");
                        
                        if (error != null) {
                            String errorMsg = "";
                            switch(error) {
                                case "rating_required": errorMsg = "Vui lòng chọn số sao đánh giá!"; break;
                                case "invalid_rating": errorMsg = "Đánh giá phải từ 1 đến 5 sao!"; break;
                                case "already_reviewed": errorMsg = "Bạn đã đánh giá sản phẩm này rồi!"; break;
                                case "add_failed": errorMsg = "Không thể thêm đánh giá. Vui lòng thử lại!"; break;
                                default: errorMsg = "Có lỗi xảy ra!";
                            }
                    %>
                    <div class="alert alert-danger alert-review">
                        <i class="fas fa-exclamation-triangle me-2"></i><%= errorMsg %>
                    </div>
                    <% } %>
                    
                    <% if (success != null) {
                        String successMsg = "";
                        switch(success) {
                            case "review_added": successMsg = "Cảm ơn bạn đã đánh giá sản phẩm!"; break;
                            case "review_updated": successMsg = "Đánh giá của bạn đã được cập nhật!"; break;
                            case "review_deleted": successMsg = "Đánh giá đã được xóa!"; break;
                            default: successMsg = "Thành công!";
                        }
                    %>
                    <div class="alert alert-success alert-review">
                        <i class="fas fa-check-circle me-2"></i><%= successMsg %>
                    </div>
                    <% } %>
                    
                    <form action="ReviewController" method="post">
                        <input type="hidden" name="action" value="addReview">
                        <input type="hidden" name="productID" value="<%= product.getId() %>">
                        
                        <!-- Star Rating -->
                        <div class="mb-3">
                            <label class="form-label fw-bold">Đánh giá của bạn:</label>
                            <div class="star-rating">
                                <input type="radio" name="rating" value="5" id="star5">
                                <label for="star5">★</label>
                                <input type="radio" name="rating" value="4" id="star4">
                                <label for="star4">★</label>
                                <input type="radio" name="rating" value="3" id="star3">
                                <label for="star3">★</label>
                                <input type="radio" name="rating" value="2" id="star2">
                                <label for="star2">★</label>
                                <input type="radio" name="rating" value="1" id="star1">
                                <label for="star1">★</label>
                            </div>
                        </div>
                        
                        <!-- Comment -->
                        <div class="mb-3">
                            <label for="comment" class="form-label fw-bold">Chia sẻ trải nghiệm của bạn:</label>
                            <textarea class="form-control" id="comment" name="comment" rows="4" 
                                    placeholder="Hãy chia sẻ cảm nhận của bạn về sản phẩm này..."></textarea>
                        </div>
                        
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane me-2"></i>Gửi đánh giá
                        </button>
                    </form>
                </div>
                <% } else if (currentUser != null && hasUserReviewed) { %>
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>
                    Bạn đã đánh giá sản phẩm này. <a href="ReviewController?action=viewUserReviews">Xem đánh giá của bạn</a>
                </div>
                <% } else { %>
                <div class="alert alert-warning">
                    <i class="fas fa-sign-in-alt me-2"></i>
                    <a href="login.jsp">Đăng nhập</a> để viết đánh giá sản phẩm
                </div>
                <% } %>

                <!-- Reviews List -->
                <div class="reviews-list">
                    <h5 class="mb-3">
                        <i class="fas fa-comments me-2"></i>Đánh giá từ khách hàng 
                        <span class="badge bg-primary"><%= reviews.size() %></span>
                    </h5>
                    
                    <% if (reviews != null && !reviews.isEmpty()) { %>
                        <% for (ReviewDTO review : reviews) { %>
                        <div class="review-item">
                            <div class="review-header">
                                <div class="reviewer-info">
                                    <div class="reviewer-avatar">
                                        <%= review.getUserName() != null && !review.getUserName().isEmpty() 
                                            ? review.getUserName().substring(0, 1).toUpperCase() : "U" %>
                                    </div>
                                    <div>
                                        <div class="reviewer-name"><%= review.getUserName() %></div>
                                        <div class="review-date"><%= review.getFormattedDate() %></div>
                                    </div>
                                </div>
                                <div class="review-rating">
                                    <%= review.getStarDisplay() %>
                                </div>
                            </div>
                            
                            <% if (review.getComment() != null && !review.getComment().trim().isEmpty()) { %>
                            <div class="review-comment">
                                <%= review.getComment() %>
                            </div>
                            <% } %>
                            
                            <!-- Review Actions (cho user sở hữu hoặc admin) -->
                            <% if (currentUser != null && 
                                  (currentUser.getUserID().equals(review.getUserID()) || AuthUtils.isAdmin(request))) { %>
                            <div class="review-actions">
                                <% if (currentUser.getUserID().equals(review.getUserID())) { %>
                                <button class="btn-review-action btn-edit-review" 
                                        onclick="editReview(<%= review.getReviewID() %>, <%= review.getRating() %>, '<%= review.getComment() %>')">
                                    <i class="fas fa-edit me-1"></i>Sửa
                                </button>
                                <% } %>
                                
                                <button class="btn-review-action btn-delete-review" 
                                        onclick="deleteReview(<%= review.getReviewID() %>)">
                                    <i class="fas fa-trash me-1"></i>Xóa
                                </button>
                            </div>
                            <% } %>
                        </div>
                        <% } %>
                    <% } else { %>
                    <div class="text-center py-4">
                        <i class="fas fa-comment-slash fa-3x text-muted mb-3"></i>
                        <h6 class="text-muted">Chưa có đánh giá nào</h6>
                        <p class="text-muted">Hãy là người đầu tiên đánh giá sản phẩm này!</p>
                    </div>
                    <% } %>
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
                const form = document.getElementById('addToCartForm');
                const formData = new FormData(form);

                fetch(form.action, {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (response.ok) {
                        window.location.href = 'CartController?action=view';
                    } else {
                        form.submit();
                        setTimeout(() => {
                            window.location.href = 'CartController?action=view';
                        }, 1000);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
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

                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang thêm...';
                submitBtn.disabled = true;

                const formData = new FormData(this);
                fetch(this.action, {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (response.ok) {
                        submitBtn.innerHTML = '<i class="fas fa-check me-2"></i>Đã thêm thành công!';
                        submitBtn.classList.remove('btn-add-cart');
                        submitBtn.classList.add('btn-success');

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
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                    this.submit();
                });
            });

            // ===== REVIEW FUNCTIONS =====
            
            // Star rating interaction
            document.addEventListener('DOMContentLoaded', function() {
                const starRating = document.querySelector('.star-rating');
                if (starRating) {
                    const stars = starRating.querySelectorAll('label');
                    const radios = starRating.querySelectorAll('input[type="radio"]');
                    
                    stars.forEach((star, index) => {
                        star.addEventListener('mouseover', function() {
                            // Highlight stars up to hovered star
                            stars.forEach((s, i) => {
                                if (i >= index) {
                                    s.style.color = '#ffc107';
                                } else {
                                    s.style.color = '#ddd';
                                }
                            });
                        });
                        
                        star.addEventListener('click', function() {
                            // Set the corresponding radio button
                            radios[index].checked = true;
                        });
                    });
                    
                    starRating.addEventListener('mouseleave', function() {
                        // Reset colors based on selection
                        const checkedIndex = Array.from(radios).findIndex(radio => radio.checked);
                        stars.forEach((star, index) => {
                            if (checkedIndex >= 0 && index >= checkedIndex) {
                                star.style.color = '#ffc107';
                            } else {
                                star.style.color = '#ddd';
                            }
                        });
                    });
                }
                
                console.log('✅ Product Detail page with Reviews loaded successfully!');
            });

            // Delete review function
            function deleteReview(reviewID) {
                if (confirm('Bạn có chắc muốn xóa đánh giá này?')) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = 'ReviewController';
                    form.style.display = 'none';

                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'deleteReview';
                    form.appendChild(actionInput);

                    const reviewIdInput = document.createElement('input');
                    reviewIdInput.type = 'hidden';
                    reviewIdInput.name = 'reviewID';
                    reviewIdInput.value = reviewID;
                    form.appendChild(reviewIdInput);

                    const productIdInput = document.createElement('input');
                    productIdInput.type = 'hidden';
                    productIdInput.name = 'productID';
                    productIdInput.value = '<%= product.getId() %>';
                    form.appendChild(productIdInput);

                    document.body.appendChild(form);
                    form.submit();
                }
            }

            // Edit review function (simple version - opens prompt)
            function editReview(reviewID, currentRating, currentComment) {
                const newRating = prompt('Nhập đánh giá mới (1-5 sao):', currentRating);
                if (newRating === null) return;
                
                const rating = parseInt(newRating);
                if (isNaN(rating) || rating < 1 || rating > 5) {
                    alert('Đánh giá phải từ 1 đến 5 sao!');
                    return;
                }
                
                const newComment = prompt('Nhập bình luận mới:', currentComment || '');
                if (newComment === null) return;

                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'ReviewController';
                form.style.display = 'none';

                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'updateReview';
                form.appendChild(actionInput);

                const reviewIdInput = document.createElement('input');
                reviewIdInput.type = 'hidden';
                reviewIdInput.name = 'reviewID';
                reviewIdInput.value = reviewID;
                form.appendChild(reviewIdInput);

                const productIdInput = document.createElement('input');
                productIdInput.type = 'hidden';
                productIdInput.name = 'productID';
                productIdInput.value = '<%= product.getId() %>';
                form.appendChild(productIdInput);

                const ratingInput = document.createElement('input');
                ratingInput.type = 'hidden';
                ratingInput.name = 'rating';
                ratingInput.value = rating;
                form.appendChild(ratingInput);

                const commentInput = document.createElement('input');
                commentInput.type = 'hidden';
                commentInput.name = 'comment';
                commentInput.value = newComment;
                form.appendChild(commentInput);

                document.body.appendChild(form);
                form.submit();
            }
        </script>

    </body>
</html>