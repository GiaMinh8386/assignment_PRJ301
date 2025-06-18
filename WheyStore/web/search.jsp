<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.ProductDTO"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Tìm Kiếm Sản Phẩm</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-5">
            <h3 class="mb-4">Kết quả tìm kiếm cho từ khóa: "<%= request.getAttribute("keyword") %>"</h3>

            <%
                List<ProductDTO> list = (List<ProductDTO>) request.getAttribute("list");
                if (list == null || list.isEmpty()) {
            %>
            <div class="alert alert-warning">Không tìm thấy sản phẩm nào phù hợp.</div>
            <%
                } else {
            %>
            <div class="row row-cols-1 row-cols-md-3 g-4">
                <% for (ProductDTO product : list) { %>
                <div class="col">
                    <div class="card h-100 shadow">
                        <% if (product.getImage() != null && !product.getImage().isEmpty()) { %>
                        <img src="<%= product.getImage() %>" class="card-img-top" alt="Image">
                        <% } else { %>
                        <img src="assets/img/no-image.png" class="card-img-top" alt="No Image">
                        <% } %>
                        <div class="card-body">
                            <h5 class="card-title"><%= product.getName() %></h5>
                            <p class="card-text text-muted"><%= product.getBrand() %></p>
                            <p class="card-text"><%= product.getDescription() %></p>
                            <p class="fw-bold text-danger"><%= product.getFormattedPrice() %></p>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <%
                }
            %>

            <div class="mt-4">
                <a href="welcome.jsp" class="btn btn-secondary">Quay lại trang chủ</a>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

