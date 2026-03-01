package com.mycompany.smarthealthprediction.health.servlets;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

//@WebServlet("/FileServlet")
public class FileServlet extends HttpServlet {

    // Must match the upload path in UpdateDoctorPhotoServlet
    private static final String BASE_DIR = "C:/SmartHealthUploads/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fileParam = request.getParameter("file");

        if (fileParam == null || fileParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "File parameter missing.");
            return;
        }

        // Security: prevent directory traversal attack
        if (fileParam.contains("..") || fileParam.contains("\\")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid file path.");
            return;
        }

        File file = new File(BASE_DIR + fileParam);

        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found.");
            return;
        }

        // Detect and set content type (image/jpeg, image/png, etc.)
        String mimeType = getServletContext().getMimeType(file.getName());
        if (mimeType == null) mimeType = "application/octet-stream";

        response.setContentType(mimeType);
        response.setContentLengthLong(file.length());

        // Cache for 1 day to improve performance
        response.setHeader("Cache-Control", "max-age=86400");

        Files.copy(file.toPath(), response.getOutputStream());
    }
}