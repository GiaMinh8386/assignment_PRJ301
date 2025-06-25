<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page isErrorPage="true" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lỗi hệ thống</title>
    </head>
    <body>
        <h2 style="color: red;">Đã xảy ra lỗi trong quá trình xử lý!</h2>

        <%
            Object msg = request.getAttribute("message");
            if (msg != null) {
        %>
        <p><b>Thông báo:</b> <%= msg %></p>
        <%
            }
        %>

        <hr>
        <%
            Exception ex = (Exception) request.getAttribute("jakarta.servlet.error.exception");
            if (ex != null) {
        %>
        <h4>Chi tiết lỗi:</h4>
        <pre>
            <%= ex.toString() %>
            <%
                for (StackTraceElement element : ex.getStackTrace()) {
                    out.println("    at " + element.toString());
                }
            %>
        </pre>
        <%
            }
        %>
    </body>
</html>
