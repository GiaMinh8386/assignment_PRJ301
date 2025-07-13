<%-- 
    Document   : orderHistory
    Created on : Jul 9, 2025, 6:12:51 PM
    Author     : PC
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.OrderDTO" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lịch sử đơn hàng - GymLife</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body>
        <%@ include file="header.jsp" %>
        <div class="container my-5">
            <h3>🧾 Lịch sử đơn hàng của bạn</h3>

            <%
                List<OrderDTO> orders = (List<OrderDTO>) request.getAttribute("orders");
                if (orders == null || orders.isEmpty()) {
            %>
            <div class="alert alert-info mt-4">Bạn chưa có đơn hàng nào.</div>
            <%
                } else {
            %>

            <table class="table table-bordered mt-4">
                <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>Ngày đặt</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (OrderDTO order : orders) {
                    %>
                    <tr>
                        <td><%= order.getOrderID() %></td>
                        <td><%= order.getOrderDate() %></td>
                        <td><%= String.format("%,.0f", order.getTotalAmount()) %> ₫</td>
                        <td><span class="badge bg-info"><%= order.getStatus() %></span></td>
                        <td>
                            <a href="OrderController?action=viewOrderDetail&orderID=<%= order.getOrderID() %>" class="btn btn-sm btn-primary">
                                Xem chi tiết
                            </a>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <%
                }
            %>
            <a href="welcome.jsp" class="btn btn-secondary mt-3">← Quay lại trang chính</a>
        </div>
        <%@ include file="footer.jsp" %>
    </body>
</html>
