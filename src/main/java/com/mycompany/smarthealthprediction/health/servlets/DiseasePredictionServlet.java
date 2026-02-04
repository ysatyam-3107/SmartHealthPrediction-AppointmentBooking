package com.mycompany.smarthealthprediction.health.servlets;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import org.json.JSONObject;

public class DiseasePredictionServlet extends HttpServlet {

    private static final String API_URL = "http://localhost:5000/predict";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("userLogin.jsp");
            return;
        }

        String symptoms = request.getParameter("symptoms");
        if (symptoms == null || symptoms.isEmpty()) {
            request.setAttribute("mlError", true);
            request.getRequestDispatcher("diseasePrediction.jsp").forward(request, response);
            return;
        }

        try {
            JSONObject result = callAPI(symptoms);

            session.setAttribute("predictedDisease", result.getString("predicted_disease"));
            session.setAttribute("confidenceScore", result.getDouble("confidence"));
            session.setAttribute("recommendations",
                    result.getJSONArray("recommendations").join(" ").replace("\"", ""));

            response.sendRedirect("predictionResult.jsp");

        } catch (Exception e) {
            request.setAttribute("mlError", true);
            request.getRequestDispatcher("diseasePrediction.jsp").forward(request, response);
        }
    }

    private JSONObject callAPI(String symptoms) throws Exception {
        URL url = new URL(API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        JSONObject body = new JSONObject();
        body.put("symptoms", symptoms);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(body.toString().getBytes());
        }

        if (conn.getResponseCode() != 200) {
            throw new Exception("ML API Error");
        }

        BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream())
        );

        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) sb.append(line);

        return new JSONObject(sb.toString());
    }
}
