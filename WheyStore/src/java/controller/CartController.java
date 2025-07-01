package controller;

//import jakarta.servlet.*;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//import java.util.*;
//import model.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;
import model.*;

@WebServlet(name = "CartController", urlPatterns = {"/CartController"})
public class CartController extends HttpServlet {

    /*------------------------------------------------------------*/
    /* DAO + utilities                                            */
    /*------------------------------------------------------------*/
    private final ProductDAO productDAO = new ProductDAO();
    private final CartItemDAO cartDAO = new CartItemDAO();

    // Header default for AJAX requests
    private static final String XML_HTTP_REQUEST = "XMLHttpRequest";

    /*------------------------------------------------------------*/
    /* Main Dispatcher                                            */
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
            action = "view";          // default
        }
        String url = "error.jsp";

        try {
            System.out.println("DEBUG CartController - Action: " + action);
            
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
                case "clear":
                    url = handleClear(req, resp);
                    break;
                default:
                    req.setAttribute("message", "Unknown action: " + action);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG CartController - Error: " + e.getMessage());
            req.setAttribute("message", "System error: " + e.getMessage());
        }

        /* If method already handled response (JSON or redirect) then url == null */
        if (url != null) {
            System.out.println("DEBUG CartController - Forwarding to: " + url);
            req.getRequestDispatcher(url).forward(req, resp);
        }
    }

    /*------------------------------------------------------------*/
    /* 1. ADD TO CART - FIXED                                     */
    /*------------------------------------------------------------*/
    private String handleAdd(HttpServletRequest req, HttpServletResponse resp) throws Exception {

        String pid = req.getParameter("productID");
        String qtyRaw = req.getParameter("qty");

        System.out.println("DEBUG handleAdd - ProductID: " + pid + ", Quantity: " + qtyRaw);

        // Validate quantity
        int qty = 1;
        try {
            if (qtyRaw != null && !qtyRaw.trim().isEmpty()) {
                qty = Integer.parseInt(qtyRaw);
            }
            if (qty < 1) qty = 1;
        } catch (NumberFormatException e) {
            System.out.println("DEBUG handleAdd - Invalid quantity, using 1");
            qty = 1;
        }

        // Validate product ID
        if (pid == null || pid.trim().isEmpty()) {
            System.out.println("DEBUG handleAdd - Product ID is null or empty");
            req.setAttribute("message", "Product ID is required!");
            return "error.jsp";
        }

        /* 1. Check if product exists and is active */
        ProductDTO product = productDAO.getProductByID(pid);
        if (product == null) {
            System.out.println("DEBUG handleAdd - Product not found: " + pid);
            req.setAttribute("message", "Product not found!");
            return "error.jsp";
        }

        if (!product.isStatus()) {
            System.out.println("DEBUG handleAdd - Product is inactive: " + pid);
            req.setAttribute("message", "Product is not available!");
            return "error.jsp";
        }

        /* 2. Get or create cart in session */
        HttpSession session = req.getSession(true);
        Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
            System.out.println("DEBUG handleAdd - Created new cart");
        }

        /* 3. Add or update item in cart */
        CartItemDTO item = cart.get(pid);
        if (item == null) {
            // Create new cart item
            item = new CartItemDTO(pid, product.getName(), product.getPriceBigDec(), qty);
            System.out.println("DEBUG handleAdd - Created new cart item for: " + product.getName());
        } else {
            // Update existing item quantity
            int newQty = item.getQuantity() + qty;
            item.setQuantity(newQty);
            System.out.println("DEBUG handleAdd - Updated cart item quantity to: " + newQty);
        }
        cart.put(pid, item);
        session.setAttribute("cart", cart);

        /* 4. Save to database if user is logged in */
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user != null) {
            try {
                cartDAO.addOrUpdate(user.getUserID(), pid, qty);
                System.out.println("DEBUG handleAdd - Saved to database for user: " + user.getUserID());
            } catch (Exception e) {
                System.out.println("DEBUG handleAdd - Database save failed: " + e.getMessage());
                // Continue anyway - cart is still in session
            }
        }

        /* 5. FIXED: Always redirect to prevent form resubmission */
        String referer = req.getHeader("referer");
        if (referer == null || referer.trim().isEmpty()) {
            referer = req.getContextPath() + "/MainController?action=home";
        }
        
        System.out.println("DEBUG handleAdd - Redirecting to: " + referer);
        resp.sendRedirect(referer);
        return null; // No forward needed
    }

    /*------------------------------------------------------------*/
    /* 2. UPDATE QUANTITY - FIXED                                 */
    /*------------------------------------------------------------*/
    private String handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws Exception {

        String pid = req.getParameter("productID");
        String qtyRaw = req.getParameter("qty");

        System.out.println("DEBUG handleUpdate - ProductID: " + pid + ", New Quantity: " + qtyRaw);

        if (pid == null || qtyRaw == null) {
            req.setAttribute("message", "Missing parameters for update!");
            return "cart.jsp";
        }

        int qty;
        try {
            qty = Integer.parseInt(qtyRaw);
            if (qty < 1) {
                // If quantity is 0 or negative, remove item
                return handleRemove(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("message", "Invalid quantity!");
            return "cart.jsp";
        }

        /* Update cart in session */
        HttpSession session = req.getSession(false);
        if (session != null) {
            Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) session.getAttribute("cart");
            if (cart != null && cart.containsKey(pid)) {
                cart.get(pid).setQuantity(qty);
                System.out.println("DEBUG handleUpdate - Updated quantity in session");
            }

            /* Update database if user is logged in */
            UserDTO user = (UserDTO) session.getAttribute("user");
            if (user != null) {
                try {
                    cartDAO.updateQuantity(user.getUserID(), pid, qty);
                    System.out.println("DEBUG handleUpdate - Updated quantity in database");
                } catch (Exception e) {
                    System.out.println("DEBUG handleUpdate - Database update failed: " + e.getMessage());
                }
            }
        }

        /* FIXED: Redirect back to cart with context path */
        resp.sendRedirect(req.getContextPath() + "/CartController?action=view");
        return null;
    }

    /*------------------------------------------------------------*/
    /* 3. REMOVE ITEM - FIXED                                     */
    /*------------------------------------------------------------*/
    private String handleRemove(HttpServletRequest req, HttpServletResponse resp) throws Exception {

        String pid = req.getParameter("productID");
        System.out.println("DEBUG handleRemove - ProductID: " + pid);

        if (pid == null) {
            req.setAttribute("message", "Product ID is required for removal!");
            return "cart.jsp";
        }

        /* Remove from session cart */
        HttpSession session = req.getSession(false);
        if (session != null) {
            Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) session.getAttribute("cart");
            if (cart != null) {
                CartItemDTO removed = cart.remove(pid);
                if (removed != null) {
                    System.out.println("DEBUG handleRemove - Removed from session: " + removed.getProductName());
                }
            }

            /* Remove from database if user is logged in */
            UserDTO user = (UserDTO) session.getAttribute("user");
            if (user != null) {
                try {
                    cartDAO.remove(user.getUserID(), pid);
                    System.out.println("DEBUG handleRemove - Removed from database");
                } catch (Exception e) {
                    System.out.println("DEBUG handleRemove - Database removal failed: " + e.getMessage());
                }
            }
        }

        /* FIXED: Redirect back to cart with context path */
        resp.sendRedirect(req.getContextPath() + "/CartController?action=view");
        return null;
    }

    /*------------------------------------------------------------*/
    /* 4. VIEW CART - FIXED                                       */
    /*------------------------------------------------------------*/
    private String handleView(HttpServletRequest req, HttpServletResponse resp) throws Exception {

        HttpSession session = req.getSession(true);
        Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) session.getAttribute("cart");

        /* Load cart from database if user is logged in and cart is empty */
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user != null && (cart == null || cart.isEmpty())) {
            try {
                List<CartItemDTO> dbCart = cartDAO.getCart(user.getUserID());
                cart = new HashMap<>();
                for (CartItemDTO ci : dbCart) {
                    cart.put(ci.getProductID(), ci);
                }
                session.setAttribute("cart", cart);
                System.out.println("DEBUG handleView - Loaded cart from database, items: " + cart.size());
            } catch (Exception e) {
                System.out.println("DEBUG handleView - Failed to load cart from database: " + e.getMessage());
                cart = new HashMap<>(); // Use empty cart
            }
        }

        if (cart == null) {
            cart = new HashMap<>();
        }

        /* Calculate cart summary */
        int totalItems = 0;
        java.math.BigDecimal totalAmount = java.math.BigDecimal.ZERO;
        
        for (CartItemDTO item : cart.values()) {
            totalItems += item.getQuantity();
            totalAmount = totalAmount.add(item.getLineTotal());
        }

        /* Set attributes for JSP */
        req.setAttribute("cartItems", cart);
        req.setAttribute("totalItems", totalItems);
        req.setAttribute("totalAmount", totalAmount);
        
        System.out.println("DEBUG handleView - Cart summary: " + totalItems + " items, total: " + totalAmount);

        return "cart.jsp";
    }

    /*------------------------------------------------------------*/
    /* 5. CLEAR CART - FIXED                                      */
    /*------------------------------------------------------------*/
    private String handleClear(HttpServletRequest req, HttpServletResponse resp) throws Exception {

        System.out.println("DEBUG handleClear - Clearing cart");

        /* Clear session cart */
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.removeAttribute("cart");
            System.out.println("DEBUG handleClear - Cleared session cart");

            /* Clear database cart if user is logged in */
            UserDTO user = (UserDTO) session.getAttribute("user");
            if (user != null) {
                try {
                    cartDAO.clear(user.getUserID());
                    System.out.println("DEBUG handleClear - Cleared database cart");
                } catch (Exception e) {
                    System.out.println("DEBUG handleClear - Database clear failed: " + e.getMessage());
                }
            }
        }

        /* FIXED: Redirect back to cart view with context path */
        resp.sendRedirect(req.getContextPath() + "/CartController?action=view");
        return null;
    }
}