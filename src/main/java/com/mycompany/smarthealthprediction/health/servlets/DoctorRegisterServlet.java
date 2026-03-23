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
        String hospitalName = request.getParameter("hospitalName");
        String location = request.getParameter("location");
        String experience = request.getParameter("experience");
        String consultationFee = request.getParameter("consultationFee");
        String availableDays = request.getParameter("availableDaysString");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");
        String slotDuration = request.getParameter("slotDuration");
        
        // ✅ SERVER-SIDE VALIDATION
        if (fullName == null || fullName.trim().length() < 3) {
            response.sendRedirect("doctorRegister.jsp?error=Name must be at least 3 characters");
            return;
        }
        
        if (!ValidationUtil.isValidEmail(email)) {
            response.sendRedirect("doctorRegister.jsp?error=Invalid email format");
            return;
        }
        
        if (!PasswordUtil.isValidPassword(password)) {
            response.sendRedirect("doctorRegister.jsp?error=Password must be at least 8 characters with letters and numbers");
            return;
        }
        
        if (!ValidationUtil.isValidPhone(phone)) {
            response.sendRedirect("doctorRegister.jsp?error=Invalid phone number");
            return;
        }
        
        if (availableDays == null || availableDays.trim().isEmpty()) {
            response.sendRedirect("doctorRegister.jsp?error=Please select at least one available day");
            return;
        }
        
        if (startTime == null || endTime == null || slotDuration == null ||
            startTime.trim().isEmpty() || endTime.trim().isEmpty() || slotDuration.trim().isEmpty()) {
            response.sendRedirect("doctorRegister.jsp?error=Please provide complete time slot information");
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
                response.sendRedirect("doctorRegister.jsp?error=Invalid file type. Please upload an image.");
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
            
            String sql = "INSERT INTO doctors (full_name, email, password, phone, " +
                        "specialization, qualification, hospital_name, location, " +
                        "experience, consultation_fee, available_days, " +
                        "start_time, end_time, slot_duration, profile_photo, status) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'approved')";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, fullName.trim());
            pstmt.setString(2, email.toLowerCase().trim());
            pstmt.setString(3, hashedPassword); // ✅ STORE HASHED PASSWORD
            pstmt.setString(4, phone.trim());
            pstmt.setString(5, specialization);
            pstmt.setString(6, qualification);
            pstmt.setString(7, hospitalName);
            pstmt.setString(8, location);
            pstmt.setInt(9, Integer.parseInt(experience));
            pstmt.setDouble(10, Double.parseDouble(consultationFee));
            pstmt.setString(11, availableDays);
            pstmt.setString(12, startTime);
            pstmt.setString(13, endTime);
            pstmt.setInt(14, Integer.parseInt(slotDuration));
            pstmt.setString(15, photoPath);
            
            int rowsInserted = pstmt.executeUpdate();
            
            if (rowsInserted > 0) {
                // ✅ SEND WELCOME EMAIL (ASYNC)
                final String doctorEmail = email;
                final String doctorName = fullName;
                new Thread(() -> {
                    try {
                        String subject = "Welcome Dr. " + doctorName + " - Smart Health";
                        String body = buildDoctorWelcomeEmail(doctorName);
                        EmailUtil.sendEmail(doctorEmail, subject, body);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }).start();
                
                response.sendRedirect("doctorLogin.jsp?success=Registration successful! Please check your email and login.");
            } else {
                response.sendRedirect("doctorRegister.jsp?error=Registration failed. Please try again.");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getMessage().contains("Duplicate entry")) {
                response.sendRedirect("doctorRegister.jsp?error=Email already registered!");
            } else {
                response.sendRedirect("doctorRegister.jsp?error=Database error occurred.");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("doctorRegister.jsp?error=Invalid number format for experience, consultation fee, or slot duration.");
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
    
    private String buildDoctorWelcomeEmail(String doctorName) {
        return "<!DOCTYPE html><html><body style='margin:0;padding:0;background:#f0f4f8;font-family:Arial,sans-serif;'>"
            + "<div style='max-width:560px;margin:30px auto;background:white;border-radius:16px;overflow:hidden;box-shadow:0 4px 20px rgba(0,0,0,0.1);'>"
            + "<div style='background:#28a745;padding:28px 32px;text-align:center;'>"
            + "<h1 style='color:white;margin:0;font-size:22px;'>❤️ Smart Health</h1>"
            + "<h2 style='color:white;margin:8px 0 0;font-size:18px;font-weight:400;'>Welcome Doctor!</h2>"
            + "</div>"
            + "<div style='padding:28px 32px;'>"
            + "<p style='font-size:16px;color:#333;margin:0 0 16px;'>Dear Dr. " + doctorName + ",</p>"
            + "<p style='font-size:14px;color:#666;margin:0 0 20px;'>Welcome to Smart Health System! Your account has been created successfully.</p>"
            + "<p style='font-size:14px;color:#666;'>As a registered doctor, you can now:</p>"
            + "<ul style='color:#666;font-size:14px;'>"
            + "<li>Manage your appointment schedule</li>"
            + "<li>View and confirm patient appointment requests</li>"
            + "<li>Update your availability and consultation fees</li>"
            + "<li>Access patient medical history</li>"
            + "</ul>"
            + "</div>"
            + "<div style='background:#1a1a2e;padding:16px;text-align:center;'>"
            + "<p style='color:#aaa;font-size:12px;margin:0;'>Smart Health System © 2025</p>"
            + "</div>"
            + "</div></body></html>";
    }
}