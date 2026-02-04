package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

//@WebServlet("/UpdateDoctorProfileServlet")
public class UpdateDoctorProfileServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer doctorId = (Integer) session.getAttribute("doctorId");
        
        if (doctorId == null) {
            response.sendRedirect("doctorLogin.jsp?error=Please login first!");
            return;
        }
        
        // Get form parameters
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String hospitalName = request.getParameter("hospitalName");
        String location = request.getParameter("location");
        String experience = request.getParameter("experience");
        String consultationFee = request.getParameter("consultationFee");
        String availableDays = request.getParameter("availableDays");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");
        String slotDuration = request.getParameter("slotDuration");
        
        // Validate inputs
        if (fullName == null || phone == null || hospitalName == null || 
            location == null || experience == null || consultationFee == null ||
            availableDays == null || startTime == null || endTime == null || slotDuration == null) {
            response.sendRedirect("doctorProfile.jsp?error=All fields are required!");
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            String sql = "UPDATE doctors SET full_name = ?, phone = ?, hospital_name = ?, " +
                        "location = ?, experience = ?, consultation_fee = ?, available_days = ?, " +
                        "start_time = ?, end_time = ?, slot_duration = ? " +
                        "WHERE doctor_id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, fullName);
            pstmt.setString(2, phone);
            pstmt.setString(3, hospitalName);
            pstmt.setString(4, location);
            pstmt.setInt(5, Integer.parseInt(experience));
            pstmt.setDouble(6, Double.parseDouble(consultationFee));
            pstmt.setString(7, availableDays);
            pstmt.setString(8, startTime);
            pstmt.setString(9, endTime);
            pstmt.setInt(10, Integer.parseInt(slotDuration));
            pstmt.setInt(11, doctorId);
            
            int rowsUpdated = pstmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                // Update session with new name
                session.setAttribute("doctorName", fullName);
                response.sendRedirect("doctorProfile.jsp?success=Profile updated successfully!");
            } else {
                response.sendRedirect("doctorProfile.jsp?error=Failed to update profile.");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("doctorProfile.jsp?error=Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("doctorProfile.jsp?error=Invalid number format.");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}








