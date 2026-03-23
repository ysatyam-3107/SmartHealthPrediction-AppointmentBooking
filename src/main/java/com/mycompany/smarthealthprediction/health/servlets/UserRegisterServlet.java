package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
import com.mycompany.smarthealthprediction.health.util.PasswordUtil;
import com.mycompany.smarthealthprediction.health.util.ValidationUtil;
import com.mycompany.smarthealthprediction.health.util.EmailUtil;
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

//@WebServlet("/UserRegisterServlet")
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,      // 5 MB
    maxRequestSize = 10 * 1024 * 1024   // 10 MB
)
public class UserRegisterServlet extends HttpServlet {
    
    private static final String UPLOAD_DIR = "uploads/users";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String gender = request.getParameter("gender");
        String dob = request.getParameter("dob");
        
        // ✅ SERVER-SIDE VALIDATION
        if (fullName == null || fullName.trim().length() < 3) {
            response.sendRedirect("userRegister.jsp?error=Name must be at least 3 characters");
            return;
        }
        
        if (!ValidationUtil.isValidEmail(email)) {
            response.sendRedirect("userRegister.jsp?error=Invalid email format");
            return;
        }
        
        if (!PasswordUtil.isValidPassword(password)) {
            response.sendRedirect("userRegister.jsp?error=Password must be at least 8 characters with letters and numbers");
            return;
        }
        
        if (!ValidationUtil.isValidPhone(phone)) {
            response.sendRedirect("userRegister.jsp?error=Invalid phone number. Enter 10-digit number starting with 6-9");
            return;
        }
        
        // ✅ HASH PASSWORD USING BCRYPT
        String hashedPassword = PasswordUtil.hashPassword(password);
        
        // Handle file upload
        Part filePart = request.getPart("profilePhoto");
        String photoPath = null;
        
        if (filePart != null && filePart.getSize() > 0) {
            String contentType = filePart.getContentType();
            if (!contentType.startsWith("image/")) {
                response.sendRedirect("userRegister.jsp?error=Invalid file type. Please upload an image.");
                return;
            }
            
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
            
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);
            String filePath = uploadPath + File.separator + fileName;
            
            filePart.write(filePath);
            photoPath = UPLOAD_DIR + "/" + fileName;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            String sql = "INSERT INTO users (full_name, email, password, phone, address, gender, date_of_birth, profile_photo) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, fullName.trim());
            pstmt.setString(2, email.toLowerCase().trim());
            pstmt.setString(3, hashedPassword); // ✅ STORE HASHED PASSWORD
            pstmt.setString(4, phone.trim());
            pstmt.setString(5, address);
            pstmt.setString(6, gender);
            pstmt.setString(7, dob);
            pstmt.setString(8, photoPath);
            
            int rowsInserted = pstmt.executeUpdate();
            
            if (rowsInserted > 0) {
                // ✅ SEND WELCOME EMAIL (ASYNC)
                final String userEmail = email;
                final String userName = fullName;
                new Thread(() -> {
                    try {
                        String subject = "Welcome to Smart Health!";
                        String body = buildWelcomeEmail(userName);
                        EmailUtil.sendEmail(userEmail, subject, body);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }).start();
                
                response.sendRedirect("userLogin.jsp?success=Registration successful! Please check your email and login.");
            } else {
                response.sendRedirect("userRegister.jsp?error=Registration failed. Please try again.");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getMessage().contains("Duplicate entry")) {
                response.sendRedirect("userRegister.jsp?error=Email already registered!");
            } else {
                response.sendRedirect("userRegister.jsp?error=Database error occurred.");
            }
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
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
    
    private String buildWelcomeEmail(String userName) {
        return "<!DOCTYPE html><html><body style='margin:0;padding:0;background:#f0f4f8;font-family:Arial,sans-serif;'>"
            + "<div style='max-width:560px;margin:30px auto;background:white;border-radius:16px;overflow:hidden;box-shadow:0 4px 20px rgba(0,0,0,0.1);'>"
            + "<div style='background:#667eea;padding:28px 32px;text-align:center;'>"
            + "<h1 style='color:white;margin:0;font-size:22px;'>❤️ Smart Health</h1>"
            + "<h2 style='color:white;margin:8px 0 0;font-size:18px;font-weight:400;'>Welcome!</h2>"
            + "</div>"
            + "<div style='padding:28px 32px;'>"
            + "<p style='font-size:16px;color:#333;margin:0 0 16px;'>Hello " + userName + ",</p>"
            + "<p style='font-size:14px;color:#666;margin:0 0 20px;'>Thank you for registering with Smart Health System!</p>"
            + "<p style='font-size:14px;color:#666;'>You can now:</p>"
            + "<ul style='color:#666;font-size:14px;'>"
            + "<li>Book appointments with specialist doctors</li>"
            + "<li>Get AI-powered disease predictions</li>"
            + "<li>Make secure online payments</li>"
            + "<li>Access your medical history</li>"
            + "</ul>"
            + "</div>"
            + "<div style='background:#1a1a2e;padding:16px;text-align:center;'>"
            + "<p style='color:#aaa;font-size:12px;margin:0;'>Smart Health System © 2025</p>"
            + "</div>"
            + "</div></body></html>";
    }
}