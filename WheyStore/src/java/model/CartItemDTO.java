package model;

import java.math.BigDecimal;

public class CartItemDTO {

    private String productID;
    private String productName;      // chỉ dùng session hiển thị
    private String imageURL;
    private BigDecimal unitPrice;
    private int quantity;

    public CartItemDTO() {
    }

    public CartItemDTO(String productID, String productName, String imageURL, BigDecimal unitPrice, int quantity) {
        this.productID = productID;
        this.productName = productName;
        this.imageURL = imageURL;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
    }

    public String getProductID() {
        return productID;
    }

    public void setProductID(String productID) {
        this.productID = productID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getLineTotal() {
        return unitPrice.multiply(BigDecimal.valueOf(quantity));
    }
}
