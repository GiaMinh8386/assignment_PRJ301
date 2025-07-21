package controller;


import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.UserDAO;
import model.UserDTO;
import java.time.LocalDateTime;
import utils.PasswordUtils;

/* import utils.PasswordUtils; // ❌ COMMENTED OUT - Không dùng hash */

@WebServlet(name = "UserController", urlPatterns = {"/UserController"})
public class UserController extends HttpServlet {

    private static final String WELCOME_PAGE = "welcome.jsp";
    private static final String LOGIN_PAGE = "login.jsp";
    private static final String HOME_PAGE = "MainController?action=home";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = LOGIN_PAGE;

        try {
            String action = request.getParameter("action");
            System.out.println("DEBUG UserController - Action received: " + action);

            if ("login".equals(action)) {
                url = handleLogin(request, response);
            } else if ("logout".equals(action)) {
                url = handleLogout(request, response);
            } else if ("register".equals(action)) {
                url = handleRegister(request, response);
            } else if ("updateProfile".equals(action)) {
                url = handleUpdateProfile(request, response);
            } else if ("viewProfile".equals(action)) {
                url = handleViewProfile(request, response);
            } else if ("changePassword".equals(action)) {
                url = handleChangePassword(request, response);
            } else if ("forgotPassword".equals(action)) {
                url = handleForgotPassword(request, response);
            } else {
                request.setAttribute("message", "Invalid action: " + action);
                url = LOGIN_PAGE;
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG UserController - Error: " + e.getMessage());
            request.setAttribute("message", "System error occurred!");
            url = "error.jsp";
        } finally {
            System.out.println("DEBUG UserController - Final URL: " + url);

            if (url.startsWith("MainController")) {
                System.out.println("DEBUG UserController - Redirecting to: " + url);
                response.sendRedirect(url);
            } else {
                System.out.println("DEBUG UserController - Forwarding to: " + url);
                request.getRequestDispatcher(url).forward(request, response);
            }
        }
    }

    /**
     * ✅ SIMPLE LOGIN - No password hashing
     */
    private String handleLogin(HttpServletRequest request, HttpServletResponse response) {
        String url = LOGIN_PAGE;
        HttpSession session = request.getSession();
        String strUsername = request.getParameter("strUsername");
        String strPassword = request.getParameter("strPassword");
        
        System.out.println("🚀 DEBUG handleLogin - Username: " + strUsername);
        System.out.println("🔑 DEBUG handleLogin - Password: " + strPassword);

        UserDAO userDAO = new UserDAO();

        // Validate input
        if (strUsername == null || strUsername.trim().isEmpty()
                || strPassword == null || strPassword.trim().isEmpty()) {
            request.setAttribute("message", "Username and password are required");
            System.out.println("❌ DEBUG handleLogin - Empty username or password");
            return url;
        }

        try {
            // ✅ NO HASH: Pass plain password directly to DAO
            if (userDAO.login(strUsername, strPassword)) {
                UserDTO user = userDAO.getUserById(strUsername);
                if (user != null && user.isStatus()) {
                    session.setAttribute("user", user);
                    System.out.println("✅ DEBUG handleLogin - Login successful for user: " + user.getFullName());

                    String redirectTo = request.getParameter("redirectTo");
                    if ("welcome".equals(redirectTo)) {
                        url = WELCOME_PAGE;
                    } else {
                        url = HOME_PAGE;
                    }
                } else {
                    request.setAttribute("message", "Your account has been deactivated");
                    System.out.println("❌ DEBUG handleLogin - Account deactivated or null");
                }
            } else {
                request.setAttribute("message", "Invalid username or password");
                System.out.println("❌ DEBUG handleLogin - Invalid credentials");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Database error: " + e.getMessage());
            System.out.println("❌ DEBUG handleLogin - Database error: " + e.getMessage());
        }

        return url;
    }

    private String handleLogout(HttpServletRequest request, HttpServletResponse response) {
        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                UserDTO user = (UserDTO) session.getAttribute("user");
                if (user != null) {
                    System.out.println("DEBUG handleLogout - Logging out user: " + user.getFullName());
                }

                session.invalidate();
                System.out.println("DEBUG handleLogout - Session invalidated successfully");
            }

            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG handleLogout - Error: " + e.getMessage());
        }

