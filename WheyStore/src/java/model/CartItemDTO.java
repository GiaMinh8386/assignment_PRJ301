package model;

import java.math.BigDecimal;

public class CartItemDTO {
    private String productID;
    private String productName;      // chỉ dùng session hiển thị
    private BigDecimal unitPrice;
    private int quantity;

    public CartItemDTO() {}

    public CartItemDTO(String productID, String productName,
                       BigDecimal unitPrice, int quantity) {
        this.productID   = productID;
        this.productName = productName;
        this.unitPrice   = unitPrice;
        this.quantity    = quantity;
    }

    public String getProductID()     { return productID; }
    public void setProductID(String productID) { this.productID = productID; }

    public String getProductName()   { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public int getQuantity()         { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getLineTotal() {
        return unitPrice.multiply(BigDecimal.valueOf(quantity));
    }
}
