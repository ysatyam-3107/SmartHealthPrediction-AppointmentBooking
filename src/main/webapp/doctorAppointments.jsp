<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.mycompany.smarthealthprediction.health.db.DBConnection" %>
<%
    if (session.getAttribute("doctorId") == null) {
        response.sendRedirect("doctorLogin.jsp");
        return;
    }
    Integer doctorId = (Integer) session.getAttribute("doctorId");
    String doctorName = (String) session.getAttribute("doctorName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments - Doctor</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container">
            <a class="navbar-brand" href="doctorDashboard.jsp">
                <i class="fas fa-user-md"></i> Smart Health - Doctor Portal
            </a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="doctorDashboard.jsp">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="doctorAppointments.jsp">My Appointments</a>
                    </li>
                    <li class="nav-item">
    <a class="nav-link" href="doctorReports.jsp">
        <i class="fas fa-chart-bar"></i> Reports
    </a>
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
            <a href="doctorDashboard.jsp" class="btn btn-outline-success">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
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

        <!-- Filter Tabs -->
        <ul class="nav nav-tabs mb-4" id="appointmentTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="all-tab" data-bs-toggle="tab" data-bs-target="#all" type="button">
                    All Appointments
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending" type="button">
                    Pending
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="confirmed-tab" data-bs-toggle="tab" data-bs-target="#confirmed" type="button">
                    Confirmed
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="completed-tab" data-bs-toggle="tab" data-bs-target="#completed" type="button">
                    Completed
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="cancelled-tab" data-bs-toggle="tab" data-bs-target="#cancelled" type="button">
                    Cancelled
                </button>
            </li>
        </ul>

        <div class="tab-content" id="appointmentTabsContent">
            <!-- All Appointments Tab -->
            <div class="tab-pane fade show active" id="all" role="tabpanel">
                <div class="card shadow border-0">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-success">
                                    <tr>
                                        <th>ID</th>
                                        <th>Patient Name</th>
                                        <th>Contact</th>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th>Symptoms</th>
                                        <th>Status</th>
                                        <th>Actions</th>
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
                                                       "a.symptoms, a.status, u.full_name, u.phone, u.email " +
                                                       "FROM appointments a " +
                                                       "JOIN users u ON a.user_id = u.user_id " +
                                                       "WHERE a.doctor_id = ? " +
                                                       "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
                                            pstmt = conn.prepareStatement(sql);
                                            pstmt.setInt(1, doctorId);
                                            rs = pstmt.executeQuery();
                                            
                                            boolean hasRecords = false;
                                            while (rs.next()) {
                                                hasRecords = true;
                                                String status = rs.getString("status");
                                                int appointmentId = rs.getInt("appointment_id");
                                                String badgeClass = "bg-secondary";
                                                if (status.equals("Pending")) badgeClass = "bg-warning text-dark";
                                                else if (status.equals("Confirmed")) badgeClass = "bg-info";
                                                else if (status.equals("Completed")) badgeClass = "bg-success";
                                                else if (status.equals("Cancelled")) badgeClass = "bg-danger";
                                    %>
                                                <tr>
                                                    <td><strong>#<%= appointmentId %></strong></td>
                                                    <td><%= rs.getString("full_name") %></td>
                                                    <td>
                                                        <small><i class="fas fa-phone"></i> <%= rs.getString("phone") %></small><br>
                                                        <small><i class="fas fa-envelope"></i> <%= rs.getString("email") %></small>
                                                    </td>
                                                    <td><%= rs.getDate("appointment_date") %></td>
                                                    <td><%= rs.getString("appointment_time") %></td>
                                                    <td>
                                                        <small><%= rs.getString("symptoms").substring(0, Math.min(30, rs.getString("symptoms").length())) %>...</small>
                                                    </td>
                                                    <td>
                                                        <span class="badge <%= badgeClass %>"><%= status %></span>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group btn-group-sm" role="group">
                                                            <!-- View Details Button (Always shown) -->
                                                            <a href="doctorViewAppointments.jsp?id=<%= appointmentId %>" 
                                                               class="btn btn-outline-primary" 
                                                               title="View Details">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                            
                                                            <% if (status.equals("Pending")) { %>
                                                                <!-- Confirm Button for Pending -->
                                                                <a href="UpdateAppointmentServlet?id=<%= appointmentId %>&status=Confirmed" 
                                                                   class="btn btn-outline-success" 
                                                                   title="Confirm Appointment"
                                                                   onclick="return confirm('Confirm this appointment?');">
                                                                    <i class="fas fa-check"></i>
                                                                </a>
                                                                <!-- Cancel Button for Pending -->
                                                                <a href="DoctorCancelAppointmentServlet?id=<%= appointmentId %>" 
                                                                   class="btn btn-outline-danger" 
                                                                   title="Cancel Appointment"
                                                                   onclick="return confirm('Cancel this appointment? The patient will be notified and the time slot will be freed.');">
                                                                    <i class="fas fa-times"></i>
                                                                </a>
                                                            <% } else if (status.equals("Confirmed")) { %>
                                                                <!-- Complete Button for Confirmed -->
                                                                <a href="UpdateAppointmentServlet?id=<%= appointmentId %>&status=Completed" 
                                                                   class="btn btn-outline-info" 
                                                                   title="Mark as Completed"
                                                                   onclick="return confirm('Mark this appointment as completed?');">
                                                                    <i class="fas fa-check-double"></i>
                                                                </a>
                                                                <!-- Cancel Button for Confirmed -->
                                                                <a href="DoctorCancelAppointmentServlet?id=<%= appointmentId %>" 
                                                                   class="btn btn-outline-danger" 
                                                                   title="Cancel Appointment"
                                                                   onclick="return confirm('Cancel this confirmed appointment? The patient will receive a refund notification and the time slot will be freed.');">
                                                                    <i class="fas fa-ban"></i>
                                                                </a>
                                                            <% } else if (status.equals("Completed")) { %>
                                                                <!-- No action buttons for completed -->
                                                                <button class="btn btn-outline-secondary" disabled title="Completed">
                                                                    <i class="fas fa-check-circle"></i>
                                                                </button>
                                                            <% } else if (status.equals("Cancelled")) { %>
                                                                <!-- No action buttons for cancelled -->
                                                                <button class="btn btn-outline-secondary" disabled title="Cancelled">
                                                                    <i class="fas fa-ban"></i>
                                                                </button>
                                                            <% } %>
                                                        </div>
                                                    </td>
                                                </tr>
                                    <%
                                            }
                                            
                                            if (!hasRecords) {
                                    %>
                                                <tr>
                                                    <td colspan="8" class="text-center text-muted py-4">
                                                        <i class="fas fa-inbox fa-3x mb-3"></i><br>
                                                        No appointments found.
                                                    </td>
                                                </tr>
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
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pending Appointments Tab -->
            <div class="tab-pane fade" id="pending" role="tabpanel">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i> Showing pending appointments that need your confirmation.
                </div>
                <div class="card shadow border-0">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-warning">
                                    <tr>
                                        <th>ID</th>
                                        <th>Patient Name</th>
                                        <th>Contact</th>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th>Symptoms</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        conn = null;
                                        pstmt = null;
                                        rs = null;
                                        
                                        try {
                                            conn = DBConnection.getConnection();
                                            String sql = "SELECT a.appointment_id, a.appointment_date, a.appointment_time, " +
                                                       "a.symptoms, u.full_name, u.phone, u.email " +
                                                       "FROM appointments a " +
                                                       "JOIN users u ON a.user_id = u.user_id " +
                                                       "WHERE a.doctor_id = ? AND a.status = 'Pending' " +
                                                       "ORDER BY a.appointment_date ASC, a.appointment_time ASC";
                                            pstmt = conn.prepareStatement(sql);
                                            pstmt.setInt(1, doctorId);
                                            rs = pstmt.executeQuery();
                                            
                                            boolean hasRecords = false;
                                            while (rs.next()) {
                                                hasRecords = true;
                                                int appointmentId = rs.getInt("appointment_id");
                                    %>
                                                <tr>
                                                    <td><strong>#<%= appointmentId %></strong></td>
                                                    <td><%= rs.getString("full_name") %></td>
                                                    <td>
                                                        <small><i class="fas fa-phone"></i> <%= rs.getString("phone") %></small><br>
                                                        <small><i class="fas fa-envelope"></i> <%= rs.getString("email") %></small>
                                                    </td>
                                                    <td><%= rs.getDate("appointment_date") %></td>
                                                    <td><%= rs.getString("appointment_time") %></td>
                                                    <td><small><%= rs.getString("symptoms").substring(0, Math.min(50, rs.getString("symptoms").length())) %>...</small></td>
                                                    <td>
                                                        <div class="btn-group btn-group-sm">
                                                            <a href="viewAppointment.jsp?id=<%= appointmentId %>" 
                                                               class="btn btn-outline-primary">
                                                                <i class="fas fa-eye"></i> View
                                                            </a>
                                                            <a href="UpdateAppointmentServlet?id=<%= appointmentId %>&status=Confirmed" 
                                                               class="btn btn-success"
                                                               onclick="return confirm('Confirm this appointment?');">
                                                                <i class="fas fa-check"></i> Confirm
                                                            </a>
                                                            <a href="DoctorCancelAppointmentServlet?id=<%= appointmentId %>" 
                                                               class="btn btn-danger"
                                                               onclick="return confirm('Cancel this appointment?');">
                                                                <i class="fas fa-times"></i> Cancel
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                    <%
                                            }
                                            
                                            if (!hasRecords) {
                                    %>
                                                <tr>
                                                    <td colspan="7" class="text-center text-muted py-4">
                                                        <i class="fas fa-check-circle fa-3x mb-3"></i><br>
                                                        No pending appointments.
                                                    </td>
                                                </tr>
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
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Confirmed Appointments Tab -->
            <div class="tab-pane fade" id="confirmed" role="tabpanel">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i> Showing confirmed appointments.
                </div>
                <div class="card shadow border-0">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-info">
                                    <tr>
                                        <th>ID</th>
                                        <th>Patient Name</th>
                                        <th>Contact</th>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th>Symptoms</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        conn = null;
                                        pstmt = null;
                                        rs = null;
                                        
                                        try {
                                            conn = DBConnection.getConnection();
                                            String sql = "SELECT a.appointment_id, a.appointment_date, a.appointment_time, " +
                                                       "a.symptoms, u.full_name, u.phone, u.email " +
                                                       "FROM appointments a " +
                                                       "JOIN users u ON a.user_id = u.user_id " +
                                                       "WHERE a.doctor_id = ? AND a.status = 'Confirmed' " +
                                                       "ORDER BY a.appointment_date ASC, a.appointment_time ASC";
                                            pstmt = conn.prepareStatement(sql);
                                            pstmt.setInt(1, doctorId);
                                            rs = pstmt.executeQuery();
                                            
                                            boolean hasRecords = false;
                                            while (rs.next()) {
                                                hasRecords = true;
                                                int appointmentId = rs.getInt("appointment_id");
                                    %>
                                                <tr>
                                                    <td><strong>#<%= appointmentId %></strong></td>
                                                    <td><%= rs.getString("full_name") %></td>
                                                    <td>
                                                        <small><i class="fas fa-phone"></i> <%= rs.getString("phone") %></small><br>
                                                        <small><i class="fas fa-envelope"></i> <%= rs.getString("email") %></small>
                                                    </td>
                                                    <td><%= rs.getDate("appointment_date") %></td>
                                                    <td><%= rs.getString("appointment_time") %></td>
                                                    <td><small><%= rs.getString("symptoms").substring(0, Math.min(50, rs.getString("symptoms").length())) %>...</small></td>
                                                    <td>
                                                        <div class="btn-group btn-group-sm">
                                                            <a href="viewAppointment.jsp?id=<%= appointmentId %>" 
                                                               class="btn btn-outline-primary">
                                                                <i class="fas fa-eye"></i> View
                                                            </a>
                                                            <a href="UpdateAppointmentServlet?id=<%= appointmentId %>&status=Completed" 
                                                               class="btn btn-info"
                                                               onclick="return confirm('Mark as completed?');">
                                                                <i class="fas fa-check-double"></i> Complete
                                                            </a>
                                                            <a href="DoctorCancelAppointmentServlet?id=<%= appointmentId %>" 
                                                               class="btn btn-danger"
                                                               onclick="return confirm('Cancel this confirmed appointment? Patient will be refunded.');">
                                                                <i class="fas fa-ban"></i> Cancel
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                    <%
                                            }
                                            
                                            if (!hasRecords) {
                                    %>
                                                <tr>
                                                    <td colspan="7" class="text-center text-muted py-4">
                                                        <i class="fas fa-calendar-check fa-3x mb-3"></i><br>
                                                        No confirmed appointments.
                                                    </td>
                                                </tr>
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
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Completed Appointments Tab -->
            <div class="tab-pane fade" id="completed" role="tabpanel">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> Showing completed appointments.
                </div>
                <div class="card shadow border-0">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-success">
                                    <tr>
                                        <th>ID</th>
                                        <th>Patient Name</th>
                                        <th>Contact</th>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th>Symptoms</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        conn = null;
                                        pstmt = null;
                                        rs = null;
                                        
                                        try {
                                            conn = DBConnection.getConnection();
                                            String sql = "SELECT a.appointment_id, a.appointment_date, a.appointment_time, " +
                                                       "a.symptoms, u.full_name, u.phone, u.email " +
                                                       "FROM appointments a " +
                                                       "JOIN users u ON a.user_id = u.user_id " +
                                                       "WHERE a.doctor_id = ? AND a.status = 'Completed' " +
                                                       "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
                                            pstmt = conn.prepareStatement(sql);
                                            pstmt.setInt(1, doctorId);
                                            rs = pstmt.executeQuery();
                                            
                                            boolean hasRecords = false;
                                            while (rs.next()) {
                                                hasRecords = true;
                                                int appointmentId = rs.getInt("appointment_id");
                                    %>
                                                <tr>
                                                    <td><strong>#<%= appointmentId %></strong></td>
                                                    <td><%= rs.getString("full_name") %></td>
                                                    <td>
                                                        <small><i class="fas fa-phone"></i> <%= rs.getString("phone") %></small><br>
                                                        <small><i class="fas fa-envelope"></i> <%= rs.getString("email") %></small>
                                                    </td>
                                                    <td><%= rs.getDate("appointment_date") %></td>
                                                    <td><%= rs.getString("appointment_time") %></td>
                                                    <td><small><%= rs.getString("symptoms").substring(0, Math.min(50, rs.getString("symptoms").length())) %>...</small></td>
                                                    <td>
                                                        <a href="viewAppointment.jsp?id=<%= appointmentId %>" 
                                                           class="btn btn-outline-primary btn-sm">
                                                            <i class="fas fa-eye"></i> View Details
                                                        </a>
                                                    </td>
                                                </tr>
                                    <%
                                            }
                                            
                                            if (!hasRecords) {
                                    %>
                                                <tr>
                                                    <td colspan="7" class="text-center text-muted py-4">
                                                        <i class="fas fa-clipboard-check fa-3x mb-3"></i><br>
                                                        No completed appointments yet.
                                                    </td>
                                                </tr>
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
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Cancelled Appointments Tab -->
            <div class="tab-pane fade" id="cancelled" role="tabpanel">
                <div class="alert alert-danger">
                    <i class="fas fa-ban"></i> Showing cancelled appointments.
                </div>
                <div class="card shadow border-0">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-danger">
                                    <tr>
                                        <th>ID</th>
                                        <th>Patient Name</th>
                                        <th>Contact</th>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th>Symptoms</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        conn = null;
                                        pstmt = null;
                                        rs = null;
                                        
                                        try {
                                            conn = DBConnection.getConnection();
                                            String sql = "SELECT a.appointment_id, a.appointment_date, a.appointment_time, " +
                                                       "a.symptoms, u.full_name, u.phone, u.email " +
                                                       "FROM appointments a " +
                                                       "JOIN users u ON a.user_id = u.user_id " +
                                                       "WHERE a.doctor_id = ? AND a.status = 'Cancelled' " +
                                                       "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
                                            pstmt = conn.prepareStatement(sql);
                                            pstmt.setInt(1, doctorId);
                                            rs = pstmt.executeQuery();
                                            
                                            boolean hasRecords = false;
                                            while (rs.next()) {
                                                hasRecords = true;
                                                int appointmentId = rs.getInt("appointment_id");
                                    %>
                                                <tr class="table-light">
                                                    <td><strong>#<%= appointmentId %></strong></td>
                                                    <td><%= rs.getString("full_name") %></td>
                                                    <td>
                                                        <small><i class="fas fa-phone"></i> <%= rs.getString("phone") %></small><br>
                                                        <small><i class="fas fa-envelope"></i> <%= rs.getString("email") %></small>
                                                    </td>
                                                    <td><%= rs.getDate("appointment_date") %></td>
                                                    <td><%= rs.getString("appointment_time") %></td>
                                                    <td><small><%= rs.getString("symptoms").substring(0, Math.min(50, rs.getString("symptoms").length())) %>...</small></td>
                                                    <td>
                                                        <a href="viewAppointment.jsp?id=<%= appointmentId %>" 
                                                           class="btn btn-outline-secondary btn-sm">
                                                            <i class="fas fa-eye"></i> View Details
                                                        </a>
                                                    </td>
                                                </tr>
                                    <%
                                            }
                                            
                                            if (!hasRecords) {
                                    %>
                                                <tr>
                                                    <td colspan="7" class="text-center text-muted py-4">
                                                        <i class="fas fa-smile fa-3x mb-3"></i><br>
                                                        No cancelled appointments.
                                                    </td>
                                                </tr>
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
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
