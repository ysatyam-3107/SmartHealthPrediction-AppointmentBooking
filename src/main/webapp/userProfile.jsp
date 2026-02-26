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
    <title>My Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .profile-avatar {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid #0d6efd;
            transition: all 0.3s ease;
        }
        /* CSS Initials Avatar - replaces broken ui-avatars.com */
.profile-avatar-initials {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    border: 5px solid #0d6efd;
    background: linear-gradient(135deg, #0d6efd, #6610f2);
    color: white;
    font-size: 3rem;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto;
    letter-spacing: 2px;
    box-shadow: 0 8px 25px rgba(13, 110, 253, 0.4);
    transition: all 0.3s ease;
    cursor: pointer;
    user-select: none;
}

.profile-photo-container:hover .profile-avatar-initials {
    opacity: 0.8;
    transform: scale(1.05);
}
        .profile-photo-container {
            position: relative;
            display: inline-block;
            cursor: pointer;
        }
        .profile-photo-container:hover .profile-avatar {
            opacity: 0.7;
            transform: scale(1.05);
        }
        .photo-upload-overlay {
            position: absolute;
            bottom: 5px;
            right: 5px;
            background: #0d6efd;
            color: white;
            border-radius: 50%;
            width: 45px;
            height: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 3px 10px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
        }
        .photo-upload-overlay:hover {
            background: #0a58ca;
            transform: scale(1.1);
        }
        .upload-hint {
            position: absolute;
            top: -30px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0,0,0,0.8);
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 12px;
            white-space: nowrap;
            opacity: 0;
            transition: opacity 0.3s ease;
            pointer-events: none;
        }
        .profile-photo-container:hover .upload-hint {
            opacity: 1;
        }
        .stat-card {
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        /* Loading spinner */
        .spinner-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }
        .spinner-overlay.active {
            display: flex;
        }
    </style>
</head>
<body class="bg-light">
    <!-- Loading Spinner -->
    <div class="spinner-overlay" id="loadingSpinner">
        <div class="text-center">
            <div class="spinner-border text-light" role="status" style="width: 3rem; height: 3rem;">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="text-white mt-3">Uploading photo...</p>
        </div>
    </div>

    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="userDashboard.jsp">
                <i class="fas fa-heartbeat"></i> Smart Health
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="userDashboard.jsp">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="bookAppointment.jsp">Book Appointment</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="userAppointments.jsp">My Appointments</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="userProfile.jsp">Profile</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="LogoutServlet">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container my-5">
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

        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = DBConnection.getConnection();
                String sql = "SELECT * FROM users WHERE user_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    String profilePhoto = rs.getString("profile_photo");
                    String fullName = rs.getString("full_name");
        %>
        
        <div class="row">
            <!-- Profile Card -->
            <div class="col-md-4">
                <div class="card shadow border-0 text-center">
                    <div class="card-body p-4">
<!-- NEW - CSS avatar, no external API needed -->
<div class="profile-photo-container mb-3" onclick="document.getElementById('photoInput').click()">
    <div class="upload-hint">
        <i class="fas fa-camera"></i> Click to change photo
    </div>

    <% if (profilePhoto != null && !profilePhoto.isEmpty()) { %>
        <%-- User has uploaded a photo - show it --%>
        <img src="<%= profilePhoto %>" 
             alt="Profile" 
             class="profile-avatar" 
             id="profileImage"
             onerror="this.style.display='none'; document.getElementById('avatarFallback').style.display='flex';">
        
        <%-- Hidden fallback in case image fails to load --%>
        <%
            String initials = "";
            String[] nameParts = fullName.trim().split("\\s+");
            if (nameParts.length >= 2) {
                initials = String.valueOf(nameParts[0].charAt(0)).toUpperCase() + 
                           String.valueOf(nameParts[nameParts.length - 1].charAt(0)).toUpperCase();
            } else if (nameParts.length == 1) {
                initials = String.valueOf(nameParts[0].charAt(0)).toUpperCase();
            }
        %>
        <div id="avatarFallback" class="profile-avatar-initials" style="display:none;">
            <%= initials %>
        </div>

    <% } else { %>
        <%-- No photo - show initials avatar --%>
        <%
            String initials = "";
            String[] nameParts = fullName.trim().split("\\s+");
            if (nameParts.length >= 2) {
                initials = String.valueOf(nameParts[0].charAt(0)).toUpperCase() + 
                           String.valueOf(nameParts[nameParts.length - 1].charAt(0)).toUpperCase();
            } else if (nameParts.length == 1) {
                initials = String.valueOf(nameParts[0].charAt(0)).toUpperCase();
            }
        %>
        <div class="profile-avatar-initials" id="profileImage">
            <%= initials %>
        </div>
    <% } %>

    <div class="photo-upload-overlay" title="Change profile photo">
        <i class="fas fa-camera fa-lg"></i>
    </div>
