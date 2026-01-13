<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.mycompany.smarthealthprediction.health.db.DBConnection" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }
    
    String appointmentId = request.getParameter("id");
    if (appointmentId == null) {
        response.sendRedirect("userAppointments.jsp?error=Invalid appointment ID");
        return;
    }
    
    Integer userId = (Integer) session.getAttribute("userId");
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
        .detail-card {
            border-left: 4px solid #0d6efd;
        }
        .doctor-photo {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #0d6efd;
        }
    </style>
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="userDashboard.jsp">
                <i class="fas fa-heartbeat"></i> Smart Health
            </a>
            <div class="ms-auto">
                <a href="userAppointments.jsp" class="btn btn-outline-light">
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
                String sql = "SELECT a.*, d.full_name as doctor_name, d.email as doctor_email, " +
                           "d.phone as doctor_phone, d.specialization, d.qualification, " +
                           "d.hospital_name, d.location, d.consultation_fee, " +
                           "d.available_days, d.available_time, d.profile_photo, " +
                           "u.full_name as patient_name, u.email as patient_email, u.phone as patient_phone " +
                           "FROM appointments a " +
                           "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                           "JOIN users u ON a.user_id = u.user_id " +
                           "WHERE a.appointment_id = ? AND a.user_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(appointmentId));
                pstmt.setInt(2, userId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    String status = rs.getString("status");
                    String badgeClass = "bg-secondary";
                    if (status.equals("Pending")) badgeClass = "bg-warning text-dark";
                    else if (status.equals("Confirmed")) badgeClass = "bg-info";
                    else if (status.equals("Completed")) badgeClass = "bg-success";
                    else if (status.equals("Cancelled")) badgeClass = "bg-danger";
        %>
        
        <div class="row">
            <div class="col-md-8">
                <!-- Appointment Overview -->
                <div class="card shadow border-0 mb-4">
                    <div class="card-header bg-primary text-white">
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
                                <p class="text-primary"><i class="fas fa-calendar"></i> <%= new java.text.SimpleDateFormat("EEEE, dd MMMM yyyy").format(rs.getDate("appointment_date")) %></p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-2"><strong>Appointment Time:</strong></p>
                                <p class="text-primary"><i class="fas fa-clock"></i> <%= rs.getString("appointment_time") %></p>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <p class="mb-2"><strong>Symptoms / Reason for Visit:</strong></p>
                            <div class="alert alert-light border">
                                <%= rs.getString("symptoms") %>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <p class="mb-2"><strong>Consultation Fee:</strong></p>
                            <h4 class="text-success">₹<%= String.format("%.2f", rs.getDouble("consultation_fee")) %></h4>
                        </div>
                    </div>
                </div>

                <!-- Doctor Information -->
                <div class="card shadow border-0 mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-user-md"></i> Doctor Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row align-items-center mb-3">
                            <div class="col-md-3 text-center">
                                <%
                                    String photoPath = rs.getString("profile_photo");
                                    if (photoPath != null && !photoPath.isEmpty()) {
                                %>
                                    <img src="<%= photoPath %>" alt="Doctor Photo" class="doctor-photo">
                                <% } else { %>
                                    <img src="https://ui-avatars.com/api/?name=<%= rs.getString("doctor_name") %>&size=120&background=0d6efd&color=fff" 
                                         alt="Doctor Photo" class="doctor-photo">
                                <% } %>
                            </div>
                            <div class="col-md-9">
                                <h4 class="text-primary mb-2">Dr. <%= rs.getString("doctor_name") %></h4>
                                <p class="mb-1"><i class="fas fa-stethoscope text-success"></i> <strong><%= rs.getString("specialization") %></strong></p>
                                <p class="mb-1"><i class="fas fa-graduation-cap text-info"></i> <%= rs.getString("qualification") %></p>
                                <p class="mb-1"><i class="fas fa-hospital text-danger"></i> <%= rs.getString("hospital_name") %></p>
                                <p class="mb-1"><i class="fas fa-map-marker-alt text-warning"></i> <%= rs.getString("location") %></p>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-2"><strong>Contact:</strong></p>
                                <p class="mb-1"><i class="fas fa-phone text-success"></i> <%= rs.getString("doctor_phone") %></p>
                                <p class="mb-1"><i class="fas fa-envelope text-primary"></i> <%= rs.getString("doctor_email") %></p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-2"><strong>Availability:</strong></p>
                                <p class="mb-1"><i class="fas fa-calendar-alt text-info"></i> <%= rs.getString("available_days") %></p>
                                <p class="mb-1"><i class="fas fa-clock text-warning"></i> <%= rs.getString("available_time") %></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Panel -->
            <div class="col-md-4">
                <div class="card shadow border-0 sticky-top" style="top: 20px;">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-tasks"></i> Quick Actions</h5>
                    </div>
                    <div class="card-body">
                        <% if (status.equals("Pending")) { %>
                            <a href="makePayment.jsp?appointmentId=<%= rs.getInt("appointment_id") %>&amount=<%= rs.getDouble("consultation_fee") %>" 
                               class="btn btn-success w-100 mb-2">
                                <i class="fas fa-credit-card"></i> Make Payment
                            </a>
                            <a href="CancelAppointmentServlet?id=<%= rs.getInt("appointment_id") %>" 
                               class="btn btn-danger w-100"
                               onclick="return confirm('Are you sure you want to cancel this appointment?')">
                                <i class="fas fa-times"></i> Cancel Appointment
                            </a>
                        <% } else if (status.equals("Confirmed")) { %>
                            <button class="btn btn-primary w-100 mb-2" onclick="joinMeeting()">
                                <i class="fas fa-video"></i> Join Video Call
                            </button>
                            <a href="CancelAppointmentServlet?id=<%= rs.getInt("appointment_id") %>" 
                               class="btn btn-danger w-100"
                               onclick="return confirm('Are you sure? Refund will be processed in 5-7 days.')">
                                <i class="fas fa-times"></i> Cancel Appointment
                            </a>
                        <% } else if (status.equals("Completed")) { %>
                            <button class="btn btn-secondary w-100 mb-2" onclick="downloadReceipt()">
                                <i class="fas fa-download"></i> Download Receipt
                            </button>
                            <button class="btn btn-warning w-100 mb-2" onclick="rateDoctor()">
                                <i class="fas fa-star"></i> Rate Doctor
                            </button>
                            <a href="bookAppointment.jsp" class="btn btn-primary w-100">
                                <i class="fas fa-redo"></i> Book Again
                            </a>
                        <% } else if (status.equals("Cancelled")) { %>
                            <a href="bookAppointment.jsp" class="btn btn-primary w-100">
                                <i class="fas fa-calendar-plus"></i> Book New Appointment
                            </a>
                        <% } %>
                        
                        <hr>
                        
                        <a href="userAppointments.jsp" class="btn btn-outline-secondary w-100">
                            <i class="fas fa-arrow-left"></i> Back to Appointments
                        </a>
                    </div>
                </div>

                <!-- Need Help Card -->
                <div class="card shadow border-0 mt-3">
                    <div class="card-body text-center">
                        <i class="fas fa-question-circle fa-3x text-primary mb-3"></i>
                        <h6>Need Help?</h6>
                        <p class="small text-muted">Contact our support team</p>
                        <a href="tel:+919876543210" class="btn btn-outline-primary btn-sm">
                            <i class="fas fa-phone"></i> Call Support
                        </a>
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
                        <p>The appointment you're looking for doesn't exist or you don't have permission to view it.</p>
                        <a href="userAppointments.jsp" class="btn btn-primary">Back to Appointments</a>
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
    <script>
        function joinMeeting() {
            alert('Video consultation feature will be available soon!\n\nYou will receive a meeting link via email and SMS before your appointment time.');
        }

        function downloadReceipt() {
            alert('Generating receipt...\n\nReceipt download feature coming soon!');
            // Future: Generate PDF receipt
        }

        function rateDoctor() {
            // Future: Show rating modal
            const rating = prompt('Rate this doctor (1-5 stars):');
            if (rating >= 1 && rating <= 5) {
                alert('Thank you for your feedback!\n\nRating: ' + rating + ' stars');
                // Future: Save rating to database
            }
        }
    </script>
</body>
</html>