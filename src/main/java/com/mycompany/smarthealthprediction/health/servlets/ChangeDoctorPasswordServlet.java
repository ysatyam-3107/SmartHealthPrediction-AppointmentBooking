package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
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

//@WebServlet("/ChangeDoctorPasswordServlet")
public class ChangeDoctorPasswordServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer doctorId = (Integer) session.getAttribute("doctorId");
        
        if (doctorId == null) {
            response.sendRedirect("doctorLogin.jsp?error=Please login first!");
            return;
        }
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate inputs
        if (currentPassword == null || newPassword == null || confirmPassword == null ||
            currentPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            response.sendRedirect("doctorProfile.jsp?error=All password fields are required!");
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("doctorProfile.jsp?error=New passwords do not match!");
            return;
        }
        
        if (newPassword.length() < 6) {
            response.sendRedirect("doctorProfile.jsp?error=New password must be at least 6 characters long!");
            return;
        }
        
        Connection conn = null;
        PreparedStatement checkPstmt = null;
        PreparedStatement updatePstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Verify current password
            String checkSql = "SELECT password FROM doctors WHERE doctor_id = ?";
            checkPstmt = conn.prepareStatement(checkSql);
            checkPstmt.setInt(1, doctorId);
            rs = checkPstmt.executeQuery();
            
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                
                // Check if current password matches
                if (!currentPassword.equals(storedPassword)) {
                    response.sendRedirect("doctorProfile.jsp?error=Current password is incorrect!");
                    return;
                }
                
                // Update to new password
                String updateSql = "UPDATE doctors SET password = ? WHERE doctor_id = ?";
                updatePstmt = conn.prepareStatement(updateSql);
                updatePstmt.setString(1, newPassword);
                updatePstmt.setInt(2, doctorId);
                
                int rowsUpdated = updatePstmt.executeUpdate();
                
                if (rowsUpdated > 0) {
                    response.sendRedirect("doctorProfile.jsp?success=Password changed successfully!");
                } else {
                    response.sendRedirect("doctorProfile.jsp?error=Failed to change password.");
                }
            } else {
                response.sendRedirect("doctorProfile.jsp?error=Doctor account not found.");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("doctorProfile.jsp?error=Database error: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkPstmt != null) checkPstmt.close();
                if (updatePstmt != null) updatePstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}








