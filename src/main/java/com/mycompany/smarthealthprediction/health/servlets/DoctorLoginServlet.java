package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
import com.mycompany.smarthealthprediction.health.util.PasswordUtil;
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

//@WebServlet("/DoctorLoginServlet")
public class DoctorLoginServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // ✅ BASIC VALIDATION
        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            response.sendRedirect("doctorLogin.jsp?error=Email and password are required");
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // ✅ FETCH DOCTOR BY EMAIL ONLY (SECURITY: DON'T INCLUDE PASSWORD IN WHERE)
            String sql = "SELECT doctor_id, full_name, email, password, specialization FROM doctors WHERE email = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email.toLowerCase().trim());
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                
                // ✅ VERIFY PASSWORD USING BCRYPT
                if (PasswordUtil.verifyPassword(password, hashedPassword)) {
                    // ✅ PASSWORD CORRECT - CREATE SESSION
                    HttpSession session = request.getSession();
                    session.setAttribute("doctorId", rs.getInt("doctor_id"));
                    session.setAttribute("doctorName", rs.getString("full_name"));
                    session.setAttribute("doctorEmail", rs.getString("email"));
                    session.setAttribute("specialization", rs.getString("specialization"));
                    session.setAttribute("userType", "doctor");
                    
                    // ✅ SET SESSION TIMEOUT (30 MINUTES)
                    session.setMaxInactiveInterval(30 * 60);
                    
                    response.sendRedirect("doctorDashboard.jsp");
                } else {
                    // ✅ INVALID PASSWORD
                    response.sendRedirect("doctorLogin.jsp?error=Invalid email or password!");
                }
            } else {
                // ✅ DOCTOR NOT FOUND
                response.sendRedirect("doctorLogin.jsp?error=Invalid email or password!");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("doctorLogin.jsp?error=Database error occurred.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}