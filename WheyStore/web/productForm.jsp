<%--<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.UserDTO"%>
<%@page import="model.ProductDTO"%>
<%@page import="utils.AuthUtils"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Product Form</title>
</head>
<body>
<%
    if(AuthUtils.isAdmin(request)){
        ProductDTO product = (ProductDTO) request.getAttribute("product");
        String checkError = (String) request.getAttribute("checkError");
        String message = (String) request.getAttribute("message");
%>
    <h1>Add Product</h1>
    <form action="MainController" method="post">
        <input type="hidden" name="action" value="addProduct"/>

        <div>
            <label for="id">Product ID*</label>
            <input type="text" name="id" id="id" required
                   value="<%=product != null ? product.getId() : ""%>"/>
        </div>

        <div>
            <label for="name">Product Name*</label>
            <input type="text" name="name" id="name" required
                   value="<%=product != null ? product.getName() : ""%>"/>
        </div>

        <div>
            <label for="image">Image URL</label>
            <input type="text" name="image" id="image"
                   value="<%=product != null ? product.getImage() : ""%>"/>
        </div>

        <div>
            <label for="description">Description</label><br/>
            <textarea name="description" id="description" rows="4" cols="40"><%=product != null ? product.getDescription() : ""%></textarea>
        </div>

        <div>
            <label for="price">Price*</label>
            <input type="number" name="price" id="price" min="0" step="0.01" required
                   value="<%=product != null ? product.getPrice() : ""%>"/>
        </div>

        <div>
            <label for="brand">Brand</label>
            <input type="text" name="brand" id="brand"
                   value="<%=product != null ? product.getBrand() : ""%>"/>
        </div>

        <div>
            <label for="stockQuantity">Stock Quantity</label>
            <input type="number" name="stockQuantity" id="stockQuantity" min="0"
                   value="<%=product != null ? product.getStockQuantity() : ""%>"/>
        </div>

        <div>
            <label for="productCode">Product Code</label>
            <input type="text" name="productCode" id="productCode"
                   value="<%=product != null ? product.getProductCode() : ""%>"/>
        </div>

        <div>
            <label for="categoryId">Category ID</label>
            <input type="number" name="categoryId" id="categoryId"
                   value="<%=product != null ? product.getCategoryId() : ""%>"/>
        </div>

        <div>
            <input type="submit" value="Add Product"/>
            <input type="reset" value="Reset"/>
        </div>
    </form>

    <p style="color:red;"><%= checkError != null ? checkError : "" %></p>
    <p style="color:green;"><%= message != null ? message : "" %></p>

<%
    } else {
%>
    <%= AuthUtils.getAccessDeniedMessage("product-form page") %>
<%
    }
%>
</body>
</html> --%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                color: #ffdddd;
                background-color: #7a1212;
                border-left: 6px solid #ff4444;
                padding: 12px 16px;
                border-radius: 10px;
                margin-top: 20px;
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
                String checkError = (String) request.getAttribute("checkError");
                String message = (String) request.getAttribute("message");
        %>

        <div class="form-wrapper">
            <div class="card card-custom">
                <h3 class="form-title">Thêm Sản Phẩm Mới</h3>
                <form action="MainController" method="post">
                    <input type="hidden" name="action" value="addProduct"/>

                    <div class="mb-3">
                        <label class="form-label" for="id">Mã sản phẩm *</label>
                        <input type="text" class="form-control" id="id" name="id" required
                               value="<%= product != null ? product.getId() : "" %>"/>
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="name">Tên sản phẩm *</label>
                        <input type="text" class="form-control" id="name" name="name" required
                               value="<%= product != null ? product.getName() : "" %>"/>
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="image">Link ảnh</label>
                        <input type="text" class="form-control" id="image" name="image"
                               value="<%= product != null ? product.getImage() : "" %>"/>
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="description">Mô tả</label>
                        <textarea class="form-control" id="description" name="description" rows="3"><%= product != null ? product.getDescription() : "" %></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="price">Giá *</label>
                        <input type="number" class="form-control" id="price" name="price" min="0" step="0.01" required
                               value="<%= product != null ? product.getPrice() : "" %>"/>
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="brand">Thương hiệu</label>
                        <input type="text" class="form-control" id="brand" name="brand"
                               value="<%= product != null ? product.getBrand() : "" %>"/>
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="stockQuantity">Số lượng tồn kho</label>
                        <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" min="0"
                               value="<%= product != null ? product.getStockQuantity() : "" %>"/>
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="productCode">Mã hiển thị</label>
                        <input type="text" class="form-control" id="productCode" name="productCode"
                               value="<%= product != null ? product.getProductCode() : "" %>"/>
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="categoryId">Mã danh mục</label>
                        <input type="number" class="form-control" id="categoryId" name="categoryId"
                               value="<%= product != null ? product.getCategoryId() : "" %>"/>
                    </div>

                    <div class="d-flex justify-content-between">
                        <button type="submit" class="btn btn-custom btn-submit">Thêm</button>
                        <button type="reset" class="btn btn-custom btn-reset">Reset</button>
                    </div>

                    <div style="color:red">
                        <%=request.getAttribute("createError")!=null?request.getAttribute("createError"):""%>
                    </div>
                    <div style="color:green">
                        <%=request.getAttribute("message")!=null?request.getAttribute("message"):""%>
                    </div>
                </form>

                <% if (checkError != null && !checkError.isEmpty()) { %>
                <div class="error-msg mt-3"><%= checkError %></div>
                <% } %>

                <% if (message != null && !message.isEmpty()) { %>
                <div class="success-msg mt-3"><%= message %></div>
                <% } %>
            </div>
        </div>

        <% } else { %>
        
        <div class="access-denied">
            <%=AuthUtils.getAccessDeniedMessage(" product-form page ")%>
        </div>
        
        <% } %>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
