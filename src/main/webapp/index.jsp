<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Health - Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 100px 0;
        }
        .feature-card:hover {
            transform: translateY(-10px);
        }
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="index.jsp"><i class="fas fa-heartbeat"></i> Smart Health</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">Patient</a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="userLogin.jsp">Login</a></li>
                            <li><a class="dropdown-item" href="userRegister.jsp">Register</a></li>
                        </ul>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">Doctor</a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="doctorLogin.jsp">Login</a></li>
                            <li><a class="dropdown-item" href="doctorRegister.jsp">Register</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="hero-section text-center">
        <div class="container">
            <h1 class="display-4 fw-bold mb-4">Smart Health Prediction & Appointment System</h1>
            <p class="lead mb-4">Your Health, Our Priority - Book Appointments & Get AI-Powered Health Predictions</p>
            <a href="userRegister.jsp" class="btn btn-light btn-lg me-3"><i class="fas fa-user-plus"></i> Get Started</a>
            <a href="userLogin.jsp" class="btn btn-outline-light btn-lg"><i class="fas fa-sign-in-alt"></i> Login</a>
        </div>
    </div>

    <div class="container my-5">
        <h2 class="text-center mb-5">Our Services</h2>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="card feature-card shadow border-0">
                    <div class="card-body text-center p-4">
                        <i class="fas fa-calendar-check fa-3x text-primary mb-3"></i>
                        <h5 class="card-title">Book Appointments</h5>
                        <p class="card-text">Schedule appointments with specialist doctors at your convenience.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card shadow border-0">
                    <div class="card-body text-center p-4">
                        <i class="fas fa-brain fa-3x text-success mb-3"></i>
                        <h5 class="card-title">Disease Prediction</h5>
                        <p class="card-text">Get AI-powered disease predictions based on your symptoms.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card shadow border-0">
                    <div class="card-body text-center p-4">
                        <i class="fas fa-credit-card fa-3x text-warning mb-3"></i>
                        <h5 class="card-title">Secure Payments</h5>
                        <p class="card-text">Make secure online payments for consultations and services.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="bg-dark text-white text-center py-4 mt-5">
        <p class="mb-0">&copy; 2025 Smart Health System. All Rights Reserved.</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
