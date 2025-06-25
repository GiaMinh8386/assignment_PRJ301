<%@ page import="java.util.*, model.CartItemDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) session.getAttribute("cart");
    if (cart == null || cart.isEmpty()) {
%>
    <h3 class="text-center mt-5">Giỏ hàng trống!</h3>
<%
    } else {
        int idx = 0;
        java.math.BigDecimal grand = java.math.BigDecimal.ZERO;
%>
<table class="table table-striped">
    <thead>
        <tr><th>#</th><th>Sản phẩm</th><th>Số lượng</th><th>Đơn giá</th><th>Tạm tính</th><th></th></tr>
    </thead>
    <tbody>
<%
        for (CartItemDTO ci : cart.values()) {
            grand = grand.add(ci.getLineTotal());
%>
        <tr>
            <td><%= ++idx %></td>
            <td><%= ci.getProductName() %></td>
            <td>
                <form action="CartController" method="post" class="d-inline">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="productID" value="<%= ci.getProductID() %>">
                    <input type="number" name="qty" value="<%= ci.getQuantity() %>" min="1" class="form-control d-inline w-50">
                    <button class="btn btn-sm btn-primary">Cập nhật</button>
                </form>
            </td>
            <td><%= ci.getUnitPrice() %></td>
            <td><%= ci.getLineTotal() %></td>
            <td>
                <a href="CartController?action=remove&productID=<%= ci.getProductID() %>" class="btn btn-sm btn-danger">X</a>
            </td>
        </tr>
<%
        }
%>
    </tbody>
</table>

<h4 class="text-end">Tổng cộng: <%= grand %> ₫</h4>

<form action="OrderController" method="post" class="text-end">
    <input type="hidden" name="action" value="createOrder">
    <button class="btn btn-success">Thanh toán</button>
</form>
<%
    }
%>
