<%@page import="com.mycompany.smarthealthprediction.health.db.DBConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.mycompany.smarthealthprediction.health.db.DBConnection" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
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
        .action-btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
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
                        <a class="nav-link" href="bookAppointment.jsp">Book Appointment</a>
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

        <% 
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if (success != null) {
        %>
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle"></i> <%= success %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } 
           if (error != null) {
        %>
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="fas fa-exclamation-circle"></i> <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card shadow border-0">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-primary">
                            <tr>
                                <th>ID</th>
                                <th>Doctor</th>
                                <th>Specialization</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Fee</th>
                                <th>Status</th>
                                <th style="width: 200px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection conn = null;
                                PreparedStatement pstmt = null;
                                ResultSet rs = null;
                                
                                try {
                                    conn = DBConnection.getConnection();
                                    String sql = "SELECT a.appointment_id, a.appointment_date, a.appointment_time, " +
                                               "a.status, a.symptoms, d.full_name as doctor_name, d.specialization, d.consultation_fee " +
                                               "FROM appointments a " +
                                               "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                                               "WHERE a.user_id = ? " +
                                               "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
                                    pstmt = conn.prepareStatement(sql);
                                    pstmt.setInt(1, userId);
                                    rs = pstmt.executeQuery();
                                    
                                    boolean hasRecords = false;
                                    while (rs.next()) {
                                        hasRecords = true;
                                        String status = rs.getString("status");
                                        String badgeClass = "bg-secondary";
                                        if (status.equals("Pending")) badgeClass = "bg-warning text-dark";
                                        else if (status.equals("Confirmed")) badgeClass = "bg-info";
                                        else if (status.equals("Completed")) badgeClass = "bg-success";
                                        else if (status.equals("Cancelled")) badgeClass = "bg-danger";
                            %>
                                        <tr>
                                            <td><strong>#<%= rs.getInt("appointment_id") %></strong></td>
                                            <td>
                                                <strong>Dr. <%= rs.getString("doctor_name") %></strong>
                                            </td>
                                            <td><%= rs.getString("specialization") %></td>
                                            <td><%= rs.getDate("appointment_date") %></td>
                                            <td><%= rs.getString("appointment_time") %></td>
                                            <td><strong>₹<%= String.format("%.2f", rs.getDouble("consultation_fee")) %></strong></td>
                                            <td>
                                                <span class="badge <%= badgeClass %>"><%= status %></span>
                                            </td>
                                            <td>
                                                <div class="btn-group-vertical w-100" role="group">
                                                    <!-- View Details Button - Always Available -->
                                                    <a href="viewAppointmentDetails.jsp?id=<%= rs.getInt("appointment_id") %>" 
                                                       class="btn btn-sm btn-outline-primary action-btn mb-1" 
                                                       title="View Details">
                                                        <i class="fas fa-eye"></i> View
                                                    </a>
                                                    
                                                    <% if (status.equals("Pending")) { %>
                                                        <!-- Make Payment Button -->
                                                        <a href="makePayment.jsp?appointmentId=<%= rs.getInt("appointment_id") %>&amount=<%= rs.getDouble("consultation_fee") %>" 
                                                           class="btn btn-sm btn-success action-btn mb-1" 
                                                           title="Make Payment">
                                                            <i class="fas fa-credit-card"></i> Pay
                                                        </a>
                                                        
                                                        <!-- Cancel Button -->
                                                        <a href="CancelAppointmentServlet?id=<%= rs.getInt("appointment_id") %>" 
                                                           class="btn btn-sm btn-danger action-btn" 
                                                           title="Cancel Appointment"
                                                           onclick="return confirm('Are you sure you want to cancel this appointment?')">
                                                            <i class="fas fa-times"></i> Cancel
                                                        </a>
                                                    <% } %>
                                                    
                                                    <% if (status.equals("Confirmed")) { %>
                                                        <!-- Join Meeting Button (Future Feature) -->
                                                        <button class="btn btn-sm btn-info action-btn mb-1" 
                                                                title="Join Video Consultation"
                                                                disabled>
                                                            <i class="fas fa-video"></i> Join
                                                        </button>
                                                        
                                                        
                                                        <a href="CancelAppointmentServlet?id=<%= rs.getInt("appointment_id") %>" 
                                                           class="btn btn-sm btn-danger action-btn" 
                                                           title="Cancel Appointment"
                                                           onclick="return confirm('Are you sure you want to cancel this appointment? Refund will be processed within 5-7 business days.')">
                                                            <i class="fas fa-times"></i> Cancel
                                                        </a>
                                                    <% } %>
                                                    
                                                    <% if (status.equals("Completed")) { %>
                                                        <!-- Download Receipt -->
                                                        <button class="btn btn-sm btn-secondary action-btn mb-1" 
                                                                title="Download Receipt"
                                                                onclick="alert('Receipt download feature coming soon!')">
                                                            <i class="fas fa-download"></i> Receipt
                                                        </button>
                                                        
                                                        <!-- Rate Doctor -->
                                                        <button class="btn btn-sm btn-warning action-btn" 
                                                                title="Rate Doctor"
                                                                onclick="alert('Rating feature coming soon!')">
                                                            <i class="fas fa-star"></i> Rate
                                                        </button>
                                                    <% } %>
                                                    
                                                    <% if (status.equals("Cancelled")) { %>
                                                        <!-- Rebook Button -->
                                                        <a href="bookAppointment.jsp" 
                                                           class="btn btn-sm btn-primary action-btn" 
                                                           title="Book New Appointment">
                                                            <i class="fas fa-redo"></i> Rebook
                                                        </a>
                                                    <% } %>
                                                </div>
                                            </td>
                                        </tr>
                            <%
                                    }
                                    
                                    if (!hasRecords) {
                            %>
                                        <tr>
                                            <td colspan="8" class="text-center text-muted py-5">
                                                <i class="fas fa-calendar-times fa-3x mb-3 d-block"></i>
                                                <h5>No appointments found</h5>
                                                <p>Book your first appointment to get started!</p>
                                                <a href="bookAppointment.jsp" class="btn btn-primary mt-2">
                                                    <i class="fas fa-plus"></i> Book Appointment
                                                </a>
                                            </td>
                                        </tr>
                            <%
                                    }
                                } catch (SQLException e) {
                                    e.printStackTrace();
                            %>
                                    <tr>
                                        <td colspan="8" class="text-center text-danger py-4">
                                            <i class="fas fa-exclamation-triangle fa-2x mb-2 d-block"></i>
                                            <strong>Error loading appointments.</strong><br>
                                            <small><%= e.getMessage() %></small>
                                        </td>
                                    </tr>
                            <%
                                } finally {
                                    if (rs != null) rs.close();
                                    if (pstmt != null) pstmt.close();
                                    if (conn != null) conn.close();
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Appointment Legend -->
        <div class="card mt-4 border-0 bg-light">
            <div class="card-body">
                <h6 class="mb-3"><i class="fas fa-info-circle"></i> Status Legend:</h6>
                <div class="row">
                    <div class="col-md-3 mb-2">
                        <span class="badge bg-warning text-dark">Pending</span> 
                        <small>- Payment pending</small>
                    </div>
                    <div class="col-md-3 mb-2">
                        <span class="badge bg-info">Confirmed</span> 
                        <small>- Payment done</small>
                    </div>
                    <div class="col-md-3 mb-2">
                        <span class="badge bg-success">Completed</span> 
                        <small>- Consultation done</small>
                    </div>
                    <div class="col-md-3 mb-2">
                        <span class="badge bg-danger">Cancelled</span> 
                        <small>- Appointment cancelled</small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>