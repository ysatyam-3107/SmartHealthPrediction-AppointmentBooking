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

//@WebServlet("/DeleteAccountServlet")
public class DeleteAccountServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("userLogin.jsp?error=Please login first!");
            return;
        }

        String password = request.getParameter("confirmPassword");

        if (password == null || password.trim().isEmpty()) {
            response.sendRedirect("userProfile.jsp?error=Please enter your password to confirm deletion.");
            return;
        }

        Connection conn = null;
        PreparedStatement checkPstmt = null;
        PreparedStatement deletePstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Verify password before deleting
            String checkSql = "SELECT password FROM users WHERE user_id = ? AND is_deleted = 0";
            checkPstmt = conn.prepareStatement(checkSql);
            checkPstmt.setInt(1, userId);
            rs = checkPstmt.executeQuery();

            if (!rs.next()) {
                response.sendRedirect("userProfile.jsp?error=Account not found.");
                return;
            }

            String storedPassword = rs.getString("password");

            // Check password matches (adjust if you use hashing like BCrypt)
            if (!storedPassword.equals(password)) {
                response.sendRedirect("userProfile.jsp?error=Incorrect password. Account not deleted.");
                return;
            }

            // Soft delete — mark as deleted, keep all data
            String deleteSql = "UPDATE users SET is_deleted = 1, deleted_at = NOW() WHERE user_id = ?";
            deletePstmt = conn.prepareStatement(deleteSql);
            deletePstmt.setInt(1, userId);
            int rows = deletePstmt.executeUpdate();

            if (rows > 0) {
                // Invalidate session
                session.invalidate();
                response.sendRedirect("index.jsp?message=Your account has been deleted. Your data is retained for records.");
            } else {
                response.sendRedirect("userProfile.jsp?error=Failed to delete account. Please try again.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("userProfile.jsp?error=Database error: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkPstmt != null) checkPstmt.close();
                if (deletePstmt != null) deletePstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}