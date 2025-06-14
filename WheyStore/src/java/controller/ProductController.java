/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ProductDAO;
import model.ProductDTO;
import utils.AuthUtils;

//    import java.io.IOException;
//    import javax.servlet.ServletException;
//    import javax.servlet.annotation.WebServlet;
//    import javax.servlet.http.HttpServlet;
//    import javax.servlet.http.HttpServletRequest;
//    import javax.servlet.http.HttpServletResponse;
//    import model.ProductDAO;
//    import model.ProductDTO;
//    import utils.AuthUtils;
@WebServlet(name = "ProductController", urlPatterns = {"/ProductController"})
public class ProductController extends HttpServlet {

    ProductDAO pdao = new ProductDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "";

        try {
            String action = request.getParameter("action");

            if ("addProduct".equals(action)) {
                url = handleProductAdding(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    private String handleProductAdding(HttpServletRequest request, HttpServletResponse response) {
        if (AuthUtils.isAdmin(request)) {
            // Lay thong tin
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String brand = request.getParameter("brand");
            String price = request.getParameter("price");
            String stockQuantity = request.getParameter("stockQuantity");
            String image = request.getParameter("image");
            String productCode = request.getParameter("productCode");
            String categoryId = request.getParameter("categoryId");
            //String status = request.getParameter("status");

            boolean hasError = false;

            if (pdao.isProductExists(id)) {
                request.setAttribute("idError", "This Product ID already exists.");
                hasError = true;
            }

            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("nameError", "Product name cannot be empty.");
                hasError = true;
            }

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

            int stock = 0;
            try {
                stock = Integer.parseInt(stockQuantity);
            } catch (NumberFormatException e) {
                request.setAttribute("stockError", "Stock quantity must be a number.");
                hasError = true;
            }

            int category = 0;
            try {
                category = Integer.parseInt(categoryId);
            } catch (NumberFormatException e) {
                request.setAttribute("categoryError", "Category ID must be a number.");
                hasError = true;
            }

            //boolean status_value = "true".equals(status);
            
            // Giữ lại giá trị đúng đã nhập
            //ProductDTO product = new ProductDTO(id, name, description, brand, price_value, 0, image, productCode, 0);
            ProductDTO product = new ProductDTO(id, name, description, brand, price_value, stock, image, productCode, category);

            request.setAttribute("product", product);

            if (hasError) {
                return "productForm.jsp";
            }

            if (!pdao.create(product)) {
                request.setAttribute("createError", "Can not add product!");
                return "productForm.jsp";
            }

            request.setAttribute("message", "Add product successfully!");
            return "productForm.jsp";
        }
        return "accessDenied.jsp";
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
