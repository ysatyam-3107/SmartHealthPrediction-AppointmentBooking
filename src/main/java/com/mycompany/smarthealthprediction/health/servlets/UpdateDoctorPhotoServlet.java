package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

//@WebServlet("/UpdateDoctorPhotoServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 5,        // 5MB
    maxRequestSize = 1024 * 1024 * 10     // 10MB
)
public class UpdateDoctorPhotoServlet extends HttpServlet {
    
    // Upload directory - adjust this path to your project structure
    private static final String UPLOAD_DIR = "uploads/doctor-photos";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer doctorId = (Integer) session.getAttribute("doctorId");
        
        if (doctorId == null) {
            response.sendRedirect("doctorLogin.jsp?error=Please login first!");
            return;
        }
        
        Part filePart = request.getPart("profilePhoto");
        
        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect("doctorProfile.jsp?error=Please select a photo to upload.");
            return;
        }
        
        // Validate file type
        String contentType = filePart.getContentType();
        if (!contentType.startsWith("image/")) {
            response.sendRedirect("doctorProfile.jsp?error=Please upload a valid image file.");
            return;
        }
        
        // Get the upload path
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
        
        // Create directory if it doesn't exist
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Generate unique filename
        String fileName = "doctor_" + doctorId + "_" + System.currentTimeMillis() + getFileExtension(filePart);
        String filePath = uploadPath + File.separator + fileName;
        
        // Save file
        try (InputStream fileContent = filePart.getInputStream()) {
            Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            e.printStackTrace();
            response.sendRedirect("doctorProfile.jsp?error=Failed to upload photo: " + e.getMessage());
            return;
        }
        
        // Update database with file path
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Store relative path for use in web pages
            String dbFilePath = UPLOAD_DIR + "/" + fileName;
            
            String sql = "UPDATE doctors SET profile_photo = ? WHERE doctor_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dbFilePath);
            pstmt.setInt(2, doctorId);
            
            int rowsUpdated = pstmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                response.sendRedirect("doctorProfile.jsp?success=Profile photo updated successfully!");
            } else {
                response.sendRedirect("doctorProfile.jsp?error=Failed to update photo in database.");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("doctorProfile.jsp?error=Database error: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private String getFileExtension(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] items = contentDisposition.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                String fileName = item.substring(item.indexOf("=") + 2, item.length() - 1);
                int dotIndex = fileName.lastIndexOf('.');
                if (dotIndex > 0) {
                    return fileName.substring(dotIndex);
                }
            }
        }
        return ".jpg"; // default extension
    }
}








