package utils;

import model.FavoriteDAO;

public class FavoriteUtils {
    
    /**
     * Đếm số lượng sản phẩm yêu thích của user
     */
    public static int getFavoriteCount(String userID) {
        if (userID == null || userID.trim().isEmpty()) {
            return 0;
        }
        
        try {
            FavoriteDAO favoriteDAO = new FavoriteDAO();
            return favoriteDAO.getFavorites(userID).size();
        } catch (Exception e) {
            System.out.println("Error getting favorite count: " + e.getMessage());
            return 0;
        }
    }
    
    /**
     * Kiểm tra xem sản phẩm đã được yêu thích chưa
     */
    public static boolean isFavorited(String userID, String productID) {
        if (userID == null || productID == null) {
            return false;
        }
        
        try {
            FavoriteDAO favoriteDAO = new FavoriteDAO();
            return favoriteDAO.isFavorite(userID, productID);
        } catch (Exception e) {
            System.out.println("Error checking favorite status: " + e.getMessage());
            return false;
        }
    }
}