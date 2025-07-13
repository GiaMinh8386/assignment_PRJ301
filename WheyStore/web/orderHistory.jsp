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
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            .home-btn {
                border-radius: 25px;
                padding: 12px 30px;
                font-weight: 500;
                box-shadow: 0 4px 15px rgba(0,123,255,0.3);
                transition: all 0.3s ease;
            }
            .home-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(0,123,255,0.4);
            }
        </style>
    </head>
    <body>
        <%@ include file="header.jsp" %>
        <div class="container my-5">
            <h3>🧾 Lịch sử đơn hàng của bạn</h3>

            <%
                List<OrderDTO> orders = (List<OrderDTO>) request.getAttribute("orders");
                if (orders == null || orders.isEmpty()) {
            %>
            <!-- MERGED: Kết hợp icon của bạn + text của bạn tôi -->
            <div class="alert alert-info mt-4">
                <i class="fas fa-info-circle me-2"></i>Bạn chưa có đơn hàng nào.
            </div>
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
                        <!-- MERGED: Giữ badge warning của bạn (đẹp hơn) -->
                        <td>
                            <span class="badge bg-warning text-dark"><%= order.getStatus() %></span>
                        </td>
                        <!-- MERGED: Giữ button design của bạn (có icon + bo tròn) -->
                        <td>
                            <a href="OrderController?action=viewOrderDetail&orderID=<%= order.getOrderID() %>" 
                               class="btn btn-sm btn-primary rounded-pill">
                                <i class="fas fa-eye me-1"></i>Xem chi tiết
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

            <!-- MERGED: Giữ home button đẹp của bạn + link MainController của bạn -->
            <div class="text-center mt-4 mb-5">
                <a href="MainController?action=home" class="btn btn-primary home-btn">
                    <i class="fas fa-home me-2"></i>Về trang chủ
                </a>
            </div>
        </div>
        <%@ include file="footer.jsp" %>

        <!-- MERGED: Thêm Bootstrap JS của bạn -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>