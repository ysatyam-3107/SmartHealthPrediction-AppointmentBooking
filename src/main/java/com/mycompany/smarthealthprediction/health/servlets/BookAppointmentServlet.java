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
        
        // Validate inputs
        if (doctorId == null || appointmentDate == null || appointmentTime == null || symptoms == null ||
            doctorId.trim().isEmpty() || appointmentDate.trim().isEmpty() || 
            appointmentTime.trim().isEmpty() || symptoms.trim().isEmpty()) {
            response.sendRedirect("bookAppointment.jsp?error=Please fill all required fields.");
            return;
        }
        
        Connection conn = null;
        PreparedStatement checkPstmt = null;
        PreparedStatement insertPstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // CRITICAL: Check if the time slot is already booked
            String checkSql = "SELECT COUNT(*) as count FROM appointments " +
                            "WHERE doctor_id = ? AND appointment_date = ? AND appointment_time = ? " +
                            "AND status IN ('Pending', 'Confirmed')";
            
            checkPstmt = conn.prepareStatement(checkSql);
            checkPstmt.setInt(1, Integer.parseInt(doctorId));
            checkPstmt.setString(2, appointmentDate);
            checkPstmt.setString(3, appointmentTime);
            rs = checkPstmt.executeQuery();
            
            if (rs.next() && rs.getInt("count") > 0) {
                // Time slot is already booked
                conn.rollback();
                response.sendRedirect("bookAppointment.jsp?error=Sorry, this time slot has just been booked by another patient. Please select a different time.");
                return;
            }
            
            // Time slot is available, proceed with booking
            // STATUS = 'Pending' - User must wait for doctor confirmation before payment
            String insertSql = "INSERT INTO appointments (user_id, doctor_id, appointment_date, appointment_time, symptoms, status) " +
                             "VALUES (?, ?, ?, ?, ?, 'Pending')";
            insertPstmt = conn.prepareStatement(insertSql);
            insertPstmt.setInt(1, userId);
            insertPstmt.setInt(2, Integer.parseInt(doctorId));
            insertPstmt.setString(3, appointmentDate);
            insertPstmt.setString(4, appointmentTime);
            insertPstmt.setString(5, symptoms);
            
            int rowsInserted = insertPstmt.executeUpdate();
            
            if (rowsInserted > 0) {
                conn.commit();
                response.sendRedirect("userAppointments.jsp?success=Appointment requested successfully! Please wait for doctor's confirmation before making payment.");
            } else {
                conn.rollback();
                response.sendRedirect("bookAppointment.jsp?error=Failed to book appointment. Please try again.");
            }
            
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("bookAppointment.jsp?error=Database error occurred: " + e.getMessage());
        } catch (NumberFormatException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("bookAppointment.jsp?error=Invalid doctor ID format.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkPstmt != null) checkPstmt.close();
                if (insertPstmt != null) insertPstmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}








