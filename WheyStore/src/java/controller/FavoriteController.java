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

/**
 *
 * @author ASUS
 */
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
        String url = null;                 // default: KHÔNG forward nếu null

        try {
            String action = request.getParameter("action");
            System.out.println("DEBUG FavoriteController - Action: " + action);

            if ("toggleFavorite".equals(action)) {
                // xử lý like / unlike
                url = handleToggleFavorite(request, response);  // trả null để không forward
            } else if ("viewFavorites".equals(action)) {
                // (tuỳ chọn) nếu bạn muốn gọi controller thay vì favorite.jsp
                url = handleViewFavorites(request, response);
            } else {
                System.out.println("DEBUG FavoriteController - Unknown action");
                request.setAttribute("message", "Unknown action: " + action);
                url = "error.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message",
                    "System error occurred: " + e.getMessage());
            url = "error.jsp";
        } finally {
            loadCategories(request);

            // Nếu url != null thì forward/redirect
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
     * 1. LIKE / UNLIKE – trả về "liked" hoặc "unliked" (KHÔNG forward)
     *-------------------------------------------------------------*/
    private String handleToggleFavorite(HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        UserDTO user = AuthUtils.getCurrentUser(request);
        if (user == null) {                       // chưa đăng nhập
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return null;                          // không forward
        }

        String pid = request.getParameter("productID");  // productID
        if (pid == null || pid.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }

        boolean likedNow = new FavoriteDAO()
                .toggle(user.getUserID(), pid);

        String referer = request.getHeader("referer");
        return "redirect:" + (referer != null ? referer : "MainController?action=listProducts");
    }

    /*--------------------------------------------------------------
     * 2. (Tuỳ chọn) XEM DANH SÁCH YÊU THÍCH bằng controller
     *-------------------------------------------------------------*/
    private String handleViewFavorites(HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        UserDTO user = AuthUtils.getCurrentUser(request);
        if (user == null) {
            // chuyển hướng tới login
            return "redirect:" + request.getContextPath() + "/login.jsp";
        }

        // Lấy danh sách đã thích
        request.setAttribute("favorites",
                new FavoriteDAO().getFavorites(user.getUserID()));
        return "favorite.jsp";
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
        return "Handle favorite (like/unlike, view list) without touching MainController";
    }
}
