<%@ page pageEncoding="UTF-8" %>
<%@ page import="model.UserDTO" %>
<%@ page import="utils.AuthUtils" %>

<style>
    body {
        font-family: 'Segoe UI', sans-serif;
    }

    .navbar {
        background-color: #b02a20 !important;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .navbar-brand {
        font-size: 30px;
        font-weight: bold;
        color: white !important;
        text-decoration: none;
    }

    .navbar-brand:hover {
        color: #fff !important;
        text-decoration: none;
    }

    .search-container {
        max-width: 600px;
        margin: 0 auto;
        flex: 1;
    }

    .input-group {
        border-radius: 25px;
        overflow: hidden;
        border: 2px solid #fff;
        background-color: white;
        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
    }

    .input-group .form-control {
        border: none;
        box-shadow: none;
        font-size: 14px;
        padding: 12px 20px;
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
    }

    .input-group .btn-search:hover {
        background-color: #8b1e16;
        color: white;
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

    /* ===== RESPONSIVE ===== */
    @media (max-width: 768px) {
        .user-dropdown-menu {
            right: -10px;
            min-width: 180px;
        }

        .search-container {
            max-width: 400px;
        }
    }
</style>

<nav class="navbar navbar-expand-lg px-4 py-3">
    <div class="container-fluid d-flex align-items-center">
        <!-- Logo -->
        <a class="navbar-brand me-4" href="MainController?action=home">
            <i class="fas fa-dumbbell me-2"></i>GymLife
        </a>

        <!-- Search Form - SIMPLIFIED -->
        <form class="search-container" role="search" action="MainController" method="get">
            <input type="hidden" name="action" value="searchProduct">
            <div class="input-group">
                <input type="text" class="form-control" placeholder="Tìm kiếm sản phẩm..." name="keyword" />
                <button class="btn btn-search" type="submit">
                    <i class="fas fa-search"></i>
                </button>
            </div>
        </form>

        <!-- User Info -->
        <div class="ms-4 d-flex align-items-center">
            <%
                UserDTO currentUser = null;
                try {
                    currentUser = AuthUtils.getCurrentUser(request);
                } catch (Exception e) {
                    // Handle exception silently
                }
                
                if (currentUser != null) {
            %>

            <div class="d-flex align-items-center">
                <!-- Giỏ hàng -->
                <a href="CartController?action=view" class="btn btn-outline-light me-3">
                    <i class="fas fa-shopping-cart"></i> Giỏ hàng
                </a>

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
            </div>

            <!-- Dropdown Menu -->
            <div class="user-dropdown-menu" id="userDropdownMenu">
                <div class="dropdown-header">
                    <i class="fas fa-user-circle me-2"></i><%= currentUser.getFullName() %>
                </div>

                <%
                    try {
                        if (AuthUtils.isAdmin(request)) {
                %>
                <a href="MainController?action=listProducts" class="dropdown-item">
                    <i class="fas fa-box"></i>Quản lý sản phẩm
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

                <a href="MainController?action=logout" class="dropdown-item logout-item" onclick="return confirmLogout()">
                    <i class="fas fa-sign-out-alt"></i>Đăng xuất
                </a>
                <a href="changePassword.jsp" class="dropdown-item">
                    <i class="fas fa-key"></i>Thay đổi mật khẩu
                </a>
                <div class="dropdown-divider"></div>
            </div>
        </div>
        <%
            } else {
        %>
        <!-- Login Link -->
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
    function toggleUserDropdown() {
        const dropdown = document.getElementById('userDropdownMenu');
        dropdown.classList.toggle('show');

        // Close dropdown when clicking outside
        setTimeout(() => {
            document.addEventListener('click', closeDropdownOnClickOutside);
        }, 10);
    }

    function closeDropdownOnClickOutside(event) {
        const dropdown = document.getElementById('userDropdownMenu');
        const userInfo = document.getElementById('userInfoClick');

        if (dropdown && userInfo) {
            if (!userInfo.contains(event.target) && !dropdown.contains(event.target)) {
                dropdown.classList.remove('show');
                document.removeEventListener('click', closeDropdownOnClickOutside);
            }
        }
    }

    function confirmLogout() {
        return confirm('Bạn có chắc chắn muốn đăng xuất?');
    }

    document.addEventListener('DOMContentLoaded', function () {
        console.log('✅ Header loaded with user dropdown');

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
                const dropdown = document.getElementById('userDropdownMenu');
                if (dropdown) {
                    dropdown.classList.remove('show');
                }
            }
        });
    });
</script>