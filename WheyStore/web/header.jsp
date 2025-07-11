<%@ page pageEncoding="UTF-8" %>
<%@ page import="model.UserDTO" %>
<%@ page import="utils.AuthUtils" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.CartItemDTO" %>

<style>
    body {
        font-family: 'Segoe UI', sans-serif;
    }

    .navbar {
        background-color: #b02a20 !important;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        min-height: 70px;
    }

    .navbar-brand {
        font-size: 30px;
        font-weight: bold;
        color: white !important;
        text-decoration: none;
        flex-shrink: 0;
    }

    .navbar-brand:hover {
        color: #fff !important;
        text-decoration: none;
    }

    .search-container {
        flex: 1;
        max-width: 600px;
        margin: 0 auto;
        padding: 0 20px;
    }

    .input-group {
        border-radius: 25px;
        overflow: hidden;
        border: 2px solid #fff;
        background-color: white;
        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        width: 100%;
    }

    .input-group .form-control {
        border: none;
        box-shadow: none;
        font-size: 14px;
        padding: 12px 20px;
        flex: 1;
    }

    .input-group .form-control:focus {
        box-shadow: none;
        outline: none;
    }

    .input-group .btn-search {
        background-color: #b02a20;
        color: white;
        border: none;
        padding: 0 25px;
        transition: all 0.3s ease;
        flex-shrink: 0;
    }

    .input-group .btn-search:hover {
        background-color: #8b1e16;
        color: white;
    }

    .user-section {
        display: flex;
        align-items: center;
        gap: 15px;
        flex-shrink: 0;
        min-width: 200px;
    }

    /* ===== FAVORITE BUTTON STYLES ===== */
    .favorite-button {
        position: relative;
    }

    .favorite-link {
        color: white;
        text-decoration: none;
        cursor: pointer;
        padding: 10px 15px;
        border-radius: 12px;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        position: relative;
        background: linear-gradient(135deg, rgba(255, 255, 255, 0.15), rgba(255, 255, 255, 0.05));
        backdrop-filter: blur(10px);
        border: 2px solid rgba(255, 255, 255, 0.2);
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    }

    .favorite-link:hover {
        background: linear-gradient(135deg, rgba(255, 255, 255, 0.25), rgba(255, 255, 255, 0.15));
        border-color: rgba(255, 255, 255, 0.4);
        color: #fff;
        text-decoration: none;
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
    }

    .favorite-link i {
        color: #ff69b4;
        filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
        text-shadow: 0 0 10px rgba(255, 105, 180, 0.5);
    }

    .favorite-link:hover i {
        color: #ff1493;
        transform: scale(1.1);
        text-shadow: 0 0 15px rgba(255, 20, 147, 0.8);
    }

    /* ===== CART DROPDOWN STYLES ===== */
    .cart-dropdown {
        position: relative;
    }

    .cart-button {
        color: white;
        text-decoration: none;
        cursor: pointer;
        padding: 8px 15px;
        border-radius: 8px;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        position: relative;
        background: none;
        border: none;
    }

    .cart-button:hover {
        background-color: rgba(255, 255, 255, 0.1);
        color: white !important;
        text-decoration: none;
    }

    .cart-badge {
        position: absolute;
        top: -5px;
        right: -5px;
        background: #dc3545;
        color: white;
        border-radius: 50%;
        width: 20px;
        height: 20px;
        font-size: 11px;
        font-weight: bold;
        display: flex;
        align-items: center;
        justify-content: center;
        animation: pulse 2s infinite;
    }

    @keyframes pulse {
        0% {
            transform: scale(1);
        }
        50% {
            transform: scale(1.1);
        }
        100% {
            transform: scale(1);
        }
    }

    .cart-dropdown-menu {
        position: absolute;
        top: 100%;
        right: 0;
        background: white;
        border-radius: 10px;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        border: 1px solid #e9ecef;
        min-width: 350px;
        max-width: 400px;
        opacity: 0;
        visibility: hidden;
        transform: translateY(-10px);
        transition: all 0.3s ease;
        z-index: 1000;
        margin-top: 5px;
        max-height: 400px;
        overflow-y: auto;
    }

    .cart-dropdown-menu.show {
        opacity: 1;
        visibility: visible;
        transform: translateY(0);
    }

    .cart-header {
        padding: 15px 20px;
        background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
        color: white;
        border-radius: 10px 10px 0 0;
        font-weight: 600;
        font-size: 14px;
        border-bottom: 1px solid #e9ecef;
    }

    .cart-item {
        padding: 12px 20px;
        border-bottom: 1px solid #f8f9fa;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .cart-item:last-child {
        border-bottom: none;
    }

    .cart-item-info {
        flex: 1;
    }

    .cart-item-name {
        font-weight: 600;
        color: #333;
        font-size: 13px;
        margin-bottom: 2px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }

    .cart-item-details {
        font-size: 11px;
        color: #666;
    }

    .cart-empty {
        padding: 30px 20px;
        text-align: center;
        color: #666;
    }

    .cart-empty i {
        font-size: 2rem;
        margin-bottom: 10px;
        color: #ddd;
    }

    .cart-footer {
        padding: 15px 20px;
        background: #f8f9fa;
        border-radius: 0 0 10px 10px;
    }

    .cart-total {
        font-weight: 700;
        color: #b02a20;
        margin-bottom: 10px;
        text-align: center;
    }

    .cart-actions {
        display: flex;
        gap: 10px;
    }

    .cart-btn {
        flex: 1;
        padding: 8px 12px;
        border-radius: 6px;
        text-decoration: none;
        text-align: center;
        font-size: 12px;
        font-weight: 600;
        transition: all 0.3s ease;
    }

    .cart-btn-primary {
        background: #b02a20;
        color: white;
    }

    .cart-btn-primary:hover {
        background: #8b1e16;
        color: white;
        text-decoration: none;
    }

    .cart-btn-secondary {
        background: #6c757d;
        color: white;
    }

    .cart-btn-secondary:hover {
        background: #545b62;
        color: white;
        text-decoration: none;
    }

    /* ===== USER DROPDOWN STYLES ===== */
    .user-dropdown {
        position: relative;
    }

    .user-info {
        color: white;
        text-decoration: none;
        cursor: pointer;
        padding: 8px 12px;
        border-radius: 8px;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
    }

    .user-info:hover {
        background-color: rgba(255, 255, 255, 0.1);
        color: white !important;
        text-decoration: none;
    }

    .user-dropdown-menu {
        position: absolute;
        top: 100%;
        right: 0;
        background: white;
        border-radius: 10px;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        border: 1px solid #e9ecef;
        min-width: 200px;
        opacity: 0;
        visibility: hidden;
        transform: translateY(-10px);
        transition: all 0.3s ease;
        z-index: 1000;
        margin-top: 5px;
    }

    .user-dropdown-menu.show {
        opacity: 1;
        visibility: visible;
        transform: translateY(0);
    }

    .dropdown-header {
        padding: 12px 20px;
        background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
        color: white;
        border-radius: 10px 10px 0 0;
        font-weight: 600;
        font-size: 14px;
        border-bottom: 1px solid #e9ecef;
    }

    .dropdown-item {
        display: block;
        padding: 12px 20px;
        color: #495057;
        text-decoration: none;
        transition: all 0.3s ease;
        border: none;
        background: none;
        width: 100%;
        text-align: left;
        cursor: pointer;
        font-size: 14px;
    }

    .dropdown-item:hover {
        background-color: #f8f9fa;
        color: #b02a20;
        text-decoration: none;
    }

    .dropdown-item i {
        margin-right: 10px;
        width: 16px;
        text-align: center;
    }

    .dropdown-divider {
        height: 1px;
        background-color: #e9ecef;
        margin: 0;
    }

    .logout-item {
        color: #dc3545 !important;
        font-weight: 600;
    }

    .logout-item:hover {
        background-color: #fff5f5;
        color: #dc3545 !important;
    }
