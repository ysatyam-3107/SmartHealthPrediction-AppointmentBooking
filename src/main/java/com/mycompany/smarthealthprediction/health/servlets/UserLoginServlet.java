package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

//@WebServlet("/UserLoginServlet")
public class UserLoginServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            // is_deleted = 0 blocks soft-deleted accounts from logging in
            String sql = "SELECT * FROM users WHERE email = ? AND password = ? AND is_deleted = 0";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, password);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("user_id"));
                session.setAttribute("userName", rs.getString("full_name"));
                session.setAttribute("userEmail", rs.getString("email"));
                session.setAttribute("userType", "user");
                response.sendRedirect("userDashboard.jsp");
            } else {
                // Check if account exists but was soft-deleted
                PreparedStatement checkDeleted = conn.prepareStatement(
                    "SELECT is_deleted FROM users WHERE email = ? AND password = ?"
                );
                checkDeleted.setString(1, email);
                checkDeleted.setString(2, password);
                ResultSet checkRs = checkDeleted.executeQuery();

                if (checkRs.next() && checkRs.getInt("is_deleted") == 1) {
                    response.sendRedirect("userLogin.jsp?error=This account has been deleted. Contact support to recover it.");
                } else {
                    response.sendRedirect("userLogin.jsp?error=Invalid email or password!");
                }
                checkRs.close();
                checkDeleted.close();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("userLogin.jsp?error=Database error occurred.");
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