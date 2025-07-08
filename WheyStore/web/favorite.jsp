<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.ProductDTO" %>
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
    <title>Sản phẩm yêu thích - GymLife</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', sans-serif;
        }
        
        .favorites-header {
            background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .favorites-header h1 {
            margin: 0;
            font-weight: 700;
            font-size: 2.5rem;
        }
        
        .favorites-header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
            font-size: 1.1rem;
        }
        
        .product-card {
            border: 1px solid #e9ecef;
            border-radius: 15px;
            transition: all 0.3s ease;
            overflow: hidden;
            height: 100%;
            display: flex;
            flex-direction: column;
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .product-card:hover {
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            transform: translateY(-5px);
        }
        
        .product-image-container {
            position: relative;
            height: 200px;
            overflow: hidden;
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .product-image {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
            transition: transform 0.3s ease;
        }
        
        .product-image:hover {
            transform: scale(1.05);
        }
        
        .product-image-placeholder {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            font-size: 14px;
            text-align: center;
            flex-direction: column;
        }
        
        .product-image-placeholder i {
            font-size: 3rem;
            margin-bottom: 10px;
            opacity: 0.5;
        }
        
        .product-info {
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        
        .product-brand {
            color: #6c757d;
            font-size: 12px;
            margin-bottom: 8px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .product-title {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 12px;
            min-height: 48px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .product-description {
            font-size: 14px;
            color: #666;
            margin-bottom: 15px;
            flex-grow: 1;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .product-price {
            color: #dc3545;
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .product-actions {
            margin-top: auto;
            display: flex;
            gap: 8px;
        }
        
        .btn-detail {
            background-color: #b02a20;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 16px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            flex: 1;
            text-align: center;
            font-size: 14px;
        }
        
        .btn-detail:hover {
            background-color: #8b1e16;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
        }
        
        .btn-remove-favorite {
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px;
            transition: all 0.3s ease;
            width: 45px;
            height: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .btn-remove-favorite:hover {
            background-color: #c82333;
            color: white;
            transform: translateY(-2px);
        }
        
        .favorite-heart {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(220, 53, 69, 0.9);
            color: white;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            animation: heartbeat 2s infinite;
        }
        
        @keyframes heartbeat {
            0% { transform: scale(1); }
            14% { transform: scale(1.1); }
            28% { transform: scale(1); }
            42% { transform: scale(1.1); }
            70% { transform: scale(1); }
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
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
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
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
                        Sản phẩm yêu thích
                    </li>
                </ol>
            </nav>
        </div>
    </div>
    
    <!-- Favorites Header -->
    <div class="favorites-header">
        <div class="container text-center">
            <h1><i class="fas fa-heart me-3"></i>Sản phẩm yêu thích</h1>
            <p>Những sản phẩm bạn đã yêu thích để mua sau</p>
        </div>
    </div>

    <div class="container">
        <%
            List<ProductDTO> favorites = (List<ProductDTO>) request.getAttribute("favorites");
            int favoriteCount = favorites != null ? favorites.size() : 0;
        %>
        
        <!-- Stats Card -->
        <div class="row">
            <div class="col-md-4 mx-auto">
                <div class="stats-card">
                    <div class="stats-number"><%= favoriteCount %></div>
                    <div class="stats-label">Sản phẩm yêu thích</div>
                </div>
            </div>
        </div>

        <%
            if (favorites != null && !favorites.isEmpty()) {
        %>
        
        <!-- Products Grid -->
        <div class="row">
            <%
                for (ProductDTO product : favorites) {
            %>
            <div class="col-md-4 col-lg-3 mb-4">
                <div class="card product-card">
                    <!-- Favorite Heart Icon -->
                    <div class="favorite-heart">
                        <i class="fas fa-heart"></i>
                    </div>
                    
                    <!-- Product Image -->
                    <%
                        String contextPath = request.getContextPath();
                        String imageName = product.getImage();
                        String imagePath = null;
                        boolean hasValidImage = false;
                        
                        if (imageName != null && !imageName.trim().isEmpty()) {
                            if (imageName.startsWith("http://") || imageName.startsWith("https://")) {
                                imagePath = imageName;
                                hasValidImage = true;
                            } else if (imageName.startsWith("/") || imageName.startsWith("assets/")) {
                                imagePath = contextPath + (imageName.startsWith("/") ? imageName : "/assets/images/products/" + imageName);
                                hasValidImage = true;
                            } else {
                                imagePath = contextPath + "/assets/images/products/" + imageName;
                                hasValidImage = true;
                            }
                        }
                    %>
                    
                    <div class="product-image-container">
                        <% if (hasValidImage) { %>
                            <img src="<%= imagePath %>"
                                 class="product-image"
                                 alt="<%= product.getName() %>"
                                 loading="lazy"
                                 onerror="handleImageError(this, '<%= product.getName() %>', '<%= product.getBrand() != null ? product.getBrand() : "" %>')">
                        <% } else { %>
                            <div class="product-image-placeholder">
                                <i class="fas fa-image"></i>
                                <div><%= product.getBrand() != null ? product.getBrand() : "Product" %></div>
                                <small><%= product.getFormattedPrice() %></small>
                            </div>
                        <% } %>
                    </div>

                    <div class="product-info">
                        <%
                            if (product.getBrand() != null && !product.getBrand().trim().isEmpty()) {
                        %>
                        <div class="product-brand"><%= product.getBrand() %></div>
                        <%
                            }
                        %>
                        <h5 class="product-title"><%= product.getName() %></h5>
                        
                        <%
                            if (product.getDescription() != null && !product.getDescription().trim().isEmpty()) {
                        %>
                        <p class="product-description"><%= product.getDescription() %></p>
                        <%
                            }
                        %>
                        
                        <div class="product-price">
                            <%
                                if (product.getPrice() > 0) {
                                    out.print(product.getFormattedPrice());
                                } else {
                                    out.print("Liên hệ");
                                }
                            %>
                        </div>
                        
                        <div class="product-actions">
                            <a href="MainController?action=productDetail&id=<%= product.getId() %>" 
                               class="btn-detail">
                                <i class="fas fa-eye me-2"></i>Xem chi tiết
                            </a>
                            
                            <form action="FavoriteController" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="toggleFavorite">
                                <input type="hidden" name="productID" value="<%= product.getId() %>">
                                <button type="submit" class="btn-remove-favorite" 
                                        title="Bỏ yêu thích"
                                        onclick="return confirm('Bỏ sản phẩm này khỏi danh sách yêu thích?')">
                                    <i class="fas fa-heart-broken"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <%
                }
            %>
        </div>
        
        <!-- Back to Shopping -->
        <div class="text-center mt-4 mb-5">
            <a href="MainController?action=home" class="btn btn-outline-primary btn-lg">
                <i class="fas fa-shopping-bag me-2"></i>Tiếp tục mua sắm
            </a>
        </div>
        
        <%
            } else {
        %>
        
        <!-- Empty State -->
        <div class="empty-state">
            <i class="fas fa-heart-broken"></i>
            <h3>Chưa có sản phẩm yêu thích</h3>
            <p>
                Bạn chưa yêu thích sản phẩm nào.<br>
                Hãy khám phá và thêm những sản phẩm bạn quan tâm vào danh sách yêu thích!
            </p>
            <a href="MainController?action=home" class="btn">
                <i class="fas fa-search me-2"></i>Khám phá sản phẩm
            </a>
        </div>
        
        <%
            }
        %>
    </div>

    <!-- Include Footer -->
    <%@ include file="footer.jsp" %>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Handle image errors
        function handleImageError(img, productName, productBrand) {
            console.log('🖼️ Image failed to load for product:', productName);
            
            const placeholder = document.createElement('div');
            placeholder.className = 'product-image-placeholder';
            placeholder.innerHTML = `
                <i class="fas fa-image"></i>
                <div>${productBrand || 'Product'}</div>
                <small>Hình ảnh không có sẵn</small>
            `;
            
            img.parentNode.replaceChild(placeholder, img);
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            console.log('✅ Favorites page loaded successfully!');
            
            // Add smooth animations to cards
            const cards = document.querySelectorAll('.product-card');
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
            const buttons = document.querySelectorAll('.btn-detail, .btn-remove-favorite');
            buttons.forEach(btn => {
                btn.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-3px)';
                });
                
                btn.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });
            
            // Confirmation for remove favorite
            const removeForms = document.querySelectorAll('form[action="FavoriteController"]');
            removeForms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    const btn = this.querySelector('button[type="submit"]');
                    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                    btn.disabled = true;
                });
            });
        });
    </script>

</body>
</html>