package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(name = "UpdatePhotoServlet", urlPatterns = {"/UpdatePhotoServlet"})
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,      // 5 MB
    maxRequestSize = 10 * 1024 * 1024   // 10 MB
)
public class UpdatePhotoServlet extends HttpServlet {
    
    private static final String UPLOAD_DIR = "uploads/users";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("userLogin.jsp?error=Please login first!");
            return;
        }
        
        Part filePart = null;
        try {
            filePart = request.getPart("profilePhoto");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("userProfile.jsp?error=Error processing file upload.");
            return;
        }
        
        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect("userProfile.jsp?error=No file selected!");
            return;
        }
        
        String contentType = filePart.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            response.sendRedirect("userProfile.jsp?error=Invalid file type. Please upload an image.");
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String oldPhotoPath = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Get old photo path to delete it
            String selectSql = "SELECT profile_photo FROM users WHERE user_id = ?";
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                oldPhotoPath = rs.getString("profile_photo");
            }
            
            rs.close();
            pstmt.close();
            
            // Get application path
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
            
            // Create directory if not exists
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Generate unique filename
            String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);
            String filePath = uploadPath + File.separator + fileName;
            
            // Save new file
            filePart.write(filePath);
            
            // Store relative path
            String photoPath = UPLOAD_DIR + "/" + fileName;
            
            // Update database
            String updateSql = "UPDATE users SET profile_photo = ? WHERE user_id = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setString(1, photoPath);
            pstmt.setInt(2, userId);
            
            int rowsUpdated = pstmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                // Delete old photo if exists
                if (oldPhotoPath != null && !oldPhotoPath.isEmpty()) {
                    File oldFile = new File(applicationPath + File.separator + oldPhotoPath);
                    if (oldFile.exists()) {
                        oldFile.delete();
                    }
                }
                
                response.sendRedirect("userProfile.jsp?success=Profile photo updated successfully!");
            } else {
                response.sendRedirect("userProfile.jsp?error=Failed to update photo.");
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
    
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition == null) {
            return "photo_" + System.currentTimeMillis() + ".jpg";
        }
        
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                String filename = token.substring(token.indexOf("=") + 2, token.length() - 1);
                return filename.isEmpty() ? "photo_" + System.currentTimeMillis() + ".jpg" : filename;
            }
        }
        return "photo_" + System.currentTimeMillis() + ".jpg";
    }
}