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
        <title>Trang chủ - WheyStore</title>
    </head>
    <body>

        <%@ include file="header.jsp" %>

        <div class="container mt-5">
            <h2 class="mb-4">Sản phẩm nổi bật</h2>

            <c:if test="${empty products}">
                <div class="alert alert-warning">Không có sản phẩm nào được hiển thị.</div>
            </c:if>

            <div class="row">
                <c:forEach var="p" items="${products}">
                    <div class="col-md-3 mb-4">
                        <div class="card h-100 shadow-sm">
                            <img src="assets/images/${p.image}" class="card-img-top" alt="${p.name}">
                            <div class="card-body">
                                <h5 class="card-title">${p.name}</h5>
                                <p class="card-text text-danger fw-bold">
                                    <c:choose>
                                        <c:when test="${p.price > 0}">
                                            ${p.formattedPrice}
                                        </c:when>
                                        <c:otherwise>
                                            0 ₫
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <a href="MainController?action=productDetail&id=${p.id}" class="btn btn-outline-primary btn-sm">Xem chi tiết</a>
                            </div>
                        </div>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - WheyStore</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- Include Header -->
<%@ include file="header.jsp" %>
<%@ include file="banner.jsp" %>

<div class="container mt-5">
    <h2 class="mb-4">Sản phẩm nổi bật</h2>
    
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
                for (ProductDTO p : products) {
        %>
            <div class="col-md-3 mb-4">
                <div class="card h-100 shadow-sm">
                    <%
                        String imagePath = (p.getImage() != null && !p.getImage().trim().isEmpty()) 
                                         ? "assets/images/" + p.getImage() 
                                         : "assets/images/no-image.jpg";
                    %>
                    <img src="<%= imagePath %>" class="card-img-top" alt="<%= p.getName() %>"
                         style="height: 200px; object-fit: cover;"
                         onerror="this.src='assets/images/no-image.jpg'">
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title"><%= p.getName() %></h5>
                        <p class="card-text text-muted small"><%= p.getBrand() != null ? p.getBrand() : "" %></p>
                        <p class="card-text text-danger fw-bold mt-auto">
                            <%= String.format("%,.0f ₫", p.getPrice()) %>
                        </p>
                        <a href="MainController?action=productDetail&id=<%= p.getId() %>" 
                           class="btn btn-outline-primary btn-sm">Xem chi tiết</a>

                    </div>
                </c:forEach>
            </div>

        </div>
        <%@ include file="footer.jsp" %>
        <!-- Bootstrap JS (tu? ch?n n?u có t??ng tác) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

        <%
                }
            } else {
        %>
            <div class="col-12">
                <div class="alert alert-info text-center">
                    <i class="fas fa-info-circle fa-2x mb-3"></i>
                    <h4>Chưa có sản phẩm nào</h4>
                    <p>Hệ thống đang cập nhật sản phẩm. Vui lòng quay lại sau.</p>
                    <a href="MainController?action=home" class="btn btn-primary">Tải lại trang</a>
                </div>
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
</body>
>>>>>>> Stashed changes
</html>