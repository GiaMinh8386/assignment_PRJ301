package model;

import java.math.BigDecimal;

public class OrderDetailDTO {

    private int orderDetailID;   // nếu muốn dùng sau
    private int orderID;
    private String productID;
    private String productName;
    private String imageURL;
    private int quantity;
    private BigDecimal unitPrice;

    public OrderDetailDTO() {
    }

    public OrderDetailDTO(int orderDetailID, int orderID, String productID, String productName, String imageURL, int quantity, BigDecimal unitPrice) {
        this.orderDetailID = orderDetailID;
        this.orderID = orderID;
        this.productID = productID;
        this.productName = productName;
        this.imageURL = imageURL;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }
    
    public int getOrderDetailID() {
        return orderDetailID;
    }

    public void setOrderDetailID(int orderDetailID) {
        this.orderDetailID = orderDetailID;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
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

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    @Override
    public String toString() {
        return "OrderDetailDTO{" + "orderDetailID=" + orderDetailID + ", orderID=" + orderID + ", productID=" + productID + ", quantity=" + quantity + ", unitPrice=" + unitPrice + '}';
    }

}
