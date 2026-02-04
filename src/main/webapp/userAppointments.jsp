<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.mycompany.smarthealthprediction.health.db.DBConnection" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }
    Integer userId = (Integer) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .appointment-card {
            transition: all 0.3s;
            border-left: 4px solid #0d6efd;
        }
        .appointment-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .status-pending { border-left-color: #ffc107; }
        .status-confirmed { border-left-color: #17a2b8; }
        .status-paid { border-left-color: #28a745; }
        .status-completed { border-left-color: #28a745; }
        .status-cancelled { border-left-color: #dc3545; }
    </style>
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="userDashboard.jsp">
                <i class="fas fa-heartbeat"></i> Smart Health
            </a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="userDashboard.jsp">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="userAppointments.jsp">My Appointments</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="LogoutServlet">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-calendar-alt"></i> My Appointments</h2>
            <a href="bookAppointment.jsp" class="btn btn-primary">
                <i class="fas fa-plus"></i> Book New Appointment
            </a>
        </div>

        <%-- Success and Error Messages --%>
        <% 
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if (success != null) {
        %>
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle"></i> <%= success %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="fas fa-exclamation-triangle"></i> <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Info Alert for Pending Appointments -->
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i> <strong>How it works:</strong><br>
            <small>
                1. <strong>Pending</strong> - Waiting for doctor's confirmation (No payment required yet)<br>
                2. <strong>Confirmed</strong> - Doctor approved! Pay now to secure your appointment<br>
                3. <strong>Paid</strong> - Payment completed, appointment secured<br>
                4. <strong>Completed</strong> - Appointment finished
            </small>
        </div>

        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = DBConnection.getConnection();
                
                // Get appointments with payment status
                String sql = "SELECT a.*, d.full_name as doctor_name, d.specialization, " +
                           "d.consultation_fee, d.hospital_name, d.location, " +
                           "CASE WHEN p.payment_id IS NOT NULL THEN 1 ELSE 0 END as is_paid " +
                           "FROM appointments a " +
                           "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                           "LEFT JOIN payments p ON a.appointment_id = p.appointment_id " +
                           "WHERE a.user_id = ? " +
                           "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
                
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                
                boolean hasAppointments = false;
                
                while (rs.next()) {
                    hasAppointments = true;
                    int appointmentId = rs.getInt("appointment_id");
                    String status = rs.getString("status");
                    boolean isPaid = rs.getBoolean("is_paid");
                    
                    // Determine display status
                    String displayStatus = status;
                    String badgeClass = "bg-secondary";
                    String cardClass = "status-pending";
                    
                    if (status.equals("Pending")) {
                        badgeClass = "bg-warning text-dark";
                        cardClass = "status-pending";
                    } else if (status.equals("Confirmed")) {
                        if (isPaid) {
                            displayStatus = "Paid";
                            badgeClass = "bg-success";
                            cardClass = "status-paid";
                        } else {
                            badgeClass = "bg-info";
                            cardClass = "status-confirmed";
                        }
                    } else if (status.equals("Completed")) {
                        badgeClass = "bg-success";
                        cardClass = "status-completed";
                    } else if (status.equals("Cancelled")) {
                        badgeClass = "bg-danger";
                        cardClass = "status-cancelled";
                    }
        %>
        
        <div class="card appointment-card <%= cardClass %> mb-3">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-8">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-user-md text-primary"></i> Dr. <%= rs.getString("doctor_name") %>
                            </h5>
                            <span class="badge <%= badgeClass %>"><%= displayStatus %></span>
                        </div>
                        
                        <p class="text-muted mb-2">
                            <i class="fas fa-stethoscope"></i> <%= rs.getString("specialization") %>
                        </p>
                        
                        <div class="row mt-3">
                            <div class="col-md-6">
                                <p class="mb-1">
                                    <i class="fas fa-calendar text-primary"></i> 
                                    <strong>Date:</strong> <%= rs.getDate("appointment_date") %>
                                </p>
                                <p class="mb-1">
                                    <i class="fas fa-clock text-primary"></i> 
                                    <strong>Time:</strong> <%= rs.getString("appointment_time") %>
                                </p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1">
                                    <i class="fas fa-hospital text-primary"></i> 
                                    <%= rs.getString("hospital_name") %>
                                </p>
                                <p class="mb-1">
                                    <i class="fas fa-map-marker-alt text-primary"></i> 
                                    <%= rs.getString("location") %>
                                </p>
                            </div>
                        </div>
                        
                        <p class="mb-1 mt-2">
                            <i class="fas fa-rupee-sign text-success"></i> 
                            <strong>Consultation Fee:</strong> ₹<%= rs.getDouble("consultation_fee") %>
                        </p>
                    </div>
                    
                    <div class="col-md-4 text-end">
                        <div class="d-grid gap-2">
                            <a href="viewAppointmentDetails.jsp?id=<%= appointmentId %>" 
                               class="btn btn-outline-primary btn-sm">
                                <i class="fas fa-eye"></i> View Details
                            </a>
                            
                            <%-- PENDING: No payment option, only cancel --%>
                            <% if (status.equals("Pending")) { %>
                                <div class="alert alert-warning mb-0 p-2">
                                    <small><i class="fas fa-hourglass-half"></i> Waiting for doctor's confirmation</small>
                                </div>
                                <a href="CancelAppointmentServlet?id=<%= appointmentId %>" 
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Cancel this appointment?');">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                            
                            <%-- CONFIRMED but NOT PAID: Show payment button --%>
                            <% } else if (status.equals("Confirmed") && !isPaid) { %>
                                <div class="alert alert-success mb-2 p-2">
                                    <small><i class="fas fa-check-circle"></i> Doctor confirmed! Please pay to secure your appointment</small>
                                </div>
                                <a href="makePayment.jsp?appointmentId=<%= appointmentId %>&amount=<%= rs.getDouble("consultation_fee") %>" 
                                   class="btn btn-success btn-sm">
                                    <i class="fas fa-credit-card"></i> Pay Now
                                </a>
                                <a href="CancelAppointmentServlet?id=<%= appointmentId %>" 
                                   class="btn btn-outline-danger btn-sm"
                                   onclick="return confirm('Cancel this appointment?');">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                            
                            <%-- PAID: Show join/download options --%>
                            <% } else if (status.equals("Confirmed") && isPaid) { %>
                                <div class="alert alert-info mb-2 p-2">
                                    <small><i class="fas fa-check-double"></i> Payment completed</small>
                                </div>
                                <button class="btn btn-primary btn-sm" onclick="alert('Video consultation feature coming soon!')">
                                    <i class="fas fa-video"></i> Join Call
                                </button>
                                <a href="CancelAppointmentServlet?id=<%= appointmentId %>" 
                                   class="btn btn-outline-danger btn-sm"
                                   onclick="return confirm('Cancel? You will be refunded in 5-7 days.');">
                                    <i class="fas fa-ban"></i> Cancel
                                </a>
                            
                            <%-- COMPLETED: Show receipt --%>
                            <% } else if (status.equals("Completed")) { %>
                                <button class="btn btn-outline-secondary btn-sm" onclick="alert('Receipt download coming soon!')">
                                    <i class="fas fa-download"></i> Receipt
                                </button>
                                <a href="bookAppointment.jsp" class="btn btn-outline-primary btn-sm">
                                    <i class="fas fa-redo"></i> Book Again
                                </a>
                            
                            <%-- CANCELLED: Show rebook option --%>
                            <% } else if (status.equals("Cancelled")) { %>
                                <a href="bookAppointment.jsp" class="btn btn-primary btn-sm">
                                    <i class="fas fa-calendar-plus"></i> Book New
                                </a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <%
                }
                
                if (!hasAppointments) {
        %>
                    <div class="text-center py-5">
                        <i class="fas fa-calendar-times fa-4x text-muted mb-3"></i>
                        <h4 class="text-muted">No Appointments Yet</h4>
                        <p class="text-muted">Book your first appointment with our expert doctors</p>
                        <a href="bookAppointment.jsp" class="btn btn-primary btn-lg">
                            <i class="fas fa-plus"></i> Book Appointment
                        </a>
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
