/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

//import java.io.IOException;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import model.ProductDAO;
//import model.ProductDTO;
//import utils.AuthUtils;

    import java.io.IOException;
    import javax.servlet.ServletException;
    import javax.servlet.annotation.WebServlet;
    import javax.servlet.http.HttpServlet;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;
    import model.ProductDAO;
    import model.ProductDTO;
    import utils.AuthUtils;

/**
 *
 * @author QUOC HUY
 */
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
        String checkError = "";
        String message = "";

        if (AuthUtils.isAdmin(request)) {
            // Lấy dữ liệu từ form
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String image = request.getParameter("image");
            String description = request.getParameter("description");
            String price = request.getParameter("price");
            String brand = request.getParameter("brand");
            String stock = request.getParameter("stockQuantity");
            String productCode = request.getParameter("productCode");
            String categoryId = request.getParameter("categoryId");

            // Chuyển kiểu dữ liệu
            double priceValue = 0;
            int stockQty = 0;
            int catId = 0;

            try {
                priceValue = Double.parseDouble(price);
            } catch (Exception e) {
                checkError += "Price must be a number.<br/>";
            }

            try {
                stockQty = Integer.parseInt(stock);
            } catch (Exception e) {
                checkError += "Stock quantity must be an integer.<br/>";
            }

            try {
                catId = Integer.parseInt(categoryId);
            } catch (Exception e) {
                checkError += "Category ID must be an integer.<br/>";
            }

            // Kiểm tra trùng ID
            if (pdao.isProductExists(id)) {
                checkError += "This Product ID already exists.<br/>";
            }

            // Tạo đối tượng sản phẩm
            ProductDTO product = new ProductDTO(id, name, image, description, priceValue, brand, stockQty, productCode, catId);
            request.setAttribute("product", product);

            // Nếu không có lỗi thì thêm
            if (checkError.isEmpty()) {
                boolean created = pdao.create(product);
                if (created) {
                    message = "Add product successfully!";
                } else {
                    checkError += "Error: Cannot add product to database.<br/>";
                }
            }

            request.setAttribute("checkError", checkError);
            request.setAttribute("message", message);
        } else {
            request.setAttribute("checkError", "Access denied: Admin only.");
        }

        return "productForm.jsp";
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
