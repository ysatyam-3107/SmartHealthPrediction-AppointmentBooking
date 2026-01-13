package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
import java.io.File;
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

//@WebServlet("/RemovePhotoServlet")
public class RemovePhotoServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("userLogin.jsp?error=Please login first!");
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Get current photo path
            String selectSql = "SELECT profile_photo FROM users WHERE user_id = ?";
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            String photoPath = null;
            if (rs.next()) {
                photoPath = rs.getString("profile_photo");
            }
            
            rs.close();
            pstmt.close();
            
            // Update database to remove photo
            String updateSql = "UPDATE users SET profile_photo = NULL WHERE user_id = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setInt(1, userId);
            
            int rowsUpdated = pstmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                // Delete physical file
                if (photoPath != null && !photoPath.isEmpty()) {
                    String applicationPath = request.getServletContext().getRealPath("");
                    File photoFile = new File(applicationPath + File.separator + photoPath);
                    if (photoFile.exists()) {
                        photoFile.delete();
                    }
                }
                
                response.sendRedirect("userProfile.jsp?success=Profile photo removed successfully!");
            } else {
                response.sendRedirect("userProfile.jsp?error=Failed to remove photo.");
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
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}