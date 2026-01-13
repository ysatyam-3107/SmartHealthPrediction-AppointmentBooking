<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }
    String userName = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Greeting animation */
.wave {
    display: inline-block;
    animation: wave 1.6s infinite;
    transform-origin: 70% 70%;
}

@keyframes wave {
    0%   { transform: rotate(0deg); }
    15%  { transform: rotate(14deg); }
    30%  { transform: rotate(-8deg); }
    40%  { transform: rotate(14deg); }
    50%  { transform: rotate(-4deg); }
    60%  { transform: rotate(10deg); }
    100% { transform: rotate(0deg); }
}

.greeting-text {
    animation: fadeInDown 1s ease-in-out;
}

.date-text {
    animation: fadeInUp 1.2s ease-in-out;
    opacity: 0.85;
}

@keyframes fadeInDown {
    from { opacity: 0; transform: translateY(-15px); }
    to   { opacity: 1; transform: translateY(0); }
}

@keyframes fadeInUp {
    from { opacity: 0; transform: translateY(15px); }
    to   { opacity: 1; transform: translateY(0); }
}

        .feature-card {
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15) !important;
        }
    </style>
</head>
<body class="bg-light">
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
                        <a class="nav-link active" href="userDashboard.jsp">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="bookAppointment.jsp">Book Appointment</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="diseasePrediction.jsp">Disease Prediction</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user"></i> <%= userName %>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="userProfile.jsp">
                                <i class="fas fa-user-circle"></i> My Profile
                            </a></li>
                            <li><a class="dropdown-item" href="userAppointments.jsp">
                                <i class="fas fa-calendar-alt"></i> My Appointments
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="LogoutServlet">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <!-- Welcome Banner -->
      <div class="card shadow border-0 mb-4"
     style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
     
    <div class="card-body text-white p-4">
        <h2 class="mb-2 greeting-text">
            <span class="wave">👋</span>
            Welcome back, <%= userName %>!
        </h2>

        <p class="mb-0 date-text">
            <i class="fas fa-calendar-alt"></i>
            <%= new java.text.SimpleDateFormat("EEEE, dd MMMM yyyy")
                    .format(new java.util.Date()) %>
        </p>
    </div>
</div>

        <!-- Quick Actions -->
        <h4 class="mb-4"><i class="fas fa-bolt text-warning"></i> Quick Actions</h4>
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <a href="bookAppointment.jsp" class="text-decoration-none">
                    <div class="card feature-card shadow border-0 h-100">
                        <div class="card-body text-center p-4">
                            <div class="mb-3">
                                <i class="fas fa-calendar-plus fa-4x text-primary"></i>
                            </div>
                            <h5 class="card-title text-dark">Book Appointment</h5>
                            <p class="card-text text-muted">Schedule an appointment with our specialist doctors</p>
                        </div>
                    </div>
                </a>
            </div>
            
            <div class="col-md-4">
                <a href="diseasePrediction.jsp" class="text-decoration-none">
                    <div class="card feature-card shadow border-0 h-100">
                        <div class="card-body text-center p-4">
                            <div class="mb-3">
                                <i class="fas fa-brain fa-4x text-success"></i>
                            </div>
                            <h5 class="card-title text-dark">Disease Prediction</h5>
                            <p class="card-text text-muted">Get AI-powered predictions based on your symptoms</p>
                        </div>
                    </div>
                </a>
            </div>
            
            <div class="col-md-4">
                <a href="userAppointments.jsp" class="text-decoration-none">
                    <div class="card feature-card shadow border-0 h-100">
                        <div class="card-body text-center p-4">
                            <div class="mb-3">
                                <i class="fas fa-file-medical fa-4x text-info"></i>
                            </div>
                            <h5 class="card-title text-dark">My Appointments</h5>
                            <p class="card-text text-muted">View and manage your appointment history</p>
                        </div>
                    </div>
                </a>
            </div>
        </div>

        <!-- Additional Features -->
        <h4 class="mb-4"><i class="fas fa-star text-warning"></i> More Features</h4>
        <div class="row g-4">
            <div class="col-md-3">
                <a href="userProfile.jsp" class="text-decoration-none">
                    <div class="card feature-card shadow-sm border-0 text-center h-100">
                        <div class="card-body p-3">
                            <i class="fas fa-user-circle fa-3x text-primary mb-2"></i>
                            <h6 class="text-dark mb-0">My Profile</h6>
                        </div>
                    </div>
                </a>
            </div>

            <div class="col-md-3">
                <div class="card feature-card shadow-sm border-0 text-center h-100" style="opacity: 0.6; cursor: not-allowed;">
                    <div class="card-body p-3">
                        <i class="fas fa-pills fa-3x text-warning mb-2"></i>
                        <h6 class="text-dark mb-0">Prescriptions</h6>
                        <small class="text-muted">(Coming Soon)</small>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card feature-card shadow-sm border-0 text-center h-100" style="opacity: 0.6; cursor: not-allowed;">
                    <div class="card-body p-3">
                        <i class="fas fa-notes-medical fa-3x text-danger mb-2"></i>
                        <h6 class="text-dark mb-0">Medical Records</h6>
                        <small class="text-muted">(Coming Soon)</small>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card feature-card shadow-sm border-0 text-center h-100" style="opacity: 0.6; cursor: not-allowed;">
                    <div class="card-body p-3">
                        <i class="fas fa-comment-medical fa-3x text-success mb-2"></i>
                        <h6 class="text-dark mb-0">Chat with Doctor</h6>
                        <small class="text-muted">(Coming Soon)</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Health Tips -->
        <div class="card shadow border-0 mt-5">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0"><i class="fas fa-lightbulb"></i> Health Tips</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <div class="d-flex align-items-start">
                            <i class="fas fa-check-circle text-success fa-2x me-3"></i>
                            <div>
                                <h6>Stay Hydrated</h6>
                                <p class="text-muted small mb-0">Drink at least 8 glasses of water daily</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="d-flex align-items-start">
                            <i class="fas fa-check-circle text-success fa-2x me-3"></i>
                            <div>
                                <h6>Regular Exercise</h6>
                                <p class="text-muted small mb-0">At least 30 minutes of physical activity daily</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="d-flex align-items-start">
                            <i class="fas fa-check-circle text-success fa-2x me-3"></i>
                            <div>
                                <h6>Balanced Diet</h6>
                                <p class="text-muted small mb-0">Include fruits, vegetables, and proteins</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="bg-dark text-white text-center py-3 mt-5">
        <p class="mb-0">&copy; 2025 Smart Health System. All Rights Reserved.</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>