package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
import com.mycompany.smarthealthprediction.health.util.EmailUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

//@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("userLogin.jsp?error=Please login first!");
            return;
        }

        String appointmentId  = request.getParameter("appointmentId");
        String amount         = request.getParameter("amount");
        String paymentMethod  = request.getParameter("paymentMethod");

        if (appointmentId == null || amount == null || paymentMethod == null ||
            appointmentId.trim().isEmpty() || amount.trim().isEmpty() || paymentMethod.trim().isEmpty()) {
            response.sendRedirect("makePayment.jsp?error=Invalid payment details.");
            return;
        }

        String transactionId = "TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        Connection conn           = null;
        PreparedStatement checkPstmt   = null;
        PreparedStatement pstmt        = null;
        PreparedStatement infoPstmt    = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String checkSql = "SELECT status, user_id FROM appointments WHERE appointment_id = ?";
            checkPstmt = conn.prepareStatement(checkSql);
            checkPstmt.setInt(1, Integer.parseInt(appointmentId));
            rs = checkPstmt.executeQuery();

            if (!rs.next()) {
                conn.rollback();
                response.sendRedirect("userAppointments.jsp?error=Appointment not found.");
                return;
            }

            String status           = rs.getString("status");
            int appointmentUserId   = rs.getInt("user_id");

            if (appointmentUserId != userId) {
                conn.rollback();
                response.sendRedirect("userAppointments.jsp?error=Unauthorized payment attempt.");
                return;
            }

            if (!status.equals("Confirmed")) {
                conn.rollback();
                String errorMsg = status.equals("Pending")
                    ? "Please wait for doctor confirmation before making payment."
                    : "This appointment cannot be paid. Status: " + status;
                response.sendRedirect("userAppointments.jsp?error=" + errorMsg);
                return;
            }

            PreparedStatement checkPaymentPstmt = conn.prepareStatement(
                "SELECT payment_id FROM payments WHERE appointment_id = ?"
            );
            checkPaymentPstmt.setInt(1, Integer.parseInt(appointmentId));
            ResultSet paymentRs = checkPaymentPstmt.executeQuery();
            if (paymentRs.next()) {
                conn.rollback();
                response.sendRedirect("userAppointments.jsp?error=Payment already made for this appointment.");
                paymentRs.close(); checkPaymentPstmt.close();
                return;
            }
            paymentRs.close(); checkPaymentPstmt.close();

            String sql = "INSERT INTO payments (appointment_id, user_id, amount, payment_method, transaction_id) " +
                         "VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(appointmentId));
            pstmt.setInt(2, userId);
            pstmt.setDouble(3, Double.parseDouble(amount));
            pstmt.setString(4, paymentMethod);
            pstmt.setString(5, transactionId);

            int rowsInserted = pstmt.executeUpdate();

            if (rowsInserted > 0) {
                conn.commit();
                session.setAttribute("lastTransactionId", transactionId);
                session.setAttribute("lastPaymentAmount", amount);

                // Fetch details for payment confirmation email
                String infoSql = "SELECT u.full_name as patient_name, u.email as patient_email, " +
                                 "d.full_name as doctor_name, a.appointment_date, a.appointment_time " +
                                 "FROM appointments a " +
                                 "JOIN users u ON a.user_id = u.user_id " +
                                 "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                                 "WHERE a.appointment_id = ?";
                infoPstmt = conn.prepareStatement(infoSql);
                infoPstmt.setInt(1, Integer.parseInt(appointmentId));
                ResultSet infoRs = infoPstmt.executeQuery();

                if (infoRs.next()) {
                    EmailUtil.sendPaymentConfirmationToPatient(
                        infoRs.getString("patient_email"),
                        infoRs.getString("patient_name"),
                        infoRs.getString("doctor_name"),
                        infoRs.getString("appointment_date"),
                        infoRs.getString("appointment_time"),
                        Double.parseDouble(amount),
                        transactionId
                    );
                }
                infoRs.close();

                response.sendRedirect("paymentSuccess.jsp?transactionId=" + transactionId);
            } else {
                conn.rollback();
                response.sendRedirect("makePayment.jsp?appointmentId=" + appointmentId + "&amount=" + amount + "&error=Payment processing failed.");
            }

        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            response.sendRedirect("makePayment.jsp?appointmentId=" + appointmentId + "&amount=" + amount + "&error=Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            response.sendRedirect("makePayment.jsp?error=Invalid payment amount format.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkPstmt != null) checkPstmt.close();
                if (pstmt != null) pstmt.close();
                if (infoPstmt != null) infoPstmt.close();
                if (conn != null) { conn.setAutoCommit(true); conn.close(); }
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}