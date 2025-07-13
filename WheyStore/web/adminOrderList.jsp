<%-- 
    Document   : adminOrderList
    Created on : Jul 12, 2025, 7:25:57 PM
    Author     : PC
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.OrderDTO" %>
<%@ include file="header.jsp" %>

<div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-danger"><i class="fas fa-box"></i> Danh sách đơn hàng</h3>
    </div>

    <table class="table table-hover table-bordered shadow-sm">
        <thead class="table-dark text-center align-middle">
            <tr>
                <th>ID</th>
                <th>Người đặt</th>
                <th>Ngày đặt</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody class="align-middle text-center">
            <%
                List<OrderDTO> list = (List<OrderDTO>) request.getAttribute("orders");
                for (OrderDTO o : list) {
            %>
            <tr>
                <td><%= o.getOrderID() %></td>
                <td><%= o.getUserID() %></td>
                <td><%= o.getOrderDate() %></td>
                <td class="text-end text-success fw-bold"><%= String.format("%,.0f", o.getTotalAmount()) %> ₫</td>
                <td>
                    <span class="badge
                          <%= o.getStatus().equals("Pending") ? "bg-warning text-dark"
                             : o.getStatus().equals("Approved") ? "bg-success"
                             : o.getStatus().equals("Shipped") ? "bg-primary"
                             : "bg-danger" %>">
                        <%= o.getStatus() %>
                    </span>
                </td>
                <td>
                    <form action="OrderController" method="post" class="d-flex justify-content-center gap-2">
                        <input type="hidden" name="action" value="updateOrderStatus">
                        <input type="hidden" name="orderID" value="<%= o.getOrderID() %>">

                        <select name="status" class="form-select form-select-sm w-auto">
                            <option <%= o.getStatus().equals("Pending") ? "selected" : "" %>>Pending</option>
                            <option <%= o.getStatus().equals("Approved") ? "selected" : "" %>>Approved</option>
                            <option <%= o.getStatus().equals("Shipped") ? "selected" : "" %>>Shipped</option>
                            <option <%= o.getStatus().equals("Cancelled") ? "selected" : "" %>>Cancelled</option>
                        </select>

                        <button class="btn btn-sm btn-primary">
                            <i class="fas fa-sync-alt me-1"></i> Cập nhật
                        </button>
                    </form>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>

<%@ include file="footer.jsp" %>

