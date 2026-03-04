package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
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

//@WebServlet("/DeleteDoctorAccountServlet")
public class DeleteDoctorAccountServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer doctorId = (Integer) session.getAttribute("doctorId");

        if (doctorId == null) {
            response.sendRedirect("doctorLogin.jsp?error=Please login first!");
            return;
        }

        String password = request.getParameter("confirmPassword");

        if (password == null || password.trim().isEmpty()) {
            response.sendRedirect("doctorProfile.jsp?error=Please enter your password to confirm deletion.");
            return;
        }

        Connection conn = null;
        PreparedStatement checkPstmt = null;
        PreparedStatement deletePstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Verify password
            String checkSql = "SELECT password FROM doctors WHERE doctor_id = ? AND is_deleted = 0";
            checkPstmt = conn.prepareStatement(checkSql);
            checkPstmt.setInt(1, doctorId);
            rs = checkPstmt.executeQuery();

            if (!rs.next()) {
                response.sendRedirect("doctorProfile.jsp?error=Account not found.");
                return;
            }

            String storedPassword = rs.getString("password");

            if (!storedPassword.equals(password)) {
                response.sendRedirect("doctorProfile.jsp?error=Incorrect password. Account not deleted.");
                return;
            }

            // Soft delete
            String deleteSql = "UPDATE doctors SET is_deleted = 1, deleted_at = NOW() WHERE doctor_id = ?";
            deletePstmt = conn.prepareStatement(deleteSql);
            deletePstmt.setInt(1, doctorId);
            int rows = deletePstmt.executeUpdate();

            if (rows > 0) {
                session.invalidate();
                response.sendRedirect("index.jsp?message=Your doctor account has been deleted. Your data is retained for records.");
            } else {
                response.sendRedirect("doctorProfile.jsp?error=Failed to delete account. Please try again.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("doctorProfile.jsp?error=Database error: " + e.getMessage());
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