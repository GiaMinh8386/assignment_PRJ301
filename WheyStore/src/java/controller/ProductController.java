package controller;

//import java.io.IOException;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.util.List;
//import model.ProductDAO;
//import model.ProductDTO;
//import utils.AuthUtils;
//import model.CategoryDAO;
//import model.CategoryDTO;
//import java.util.ArrayList;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.ProductDAO;
import model.ProductDTO;
import utils.AuthUtils;
import java.util.List;
import model.CategoryDAO;
import model.CategoryDTO;
import java.util.ArrayList;

@WebServlet(name = "ProductController", urlPatterns = {"/ProductController"})
public class ProductController extends HttpServlet {

    ProductDAO pdao = new ProductDAO();
    
    private void loadCategories(HttpServletRequest request) {
        try {
            List<CategoryDTO> list = new CategoryDAO().getAll();
            request.setAttribute("categories", list);
        } catch (Exception ex) {
            log("Cannot load categories", ex);
            request.setAttribute("categories", new ArrayList<CategoryDTO>());
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "index.jsp";

        try {
            String action = request.getParameter("action");
            System.out.println("DEBUG ProductController - Action received: " + action);

            if ("addProduct".equals(action)) {
                url = handleProductAdding(request, response);
            } else if ("listProducts".equals(action)) {
                url = handleListProducts(request, response);
            } else if ("listAllProducts".equals(action)) {
                // FIX 1: ✅ FIXED - Proper handling for dashboard all products view
                url = handleListAllProductsInDashboard(request, response);
            } else if ("searchProduct".equals(action)) {
                url = handleSearchProduct(request, response);
            } else if ("filterByCategory".equals(action)) {
                url = handleFilterByCategory(request, response);
            } else if ("filterByPrice".equals(action)) {
                url = handleFilterByPrice(request, response);
            } else if ("filterByBrand".equals(action)) {
                url = handleFilterByBrand(request, response);
            } else if ("productDetail".equals(action)) {
                url = handleProductDetail(request, response);
            } else if ("adminDashboard".equals(action)) {
                url = handleAdminDashboard(request, response);
            } else if ("editProduct".equals(action)) {
                url = handleEditProduct(request, response);
            } else if ("updateProduct".equals(action)) {
                url = handleUpdateProduct(request, response);
            } else if ("deleteProduct".equals(action)) {
                url = handleDeleteProduct(request, response);
            } else {
                System.out.println("DEBUG ProductController - Unknown action, using default");
                url = "index.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "System error occurred: " + e.getMessage());
            url = "error.jsp";
        } finally {
            loadCategories(request);
            System.out.println("DEBUG ProductController - Forwarding to: " + url);
            
            // FIX 1: ✅ Only redirect for listAllProducts, forward for others
            if (url != null && url.startsWith("redirect:")) {
                String redirectUrl = url.substring("redirect:".length());
                response.sendRedirect(redirectUrl);
            } else if (url != null) {
                request.getRequestDispatcher(url).forward(request, response);
            }
        }
    }

    /**
     * FIX 1: ✅ FIXED - Handle Admin Dashboard with proper all products display
     */
    private String handleAdminDashboard(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("message", "Bạn không có quyền truy cập trang này!");
            return "error.jsp";
        }
        
        try {
            System.out.println("DEBUG handleAdminDashboard - Loading dashboard data...");
            
            // Check if we should show all products or just preview
            String showAll = request.getParameter("showAll");
            
            // Load all products for dashboard
            List<ProductDTO> allProducts = pdao.getAllProducts();
            request.setAttribute("allProducts", allProducts);
            
            // FIX 1: ✅ FIXED - Proper handling of showAll parameter
            if ("true".equals(showAll)) {
                request.setAttribute("showAllProducts", true);
                System.out.println("DEBUG handleAdminDashboard - Showing all " + (allProducts != null ? allProducts.size() : 0) + " products");
            } else {
                request.setAttribute("showAllProducts", false);
                System.out.println("DEBUG handleAdminDashboard - Showing preview (10 products max)");
            }
            
            // Calculate statistics
            int totalProducts = allProducts != null ? allProducts.size() : 0;
            int activeProducts = 0;
            int inactiveProducts = 0;
            
            if (allProducts != null) {
                for (ProductDTO p : allProducts) {
                    if (p.isStatus()) {
                        activeProducts++;
                    } else {
                        inactiveProducts++;
                    }
                }
            }
            
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("activeProducts", activeProducts);
            request.setAttribute("inactiveProducts", inactiveProducts);
            
            System.out.println("DEBUG handleAdminDashboard - Stats: Total=" + totalProducts + 
                             ", Active=" + activeProducts + ", Inactive=" + inactiveProducts);
            
            return "adminDashboard.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error loading dashboard: " + e.getMessage());
            return "error.jsp";
        }
    }

