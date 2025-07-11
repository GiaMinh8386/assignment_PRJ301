package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import model.ReviewDAO;
import model.ReviewDTO;
import model.UserDTO;
import model.CategoryDAO;
import model.CategoryDTO;
import utils.AuthUtils;
import java.util.ArrayList;

@WebServlet(name = "ReviewController", urlPatterns = {"/ReviewController"})
public class ReviewController extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAO();

    /*--------------------------------------------------------------
     * NẠP danh mục để sidebar JSP sử dụng
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
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        String url = null;

        try {
            String action = request.getParameter("action");
            System.out.println("DEBUG ReviewController - Action: " + action);

            if ("addReview".equals(action)) {
                url = handleAddReview(request, response);
            } else if ("viewReviews".equals(action)) {
                url = handleViewReviews(request, response);
            } else if ("deleteReview".equals(action)) {
                url = handleDeleteReview(request, response);
            } else if ("updateReview".equals(action)) {
                url = handleUpdateReview(request, response);
            } else if ("viewUserReviews".equals(action)) {
                url = handleViewUserReviews(request, response);
            } else if ("adminViewAllReviews".equals(action)) {
                url = handleAdminViewAllReviews(request, response);
            } else {
                System.out.println("DEBUG ReviewController - Unknown action, redirecting to home");
                url = "redirect:MainController?action=home";
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
     * 1. THÊM REVIEW
     *-------------------------------------------------------------*/
    private String handleAddReview(HttpServletRequest request, HttpServletResponse response) throws Exception {
        UserDTO user = AuthUtils.getCurrentUser(request);
        if (user == null) {
            return "redirect:login.jsp";
        }

        String productID = request.getParameter("productID");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        System.out.println("DEBUG handleAddReview - User: " + user.getUserID() + ", Product: " + productID + ", Rating: " + ratingStr);

        if (productID == null || productID.trim().isEmpty()) {
            request.setAttribute("message", "Product ID is required");
            return "error.jsp";
        }

        if (ratingStr == null || ratingStr.trim().isEmpty()) {
            request.setAttribute("message", "Rating is required");
            return "redirect:MainController?action=productDetail&id=" + productID + "&error=rating_required";
        }

        try {
            int rating = Integer.parseInt(ratingStr);
            if (rating < 1 || rating > 5) {
                request.setAttribute("message", "Rating must be between 1 and 5");
                return "redirect:MainController?action=productDetail&id=" + productID + "&error=invalid_rating";
            }

            // Kiểm tra user đã review chưa
            if (reviewDAO.hasUserReviewed(productID, user.getUserID())) {
                System.out.println("DEBUG handleAddReview - User already reviewed this product");
                return "redirect:MainController?action=productDetail&id=" + productID + "&error=already_reviewed";
            }

            // Thêm review
            boolean success = reviewDAO.addReview(productID, user.getUserID(), rating, comment);
            
            if (success) {
                System.out.println("DEBUG handleAddReview - Review added successfully");
                return "redirect:MainController?action=productDetail&id=" + productID + "&success=review_added";
            } else {
                System.out.println("DEBUG handleAddReview - Failed to add review");
                return "redirect:MainController?action=productDetail&id=" + productID + "&error=add_failed";
            }

        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid rating format");
            return "redirect:MainController?action=productDetail&id=" + productID + "&error=invalid_rating";
        }
    }

    /*--------------------------------------------------------------
     * 2. XEM REVIEWS CỦA SẢN PHẨM
     *-------------------------------------------------------------*/
    private String handleViewReviews(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String productID = request.getParameter("productID");
        
        if (productID == null || productID.trim().isEmpty()) {
            request.setAttribute("message", "Product ID is required");
            return "error.jsp";
        }

        System.out.println("DEBUG handleViewReviews - Loading reviews for product: " + productID);

        try {
            List<ReviewDTO> reviews = reviewDAO.getReviewsByProduct(productID);
            ReviewDAO.ReviewSummaryDTO summary = reviewDAO.getReviewSummary(productID);
            
            request.setAttribute("reviews", reviews);
            request.setAttribute("reviewSummary", summary);
            request.setAttribute("productID", productID);
            
            System.out.println("DEBUG handleViewReviews - Found " + reviews.size() + " reviews");
            
            return "reviewList.jsp";
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG handleViewReviews - Error: " + e.getMessage());
            request.setAttribute("message", "Error loading reviews: " + e.getMessage());
            return "error.jsp";
        }
    }

    /*--------------------------------------------------------------
     * 3. XÓA REVIEW
     *-------------------------------------------------------------*/
    private String handleDeleteReview(HttpServletRequest request, HttpServletResponse response) throws Exception {
        UserDTO user = AuthUtils.getCurrentUser(request);
        if (user == null) {
            return "redirect:login.jsp";
        }

        String reviewIDStr = request.getParameter("reviewID");
        String productID = request.getParameter("productID");
        
        if (reviewIDStr == null || reviewIDStr.trim().isEmpty()) {
            request.setAttribute("message", "Review ID is required");
            return "error.jsp";
        }

        try {
            int reviewID = Integer.parseInt(reviewIDStr);
            System.out.println("DEBUG handleDeleteReview - Deleting review ID: " + reviewID + " by user: " + user.getUserID());

            boolean success = reviewDAO.deleteReview(reviewID);
            
            if (success) {
                System.out.println("DEBUG handleDeleteReview - Review deleted successfully");
                if (productID != null && !productID.trim().isEmpty()) {
                    return "redirect:MainController?action=productDetail&id=" + productID + "&success=review_deleted";
                } else {
                    return "redirect:ReviewController?action=viewUserReviews&success=review_deleted";
                }
            } else {
                System.out.println("DEBUG handleDeleteReview - Failed to delete review");
                return "redirect:MainController?action=productDetail&id=" + productID + "&error=delete_failed";
            }

        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid review ID format");
            return "error.jsp";
        }
    }

    /*--------------------------------------------------------------
     * 4. CẬP NHẬT REVIEW
     *-------------------------------------------------------------*/
    private String handleUpdateReview(HttpServletRequest request, HttpServletResponse response) throws Exception {
        UserDTO user = AuthUtils.getCurrentUser(request);
        if (user == null) {
            return "redirect:login.jsp";
        }

        String reviewIDStr = request.getParameter("reviewID");
        String productID = request.getParameter("productID");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (reviewIDStr == null || ratingStr == null) {
            request.setAttribute("message", "Review ID and rating are required");
            return "error.jsp";
        }

        try {
            int reviewID = Integer.parseInt(reviewIDStr);
            int rating = Integer.parseInt(ratingStr);
            
            if (rating < 1 || rating > 5) {
                request.setAttribute("message", "Rating must be between 1 and 5");
                return "redirect:MainController?action=productDetail&id=" + productID + "&error=invalid_rating";
            }

            System.out.println("DEBUG handleUpdateReview - Updating review ID: " + reviewID + " by user: " + user.getUserID());

            boolean success = reviewDAO.updateReview(reviewID, user.getUserID(), rating, comment);
            
            if (success) {
                System.out.println("DEBUG handleUpdateReview - Review updated successfully");
                return "redirect:MainController?action=productDetail&id=" + productID + "&success=review_updated";
            } else {
                System.out.println("DEBUG handleUpdateReview - Failed to update review");
                return "redirect:MainController?action=productDetail&id=" + productID + "&error=update_failed";
            }

        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid number format");
            return "error.jsp";
        }
    }

    /*--------------------------------------------------------------
     * 5. XEM REVIEWS CỦA USER
     *-------------------------------------------------------------*/
    private String handleViewUserReviews(HttpServletRequest request, HttpServletResponse response) throws Exception {
        UserDTO user = AuthUtils.getCurrentUser(request);
        if (user == null) {
            return "redirect:login.jsp";
        }

        System.out.println("DEBUG handleViewUserReviews - Loading reviews for user: " + user.getUserID());

        try {
            List<ReviewDTO> reviews = reviewDAO.getReviewsByUser(user.getUserID());
            
            request.setAttribute("userReviews", reviews);
            
            System.out.println("DEBUG handleViewUserReviews - Found " + reviews.size() + " reviews for user");
            
            return "userReviews.jsp";
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG handleViewUserReviews - Error: " + e.getMessage());
            request.setAttribute("message", "Error loading your reviews: " + e.getMessage());
            return "error.jsp";
        }
    }

    /*--------------------------------------------------------------
     * 6. ADMIN XEM TẤT CẢ REVIEWS
     *-------------------------------------------------------------*/
    private String handleAdminViewAllReviews(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("message", "Access denied. Admin only.");
            return "error.jsp";
        }

        System.out.println("DEBUG handleAdminViewAllReviews - Loading all reviews for admin");

        try {
            List<ReviewDTO> reviews = reviewDAO.getAllReviews();
            
            request.setAttribute("allReviews", reviews);
            
            System.out.println("DEBUG handleAdminViewAllReviews - Found " + reviews.size() + " total reviews");
            
            return "adminReviews.jsp";
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG handleAdminViewAllReviews - Error: " + e.getMessage());
            request.setAttribute("message", "Error loading all reviews: " + e.getMessage());
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
        return "Handle review operations (add, view, edit, delete)";
    }
}