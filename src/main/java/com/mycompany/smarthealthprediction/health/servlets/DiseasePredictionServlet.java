package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Random;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

//@WebServlet("/DiseasePredictionServlet")
public class DiseasePredictionServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("userLogin.jsp?error=Please login first!");
            return;
        }
        
        String symptoms = request.getParameter("symptoms");
        
        // Simple rule-based prediction (In production, use ML model)
        String predictedDisease = predictDisease(symptoms);
        double confidenceScore = 75.0 + (new Random().nextDouble() * 20.0); // 75-95%
        String recommendations = getRecommendations(predictedDisease);
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO predictions (user_id, symptoms, predicted_disease, confidence_score, recommendations) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setString(2, symptoms);
            pstmt.setString(3, predictedDisease);
            pstmt.setDouble(4, confidenceScore);
            pstmt.setString(5, recommendations);
            
            int rowsInserted = pstmt.executeUpdate();
            
            if (rowsInserted > 0) {
                session.setAttribute("predictedDisease", predictedDisease);
                session.setAttribute("confidenceScore", String.format("%.2f", confidenceScore));
                session.setAttribute("recommendations", recommendations);
                response.sendRedirect("predictionResult.jsp");
            } else {
                response.sendRedirect("diseasePrediction.jsp?error=Prediction failed. Please try again.");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("diseasePrediction.jsp?error=Database error occurred.");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private String predictDisease(String symptoms) {
        symptoms = symptoms.toLowerCase();
        
        if (symptoms.contains("fever") && symptoms.contains("cough")) {
            return "Common Cold / Flu";
        } else if (symptoms.contains("chest pain") || symptoms.contains("breathing")) {
            return "Respiratory Issue";
        } else if (symptoms.contains("headache") && symptoms.contains("nausea")) {
            return "Migraine";
        } else if (symptoms.contains("stomach") || symptoms.contains("diarrhea")) {
            return "Gastroenteritis";
        } else if (symptoms.contains("rash") || symptoms.contains("itching")) {
            return "Skin Allergy";
        } else if (symptoms.contains("joint") || symptoms.contains("pain")) {
            return "Arthritis";
        } else {
            return "General Health Concern";
        }
    }
    
    private String getRecommendations(String disease) {
        switch (disease) {
            case "Common Cold / Flu":
                return "Rest well, stay hydrated, take vitamin C. Consult a doctor if symptoms persist for more than 3 days.";
            case "Respiratory Issue":
                return "Avoid smoking and polluted areas. Consult a pulmonologist immediately.";
            case "Migraine":
                return "Rest in a dark room, avoid loud noises. Consider consulting a neurologist.";
            case "Gastroenteritis":
                return "Drink plenty of fluids, follow a bland diet (BRAT). Consult if severe.";
            case "Skin Allergy":
                return "Avoid allergens, use hypoallergenic products. Consult a dermatologist.";
            case "Arthritis":
                return "Light exercise, anti-inflammatory medication. Consult an orthopedic specialist.";
            default:
                return "Please consult a general physician for proper diagnosis and treatment.";
        }
    }
}