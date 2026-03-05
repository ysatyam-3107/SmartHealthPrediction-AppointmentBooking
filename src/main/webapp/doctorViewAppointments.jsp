<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.mycompany.smarthealthprediction.health.db.DBConnection" %>
<%
    if (session.getAttribute("doctorId") == null) {
        response.sendRedirect("doctorLogin.jsp");
        return;
    }
    String appointmentId = request.getParameter("id");
    if (appointmentId == null) {
        response.sendRedirect("doctorAppointments.jsp?error=Invalid appointment ID");
        return;
    }
    Integer doctorId = (Integer) session.getAttribute("doctorId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .patient-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: linear-gradient(135deg, #198754, #20c997);
            color: white;
            font-size: 2rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            border: 4px solid #198754;
            box-shadow: 0 6px 20px rgba(25,135,84,0.35);
        }
    </style>
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container">
            <a class="navbar-brand" href="doctorDashboard.jsp">
                <i class="fas fa-heartbeat"></i> Smart Health - Doctor Portal
            </a>
            <div class="ms-auto">
                <a href="doctorAppointments.jsp" class="btn btn-outline-light">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                conn = DBConnection.getConnection();
                String sql = "SELECT a.*, " +
                             "u.full_name as patient_name, u.email as patient_email, u.phone as patient_phone, u.gender, u.date_of_birth, " +
                             "d.full_name as doctor_name, d.consultation_fee " +
                             "FROM appointments a " +
                             "JOIN users u ON a.user_id = u.user_id " +
                             "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                             "WHERE a.appointment_id = ? AND a.doctor_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(appointmentId));
                pstmt.setInt(2, doctorId);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    String status = rs.getString("status");
                    String badgeClass = "bg-secondary";
                    if (status.equals("Pending"))    badgeClass = "bg-warning text-dark";
                    else if (status.equals("Confirmed"))  badgeClass = "bg-info";
                    else if (status.equals("Completed"))  badgeClass = "bg-success";
                    else if (status.equals("Cancelled"))  badgeClass = "bg-danger";

                    String patientName = rs.getString("patient_name");
                    String ptInitials = "";
                    String[] ptParts = patientName.trim().split("\\s+");
                    if (ptParts.length >= 2) {
                        ptInitials = String.valueOf(ptParts[0].charAt(0)).toUpperCase() +
                                     String.valueOf(ptParts[ptParts.length - 1].charAt(0)).toUpperCase();
                    } else {
                        ptInitials = String.valueOf(ptParts[0].charAt(0)).toUpperCase();
                    }
        %>

        <div class="row">
            <!-- LEFT: Main Content -->
            <div class="col-md-8">

                <!-- Appointment Overview -->
                <div class="card shadow border-0 mb-4">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0">
                            <i class="fas fa-calendar-check"></i> Appointment Details
                            <span class="badge <%= badgeClass %> float-end"><%= status %></span>
                        </h4>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <p class="mb-2"><strong>Appointment ID:</strong></p>
                                <p class="text-muted">#<%= rs.getInt("appointment_id") %></p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-2"><strong>Booked On:</strong></p>
                                <p class="text-muted"><%= new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(rs.getTimestamp("created_at")) %></p>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <p class="mb-2"><strong>Appointment Date:</strong></p>
                                <p class="text-success"><i class="fas fa-calendar"></i> <%= new java.text.SimpleDateFormat("EEEE, dd MMMM yyyy").format(rs.getDate("appointment_date")) %></p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-2"><strong>Appointment Time:</strong></p>
                                <p class="text-success"><i class="fas fa-clock"></i> <%= rs.getString("appointment_time") %></p>
                            </div>
                        </div>
                        <div class="mb-3">
                            <p class="mb-2"><strong>Symptoms / Reason for Visit:</strong></p>
                            <div class="alert alert-light border"><%= rs.getString("symptoms") %></div>
                        </div>
                        <div class="mb-3">
                            <p class="mb-2"><strong>Consultation Fee:</strong></p>
                            <h4 class="text-success">₹<%= String.format("%.2f", rs.getDouble("consultation_fee")) %></h4>
                        </div>
                    </div>
                </div>

                <!-- Patient Information -->
                <div class="card shadow border-0 mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-user"></i> Patient Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row align-items-center mb-3">
                            <div class="col-md-3 text-center">
                                <div class="patient-avatar"><%= ptInitials %></div>
                            </div>
                            <div class="col-md-9">
                                <h4 class="text-primary mb-2"><%= rs.getString("patient_name") %></h4>
                                <p class="mb-1"><i class="fas fa-phone text-success"></i> <%= rs.getString("patient_phone") %></p>
                                <p class="mb-1"><i class="fas fa-envelope text-primary"></i> <%= rs.getString("patient_email") %></p>
                                <% if (rs.getString("gender") != null) { %>
                                <p class="mb-1"><i class="fas fa-venus-mars text-info"></i> <%= rs.getString("gender") %></p>
                                <% } %>
                                <% if (rs.getString("date_of_birth") != null) { %>
                                <p class="mb-1"><i class="fas fa-birthday-cake text-warning"></i> <%= rs.getString("date_of_birth") %></p>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- RIGHT: Quick Actions -->
            <div class="col-md-4">
                <div class="sticky-top" style="top: 20px;">

                    <div class="card shadow border-0">
                        <div class="card-header bg-info text-white">
                            <h5 class="mb-0"><i class="fas fa-tasks"></i> Quick Actions</h5>
                        </div>
                        <div class="card-body">
                            <% if (status.equals("Pending")) { %>
                                <a href="UpdateAppointmentServlet?id=<%= rs.getInt("appointment_id") %>&status=Confirmed"
                                   class="btn btn-success w-100 mb-2"
                                   onclick="return confirm('Confirm this appointment?')">
                                    <i class="fas fa-check"></i> Confirm Appointment
                                </a>
                                <a href="UpdateAppointmentServlet?id=<%= rs.getInt("appointment_id") %>&status=Cancelled"
                                   class="btn btn-danger w-100"
                                   onclick="return confirm('Cancel this appointment?')">
                                    <i class="fas fa-times"></i> Cancel Appointment
                                </a>
                            <% } else if (status.equals("Confirmed")) { %>
                                <a href="UpdateAppointmentServlet?id=<%= rs.getInt("appointment_id") %>&status=Completed"
                                   class="btn btn-primary w-100 mb-2"
                                   onclick="return confirm('Mark this appointment as completed?')">
                                    <i class="fas fa-check-double"></i> Mark as Completed
                                </a>
                                <a href="UpdateAppointmentServlet?id=<%= rs.getInt("appointment_id") %>&status=Cancelled"
                                   class="btn btn-danger w-100"
                                   onclick="return confirm('Cancel this appointment?')">
                                    <i class="fas fa-times"></i> Cancel Appointment
                                </a>
                            <% } else if (status.equals("Completed")) { %>
                                <div class="alert alert-success text-center">
                                    <i class="fas fa-check-circle fa-2x mb-2 d-block"></i>
                                    Appointment Completed
                                </div>
                            <% } else if (status.equals("Cancelled")) { %>
                                <div class="alert alert-danger text-center">
                                    <i class="fas fa-times-circle fa-2x mb-2 d-block"></i>
                                    Appointment Cancelled
                                </div>
                            <% } %>

                            <hr>

                            <a href="doctorAppointments.jsp" class="btn btn-outline-secondary w-100">
                                <i class="fas fa-arrow-left"></i> Back to Appointments
                            </a>
                        </div>
                    </div>

                    <!-- Patient Contact Card -->
                    <div class="card shadow border-0 mt-3">
                        <div class="card-body text-center">
                            <i class="fas fa-phone-alt fa-3x text-success mb-3"></i>
                            <h6>Contact Patient</h6>
                            <a href="tel:<%= rs.getString("patient_phone") %>" class="btn btn-outline-success btn-sm w-100 mb-2">
                                <i class="fas fa-phone"></i> <%= rs.getString("patient_phone") %>
                            </a>
                            <a href="mailto:<%= rs.getString("patient_email") %>" class="btn btn-outline-primary btn-sm w-100">
                                <i class="fas fa-envelope"></i> Send Email
                            </a>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <%
                } else {
        %>
            <div class="alert alert-danger text-center">
                <i class="fas fa-exclamation-triangle fa-3x mb-3"></i>
                <h4>Appointment Not Found</h4>
                <p>This appointment doesn't exist or you don't have permission to view it.</p>
                <a href="doctorAppointments.jsp" class="btn btn-success">Back to Appointments</a>
            </div>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
        %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i>
                <strong>Error:</strong> <%= e.getMessage() %>
            </div>
        <%
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
