package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

//@WebServlet("/GetAvailableTimeSlotsServlet")
public class GetAvailableTimeSlotsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String doctorId = request.getParameter("doctorId");
        String date = request.getParameter("date");
        
        if (doctorId == null || date == null) {
            JSONObject errorJson = new JSONObject();
            errorJson.put("error", "Missing parameters");
            out.print(errorJson.toString());
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<String> bookedSlots = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            
            // Get all booked time slots for this doctor on this date
            // Only consider Pending, Confirmed appointments (not Cancelled or Completed)
            String sql = "SELECT appointment_time FROM appointments " +
                        "WHERE doctor_id = ? AND appointment_date = ? " +
                        "AND status IN ('Pending', 'Confirmed')";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(doctorId));
            pstmt.setString(2, date);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                bookedSlots.add(rs.getString("appointment_time"));
            }
            
            // Create JSON response
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("bookedSlots", new JSONArray(bookedSlots));
            
            out.print(jsonResponse.toString());
            
        } catch (SQLException e) {
            e.printStackTrace();
            JSONObject errorJson = new JSONObject();
            errorJson.put("error", "Database error: " + e.getMessage());
            out.print(errorJson.toString());
        } catch (NumberFormatException e) {
            e.printStackTrace();
            JSONObject errorJson = new JSONObject();
            errorJson.put("error", "Invalid doctor ID format");
            out.print(errorJson.toString());
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








