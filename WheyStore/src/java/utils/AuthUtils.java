/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.UserDTO;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
public class AuthUtils {

    public static UserDTO getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (UserDTO) session.getAttribute("user");
        }
        return null;
    }

    public static boolean isLoggedIn(HttpServletRequest request) {
        return AuthUtils.getCurrentUser(request) != null;
    }

    public static boolean hasRole(HttpServletRequest request, String role) {
        UserDTO user = getCurrentUser(request);
        if (user != null) {
            String userRole = user.getRoleID();
            return userRole.equals(role);
        }
        return false;
    }

    public static boolean isAdmin(HttpServletRequest request) {
        return hasRole(request, "AD");
    }

    public static boolean isStaff(HttpServletRequest request) {
        return hasRole(request, "ST");
    }

    public static boolean isUser(HttpServletRequest request) {
        return hasRole(request, "MB");
    }

    public static String getLoginURL() {
        return "MainController?action=login";
    }

    public static String getAccessDeniedMessage(String action) {
        return "You don't have permission to " + action + ". Please contact administrator.";
    }
}
