<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.ProductDTO" %>
<%@ page import="java.util.List" %>

<h2>Sản phẩm yêu thích</h2>

<%
List<ProductDTO> list = (List<ProductDTO>) request.getAttribute("favorites");
if (list != null && !list.isEmpty()) {
        for (ProductDTO p : list) {
%>
<div>
    <h3><%= p.getName() %></h3>
    <p><%= p.getDescription() %></p>
    <p>Giá: <%= String.format("%,.0f", p.getPrice()) %>₫</p>
</div>
<%
        }
    } else {
%>
<p>Bạn chưa yêu thích sản phẩm nào.</p>
<%
    }
%>