</style>

<nav class="navbar navbar-expand-lg px-4 py-3">
    <div class="container-fluid d-flex align-items-center flex-wrap">
        <!-- Logo -->
        <a class="navbar-brand me-4" href="MainController?action=home">
            <i class="fas fa-dumbbell me-2"></i>GymLife
        </a>

        <!-- Search Form -->
        <form class="search-container d-flex" role="search" action="MainController" method="get">
            <input type="hidden" name="action" value="searchProduct">
            <div class="input-group">
                <input type="text" class="form-control" placeholder="Tìm kiếm sản phẩm..." name="keyword" />
                <button class="btn btn-search" type="submit">
                    <i class="fas fa-search"></i>
                </button>
            </div>
        </form>

        <!-- User Section -->
        <div class="user-section">
            <%
                UserDTO currentUser = null;
                try {
                    currentUser = AuthUtils.getCurrentUser(request);
                } catch (Exception e) {
                    // Handle exception silently
                }
                
                if (currentUser != null) {
            %>

            <!-- Favorite Icon -->
            <div class="favorite-button">
                <a href="MainController?action=viewFavorites" class="favorite-link" title="Yêu thích">
                    <i class="fas fa-heart fa-lg"></i>
                </a>
            </div>

            <!-- Cart Dropdown -->
            <div class="cart-dropdown">
                <button class="cart-button" onclick="toggleCartDropdown()" id="cartButton">
                    <i class="fas fa-shopping-cart fa-lg"></i>
                    <%
                        Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) session.getAttribute("cart");
                        int cartCount = 0;
                        if (cart != null) {
                            for (CartItemDTO item : cart.values()) {
                                cartCount += item.getQuantity();
                            }
                        }
                        if (cartCount > 0) {
                    %>
                    <span class="cart-badge" id="cartBadge"><%= cartCount %></span>
                    <%
                        }
                    %>
                </button>

                <!-- Cart Dropdown Menu -->
                <div class="cart-dropdown-menu" id="cartDropdownMenu">
                    <div class="cart-header">
                        <i class="fas fa-shopping-cart me-2"></i>Giỏ hàng của bạn
                    </div>

                    <div id="cartItems">
                        <%
                            if (cart != null && !cart.isEmpty()) {
                                java.math.BigDecimal total = java.math.BigDecimal.ZERO;
                                for (CartItemDTO item : cart.values()) {
                                    total = total.add(item.getLineTotal());
                        %>
                        <div class="cart-item">
                            <div class="cart-item-info">
                                <div class="cart-item-name"><%= item.getProductName() %></div>
                                <div class="cart-item-details">
                                    Số lượng: <%= item.getQuantity() %> × <%= String.format("%,.0f", item.getUnitPrice()) %>₫
                                </div>
                            </div>
                            <div class="text-end">
                                <strong><%= String.format("%,.0f", item.getLineTotal()) %>₫</strong>
                            </div>
                        </div>
                        <%
                                }
                        %>
                        <div class="cart-footer">
                            <div class="cart-total">
                                Tổng cộng: <%= String.format("%,.0f", total) %>₫
                            </div>
                            <div class="cart-actions">
                                <a href="CartController?action=view" class="cart-btn cart-btn-primary">
                                    <i class="fas fa-edit me-1"></i>Chỉnh sửa giỏ hàng
                                </a>
                                <a href="OrderController?action=checkout" class="cart-btn cart-btn-secondary">
                                    <i class="fas fa-credit-card me-1"></i>Thanh toán
                                </a>
                            </div>
                        </div>
                        <%
                            } else {
                        %>
                        <div class="cart-empty">
                            <i class="fas fa-shopping-cart"></i>
                            <p>Giỏ hàng trống</p>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>

            <!-- User dropdown -->
            <div class="user-dropdown">
                <div class="user-info" onclick="toggleUserDropdown()" id="userInfoClick">
                    <i class="fas fa-user-circle fa-2x me-2"></i>
                    <div class="d-flex flex-column">
                        <span style="font-size: 14px;">Xin chào</span>
                        <strong style="font-size: 16px;"><%= currentUser.getFullName() %></strong>
                    </div>
                </div>
            </div>

            <!-- ✅ User Dropdown Menu - ĐÃ XÓA MỤC ĐÁNH GIÁ -->
            <div class="user-dropdown-menu" id="userDropdownMenu">
                <div class="dropdown-header">
                    <i class="fas fa-user-circle me-2"></i><%= currentUser.getFullName() %>
                </div>

                <%
                    try {
                        if (AuthUtils.isAdmin(request)) {
                %>
                <a href="ProductController?action=adminDashboard" class="dropdown-item">
                    <i class="fas fa-tachometer-alt"></i>Dashboard Admin
                </a>

                <a href="productForm.jsp" class="dropdown-item">
                    <i class="fas fa-plus"></i>Thêm sản phẩm
                </a>
                <div class="dropdown-divider"></div>
                <%
                        }
                    } catch (Exception e) {
                        // Handle exception silently
                    }
                %>

                <!-- ✅ Lịch sử đơn hàng -->
                <a href="OrderController?action=viewOrders" class="dropdown-item">
                    <i class="fas fa-box me-2"></i>Lịch sử đơn hàng            
                </a> 

                <!-- ❌ ĐÃ XÓA: Mục đánh giá sản phẩm -->

                <a href="changePassword.jsp" class="dropdown-item">
                    <i class="fas fa-key"></i>Thay đổi mật khẩu
                </a>
                <a href="MainController?action=logout" class="dropdown-item logout-item" onclick="return confirmLogout()">
                    <i class="fas fa-sign-out-alt"></i>Đăng xuất
                </a>
                <div class="dropdown-divider"></div>
            </div>

            <%
                } else {
            %>
            <!-- Login Link for Guest Users -->
            <a href="login.jsp" class="user-info">
                <i class="fas fa-user-circle fa-2x me-2"></i>
                <div class="d-flex flex-column">
                    <span style="font-size: 14px;">Đăng nhập</span>
                    <strong style="font-size: 16px;">Tài khoản</strong>
                </div>
            </a>
            <%
                }
            %>
        </div>
    </div>
