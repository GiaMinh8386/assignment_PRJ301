<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <div class="row">
        <c:forEach var="p" items="${products}">
            <div class="col-md-3 mb-4">
                <div class="card h-100 shadow-sm">
                    <img src="assets/images/${p.image}" class="card-img-top" alt="${p.name}">
                    <div class="card-body">
                        <h5 class="card-title">${p.name}</h5>
                        <p class="card-text text-danger fw-bold">${p.price} ?</p>
                        <a href="MainController?action=productDetail&id=${p.id}" class="btn btn-outline-primary btn-sm">Xem chi ti?t</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<%@ include file="footer.jsp" %>

<!-- Bootstrap JS (tu? ch?n n?u có t??ng tác) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>