        String logoutDestination = request.getParameter("destination");
        if ("login".equals(logoutDestination)) {
            return LOGIN_PAGE;
        } else {
            return HOME_PAGE;
        }
    }

    /**
     * ✅ REGISTER - No password hashing
     */
    private String handleRegister(HttpServletRequest request, HttpServletResponse response) {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        System.out.println("DEBUG handleRegister - Registering user: " + username);

        UserDAO dao = new UserDAO();

        // Validate inputs
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("message", "Họ tên không được để trống");
            return "register.jsp";
        }

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("message", "Email không được để trống");
            return "register.jsp";
        }

        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("message", "Tên đăng nhập không được để trống");
            return "register.jsp";
        }

        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("message", "Mật khẩu không được để trống");
            return "register.jsp";
        }

        if (confirmPassword == null || !password.equals(confirmPassword)) {
            request.setAttribute("message", "Mật khẩu xác nhận không khớp");
            return "register.jsp";
        }

        try {
            if (dao.isUsernameExist(username)) {
                request.setAttribute("message", "Tên đăng nhập đã tồn tại");
                return "register.jsp";
            }

            if (dao.isEmailExist(email)) {
                request.setAttribute("message", "Email này đã được sử dụng");
                return "register.jsp";
            }

            // ✅ NO HASH: Password will be stored as plain text in DAO
            boolean success = dao.registerCustomer(fullName, email, phone, address, username, password);

            if (success) {
                request.setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
                System.out.println("DEBUG handleRegister - Registration successful for: " + username);
                return "login.jsp";
            } else {
                request.setAttribute("message", "Đăng ký thất bại. Vui lòng thử lại.");
                System.out.println("DEBUG handleRegister - Registration failed for: " + username);
                return "register.jsp";
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Lỗi hệ thống: " + e.getMessage());
            System.out.println("DEBUG handleRegister - Database error: " + e.getMessage());
            return "register.jsp";
        }
    }

    private String handleViewProfile(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null) {
            request.setAttribute("message", "Vui lòng đăng nhập để xem thông tin cá nhân");
            return LOGIN_PAGE;
        }

        UserDAO userDAO = new UserDAO();
        UserDTO refreshedUser = userDAO.getUserById(user.getUsername());

        if (refreshedUser != null) {
            session.setAttribute("user", refreshedUser);
            request.setAttribute("user", refreshedUser);
        }

        return "profile.jsp";
    }

    private String handleUpdateProfile(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        UserDTO currentUser = (UserDTO) session.getAttribute("user");

        if (currentUser == null) {
            request.setAttribute("message", "Vui lòng đăng nhập để cập nhật thông tin");
            return LOGIN_PAGE;
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("message", "Họ tên không được để trống");
            return "profile.jsp";
        }

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("message", "Email không được để trống");
            return "profile.jsp";
        }

        UserDAO dao = new UserDAO();
        if (dao.isEmailExist(email) && !email.equals(currentUser.getEmail())) {
            request.setAttribute("message", "Email này đã được sử dụng bởi tài khoản khác");
            return "profile.jsp";
        }

        currentUser.setFullName(fullName);
        currentUser.setEmail(email);
        currentUser.setPhone(phone);
        currentUser.setAddress(address);

        session.setAttribute("user", currentUser);
        request.setAttribute("message", "Cập nhật thông tin thành công");

        return "profile.jsp";
    }

    /**
     * ✅ CHANGE PASSWORD - No password hashing
     */
    private String handleChangePassword(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        UserDTO currentUser = (UserDTO) session.getAttribute("user");

        if (currentUser == null) {
            request.setAttribute("message", "Vui lòng đăng nhập để đổi mật khẩu");
            return LOGIN_PAGE;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            request.setAttribute("message", "Vui lòng nhập mật khẩu hiện tại");
            return "changePassword.jsp";
        }

        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("message", "Vui lòng nhập mật khẩu mới");
            return "changePassword.jsp";
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("message", "Mật khẩu mới không khớp");
            return "changePassword.jsp";
        }

        // ✅ NO HASH: Plain text comparison
        if (!currentUser.getPassword().equals(currentPassword)) {
            request.setAttribute("message", "Mật khẩu hiện tại không đúng");
            return "changePassword.jsp";
        }

        UserDAO dao = new UserDAO();
        boolean updated = dao.updatePasswordByUsername(currentUser.getUsername(), newPassword);

        if (updated) {
            currentUser.setPassword(newPassword);
            session.setAttribute("user", currentUser);
            request.setAttribute("success", "Thay đổi mật khẩu thành công. Bạn sẽ được đăng xuất sau 5 giây...");
        } else {
            request.setAttribute("message", "Lỗi khi cập nhật mật khẩu. Vui lòng thử lại.");
        }

        return "changePassword.jsp";
    }

    /**
     * ✅ FORGOT PASSWORD - No password hashing
     */
    private String handleForgotPassword(HttpServletRequest request, HttpServletResponse response) {
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("message", "Vui lòng nhập email để khôi phục mật khẩu");
            return "forgot_password.jsp";
        }

        UserDAO dao = new UserDAO();
        String username = dao.findUsernameByEmail(email);

        if (username != null) {
            String tempPassword = "123456"; // Simple temp password
            boolean updated = dao.updatePasswordByEmail(email, tempPassword);
            if (updated) {
                request.setAttribute("message", "Mật khẩu mới của bạn là: " + tempPassword + ". Vui lòng đăng nhập và đổi mật khẩu.");
            } else {
                request.setAttribute("message", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
            }
        } else {
            request.setAttribute("message", "Email không tồn tại trong hệ thống.");
        }

        return "forgot_password.jsp";
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "User management servlet - NO PASSWORD HASHING VERSION";
    }
}