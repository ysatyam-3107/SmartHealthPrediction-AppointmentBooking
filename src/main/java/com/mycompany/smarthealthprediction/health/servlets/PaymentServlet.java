package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
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
        PreparedStatement pstmt = null;
        PreparedStatement updatePstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Start transaction
            conn.setAutoCommit(false);
            
            // Insert payment record with user_id
            String sql = "INSERT INTO payments (appointment_id, user_id, amount, payment_method, transaction_id, payment_status) " +
                        "VALUES (?, ?, ?, ?, ?, 'Completed')";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(appointmentId));
            pstmt.setInt(2, userId);
            pstmt.setDouble(3, Double.parseDouble(amount));
            pstmt.setString(4, paymentMethod);
            pstmt.setString(5, transactionId);
            
            int rowsInserted = pstmt.executeUpdate();
            
            if (rowsInserted > 0) {
                // Update appointment status to Confirmed
                String updateSql = "UPDATE appointments SET status = 'Confirmed' WHERE appointment_id = ?";
                updatePstmt = conn.prepareStatement(updateSql);
                updatePstmt.setInt(1, Integer.parseInt(appointmentId));
                int rowsUpdated = updatePstmt.executeUpdate();
                
                if (rowsUpdated > 0) {
                    // Commit transaction
                    conn.commit();
                    
                    // Store details in session for success page
                    session.setAttribute("lastTransactionId", transactionId);
                    session.setAttribute("lastPaymentAmount", amount);
                    
                    response.sendRedirect("paymentSuccess.jsp?transactionId=" + transactionId);
                } else {
                    conn.rollback();
                    response.sendRedirect("makePayment.jsp?appointmentId=" + appointmentId + 
                                        "&amount=" + amount + "&error=Failed to confirm appointment.");
                }
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
            e.printStackTrace();
            response.sendRedirect("makePayment.jsp?error=Invalid payment amount format.");
        } finally {
            try {
                if (updatePstmt != null) updatePstmt.close();
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