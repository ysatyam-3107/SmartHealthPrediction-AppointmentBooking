<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.mycompany.smarthealthprediction.health.db.DBConnection" %>
<%
    if (session.getAttribute("doctorId") == null) {
        response.sendRedirect("doctorLogin.jsp");
        return;
    }
    Integer doctorId = (Integer) session.getAttribute("doctorId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Doctor</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .profile-photo {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid #198754;
        }
        .info-card {
            border-left: 4px solid #198754;
        }
    </style>
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
                        <a class="nav-link" href="doctorAppointments.jsp">Appointments</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="doctorProfile.jsp">My Profile</a>
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
            <h2><i class="fas fa-user-circle"></i> My Profile</h2>
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

        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = DBConnection.getConnection();
                String sql = "SELECT * FROM doctors WHERE doctor_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, doctorId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
        %>
        
        <div class="row">
            <!-- Profile Card -->
            <div class="col-md-4">
                <div class="card shadow border-0 mb-4">
                    <div class="card-body text-center">
                        <% 
                            String photoPath = rs.getString("profile_photo");
                            if (photoPath != null && !photoPath.isEmpty()) {
                        %>
                            <img src="<%= photoPath %>" alt="Doctor Photo" class="profile-photo mb-3">
                        <% } else { %>
                            <img src="https://ui-avatars.com/api/?name=<%= rs.getString("full_name") %>&size=150&background=198754&color=fff" 
                                 alt="Doctor Photo" class="profile-photo mb-3">
                        <% } %>
                        <h4 class="mb-1">Dr. <%= rs.getString("full_name") %></h4>
                        <p class="text-muted mb-2"><%= rs.getString("specialization") %></p>
                        <p class="text-success"><i class="fas fa-graduation-cap"></i> <%= rs.getString("qualification") %></p>
                        <hr>
                        <div class="d-grid gap-2">
                            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                <i class="fas fa-edit"></i> Edit Profile
                            </button>
                            <button class="btn btn-outline-success" data-bs-toggle="modal" data-bs-target="#changePhotoModal">
                                <i class="fas fa-camera"></i> Change Photo
                            </button>
                            <button class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                                <i class="fas fa-key"></i> Change Password
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Details Card -->
            <div class="col-md-8">
                <!-- Personal Information -->
                <div class="card shadow border-0 mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-user"></i> Personal Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <p class="mb-1 text-muted small">Email</p>
                                <p class="fw-bold"><i class="fas fa-envelope"></i> <%= rs.getString("email") %></p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1 text-muted small">Phone</p>
                                <p class="fw-bold"><i class="fas fa-phone"></i> <%= rs.getString("phone") %></p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Professional Information -->
                <div class="card shadow border-0 mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-briefcase-medical"></i> Professional Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <p class="mb-1 text-muted small">Hospital / Clinic</p>
                                <p class="fw-bold"><i class="fas fa-hospital"></i> <%= rs.getString("hospital_name") %></p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1 text-muted small">Location</p>
                                <p class="fw-bold"><i class="fas fa-map-marker-alt"></i> <%= rs.getString("location") %></p>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <p class="mb-1 text-muted small">Experience</p>
                                <p class="fw-bold"><i class="fas fa-briefcase"></i> <%= rs.getInt("experience") %> years</p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1 text-muted small">Consultation Fee</p>
                                <p class="fw-bold text-success"><i class="fas fa-rupee-sign"></i> <%= rs.getDouble("consultation_fee") %></p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Availability Settings -->
                <div class="card shadow border-0">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-clock"></i> Availability Settings</h5>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <p class="mb-1 text-muted small">Available Days</p>
                                <p class="fw-bold"><i class="fas fa-calendar-alt"></i> <%= rs.getString("available_days") %></p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1 text-muted small">Working Hours</p>
                                <p class="fw-bold"><i class="fas fa-clock"></i> <%= rs.getString("start_time") %> - <%= rs.getString("end_time") %></p>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-1 text-muted small">Appointment Slot Duration</p>
                                <p class="fw-bold"><i class="fas fa-hourglass-half"></i> <%= rs.getInt("slot_duration") %> minutes</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%
                } else {
        %>
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle"></i> Profile not found!
                    </div>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
        %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle"></i> Error: <%= e.getMessage() %>
                </div>
        <%
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        %>
    </div>

    <!-- Edit Profile Modal -->
    <div class="modal fade" id="editProfileModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title"><i class="fas fa-edit"></i> Edit Profile</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="UpdateDoctorProfileServlet" method="post">
                    <div class="modal-body">
                        <%
                            conn = null;
                            pstmt = null;
                            rs = null;
                            try {
                                conn = DBConnection.getConnection();
                                String sql = "SELECT * FROM doctors WHERE doctor_id = ?";
                                pstmt = conn.prepareStatement(sql);
                                pstmt.setInt(1, doctorId);
                                rs = pstmt.executeQuery();
                                if (rs.next()) {
                                    String currentDays = rs.getString("available_days");
                                    String[] selectedDaysArray = currentDays != null ? currentDays.split(",\\s*") : new String[0];
                                    java.util.Set<String> selectedDaysSet = new java.util.HashSet<>();
                                    for (String day : selectedDaysArray) {
                                        selectedDaysSet.add(day.trim().toLowerCase());
                                    }
                        %>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Full Name *</label>
                                <input type="text" class="form-control" name="fullName" value="<%= rs.getString("full_name") %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Phone *</label>
                                <input type="tel" class="form-control" name="phone" value="<%= rs.getString("phone") %>" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Hospital / Clinic *</label>
                                <input type="text" class="form-control" name="hospitalName" value="<%= rs.getString("hospital_name") %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Location *</label>
                                <input type="text" class="form-control" name="location" value="<%= rs.getString("location") %>" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Experience (Years) *</label>
                                <input type="number" class="form-control" name="experience" value="<%= rs.getInt("experience") %>" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Consultation Fee (₹) *</label>
                                <input type="number" class="form-control" name="consultationFee" value="<%= rs.getDouble("consultation_fee") %>" step="0.01" required>
                            </div>
                        </div>
                        
                        <hr>
                        <h6 class="text-success mb-3">Availability Schedule</h6>
                        
                        <div class="mb-3">
                            <label class="form-label d-block">Available Days *</label>
                            <div class="row">
                                <div class="col-md-3 col-6 mb-2">
                                    <div class="form-check">
                                        <input class="form-check-input available-day-check" type="checkbox" name="availableDays" value="Monday" id="edit_mon" <%= selectedDaysSet.contains("mon") ? "checked" : "" %>>
                                        <label class="form-check-label" for="edit_mon">Monday</label>
                                    </div>
                                </div>
                                <div class="col-md-3 col-6 mb-2">
                                    <div class="form-check">
                                        <input class="form-check-input available-day-check" type="checkbox" name="availableDays" value="Tuesday" id="edit_tue" <%= selectedDaysSet.contains("tue") ? "checked" : "" %>>
                                        <label class="form-check-label" for="edit_tue">Tuesday</label>
                                    </div>
                                </div>
                                <div class="col-md-3 col-6 mb-2">
                                    <div class="form-check">
                                        <input class="form-check-input available-day-check" type="checkbox" name="availableDays" value="Wednesday" id="edit_wed" <%= selectedDaysSet.contains("wed") ? "checked" : "" %>>
                                        <label class="form-check-label" for="edit_wed">Wednesday</label>
                                    </div>
                                </div>
                                <div class="col-md-3 col-6 mb-2">
                                    <div class="form-check">
                                        <input class="form-check-input available-day-check" type="checkbox" name="availableDays" value="Thursday" id="edit_thu" <%= selectedDaysSet.contains("thu") ? "checked" : "" %>>
                                        <label class="form-check-label" for="edit_thu">Thursday</label>
                                    </div>
                                </div>
                                <div class="col-md-3 col-6 mb-2">
                                    <div class="form-check">
                                        <input class="form-check-input available-day-check" type="checkbox" name="availableDays" value="Friday" id="edit_fri" <%= selectedDaysSet.contains("fri") ? "checked" : "" %>>
                                        <label class="form-check-label" for="edit_fri">Friday</label>
                                    </div>
                                </div>
                                <div class="col-md-3 col-6 mb-2">
                                    <div class="form-check">
                                        <input class="form-check-input available-day-check" type="checkbox" name="availableDays" value="Saturday" id="edit_sat" <%= selectedDaysSet.contains("sat") ? "checked" : "" %>>
                                        <label class="form-check-label" for="edit_sat">Saturday</label>
                                    </div>
                                </div>
                                <div class="col-md-3 col-6 mb-2">
                                    <div class="form-check">
                                        <input class="form-check-input available-day-check" type="checkbox" name="availableDays" value="Sunday" id="edit_sun" <%= selectedDaysSet.contains("sun") ? "checked" : "" %>>
                                        <label class="form-check-label" for="edit_sun">Sunday</label>
                                    </div>
                                </div>
                            </div>
                            <input type="hidden" name="availableDaysString" id="editAvailableDaysString">
                            <div class="alert alert-info mt-2 p-2" id="editSelectedDaysDisplay">
                                <small><strong>Selected:</strong> <%= currentDays %></small>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Start Time *</label>
                                <input type="time" class="form-control" name="startTime" value="<%= rs.getString("start_time") %>" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">End Time *</label>
                                <input type="time" class="form-control" name="endTime" value="<%= rs.getString("end_time") %>" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Slot Duration *</label>
                                <select class="form-select" name="slotDuration" required>
                                    <option value="15" <%= rs.getInt("slot_duration") == 15 ? "selected" : "" %>>15 minutes</option>
                                    <option value="30" <%= rs.getInt("slot_duration") == 30 ? "selected" : "" %>>30 minutes</option>
                                    <option value="45" <%= rs.getInt("slot_duration") == 45 ? "selected" : "" %>>45 minutes</option>
                                    <option value="60" <%= rs.getInt("slot_duration") == 60 ? "selected" : "" %>>1 hour</option>
                                </select>
                            </div>
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
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Change Photo Modal -->
    <div class="modal fade" id="changePhotoModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title"><i class="fas fa-camera"></i> Change Profile Photo</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="UpdateDoctorPhotoServlet" method="post" enctype="multipart/form-data">
                    <div class="modal-body text-center">
                        <img id="photoPreview" src="" class="profile-photo mb-3" alt="Preview">
                        <div class="mb-3">
                            <input type="file" class="form-control" name="profilePhoto" accept="image/*" required onchange="previewNewPhoto(event)">
                            <small class="text-muted">Max size: 5MB. Formats: JPG, PNG, JPEG</small>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-upload"></i> Upload Photo
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Change Password Modal -->
    <div class="modal fade" id="changePasswordModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title"><i class="fas fa-key"></i> Change Password</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="ChangeDoctorPasswordServlet" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Current Password *</label>
                            <input type="password" class="form-control" name="currentPassword" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">New Password *</label>
                            <input type="password" class="form-control" name="newPassword" required minlength="6">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Confirm New Password *</label>
                            <input type="password" class="form-control" name="confirmPassword" required minlength="6">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-key"></i> Change Password
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Handle day selection in edit modal
        const dayCheckboxes = document.querySelectorAll('.available-day-check');
        const selectedDaysDisplay = document.getElementById('editSelectedDaysDisplay');
        const availableDaysString = document.getElementById('editAvailableDaysString');

        function updateSelectedDays() {
            const selected = [];
            dayCheckboxes.forEach(checkbox => {
                if (checkbox.checked) {
                    selected.push(checkbox.value);
                }
            });

            if (selected.length > 0) {
                const shortNames = selected.map(day => day.substring(0, 3));
                selectedDaysDisplay.innerHTML = '<small><strong>Selected:</strong> <span class="badge bg-success me-1">' + 
                    shortNames.join('</span> <span class="badge bg-success me-1">') + '</span></small>';
                availableDaysString.value = shortNames.join(', ');
            } else {
                selectedDaysDisplay.innerHTML = '<small><em class="text-danger">No days selected</em></small>';
                availableDaysString.value = '';
            }
        }

        dayCheckboxes.forEach(checkbox => {
            checkbox.addEventListener('change', updateSelectedDays);
        });

        // Initialize on modal open
        document.getElementById('editProfileModal').addEventListener('show.bs.modal', function() {
            updateSelectedDays();
        });

        function previewNewPhoto(event) {
            const file = event.target.files[0];
            if (file) {
                if (file.size > 5 * 1024 * 1024) {
                    alert('File size should not exceed 5MB');
                    event.target.value = '';
                    return;
                }
                
                const reader = new FileReader();
                reader.onload = function(){
                    document.getElementById('photoPreview').src = reader.result;
                };
                reader.readAsDataURL(file);
            }
        }
    </script>
</body>
</html>
