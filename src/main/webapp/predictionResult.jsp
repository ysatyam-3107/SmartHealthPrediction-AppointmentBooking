<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }

    String predictedDisease = (String) session.getAttribute("predictedDisease");
    String confidenceScore = String.valueOf(session.getAttribute("confidenceScore"));
    String recommendations = (String) session.getAttribute("recommendations");

    if (predictedDisease == null) {
        response.sendRedirect("diseasePrediction.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Prediction Result</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="userDashboard.jsp">
            <i class="fas fa-heartbeat"></i> Smart Health
        </a>
        <div class="ms-auto">
            <a href="userDashboard.jsp" class="btn btn-outline-light">
                <i class="fas fa-home"></i> Dashboard
            </a>
        </div>
    </div>
</nav>

<!-- Main Container -->
<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8">

            <!-- Result Card -->
            <div class="card shadow-lg border-0">
                <div class="card-header bg-success text-white text-center">
                    <h4>
                        <i class="fas fa-brain"></i> AI Disease Prediction Result
                    </h4>
                </div>

                <div class="card-body p-4">

                    <!-- Predicted Disease -->
                    <div class="text-center mb-4">
                        <h6 class="text-muted">Predicted Disease</h6>
                        <h2 class="text-danger fw-bold">
                            <%= predictedDisease %>
                        </h2>
                    </div>

                    <!-- Confidence -->
                    <div class="mb-4">
                        <h6>Confidence Level</h6>
                        <div class="progress" style="height: 25px;">
                            <div class="progress-bar bg-success"
                                 role="progressbar"
                                 style="width: <%= confidenceScore %>%;">
                                <%= confidenceScore %>%
                            </div>
                        </div>
                    </div>

                    <!-- Recommendations -->
                    <div class="alert alert-info">
                        <h6>
                            <i class="fas fa-lightbulb"></i> Recommendations
                        </h6>
                        <p class="mb-0"><%= recommendations %></p>
                    </div>

                    <!-- Disclaimer -->
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        This is an AI-based prediction and should not replace professional medical advice.
                        Please consult a qualified doctor.
                    </div>

                    <!-- Action Buttons -->
                    <div class="row g-3 mt-4">

                        <div class="col-md-4">
                            <a href="bookAppointment.jsp" class="btn btn-primary w-100">
                                <i class="fas fa-calendar-check"></i> Book Appointment
                            </a>
                        </div>

                        <div class="col-md-4">
                            <a href="diseasePrediction.jsp" class="btn btn-outline-success w-100">
                                <i class="fas fa-redo"></i> New Prediction
                            </a>
                        </div>

                        <div class="col-md-4">
                            <a href="userDashboard.jsp" class="btn btn-outline-secondary w-100">
                                <i class="fas fa-home"></i> Dashboard
                            </a>
                        </div>

                    </div>

                </div>
            </div>

        </div>
    </div>
</div>

</body>
</html>

<%
    // Clear session data after displaying result
    session.removeAttribute("predictedDisease");
    session.removeAttribute("confidenceScore");
    session.removeAttribute("recommendations");
    session.removeAttribute("matchedSymptoms");
%>
