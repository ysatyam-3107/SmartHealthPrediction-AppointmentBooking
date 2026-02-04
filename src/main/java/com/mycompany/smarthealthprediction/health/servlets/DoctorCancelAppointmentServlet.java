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

//@WebServlet("/DoctorCancelAppointmentServlet")
public class DoctorCancelAppointmentServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer doctorId = (Integer) session.getAttribute("doctorId");
        
        if (doctorId == null) {
            response.sendRedirect("doctorLogin.jsp?error=Please login first!");
            return;
        }
        
        String appointmentId = request.getParameter("id");
        String reason = request.getParameter("reason"); // Optional: cancellation reason
        
        if (appointmentId == null || appointmentId.trim().isEmpty()) {
            response.sendRedirect("doctorAppointments.jsp?error=Invalid appointment ID");
            return;
        }
        
        Connection conn = null;
        PreparedStatement checkPstmt = null;
        PreparedStatement updatePstmt = null;
        PreparedStatement notePstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Verify the appointment belongs to this doctor
            String checkSql = "SELECT status, appointment_date, appointment_time, user_id FROM appointments " +
                            "WHERE appointment_id = ? AND doctor_id = ?";
            checkPstmt = conn.prepareStatement(checkSql);
            checkPstmt.setInt(1, Integer.parseInt(appointmentId));
            checkPstmt.setInt(2, doctorId);
            rs = checkPstmt.executeQuery();
            
            if (!rs.next()) {
                conn.rollback();
                response.sendRedirect("doctorAppointments.jsp?error=Appointment not found or you don't have permission to cancel it.");
                return;
            }
            
            String currentStatus = rs.getString("status");
            
            // Check if appointment can be cancelled
            if (currentStatus.equals("Cancelled")) {
                conn.rollback();
                response.sendRedirect("doctorAppointments.jsp?error=This appointment is already cancelled.");
                return;
            }
            
            if (currentStatus.equals("Completed")) {
                conn.rollback();
                response.sendRedirect("doctorAppointments.jsp?error=Cannot cancel a completed appointment.");
                return;
            }
            
            // Update appointment status to Cancelled
            // This will FREE UP the time slot for other patients
            String updateSql = "UPDATE appointments SET status = 'Cancelled' WHERE appointment_id = ?";
            updatePstmt = conn.prepareStatement(updateSql);
            updatePstmt.setInt(1, Integer.parseInt(appointmentId));
            
            int rowsUpdated = updatePstmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                // Optional: Log cancellation reason if your appointments table has a cancellation_reason column
                // Uncomment if you have this column:
                /*
                if (reason != null && !reason.trim().isEmpty()) {
                    String noteSql = "UPDATE appointments SET cancellation_reason = ?, cancelled_by = 'doctor' WHERE appointment_id = ?";
                    notePstmt = conn.prepareStatement(noteSql);
                    notePstmt.setString(1, reason);
                    notePstmt.setInt(2, Integer.parseInt(appointmentId));
                    notePstmt.executeUpdate();
                }
                */
                
                conn.commit();
                
                String successMsg = "Appointment cancelled successfully! The time slot is now available for other patients.";
                if (currentStatus.equals("Confirmed")) {
                    successMsg += " Patient will be notified and refund will be processed.";
                }
                
                response.sendRedirect("doctorAppointments.jsp?success=" + successMsg);
            } else {
                conn.rollback();
                response.sendRedirect("doctorAppointments.jsp?error=Failed to cancel appointment. Please try again.");
            }
            
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("doctorAppointments.jsp?error=Database error occurred: " + e.getMessage());
        } catch (NumberFormatException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("doctorAppointments.jsp?error=Invalid appointment ID format.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkPstmt != null) checkPstmt.close();
                if (updatePstmt != null) updatePstmt.close();
                if (notePstmt != null) notePstmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
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








