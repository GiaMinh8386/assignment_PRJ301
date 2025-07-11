<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.ReviewDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="utils.AuthUtils" %>
<%@ page errorPage="error.jsp" %>

<%
    // Kiểm tra quyền admin
    if (!AuthUtils.isAdmin(request)) {
        response.sendRedirect("MainController?action=home");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đánh giá - Admin Dashboard</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', sans-serif;
        }
        
        .admin-header {
            background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
            color: white;
            padding: 20px 0;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .admin-header h1 {
            margin: 0;
            font-weight: 700;
        }
        
        .stats-cards {
            margin-bottom: 30px;
        }
        
        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
            height: 100%;
            text-align: center;
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
        }
        
        .stats-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin: 0 auto 15px;
        }
        
        .stats-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 5px;
        }
        
        .stats-label {
            color: #666;
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }
        
        .icon-primary { background: linear-gradient(135deg, #007bff, #0056b3); color: white; }
        .icon-success { background: linear-gradient(135deg, #28a745, #1e7e34); color: white; }
        .icon-warning { background: linear-gradient(135deg, #ffc107, #e0a800); color: #333; }
        .icon-danger { background: linear-gradient(135deg, #dc3545, #c82333); color: white; }
        
        .reviews-table {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
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
        
        .rating-stars {
            color: #ffc107;
            font-size: 1.1rem;
        }
        
        .btn-action {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 0.8rem;
            margin: 2px;
        }
        
        .review-comment {
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .review-comment.expanded {
            white-space: normal;
            max-width: none;
        }
        
        .expand-btn {
            color: #007bff;
            cursor: pointer;
            font-size: 0.8rem;
            text-decoration: underline;
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
    </style>
</head>
<body>

    <!-- Include Header -->
    <%@ include file="header.jsp" %>
    
    <!-- Admin Header -->
    <div class="admin-header">
        <div class="container">
            <div class="text-center">
                <a href="ProductController?action=adminDashboard" class="back-btn">
                    <i class="fas fa-arrow-left me-2"></i>Quay về Dashboard
                </a>
            </div>
            <div class="row align-items-center">
                <div class="col-8">
                    <h1><i class="fas fa-star me-3"></i>Quản lý đánh giá</h1>
                    <p class="mb-0">Tổng quan và quản lý đánh giá từ khách hàng</p>
                </div>
                <div class="col-4 text-end">
                    <div class="text-white-50">
                        <i class="fas fa-calendar me-2"></i>
                        <span id="currentDate"></span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <%
            List<ReviewDTO> allReviews = (List<ReviewDTO>) request.getAttribute("allReviews");
            int totalReviews = allReviews != null ? allReviews.size() : 0;
            
            // Tính toán thống kê
            int fiveStars = 0, fourStars = 0, threeStars = 0, twoStars = 0, oneStars = 0;
            double avgRating = 0.0;
            
            if (allReviews != null && !allReviews.isEmpty()) {
                int totalRating = 0;
                for (ReviewDTO review : allReviews) {
                    totalRating += review.getRating();
                    switch(review.getRating()) {
                        case 5: fiveStars++; break;
                        case 4: fourStars++; break;
                        case 3: threeStars++; break;
                        case 2: twoStars++; break;
                        case 1: oneStars++; break;
                    }
                }
                avgRating = (double) totalRating / totalReviews;
            }
        %>
        
        <!-- Statistics Cards -->
        <div class="row stats-cards">
            <div class="col-md-3 mb-3">
                <div class="stats-card">
                    <div class="stats-icon icon-primary">
                        <i class="fas fa-comments"></i>
                    </div>
                    <div class="stats-number"><%= totalReviews %></div>
                    <div class="stats-label">Tổng đánh giá</div>
                </div>
            </div>
            
            <div class="col-md-3 mb-3">
                <div class="stats-card">
                    <div class="stats-icon icon-warning">
                        <i class="fas fa-star"></i>
                    </div>
                    <div class="stats-number"><%= String.format("%.1f", avgRating) %></div>
                    <div class="stats-label">Điểm trung bình</div>
                </div>
            </div>
            
            <div class="col-md-3 mb-3">
                <div class="stats-card">
                    <div class="stats-icon icon-success">
                        <i class="fas fa-thumbs-up"></i>
                    </div>
                    <div class="stats-number"><%= fiveStars + fourStars %></div>
                    <div class="stats-label">Đánh giá tốt (4-5★)</div>
                </div>
            </div>
            
            <div class="col-md-3 mb-3">
                <div class="stats-card">
                    <div class="stats-icon icon-danger">
                        <i class="fas fa-thumbs-down"></i>
                    </div>
                    <div class="stats-number"><%= oneStars + twoStars %></div>
                    <div class="stats-label">Đánh giá kém (1-2★)</div>
                </div>
            </div>
        </div>

        <!-- Reviews Table -->
        <div class="reviews-table">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5><i class="fas fa-table me-2"></i>Danh sách đánh giá</h5>
                <div>
                    <button class="btn btn-outline-primary btn-sm me-2" onclick="refreshData()">
                        <i class="fas fa-sync-alt me-1"></i>Làm mới
                    </button>
                    <button class="btn btn-outline-success btn-sm" onclick="exportData()">
                        <i class="fas fa-download me-1"></i>Xuất Excel
                    </button>
                </div>
            </div>
            
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Khách hàng</th>
                            <th>Sản phẩm</th>
                            <th>Đánh giá</th>
                            <th>Bình luận</th>
                            <th>Ngày đánh giá</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (allReviews != null && !allReviews.isEmpty()) {
                                for (ReviewDTO review : allReviews) {
                        %>
                        <tr>
                            <td><strong>#<%= review.getReviewID() %></strong></td>
                            <td>
                                <div>
                                    <strong><%= review.getUserName() %></strong>
                                    <br><small class="text-muted">ID: <%= review.getUserID() %></small>
                                </div>
                            </td>
                            <td>
                                <div>
                                    <strong><%= review.getProductName() %></strong>
                                    <br><small class="text-muted">ID: <%= review.getProductID() %></small>
                                </div>
                            </td>
                            <td>
                                <div class="rating-stars">
                                    <%= review.getStarDisplay() %>
                                </div>
                                <small class="text-muted"><%= review.getRating() %>/5</small>
                            </td>
                            <td>
                                <% if (review.getComment() != null && !review.getComment().trim().isEmpty()) { %>
                                <div class="review-comment" id="comment-<%= review.getReviewID() %>">
                                    <%= review.getComment() %>
                                </div>
                                <% if (review.getComment().length() > 50) { %>
                                <small class="expand-btn" onclick="toggleComment(<%= review.getReviewID() %>)">
                                    Xem thêm
                                </small>
                                <% } %>
                                <% } else { %>
                                <em class="text-muted">Không có bình luận</em>
                                <% } %>
                            </td>
                            <td>
                                <small><%= review.getFormattedDate() %></small>
                            </td>
                            <td>
                                <a href="MainController?action=productDetail&id=<%= review.getProductID() %>" 
                                   class="btn btn-outline-primary btn-action" title="Xem sản phẩm">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <button class="btn btn-outline-danger btn-action" 
                                        onclick="deleteReview(<%= review.getReviewID() %>)" title="Xóa đánh giá">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="7" class="text-center py-5">
                                <i class="fas fa-comment-slash fa-3x text-muted mb-3"></i>
                                <p class="text-muted">Chưa có đánh giá nào</p>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Include Footer -->
    <%@ include file="footer.jsp" %>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Display current date
            const currentDate = new Date().toLocaleDateString('vi-VN', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
            document.getElementById('currentDate').textContent = currentDate;
            
            console.log('✅ Admin Reviews page loaded successfully!');
        });
        
        // Toggle comment expansion
        function toggleComment(reviewID) {
            const commentDiv = document.getElementById('comment-' + reviewID);
            const expandBtn = commentDiv.nextElementSibling;
            
            if (commentDiv.classList.contains('expanded')) {
                commentDiv.classList.remove('expanded');
                expandBtn.textContent = 'Xem thêm';
            } else {
                commentDiv.classList.add('expanded');
                expandBtn.textContent = 'Thu gọn';
            }
        }
        
        // Delete review function
        function deleteReview(reviewID) {
            if (confirm('Bạn có chắc muốn xóa đánh giá này?\nHành động này không thể hoàn tác!')) {
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

                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function refreshData() {
            const btn = event.target.closest('button');
            const originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang tải...';
            btn.disabled = true;
            
            setTimeout(() => {
                btn.innerHTML = originalText;
                btn.disabled = false;
                window.location.reload();
            }, 1000);
        }
        
        function exportData() {
            alert('Chức năng xuất Excel sẽ được triển khai trong phiên bản tiếp theo!');
        }
    </script>

</body>
</html>