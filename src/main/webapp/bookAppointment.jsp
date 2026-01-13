<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.mycompany.smarthealthprediction.health.db.DBConnection" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="userDashboard.jsp"><i class="fas fa-heartbeat"></i> Smart Health</a>
            <div class="ms-auto">
                <a href="LogoutServlet" class="btn btn-outline-light">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <h2 class="mb-4"><i class="fas fa-calendar-plus"></i> Book Appointment</h2>
        
        <% 
            String error = request.getParameter("error");
            if (error != null) {
        %>
            <div class="alert alert-danger alert-dismissible fade show">
                <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <div class="row">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5>Select Doctor & Schedule</h5>
                    </div>
                    <div class="card-body">
                        <form action="BookAppointmentServlet" method="post">
                            <div class="mb-3">
                                <label class="form-label">Select Doctor *</label>
                                <select class="form-select" name="doctorId" id="doctorSelect" required>
                                    <option value="">Choose a doctor...</option>
                                    <%
                                        Connection conn = null;
                                        PreparedStatement pstmt = null;
                                        ResultSet rs = null;
                                        try {
                                            conn = DBConnection.getConnection();
                                            String sql = "SELECT doctor_id, full_name, specialization, consultation_fee, available_days, available_time FROM doctors";
                                            pstmt = conn.prepareStatement(sql);
                                            rs = pstmt.executeQuery();
                                            
                                            while (rs.next()) {
                                    %>
                                                <option value="<%= rs.getInt("doctor_id") %>" 
                                                        data-fee="<%= rs.getDouble("consultation_fee") %>"
                                                        data-days="<%= rs.getString("available_days") %>"
                                                        data-time="<%= rs.getString("available_time") %>">
                                                    Dr. <%= rs.getString("full_name") %> - <%= rs.getString("specialization") %> (₹<%= rs.getDouble("consultation_fee") %>)
                                                </option>
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
                                </select>
                            </div>
                            
                            <div id="doctorInfo" class="alert alert-info d-none">
                                <strong>Doctor Availability:</strong><br>
                                <span id="availableDays"></span><br>
                                <span id="availableTime"></span>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Appointment Date *</label>
                                    <input type="date" class="form-control" name="appointmentDate" required min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Preferred Time *</label>
                                    <select class="form-select" name="appointmentTime" required>
                                        <option value="">Select time...</option>
                                        <option value="9:00 AM">9:00 AM</option>
                                        <option value="10:00 AM">10:00 AM</option>
                                        <option value="11:00 AM">11:00 AM</option>
                                        <option value="12:00 PM">12:00 PM</option>
                                        <option value="2:00 PM">2:00 PM</option>
                                        <option value="3:00 PM">3:00 PM</option>
                                        <option value="4:00 PM">4:00 PM</option>
                                        <option value="5:00 PM">5:00 PM</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Symptoms / Reason for Visit *</label>
                                <textarea class="form-control" name="symptoms" rows="4" required></textarea>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-calendar-check"></i> Book Appointment
                            </button>
                            <a href="userDashboard.jsp" class="btn btn-secondary">Cancel</a>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('doctorSelect').addEventListener('change', function() {
            var option = this.options[this.selectedIndex];
            if (this.value) {
                document.getElementById('doctorInfo').classList.remove('d-none');
                document.getElementById('availableDays').innerText = 'Days: ' + option.getAttribute('data-days');
                document.getElementById('availableTime').innerText = 'Time: ' + option.getAttribute('data-time');
            } else {
                document.getElementById('doctorInfo').classList.add('d-none');
            }
        });
    </script>
</body>
</html>