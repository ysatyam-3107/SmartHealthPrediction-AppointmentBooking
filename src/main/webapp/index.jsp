<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Smart Health - Home</title>

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

<style>
/* ---------- GLOBAL ---------- */
body {
    scroll-behavior: smooth;
}

/* ---------- NAVBAR ---------- */
.navbar {
    backdrop-filter: blur(10px);
    background: rgba(13, 110, 253, 0.9);
    box-shadow: 0 5px 20px rgba(0,0,0,0.2);
    transition: 0.3s;
}

.navbar-brand {
    font-weight: 700;
    font-size: 1.6rem;
}

.nav-link {
    font-weight: 500;
    position: relative;
}

.nav-link::after {
    content: "";
    width: 0;
    height: 2px;
    background: #fff;
    position: absolute;
    bottom: 0;
    left: 0;
    transition: 0.3s;
}

.nav-link:hover::after {
    width: 100%;
}

/* ---------- HERO ---------- */
.hero-section {
    min-height: 90vh;
    background: linear-gradient(135deg, #667eea, #764ba2);
    color: white;
    display: flex;
    align-items: center;
    animation: fadeIn 1.2s ease;
}

.hero-section h1 {
    animation: slideDown 1s ease;
}

.hero-section p {
    animation: fadeIn 1.5s ease;
}

/* ---------- BUTTONS ---------- */
.btn-lg {
    padding: 14px 30px;
    border-radius: 30px;
    transition: 0.3s;
}

.btn-light:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 25px rgba(255,255,255,0.4);
}

.btn-outline-light:hover {
    background: white;
    color: #764ba2;
}

/* ---------- CARDS ---------- */
.feature-card {
    border-radius: 20px;
    transition: all 0.4s ease;
    animation: fadeUp 1.2s ease;
}

.feature-card:hover {
    transform: translateY(-15px) scale(1.03);
    box-shadow: 0 20px 40px rgba(0,0,0,0.2);
}

.feature-card i {
    transition: 0.4s;
}

.feature-card:hover i {
    transform: rotate(8deg) scale(1.2);
}