</nav>

<script>
    // Global variables
    let cartDropdownOpen = false;
    let userDropdownOpen = false;

    // Toggle cart dropdown
    function toggleCartDropdown() {
        const dropdown = document.getElementById('cartDropdownMenu');
        const userDropdown = document.getElementById('userDropdownMenu');

        // Close user dropdown if open
        if (userDropdownOpen) {
            userDropdown.classList.remove('show');
            userDropdownOpen = false;
        }

        cartDropdownOpen = !cartDropdownOpen;
        dropdown.classList.toggle('show', cartDropdownOpen);

        if (cartDropdownOpen) {
            setTimeout(() => {
                document.addEventListener('click', closeCartDropdownOnClickOutside);
            }, 10);
        }
    }

    // Toggle user dropdown
    function toggleUserDropdown() {
        const dropdown = document.getElementById('userDropdownMenu');
        const cartDropdown = document.getElementById('cartDropdownMenu');

        // Close cart dropdown if open
        if (cartDropdownOpen) {
            cartDropdown.classList.remove('show');
            cartDropdownOpen = false;
        }

        userDropdownOpen = !userDropdownOpen;
        dropdown.classList.toggle('show', userDropdownOpen);

        if (userDropdownOpen) {
            setTimeout(() => {
                document.addEventListener('click', closeUserDropdownOnClickOutside);
            }, 10);
        }
    }

    // Close cart dropdown when clicking outside
    function closeCartDropdownOnClickOutside(event) {
        const dropdown = document.getElementById('cartDropdownMenu');
        const cartButton = document.getElementById('cartButton');

        if (dropdown && cartButton) {
            if (!cartButton.contains(event.target) && !dropdown.contains(event.target)) {
                dropdown.classList.remove('show');
                cartDropdownOpen = false;
                document.removeEventListener('click', closeCartDropdownOnClickOutside);
            }
        }
    }

    // Close user dropdown when clicking outside
    function closeUserDropdownOnClickOutside(event) {
        const dropdown = document.getElementById('userDropdownMenu');
        const userInfo = document.getElementById('userInfoClick');

        if (dropdown && userInfo) {
            if (!userInfo.contains(event.target) && !dropdown.contains(event.target)) {
                dropdown.classList.remove('show');
                userDropdownOpen = false;
                document.removeEventListener('click', closeUserDropdownOnClickOutside);
            }
        }
    }

    function confirmLogout() {
        return confirm('Bạn có chắc chắn muốn đăng xuất?');
    }

    document.addEventListener('DOMContentLoaded', function () {
        console.log('✅ Header loaded with complete cart dropdown fix');

        // Search form validation
        const searchForm = document.querySelector('form[role="search"]');
        if (searchForm) {
            searchForm.addEventListener('submit', function (e) {
                const keyword = this.querySelector('input[name="keyword"]');
                if (keyword && keyword.value.trim().length < 2) {
                    e.preventDefault();
                    alert('Vui lòng nhập ít nhất 2 ký tự để tìm kiếm');
                    keyword.focus();
                    return false;
                }
            });
        }

        // Close dropdown when pressing Escape
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') {
                const cartDropdown = document.getElementById('cartDropdownMenu');
                const userDropdown = document.getElementById('userDropdownMenu');
                if (cartDropdown) {
                    cartDropdown.classList.remove('show');
                    cartDropdownOpen = false;
                }
                if (userDropdown) {
                    userDropdown.classList.remove('show');
                    userDropdownOpen = false;
                }
            }
        });
    });

    // GLOBAL: Update cart icon function (called from index.jsp)
    function updateCartIcon() {
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
</script>