package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
import com.mycompany.smarthealthprediction.health.util.EmailUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
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

        if (appointmentId == null || appointmentId.trim().isEmpty()) {
            response.sendRedirect("userAppointments.jsp?error=Invalid appointment ID");
            return;
        }

        Connection conn         = null;
        PreparedStatement checkPstmt  = null;
        PreparedStatement updatePstmt = null;
        PreparedStatement infoPstmt   = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String checkSql = "SELECT a.status, a.appointment_date, a.appointment_time, " +
                              "u.full_name as patient_name, u.email as patient_email, " +
                              "d.full_name as doctor_name, d.email as doctor_email " +
                              "FROM appointments a " +
                              "JOIN users u ON a.user_id = u.user_id " +
                              "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                              "WHERE a.appointment_id = ? AND a.user_id = ?";
            checkPstmt = conn.prepareStatement(checkSql);
            checkPstmt.setInt(1, Integer.parseInt(appointmentId));
            checkPstmt.setInt(2, userId);
            rs = checkPstmt.executeQuery();

            if (!rs.next()) {
                conn.rollback();
                response.sendRedirect("userAppointments.jsp?error=Appointment not found or you don 't have permission.");
                return;
            }

            String currentStatus  = rs.getString("status");
            String date           = rs.getString("appointment_date");
            String time           = rs.getString("appointment_time");
            String patientName    = rs.getString("patient_name");
            String patientEmail   = rs.getString("patient_email");
            String doctorName     = rs.getString("doctor_name");
            String doctorEmail    = rs.getString("doctor_email");

            if (currentStatus.equals("Cancelled")) {
                conn.rollback();
                response.sendRedirect("userAppointments.jsp?error=This appointment is already cancelled.");
                return;
            }
            if (currentStatus.equals("Completed")) {
                conn.rollback();
                response.sendRedirect("userAppointments.jsp?error=Cannot cancel a completed appointment.");
                return;
            }

            String updateSql = "UPDATE appointments SET status = 'Cancelled ' WHERE appointment_id = ?";
            updatePstmt = conn.prepareStatement(updateSql);
            updatePstmt.setInt(1, Integer.parseInt(appointmentId));

            int rowsUpdated = updatePstmt.executeUpdate();

            if (rowsUpdated > 0) {
                conn.commit();

                // Send cancellation emails to both patient and doctor
                EmailUtil.sendCancellationEmail(patientEmail, patientName, doctorName, date, time, false);
                EmailUtil.sendCancellationEmail(doctorEmail,  doctorName,  doctorName, date, time, true);

                String successMsg = "Appointment cancelled successfully.";
                if (currentStatus.equals("Confirmed")) {
                    successMsg += " Refund will be processed in 5-7 business days.";
                }
                response.sendRedirect("userAppointments.jsp?success=" + successMsg);
            } else {
                conn.rollback();
                response.sendRedirect("userAppointments.jsp?error=Failed to cancel appointment.");
            }

        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            response.sendRedirect("userAppointments.jsp?error=Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            response.sendRedirect("userAppointments.jsp?error=Invalid appointment ID format.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkPstmt != null) checkPstmt.close();
                if (updatePstmt != null) updatePstmt.close();
                if (infoPstmt != null) infoPstmt.close();
                if (conn != null) { conn.setAutoCommit(true); conn.close(); }
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}