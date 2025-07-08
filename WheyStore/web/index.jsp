<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.ProductDTO" %>
<%@ page import="utils.AuthUtils" %>
<%@ page errorPage="error.jsp" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>
            <%
                String pageTitle = (String) request.getAttribute("pageTitle");
                if (pageTitle != null && !pageTitle.isEmpty()) {
                    out.print(pageTitle + " - GymLife");
                } else {
                    out.print("Trang chủ - GymLife");
                }
            %>
        </title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            /* ===== SIDEBAR STYLES ===== */
            .sidebar {
                background-color: #f8f9fa;
                border-radius: 10px;
                padding: 0;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            .sidebar-header {
                background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
                color: white;
                padding: 15px 20px;
                border-radius: 10px 10px 0 0;
                margin-bottom: 0;
            }

            .sidebar-content {
                padding: 20px;
            }

            .category-section {
                margin-bottom: 30px;
            }

            .category-section h6 {
                color: #333;
                font-weight: 600;
                margin-bottom: 15px;
                padding-bottom: 8px;
                border-bottom: 2px solid #e9ecef;
            }

            .category-link {
                display: block;
                padding: 10px 15px;
                color: #495057;
                text-decoration: none;
                border-radius: 8px;
                margin-bottom: 5px;
                transition: all 0.3s ease;
                font-weight: 500;
            }

            .category-link:hover, .category-link.active {
                background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
                color: white;
                text-decoration: none;
                transform: translateX(5px);
            }

            .category-link i {
                width: 20px;
                margin-right: 8px;
            }

            /* ===== PRICE FILTER STYLES ===== */
            .price-filter .form-check {
                margin-bottom: 8px;
            }

            .price-filter .form-check-label {
                font-weight: 500;
                color: #495057;
                cursor: pointer;
            }

            .price-filter .form-check-input:checked + .form-check-label {
                color: #b02a20;
                font-weight: 600;
            }

            .filter-btn {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                border: none;
                border-radius: 8px;
                font-weight: 600;
                padding: 10px;
                transition: all 0.3s ease;
            }

            .filter-btn:hover {
                background: linear-gradient(135deg, #20c997 0%, #17a2b8 100%);
                transform: translateY(-2px);
            }

            /* ===== MAIN CONTENT STYLES ===== */
            .main-content {
                background-color: white;
                border-radius: 10px;
                padding: 25px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .products-header {
                color: #333;
                font-weight: 700;
                margin-bottom: 25px;
                padding-bottom: 15px;
                border-bottom: 3px solid #b02a20;
            }

            /* ===== SEARCH INFO STYLES ===== */
            .search-info {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 15px 20px;
                border-radius: 8px;
                margin-bottom: 20px;
                font-size: 14px;
            }

            .search-info i {
                margin-right: 8px;
            }

            /* FIX 3: ✅ FIXED - Enhanced product card styles with better image handling */
            .product-card {
                border: 1px solid #e9ecef;
                border-radius: 12px;
                transition: all 0.3s ease;
                overflow: hidden;
                height: 100%;
                display: flex;
                flex-direction: column;
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

            /* FIX 3: ✅ FIXED - Improved image styles */
            .product-image {
                max-width: 100%;
                max-height: 100%;
                object-fit: contain;
                transition: transform 0.3s ease;
                border: none;
            }

            .product-image:hover {
                transform: scale(1.05);
            }

            .product-image.loaded {
                opacity: 1;
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
                padding: 15px;
                flex-grow: 1;
                display: flex;
                flex-direction: column;
            }

            .product-brand {
                color: #6c757d;
                font-size: 12px;
                margin-bottom: 5px;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .product-title {
                font-size: 16px;
                font-weight: 600;
                color: #333;
                margin-bottom: 10px;
                min-height: 48px;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }

            .product-price {
                color: #dc3545;
                font-size: 18px;
                font-weight: 700;
                margin-bottom: 15px;
            }

            /* FIXED: Consistent button styles for both logged in and not logged in */
            .product-actions {
                margin-top: auto;
                display: flex;
                gap: 8px;
                flex-direction: column;
            }

            .product-btn {
                background-color: #b02a20;
                color: white;
                border: none;
                border-radius: 8px;
                padding: 10px 16px;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s ease;
                display: inline-block;
                text-align: center;
                font-size: 14px;
                width: 100%;
            }

            .product-btn:hover {
                background-color: #8b1e16;
                color: white;
                text-decoration: none;
                transform: translateY(-2px);
            }

            /* FIXED: Consistent cart button styles */
            .btn-cart {
                background-color: #28a745 !important;
                border: 1px solid #28a745 !important;
                color: white !important;
                font-size: 13px;
                padding: 8px 12px;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s ease;
                width: 100%;
                text-align: center;
                text-decoration: none;
                display: inline-block;
            }

            .btn-cart:hover {
                background-color: #218838 !important;
                border-color: #1e7e34 !important;
                color: white !important;
                text-decoration: none;
                transform: translateY(-2px);
            }

            .btn-cart:disabled {
                background-color: #6c757d !important;
                border-color: #6c757d !important;
                cursor: not-allowed;
                transform: none !important;
            }

            /* ===== FAVORITE BUTTON STYLES ===== */
            .btn-favorite:hover {
                background-color: #e91e63 !important;
                border-color: #e91e63 !important;
                color: white !important;
                text-decoration: none;
                transform: translateY(-2px);
            }

            /* ===== EMPTY STATE STYLES ===== */
            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #6c757d;
            }

            .empty-state i {
                font-size: 4rem;
                margin-bottom: 20px;
                color: #dee2e6;
            }

            .empty-state h3 {
                font-size: 1.5rem;
                margin-bottom: 10px;
                color: #495057;
            }

            .empty-state p {
                font-size: 1rem;
                margin-bottom: 30px;
            }

            .empty-state .btn {
                background-color: #b02a20;
                border: none;
                padding: 12px 30px;
                border-radius: 25px;
                color: white;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .empty-state .btn:hover {
                background-color: #8b1e16;
                transform: translateY(-2px);
                color: white;
            }

            /* ===== LOGIN NOTIFICATION MODAL ===== */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                z-index: 9998;
                display: none;
            }

            .login-modal {
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: white;
                border-radius: 15px;
                padding: 30px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
                z-index: 9999;
                max-width: 400px;
                width: 90%;
                text-align: center;
                display: none;
            }

            .modal-icon {
                font-size: 3rem;
                color: #b02a20;
                margin-bottom: 20px;
            }

            .modal-title {
                font-size: 1.5rem;
                font-weight: 700;
                color: #333;
                margin-bottom: 15px;
            }

            .modal-text {
                color: #666;
                margin-bottom: 25px;
                line-height: 1.5;
            }

            .modal-actions {
                display: flex;
                gap: 10px;
                justify-content: center;
            }

            .modal-btn {
                padding: 10px 20px;
                border-radius: 25px;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
            }

            .btn-modal-login {
                background: #b02a20;
                color: white;
            }

            .btn-modal-login:hover {
                background: #8b1e16;
                color: white;
                text-decoration: none;
            }

            .btn-modal-register {
                background: #28a745;
                color: white;
            }

            .btn-modal-register:hover {
                background: #218838;
                color: white;
                text-decoration: none;
            }

            .btn-modal-cancel {
                background: #6c757d;
                color: white;
            }

            .btn-modal-cancel:hover {
                background: #545b62;
                color: white;
            }

            /* ===== SUCCESS NOTIFICATION ===== */
            .success-toast {
                position: fixed;
                top: 100px;
                right: 20px;
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                color: white;
                padding: 15px 20px;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                z-index: 9999;
                transform: translateX(400px);
                transition: all 0.3s ease;
                max-width: 350px;
                display: none;
            }

            .success-toast.show {
                display: block;
                transform: translateX(0);
            }

            .toast-content {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .toast-icon {
                font-size: 1.2rem;
            }

            .toast-text {
                flex: 1;
                font-weight: 600;
            }

            .toast-close {
                background: none;
                border: none;
                color: white;
                font-size: 1.2rem;
                cursor: pointer;
                padding: 0;
                margin-left: 10px;
            }
        </style>
    </head>
    <body>

        <!-- Include Header -->
        <%@ include file="header.jsp" %>

        <!-- Include Banner -->
        <%@ include file="banner.jsp" %>

        <!-- Main Layout -->
        <div class="container mt-4">
            <div class="row">

                <!-- ===== SIDEBAR ===== -->
                <div class="col-3">
                    <div class="sidebar">
                        <div class="sidebar-header">
                            <h5 class="mb-0">
                                <i class="fas fa-filter me-2"></i>BỘ LỌC SẢN PHẨM
                            </h5>
                        </div>

                        <div class="sidebar-content">
                            <!-- Danh mục sản phẩm -->
                            <div class="category-section">
                                <h6><i class="fas fa-list me-2"></i>DANH MỤC</h6>
                                <%
                                    String currentAction = request.getParameter("action");
                                    String currentCategoryId = request.getParameter("categoryId");
                                    List<model.CategoryDTO> categoryList = (List<model.CategoryDTO>) request.getAttribute("categories");
                                %>

                                <!-- Tất cả sản phẩm -->
                                <a href="MainController?action=home"
                                   class="category-link <%= (currentCategoryId == null || currentCategoryId.trim().isEmpty()) ? "active" : "" %>">
                                    <i class="fas fa-box-open"></i> Tất cả sản phẩm
                                </a>

                                <%
                                    if (categoryList != null) {
                                        for (model.CategoryDTO cat : categoryList) {
                                            String catIdStr = String.valueOf(cat.getCategoryID());
                                            boolean isActive = catIdStr.equals(currentCategoryId);

                                            String icon = "";
                                            String name = cat.getCategoryName();
                                            if (name.equalsIgnoreCase("Whey Protein")) {
                                                icon = "fas fa-dumbbell";
                                            } else if (name.equalsIgnoreCase("Protein")) {
                                                icon = "fas fa-seedling";
                                            } else if (name.equalsIgnoreCase("Sức Mạnh & Sức Bền")) {
                                                icon = "fas fa-bolt";
                                            } else if (name.equalsIgnoreCase("Hỗ Trợ Giảm Mỡ")) {
                                                icon = "fas fa-fire";
                                            } else if (name.equalsIgnoreCase("Vitamin & Khoáng Chất")) {
                                                icon = "fas fa-pills";
                                            } else {
                                                icon = "fas fa-circle";
                                            }
                                %>
                                <a href="MainController?action=filterByCategory&categoryId=<%= cat.getCategoryID() %>" 
                                   class="category-link <%= isActive ? "active" : "" %>">
                                    <i class="<%= icon %>"></i> <%= cat.getCategoryName() %>
                                </a>
                                <%
                                        }
                                    } else {
                                %>
                                <div class="text-muted">Không có danh mục nào</div>
                                <%
                                    }
                                %>
                            </div>

                            <!-- Lọc theo giá -->
                            <div class="category-section">
                                <h6><i class="fas fa-money-bill-wave me-2"></i>LỌC THEO GIÁ</h6>
                                <form action="MainController" method="get" class="price-filter" id="priceFilterForm">
                                    <input type="hidden" name="action" value="filterByPrice"/>
                                    <%
                                        String currentPriceRange = request.getParameter("priceRange");
                                    %>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="priceRange" value="0-500000" id="price1" <%= "0-500000".equals(currentPriceRange) ? "checked" : "" %>>
                                        <label class="form-check-label" for="price1">
                                            Dưới 500.000₫
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="priceRange" value="500000-1000000" id="price2" <%= "500000-1000000".equals(currentPriceRange) ? "checked" : "" %>>
                                        <label class="form-check-label" for="price2">
                                            500.000₫ - 1.000.000₫
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="priceRange" value="1000000-1500000" id="price3" <%= "1000000-1500000".equals(currentPriceRange) ? "checked" : "" %>>
                                        <label class="form-check-label" for="price3">
                                            1.000.000₫ - 1.500.000₫
                                        </label>
                                    </div>
                                    <div class="form-check mb-3">
                                        <input class="form-check-input" type="radio" name="priceRange" value="1500000-99999999" id="price4" <%= "1500000-99999999".equals(currentPriceRange) ? "checked" : "" %>>
                                        <label class="form-check-label" for="price4">
                                            Trên 1.500.000₫
                                        </label>
                                    </div>
                                    <button type="submit" class="btn filter-btn w-100" id="priceFilterBtn">
                                        <i class="fas fa-search me-2"></i>Áp dụng bộ lọc
                                    </button>
                                </form>
                            </div>

                            <!-- Lọc theo thương hiệu -->
                            <div class="category-section">
                                <h6><i class="fas fa-tags me-2"></i>THƯƠNG HIỆU</h6>
                                <%
                                    String currentBrand = request.getParameter("brand");
                                %>
                                <a href="MainController?action=filterByBrand&brand=PVL" class="category-link <%= "PVL".equals(currentBrand) ? "active" : "" %>">
                                    <i class="fas fa-star"></i>PVL
                                </a>
                                <a href="MainController?action=filterByBrand&brand=GHOST" class="category-link <%= "GHOST".equals(currentBrand) ? "active" : "" %>">
                                    <i class="fas fa-star"></i>GHOST LIFESTYLE
                                </a>
                                <a href="MainController?action=filterByBrand&brand=Rule One" class="category-link <%= "Rule One".equals(currentBrand) ? "active" : "" %>">
                                    <i class="fas fa-star"></i>Rule One Protein
                                </a>
                                <a href="MainController?action=filterByBrand&brand=Nutrabolics" class="category-link <%= "Nutrabolics".equals(currentBrand) ? "active" : "" %>">
                                    <i class="fas fa-star"></i>Nutrabolics
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ===== MAIN CONTENT - Sản phẩm ===== -->
                <div class="col-9">
                    <div class="main-content">
                        <!-- Search Results Info -->
                        <%
                            String searchKeyword = (String) request.getAttribute("searchKeyword");
                            if (searchKeyword != null && !searchKeyword.isEmpty()) {
                        %>
                        <div class="search-info">
                            <i class="fas fa-search"></i>
                            Kết quả tìm kiếm cho: "<strong><%= searchKeyword %></strong>"
                            <%
                                List<ProductDTO> products = (List<ProductDTO>) request.getAttribute("products");
                                if (products != null && !products.isEmpty()) {
                                    out.print(" - Tìm thấy " + products.size() + " sản phẩm");
                                }
                            %>
                        </div>
                        <%
                            }
                        %>

                        <h4 class="products-header">
                            <i class="fas fa-star text-warning me-2"></i>
                            <%
                                if (pageTitle != null && !pageTitle.isEmpty()) {
                                    out.print(pageTitle);
                                } else {
                                    out.print("Sản phẩm nổi bật");
                                }
                            %>
                        </h4>

                        <!-- Debug Information -->
                        <%
                            List<ProductDTO> products = (List<ProductDTO>) request.getAttribute("products");
                            if (products != null) {
                                out.println("<!-- DEBUG: Found " + products.size() + " products -->");
                            } else {
                                out.println("<!-- DEBUG: Products list is null -->");
                            }
                        %>

                        <div class="row">
                            <%
                                if (products != null && !products.isEmpty()) {
                                    // Hiển thị sản phẩm từ database
                                    for (ProductDTO p : products) {
                            %>
                            <div class="col-3 mb-4">
                                <div class="card product-card">
                                    <!-- FIX 3: ✅ FIXED - Enhanced image handling with better error management -->
                                    <%
                                        String contextPath = request.getContextPath();
                                        String imageName = p.getImage();
                                        String imagePath = null;
                                        boolean hasValidImage = false;
                                        
                                        // Enhanced image path logic
                                        if (imageName != null && !imageName.trim().isEmpty()) {
                                            if (imageName.startsWith("http://") || imageName.startsWith("https://")) {
                                                // External URL
                                                imagePath = imageName;
                                                hasValidImage = true;
                                            } else if (imageName.startsWith("/") || imageName.startsWith("assets/")) {
                                                // Relative path
                                                imagePath = contextPath + (imageName.startsWith("/") ? imageName : "/assets/images/products/" + imageName);
                                                hasValidImage = true;
                                            } else {
                                                // Filename only
                                                imagePath = contextPath + "/assets/images/products/" + imageName;
                                                hasValidImage = true;
                                            }
                                        }
                                    %>
                                    
                                    <div class="product-image-container">
                                        <% if (hasValidImage) { %>
                                            <img src="<%= imagePath %>"
                                                 class="product-image"
                                                 alt="<%= p.getName() %>"
                                                 loading="lazy"
                                                 onerror="handleImageError(this, '<%= p.getName() %>', '<%= p.getBrand() != null ? p.getBrand() : "" %>')">
                                        <% } else { %>
                                            <div class="product-image-placeholder">
                                                <i class="fas fa-image"></i>
                                                <div><%= p.getBrand() != null ? p.getBrand() : "Product" %></div>
                                                <small><%= p.getFormattedPrice() %></small>
                                            </div>
                                        <% } %>
                                    </div>

                                    <div class="product-info">
                                        <%
                                            if (p.getBrand() != null && !p.getBrand().trim().isEmpty()) {
                                        %>
                                        <div class="product-brand"><%= p.getBrand() %></div>
                                        <%
                                            }
                                        %>
                                        <h5 class="product-title"><%= p.getName() %></h5>
                                        <div class="product-price">
                                            <%
                                                if (p.getPrice() > 0) {
                                                    out.print(p.getFormattedPrice());
                                                } else {
                                                    out.print("Liên hệ");
                                                }
                                            %>
                                        </div>
                                        
                                        <!-- ✅ FIXED: Product actions with favorite button -->
                                        <div class="product-actions">
                                            <a href="MainController?action=productDetail&id=<%= p.getId() %>" 
                                               class="product-btn">
                                                <i class="fas fa-eye me-2"></i>Xem chi tiết
                                            </a>
                                            
                                            <%
                                                // Kiểm tra nếu user đã đăng nhập
                                                UserDTO currentUserCheck = null;
                                                try {
                                                    currentUserCheck = AuthUtils.getCurrentUser(request);
                                                } catch (Exception e) {
                                                    // Handle exception silently
                                                }
                                                
                                                if (currentUserCheck != null) {
                                                    // User đã đăng nhập - FIXED: Use AJAX for add to cart
                                            %>
                                            <button type="button" 
                                                    class="btn-cart add-to-cart-btn" 
                                                    data-product-id="<%= p.getId() %>"
                                                    data-product-name="<%= p.getName() %>">
                                                <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                            </button>
                                            
                                            <!-- ✅ FIXED: Favorite Button -->
                                            <form action="FavoriteController" method="post" style="margin-top: 8px;">
                                                <input type="hidden" name="action" value="toggleFavorite">
                                                <input type="hidden" name="productID" value="<%= p.getId() %>">
                                                <button type="submit" class="btn-favorite">
                                                    <i class="fas fa-heart me-1"></i>Yêu thích
                                                </button>
                                            </form>
                                            <%
                                                } else {
                                                    // User chưa đăng nhập - hiển thị button với onclick
                                            %>
                                            <button type="button" class="btn-cart" onclick="showLoginNotification()">
                                                <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                            </button>
                                            
                                            <button type="button" class="btn-favorite" onclick="showLoginNotification()" style="margin-top: 8px;">
                                                <i class="fas fa-heart me-1"></i>Yêu thích
                                            </button>
                                            <%
                                                }
                                            %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                                    }
                                } else {
                                    // Kiểm tra nếu đang có tìm kiếm/filter mà không có kết quả
                                    String action = request.getParameter("action");
                                    boolean isSearching = (action != null && (action.contains("search") || action.contains("filter"))) || searchKeyword != null;
                            
                                    if (isSearching) {
                            %>
                            <!-- Empty state khi tìm kiếm không có kết quả -->
                            <div class="col-12">
                                <div class="empty-state">
                                    <i class="fas fa-search"></i>
                                    <h3>Không tìm thấy sản phẩm</h3>
                                    <p>
                                        <%
                                            if (searchKeyword != null && !searchKeyword.isEmpty()) {
                                                out.print("Không có sản phẩm nào khớp với từ khóa \"<strong>" + searchKeyword + "</strong>\"");
                                            } else {
                                                out.print("Không có sản phẩm nào trong danh mục này");
                                            }
                                        %>
                                    </p>
                                    <a href="MainController?action=home" class="btn">
                                        <i class="fas fa-home me-2"></i>Về trang chủ
                                    </a>
                                </div>
                            </div>
                            <%
                                    } else {
                                        // Hiển thị sản phẩm demo khi không có data và không phải tìm kiếm
                            %>
                            <div class="col-12">
                                <div class="empty-state">
                                    <i class="fas fa-box-open"></i>
                                    <h3>Chưa có sản phẩm nào</h3>
                                    <p>Hệ thống đang cập nhật sản phẩm. Vui lòng quay lại sau!</p>
                                    <%
                                        // Kiểm tra nếu user là admin thì hiển thị link thêm sản phẩm
                                        UserDTO adminCheck = null;
                                        try {
                                            adminCheck = AuthUtils.getCurrentUser(request);
                                            if (adminCheck != null && AuthUtils.isAdmin(request)) {
                                    %>
                                    <a href="productForm.jsp" class="btn">
                                        <i class="fas fa-plus me-2"></i>Thêm sản phẩm đầu tiên
                                    </a>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            // Handle exception silently
                                        }
                                    %>
                                </div>
                            </div>
                            <%
                                    }
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Login Notification Modal -->
        <div class="modal-overlay" id="modalOverlay" onclick="hideLoginNotification()"></div>
        <div class="login-modal" id="loginModal">
            <div class="modal-icon">
                <i class="fas fa-sign-in-alt"></i>
            </div>
            <div class="modal-title">Cần đăng nhập</div>
            <div class="modal-text">
                Bạn cần đăng nhập hoặc tạo tài khoản để thực hiện chức năng này.
            </div>
            <div class="modal-actions">
                <a href="login.jsp" class="modal-btn btn-modal-login">Đăng nhập</a>
                <a href="register.jsp" class="modal-btn btn-modal-register">Đăng ký</a>
                <button class="modal-btn btn-modal-cancel" onclick="hideLoginNotification()">Đóng</button>
            </div>
        </div>

        <!-- Success Toast Notification -->
        <div class="success-toast" id="successToast">
            <div class="toast-content">
                <i class="fas fa-check-circle toast-icon"></i>
                <div class="toast-text" id="toastText">Thêm sản phẩm thành công!</div>
                <button class="toast-close" onclick="hideSuccessToast()">×</button>
            </div>
        </div>

        <!-- Include Footer -->
        <%@ include file="footer.jsp" %>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Custom JavaScript -->
        <script>
            // FIX 3: ✅ FIXED - Enhanced image error handling
            function handleImageError(img, productName, productBrand) {
                console.log('🖼️ Image failed to load for product:', productName);
                
                // Create placeholder content
                const placeholder = document.createElement('div');
                placeholder.className = 'product-image-placeholder';
                placeholder.innerHTML = `
                    <i class="fas fa-image"></i>
                    <div>${productBrand || 'Product'}</div>
                    <small>Hình ảnh không có sẵn</small>
                `;
                
                // Replace image with placeholder
                img.parentNode.replaceChild(placeholder, img);
            }

            // ===== LOGIN NOTIFICATION FUNCTIONS =====
            function showLoginNotification() {
                document.getElementById('modalOverlay').style.display = 'block';
                document.getElementById('loginModal').style.display = 'block';
                document.body.style.overflow = 'hidden'; // Prevent scrolling
            }

            function hideLoginNotification() {
                document.getElementById('modalOverlay').style.display = 'none';
                document.getElementById('loginModal').style.display = 'none';
                document.body.style.overflow = 'auto'; // Restore scrolling
            }

            // ===== SUCCESS TOAST FUNCTIONS =====
            function showSuccessToast(message) {
                const toast = document.getElementById('successToast');
                const toastText = document.getElementById('toastText');
                
                toastText.textContent = message || 'Thao tác thành công!';
                toast.classList.add('show');
                
                // Auto hide after 3 seconds
                setTimeout(() => {
                    hideSuccessToast();
                }, 3000);
            }

            function hideSuccessToast() {
                const toast = document.getElementById('successToast');
                toast.classList.remove('show');
            }

            // ===== PAGE INITIALIZATION =====
            document.addEventListener('DOMContentLoaded', function () {
                console.log('✅ Index page loaded successfully with favorite functionality!');

                // FIXED: Price filter form submission
                const priceFilterForm = document.getElementById('priceFilterForm');
                const priceFilterBtn = document.getElementById('priceFilterBtn');

                if (priceFilterForm && priceFilterBtn) {
                    priceFilterForm.addEventListener('submit', function (e) {
                        // Show loading state
                        const originalText = priceFilterBtn.innerHTML;
                        priceFilterBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang lọc...';
                        priceFilterBtn.disabled = true;

                        // Check if any price range is selected
                        const selectedPrice = priceFilterForm.querySelector('input[name="priceRange"]:checked');
                        if (!selectedPrice) {
                            e.preventDefault();
                            alert('Vui lòng chọn một khoảng giá để lọc!');
                            priceFilterBtn.innerHTML = originalText;
                            priceFilterBtn.disabled = false;
                            return false;
                        }

                        console.log('✅ Price filter submitted with range:', selectedPrice.value);
                    });

                    // Auto-submit when radio button changes
                    const priceInputs = priceFilterForm.querySelectorAll('input[name="priceRange"]');
                    priceInputs.forEach(input => {
                        input.addEventListener('change', function () {
                            console.log('🔄 Price range changed to:', this.value);
                            // Auto-submit after short delay
                            setTimeout(() => {
                                priceFilterForm.submit();
                            }, 300);
                        });
                    });
                }

                // ===== FIXED: ADD TO CART HANDLING WITH AJAX =====
                const cartButtons = document.querySelectorAll('.add-to-cart-btn');
                cartButtons.forEach(button => {
                    button.addEventListener('click', function() {
                        const productId = this.getAttribute('data-product-id');
                        const productName = this.getAttribute('data-product-name');
                        const originalText = this.innerHTML;
                        
                        // Show loading state
                        this.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang thêm...';
                        this.disabled = true;
                        
                        // Create form data
                        const formData = new FormData();
                        formData.append('action', 'add');
                        formData.append('productID', productId);
                        formData.append('qty', '1');
                        
                        console.log('🛒 Adding product to cart:', productId);
                        
                        // Submit via AJAX
                        fetch('<%= request.getContextPath() %>/CartController', {
                            method: 'POST',
                            headers: {
                                'X-Requested-With': 'XMLHttpRequest'
                            },
                            body: formData
                        })
                        .then(response => {
                            if (response.ok) {
                                return response.json();
                            } else {
                                throw new Error('Network response was not ok');
                            }
                        })
                        .then(data => {
                            if (data.success) {
                                // Show success notification
                                showSuccessToast('Đã thêm "' + productName + '" vào giỏ hàng!');
                                
                                // Update cart icon if exists in header
                                if (typeof updateCartIcon === 'function') {
                                    updateCartIcon();
                                }
                                
                                // Show success state
                                this.innerHTML = '<i class="fas fa-check me-2"></i>Đã thêm!';
                                this.classList.remove('btn-cart');
                                this.classList.add('btn-success');
                                
                                // Reset after 2 seconds
                                setTimeout(() => {
                                    this.innerHTML = originalText;
                                    this.classList.remove('btn-success');
                                    this.classList.add('btn-cart');
                                    this.disabled = false;
                                }, 2000);
                                
                                console.log('✅ Product added to cart successfully');
                            } else {
                                throw new Error(data.message || 'Add to cart failed');
                            }
                        })
                        .catch(error => {
                            console.error('❌ Error adding to cart:', error);
                            
                            // Check if user needs to login
                            if (error.message && error.message.includes('login')) {
                                showLoginNotification();
                            } else {
                                alert('Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng!');
                            }
                            
                            // Reset button
                            this.innerHTML = originalText;
                            this.disabled = false;
                        });
                    });
                });

                // ===== FAVORITE FORM HANDLING =====
                const favoriteForms = document.querySelectorAll('form[action="FavoriteController"]');
                favoriteForms.forEach(form => {
                    form.addEventListener('submit', function(e) {
                        const submitBtn = this.querySelector('button[type="submit"]');
                        const originalText = submitBtn.innerHTML;
                        
                        // Show loading state
                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
                        submitBtn.disabled = true;
                        
                        // Reset button if form submission takes too long
                        setTimeout(() => {
                            if (submitBtn.disabled) {
                                submitBtn.innerHTML = originalText;
                                submitBtn.disabled = false;
                            }
                        }, 5000);
                    });
                });

                // Smooth hover effects for product cards
                const cards = document.querySelectorAll('.product-card');
                cards.forEach(card => {
                    card.addEventListener('mouseenter', function () {
                        this.style.transform = 'translateY(-5px)';
                    });

                    card.addEventListener('mouseleave', function () {
                        this.style.transform = 'translateY(0)';
                    });
                });

                // Auto-scroll to products when filters are applied
                if (window.location.search.includes('action=filter') ||
                        window.location.search.includes('categoryId') ||
                        window.location.search.includes('priceRange') ||
                        window.location.search.includes('brand')) {
                    setTimeout(() => {
                        const mainContent = document.querySelector('.col-9');
                        if (mainContent) {
                            mainContent.scrollIntoView({
                                behavior: 'smooth',
                                block: 'start'
                            });
                        }
                    }, 100);
                }

                // Search form validation (for header search)
                const searchForms = document.querySelectorAll('form[role="search"]');
                searchForms.forEach(form => {
                    form.addEventListener('submit', function (e) {
                        const keyword = this.querySelector('input[name="q"]') || this.querySelector('input[name="keyword"]');
                        if (keyword && keyword.value.trim().length < 2) {
                            e.preventDefault();
                            alert('Vui lòng nhập ít nhất 2 ký tự để tìm kiếm');
                            keyword.focus();
                            return false;
                        }
                    });
                });

                // Close modal when pressing Escape
                document.addEventListener('keydown', function(e) {
                    if (e.key === 'Escape') {
                        hideLoginNotification();
                    }
                });

                // FIX 3: ✅ FIXED - Enhanced image lazy loading with error handling
                const images = document.querySelectorAll('.product-image');
                const imageObserver = new IntersectionObserver((entries, observer) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            const img = entry.target;
                            img.classList.add('loaded');
                            
                            // Add error handling for lazy loaded images
                            img.addEventListener('error', function() {
                                const productName = this.alt || 'Unknown Product';
                                const productBrand = this.closest('.product-card')?.querySelector('.product-brand')?.textContent || '';
                                handleImageError(this, productName, productBrand);
                            });
                            
                            observer.unobserve(img);
                        }
                    });
                });

                images.forEach(img => {
                    imageObserver.observe(img);
                });

                console.log('🖼️ Image handling system initialized with error recovery');
                console.log('❤️ Favorite functionality initialized');
                console.log('🛒 Cart functionality initialized');
            });

            // ===== UTILITY FUNCTIONS =====
            function updateCartIcon() {
                // Function to update cart icon in header (if exists)
                // This will be called after successful add to cart
                const cartBadge = document.getElementById('cartBadge');
                if (cartBadge) {
                    let currentCount = parseInt(cartBadge.textContent) || 0;
                    cartBadge.textContent = currentCount + 1;
                    
                    // Add animation
                    cartBadge.style.transform = 'scale(1.3)';
                    setTimeout(() => {
                        cartBadge.style.transform = 'scale(1)';
                    }, 200);
                } else {
                    // Create badge if it doesn't exist
                    const cartButton = document.getElementById('cartButton');
                    if (cartButton) {
                        const badge = document.createElement('span');
                        badge.className = 'cart-badge';
                        badge.id = 'cartBadge';
                        badge.textContent = '1';
                        cartButton.appendChild(badge);
                    }
                }
            }

            // ===== DEMO FUNCTION =====
            function showUpdateMessage() {
                alert('Hệ thống đang cập nhật sản phẩm. Hiện chưa có sản phẩm nào.');
                return false;
            }
        </script>

    </body>
</html>
                                     {
                background-color: transparent !important;
                border: 2px solid #e91e63 !important;
                color: #e91e63 !important;
                font-size: 13px;
                padding: 8px 12px;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s ease;
                width: 100%;
                text-align: center;
                text-decoration: none;
                display: inline-block;
            }

            .btn-favorite