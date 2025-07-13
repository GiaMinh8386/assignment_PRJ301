/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;

public class ProductDTO {

    private String id;               // ProductID
    private String name;             // ProductName
    private String description;      // Description
    private String brand;            // Brand
    private double price;            // Price
    private String imageURL;            // ImageURL
    private int categoryId;          // CategoryID
    private boolean status;          // Status (hiện/ẩn)

    // Default constructor
    public ProductDTO() {
    }

    // Full constructor
    public ProductDTO(String id, String name, String description, String brand, double price, String imageURL, int categoryId, boolean status) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.brand = brand;
        this.price = price;
        this.imageURL = imageURL;
        this.categoryId = categoryId;
        this.status = status;
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

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String image) {
        this.imageURL = image;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

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
                + ", image=" + imageURL
                + ", categoryId=" + categoryId
                + ", status=" + status + '}';
    }

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

    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }

    public BigDecimal getPriceBigDec() {
        return BigDecimal.valueOf(price);
    }
}
