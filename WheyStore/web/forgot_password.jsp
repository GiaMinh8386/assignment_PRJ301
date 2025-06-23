<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quên mật khẩu</title>
</head>
<body>
    <h2>Quên mật khẩu</h2>

    <form action="MainController" method="post">
        <label>Email của bạn:</label><br>
        <input type="email" name="email" required><br><br>

        <input type="hidden" name="action" value="forgotPassword">
        <input type="submit" value="Gửi mã đặt lại mật khẩu">
    </form>

    <p style="color:red;">${message}</p>
</body>
</html>