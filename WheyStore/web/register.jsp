<%-- 
    Document   : register
    Created on : Jun 11, 2025, 12:37:15 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

    <form action="MainController" method="post">
        <input type="hidden" name="action" value="register"/>
        Họ và tên: <input type="text" name="fullName" required/><br/>
        Email: <input type="email" name="email" required/><br/>
        SĐT: <input type="text" name="phone" required/><br/>
        Địa chỉ: <input type="text" name="address" required/><br/>
        Tên đăng nhập: <input type="text" name="username" required/><br/>
        Mật khẩu: <input type="password" name="password" required/><br/>
        <button type="submit">Đăng ký</button>
    </form>
    <%
    String msg = (String) request.getAttribute("message");
    if (msg != null && !msg.isEmpty()) {
    %>
    <div style="color: red; margin-top: 10px;"><%= msg %></div>
    <%
        }
    %>
</html>
