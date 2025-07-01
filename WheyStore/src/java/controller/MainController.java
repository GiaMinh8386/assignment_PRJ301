package controller;


//import java.io.IOException;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.sql.SQLException;
//import java.util.ArrayList;
//import java.util.List;
//import model.ProductDAO;
//import model.ProductDTO;
//import model.CategoryDAO;
//import model.CategoryDTO;

   import java.io.IOException;
    import java.sql.SQLException;
   import java.util.ArrayList;
    import javax.servlet.ServletException;
   import javax.servlet.annotation.WebServlet;
   import javax.servlet.http.HttpServlet;
   import javax.servlet.http.HttpServletRequest;
   import javax.servlet.http.HttpServletResponse;
   import java.util.List;
   import model.ProductDAO;
   import model.ProductDTO;
   import model.CategoryDAO;
    import model.CategoryDTO;
  


@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    private static final String LOGIN_PAGE = "login.jsp";

    /*--------------------------------------------------------------
     * Utility: Determine action type
     *-------------------------------------------------------------*/
    private boolean isUserAction(String action) {
        return "login".equals(action)
                || "logout".equals(action)
                || "register".equals(action)
                || "updateProfile".equals(action)
                || "viewProfile".equals(action)
                || "changePassword".equals(action)
                || "forgotPassword".equals(action);
    }

    private boolean isProductAction(String action) {
        return "listProducts".equals(action)
                || "addProduct".equals(action)
                || "updateProduct".equals(action)
                || "deleteProduct".equals(action)
                || "searchProduct".equals(action)
                || "filterByCategory".equals(action)
                || "filterByPrice".equals(action)
                || "filterByBrand".equals(action)
                || "productDetail".equals(action);
    }

    private boolean isCartAction(String action) {
        return "add".equals(action)
                || "remove".equals(action)
                || "update".equals(action)
                || "view".equals(action);
    }

    /*--------------------------------------------------------------
     * NEW: Load categories once per request so JSP sidebar can loop
     *-------------------------------------------------------------*/
    private void loadCategories(HttpServletRequest request) {
        try {
            List<CategoryDTO> categories = new CategoryDAO().getAll();
            request.setAttribute("categories", categories);
        } catch (SQLException | ClassNotFoundException ex) {
            log("Cannot load categories", ex);
            // fallback: provide empty list to avoid null check in JSP
            request.setAttribute("categories", new ArrayList<CategoryDTO>());
        }
    }

    /*--------------------------------------------------------------
     * Main dispatcher
     *-------------------------------------------------------------*/
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        String url = "index.jsp";

        try {
            String action = request.getParameter("action");
            System.out.println("DEBUG MainController - Action received: " + action);

            if (action == null || action.isEmpty() || "home".equals(action)) {
                // Load ALL products for home page
                System.out.println("DEBUG MainController - Loading home page with all products");
                ProductDAO dao = new ProductDAO();
                List<ProductDTO> list = dao.getAllProducts();
                System.out.println("DEBUG MainController - Loaded " + (list != null ? list.size() : 0) + " products for home");
                request.setAttribute("products", list);
                url = "index.jsp";
            } else if (isUserAction(action)) {
                System.out.println("DEBUG MainController - Forwarding to UserController");
                url = "UserController";
            } else if (isProductAction(action)) {
                System.out.println("DEBUG MainController - Forwarding to ProductController");
                url = "ProductController";

            } else if (isCartAction(action)) {
                System.out.println("DEBUG MainController - Forwarding to CartController");
                url = "CartController";
            } else {
                System.out.println("DEBUG MainController - Unknown action: " + action);
                request.setAttribute("message", "Unknown action: " + action);
                url = "error.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG MainController - Error: " + e.getMessage());
            request.setAttribute("message", "System error occurred: " + e.getMessage());
            url = "error.jsp";
        } finally {
            // *** BEGIN FIX: always provide category list for sidebar ***
            loadCategories(request);
            // *** END FIX ***
            System.out.println("DEBUG MainController - Final URL: " + url);
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

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
        return "Main routing servlet with enhanced product and category support";
    }
}
