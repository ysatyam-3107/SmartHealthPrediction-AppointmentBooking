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

//@WebServlet("/BookAppointmentServlet")
public class BookAppointmentServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("userLogin.jsp?error=Please login first!");
            return;
        }
        
        String doctorId = request.getParameter("doctorId");
        String appointmentDate = request.getParameter("appointmentDate");
        String appointmentTime = request.getParameter("appointmentTime");
        String symptoms = request.getParameter("symptoms");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO appointments (user_id, doctor_id, appointment_date, appointment_time, symptoms, status) VALUES (?, ?, ?, ?, ?, 'Pending')";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, Integer.parseInt(doctorId));
            pstmt.setString(3, appointmentDate);
            pstmt.setString(4, appointmentTime);
            pstmt.setString(5, symptoms);
            
            int rowsInserted = pstmt.executeUpdate();
            
            if (rowsInserted > 0) {
                response.sendRedirect("userAppointments.jsp?success=Appointment booked successfully!");
            } else {
                response.sendRedirect("bookAppointment.jsp?error=Failed to book appointment.");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("bookAppointment.jsp?error=Database error occurred.");
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