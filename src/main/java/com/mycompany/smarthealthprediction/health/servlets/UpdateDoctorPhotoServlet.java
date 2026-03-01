package com.mycompany.smarthealthprediction.health.servlets;

import com.mycompany.smarthealthprediction.health.db.DBConnection;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

//@WebServlet("/UpdateDoctorPhotoServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class UpdateDoctorPhotoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer doctorId = (Integer) session.getAttribute("doctorId");

        if (doctorId == null) {
            response.sendRedirect("doctorLogin.jsp?error=Please login first!");
            return;
        }

        Part filePart = request.getPart("profilePhoto");

        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect("doctorProfile.jsp?error=Please select a photo to upload.");
            return;
        }

        String contentType = filePart.getContentType();
        if (!contentType.startsWith("image/")) {
            response.sendRedirect("doctorProfile.jsp?error=Please upload a valid image file.");
            return;
        }

        // Save to C:/SmartHealthUploads — outside project, survives redeployment
        String uploadDiskPath = "C:/SmartHealthUploads/doctor-photos";
        File uploadDir = new File(uploadDiskPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String extension = getFileExtension(filePart);
        String fileName = "doctor_" + doctorId + "_" + System.currentTimeMillis() + extension;
        String fullFilePath = uploadDiskPath + "/" + fileName;

        try (InputStream fileContent = filePart.getInputStream()) {
            Files.copy(fileContent, Paths.get(fullFilePath), StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            e.printStackTrace();
            response.sendRedirect("doctorProfile.jsp?error=Failed to save photo: " + e.getMessage());
            return;
        }

        // Store servlet URL in DB — FileServlet reads from C:/SmartHealthUploads and serves the image
        String dbPath = "FileServlet?file=doctor-photos/" + fileName;

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE doctors SET profile_photo = ? WHERE doctor_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dbPath);
            pstmt.setInt(2, doctorId);

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("doctorProfile.jsp?success=Profile photo updated successfully!");
            } else {
                response.sendRedirect("doctorProfile.jsp?error=Failed to update photo in database.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("doctorProfile.jsp?error=Database error: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private String getFileExtension(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String item : contentDisposition.split(";")) {
            if (item.trim().startsWith("filename")) {
                String fileName = item.substring(item.indexOf("=") + 2, item.length() - 1);
                int dot = fileName.lastIndexOf('.');
                if (dot > 0) return fileName.substring(dot);
            }
        }
        return ".jpg";
    }
}