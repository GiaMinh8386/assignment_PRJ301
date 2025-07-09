<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lỗi hệ thống</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body>

        <%@ include file="header.jsp" %>

        <div class="container my-5">
            <div class="alert alert-danger text-center">
                <h2>❌ Đã xảy ra lỗi trong quá trình xử lý!</h2>
            </div>

            <%
                Object msg = request.getAttribute("message");
                if (msg != null) {
            %>
            <div class="alert alert-warning">
                <strong>Thông báo:</strong> <%= msg %>
            </div>
            <%
                }
            %>

            <%
                Exception ex = (Exception) request.getAttribute("jakarta.servlet.error.exception");
                if (ex != null) {
            %>
            <div class="alert alert-secondary">
                <h4>Chi tiết lỗi:</h4>
                <pre style="white-space: pre-wrap;">
                    <%= ex.toString() %>
                    <%
                        for (StackTraceElement element : ex.getStackTrace()) {
                            out.println("    at " + element.toString());
                        }
                    %>
                </pre>
            </div>
            <%
                }
            %>

            <div class="mt-4 text-center">
                <a href="MainController?action=home" class="btn btn-primary">
                    <i class="fas fa-home me-2"></i>Quay về trang chủ
                </a>
            </div>
        </div>

        <%@ include file="footer.jsp" %>

        <!-- FontAwesome (nếu bạn dùng icon) -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>

    </body>
</html>
