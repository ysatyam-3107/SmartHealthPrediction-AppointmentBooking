package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
import com.mycompany.smarthealthprediction.health.util.PasswordUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

//@WebServlet("/UserLoginServlet")
public class UserLoginServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // ✅ BASIC VALIDATION
        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            response.sendRedirect("userLogin.jsp?error=Email and password are required");
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // ✅ FETCH USER BY EMAIL ONLY (DON'T INCLUDE PASSWORD IN WHERE CLAUSE)
            // This is more secure as we verify password with BCrypt separately
            String sql = "SELECT user_id, full_name, email, password, is_deleted FROM users WHERE email = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email.toLowerCase().trim());
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                int isDeleted = rs.getInt("is_deleted");
                
                // Check if account is soft-deleted
                if (isDeleted == 1) {
                    response.sendRedirect("userLogin.jsp?error=This account has been deleted. Contact support to recover it.");
                    return;
                }
                
                String hashedPassword = rs.getString("password");
                
                // ✅ VERIFY PASSWORD USING BCRYPT
                if (PasswordUtil.verifyPassword(password, hashedPassword)) {
                    // ✅ PASSWORD CORRECT - CREATE SESSION
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", rs.getInt("user_id"));
                    session.setAttribute("userName", rs.getString("full_name"));
                    session.setAttribute("userEmail", rs.getString("email"));
                    session.setAttribute("userType", "user");
                    
                    // ✅ SET SESSION TIMEOUT (30 MINUTES)
                    session.setMaxInactiveInterval(30 * 60);
                    
                    response.sendRedirect("userDashboard.jsp");
                } else {
                    // ✅ INVALID PASSWORD
                    response.sendRedirect("userLogin.jsp?error=Invalid email or password!");
                }
            } else {
                // ✅ USER NOT FOUND
                response.sendRedirect("userLogin.jsp?error=Invalid email or password!");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("userLogin.jsp?error=Database error occurred.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}