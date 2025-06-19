<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách sản phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        a.text-decoration-none:hover {
            text-decoration: underline;
        }
        .category-link {
            display: block;
            padding: 5px 0;
            color: black;
        }
        .category-link:hover {
            color: #0d6efd;
        }
        .product-card {
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-bottom: 20px;
            padding: 10px;
            background-color: #fff;
        }
        .product-card img {
            max-width: 100%;
            height: 200px;
            object-fit: contain;
        }
        .old-price {
            text-decoration: line-through;
            color: gray;
        }
        .price {
            color: red;
            font-weight: bold;
        }
        .label-yeuthich {
            position: absolute;
            background: #dc3545;
            color: white;
            font-size: 12px;
            padding: 2px 5px;
            top: 5px;
            left: 5px;
        }
        .label-giam {
            position: absolute;
            background: gold;
            font-size: 12px;
            padding: 2px 5px;
            top: 5px;
            right: 5px;
            color: #333;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container-fluid mt-4">
    <div class="row">

        <!-- Sidebar -->
        <div class="col-md-3">
            <h5><i class="bi bi-list"></i> DANH MỤC</h5>
            <hr/>
            <c:forEach var="cat" items="${categories}">
                <a class="category-link text-decoration-none" 
                   href="ProductController?action=filter&categoryId=${cat.id}">
                    ${cat.name}
                </a>
            </c:forEach>

            <hr/>
            <h6>Giá</h6>
            <form action="ProductController" method="get">
                <input type="hidden" name="action" value="filter"/>
                <input type="hidden" name="categoryId" value="${param.categoryId}"/>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="priceRange" value="0-500000" id="price1">
                    <label class="form-check-label" for="price1">Dưới 500.000đ</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="priceRange" value="500000-1000000" id="price2">
                    <label class="form-check-label" for="price2">500.000đ - 1.000.000đ</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="priceRange" value="1000000-1500000" id="price3">
                    <label class="form-check-label" for="price3">1.000.000đ - 1.500.000đ</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="priceRange" value="1500000-2000000" id="price4">
                    <label class="form-check-label" for="price4">1.500.000đ - 2.000.000đ</label>
                </div>
                <button type="submit" class="btn btn-outline-primary btn-sm mt-2">Lọc</button>
            </form>
        </div>

        <!-- Product grid -->
        <div class="col-md-9">
            <div class="row">
                <c:forEach var="product" items="${products}">
                    <div class="col-md-4">
                        <div class="product-card position-relative">
                            <div class="label-yeuthich">Yêu thích</div>
                            <div class="label-giam">GIẢM ${product.discountPercent}%</div>
                            <img src="${product.imageUrl}" alt="${product.name}">
                            <h6 class="mt-2">${product.name}</h6>
                            <p>
                                <span class="old-price">${product.oldPrice}đ</span><br>
                                <span class="price">${product.price}đ</span>
                            </p>
                            <p><i class="bi bi-star-fill text-warning"></i> ${product.soldQuantity} đã bán</p>
                            <p><small>${product.origin}</small></p>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

    </div>
</div>

<!-- Bootstrap JS (tuỳ chọn nếu có modal, toast, dropdown) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
