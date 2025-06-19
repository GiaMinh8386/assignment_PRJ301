package controller;

//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.util.List;
//import model.ProductDAO;
//import model.ProductDTO;
//import model.UserDAO;
//import model.UserDTO;

    import java.io.IOException;
    import javax.servlet.ServletException;
    import javax.servlet.annotation.WebServlet;
    import javax.servlet.http.HttpServlet;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;
    import java.util.List;
    import model.ProductDAO;
    import model.ProductDTO;
    import model.UserDAO;
    import model.UserDTO;
    import utils.AuthUtils;
@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    private static final String LOGIN_PAGE = "login.jsp";

    private boolean isUserAction(String action) {
        return "login".equals(action)
                || "logout".equals(action)
                || "register".equals(action)
                || "updateProfile".equals(action)
                || "viewProfile".equals(action)
                || "changePassword".equals(action);
    }

    private boolean isProductAction(String action) {
        return "listProducts".equals(action)
                || "addProduct".equals(action)
                || "updateProduct".equals(action)
                || "deleteProduct".equals(action)
                || "searchProduct".equals(action);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        String url = "index.jsp";  // Mặc định về trang chủ

        try {
            String action = request.getParameter("action");
            if (action == null || action.equals("") || action.equals("home")) {
                // Load danh sách sản phẩm
                ProductDAO dao = new ProductDAO();
                List<ProductDTO> list = dao.getAllProducts();  // chỉ lấy status = 1 đã xử lý ở DAO
                request.setAttribute("products", list);

                System.out.println("=== MainController Debug ===");
                System.out.println("Số lượng sản phẩm lấy được: " + (list != null ? list.size() : 0));
                if (list != null) {
                    for (ProductDTO p : list) {
                        System.out.println("Sản phẩm: " + p.getId() + " - " + p.getName());
                    }
                }

                System.out.println(">>> Product List Size: " + (list != null ? list.size() : "null"));
                for (ProductDTO p : list) {
                    System.out.println(">>> Product: " + p.getId() + " - " + p.getName());
                }
                request.setAttribute("products", list); // Truyền danh sách cho index.jsp
                url = "index.jsp";
            } else if (isUserAction(action)) {
                url = "/UserController";
            } else if (isProductAction(action)) {
                url = "/ProductController";
            } else {
                request.setAttribute("message", "Invalid action: " + action);
            }
        } catch (Exception e) {
            System.err.println("Lỗi trong MainController: " + e.getMessage());
            e.printStackTrace();
        } finally {
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
        return "Main routing servlet";
    }
}