</div>                        
                        <!-- Hidden form for photo upload -->
                        <form action="UpdatePhotoServlet" method="post" enctype="multipart/form-data" id="photoForm">
                            <input type="file" 
                                   id="photoInput" 
                                   name="profilePhoto" 
                                   accept="image/*" 
                                   style="display: none;" 
                                   onchange="validateAndSubmitPhoto(event)">
                        </form>
                        
                        <h4 class="mb-1"><%= fullName %></h4>
                        <p class="text-muted mb-3">
                            <i class="fas fa-envelope"></i> <%= rs.getString("email") %>
                        </p>
                        
                        <div class="d-grid gap-2">
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                <i class="fas fa-edit"></i> Edit Profile
                            </button>
                            <button class="btn btn-outline-warning" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                                <i class="fas fa-lock"></i> Change Password
                            </button>
                            <% if (profilePhoto != null && !profilePhoto.isEmpty()) { %>
                            <button class="btn btn-outline-danger btn-sm" onclick="removePhoto()">
                                <i class="fas fa-trash"></i> Remove Photo
                            </button>
                            <% } %>
                        </div>

                        <div class="alert alert-info mt-3 mb-0">
                            <small>
                                <i class="fas fa-info-circle"></i> 
                                <strong>Tip:</strong> Click on your photo to change it!
                            </small>
                        </div>
                    </div>
                </div>

                <!-- Quick Stats -->
                <div class="card shadow border-0 mt-3">
                    <div class="card-header bg-info text-white">
                        <h6 class="mb-0"><i class="fas fa-chart-bar"></i> Quick Stats</h6>
                    </div>
                    <div class="card-body">
                        <%
                            String statsSql = "SELECT " +
                                            "COUNT(*) as total, " +
                                            "SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) as completed, " +
                                            "SUM(CASE WHEN status = 'Pending' THEN 1 ELSE 0 END) as pending, " +
                                            "SUM(CASE WHEN status = 'Confirmed' THEN 1 ELSE 0 END) as confirmed " +
                                            "FROM appointments WHERE user_id = ?";
                            PreparedStatement statsPstmt = conn.prepareStatement(statsSql);
                            statsPstmt.setInt(1, userId);
                            ResultSet statsRs = statsPstmt.executeQuery();
                            
                            if (statsRs.next()) {
                        %>
                        <div class="d-flex justify-content-between mb-2 pb-2 border-bottom">
                            <span><i class="fas fa-calendar-alt text-primary"></i> Total:</span>
                            <strong class="text-primary"><%= statsRs.getInt("total") %></strong>
                        </div>
                        <div class="d-flex justify-content-between mb-2 pb-2 border-bottom">
                            <span><i class="fas fa-check-circle text-success"></i> Completed:</span>
                            <strong class="text-success"><%= statsRs.getInt("completed") %></strong>
                        </div>
                        <div class="d-flex justify-content-between mb-2 pb-2 border-bottom">
                            <span><i class="fas fa-clock text-warning"></i> Pending:</span>
                            <strong class="text-warning"><%= statsRs.getInt("pending") %></strong>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span><i class="fas fa-calendar-check text-info"></i> Confirmed:</span>
                            <strong class="text-info"><%= statsRs.getInt("confirmed") %></strong>
                        </div>
                        <%
                                statsRs.close();
                                statsPstmt.close();
                            }
                        %>
                    </div>
                </div>
            </div>

            <!-- Profile Details -->
            <div class="col-md-8">
                <div class="card shadow border-0">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-user"></i> Personal Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="text-muted small mb-1">
                                    <i class="fas fa-user"></i> Full Name
                                </label>
                                <p class="fw-bold"><%= rs.getString("full_name") %></p>
                            </div>
                            <div class="col-md-6">
                                <label class="text-muted small mb-1">
                                    <i class="fas fa-envelope"></i> Email Address
                                </label>
                                <p class="fw-bold"><%= rs.getString("email") %></p>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="text-muted small mb-1">
                                    <i class="fas fa-phone"></i> Phone Number
                                </label>
                                <p class="fw-bold">
                                    <% 
                                        String phone = rs.getString("phone");
                                        out.print(phone != null && !phone.isEmpty() ? phone : "<span class='text-muted'>Not provided</span>");
                                    %>
                                </p>
                            </div>
                            <div class="col-md-6">
                                <label class="text-muted small mb-1">
                                    <i class="fas fa-venus-mars"></i> Gender
                                </label>
                                <p class="fw-bold">
                                    <% 
                                        String gender = rs.getString("gender");
                                        out.print(gender != null && !gender.isEmpty() ? gender : "<span class='text-muted'>Not specified</span>");
                                    %>
                                </p>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="text-muted small mb-1">
                                    <i class="fas fa-birthday-cake"></i> Date of Birth
                                </label>
                                <p class="fw-bold">
                                    <% 
                                        Date dob = rs.getDate("date_of_birth");
                                        if (dob != null) {
                                            out.print(new java.text.SimpleDateFormat("dd MMM yyyy").format(dob));
                                        } else {
                                            out.print("<span class='text-muted'>Not provided</span>");
                                        }
                                    %>
                                </p>
                            </div>
                            <div class="col-md-6">
                                <label class="text-muted small mb-1">
                                    <i class="fas fa-calendar-plus"></i> Member Since
                                </label>
                                <p class="fw-bold">
                                    <%= new java.text.SimpleDateFormat("dd MMM yyyy").format(rs.getTimestamp("created_at")) %>
                                </p>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="text-muted small mb-1">
                                <i class="fas fa-map-marker-alt"></i> Address
                            </label>
                            <p class="fw-bold">
                                <% 
                                    String address = rs.getString("address");
                                    out.print(address != null && !address.isEmpty() ? address : "<span class='text-muted'>Not provided</span>");
                                %>
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Recent Activity -->
                <div class="card shadow border-0 mt-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-history"></i> Recent Activity</h5>
                    </div>
                    <div class="card-body">
                        <%
                            String activitySql = "SELECT a.appointment_id, a.appointment_date, a.appointment_time, a.status, " +
                                               "d.full_name as doctor_name, d.specialization " +
                                               "FROM appointments a " +
                                               "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                                               "WHERE a.user_id = ? " +
                                               "ORDER BY a.created_at DESC LIMIT 5";
                            PreparedStatement activityPstmt = conn.prepareStatement(activitySql);
                            activityPstmt.setInt(1, userId);
                            ResultSet activityRs = activityPstmt.executeQuery();
                            
                            boolean hasActivity = false;
                            while (activityRs.next()) {
                                hasActivity = true;
                                String status = activityRs.getString("status");
                                String statusIcon = "";
                                String statusColor = "";
                                
                                if (status.equals("Completed")) {
                                    statusIcon = "fa-check-circle";
                                    statusColor = "text-success";
                                } else if (status.equals("Confirmed")) {
                                    statusIcon = "fa-calendar-check";
                                    statusColor = "text-info";
                                } else if (status.equals("Pending")) {
                                    statusIcon = "fa-clock";
                                    statusColor = "text-warning";
                                } else {
                                    statusIcon = "fa-times-circle";
                                    statusColor = "text-danger";
                                }
                        %>
                        <div class="d-flex align-items-center mb-3 pb-3 border-bottom">
                            <i class="fas <%= statusIcon %> <%= statusColor %> fa-2x me-3"></i>
                            <div class="flex-grow-1">
                                <h6 class="mb-1">Appointment with Dr. <%= activityRs.getString("doctor_name") %></h6>
                                <small class="text-muted">
                                    <i class="fas fa-stethoscope"></i> <%= activityRs.getString("specialization") %> • 
                                    <i class="fas fa-calendar"></i> <%= new java.text.SimpleDateFormat("dd MMM yyyy").format(activityRs.getDate("appointment_date")) %>
                                </small>
                            </div>
                            <span class="badge bg-<%= status.equals("Completed") ? "success" : status.equals("Confirmed") ? "info" : status.equals("Pending") ? "warning" : "danger" %>">
                                <%= status %>
                            </span>
                        </div>
                        <%
                            }
                            
                            if (!hasActivity) {
                        %>
                        <div class="text-center text-muted py-4">
                            <i class="fas fa-inbox fa-3x mb-3 d-block"></i>
                            <p>No recent activity</p>
                            <a href="bookAppointment.jsp" class="btn btn-primary btn-sm">
                                <i class="fas fa-calendar-plus"></i> Book Your First Appointment
                            </a>
                        </div>
                        <%
                            }
                            
                            activityRs.close();
                            activityPstmt.close();
                        %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Profile Modal -->
        <div class="modal fade" id="editProfileModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title"><i class="fas fa-edit"></i> Edit Profile</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="UpdateProfileServlet" method="post">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label">Full Name *</label>
                                <input type="text" class="form-control" name="fullName" value="<%= rs.getString("full_name") %>" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Phone Number</label>
                                <input type="tel" class="form-control" name="phone" value="<%= rs.getString("phone") != null ? rs.getString("phone") : "" %>" pattern="[0-9]{10}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Gender</label>
                                <select class="form-select" name="gender">
                                    <option value="">Select Gender</option>
                                    <option value="Male" <%= "Male".equals(rs.getString("gender")) ? "selected" : "" %>>Male</option>
                                    <option value="Female" <%= "Female".equals(rs.getString("gender")) ? "selected" : "" %>>Female</option>
                                    <option value="Other" <%= "Other".equals(rs.getString("gender")) ? "selected" : "" %>>Other</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Date of Birth</label>
                                <input type="date" class="form-control" name="dob" 
                                       value="<%= rs.getDate("date_of_birth") != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("date_of_birth")) : "" %>">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Address</label>
                                <textarea class="form-control" name="address" rows="3"><%= rs.getString("address") != null ? rs.getString("address") : "" %></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Save Changes
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
                    <div class="modal-header bg-warning">
                        <h5 class="modal-title"><i class="fas fa-lock"></i> Change Password</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="ChangePasswordServlet" method="post">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label">Current Password *</label>
                                <input type="password" class="form-control" name="currentPassword" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">New Password *</label>
                                <input type="password" class="form-control" name="newPassword" minlength="6" required>
                                <small class="text-muted">At least 6 characters</small>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Confirm New Password *</label>
                                <input type="password" class="form-control" name="confirmPassword" minlength="6" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-warning">
                                <i class="fas fa-key"></i> Change Password
                            </button>
                        </div>
                    </form>
                </div>
            </div>
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
        function validateAndSubmitPhoto(event) {
            const file = event.target.files[0];
            if (!file) return;
            
            // Validate file size (5MB max)
            if (file.size > 5 * 1024 * 1024) {
                alert('❌ File size should not exceed 5MB');
                event.target.value = '';
                return;
            }
            
            // Validate file type
            if (!file.type.match('image.*')) {
                alert('❌ Please select a valid image file (JPG, PNG, JPEG)');
                event.target.value = '';
                return;
            }
            
            // Show loading spinner
            document.getElementById('loadingSpinner').classList.add('active');
            
            // Submit form
            document.getElementById('photoForm').submit();
        }

        function removePhoto() {
            if (confirm('Are you sure you want to remove your profile photo?')) {
                window.location.href = 'RemovePhotoServlet';
            }
        }
    </script>
</body>
</html>