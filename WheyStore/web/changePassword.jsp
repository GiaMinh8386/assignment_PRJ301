<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.UserDTO" %>
<%
    UserDTO user = (UserDTO) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("MainController?action=login");
        return;
    }
%>
<html>
    <head>
        <title>Thay đổi mật khẩu</title>
        <style>
            body {
                font-family: Arial;
                max-width: 500px;
                margin: 50px auto;
            }
            label {
                font-weight: bold;
            }
            .form-group {
                margin-bottom: 12px;
            }
            .error {
                color: red;
            }
            .success {
                color: green;
            }
        </style>
    </head>
    <body>
        <h2>Thay đổi mật khẩu</h2>
        <form action="MainController" method="post">
            <div class="form-group">
                <label>Mật khẩu hiện tại:</label><br>
                <input type="password" name="currentPassword" required />
            </div>
            <div class="form-group">
                <label>Mật khẩu mới:</label><br>
                <input type="password" name="newPassword" required />
            </div>
            <div class="form-group">
                <label>Xác nhận mật khẩu mới:</label><br>
                <input type="password" name="confirmPassword" required />
            </div>

            <input type="submit" name="action" value="changePassword" />

            <br><br>
            <p class="error">${requestScope.message}</p>
            <p class="success">${requestScope.success}</p>
        </form>
        <script>
            const successMessage = document.querySelector(".success");
            if (successMessage && successMessage.textContent.trim().length > 0) {
                setTimeout(() => {
                    // Chuyển hướng sang trang logout (và trang chủ sau đó)
                    window.location.href = "MainController?action=logout";
                }, 5000); // 5000 ms = 5 giây
            }
        </script>
    </body>
</html>