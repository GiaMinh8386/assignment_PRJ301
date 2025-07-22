<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.ReviewDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="utils.AuthUtils" %>
<%@ page errorPage="error.jsp" %>

<%
    // Kiểm tra đăng nhập
    if (!AuthUtils.isLoggedIn(request)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá của tôi - GymLife</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
       body {
    background-color: #f8f9fa;
    font-family: 'Segoe UI', sans-serif;
}

.review-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: nowrap;
    margin-bottom: 15px;
    padding-bottom: 15px;
    border-bottom: 1px solid #e9ecef;
}

.reviews-header h1 {
    margin: 0;
    font-weight: 700;
    font-size: 2.5rem;
}

.reviews-header p {
    margin: 10px 0 0 0;
    opacity: 0.9;
    font-size: 1.1rem;
}

.reviews-container {
    background: white;
    border-radius: 15px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    padding: 30px;
    margin-bottom: 30px;
}

.review-card {
    border: 1px solid #e9ecef;
    border-radius: 12px;
    padding: 25px;
    margin-bottom: 20px;
    transition: all 0.3s ease;
    background: white;
}

.review-card:hover {
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    transform: translateY(-2px);
}

.review-comment {
    color: #212529;
    line-height: 1.6;
    margin-bottom: 20px;
}

.product-info {
    display: flex;
    align-items: center;
    gap: 15px;
    padding: 10px;
    border: 1px solid #dee2e6;
    border-radius: 10px;
    background-color: #f9f9f9;
}

.product-image {
    width: 60px;
    height: 60px;
    border-radius: 8px;
    object-fit: cover;
    background: #f8f9fa;
}

.product-details h6 {
    margin: 0;
    font-weight: 600;
    color: #333;
}

.product-details small {
    color: #666;
}

.review-rating {
    display: flex;
    align-items: center;
    gap: 10px;
}

.rating-stars {
    display: flex;
    gap: 5px;
    font-size: 1.5rem;
    color: #ffc107;
    cursor: pointer;
}

.rating-number {
    background: #b02a20;
    color: white;
    padding: 4px 8px;
    border-radius: 15px;
    font-size: 0.8rem;
    font-weight: 600;
}

.review-date {
    color: #666;
    font-size: 0.9rem;
}

.review-actions {
    display: flex;
    gap: 10px;
    justify-content: flex-end;
}

.btn-review-action {
    padding: 8px 16px;
    border: none;
    border-radius: 20px;
    font-size: 0.85rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 5px;
}

.btn-view-product {
    background: #17a2b8;
    color: white;
}

.btn-view-product:hover {
    background: #138496;
    color: white;
    text-decoration: none;
}

.btn-edit-review {
    background: #28a745;
    color: white;
}

