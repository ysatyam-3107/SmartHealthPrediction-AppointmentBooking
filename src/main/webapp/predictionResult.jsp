<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }
    
    String predictedDisease = (String) session.getAttribute("predictedDisease");
    String confidenceScore = (String) session.getAttribute("confidenceScore");
    String recommendations = (String) session.getAttribute("recommendations");
    
    if (predictedDisease == null) {
        response.sendRedirect("diseasePrediction.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prediction Result</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .result-card {
            animation: fadeInUp 0.6s ease-in-out;
        }
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .confidence-meter {
            height: 30px;
            background: linear-gradient(to right, #ff6b6b, #feca57, #48dbfb, #1dd1a1);
            border-radius: 15px;
            position: relative;
        }
        .confidence-indicator {
            position: absolute;
            height: 40px;
            width: 4px;
            background: #2c3e50;
            top: -5px;
            border-radius: 2px;
        }
    </style>
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="userDashboard.jsp">
                <i class="fas fa-heartbeat"></i> Smart Health
            </a>
            <div class="ms-auto">
                <a href="userDashboard.jsp" class="btn btn-outline-light">Dashboard</a>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card result-card shadow border-0">
                    <div class="card-header bg-success text-white text-center py-4">
                        <h3><i class="fas fa-brain"></i> AI Prediction Result</h3>
                    </div>
                    <div class="card-body p-4">
                        <!-- Prediction Result -->
                        <div class="text-center mb-4 p-4 bg-light rounded">
                            <h5 class="text-muted mb-3">Predicted Condition</h5>
                            <h2 class="text-primary mb-0"><%= predictedDisease %></h2>
                        </div>

                        <!-- Confidence Score -->
                        <div class="mb-4">
                            <div class="d-flex justify-content-between mb-2">
                                <h6>Confidence Score</h6>
                                <strong class="text-success"><%= confidenceScore %>%</strong>
                            </div>
                            <div class="confidence-meter">
                                <div class="confidence-indicator" style="left: <%= confidenceScore %>%;"></div>
                            </div>
                            <div class="d-flex justify-content-between mt-2">
                                <small class="text-muted">Low</small>
                                <small class="text-muted">Medium</small>
                                <small class="text-muted">High</small>
                            </div>
                        </div>

                        <!-- Recommendations -->
                        <div class="alert alert-info">
                            <h6><i class="fas fa-lightbulb"></i> Recommendations</h6>
                            <p class="mb-0"><%= recommendations %></p>
                        </div>

                        <!-- Important Notice -->
                        <div class="alert alert-warning">
                            <h6><i class="fas fa-exclamation-triangle"></i> Important Notice</h6>
                            <p class="mb-0">
                                This is an AI-powered prediction and should not replace professional medical advice. 
                                Please consult with a qualified healthcare provider for accurate diagnosis and treatment.
                            </p>
                        </div>

                        <!-- Action Buttons -->
                        <div class="row g-3 mt-3">
                            <div class="col-md-6">
                                <a href="bookAppointment.jsp" class="btn btn-primary w-100">
                                    <i class="fas fa-calendar-plus"></i> Book Appointment with Doctor
                                </a>
                            </div>
                            <div class="col-md-6">
                                <a href="diseasePrediction.jsp" class="btn btn-outline-success w-100">
                                    <i class="fas fa-redo"></i> New Prediction
                                </a>
                            </div>
                        </div>

                        <div class="text-center mt-4">
                            <a href="userDashboard.jsp" class="btn btn-link">
                                <i class="fas fa-home"></i> Back to Dashboard
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Additional Info Card -->
                <div class="card mt-4 border-0 shadow-sm">
                    <div class="card-body">
                        <h6 class="mb-3"><i class="fas fa-info-circle"></i> What to do next?</h6>
                        <ul class="list-unstyled">
                            <li class="mb-2">
                                <i class="fas fa-check-circle text-success"></i> 
                                Monitor your symptoms closely
                            </li>
                            <li class="mb-2">
                                <i class="fas fa-check-circle text-success"></i> 
                                Maintain a healthy lifestyle
                            </li>
                            <li class="mb-2">
                                <i class="fas fa-check-circle text-success"></i> 
                                Schedule a consultation with a specialist
                            </li>
                            <li class="mb-2">
                                <i class="fas fa-check-circle text-success"></i> 
                                Keep a record of your symptoms
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>