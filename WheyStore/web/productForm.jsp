<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%@page import="model.UserDTO"%>
<%@page import="model.ProductDTO"%>
<%@page import="utils.AuthUtils"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thêm Sản Phẩm</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', sans-serif;
            }

            .form-wrapper {
                max-width: 700px;
                margin: 60px auto;
            }

            .card-custom {
                background: #b02a20;
                border: none;
                border-radius: 20px;
                padding: 35px;
                color: white;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            }

            h3.form-title {
                font-weight: bold;
                text-align: center;
                margin-bottom: 30px;
                color: #fff;
                letter-spacing: 1px;
            }

            .form-label {
                color: #fff;
                font-weight: 600;
            }

            .form-control {
                border-radius: 10px;
                font-size: 16px;
            }

            .btn-custom {
                border-radius: 10px;
                font-weight: 600;
                padding: 10px 25px;
                transition: all 0.3s ease;
            }

            .btn-submit {
                background-color: #000;
                color: #fff;
                border: none;
            }

            .btn-submit:hover {
                background-color: #222;
                transform: scale(1.03);
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
            }

            .btn-reset {
                background-color: #fff;
                color: #b02a20;
                border: 2px solid #fff;
            }

            .btn-reset:hover {
                background-color: #e5e5e5;
                color: #000;
                transform: scale(1.02);
            }

            .error-msg {
                color: #fff;
                padding-left: 2px;
                font-weight: bold;
                font-size: 14px;
                margin-top: 5px;
            }

            .success-msg {
                color: #d4edda;
                background-color: #155724;
                border-left: 6px solid #28a745;
                padding: 12px 16px;
                border-radius: 10px;
                margin-top: 20px;
            }

            /* Access denied styles */
            .access-denied {
                text-align: center;
                padding: 60px 30px;
                color: #e74c3c;
                font-size: 18px;
                font-weight: 500;
                background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
                color: white;
                border-radius: 15px;
                margin: 20px;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            }
        </style>
    </head>
    <body>
        <%
            if (AuthUtils.isAdmin(request)) {
                ProductDTO product = (ProductDTO) request.getAttribute("product");
                String message = (String) request.getAttribute("message");
        %>

        <div class="form-wrapper">
            <div class="card-custom">
                <h3 class="form-title">Thêm Sản Phẩm Mới</h3>
                <form action="MainController" method="post">
                    <input type="hidden" name="action" value="addProduct"/>

                    <div class="mb-3">
                        <label for="id" class="form-label">Mã sản phẩm *</label>
                        <input type="text" class="form-control" id="id" name="id" required
                               value="<%= product != null ? product.getId() : "" %>"/>
                        <% if (request.getAttribute("idError") != null) { %>
                        <div class="error-msg"><%= request.getAttribute("idError") %></div>
                        <% } %>
                    </div>

                    <div class="mb-3">
                        <label for="name" class="form-label">Tên sản phẩm *</label>
                        <input type="text" class="form-control" id="name" name="name" required
                               value="<%= product != null ? product.getName() : "" %>"/>
                        <% if (request.getAttribute("nameError") != null) { %>
                        <div class="error-msg"><%= request.getAttribute("nameError") %></div>
                        <% } %>
                    </div>

                    <div class="mb-3">
                        <label for="image" class="form-label">Link ảnh</label>
                        <input type="text" class="form-control" id="image" name="image"
                               value="<%= product != null ? product.getImage() : "" %>"/>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">Mô tả</label>
                        <textarea class="form-control" id="description" name="description" rows="3"><%= product != null ? product.getDescription() : "" %></textarea>
                    </div>

                    <div class="mb-3">
                        <label for="price" class="form-label">Giá *</label>
                        <input type="number" class="form-control" id="price" name="price" min="0" step="0.01" required
                               value="<%= product != null ? product.getPrice() : "" %>"/>
                        <% if (request.getAttribute("priceError") != null) { %>
                        <div class="error-msg"><%= request.getAttribute("priceError") %></div>
                        <% } %>
                    </div>

                    <div class="mb-3">
                        <label for="brand" class="form-label">Thương hiệu</label>
                        <input type="text" class="form-control" id="brand" name="brand"
                               value="<%= product != null ? product.getBrand() : "" %>"/>
                    </div>

                    <div class="mb-3">
                        <label for="categoryId" class="form-label">Mã danh mục *</label>
                        <input type="number" class="form-control" id="categoryId" name="categoryId" required
                               value="<%= product != null ? product.getCategoryId() : "" %>"/>
                        <% if (request.getAttribute("categoryError") != null) { %>
                        <div class="error-msg"><%= request.getAttribute("categoryError") %></div>
                        <% } %>
                    </div>

                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="status" name="status" value="true"
                               <%= (product != null && product.isStatus()) ? "checked" : "" %>/>
                        <label class="form-check-label" for="status">Hiển thị sản phẩm</label>
                    </div>

                    <div class="d-flex justify-content-between">
                        <button type="submit" class="btn btn-success btn-custom">Thêm</button>
                        <button type="reset" class="btn btn-light btn-custom btn-reset">Reset</button>
                    </div>

                    <% if (request.getAttribute("createError") != null) { %>
                    <div class="error-msg mt-3"><%= request.getAttribute("createError") %></div>
                    <% } %>

                    <% if (message != null) { %>
                    <div class="success-msg mt-3"><%= message %></div>
                    <% } %>

                </form>
            </div>
        </div>

        <% } else { %>
        <div class="container mt-5">
            <div class="alert alert-danger text-center">
                <%= AuthUtils.getAccessDeniedMessage("product-form page") %>
            </div>
        </div>
        <% } %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>