package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

public class ReviewDAO {

    // SQL Constants
    private static final String INSERT_REVIEW = 
        "INSERT INTO tblReviews (productID, userID, rating, comment) VALUES (?, ?, ?, ?)";
    
    private static final String GET_REVIEWS_BY_PRODUCT = 
        "SELECT r.reviewID, r.productID, r.userID, r.rating, r.comment, r.reviewDate, " +
        "       u.fullname as userName, p.productName " +
        "FROM tblReviews r " +
        "JOIN tblUsers u ON r.userID = u.userID " +
        "JOIN tblProducts p ON r.productID = p.productID " +
        "WHERE r.productID = ? " +
        "ORDER BY r.reviewDate DESC";
    
    private static final String GET_REVIEWS_BY_USER = 
        "SELECT r.reviewID, r.productID, r.userID, r.rating, r.comment, r.reviewDate, " +
        "       u.fullname as userName, p.productName " +
        "FROM tblReviews r " +
        "JOIN tblUsers u ON r.userID = u.userID " +
        "JOIN tblProducts p ON r.productID = p.productID " +
        "WHERE r.userID = ? " +
        "ORDER BY r.reviewDate DESC";
    
    private static final String GET_ALL_REVIEWS = 
        "SELECT r.reviewID, r.productID, r.userID, r.rating, r.comment, r.reviewDate, " +
        "       u.fullname as userName, p.productName " +
        "FROM tblReviews r " +
        "JOIN tblUsers u ON r.userID = u.userID " +
        "JOIN tblProducts p ON r.productID = p.productID " +
        "ORDER BY r.reviewDate DESC";
    
    private static final String DELETE_REVIEW = 
        "DELETE FROM tblReviews WHERE reviewID = ?";
    
    private static final String UPDATE_REVIEW = 
        "UPDATE tblReviews SET rating = ?, comment = ? WHERE reviewID = ? AND userID = ?";
    
    private static final String CHECK_USER_REVIEW = 
        "SELECT reviewID FROM tblReviews WHERE productID = ? AND userID = ?";
    
    private static final String GET_AVERAGE_RATING = 
        "SELECT AVG(CAST(rating AS FLOAT)) as avgRating, COUNT(*) as totalReviews " +
        "FROM tblReviews WHERE productID = ?";

