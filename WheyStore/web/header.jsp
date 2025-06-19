<%@ page pageEncoding="UTF-8" %>
<%@ page import="model.UserDTO" %>
<%@ page import="utils.AuthUtils" %>

<style>
    body {
        font-family: 'Segoe UI', sans-serif;
    }

    .navbar {
        background-color: #b02a20 !important;
    }

    .navbar-brand {
        font-size: 30px;
        font-weight: bold;
        color: white !important;
    }

    .search-container {
        max-width: 800px;
        margin: 0 auto;
        flex: 1;
    }

    .input-group {
        border-radius: 8px;
        overflow: hidden;
        border: 1px solid #ccc;
        background-color: white;
        box-shadow: 0 0 6px rgba(0, 0, 0, 0.1);
    }

    .input-group .form-select {
        max-width: 160px;
        font-weight: 500;
        border: none;
        border-right: 1px solid #ccc;
        background-color: white;
    }

    .input-group .form-control {
        border: none;
        box-shadow: none;
    }

    .input-group .btn-search {
        background-color: white;
        color: #b02a20;
        border: none;
        padding: 0 14px;
    }

    .input-group .btn-search:hover {
        background-color: #f8f8f8;
    }
</style>

<nav class="navbar navbar-expand-lg px-4 py-2">
    <div class="container-fluid d-flex align-items-center">
        <!-- Logo -->
<<<<<<< Updated upstream
       <a class="navbar-brand me-4" href="MainController?action=home" onclick="handleNavigation(this)">GymLife</a>
=======
        <a class="navbar-brand me-4" href="index_1.jsp">GymLife</a>
>>>>>>> Stashed changes

        <!-- Search Form -->
        <form class="search-container" role="search" action="MainController" method="get">

            <input type="hidden" name="action" value="searchProduct" />
=======
            <input type="hidden" name="action" value="searchProduct">

            <div class="input-group">
                <select class="form-select" name="category">
                    <option value="">Tất cả sản phẩm</option>
                    <option value="1">Whey Protein</option>
                    <option value="2">Creatine</option>
                    <option value="3">Vitamin</option>
                    <option value="4">Giảm mỡ</option>
                    <option value="5">Sinh lý</option>
                </select>


                <!-- Input -->
                <input type="text" class="form-control" placeholder="Search..." name="strKeyword" />

                <!-- Button -->

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
                <div class="dropdown">
                    <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" 
                       data-bs-toggle="dropdown" id="userDropdown">
                        <i class="fas fa-user fa-2x me-2"></i>
                        <div class="d-flex flex-column">
                            <span style="font-size: 14px;">Xin chào</span>
                            <strong style="font-size: 16px;"><%= currentUser.getFullName() %></strong>
                        </div>
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="userDropdown">
                        <li><a class="dropdown-item" href="MainController?action=viewProfile">
                            <i class="fas fa-user me-2"></i>Thông tin cá nhân</a></li>
                        <li><a class="dropdown-item" href="MainController?action=changePassword">
                            <i class="fas fa-key me-2"></i>Đổi mật khẩu</a></li>
                        <%
                            try {
                                if (AuthUtils.isAdmin(request)) {
                        %>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="MainController?action=listProducts">
                                    <i class="fas fa-box me-2"></i>Quản lý sản phẩm</a></li>
                                <li><a class="dropdown-item" href="productForm.jsp">
                                    <i class="fas fa-plus me-2"></i>Thêm sản phẩm</a></li>
                        <%
                                }
                            } catch (Exception e) {
                                // Handle exception silently
                            }
                        %>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="MainController?action=logout">
                            <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                    </ul>
                </div>
            <%
                } else {
            %>
                <a href="login.jsp" class="d-flex align-items-center text-white text-decoration-none">
                    <i class="fas fa-user fa-2x me-2"></i>
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
        <script>
function handleNavigation(element) {
    // Vô hiệu hóa link tạm thời để tránh click nhiều lần
    element.style.pointerEvents = 'none';
    element.style.opacity = '0.7';
    
    // Khôi phục sau 2 giây
    setTimeout(() => {
        element.style.pointerEvents = 'auto';
        element.style.opacity = '1';
    }, 2000);
}
</script>
</nav>