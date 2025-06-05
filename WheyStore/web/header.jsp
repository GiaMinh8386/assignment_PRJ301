<%-- 
    Document   : header
    Created on : Jun 5, 2025, 6:18:54 PM
    Author     : GIA MINH
--%>

<!-- /WEB-INF/views/partials/header.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- Bootstrap 5 CDN -->
<!-- Bootstrap 5 + Font Awesome -->
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
      border-radius: 0px;
      overflow: hidden;
      box-shadow: 0 0 6px rgba(0,0,0,0.1);
  }

  .input-group .form-select {
      border: none;
      max-width: 160px;
      font-weight: 500;
  }

  .input-group .form-control {
      border: none;
  }

  .input-group .btn-search {
      background-color: #4B2E83;
      color: white;
      border: none;
  }

  .input-group .btn-search:hover {
      background-color: #321c58;
  }

  .dropdown-hover {
      position: relative;
  }

  .dropdown-hover .dropdown-menu {
      display: none;
      position: absolute;
      top: 100%;
      left: 0;
      animation: fadeIn 0.3s ease-in-out;
  }

  .dropdown-hover:hover .dropdown-menu {
      display: block;
  }

  @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
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
        <!-- Dropdown s?n ph?m -->
        <div class="dropdown-hover">
          <select class="form-select" name="category">
            <option value="">Product</option>
            <option value="whey">Whey Protein</option>
            <option value="creatine">Creatine</option>
            <option value="vitamin">Vitamin</option>
            <option value="dotmo">reduce fat</option>
            <option value="sinhly">Physiology-Endocrinology</option>
          </select>
          <!-- Hi?u ?ng dropdown ri?ng n?u mu?n t?y ch?nh th?m -->
        </div>

        <!-- ? nh?p -->
        <input type="text" class="form-control" placeholder="Search..." name="q" />

        <!-- N?t search -->
        <button class="btn btn-search" type="submit">
          <i class="fas fa-search"></i>
        </button>
      </div>
    </form>

    <!-- Login -->
    <div class="ms-4">
      <a class="nav-link nav-link-login" href="login.jsp">Login</a>
    </div>
  </div>
</nav>
