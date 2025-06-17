/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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

//import java.io.IOException;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//import model.UserDAO;
//import model.UserDTO;

@WebServlet(name = "UserController", urlPatterns = {"/UserController"})
public class UserController extends HttpServlet {

    private static final String WELCOME_PAGE = "welcome.jsp";
    private static final String LOGIN_PAGE = "login.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = LOGIN_PAGE;
        System.out.println("1");
        try {
            String action = request.getParameter("action");
            if ("login".equals(action)) {
                System.out.println("2");
                url = handleLogin(request, response);
            } else if ("logout".equals(action)) {
                url = handleLogout(request, response);
            } else if ("register".equals(action)) {
                url = handleRegister(request, response);
            } else if ("updateProfile".equals(action)) {
                url = handleUpdateProfile(request, response);
            } else {
                request.setAttribute("message", "Invalid action: " + action);
                url = LOGIN_PAGE;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "System error occurred!");
            url = "error.jsp";
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }

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
        return "UserController Servlet";
    }

    private String handleLogin(HttpServletRequest request, HttpServletResponse response) {
        String url = LOGIN_PAGE;
        HttpSession session = request.getSession();
        String strUsername = request.getParameter("strUsername");
        String strPassword = request.getParameter("strPassword");
        UserDAO userDAO = new UserDAO();

        if (userDAO.login(strUsername, strPassword)) {
            UserDTO user = userDAO.getUserById(strUsername);
            session.setAttribute("user", user);
            url = "MainController?action=home"; // chuyen ve trang chu
        } else {
            request.setAttribute("message", "Tên đăng nhập hoặc mật khẩu không đúng!");
        }
        return url;
    }

    private String handleLogout(HttpServletRequest request, HttpServletResponse response) {
        String url = LOGIN_PAGE;
        UserDAO userDAO = new UserDAO();
        try {
            HttpSession session = request.getSession();
            if (session != null) {
                Object objUser = session.getAttribute("user");
                UserDTO user = (objUser != null) ? (UserDTO) objUser : null;
                if (user != null) {
                    //Invalidate session
                    session.invalidate();
                }
            }
        } catch (Exception e) {
        }
        return url;
    }

    private String handleRegister(HttpServletRequest request, HttpServletResponse response) {
        String userID = request.getParameter("userID");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();

        if (dao.isUsernameExist(username)) {
            request.setAttribute("message", "Tên đăng nhập đã tồn tại!");
            return "register.jsp";
        }

        if (dao.isEmailExist(email)) {
            request.setAttribute("message", "Email này đã được sử dụng.");
            return "register.jsp";
        }

        UserDTO newUser = new UserDTO(userID, fullName, email, phone, address, username, password, "MB", true, LocalDateTime.now());
        boolean success = dao.registerCustomer(newUser);

        if (success) {
            request.setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
            return "login.jsp";
        } else {
            request.setAttribute("message", "Đăng ký thất bại. Vui lòng thử lại.");
            return "register.jsp";
        }
    }

    private String handleUpdateProfile(HttpServletRequest request, HttpServletResponse response) {
        request.setAttribute("message", "Chức năng này chưa được hỗ trợ.");
        return "profile.jsp";
    }
}
