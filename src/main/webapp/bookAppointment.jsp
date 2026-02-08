<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.mycompany.smarthealthprediction.health.db.DBConnection" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
    <style>
        .time-slot-btn {
            margin: 5px;
            min-width: 110px;
            padding: 10px;
            font-size: 14px;
            font-weight: 500;
        }
        .time-slot-btn.booked {
            opacity: 0.4;
            cursor: not-allowed;
            background-color: #6c757d !important;
            border-color: #6c757d !important;
            color: white !important;
        }
        .time-slot-btn:not(.booked):hover {
            transform: scale(1.05);
        }
        .time-slot-btn.selected {
            background-color: #198754 !important;
            color: white !important;
            border-color: #198754 !important;
            box-shadow: 0 4px 8px rgba(25, 135, 84, 0.3);
        }
    </style>
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
                        <h5><i class="fas fa-user-md"></i> Select Doctor & Schedule</h5>
                    </div>
                    <div class="card-body">
                        <form action="bookAppointment.jsp" method="get" id="doctorForm">
                            <div class="mb-3">
                                <label class="form-label">Select Doctor *</label>
                                <select class="form-select" name="selectedDoctorId" id="doctorSelect" required onchange="if(this.value) this.form.submit();">
                                    <option value="">Choose a doctor...</option>
                                    <%
                                        Connection conn = null;
                                        PreparedStatement pstmt = null;
                                        ResultSet rs = null;
                                        
                                        String selectedDoctorId = request.getParameter("selectedDoctorId");
                                        String selectedDate = request.getParameter("selectedDate");
                                        
                                        boolean hasValidDoctor = false;
                                        if (selectedDoctorId != null && !selectedDoctorId.trim().isEmpty()) {
                                            try {
                                                Integer.parseInt(selectedDoctorId);
                                                hasValidDoctor = true;
                                            } catch (NumberFormatException e) {
                                                selectedDoctorId = null;
                                            }
                                        }
                                        
                                        try {
                                            conn = DBConnection.getConnection();
                                            String sql = "SELECT doctor_id, full_name, specialization, consultation_fee, " +
                                                       "available_days, start_time, end_time, slot_duration, profile_photo " +
                                                       "FROM doctors";
                                            pstmt = conn.prepareStatement(sql);
                                            rs = pstmt.executeQuery();
                                            
                                            while (rs.next()) {
                                                int doctorId = rs.getInt("doctor_id");
                                                boolean isSelected = hasValidDoctor && (doctorId == Integer.parseInt(selectedDoctorId));
                                    %>
                                                <option value="<%= doctorId %>" <%= isSelected ? "selected" : "" %>>
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
                        </form>
                        
                        <%
                        if (hasValidDoctor) {
                            conn = null;
                            pstmt = null;
                            rs = null;
                            
                            try {
                                conn = DBConnection.getConnection();
                                String sql = "SELECT * FROM doctors WHERE doctor_id = ?";
                                pstmt = conn.prepareStatement(sql);
                                pstmt.setInt(1, Integer.parseInt(selectedDoctorId));
                                rs = pstmt.executeQuery();
                                
                                if (rs.next()) {
                                    String startTime = rs.getString("start_time");
                                    String endTime = rs.getString("end_time");
                                    int slotDuration = rs.getInt("slot_duration");
                                    String photoPath = rs.getString("profile_photo");
                                    String availableDays = rs.getString("available_days"); // "Mon, Wed, Fri"
                        %>
                        
                        <!-- Doctor Details Card -->
                        <div class="card mb-3 border-0" style="background: linear-gradient(135deg, #e3f2fd 0%, #f5f5f5 100%);">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-3 text-center">
                                        <% if (photoPath != null && !photoPath.isEmpty()) { %>
                                            <img src="<%= photoPath %>" alt="Dr. <%= rs.getString("full_name") %>" 
                                                 class="rounded-circle shadow" 
                                                 style="width: 100px; height: 100px; object-fit: cover; border: 4px solid #fff;">
                                        <% } else { %>
                                            <img src="https://ui-avatars.com/api/?name=<%= rs.getString("full_name") %>&size=100&background=0d6efd&color=fff&bold=true" 
                                                 alt="Dr. <%= rs.getString("full_name") %>" 
                                                 class="rounded-circle shadow" 
                                                 style="width: 100px; height: 100px; object-fit: cover; border: 4px solid #fff;">
                                        <% } %>
                                        <p class="mt-2 mb-0 fw-bold text-primary">Dr. <%= rs.getString("full_name") %></p>
                                        <small class="text-muted"><%= rs.getString("specialization") %></small>
                                    </div>
                                    <div class="col-md-9">
                                        <h6 class="text-primary mb-3"><i class="fas fa-info-circle"></i> Doctor Information</h6>
                                        
                                        <div class="row mb-2">
                                            <div class="col-md-6">
                                                <p class="mb-1">
                                                    <i class="fas fa-hospital text-danger"></i> 
                                                    <strong>Hospital:</strong><br>
                                                    <small class="ms-4"><%= rs.getString("hospital_name") %></small>
                                                </p>
                                            </div>
                                            <div class="col-md-6">
                                                <p class="mb-1">
                                                    <i class="fas fa-map-marker-alt text-success"></i> 
                                                    <strong>Location:</strong><br>
                                                    <small class="ms-4"><%= rs.getString("location") %></small>
                                                </p>
                                            </div>
                                        </div>
                                        
                                        <div class="row mb-2">
                                            <div class="col-md-6">
                                                <p class="mb-1">
                                                    <i class="fas fa-calendar-alt text-primary"></i> 
                                                    <strong>Available Days:</strong><br>
                                                    <small class="ms-4"><%= availableDays %></small>
                                                </p>
                                            </div>
                                            <div class="col-md-6">
                                                <p class="mb-1">
                                                    <i class="fas fa-clock text-warning"></i> 
                                                    <strong>Timings:</strong><br>
                                                    <small class="ms-4"><%= startTime %> - <%= endTime %></small>
                                                </p>
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-6">
                                                <p class="mb-0">
                                                    <i class="fas fa-hourglass-half text-info"></i> 
                                                    <strong>Slot Duration:</strong><br>
                                                    <small class="ms-4"><%= slotDuration %> minutes</small>
                                                </p>
                                            </div>
                                            <div class="col-md-6">
                                                <p class="mb-0">
                                                    <i class="fas fa-rupee-sign text-success"></i> 
                                                    <strong>Consultation Fee:</strong><br>
                                                    <small class="ms-4 text-success fw-bold">₹<%= rs.getDouble("consultation_fee") %></small>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <form action="bookAppointment.jsp" method="get">
                            <input type="hidden" name="selectedDoctorId" value="<%= selectedDoctorId %>">
                            <input type="hidden" id="doctorAvailableDays" value="<%= availableDays %>">
                            <div class="mb-3">
                                <label class="form-label">Appointment Date * 
                                    <small class="text-muted">(Only <%= availableDays %> are available)</small>
                                </label>
                                <%
                                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                                    String today = dateFormat.format(new java.util.Date());
                                %>
                                <input type="date" class="form-control" name="selectedDate" id="dateInput"
                                       value="<%= selectedDate != null ? selectedDate : "" %>"
                                       required min="<%= today %>"
                                       onchange="this.form.submit()">
                                <small class="text-info" id="dateWarning" style="display: none;">
                                    <i class="fas fa-exclamation-circle"></i> This day is not available. Please select: <%= availableDays %>
                                </small>
                            </div>
                        </form>
                        
                        <% 
                        if (selectedDate != null && !selectedDate.trim().isEmpty()) {
                            // Generate all time slots
                            List<String> allSlots = new ArrayList<String>();
                            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
                            SimpleDateFormat displayFormat = new SimpleDateFormat("h:mm a");
                            
                            try {
                                java.util.Date start = sdf.parse(startTime);
                                java.util.Date end = sdf.parse(endTime);
                                Calendar cal = Calendar.getInstance();
                                cal.setTime(start);
                                
                                while (cal.getTime().before(end)) {
                                    allSlots.add(displayFormat.format(cal.getTime()));
                                    cal.add(Calendar.MINUTE, slotDuration);
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            
                            // Get booked slots
                            Set<String> bookedSlots = new HashSet<String>();
                            PreparedStatement bookPstmt = null;
                            ResultSet bookRs = null;
                            
                            try {
                                String bookSql = "SELECT appointment_time FROM appointments " +
                                               "WHERE doctor_id = ? AND appointment_date = ? " +
                                               "AND status IN ('Pending', 'Confirmed')";
                                bookPstmt = conn.prepareStatement(bookSql);
                                bookPstmt.setInt(1, Integer.parseInt(selectedDoctorId));
                                bookPstmt.setString(2, selectedDate);
                                bookRs = bookPstmt.executeQuery();
                                
                                while (bookRs.next()) {
                                    bookedSlots.add(bookRs.getString("appointment_time"));
                                }
                            } finally {
                                if (bookRs != null) bookRs.close();
                                if (bookPstmt != null) bookPstmt.close();
                            }
                        %>
                        
                        <form action="BookAppointmentServlet" method="post" id="bookingForm">
                            <input type="hidden" name="doctorId" value="<%= selectedDoctorId %>">
                            <input type="hidden" name="appointmentDate" value="<%= selectedDate %>">
                            <input type="hidden" name="appointmentTime" id="selectedTime">
                            
                            <div class="mb-3">
                                <label class="form-label">Select Time Slot *</label>
                                <div class="border rounded p-3 bg-light" id="slotsContainer">
                                    <% 
                                    if (allSlots.isEmpty()) {
                                    %>
                                        <p class="text-warning text-center"><i class="fas fa-exclamation-triangle"></i> No time slots available.</p>
                                    <% 
                                    } else {
                                        for (String slot : allSlots) {
                                            boolean isBooked = bookedSlots.contains(slot);
                                    %>
                                        <button type="button" 
                                                class="btn btn-outline-primary time-slot-btn <%= isBooked ? "booked" : "" %>"
                                                <%= isBooked ? "disabled" : "" %>
                                                onclick="selectSlot(this, '<%= slot %>')">
                                            <%= slot %>
                                            <% if (isBooked) { %>
                                                <br><small class="text-muted">(Booked)</small>
                                            <% } %>
                                        </button>
                                    <%
                                        }
                                    }
                                    %>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Symptoms / Reason for Visit *</label>
                                <textarea class="form-control" name="symptoms" rows="4" required 
                                          placeholder="Please describe your symptoms..."></textarea>
                            </div>
                            
                            <button type="submit" class="btn btn-primary btn-lg" id="submitBtn" disabled>
                                <i class="fas fa-calendar-check"></i> Book Appointment
                            </button>
                            <a href="userDashboard.jsp" class="btn btn-secondary btn-lg">Cancel</a>
                        </form>
                        
                        <% } %>
                        
                        <%
                                }
                            } catch (SQLException e) {
                                e.printStackTrace();
                            } finally {
                                if (rs != null) rs.close();
                                if (pstmt != null) pstmt.close();
                                if (conn != null) conn.close();
                            }
                        }
                        %>
                        
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card shadow">
                    <div class="card-header bg-success text-white">
                        <h5><i class="fas fa-info-circle"></i> Booking Info</h5>
                    </div>
                    <div class="card-body">
                        <h6>How it works:</h6>
                        <ol class="small">
                            <li>Select your preferred doctor</li>
                            <li>Choose date (only available days)</li>
                            <li>Pick from available time slots</li>
                            <li class="text-danger"><strong>Booked slots are grayed out</strong></li>
                            <li>Describe your symptoms</li>
                            <li>Wait for doctor confirmation</li>
                            <li>Pay after confirmation</li>
                        </ol>
                        <hr>
                        <div class="d-flex align-items-center mb-2">
                            <span class="badge bg-primary me-2" style="width: 80px;">Available</span>
                            <small>Click to book</small>
                        </div>
                        <div class="d-flex align-items-center">
                            <span class="badge bg-secondary me-2" style="width: 80px;">Booked</span>
                            <small>Already taken</small>
                        </div>
                        <hr>
                        <p class="small text-muted mb-0">
                            <i class="fas fa-shield-alt text-success"></i> Payment required only after doctor confirms
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Restrict date selection to doctor's available days
        const dateInput = document.getElementById('dateInput');
        const dateWarning = document.getElementById('dateWarning');
        
        if (dateInput) {
            const availableDaysString = document.getElementById('doctorAvailableDays')?.value || '';
            const availableDays = availableDaysString.split(',').map(d => d.trim().toLowerCase());
            
            // Map short names to day numbers (0 = Sunday, 1 = Monday, etc.)
            const dayMap = {
                'sun': 0, 'mon': 1, 'tue': 2, 'wed': 3,
                'thu': 4, 'fri': 5, 'sat': 6
            };
            
            const availableDayNumbers = availableDays.map(day => dayMap[day]).filter(num => num !== undefined);
            
            dateInput.addEventListener('change', function() {
                const selectedDate = new Date(this.value + 'T00:00:00');
                const selectedDayNumber = selectedDate.getDay();
                
                if (!availableDayNumbers.includes(selectedDayNumber)) {
                    dateWarning.style.display = 'block';
                    this.setCustomValidity('Doctor not available on this day');
                } else {
                    dateWarning.style.display = 'none';
                    this.setCustomValidity('');
                }
            });
        }
        
        function selectSlot(btn, time) {
            document.querySelectorAll('.time-slot-btn').forEach(b => {
                b.classList.remove('selected');
            });
            btn.classList.add('selected');
            document.getElementById('selectedTime').value = time;
            document.getElementById('submitBtn').disabled = false;
        }
        
        document.getElementById('bookingForm')?.addEventListener('submit', function(e) {
            if (!document.getElementById('selectedTime').value) {
                e.preventDefault();
                alert('Please select a time slot');
            }
        });
    </script>
</body>
</html>
