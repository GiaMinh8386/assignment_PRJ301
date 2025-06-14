/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class ProductDTO {

    private String id;               // ProductID
    private String name;             // ProductName
    private String description;      // Description
    private String brand;            // Brand
    private double price;            // Price
    private int stockQuantity;       // StockQuantity
    private String image;            // ImageURL
    private String productCode;      // ProductCode
    private int categoryId;          // CategoryID

    // Default constructor
    public ProductDTO() {
    }

    // Full constructor
    public ProductDTO(String id, String name, String description, String brand, double price, int stockQuantity, String image, String productCode, int categoryId) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.brand = brand;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.image = image;
        this.productCode = productCode;
        this.categoryId = categoryId;
    }

    // Getters & Setters
    public String getId() {
        return id;
    }
    
    public void setId(String id) {    
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    // Optional: format price for display
    public String getFormattedPrice() {
        return String.format("%,.0f ₫", price); // ví dụ: 1,200,000 ₫
    }

    @Override
    public String toString() {
        return "ProductDTO{" + "id=" + id
                + ", name=" + name
                + ", description=" + description
                + ", brand=" + brand
                + ", price=" + price
                + ", stockQuantity=" + stockQuantity
                + ", image=" + image
                + ", productCode=" + productCode
                + ", categoryId=" + categoryId + '}';
    }

    // equals method for comparison
    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        ProductDTO that = (ProductDTO) obj;
        return id != null ? id.equals(that.id) : that.id == null;
    }

    // hashCode method
    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }

}
