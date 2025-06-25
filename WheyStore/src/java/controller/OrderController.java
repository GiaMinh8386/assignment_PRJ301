package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;
import model.CartItemDTO;
import model.OrderDAO;
import model.OrderDTO;
import model.OrderDetailDTO;
import model.UserDTO;
import utils.AuthUtils;
   
@WebServlet(name = "OrderController", urlPatterns = {"/OrderController"})
public class OrderController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    /* ============================================= */
    /*                MAIN DISPATCHER                */
    /* ============================================= */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String url = "error.jsp";

        try {
            switch (action) {
                case "createOrder":
                    url = handleCreateOrder(request, response);
                    break;
                case "viewOrders":
                    url = handleViewOrders(request, response);
                    break;
                case "viewOrderDetail":
                    url = handleViewOrderDetail(request, response);
                    break;
                case "updateOrderStatus":
                    url = handleUpdateOrderStatus(request, response);
                    break;
                default:
                    request.setAttribute("message", "Unknown action!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "System error: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    /* ============================================= */
    /*                 1. CREATE ORDER               */
    /* ============================================= */
    private String handleCreateOrder(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("message", "Please login to checkout!");
            return "login.jsp";
        }

        /* Lấy giỏ hàng */
        Map<String, CartItemDTO> cart = (Map<String, CartItemDTO>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            request.setAttribute("message", "Cart is empty!");
            return "cart.jsp";
        }

        /* Tính tổng & chuẩn bị OrderDetail */
        BigDecimal total = BigDecimal.ZERO;
        List<OrderDetailDTO> details = new ArrayList<>();

        for (CartItemDTO item : cart.values()) {
            BigDecimal line = item.getUnitPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
            total = total.add(line);

            details.add(new OrderDetailDTO(
                    0,          // orderDetailID (identity)
                    0,          // orderID sẽ gán trong DAO
                    item.getProductID(),
                    item.getQuantity(),
                    item.getUnitPrice()
            ));
        }

        /* Tạo OrderDTO */
        UserDTO user = (UserDTO) session.getAttribute("user");
        OrderDTO order = new OrderDTO();
        order.setUserID(user.getUserID());
        order.setTotalAmount(total);
        order.setStatus("Pending");

        /* Lưu DB (transaction) */
        int newOrderId = orderDAO.createOrder(order, details);

        /* Clear cart */
        session.removeAttribute("cart");

        /* Forward dữ liệu */
        request.setAttribute("newOrderId", newOrderId);
        request.setAttribute("orderTotal", total);

        return "checkoutSuccess.jsp";
    }

    /* ============================================= */
    /*              2. VIEW ORDERS BY USER           */
    /* ============================================= */
    private String handleViewOrders(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return "login.jsp";
        }

        UserDTO user = (UserDTO) session.getAttribute("user");
        List<OrderDTO> list = orderDAO.getOrdersByUser(user.getUserID());
        request.setAttribute("orders", list);
        return "orderHistory.jsp";
    }

    /* ============================================= */
    /*              3. VIEW ORDER DETAIL             */
    /* ============================================= */
    private String handleViewOrderDetail(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String idStr = request.getParameter("orderID");
        if (idStr == null) {
            request.setAttribute("message", "Order ID is required");
            return "error.jsp";
        }

        int orderID = Integer.parseInt(idStr);
        List<OrderDTO> tmp = orderDAO.getAllOrders();               // có thể thay bằng getById
        OrderDTO target = tmp.stream()
                             .filter(o -> o.getOrderID() == orderID)
                             .findFirst()
                             .orElse(null);

        if (target == null) {
            request.setAttribute("message", "Order not found");
            return "error.jsp";
        }

        List<OrderDetailDTO> details = orderDAO.getOrderDetails(orderID);
        request.setAttribute("order", target);
        request.setAttribute("orderDetails", details);
        return "orderDetail.jsp";
    }

    /* ============================================= */
    /*           4. ADMIN UPDATE ORDER STATUS        */
    /* ============================================= */
    private String handleUpdateOrderStatus(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (!AuthUtils.isAdmin(request)) {
            return "accessDenied.jsp";
        }

        String idStr = request.getParameter("orderID");
        String newStatus = request.getParameter("status");

        if (idStr == null || newStatus == null) {
            request.setAttribute("message", "Missing parameters!");
            return "error.jsp";
        }

        int orderID = Integer.parseInt(idStr);
        boolean ok = orderDAO.updateStatus(orderID, newStatus);

        request.setAttribute("message",
                ok ? "Update successful!" : "Update failed!");

        List<OrderDTO> list = orderDAO.getAllOrders();
        request.setAttribute("orders", list);
        return "adminOrderList.jsp";
    }

    /* =========== STANDARD SERVLET METHODS ========= */
    @Override protected void doGet (HttpServletRequest r,HttpServletResponse s) throws ServletException,IOException { processRequest(r,s); }
    @Override protected void doPost(HttpServletRequest r,HttpServletResponse s) throws ServletException,IOException { processRequest(r,s); }
    @Override public   String getServletInfo() { return "Order processing servlet"; }
}
