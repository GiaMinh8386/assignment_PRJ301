package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

import model.*;

@WebServlet(name = "CartController", urlPatterns = {"/CartController"})
public class CartController extends HttpServlet {

    /*------------------------------------------------------------*/
 /* DAO + tiện ích                                             */
 /*------------------------------------------------------------*/
    private final ProductDAO productDAO = new ProductDAO();
    private final CartItemDAO cartDAO = new CartItemDAO();

    // Header mặc định mà trình duyệt gắn vào khi gọi fetch/AJAX
    private static final String XML_HTTP_REQUEST = "XMLHttpRequest";

    /*------------------------------------------------------------*/
 /* Dispatcher                                                 */
 /*------------------------------------------------------------*/
    @Override
    protected void doGet(HttpServletRequest r, HttpServletResponse s) throws ServletException, IOException {
        processRequest(r, s);
    }

    @Override
    protected void doPost(HttpServletRequest r, HttpServletResponse s) throws ServletException, IOException {
        processRequest(r, s);
    }

    private void processRequest(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) {
            action = "view";          // mặc định
        }
        String url = "error.jsp";

        try {
            switch (action) {
                case "add":
                    url = handleAdd(req, resp);
                    break;
                case "update":
                    url = handleUpdate(req, resp);
                    break;
                case "remove":
                    url = handleRemove(req, resp);
                    break;
                case "view":
                    url = handleView(req, resp);
                    break;
                default:
                    req.setAttribute("message", "Unknown action!");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("message", "System error: " + e.getMessage());
        }

        /* Nếu method đã tự ghi response (trả JSON hoặc redirect) thì url == null */
        if (url != null) {
            req.getRequestDispatcher(url).forward(req, resp);
        }
    }

    /*------------------------------------------------------------*/
 /* 1. ADD                                                     */
 /*------------------------------------------------------------*/
    private String handleAdd(HttpServletRequest req, HttpServletResponse resp) throws Exception {

        String pid    = req.getParameter("productID");
        String qtyRaw = req.getParameter("qty");

        int qty = 1;
        try {
            if (qtyRaw != null)  qty = Integer.parseInt(qtyRaw);
            if (qty < 1)         qty = 1;
        } catch (NumberFormatException ignored) {}

        /* 1. kiểm tra sản phẩm */
        ProductDTO p = productDAO.getProductByID(pid);
        if (p == null || !p.isStatus()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product invalid");
            return null;
        }

        /* 2. lưu giỏ trong session */
        HttpSession session = req.getSession(true);
        Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) session.getAttribute("cart");
        if (cart == null) cart = new HashMap<>();

        CartItemDTO item = cart.get(pid);
        if (item == null) {
            item = new CartItemDTO(pid, p.getName(), p.getPriceBigDec(), qty);
        } else {
            item.setQuantity(item.getQuantity() + qty);
        }
        cart.put(pid, item);
        session.setAttribute("cart", cart);

        /* 3. lưu DB nếu đã đăng nhập */
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user != null) {
            cartDAO.addOrUpdate(user.getUserID(), pid, qty);
        }

        /* 4. luôn redirect về trang gọi */
        String referer = req.getHeader("referer");
        resp.sendRedirect(referer != null ? referer : "CartController?action=view");
        return null;
    }

    /*------------------------------------------------------------*/
    /* 2. UPDATE QUANTITY                                         */
    /*------------------------------------------------------------*/
    private String handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws Exception {

        String pid = req.getParameter("productID");
        int qty    = Integer.parseInt(req.getParameter("qty"));

        HttpSession session = req.getSession(false);
        Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) session.getAttribute("cart");
        if (cart != null && cart.containsKey(pid)) {
            cart.get(pid).setQuantity(qty);
        }

        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user != null) {
            cartDAO.updateQuantity(user.getUserID(), pid, qty);
        }

        resp.sendRedirect(req.getHeader("referer"));
        return null;
    }

    /*------------------------------------------------------------*/
    /* 3. REMOVE                                                  */
    /*------------------------------------------------------------*/
    private String handleRemove(HttpServletRequest req, HttpServletResponse resp) throws Exception {

        String pid = req.getParameter("productID");

        HttpSession session = req.getSession(false);
        Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) session.getAttribute("cart");
        if (cart != null) cart.remove(pid);

        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user != null) {
            cartDAO.remove(user.getUserID(), pid);
        }

        resp.sendRedirect(req.getHeader("referer"));
        return null;
    }

    /*------------------------------------------------------------*/
    /* 4. VIEW CART                                               */
    /*------------------------------------------------------------*/
    private String handleView(HttpServletRequest req, HttpServletResponse resp) throws Exception {

        HttpSession session = req.getSession(true);
        Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) session.getAttribute("cart");

        /* Nếu user đăng nhập lần đầu -> load DB */
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user != null && (cart == null || cart.isEmpty())) {
            List<CartItemDTO> list = cartDAO.getCart(user.getUserID());
            cart = new HashMap<>();
            for (CartItemDTO ci : list) {
                cart.put(ci.getProductID(), ci);
            }
            session.setAttribute("cart", cart);
        }

        req.setAttribute("cartItems", cart);
        return "cart.jsp";
    }
}
