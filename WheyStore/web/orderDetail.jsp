<%-- 
    Document   : orderDetail
    Created on : Jul 9, 2025, 6:25:44 PM
    Author     : PC
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.OrderDTO, model.OrderDetailDTO" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết đơn #<%= ((OrderDTO)request.getAttribute("order")).getOrderID() %> - GymLife</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body>

        <%@ include file="header.jsp" %>

        <div class="container my-5">

            <%
    OrderDTO od = (OrderDTO) request.getAttribute("order");
    List<OrderDetailDTO> items = (List<OrderDetailDTO>) request.getAttribute("orderDetails");

    if (od == null || items == null) {
            %>
            <div class="alert alert-danger my-5 container">
                ❌ Không tìm thấy thông tin đơn hàng.
                <a href="OrderController?action=viewOrders" class="btn btn-secondary mt-3">← Quay lại lịch sử</a>
            </div>
            <%
                } else {
            %>
            <h3 class="mb-4 text-center">🧾 Đơn hàng #<%= od.getOrderID() %></h3>

            <ul class="list-group mb-4">
                <li class="list-group-item">Ngày đặt: <strong><%= od.getOrderDate() %></strong></li>
                <li class="list-group-item">Tổng tiền: <strong><%= String.format("%,.0f", od.getTotalAmount()) %> ₫</strong></li>
                <li class="list-group-item">Trạng thái: <span class="badge bg-info"><%= od.getStatus() %></span></li>
            </ul>

            <table class="table table-bordered text-center align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>Ảnh</th>
                        <th>Tên Sản phẩm</th>
                        <th>Số lượng</th>
                        <th>Đơn giá</th>
                        <th>Tạm tính</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        int idx = 0;
                        for (OrderDetailDTO d : items) {
                            idx++;
                    %>
                    <tr>
                        <td><%= idx %></td>
                        <td>
                            <img src="${pageContext.request.contextPath}/assets/images/products/<%= d.getImageURL() %>" alt="Ảnh" width="70" class="img-fluid"/>
                        </td>
                        <td><%= d.getProductName() %> (<%= d.getProductID() %>)</td>
                        <td><%= d.getQuantity() %></td>
                        <td><%= String.format("%,.0f", d.getUnitPrice()) %> ₫</td>
                        <td><%= String.format("%,.0f", d.getUnitPrice().multiply(new java.math.BigDecimal(d.getQuantity()))) %> ₫</td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>

            <a href="OrderController?action=viewOrders" class="btn btn-secondary">
                ← Quay lại lịch sử
            </a>
            <%
                }
            %>

        </div>

        <%@ include file="footer.jsp" %>
    </body>
</html>
