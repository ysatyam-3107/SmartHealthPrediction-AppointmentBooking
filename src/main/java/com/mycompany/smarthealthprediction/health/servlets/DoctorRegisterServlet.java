package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

//@WebServlet("/DoctorRegisterServlet")
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,      // 5 MB
    maxRequestSize = 10 * 1024 * 1024   // 10 MB
)
public class DoctorRegisterServlet extends HttpServlet {
    
    private static final String UPLOAD_DIR = "uploads/doctors";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get all form parameters
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String specialization = request.getParameter("specialization");
        String qualification = request.getParameter("qualification");
        String hospitalName = request.getParameter("hospitalName");      // ✅ ADDED
        String location = request.getParameter("location");              // ✅ ADDED
        String experience = request.getParameter("experience");
        String consultationFee = request.getParameter("consultationFee");
        String availableDays = request.getParameter("availableDays");
        String availableTime = request.getParameter("availableTime");
        
        // Handle file upload
        Part filePart = request.getPart("profilePhoto");
        String photoPath = null;
        
        if (filePart != null && filePart.getSize() > 0) {
            String contentType = filePart.getContentType();
            if (!contentType.startsWith("image/")) {
                response.sendRedirect("doctorRegister.jsp?error=Invalid file type. Please upload an image.");
                return;
            }
            
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
            
            // Save file
            filePart.write(filePath);
            
            // Store relative path
            photoPath = UPLOAD_DIR + "/" + fileName;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // ✅ FIXED SQL - Added hospital_name and location
            String sql = "INSERT INTO doctors (full_name, email, password, phone, " +
                        "specialization, qualification, hospital_name, location, " +
                        "experience, consultation_fee, available_days, available_time, profile_photo) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, fullName);
            pstmt.setString(2, email);
            pstmt.setString(3, password); // TODO: Hash this in production!
            pstmt.setString(4, phone);
            pstmt.setString(5, specialization);
            pstmt.setString(6, qualification);
            pstmt.setString(7, hospitalName);           // ✅ ADDED
            pstmt.setString(8, location);               // ✅ ADDED
            pstmt.setInt(9, Integer.parseInt(experience));
            pstmt.setDouble(10, Double.parseDouble(consultationFee));
            pstmt.setString(11, availableDays);
            pstmt.setString(12, availableTime);
            pstmt.setString(13, photoPath);
            
            int rowsInserted = pstmt.executeUpdate();
            
            if (rowsInserted > 0) {
                response.sendRedirect("doctorLogin.jsp?success=Registration successful! Please login.");
            } else {
                response.sendRedirect("doctorRegister.jsp?error=Registration failed. Please try again.");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getMessage().contains("Duplicate entry")) {
                response.sendRedirect("doctorRegister.jsp?error=Email already exists!");
            } else {
                response.sendRedirect("doctorRegister.jsp?error=Database error: " + e.getMessage());
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("doctorRegister.jsp?error=Invalid number format for experience or consultation fee.");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // Helper method to get filename from multipart request
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "unknown.jpg";
    }
}