/* ---------- FOOTER ---------- */
footer {
    background: linear-gradient(135deg, #1f1f1f, #111);
}

/* ---------- ANIMATIONS ---------- */
@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

@keyframes slideDown {
    from { opacity: 0; transform: translateY(-30px); }
    to { opacity: 1; transform: translateY(0); }
}

@keyframes fadeUp {
    from { opacity: 0; transform: translateY(40px); }
    to { opacity: 1; transform: translateY(0); }
}

/* ---------- MODAL ---------- */
.modal-content {
    border: none;
    border-radius: 24px;
    overflow: hidden;
    box-shadow: 0 30px 80px rgba(0,0,0,0.35);
}

.modal-header {
    background: linear-gradient(135deg, #667eea, #764ba2);
    color: white;
    border: none;
    padding: 28px 32px 20px;
}

.modal-header .btn-close {
    filter: invert(1);
    opacity: 0.8;
}

.modal-body {
    padding: 36px 32px 40px;
    background: #fafbff;
}

.role-card {
    border: 2.5px solid #e0e4f0;
    border-radius: 20px;
    padding: 28px 16px;
    text-align: center;
    display: block;
    text-decoration: none;
    color: inherit;
    transition: all 0.35s ease;
    background: white;
}

.role-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 20px 50px rgba(0,0,0,0.12);
    color: inherit;
}

.role-card.patient:hover { border-color: #667eea; }
.role-card.doctor:hover  { border-color: #11998e; }

.role-icon-wrap {
    width: 70px;
    height: 70px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 14px;
    font-size: 1.8rem;
    transition: transform 0.3s;
}

.role-card:hover .role-icon-wrap {
    transform: scale(1.15) rotate(-5deg);
}

.patient .role-icon-wrap { background: linear-gradient(135deg, #667eea, #764ba2); color: white; }
.doctor  .role-icon-wrap { background: linear-gradient(135deg, #11998e, #38ef7d); color: white; }

.role-title {
    font-weight: 700;
    font-size: 1.1rem;
    margin-bottom: 6px;
    color: #1a1a2e;
}

.role-desc {
    font-size: 0.8rem;
    color: #888;
    line-height: 1.5;
}

.role-badge {
    display: inline-block;
    margin-top: 12px;
    padding: 4px 14px;
    border-radius: 30px;
    font-size: 0.78rem;
    font-weight: 600;
}

.patient .role-badge { background: #eef0ff; color: #667eea; }
.doctor  .role-badge { background: #e6faf2; color: #11998e; }

.login-links a {
    font-weight: 600;
    text-decoration: none;
}

.login-links a:hover { text-decoration: underline; }
</style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark fixed-top">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">
            <i class="fas fa-heartbeat"></i> Smart Health
        </a>

        <button class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown">Patient</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="userLogin.jsp">Login</a></li>
                        <li><a class="dropdown-item" href="userRegister.jsp">Register</a></li>
                    </ul>
                </li>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown">Doctor</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="doctorLogin.jsp">Login</a></li>
                        <li><a class="dropdown-item" href="doctorRegister.jsp">Register</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- HERO -->
<div class="hero-section text-center">
    <div class="container">
        <h1 class="display-4 fw-bold mb-4">
            Smart Health Prediction &amp; Appointment System
        </h1>
        <p class="lead mb-5">
            Your Health, Our Priority - AI Powered Predictions &amp; Easy Appointments
        </p>

        <!-- ✅ FIXED: added # before getStartedModal -->
        <button type="button" class="btn btn-light btn-lg me-3" data-bs-toggle="modal" data-bs-target="#getStartedModal">
            <i class="fas fa-user-plus"></i> Get Started
        </button>

        <a href="userLogin.jsp" class="btn btn-outline-light btn-lg">
            <i class="fas fa-sign-in-alt"></i> Login
        </a>
    </div>
</div>

<!-- SERVICES -->
<div class="container my-5 py-5">
    <h2 class="text-center mb-5 fw-bold">Our Services</h2>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="card feature-card shadow border-0">
                <div class="card-body text-center p-4">
                    <i class="fas fa-calendar-check fa-3x text-primary mb-3"></i>
                    <h5>Book Appointments</h5>
                    <p>Schedule appointments with specialist doctors easily.</p>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card feature-card shadow border-0">
                <div class="card-body text-center p-4">
                    <i class="fas fa-brain fa-3x text-success mb-3"></i>
                    <h5>Disease Prediction</h5>
                    <p>AI-powered disease predictions based on symptoms.</p>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card feature-card shadow border-0">
                <div class="card-body text-center p-4">
                    <i class="fas fa-credit-card fa-3x text-warning mb-3"></i>
                    <h5>Secure Payments</h5>
                    <p>Fast and secure online payment system.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- FOOTER -->
<footer class="text-white text-center py-4">
    &copy; 2025 Smart Health System | All Rights Reserved
</footer>


<!-- ✅ GET STARTED MODAL (must be inside index.jsp to work) -->
<div class="modal fade" id="getStartedModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title fw-bold">
                    <i class="fas fa-heartbeat me-2"></i> Welcome to Smart Health
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <p class="text-center text-muted mb-4">How would you like to continue?</p>

                <div class="row g-3">

                    <!-- Patient Card -->
                    <div class="col-6">
                        <a href="userRegister.jsp" class="role-card patient">
                            <div class="role-icon-wrap">
                                <i class="fas fa-user-injured"></i>
                            </div>
                            <div class="role-title">Patient</div>
                            <div class="role-desc">Book appointments &amp; get AI health predictions</div>
                            <span class="role-badge">Register &rarr;</span>
                        </a>
                    </div>

                    <!-- Doctor Card -->
                    <div class="col-6">
                        <a href="doctorRegister.jsp" class="role-card doctor">
                            <div class="role-icon-wrap">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <div class="role-title">Doctor</div>
                            <div class="role-desc">Manage patients &amp; handle appointments</div>
                            <span class="role-badge">Register &rarr;</span>
                        </a>
                    </div>

                </div>

                <!-- Already have account -->
                <hr class="my-3">
                <p class="text-center text-muted mb-2" style="font-size:0.83rem;">Already have an account?</p>
                <div class="text-center login-links" style="font-size:0.83rem;">
                    <a href="userLogin.jsp" style="color:#667eea;">
                        <i class="fas fa-user me-1"></i>Patient Login
                    </a>
                    &nbsp;&nbsp;|&nbsp;&nbsp;
                    <a href="doctorLogin.jsp" style="color:#11998e;">
                        <i class="fas fa-stethoscope me-1"></i>Doctor Login
                    </a>
                </div>
            </div>

        </div>
    </div>
</div>


<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