.btn-edit-review:hover {
    background: #218838;
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

.empty-state {
    text-align: center;
    padding: 60px 20px;
    color: #6c757d;
}

.empty-state i {
    font-size: 5rem;
    margin-bottom: 20px;
    color: #dee2e6;
}

.empty-state h3 {
    font-size: 1.8rem;
    margin-bottom: 15px;
    color: #495057;
}

.empty-state p {
    font-size: 1.1rem;
    margin-bottom: 30px;
    line-height: 1.6;
}

.empty-state .btn {
    background-color: #b02a20;
    border: none;
    padding: 15px 30px;
    border-radius: 25px;
    color: white;
    font-weight: 600;
    text-decoration: none;
    transition: all 0.3s ease;
    font-size: 16px;
}

.empty-state .btn:hover {
    background-color: #8b1e16;
    transform: translateY(-2px);
    color: white;
    text-decoration: none;
}

.stats-card {
    background: white;
    border-radius: 15px;
    padding: 20px;
    text-align: center;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    margin-bottom: 30px;
}

.stats-number {
    font-size: 2.5rem;
    font-weight: 700;
    color: #b02a20;
    margin-bottom: 5px;
}

.stats-label {
    color: #666;
    font-weight: 500;
    text-transform: uppercase;
    font-size: 0.9rem;
    letter-spacing: 0.5px;
}

.breadcrumb-section {
    background: #fff;
    padding: 15px 0;
    margin-bottom: 20px;
    border-bottom: 1px solid #e9ecef;
}

.breadcrumb {
    background: none;
    margin: 0;
    padding: 0;
}

.breadcrumb-item a {
    color: #6c757d;
    text-decoration: none;
}

.breadcrumb-item a:hover {
    color: #b02a20;
}

.breadcrumb-item.active {
    color: #333;
}

textarea,
textarea.form-control {
    background-color: #ffffff !important;
    color: #212529 !important;  /* chữ đen dễ nhìn */
    border: 1px solid #ced4da;
    border-radius: 10px;
    padding: 10px;
    min-height: 150px;
}

/* Fix màu placeholder khi chưa gõ */
textarea::placeholder,
textarea.form-control::placeholder {
    color: #6c757d !important; /* placeholder xám đậm */
    opacity: 1 !important;     /* hiển thị rõ ràng */
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
                    <li class="breadcrumb-item active" aria-current="page">
                        Đánh giá của tôi
                    </li>
                </ol>
            </nav>
        </div>
    </div>
    
    <!-- Reviews Header -->
    <div class="reviews-header">
        <div class="container text-center">
            <h1><i class="fas fa-star me-3"></i>Đánh giá của tôi</h1>
            <p>Quản lý tất cả đánh giá bạn đã viết cho các sản phẩm</p>
        </div>
    </div>

    <div class="container">
        <%
            List<ReviewDTO> userReviews = (List<ReviewDTO>) request.getAttribute("userReviews");
            int reviewCount = userReviews != null ? userReviews.size() : 0;
        %>
        
        <!-- Stats Card -->
        <div class="row">
            <div class="col-md-4 mx-auto">
                <div class="stats-card">
                    <div class="stats-number"><%= reviewCount %></div>
                    <div class="stats-label">Đánh giá đã viết</div>
                </div>
            </div>
        </div>

        <!-- Reviews Container -->
        <div class="reviews-container">
            <%
                if (userReviews != null && !userReviews.isEmpty()) {
            %>
            
            <h5 class="mb-4">
                <i class="fas fa-list me-2"></i>Danh sách đánh giá của bạn
            </h5>
            
            <%
                for (ReviewDTO review : userReviews) {
            %>
            <div class="review-card">
                <div class="review-header">
                    <div class="product-info">
                        <div class="product-image-placeholder" style="width: 60px; height: 60px; background: #000000
; border-radius: 8px; display: flex; align-items: center; justify-content: center;">
                            <i class="fas fa-box text-muted"></i>
                        </div>
                
                <div class="review-date mb-3">
                    <i class="fas fa-calendar-alt me-2"></i>
                    Đánh giá vào: <%= review.getFormattedDate() %>
                </div>
                
                <% if (review.getComment() != null && !review.getComment().trim().isEmpty()) { %>
                <div class="review-comment">
                    "<%= review.getComment() %>"
                </div>
                <% } else { %>
                <div class="review-comment text-muted fst-italic">
                    Không có bình luận
                </div>
                <% } %>
                
                <div class="review-actions">
                    <a href="MainController?action=productDetail&id=<%= review.getProductID() %>" 
                       class="btn-review-action btn-view-product">
                        <i class="fas fa-eye"></i>Xem sản phẩm
                    </a>
                    
                    <button class="btn-review-action btn-edit-review" 
                            onclick="editReview(<%= review.getReviewID() %>, <%= review.getRating() %>, '<%= review.getComment() != null ? review.getComment().replace("'", "\\'") : "" %>', '<%= review.getProductID() %>')">
                        <i class="fas fa-edit"></i>Chỉnh sửa
                    </button>
                    
                    <button class="btn-review-action btn-delete-review" 
                            onclick="deleteReview(<%= review.getReviewID() %>, '<%= review.getProductID() %>')">
                        <i class="fas fa-trash"></i>Xóa
                    </button>
                </div>
            </div>
            <%
                }
            %>
            
            <!-- Back to Shopping -->
            <div class="text-center mt-4">
                <a href="MainController?action=home" class="btn btn-outline-primary btn-lg">
                    <i class="fas fa-shopping-bag me-2"></i>Tiếp tục mua sắm
                </a>
            </div>
            
            <%
                } else {
            %>
            
            <!-- Empty State -->
            <div class="empty-state">
                <i class="fas fa-comment-slash"></i>
                <h3>Chưa có đánh giá nào</h3>
                <p>
                    Bạn chưa viết đánh giá cho sản phẩm nào.<br>
                    Hãy mua sắm và chia sẻ trải nghiệm của bạn về các sản phẩm!
                </p>
                <a href="MainController?action=home" class="btn">
                    <i class="fas fa-search me-2"></i>Khám phá sản phẩm
                </a>
            </div>
            
            <%
                }
            %>
        </div>
    </div>

    <!-- Include Footer -->
    <%@ include file="footer.jsp" %>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Delete review function
        function deleteReview(reviewID, productID) {
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
                productIdInput.value = productID;
                form.appendChild(productIdInput);

                document.body.appendChild(form);
                form.submit();
            }
        }

        // Edit review function
        function editReview(reviewID, currentRating, currentComment, productID) {
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
            productIdInput.value = productID;
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
        
        document.addEventListener('DOMContentLoaded', function() {
            console.log('✅ User Reviews page loaded successfully!');
            
            // Add smooth animations to review cards
            const cards = document.querySelectorAll('.review-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
            
            // Enhanced button effects
            const buttons = document.querySelectorAll('.btn-review-action');
            buttons.forEach(btn => {
                btn.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px)';
                });
                
                btn.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });
        });
    </script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    const stars = document.querySelectorAll('#rating-stars i');
    let selected = 0;

    function highlight(index) {
        stars.forEach((star, i) => {
            star.classList.remove('fas', 'far', 'text-warning');
            if (i <= index) {
                star.classList.add('fas', 'text-warning');
            } else {
                star.classList.add('far');
            }
        });
    }

    stars.forEach((star, index) => {
        star.addEventListener('mouseenter', () => highlight(index));
        star.addEventListener('mouseleave', () => highlight(selected - 1));
        star.addEventListener('click', () => {
            selected = index + 1;
            document.getElementById('rating-value').value = selected; // gán vào hidden input nếu có
            highlight(index);
        });
    });

    highlight(selected - 1);
});
</script>
</body>
</html>        <% 
    List<ReviewDTO> reviewList = (List<ReviewDTO>) request.getAttribute("reviewList"); 
%>

<% if (reviewList != null && !reviewList.isEmpty()) { %>
    <% for (ReviewDTO review : reviewList) { 
           int rating = review.getRating();
    %>
        <div class="product-details">
            <h6><%= review.getProductName() %></h6>
            <small>Mã sản phẩm: <%= review.getProductID() %></small>
        </div>

        <div class="review-rating">
            <div class="rating-stars" id="rating-stars">
                <% for (int i = 1; i <= 5; i++) { %>
                    <i class="fa-star <%= i <= rating ? "fas text-warning" : "far" %>" data-value="<%= i %>"></i>
                <% } %>
            </div>
            <div class="rating-number">
                <%= review.getRating() %>/5
            </div>
        </div>
        <hr>
    <% } %>
<% } else { %>
    <p>Bạn chưa viết đánh giá nào.</p>
<% } %>
                </div>