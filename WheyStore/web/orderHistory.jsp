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

        <div class="container mt-5">
            <h2 class="mb-4">📦 Lịch sử đơn hàng của bạn</h2>

            <%
                List<OrderDTO> orders = (List<OrderDTO>) request.getAttribute("orders");
                if (orders == null || orders.isEmpty()) {
            %>
            <div class="alert alert-warning">Bạn chưa có đơn hàng nào.</div>
            <%
                } else {
            %>
            <table class="table table-bordered table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>Ngày đặt</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Chi tiết</th>
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
                        <td><%= order.getStatus() %></td>
                        <td>
                            <a href="OrderController?action=viewOrderDetail&orderID=<%= order.getOrderID() %>" class="btn btn-sm btn-primary">
                                Xem
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
        </div>

        <%@ include file="footer.jsp" %>

    </body>
</html>

