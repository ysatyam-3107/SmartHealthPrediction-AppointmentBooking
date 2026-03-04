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

//@WebServlet("/UpdateAppointmentServlet")
public class UpdateAppointmentServlet extends HttpServlet {

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
        String newStatus     = request.getParameter("status");

        if (appointmentId == null || newStatus == null) {
            response.sendRedirect("doctorAppointments.jsp?error=Invalid request parameters");
            return;
        }

        Connection conn     = null;
        PreparedStatement pstmt     = null;
        PreparedStatement infoPstmt = null;
        ResultSet infoRs = null;

        try {
            conn = DBConnection.getConnection();

            String sql = "UPDATE appointments SET status = ? WHERE appointment_id = ? AND doctor_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, Integer.parseInt(appointmentId));
            pstmt.setInt(3, doctorId);

            int rowsUpdated = pstmt.executeUpdate();

            if (rowsUpdated > 0) {
                // Fetch details for email only when status is Confirmed
                if (newStatus.equals("Confirmed")) {
                    String infoSql = "SELECT u.full_name as patient_name, u.email as patient_email, " +
                                     "d.full_name as doctor_name, d.specialization, d.hospital_name, " +
                                     "a.appointment_date, a.appointment_time, d.consultation_fee " +
                                     "FROM appointments a " +
                                     "JOIN users u ON a.user_id = u.user_id " +
                                     "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                                     "WHERE a.appointment_id = ?";
                    infoPstmt = conn.prepareStatement(infoSql);
                    infoPstmt.setInt(1, Integer.parseInt(appointmentId));
                    infoRs = infoPstmt.executeQuery();

                    if (infoRs.next()) {
                        EmailUtil.sendAppointmentConfirmedToPatient(
                            infoRs.getString("patient_email"),
                            infoRs.getString("patient_name"),
                            infoRs.getString("doctor_name"),
                            infoRs.getString("specialization"),
                            infoRs.getString("hospital_name"),
                            infoRs.getString("appointment_date"),
                            infoRs.getString("appointment_time"),
                            infoRs.getDouble("consultation_fee")
                        );
                    }
                }

                response.sendRedirect("doctorAppointments.jsp?success=Appointment updated successfully!");
            } else {
                response.sendRedirect("doctorAppointments.jsp?error=Failed to update appointment.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("doctorAppointments.jsp?error=Database error occurred.");
        } finally {
            try {
                if (infoRs != null) infoRs.close();
                if (pstmt != null) pstmt.close();
                if (infoPstmt != null) infoPstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}