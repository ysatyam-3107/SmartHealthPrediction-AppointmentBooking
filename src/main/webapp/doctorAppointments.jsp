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
                                                String badgeClass = "bg-secondary";
                                                if (status.equals("Pending")) badgeClass = "bg-warning text-dark";
                                                else if (status.equals("Confirmed")) badgeClass = "bg-info";
                                                else if (status.equals("Completed")) badgeClass = "bg-success";
                                                else if (status.equals("Cancelled")) badgeClass = "bg-danger";
                                    %>
                                                <tr>
                                                    <td><strong>#<%= rs.getInt("appointment_id") %></strong></td>
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
                                                        <div class="btn-group btn-group-sm">
                                                            <a href="viewAppointment.jsp?id=<%= rs.getInt("appointment_id") %>" 
                                                               class="btn btn-outline-primary" title="View Details">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                            <% if (status.equals("Pending")) { %>
                                                            <a href="UpdateAppointmentServlet?id=<%= rs.getInt("appointment_id") %>&status=Confirmed" 
                                                               class="btn btn-outline-success" title="Confirm">
                                                                <i class="fas fa-check"></i>
                                                            </a>
                                                            <% } %>
                                                            <% if (status.equals("Confirmed")) { %>
                                                            <a href="UpdateAppointmentServlet?id=<%= rs.getInt("appointment_id") %>&status=Completed" 
                                                               class="btn btn-outline-info" title="Mark Completed">
                                                                <i class="fas fa-check-double"></i>
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

            <!-- Other tabs would have similar structure with filtered SQL queries -->
            <div class="tab-pane fade" id="pending" role="tabpanel">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i> Showing pending appointments that need your confirmation.
                </div>
                <!-- Similar table structure with WHERE status = 'Pending' -->
            </div>

            <div class="tab-pane fade" id="confirmed" role="tabpanel">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i> Showing confirmed appointments.
                </div>
                <!-- Similar table structure with WHERE status = 'Confirmed' -->
            </div>

            <div class="tab-pane fade" id="completed" role="tabpanel">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> Showing completed appointments.
                </div>
                <!-- Similar table structure with WHERE status = 'Completed' -->
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>