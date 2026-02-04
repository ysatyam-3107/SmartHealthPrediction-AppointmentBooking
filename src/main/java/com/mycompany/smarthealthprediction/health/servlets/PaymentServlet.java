package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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
        
        String appointmentId = request.getParameter("appointmentId");
        String amount = request.getParameter("amount");
        String paymentMethod = request.getParameter("paymentMethod");
        
        // Validate inputs
        if (appointmentId == null || amount == null || paymentMethod == null || 
            appointmentId.trim().isEmpty() || amount.trim().isEmpty() || paymentMethod.trim().isEmpty()) {
            response.sendRedirect("makePayment.jsp?error=Invalid payment details.");
            return;
        }
        
        // Generate a mock transaction ID
        String transactionId = "TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        
        Connection conn = null;
        PreparedStatement checkPstmt = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // CRITICAL: Verify appointment is confirmed by doctor before accepting payment
            String checkSql = "SELECT status, user_id FROM appointments WHERE appointment_id = ?";
            checkPstmt = conn.prepareStatement(checkSql);
            checkPstmt.setInt(1, Integer.parseInt(appointmentId));
            rs = checkPstmt.executeQuery();
            
            if (!rs.next()) {
                conn.rollback();
                response.sendRedirect("userAppointments.jsp?error=Appointment not found.");
                return;
            }
            
            String status = rs.getString("status");
            int appointmentUserId = rs.getInt("user_id");
            
            // Verify appointment belongs to this user
            if (appointmentUserId != userId) {
                conn.rollback();
                response.sendRedirect("userAppointments.jsp?error=Unauthorized payment attempt.");
                return;
            }
            
            // Check if appointment is confirmed by doctor
            if (!status.equals("Confirmed")) {
                conn.rollback();
                String errorMsg = status.equals("Pending") 
                    ? "Please wait for doctor's confirmation before making payment."
                    : "This appointment cannot be paid for. Current status: " + status;
                response.sendRedirect("userAppointments.jsp?error=" + errorMsg);
                return;
            }
            
            // Check if payment already exists
            PreparedStatement checkPaymentPstmt = conn.prepareStatement(
                "SELECT payment_id FROM payments WHERE appointment_id = ?"
            );
            checkPaymentPstmt.setInt(1, Integer.parseInt(appointmentId));
            ResultSet paymentRs = checkPaymentPstmt.executeQuery();
            
            if (paymentRs.next()) {
                conn.rollback();
                response.sendRedirect("userAppointments.jsp?error=Payment already made for this appointment.");
                paymentRs.close();
                checkPaymentPstmt.close();
                return;
            }
            paymentRs.close();
            checkPaymentPstmt.close();
            
            // Insert payment record
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
                // Payment successful - appointment stays "Confirmed" but now with payment record
                conn.commit();
                
                // Store details in session for success page
                session.setAttribute("lastTransactionId", transactionId);
                session.setAttribute("lastPaymentAmount", amount);
                
                response.sendRedirect("paymentSuccess.jsp?transactionId=" + transactionId);
            } else {
                conn.rollback();
                response.sendRedirect("makePayment.jsp?appointmentId=" + appointmentId + 
                                    "&amount=" + amount + "&error=Payment processing failed.");
            }
            
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("makePayment.jsp?appointmentId=" + appointmentId + 
                                "&amount=" + amount + "&error=Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("makePayment.jsp?error=Invalid payment amount format.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkPstmt != null) checkPstmt.close();
                if (pstmt != null) pstmt.close();
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








