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

//@WebServlet("/CancelAppointmentServlet")
public class CancelAppointmentServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("userLogin.jsp?error=Please login first!");
            return;
        }
        
        String appointmentId = request.getParameter("id");
        
        if (appointmentId == null) {
            response.sendRedirect("userAppointments.jsp?error=Invalid appointment ID");
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Update appointment status to Cancelled
            // Only allow cancellation if the appointment belongs to the logged-in user
            String sql = "UPDATE appointments SET status = 'Cancelled' " +
                        "WHERE appointment_id = ? AND user_id = ? " +
                        "AND status IN ('Pending', 'Confirmed')";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(appointmentId));
            pstmt.setInt(2, userId);
            
            int rowsUpdated = pstmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                response.sendRedirect("userAppointments.jsp?success=Appointment cancelled successfully!");
            } else {
                response.sendRedirect("userAppointments.jsp?error=Cannot cancel this appointment. " +
                                    "It may already be completed or cancelled.");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("userAppointments.jsp?error=Database error occurred while cancelling appointment.");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("userAppointments.jsp?error=Invalid appointment ID format.");
        } finally {
            try {
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