    /**
     * Thêm review mới
     */
    public boolean addReview(String productID, String userID, int rating, String comment) throws Exception {
        System.out.println("🔍 ReviewDAO: Adding review - Product: " + productID + ", User: " + userID + ", Rating: " + rating);
        
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_REVIEW)) {
            
            ps.setString(1, productID);
            ps.setString(2, userID);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            
            boolean result = ps.executeUpdate() > 0;
            System.out.println("✅ ReviewDAO: Add review result: " + result);
            return result;
            
        } catch (Exception e) {
            System.err.println("❌ ReviewDAO: Error adding review: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Lấy tất cả review của sản phẩm
     */
    public List<ReviewDTO> getReviewsByProduct(String productID) throws Exception {
        List<ReviewDTO> reviews = new ArrayList<>();
        System.out.println("🔍 ReviewDAO: Getting reviews for product: " + productID);
        
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_REVIEWS_BY_PRODUCT)) {
            
            ps.setString(1, productID);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ReviewDTO review = new ReviewDTO(
                    rs.getInt("reviewID"),
                    rs.getString("productID"),
                    rs.getString("userID"),
                    rs.getInt("rating"),
                    rs.getString("comment"),
                    rs.getTimestamp("reviewDate"),
                    rs.getString("userName"),
                    rs.getString("productName")
                );
                reviews.add(review);
            }
            
            System.out.println("✅ ReviewDAO: Found " + reviews.size() + " reviews for product: " + productID);
            
        } catch (Exception e) {
            System.err.println("❌ ReviewDAO: Error getting reviews by product: " + e.getMessage());
            throw e;
        }
        
        return reviews;
    }

    /**
     * Lấy tất cả review của user
     */
    public List<ReviewDTO> getReviewsByUser(String userID) throws Exception {
        List<ReviewDTO> reviews = new ArrayList<>();
        System.out.println("🔍 ReviewDAO: Getting reviews for user: " + userID);
        
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_REVIEWS_BY_USER)) {
            
            ps.setString(1, userID);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ReviewDTO review = new ReviewDTO(
                    rs.getInt("reviewID"),
                    rs.getString("productID"),
                    rs.getString("userID"),
                    rs.getInt("rating"),
                    rs.getString("comment"),
                    rs.getTimestamp("reviewDate"),
                    rs.getString("userName"),
                    rs.getString("productName")
                );
                reviews.add(review);
            }
            
            System.out.println("✅ ReviewDAO: Found " + reviews.size() + " reviews for user: " + userID);
            
        } catch (Exception e) {
            System.err.println("❌ ReviewDAO: Error getting reviews by user: " + e.getMessage());
            throw e;
        }
        
        return reviews;
    }

    /**
     * Lấy tất cả review (cho admin)
     */
    public List<ReviewDTO> getAllReviews() throws Exception {
        List<ReviewDTO> reviews = new ArrayList<>();
        System.out.println("🔍 ReviewDAO: Getting all reviews");
        
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_ALL_REVIEWS);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                ReviewDTO review = new ReviewDTO(
                    rs.getInt("reviewID"),
                    rs.getString("productID"),
                    rs.getString("userID"),
                    rs.getInt("rating"),
                    rs.getString("comment"),
                    rs.getTimestamp("reviewDate"),
                    rs.getString("userName"),
                    rs.getString("productName")
                );
                reviews.add(review);
            }
            
            System.out.println("✅ ReviewDAO: Found " + reviews.size() + " total reviews");
            
        } catch (Exception e) {
            System.err.println("❌ ReviewDAO: Error getting all reviews: " + e.getMessage());
            throw e;
        }
        
        return reviews;
    }

    /**
     * Xóa review
     */
    public boolean deleteReview(int reviewID) throws Exception {
        System.out.println("🔍 ReviewDAO: Deleting review ID: " + reviewID);
        
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_REVIEW)) {
            
            ps.setInt(1, reviewID);
            boolean result = ps.executeUpdate() > 0;
            System.out.println("✅ ReviewDAO: Delete review result: " + result);
            return result;
            
        } catch (Exception e) {
            System.err.println("❌ ReviewDAO: Error deleting review: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Cập nhật review
     */
    public boolean updateReview(int reviewID, String userID, int rating, String comment) throws Exception {
        System.out.println("🔍 ReviewDAO: Updating review ID: " + reviewID + ", User: " + userID);
        
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_REVIEW)) {
            
            ps.setInt(1, rating);
            ps.setString(2, comment);
            ps.setInt(3, reviewID);
            ps.setString(4, userID);
            
            boolean result = ps.executeUpdate() > 0;
            System.out.println("✅ ReviewDAO: Update review result: " + result);
            return result;
            
        } catch (Exception e) {
            System.err.println("❌ ReviewDAO: Error updating review: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Kiểm tra user đã review sản phẩm chưa
     */
    public boolean hasUserReviewed(String productID, String userID) throws Exception {
        System.out.println("🔍 ReviewDAO: Checking if user " + userID + " has reviewed product " + productID);
        
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(CHECK_USER_REVIEW)) {
            
            ps.setString(1, productID);
            ps.setString(2, userID);
            ResultSet rs = ps.executeQuery();
            
            boolean hasReviewed = rs.next();
            System.out.println("✅ ReviewDAO: User has reviewed: " + hasReviewed);
            return hasReviewed;
            
        } catch (Exception e) {
            System.err.println("❌ ReviewDAO: Error checking user review: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Lấy điểm trung bình và tổng số review của sản phẩm
     */
    public ReviewSummaryDTO getReviewSummary(String productID) throws Exception {
        System.out.println("🔍 ReviewDAO: Getting review summary for product: " + productID);
        
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_AVERAGE_RATING)) {
            
            ps.setString(1, productID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                double avgRating = rs.getDouble("avgRating");
                int totalReviews = rs.getInt("totalReviews");
                
                ReviewSummaryDTO summary = new ReviewSummaryDTO(avgRating, totalReviews);
                System.out.println("✅ ReviewDAO: Review summary - Avg: " + avgRating + ", Total: " + totalReviews);
                return summary;
            }
            
        } catch (Exception e) {
            System.err.println("❌ ReviewDAO: Error getting review summary: " + e.getMessage());
            throw e;
        }
        
        return new ReviewSummaryDTO(0.0, 0);
    }

    /**
     * Inner class cho summary
     */
    public static class ReviewSummaryDTO {
        private double averageRating;
        private int totalReviews;

        public ReviewSummaryDTO(double averageRating, int totalReviews) {
            this.averageRating = averageRating;
            this.totalReviews = totalReviews;
        }

        public double getAverageRating() {
            return averageRating;
        }

        public int getTotalReviews() {
            return totalReviews;
        }

        public String getFormattedRating() {
            return String.format("%.1f", averageRating);
        }

        public String getStarDisplay() {
            StringBuilder stars = new StringBuilder();
            int fullStars = (int) Math.floor(averageRating);
            boolean hasHalfStar = (averageRating - fullStars) >= 0.5;
            
            for (int i = 1; i <= 5; i++) {
                if (i <= fullStars) {
                    stars.append("★");
                } else if (i == fullStars + 1 && hasHalfStar) {
                    stars.append("☆");
                } else {
                    stars.append("☆");
                }
            }
            return stars.toString();
        }
    }
}