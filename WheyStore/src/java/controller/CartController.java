package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import model.*;

@WebServlet(name = "CartController", urlPatterns = {"/CartController"})
public class CartController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CartItemDAO cartDAO = new CartItemDAO();

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
            action = "view";
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

        if (url != null) {
            System.out.println("DEBUG CartController - Forwarding to: " + url);
            req.getRequestDispatcher(url).forward(req, resp);
        }
    }

    private String handleAdd(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String pid = req.getParameter("productID");
        String qtyRaw = req.getParameter("qty");

        System.out.println("DEBUG handleAdd - ProductID: " + pid + ", Quantity: " + qtyRaw);

        int qty = 1;
        try {
            if (qtyRaw != null && !qtyRaw.trim().isEmpty()) {
                qty = Integer.parseInt(qtyRaw);
            }
            if (qty < 1) qty = 1;
        } catch (NumberFormatException e) {
            qty = 1;
        }

        if (pid == null || pid.trim().isEmpty()) {
            req.setAttribute("message", "Product ID is required!");
            return "error.jsp";
        }

        ProductDTO product = productDAO.getProductByID(pid);
        if (product == null || !product.isStatus()) {
            req.setAttribute("message", "Product not available!");
            return "error.jsp";
        }

        HttpSession session = req.getSession(true);
        Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
        }

        CartItemDTO item = cart.get(pid);
        if (item == null) {
            item = new CartItemDTO(pid, product.getName(), product.getPriceBigDec(), qty);
        } else {
            item.setQuantity(item.getQuantity() + qty);
        }
        cart.put(pid, item);
        session.setAttribute("cart", cart);

        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user != null) {
            try {
                cartDAO.addOrUpdate(user.getUserID(), pid, qty);
            } catch (Exception e) {
                System.out.println("DEBUG handleAdd - Database save failed: " + e.getMessage());
            }
        }

        // Simple redirect back to home or cart
        resp.sendRedirect(req.getContextPath() + "/MainController?action=home");
        return null;
    }

    private String handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String pid = req.getParameter("productID");
        String qtyRaw = req.getParameter("qty");

        if (pid == null || qtyRaw == null) {
            req.setAttribute("message", "Missing parameters!");
            return "error.jsp";
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
            return "error.jsp";
        }

        HttpSession session = req.getSession(false);
        if (session != null) {
            Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) session.getAttribute("cart");
            if (cart != null && cart.containsKey(pid)) {
                cart.get(pid).setQuantity(qty);

                UserDTO user = (UserDTO) session.getAttribute("user");
                if (user != null) {
                    try {
                        cartDAO.updateQuantity(user.getUserID(), pid, qty);
                    } catch (Exception e) {
                        System.out.println("DEBUG handleUpdate - Database update failed: " + e.getMessage());
                    }
                }
            }
        }

        resp.sendRedirect(req.getContextPath() + "/CartController?action=view");
        return null;
    }

    private String handleRemove(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String pid = req.getParameter("productID");

        if (pid == null) {
            req.setAttribute("message", "Product ID required!");
            return "error.jsp";
        }

        HttpSession session = req.getSession(false);
        if (session != null) {
            Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) session.getAttribute("cart");
            if (cart != null) {
                cart.remove(pid);

                UserDTO user = (UserDTO) session.getAttribute("user");
                if (user != null) {
                    try {
                        cartDAO.remove(user.getUserID(), pid);
                    } catch (Exception e) {
                        System.out.println("DEBUG handleRemove - Database removal failed: " + e.getMessage());
                    }
                }
            }
        }

        resp.sendRedirect(req.getContextPath() + "/CartController?action=view");
        return null;
    }

    private String handleView(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        HttpSession session = req.getSession(true);
        Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) session.getAttribute("cart");

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
                cart = new HashMap<>();
            }
        }

        if (cart == null) {
            cart = new HashMap<>();
        }

        int totalItems = 0;
        java.math.BigDecimal totalAmount = java.math.BigDecimal.ZERO;
        
        for (CartItemDTO item : cart.values()) {
            totalItems += item.getQuantity();
            totalAmount = totalAmount.add(item.getLineTotal());
        }

        req.setAttribute("cartItems", cart);
        req.setAttribute("totalItems", totalItems);
        req.setAttribute("totalAmount", totalAmount);
        
        System.out.println("DEBUG handleView - Cart summary: " + totalItems + " items, total: " + totalAmount);

        return "cart.jsp";
    }

    private String handleClear(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.removeAttribute("cart");

            UserDTO user = (UserDTO) session.getAttribute("user");
            if (user != null) {
                try {
                    cartDAO.clear(user.getUserID());
                } catch (Exception e) {
                    System.out.println("DEBUG handleClear - Database clear failed: " + e.getMessage());
                }
            }
        }

        resp.sendRedirect(req.getContextPath() + "/CartController?action=view");
        return null;
    }
}