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
                    out.print(pageTitle + " - WheyStore");
                } else {
                    out.print("Trang chủ - WheyStore");
                }
            %>
        </title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            /* ===== SIDEBAR STYLES - Gọn gàng, rõ ràng ===== */
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

            .filter-btn:disabled {
                background: #6c757d;
                transform: none;
                cursor: not-allowed;
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

            /* ===== PRODUCT CARD STYLES ===== */
            .product-card {
                border: 1px solid #e9ecef;
                border-radius: 12px;
                transition: all 0.3s ease;
                overflow: hidden;
                height: 100%;
            }

            .product-card:hover {
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
                transform: translateY(-5px);
            }

            .product-image {
                height: 200px;
                object-fit: cover;
                width: 100%;
                background-color: #f8f9fa;
            }

            .product-info {
                padding: 15px;
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

            .product-btn {
                background-color: #b02a20;
                color: white;
                border: none;
                border-radius: 8px;
                padding: 8px 16px;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s ease;
                display: inline-block;
                width: 100%;
                text-align: center;
            }

            .product-btn:hover {
                background-color: #8b1e16;
                color: white;
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

            /* ===== RESPONSIVE ===== */
            @media (max-width: 768px) {
                .sidebar {
                    margin-bottom: 20px;
                }

                .main-content {
                    padding: 15px;
                }
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

                <!-- ===== SIDEBAR - Gọn gàng, rõ ràng ===== -->
                <div class="col-lg-3 col-md-4">
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
                                            } else if (name.equalsIgnoreCase("Creatine")) {
                                                icon = "fas fa-bolt";
                                            } else if (name.equalsIgnoreCase("Vitamin & Khoáng Chất")) {
                                                icon = "fas fa-pills";
                                            } else if (name.equalsIgnoreCase("Hỗ Trợ Giảm Mỡ")) {
                                                icon = "fas fa-fire";
                                            } else if (name.equalsIgnoreCase("Sinh lý & Nội tiết tố")) {
                                                icon = "fas fa-heartbeat";
                                            } else {
                                                icon = "fas fa-circle"; // default icon
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

                            <!-- Lọc theo giá - FIXED -->
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
                                        <input class="form-check-input" type="radio" name="priceRange" value="1500000-99999999" id="price4" <%= "1500000- 99999999 ".equals(currentPriceRange) ? "checked" : "" %>>
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
                                <a href="MainController?action=filterByBrand&brand=Optimum" class="category-link <%= "Optimum".equals(currentBrand) ? "active" : "" %>">
                                    <i class="fas fa-star"></i>Optimum Nutrition
                                </a>
                                <a href="MainController?action=filterByBrand&brand=MuscleTech" class="category-link <%= "MuscleTech".equals(currentBrand) ? "active" : "" %>">
                                    <i class="fas fa-star"></i>MuscleTech
                                </a>
                                <a href="MainController?action=filterByBrand&brand=Dymatize" class="category-link <%= "Dymatize".equals(currentBrand) ? "active" : "" %>">
                                    <i class="fas fa-star"></i>Dymatize
                                </a>
                                <a href="MainController?action=filterByBrand&brand=BSN" class="category-link <%= "BSN".equals(currentBrand) ? "active" : "" %>">
                                    <i class="fas fa-star"></i>BSN
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ===== MAIN CONTENT - Sản phẩm ===== -->
                <div class="col-lg-9 col-md-8">
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
                            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                                <div class="card product-card">
                                    <%
                                        String imagePath = (p.getImage() != null && !p.getImage().trim().isEmpty()) 
                                                         ? "assets/images/" + p.getImage() 
                                                         : "https://via.placeholder.com/300x200/f8f9fa/6c757d?text=No+Image";
                                    %>
                                    <img src="<%= imagePath %>" class="product-image" alt="<%= p.getName() %>"
                                         onerror="this.src='https://via.placeholder.com/300x200/f8f9fa/6c757d?text=No+Image'">

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
                                        <a href="MainController?action=productDetail&id=<%= p.getId() %>" 
                                           class="btn product-btn">
                                            <i class="fas fa-eye me-2"></i>Xem chi tiết
                                        </a>
                                        <form action="MainController" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="productID" value="<%= p.getId() %>">
                                            <input type="hidden" name="qty" value="1">
                                            <button class="btn btn-sm btn-outline-primary">Thêm vào giỏ hàng</button>
                                        </form>
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
                            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                                <div class="card product-card">
                                    <img src="https://via.placeholder.com/300x200/667eea/ffffff?text=PVL+ISO+Gold" 
                                         class="product-image" alt="PVL ISO Gold">
                                    <div class="product-info">
                                        <div class="product-brand">PVL - Canada</div>
                                        <h5 class="product-title">PVL ISO Gold - Premium Whey Protein With Probiotic</h5>
                                        <div class="product-price">2.350.000 ₫</div>
                                        <a href="#" onclick="showUpdateMessage()" class="btn product-btn">
                                            <i class="fas fa-eye me-2"></i>Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                                <div class="card product-card">
                                    <img src="https://via.placeholder.com/300x200/28a745/ffffff?text=GHOST+Whey" 
                                         class="product-image" alt="GHOST Whey Protein">
                                    <div class="product-info">
                                        <div class="product-brand">GHOST LIFESTYLE</div>
                                        <h5 class="product-title">GHOST Whey Protein</h5>
                                        <div class="product-price">1.200.000 ₫</div>
                                        <a href="#" onclick="showUpdateMessage()" class="btn product-btn">
                                            <i class="fas fa-eye me-2"></i>Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                                <div class="card product-card">
                                    <img src="https://via.placeholder.com/300x200/dc3545/ffffff?text=Rule+1+Protein" 
                                         class="product-image" alt="Rule 1 Protein">
                                    <div class="product-info">
                                        <div class="product-brand">Rule One Protein</div>
                                        <h5 class="product-title">Rule 1 Protein</h5>
                                        <div class="product-price">1.950.000 ₫</div>
                                        <a href="#" onclick="showUpdateMessage()" class="btn product-btn">
                                            <i class="fas fa-eye me-2"></i>Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                                <div class="card product-card">
                                    <img src="https://via.placeholder.com/300x200/ffc107/000000?text=Nutrabolics" 
                                         class="product-image" alt="Nutrabolics Hydropure">
                                    <div class="product-info">
                                        <div class="product-brand">Nutrabolics Nutrition</div>
                                        <h5 class="product-title">Nutrabolics Hydropure</h5>
                                        <div class="product-price">1.950.000 ₫</div>
                                        <a href="#" onclick="showUpdateMessage()" class="btn product-btn">
                                            <i class="fas fa-eye me-2"></i>Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                                <div class="card product-card">
                                    <img src="https://via.placeholder.com/300x200/6f42c1/ffffff?text=BareBells+Bar" 
                                         class="product-image" alt="BareBells Bar">
                                    <div class="product-info">
                                        <div class="product-brand">BareBells</div>
                                        <h5 class="product-title">BareBells Bar</h5>
                                        <div class="product-price">80.000 ₫</div>
                                        <a href="#" onclick="showUpdateMessage()" class="btn product-btn">
                                            <i class="fas fa-eye me-2"></i>Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                                <div class="card product-card">
                                    <img src="https://via.placeholder.com/300x200/17a2b8/ffffff?text=Ostrovit+Creatine" 
                                         class="product-image" alt="Ostrovit Creatine">
                                    <div class="product-info">
                                        <div class="product-brand">Ostrovit</div>
                                        <h5 class="product-title">Ostrovit Creatine Monohydrate</h5>
                                        <div class="product-price">650.000 ₫</div>
                                        <a href="#" onclick="showUpdateMessage()" class="btn product-btn">
                                            <i class="fas fa-eye me-2"></i>Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                                <div class="card product-card">
                                    <img src="https://via.placeholder.com/300x200/fd7e14/ffffff?text=Nutrex+Lipo+6" 
                                         class="product-image" alt="Nutrex Lipo 6">
                                    <div class="product-info">
                                        <div class="product-brand">Nutrex</div>
                                        <h5 class="product-title">Nutrex Lipo 6 Black Cleanse & Detox</h5>
                                        <div class="product-price">490.000 ₫</div>
                                        <a href="#" onclick="showUpdateMessage()" class="btn product-btn">
                                            <i class="fas fa-eye me-2"></i>Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                                <div class="card product-card">
                                    <img src="https://via.placeholder.com/300x200/e74c3c/ffffff?text=CodeAge+Hair" 
                                         class="product-image" alt="CodeAge Hair Vitamins">
                                    <div class="product-info">
                                        <div class="product-brand">Code Age</div>
                                        <h5 class="product-title">CodeAge Hair Vitamins</h5>
                                        <div class="product-price">1.550.000 ₫</div>
                                        <a href="#" onclick="showUpdateMessage()" class="btn product-btn">
                                            <i class="fas fa-eye me-2"></i>Xem chi tiết
                                        </a>
                                    </div>
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

        <!-- Include Footer -->
        <%@ include file="footer.jsp" %>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Custom JavaScript -->
        <script>
                                            function showUpdateMessage() {
                                                alert('Hệ thống đang cập nhật sản phẩm. Hiện chưa có sản phẩm nào.');
                                                return false;
                                            }

                                            document.addEventListener('DOMContentLoaded', function () {
                                                console.log('✅ Index page loaded successfully!');

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
                                                        // Form will submit normally, loading state will persist until page reloads
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

                                                // Smooth hover effects
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
                                                        document.querySelector('.col-lg-9').scrollIntoView({
                                                            behavior: 'smooth',
                                                            block: 'start'
                                                        });
                                                    }, 100);
                                                }
                                            });

                                            // Search form validation (for header search)
                                            document.addEventListener('DOMContentLoaded', function () {
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
                                            });
        </script>
        
    </body>
</html>