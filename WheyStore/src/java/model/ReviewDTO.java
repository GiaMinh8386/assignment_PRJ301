package model;

import java.sql.Timestamp;

public class ReviewDTO {
    private int reviewID;
    private String productID;
    private String userID;
    private int rating;
    private String comment;
    private Timestamp reviewDate;
    
    // Thêm các field để hiển thị
    private String userName;      // Tên người dùng
    private String productName;   // Tên sản phẩm

    // Constructors
    public ReviewDTO() {
    }

    public ReviewDTO(int reviewID, String productID, String userID, int rating, String comment, Timestamp reviewDate) {
        this.reviewID = reviewID;
        this.productID = productID;
        this.userID = userID;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = reviewDate;
    }

    // Constructor với userName và productName
    public ReviewDTO(int reviewID, String productID, String userID, int rating, String comment, 
                     Timestamp reviewDate, String userName, String productName) {
        this.reviewID = reviewID;
        this.productID = productID;
        this.userID = userID;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = reviewDate;
        this.userName = userName;
        this.productName = productName;
    }

    // Getters and Setters
    public int getReviewID() {
        return reviewID;
    }

    public void setReviewID(int reviewID) {
        this.reviewID = reviewID;
    }

    public String getProductID() {
        return productID;
    }

    public void setProductID(String productID) {
        this.productID = productID;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Timestamp reviewDate) {
        this.reviewDate = reviewDate;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    // Utility methods
    public String getStarDisplay() {
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars.append("★");
            } else {
                stars.append("☆");
            }
        }
        return stars.toString();
    }

    public String getFormattedDate() {
        if (reviewDate != null) {
            return reviewDate.toString().substring(0, 16); // yyyy-MM-dd HH:mm
        }
        return "";
    }

    @Override
    public String toString() {
        return "ReviewDTO{" +
                "reviewID=" + reviewID +
                ", productID='" + productID + '\'' +
                ", userID='" + userID + '\'' +
                ", rating=" + rating +
                ", comment='" + comment + '\'' +
                ", reviewDate=" + reviewDate +
                ", userName='" + userName + '\'' +
                ", productName='" + productName + '\'' +
                '}';
    }
}