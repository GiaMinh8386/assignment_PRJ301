package controller;

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
                case "sync":  // 🔧 FIXED: Added missing case
                    url = handleSyncCart(req, resp);
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
    /* 1. ADD TO CART - ENHANCED FOR BETTER AJAX/FORM HANDLING   */
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

        // 🔧 FIXED: Better error handling for AJAX vs Form submissions
        boolean isAjax = isAjaxRequest(req);

        // Validate product ID
        if (pid == null || pid.trim().isEmpty()) {
            System.out.println("DEBUG handleAdd - Product ID is null or empty");
            return handleError(resp, "Product ID is required!", isAjax);
        }

        /* 1. Check if product exists and is active */
        ProductDTO product = productDAO.getProductByID(pid);
        if (product == null) {
            System.out.println("DEBUG handleAdd - Product not found: " + pid);
            return handleError(resp, "Product not found!", isAjax);
        }

        if (!product.isStatus()) {
            System.out.println("DEBUG handleAdd - Product is inactive: " + pid);
            return handleError(resp, "Product is not available!", isAjax);
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

        /* 5. ENHANCED: Better response handling */
        if (isAjax) {
            // AJAX request - return JSON response
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write("{\"success\": true, \"message\": \"Sản phẩm đã được thêm vào giỏ hàng!\"}");
            System.out.println("DEBUG handleAdd - AJAX response sent");
            return null;
        } else {
            // Form submission - redirect to prevent form resubmission
            String referer = req.getHeader("referer");
            if (referer == null || referer.trim().isEmpty()) {
                referer = req.getContextPath() + "/MainController?action=home";
            }
            
            System.out.println("DEBUG handleAdd - Redirecting to: " + referer);
            resp.sendRedirect(referer);
            return null;
        }
    }

    /*------------------------------------------------------------*/
    /* 2. UPDATE QUANTITY - ENHANCED WITH BETTER ERROR HANDLING  */
    /*------------------------------------------------------------*/
    private String handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws Exception {

        String pid = req.getParameter("productID");
        String qtyRaw = req.getParameter("qty");

        System.out.println("DEBUG handleUpdate - ProductID: " + pid + ", New Quantity: " + qtyRaw);

        boolean isAjax = isAjaxRequest(req);

        if (pid == null || qtyRaw == null) {
            String errorMsg = "Missing parameters for update!";
            System.out.println("DEBUG handleUpdate - " + errorMsg);
            return handleError(resp, errorMsg, isAjax);
        }

        int qty;
        try {
            qty = Integer.parseInt(qtyRaw);
            if (qty < 1) {
                // If quantity is 0 or negative, remove item
                System.out.println("DEBUG handleUpdate - Quantity < 1, removing item");
                return handleRemove(req, resp);
            }
        } catch (NumberFormatException e) {
            String errorMsg = "Invalid quantity: " + qtyRaw;
            System.out.println("DEBUG handleUpdate - " + errorMsg);
            return handleError(resp, errorMsg, isAjax);
        }

        /* Update cart in session */
        HttpSession session = req.getSession(false);
        boolean updateSuccess = false;
        
        if (session != null) {
            Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) session.getAttribute("cart");
            if (cart != null && cart.containsKey(pid)) {
                CartItemDTO item = cart.get(pid);
                item.setQuantity(qty);
                updateSuccess = true;
                System.out.println("DEBUG handleUpdate - Updated quantity in session to: " + qty);
                System.out.println("DEBUG handleUpdate - New line total: " + item.getLineTotal());
            }

            /* Update database if user is logged in */
            UserDTO user = (UserDTO) session.getAttribute("user");
            if (user != null && updateSuccess) {
                try {
                    cartDAO.updateQuantity(user.getUserID(), pid, qty);
                    System.out.println("DEBUG handleUpdate - Updated quantity in database");
                } catch (Exception e) {
                    System.out.println("DEBUG handleUpdate - Database update failed: " + e.getMessage());
                    // Don't fail the whole operation for DB issues
                }
            }
        }

        if (!updateSuccess) {
            String errorMsg = "Item not found in cart or session expired";
            System.out.println("DEBUG handleUpdate - " + errorMsg);
            return handleError(resp, errorMsg, isAjax);
        }

        /* ENHANCED: Better response handling */
        if (isAjax) {
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write("{\"success\": true, \"message\": \"Cập nhật số lượng thành công!\"}");
            System.out.println("DEBUG handleUpdate - AJAX response sent");
            return null;
        } else {
            resp.sendRedirect(req.getContextPath() + "/CartController?action=view");
            return null;
        }
    }

    /*------------------------------------------------------------*/
    /* 3. REMOVE ITEM - ENHANCED                                  */
    /*------------------------------------------------------------*/
    private String handleRemove(HttpServletRequest req, HttpServletResponse resp) throws Exception {

        String pid = req.getParameter("productID");
        System.out.println("DEBUG handleRemove - ProductID: " + pid);

        boolean isAjax = isAjaxRequest(req);

        if (pid == null) {
            String errorMsg = "Product ID is required for removal!";
            return handleError(resp, errorMsg, isAjax);
        }

        /* Remove from session cart */
        boolean removeSuccess = false;
        HttpSession session = req.getSession(false);
        
        if (session != null) {
            Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) session.getAttribute("cart");
            if (cart != null) {
                CartItemDTO removed = cart.remove(pid);
                if (removed != null) {
                    removeSuccess = true;
                    System.out.println("DEBUG handleRemove - Removed from session: " + removed.getProductName());
                }
            }

            /* Remove from database if user is logged in */
            UserDTO user = (UserDTO) session.getAttribute("user");
            if (user != null && removeSuccess) {
                try {
                    cartDAO.remove(user.getUserID(), pid);
                    System.out.println("DEBUG handleRemove - Removed from database");
                } catch (Exception e) {
                    System.out.println("DEBUG handleRemove - Database removal failed: " + e.getMessage());
                }
            }
        }

        if (!removeSuccess) {
            String errorMsg = "Item not found in cart";
            System.out.println("DEBUG handleRemove - " + errorMsg);
            return handleError(resp, errorMsg, isAjax);
        }

        /* ENHANCED: Better response handling */
        if (isAjax) {
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write("{\"success\": true, \"message\": \"Đã xóa sản phẩm khỏi giỏ hàng!\"}");
            System.out.println("DEBUG handleRemove - AJAX response sent");
            return null;
        } else {
            resp.sendRedirect(req.getContextPath() + "/CartController?action=view");
            return null;
        }
    }

    /*------------------------------------------------------------*/
    /* 4. VIEW CART - SAME AS BEFORE                              */
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
    /* 5. CLEAR CART - ENHANCED                                   */
    /*------------------------------------------------------------*/
    private String handleClear(HttpServletRequest req, HttpServletResponse resp) throws Exception {

        System.out.println("DEBUG handleClear - Clearing cart");

        boolean isAjax = isAjaxRequest(req);

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

        /* ENHANCED: Better response handling */
        if (isAjax) {
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write("{\"success\": true, \"message\": \"Đã xóa toàn bộ giỏ hàng!\"}");
            System.out.println("DEBUG handleClear - AJAX response sent");
            return null;
        } else {
            resp.sendRedirect(req.getContextPath() + "/CartController?action=view");
            return null;
        }
    }

    /*------------------------------------------------------------*/
    /* 6. SYNC CART - FIXED TO BE CALLED PROPERLY                */
    /*------------------------------------------------------------*/
    private String handleSyncCart(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        
        System.out.println("DEBUG handleSyncCart - Syncing cart from database");
        
        HttpSession session = req.getSession(false);
        if (session != null) {
            UserDTO user = (UserDTO) session.getAttribute("user");
            if (user != null) {
                try {
                    // Load cart from database
                    List<CartItemDTO> dbCart = cartDAO.getCart(user.getUserID());
                    Map<String, CartItemDTO> cart = new HashMap<>();
                    
                    for (CartItemDTO item : dbCart) {
                        cart.put(item.getProductID(), item);
                    }
                    
                    // Update session
                    session.setAttribute("cart", cart);
                    System.out.println("DEBUG handleSyncCart - Synced " + cart.size() + " items from database");
                    
                    // Return JSON response for AJAX
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    resp.getWriter().write("{\"success\": true, \"itemCount\": " + cart.size() + "}");
                    return null;
                    
                } catch (Exception e) {
                    System.out.println("DEBUG handleSyncCart - Sync failed: " + e.getMessage());
                    resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    resp.getWriter().write("{\"success\": false, \"message\": \"Sync failed\"}");
                    return null;
                }
            }
        }
        
        resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write("{\"success\": false, \"message\": \"User not logged in\"}");
        return null;
    }

    /*------------------------------------------------------------*/
    /* UTILITY METHODS - NEW                                      */
    /*------------------------------------------------------------*/
    
    /**
     * 🔧 FIXED: Better AJAX detection
     */
    private boolean isAjaxRequest(HttpServletRequest req) {
        String requestedWith = req.getHeader("X-Requested-With");
        String contentType = req.getHeader("Content-Type");
        String accept = req.getHeader("Accept");
        
        return "XMLHttpRequest".equals(requestedWith) ||
               (contentType != null && contentType.contains("application/json")) ||
               (accept != null && accept.contains("application/json"));
    }
    
    /**
     * 🔧 FIXED: Unified error handling for AJAX vs Form
     */
    private String handleError(HttpServletResponse resp, String errorMessage, boolean isAjax) throws IOException {
        System.out.println("DEBUG handleError - " + errorMessage + " (isAjax: " + isAjax + ")");
        
        if (isAjax) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write("{\"success\": false, \"message\": \"" + errorMessage + "\"}");
            return null;
        } else {
            // For form submissions, return error page
            return "error.jsp";
        }
    }
}