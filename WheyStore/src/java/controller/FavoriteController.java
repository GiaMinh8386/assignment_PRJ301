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
import java.util.List;
import model.ProductDAO;
import model.ProductDTO;
import utils.AuthUtils;
import model.CategoryDAO;
import model.CategoryDTO;
import java.util.ArrayList;
import model.FavoriteDAO;
import model.UserDTO;

//import java.io.IOException;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import java.util.List;
//import model.ProductDAO;
//import model.ProductDTO;
//import utils.AuthUtils;
//import model.CategoryDAO;
//import model.CategoryDTO;
//import java.util.ArrayList;
//import model.FavoriteDAO;
//import model.UserDTO;

@WebServlet(name = "FavoriteController", urlPatterns = {"/FavoriteController"})
public class FavoriteController extends HttpServlet {

    /*--------------------------------------------------------------
     * NẠP danh mục để sidebar JSP sử dụng (giống ProductController)
     *-------------------------------------------------------------*/
    private void loadCategories(HttpServletRequest request) {
        try {
            List<CategoryDTO> list = new CategoryDAO().getAll();
            request.setAttribute("categories", list);
        } catch (Exception ex) {
            log("Cannot load categories", ex);
            request.setAttribute("categories", new ArrayList<CategoryDTO>());
        }
    }

    /*--------------------------------------------------------------
     * XỬ LÝ CHÍNH
     *-------------------------------------------------------------*/
    protected void processRequest(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        String url = null;

        try {
            String action = request.getParameter("action");
            System.out.println("DEBUG FavoriteController - Action: " + action);

            if ("toggleFavorite".equals(action)) {
                url = handleToggleFavorite(request, response);
            } else if ("viewFavorites".equals(action)) {
                url = handleViewFavorites(request, response);
            } else {
                System.out.println("DEBUG FavoriteController - Unknown action, redirecting to viewFavorites");
                url = handleViewFavorites(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "System error occurred: " + e.getMessage());
            url = "error.jsp";
        } finally {
            loadCategories(request);

            if (url != null) {
                if (url.startsWith("redirect:")) {
                    response.sendRedirect(url.substring("redirect:".length()));
                } else {
                    request.getRequestDispatcher(url).forward(request, response);
                }
            }
        }
    }

    /*--------------------------------------------------------------
     * 1. LIKE / UNLIKE – toggle favorite status
     *-------------------------------------------------------------*/
    private String handleToggleFavorite(HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        UserDTO user = AuthUtils.getCurrentUser(request);
        if (user == null) {
            return "redirect:login.jsp";
        }

        String pid = request.getParameter("productID");
        if (pid == null || pid.trim().isEmpty()) {
            request.setAttribute("message", "Product ID is required");
            return "error.jsp";
        }

        System.out.println("DEBUG toggleFavorite - User: " + user.getUserID() + ", Product: " + pid);

        try {
            FavoriteDAO favoriteDAO = new FavoriteDAO();
            boolean isNowFavorite = favoriteDAO.toggle(user.getUserID(), pid);
            
            System.out.println("DEBUG toggleFavorite - Result: " + (isNowFavorite ? "Added" : "Removed"));
            
            // Redirect back to the referring page or to favorites list
            String referer = request.getHeader("referer");
            if (referer != null && !referer.isEmpty()) {
                return "redirect:" + referer;
            } else {
                return "redirect:FavoriteController?action=viewFavorites";
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG toggleFavorite - Error: " + e.getMessage());
            request.setAttribute("message", "Error toggling favorite: " + e.getMessage());
            return "error.jsp";
        }
    }

    /*--------------------------------------------------------------
     * 2. XEM DANH SÁCH YÊU THÍCH
     *-------------------------------------------------------------*/
    private String handleViewFavorites(HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        UserDTO user = AuthUtils.getCurrentUser(request);
        if (user == null) {
            return "redirect:login.jsp";
        }

        System.out.println("DEBUG viewFavorites - Loading favorites for user: " + user.getUserID());

        try {
            FavoriteDAO favoriteDAO = new FavoriteDAO();
            List<ProductDTO> favorites = favoriteDAO.getFavorites(user.getUserID());
            
            System.out.println("DEBUG viewFavorites - Found " + (favorites != null ? favorites.size() : 0) + " favorites");
            
            request.setAttribute("favorites", favorites);
            return "favorite.jsp";
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG viewFavorites - Error: " + e.getMessage());
            request.setAttribute("message", "Error loading favorites: " + e.getMessage());
            return "error.jsp";
        }
    }

    /*--------------------------------------------------------------*/
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
        return "Handle favorite operations (toggle, view list)";
    }
}
