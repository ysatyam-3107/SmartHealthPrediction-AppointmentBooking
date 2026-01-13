<%@page import="com.mycompany.smarthealthprediction.health.db.DBConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.mycompany.smarthealthprediction.health.db.DBConnection" %>
<%
    if (session.getAttribute("doctorId") == null) {
        response.sendRedirect("doctorLogin.jsp");
        return;
    }
    String doctorName = (String) session.getAttribute("doctorName");
    String specialization = (String) session.getAttribute("specialization");
    Integer doctorId = (Integer) session.getAttribute("doctorId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .stat-card {
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .appointment-card {
            border-left: 4px solid #28a745;
        }
    </style>
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container">
            <a class="navbar-brand" href="doctorDashboard.jsp">
                <i class="fas fa-user-md"></i> Smart Health - Doctor Portal
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="doctorDashboard.jsp">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="doctorAppointments.jsp">My Appointments</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-md"></i> Dr. <%= doctorName %>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="doctorProfile.jsp">Profile</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="LogoutServlet">Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <!-- Welcome Header -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow-sm border-0 bg-success text-white">
                    <div class="card-body p-4">
                        <h2 class="mb-2"><i class="fas fa-hand-wave"></i> Welcome, Dr. <%= doctorName %>!</h2>
                        <p class="mb-0"><i class="fas fa-stethoscope"></i> Specialization: <%= specialization %></p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="row g-4 mb-5">
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                
                int totalAppointments = 0;
                int pendingAppointments = 0;
                int confirmedAppointments = 0;
                int completedAppointments = 0;
                
                try {
                    conn = DBConnection.getConnection();
                    
                    // Get total appointments
                    String totalSql = "SELECT COUNT(*) as total FROM appointments WHERE doctor_id = ?";
                    pstmt = conn.prepareStatement(totalSql);
                    pstmt.setInt(1, doctorId);
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        totalAppointments = rs.getInt("total");
                    }
                    rs.close();
                    pstmt.close();
                    
                    // Get pending appointments
                    String pendingSql = "SELECT COUNT(*) as pending FROM appointments WHERE doctor_id = ? AND status = 'Pending'";
                    pstmt = conn.prepareStatement(pendingSql);
                    pstmt.setInt(1, doctorId);
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        pendingAppointments = rs.getInt("pending");
                    }
                    rs.close();
                    pstmt.close();
                    
                    // Get confirmed appointments
                    String confirmedSql = "SELECT COUNT(*) as confirmed FROM appointments WHERE doctor_id = ? AND status = 'Confirmed'";
                    pstmt = conn.prepareStatement(confirmedSql);
                    pstmt.setInt(1, doctorId);
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        confirmedAppointments = rs.getInt("confirmed");
                    }
                    rs.close();
                    pstmt.close();
                    
                    // Get completed appointments
                    String completedSql = "SELECT COUNT(*) as completed FROM appointments WHERE doctor_id = ? AND status = 'Completed'";
                    pstmt = conn.prepareStatement(completedSql);
                    pstmt.setInt(1, doctorId);
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        completedAppointments = rs.getInt("completed");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                }
            %>
            
            <div class="col-md-3">
                <div class="card stat-card shadow border-0 bg-primary text-white">
                    <div class="card-body text-center p-4">
                        <i class="fas fa-calendar-check fa-3x mb-3"></i>
                        <h3 class="display-4"><%= totalAppointments %></h3>
                        <p class="mb-0">Total Appointments</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card stat-card shadow border-0 bg-warning text-white">
                    <div class="card-body text-center p-4">
                        <i class="fas fa-clock fa-3x mb-3"></i>
                        <h3 class="display-4"><%= pendingAppointments %></h3>
                        <p class="mb-0">Pending</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card stat-card shadow border-0 bg-info text-white">
                    <div class="card-body text-center p-4">
                        <i class="fas fa-check-circle fa-3x mb-3"></i>
                        <h3 class="display-4"><%= confirmedAppointments %></h3>
                        <p class="mb-0">Confirmed</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card stat-card shadow border-0 bg-success text-white">
                    <div class="card-body text-center p-4">
                        <i class="fas fa-check-double fa-3x mb-3"></i>
                        <h3 class="display-4"><%= completedAppointments %></h3>
                        <p class="mb-0">Completed</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Today's Appointments -->
        <div class="row">
            <div class="col-12">
                <div class="card shadow border-0">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-calendar-day"></i> Today's Appointments</h5>
                    </div>
                    <div class="card-body">
                        <%
                            try {
                                String todaySql = "SELECT a.appointment_id, a.appointment_date, a.appointment_time, " +
                                                "a.symptoms, a.status, u.full_name, u.phone, u.email " +
                                                "FROM appointments a " +
                                                "JOIN users u ON a.user_id = u.user_id " +
                                                "WHERE a.doctor_id = ? AND DATE(a.appointment_date) = CURDATE() " +
                                                "ORDER BY a.appointment_time";
                                pstmt = conn.prepareStatement(todaySql);
                                pstmt.setInt(1, doctorId);
                                rs = pstmt.executeQuery();
                                
                                boolean hasAppointments = false;
                                while (rs.next()) {
                                    hasAppointments = true;
                        %>
                                    <div class="appointment-card card mb-3">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-md-3">
                                                    <h6 class="mb-1"><i class="fas fa-user"></i> <%= rs.getString("full_name") %></h6>
                                                    <small class="text-muted">
                                                        <i class="fas fa-phone"></i> <%= rs.getString("phone") %>
                                                    </small>
                                                </div>
                                                <div class="col-md-2">
                                                    <i class="fas fa-clock text-primary"></i> 
                                                    <strong><%= rs.getString("appointment_time") %></strong>
                                                </div>
                                                <div class="col-md-4">
                                                    <small class="text-muted">Symptoms:</small><br>
                                                    <%= rs.getString("symptoms").substring(0, Math.min(50, rs.getString("symptoms").length())) %>...
                                                </div>
                                                <div class="col-md-2">
                                                    <%
                                                        String status = rs.getString("status");
                                                        String badgeClass = "bg-secondary";
                                                        if (status.equals("Pending")) badgeClass = "bg-warning";
                                                        else if (status.equals("Confirmed")) badgeClass = "bg-info";
                                                        else if (status.equals("Completed")) badgeClass = "bg-success";
                                                    %>
                                                    <span class="badge <%= badgeClass %>"><%= status %></span>
                                                </div>
                                                <div class="col-md-1">
                                                    <a href="viewAppointment.jsp?id=<%= rs.getInt("appointment_id") %>" 
                                                       class="btn btn-sm btn-outline-success">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                        <%
                                }
                                
                                if (!hasAppointments) {
                        %>
                                    <div class="alert alert-info text-center">
                                        <i class="fas fa-info-circle"></i> No appointments scheduled for today.
                                    </div>
                        <%
                                }
                            } catch (SQLException e) {
                                e.printStackTrace();
                            } finally {
                                if (rs != null) rs.close();
                                if (pstmt != null) pstmt.close();
                                if (conn != null) conn.close();
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mt-4">
            <div class="col-12">
                <h4 class="mb-3">Quick Actions</h4>
            </div>
            <div class="col-md-4">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-body text-center p-4">
                        <i class="fas fa-list-ul fa-3x text-success mb-3"></i>
                        <h5>View All Appointments</h5>
                        <p class="text-muted">See all your scheduled appointments</p>
                        <a href="doctorAppointments.jsp" class="btn btn-success">View All</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-body text-center p-4">
                        <i class="fas fa-user-edit fa-3x text-primary mb-3"></i>
                        <h5>Update Profile</h5>
                        <p class="text-muted">Edit your professional information</p>
                        <a href="doctorProfile.jsp" class="btn btn-primary">Edit Profile</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-body text-center p-4">
                        <i class="fas fa-chart-line fa-3x text-info mb-3"></i>
                        <h5>View Reports</h5>
                        <p class="text-muted">Check your appointment statistics</p>
                        <a href="doctorReports.jsp" class="btn btn-info">View Reports</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="bg-dark text-white text-center py-3 mt-5">
        <p class="mb-0">&copy; 2024 Smart Health System - Doctor Portal</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>