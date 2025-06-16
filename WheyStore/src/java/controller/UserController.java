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


//import java.io.IOException;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//import model.UserDAO;
//import model.UserDTO;

/**
 *
 * @author ASUS
 */
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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

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
            request.setAttribute("message", "Invalid username or password");
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
                    // Invalidate session
                    session.invalidate();
                }
            }
        } catch (Exception e) {
        }
        return url;
    }

    private String handleRegister(HttpServletRequest request, HttpServletResponse response) {
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

        boolean success = dao.registerCustomer(fullName, email, phone, address, username, password);

        if (success) {
            request.setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
            return "login.jsp";
        } else {
            request.setAttribute("message", "Đăng ký thất bại. Vui lòng thử lại sau.");
            return "register.jsp";
        }
    }

    private String handleUpdateProfile(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