    /**
     * FIX 1: ✅ FIXED - Handle list all products in dashboard properly
     */
    private String handleListAllProductsInDashboard(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("message", "Bạn không có quyền truy cập trang này!");
            return "error.jsp";
        }
        
        try {
            System.out.println("DEBUG handleListAllProductsInDashboard - Loading all products in dashboard");
            
            // Load all products for dashboard
            List<ProductDTO> allProducts = pdao.getAllProducts();
            request.setAttribute("allProducts", allProducts);
            request.setAttribute("showAllProducts", true); // Show all products
            
            // Calculate statistics
            int totalProducts = allProducts != null ? allProducts.size() : 0;
            int activeProducts = 0;
            int inactiveProducts = 0;
            
            if (allProducts != null) {
                for (ProductDTO p : allProducts) {
                    if (p.isStatus()) {
                        activeProducts++;
                    } else {
                        inactiveProducts++;
                    }
                }
            }
            
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("activeProducts", activeProducts);
            request.setAttribute("inactiveProducts", inactiveProducts);
            
            System.out.println("DEBUG handleListAllProductsInDashboard - Loaded " + totalProducts + " products");
            
            return "adminDashboard.jsp"; // Return to dashboard with all products shown
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error loading all products: " + e.getMessage());
            return "error.jsp";
        }
    }

    /**
     * Handle listing all products
     */
    private String handleListProducts(HttpServletRequest request, HttpServletResponse response) {
        try {
            System.out.println("DEBUG handleListProducts - Starting...");
            List<ProductDTO> products = pdao.getAllProducts();
            System.out.println("DEBUG handleListProducts - Found " + (products != null ? products.size() : 0) + " products");
            
            request.setAttribute("products", products);
            request.setAttribute("pageTitle", "Tất cả sản phẩm");
            return "index.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error loading products: " + e.getMessage());
            return "error.jsp";
        }
    }

    /**
     * Handle product search - FIXED
     */
    private String handleSearchProduct(HttpServletRequest request, HttpServletResponse response) {
        try {
            String keyword = request.getParameter("keyword");
            String category = request.getParameter("category");
            
            System.out.println("DEBUG handleSearchProduct - Keyword: " + keyword);
            System.out.println("DEBUG handleSearchProduct - Category: " + category);
            
            List<ProductDTO> products;
            
            // If category is specified, filter by category and keyword
            if (category != null && !category.trim().isEmpty() && !category.equals("")) {
                try {
                    int categoryId = Integer.parseInt(category);
                    System.out.println("DEBUG handleSearchProduct - Filtering by category: " + categoryId);
                    
                    if (keyword != null && !keyword.trim().isEmpty()) {
                        // Search within category
                        products = pdao.filterProducts(keyword, categoryId, null, null, null);
                        System.out.println("DEBUG handleSearchProduct - Search with category and keyword");
                    } else {
                        // Just filter by category
                        products = pdao.getProductsByCategory(categoryId);
                        System.out.println("DEBUG handleSearchProduct - Filter by category only");
                    }
                } catch (NumberFormatException e) {
                    // If category is not a number, search by keyword only
                    System.out.println("DEBUG handleSearchProduct - Invalid category, search by keyword");
                    products = pdao.searchProducts(keyword);
                }
            } else {
                // Search by keyword only
                System.out.println("DEBUG handleSearchProduct - Search by keyword only");
                products = pdao.searchProducts(keyword);
            }
            
            System.out.println("DEBUG handleSearchProduct - Final result: " + (products != null ? products.size() : 0) + " products");
            
            request.setAttribute("products", products);
            request.setAttribute("searchKeyword", keyword);
            request.setAttribute("pageTitle", "Kết quả tìm kiếm" + (keyword != null ? " cho: " + keyword : ""));
            
            return "index.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error searching products: " + e.getMessage());
            return "error.jsp";
        }
    }

    /**
     * Handle filter by category - FIXED
     */
    private String handleFilterByCategory(HttpServletRequest request, HttpServletResponse response) {
        try {
            String categoryIdStr = request.getParameter("categoryId");
            System.out.println("DEBUG handleFilterByCategory - CategoryId: " + categoryIdStr);
            
            if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                return handleListProducts(request, response);
            }
            
            int categoryId = Integer.parseInt(categoryIdStr);
            List<ProductDTO> products = pdao.getProductsByCategory(categoryId);
            
            System.out.println("DEBUG handleFilterByCategory - Found " + (products != null ? products.size() : 0) + " products for category " + categoryId);
            
            request.setAttribute("products", products);
            request.setAttribute("selectedCategory", categoryId);
            request.setAttribute("pageTitle", "Sản phẩm theo danh mục " + categoryId);
            
            return "index.jsp";
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("message", "Invalid category ID!");
            return "error.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error filtering by category: " + e.getMessage());
            return "error.jsp";
        }
    }

    /**
     * Handle filter by price range - FIXED
     */
    private String handleFilterByPrice(HttpServletRequest request, HttpServletResponse response) {
        try {
            String priceRange = request.getParameter("priceRange");
            System.out.println("DEBUG handleFilterByPrice - PriceRange: " + priceRange);
            
            if (priceRange == null || priceRange.trim().isEmpty()) {
                return handleListProducts(request, response);
            }
            
            String[] range = priceRange.split("-");
            if (range.length != 2) {
                request.setAttribute("message", "Invalid price range format!");
                return "error.jsp";
            }
            
            double minPrice = Double.parseDouble(range[0]);
            double maxPrice = Double.parseDouble(range[1]);
            
            System.out.println("DEBUG handleFilterByPrice - Price range: " + minPrice + " - " + maxPrice);
            
            List<ProductDTO> products = pdao.getProductsByPriceRange(minPrice, maxPrice);
            
            System.out.println("DEBUG handleFilterByPrice - Found " + (products != null ? products.size() : 0) + " products");
            
            request.setAttribute("products", products);
            request.setAttribute("selectedPriceRange", priceRange);
            request.setAttribute("pageTitle", "Sản phẩm từ " + String.format("%,.0f", minPrice) + "₫ - " + String.format("%,.0f", maxPrice) + "₫");
            
            return "index.jsp";
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("message", "Invalid price range!");
            return "error.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error filtering by price: " + e.getMessage());
            return "error.jsp";
        }
    }

    /**
     * Handle filter by brand - FIXED
     */
    private String handleFilterByBrand(HttpServletRequest request, HttpServletResponse response) {
        try {
            String brand = request.getParameter("brand");
            System.out.println("DEBUG handleFilterByBrand - Brand: " + brand);
            
            if (brand == null || brand.trim().isEmpty()) {
                return handleListProducts(request, response);
            }
            
            List<ProductDTO> products = pdao.getProductsByBrand(brand);
            
            System.out.println("DEBUG handleFilterByBrand - Found " + (products != null ? products.size() : 0) + " products");
            
            request.setAttribute("products", products);
            request.setAttribute("selectedBrand", brand);
            request.setAttribute("pageTitle", "Sản phẩm thương hiệu: " + brand);
            
            return "index.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error filtering by brand: " + e.getMessage());
            return "error.jsp";
        }
    }

    /**
     * Handle product detail view
     */
    private String handleProductDetail(HttpServletRequest request, HttpServletResponse response) {
        try {
            String productId = request.getParameter("id");
            System.out.println("DEBUG handleProductDetail - ProductId: " + productId);
            
            if (productId == null || productId.trim().isEmpty()) {
                request.setAttribute("message", "Product ID is required!");
                return "error.jsp";
            }
            
            ProductDTO product = pdao.getProductByID(productId);
            if (product == null) {
                request.setAttribute("message", "Product not found!");
                return "error.jsp";
            }
            
            request.setAttribute("product", product);
            return "productDetail.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error loading product detail: " + e.getMessage());
            return "error.jsp";
        }
    }

    /**
     * Handle Edit Product
     */
    private String handleEditProduct(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("message", "Bạn không có quyền chỉnh sửa sản phẩm!");
            return "error.jsp";
        }
        
        try {
            String productId = request.getParameter("id");
            System.out.println("DEBUG handleEditProduct - ProductId: " + productId);
            
            if (productId == null || productId.trim().isEmpty()) {
                request.setAttribute("message", "Product ID is required!");
                return "error.jsp";
            }
            
            ProductDTO product = pdao.getProductByID(productId);
            if (product == null) {
                request.setAttribute("message", "Product not found!");
                return "error.jsp";
            }
            
            request.setAttribute("product", product);
            request.setAttribute("isEdit", true);
            return "productForm.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error loading product for edit: " + e.getMessage());
            return "error.jsp";
        }
    }

    /**
     * Handle Update Product
     */
    private String handleUpdateProduct(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("message", "Bạn không có quyền cập nhật sản phẩm!");
            return "error.jsp";
        }
        
        try {
            // Get form data
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String brand = request.getParameter("brand");
            String price = request.getParameter("price");
            String image = request.getParameter("image");
            String categoryId = request.getParameter("categoryId");
            String status = request.getParameter("status");

            boolean hasError = false;

            // Validate product name
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("nameError", "Product name cannot be empty.");
                hasError = true;
            }

            // Validate price
            double price_value = 0;
            try {
                price_value = Double.parseDouble(price);
                if (price_value < 0) {
                    request.setAttribute("priceError", "Price must be greater than zero.");
                    hasError = true;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("priceError", "Price must be a number.");
                hasError = true;
            }

            // Validate category
            int category = 0;
            try {
                category = Integer.parseInt(categoryId);
            } catch (NumberFormatException e) {
                request.setAttribute("categoryError", "Category ID must be a number.");
                hasError = true;
            }

            // Set default status if not provided
            boolean status_value = "true".equals(status);

            // Create product object to retain form values
            ProductDTO product = new ProductDTO(id, name, description, brand, price_value, image, category, status_value);
            request.setAttribute("product", product);
            request.setAttribute("isEdit", true);

            if (hasError) {
                return "productForm.jsp";
            }

            // Try to update product
            if (!pdao.update(product)) {
                request.setAttribute("updateError", "Cannot update product!");
                return "productForm.jsp";
            }

            request.setAttribute("message", "Update product successfully!");
            return "redirect:" + request.getContextPath() + "/ProductController?action=adminDashboard";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error updating product: " + e.getMessage());
            return "error.jsp";
        }
    }

    /**
     * Handle Delete Product
     */
    private String handleDeleteProduct(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("message", "Bạn không có quyền xóa sản phẩm!");
            return "error.jsp";
        }
        
        try {
            String productId = request.getParameter("id");
            System.out.println("DEBUG handleDeleteProduct - ProductId: " + productId);
            
            if (productId == null || productId.trim().isEmpty()) {
                request.setAttribute("message", "Product ID is required!");
                return "error.jsp";
            }
            
            if (pdao.delete(productId)) {
                System.out.println("DEBUG handleDeleteProduct - Product deleted successfully");
                return "redirect:" + request.getContextPath() + "/ProductController?action=adminDashboard";
            } else {
                request.setAttribute("message", "Cannot delete product!");
                return "error.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error deleting product: " + e.getMessage());
            return "error.jsp";
        }
    }

    /**
     * FIX 2: ✅ FIXED - Enhanced product adding with proper navigation
     */
    private String handleProductAdding(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("message", "Bạn không có quyền thêm sản phẩm!");
            return "error.jsp";
        }
        
        // Get form data
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String brand = request.getParameter("brand");
        String price = request.getParameter("price");
        String image = request.getParameter("image");
        String categoryId = request.getParameter("categoryId");
        String status = request.getParameter("status");

        boolean hasError = false;

        // Validate product ID
        if (pdao.isProductExists(id)) {
            request.setAttribute("idError", "This Product ID already exists.");
            hasError = true;
        }

        // Validate product name
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("nameError", "Product name cannot be empty.");
            hasError = true;
        }

        // Validate price
        double price_value = 0;
        try {
            price_value = Double.parseDouble(price);
            if (price_value < 0) {
                request.setAttribute("priceError", "Price must be greater than zero.");
                hasError = true;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("priceError", "Price must be a number.");
            hasError = true;
        }

        // Validate category
        int category = 0;
        try {
            category = Integer.parseInt(categoryId);
        } catch (NumberFormatException e) {
            request.setAttribute("categoryError", "Category ID must be a number.");
            hasError = true;
        }

        // Set default status if not provided
        boolean status_value = "true".equals(status) || status == null; // Default to true

        // Create product object to retain form values
        ProductDTO product = new ProductDTO(id, name, description, brand, price_value, image, category, status_value);
        request.setAttribute("product", product);

        if (hasError) {
            return "productForm.jsp";
        }

        // Try to create product
        if (!pdao.create(product)) {
            request.setAttribute("createError", "Cannot add product!");
            return "productForm.jsp";
        }

        // FIX 2: ✅ FIXED - Set success message and show navigation buttons
        request.setAttribute("message", "Thêm sản phẩm thành công!");
        request.setAttribute("showSuccessActions", true);
        return "productForm.jsp";
    }

    // Standard servlet methods
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
        return "Product management servlet with enhanced search functionality and admin dashboard";
    }
}