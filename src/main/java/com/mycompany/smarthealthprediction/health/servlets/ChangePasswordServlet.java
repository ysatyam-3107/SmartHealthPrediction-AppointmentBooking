package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

//@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("userLogin.jsp?error=Please login first!");
            return;
        }
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate passwords match
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("userProfile.jsp?error=New passwords do not match!");
            return;
        }
        
        // Validate password length
        if (newPassword.length() < 6) {
            response.sendRedirect("userProfile.jsp?error=Password must be at least 6 characters long!");
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Verify current password
            String verifySql = "SELECT password FROM users WHERE user_id = ?";
            pstmt = conn.prepareStatement(verifySql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                
                // Check if current password matches
                // NOTE: In production, use password hashing (BCrypt)
                if (!storedPassword.equals(currentPassword)) {
                    response.sendRedirect("userProfile.jsp?error=Current password is incorrect!");
                    return;
                }
                
                rs.close();
                pstmt.close();
                
                // Update to new password
                String updateSql = "UPDATE users SET password = ? WHERE user_id = ?";
                pstmt = conn.prepareStatement(updateSql);
                pstmt.setString(1, newPassword); // TODO: Hash this password!
                pstmt.setInt(2, userId);
                
                int rowsUpdated = pstmt.executeUpdate();
                
                if (rowsUpdated > 0) {
                    response.sendRedirect("userProfile.jsp?success=Password changed successfully!");
                } else {
                    response.sendRedirect("userProfile.jsp?error=Failed to change password.");
                }
            } else {
                response.sendRedirect("userProfile.jsp?error=User not found!");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("userProfile.jsp?error=Database error: " + e.getMessage());
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