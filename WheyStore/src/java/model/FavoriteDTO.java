/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

public class FavoriteDTO {

    private int favoriteID;
    private String userID;
    private String productID;
    private Timestamp addedAt;

    public FavoriteDTO() {
    }

    public FavoriteDTO(int favoriteID, String userID,
            String productID, Timestamp addedAt) {
        this.favoriteID = favoriteID;
        this.userID = userID;
        this.productID = productID;
        this.addedAt = addedAt;
    }

    //── Getter & Setter ────────────────────────────────
    public int getFavoriteID() {
        return favoriteID;
    }

    public void setFavoriteID(int id) {
        this.favoriteID = id;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String uid) {
        this.userID = uid;
    }

    public String getProductID() {
        return productID;
    }

    public void setProductID(String pid) {
        this.productID = pid;
    }

    public Timestamp getAddedAt() {
        return addedAt;
    }

    public void setAddedAt(Timestamp ts) {
        this.addedAt = ts;
    }
}
