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

        String doctorId        = request.getParameter("doctorId");
        String appointmentDate = request.getParameter("appointmentDate");
        String appointmentTime = request.getParameter("appointmentTime");
        String symptoms        = request.getParameter("symptoms");

        if (doctorId == null || appointmentDate == null || appointmentTime == null || symptoms == null ||
            doctorId.trim().isEmpty() || appointmentDate.trim().isEmpty() ||
            appointmentTime.trim().isEmpty() || symptoms.trim().isEmpty()) {
            response.sendRedirect("bookAppointment.jsp?error=Please fill all required fields.");
            return;
        }

        Connection conn        = null;
        PreparedStatement checkPstmt  = null;
        PreparedStatement insertPstmt = null;
        PreparedStatement infoPstmt   = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String checkSql = "SELECT COUNT(*) as count FROM appointments " +
                              "WHERE doctor_id = ? AND appointment_date = ? AND appointment_time = ? " +
                              "AND status IN ('Pending ', 'Confirmed ')";
            checkPstmt = conn.prepareStatement(checkSql);
            checkPstmt.setInt(1, Integer.parseInt(doctorId));
            checkPstmt.setString(2, appointmentDate);
            checkPstmt.setString(3, appointmentTime);
            rs = checkPstmt.executeQuery();

            if (rs.next() && rs.getInt("count") > 0) {
                conn.rollback();
                response.sendRedirect("bookAppointment.jsp?error=Sorry, this time slot has just been booked. Please select a different time.");
                return;
            }

            String insertSql = "INSERT INTO appointments (user_id, doctor_id, appointment_date, appointment_time, symptoms, status) " +
                               "VALUES (?, ?, ?, ?, ?, 'Pending ')";
            insertPstmt = conn.prepareStatement(insertSql);
            insertPstmt.setInt(1, userId);
            insertPstmt.setInt(2, Integer.parseInt(doctorId));
            insertPstmt.setString(3, appointmentDate);
            insertPstmt.setString(4, appointmentTime);
            insertPstmt.setString(5, symptoms);

            int rowsInserted = insertPstmt.executeUpdate();

            if (rowsInserted > 0) {
                conn.commit();

                // Fetch patient + doctor details for email
                String infoSql = "SELECT u.full_name as patient_name, u.email as patient_email, " +
                                 "d.full_name as doctor_name, d.email as doctor_email, " +
                                 "d.phone as doctor_phone, d.specialization, d.hospital_name " +
                                 "FROM users u, doctors d " +
                                 "WHERE u.user_id = ? AND d.doctor_id = ?";
                infoPstmt = conn.prepareStatement(infoSql);
                infoPstmt.setInt(1, userId);
                infoPstmt.setInt(2, Integer.parseInt(doctorId));
                ResultSet infoRs = infoPstmt.executeQuery();

                if (infoRs.next()) {
                    String patientName  = infoRs.getString("patient_name");
                    String patientEmail = infoRs.getString("patient_email");
                    String doctorName   = infoRs.getString("doctor_name");
                    String doctorEmail  = infoRs.getString("doctor_email");
                    String doctorPhone  = infoRs.getString("doctor_phone");
                    String specialization = infoRs.getString("specialization");
                    String hospital     = infoRs.getString("hospital_name");

                    EmailUtil.sendAppointmentBookedToPatient(
                        patientEmail, patientName, doctorName, specialization, hospital, appointmentDate, appointmentTime
                    );
                    EmailUtil.sendAppointmentBookedToDoctor(
                        doctorEmail, doctorName, patientName, doctorPhone, appointmentDate, appointmentTime, symptoms
                    );
                }
                infoRs.close();

                response.sendRedirect("userAppointments.jsp?success=Appointment requested successfully! Please wait for doctor confirmation.");
            } else {
                conn.rollback();
                response.sendRedirect("bookAppointment.jsp?error=Failed to book appointment. Please try again.");
            }

        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            response.sendRedirect("bookAppointment.jsp?error=Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            response.sendRedirect("bookAppointment.jsp?error=Invalid doctor ID format.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkPstmt != null) checkPstmt.close();
                if (insertPstmt != null) insertPstmt.close();
                if (infoPstmt != null) infoPstmt.close();
                if (conn != null) { conn.setAutoCommit(true); conn.close(); }
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}