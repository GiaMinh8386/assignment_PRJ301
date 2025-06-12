<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
</html>
