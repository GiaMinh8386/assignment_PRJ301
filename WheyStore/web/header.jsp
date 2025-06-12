

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- Bootstrap 5 CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    body {
        font-family: 'Segoe UI', sans-serif;
    }

    .navbar {
        background-color: #b02a20;
    }

    .navbar-brand {
        font-size: 30px;
        font-weight: bold;
        color: white;
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

    .input-group .form-control:focus {
        box-shadow: none;
    }

    .input-group .btn-search {
        background-color: white;
        color: #b02a20;
        border: none;
        padding: 0 14px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .input-group .btn-search i {
        color: #b02a20;
    }

    .input-group .btn-search:hover {
        background-color: #f8f8f8;
    }

    .nav-link-login {
        font-weight: bold;
        color: white !important;
    }

    .nav-link-login:hover {
        text-decoration: underline;
    }
</style>

<nav class="navbar navbar-expand-lg px-4 py-2">
    <div class="container-fluid d-flex align-items-center">
        <!-- Logo -->
        <a class="navbar-brand me-4" href="home.jsp">GymLife</a>

        <!-- Search Form -->
        <form class="search-container" role="search" action="search.jsp" method="get">
            <div class="input-group">
                <!-- Dropdown -->
                <select class="form-select" name="category">
                    <option value="">Product</option>
                    <option value="whey">Whey Protein</option>
                    <option value="creatine">Creatine</option>
                    <option value="vitamin">Vitamin</option>
                    <option value="dotmo">Reduce Fat</option>
                    <option value="sinhly">Physiology-Endocrinology</option>
                </select>

                <!-- Input -->
                <input type="text" class="form-control" placeholder="Search..." name="q" />

                <!-- Button -->
                <button class="btn btn-search" type="submit">
                    <i class="fas fa-search"></i>
                </button>
            </div>
        </form>

        <!-- Login -->
        <!-- Login Block -->
        <div class="ms-4 d-flex align-items-center">
            <a href="login.jsp" class="d-flex align-items-center text-white text-decoration-none">
                <i class="fas fa-user fa-2x me-2"></i>
                <div class="d-flex flex-column">
                    <span style="font-size: 14px;">Login</span>
                    <strong style="font-size: 16px;">Account</strong>
                </div>
            </a>
        </div>


</nav>
