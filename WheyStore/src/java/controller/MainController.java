package controller;

//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.util.List;
//import model.ProductDAO;
//import model.ProductDTO;
//import model.UserDAO;
//import model.UserDTO;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import model.ProductDAO;
import model.ProductDTO;
import model.UserDAO;
import model.UserDTO;
import utils.AuthUtils;

@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    private static final String LOGIN_PAGE = "login.jsp";

    private boolean isUserAction(String action) {
        return "login".equals(action)
                || "logout".equals(action)
                || "register".equals(action)
                || "updateProfile".equals(action)
                || "viewProfile".equals(action)
                || "changePassword".equals(action);
    }

    private boolean isProductAction(String action) {
        return "listProducts".equals(action)
                || "addProduct".equals(action)
                || "updateProduct".equals(action)
                || "deleteProduct".equals(action)
                || "searchProduct".equals(action)
                || "filterByCategory".equals(action)
                || "filterByPrice".equals(action)
                || "filterByBrand".equals(action)
                || "productDetail".equals(action);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        String url = "index.jsp";

        try {
            String action = request.getParameter("action");
            System.out.println("DEBUG MainController - Action received: " + action);

            if (action == null || action.equals("") || action.equals("home")) {
                // FIXED: Load ALL products for home page
                System.out.println("DEBUG MainController - Loading home page with all products");
                ProductDAO dao = new ProductDAO();
                List<ProductDTO> list = dao.getAllProducts();
                System.out.println("DEBUG MainController - Loaded " + (list != null ? list.size() : 0) + " products for home");
                request.setAttribute("products", list);
                url = "index.jsp";
            } else if (isUserAction(action)) {
                System.out.println("DEBUG MainController - Forwarding to UserController");
                url = "UserController"; // FIXED: Remove leading slash
            } else if (isProductAction(action)) {
                System.out.println("DEBUG MainController - Forwarding to ProductController");
                url = "ProductController"; // FIXED: Remove leading slash
            } else {
                // Handle unknown actions
                System.out.println("DEBUG MainController - Unknown action: " + action);
                request.setAttribute("message", "Unknown action: " + action);
                url = "error.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG MainController - Error: " + e.getMessage());
            request.setAttribute("message", "System error occurred: " + e.getMessage());
            url = "error.jsp";
        } finally {
            System.out.println("DEBUG MainController - Final URL: " + url);
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
        return "Main routing servlet with enhanced product search support";
    }
}