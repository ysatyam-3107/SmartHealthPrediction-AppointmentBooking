<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Disease Prediction</title>

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

<!-- Main -->
<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8">

            <div class="card shadow-lg border-0">
                <div class="card-header bg-success text-white text-center">
                    <h4>
                        <i class="fas fa-brain"></i> AI Disease Prediction
                    </h4>
                </div>

                <div class="card-body p-4">

                    <!-- Info -->
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i>
                        This AI tool predicts possible diseases based on symptoms.
                        Always consult a doctor for medical advice.
                    </div>

                    <!-- ML Error -->
                    <%
                        Boolean mlError = (Boolean) request.getAttribute("mlError");
                        if (mlError != null && mlError) {
                    %>
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-triangle"></i>
                            ML service unavailable. Please start Python API.
                        </div>
                    <% } %>

                    <!-- Form -->
                    <form method="post" action="DiseasePredictionServlet">

                        <!-- Textarea -->
                        <div class="mb-4">
                            <label class="form-label fw-bold">
                                Describe Your Symptoms
                            </label>
                            <textarea class="form-control"
                                      name="symptoms"
                                      rows="5"
                                      placeholder="Example: fever, cough, headache, body pain..."
                                      required></textarea>
                            <small class="text-muted">
                                Enter multiple symptoms separated by comma.
                            </small>
                        </div>

                        <!-- Quick Symptoms -->
                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                Common Symptoms (click to add)
                            </label>
                            <div class="d-flex flex-wrap gap-2">

                                <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Fever</button>
                                <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Cough</button>
                                <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Headache</button>
                                <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Body Pain</button>
                                <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Fatigue</button>
                                <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Sore Throat</button>
                                <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Nausea</button>
                                <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Diarrhea</button>
                                <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Chest Pain</button>
                                <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Breathing Difficulty</button>

                            </div>
                        </div>

                        <!-- Buttons -->
                        <div class="row mt-4">
                            <div class="col-md-6 mb-2">
                                <button type="submit" class="btn btn-success w-100">
                                    <i class="fas fa-brain"></i> Predict Disease
                                </button>
                            </div>
                            <div class="col-md-6 mb-2">
                                <a href="userDashboard.jsp" class="btn btn-outline-secondary w-100">
                                    <i class="fas fa-home"></i> Back to Dashboard
                                </a>
                            </div>
                        </div>

                    </form>

                </div>
            </div>

        </div>
    </div>
</div>

<!-- JS -->
<script>
    document.querySelectorAll('.symptom-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const textarea = document.querySelector('textarea[name="symptoms"]');
            const symptom = btn.textContent;

            if (!textarea.value.toLowerCase().includes(symptom.toLowerCase())) {
                textarea.value = textarea.value
                    ? textarea.value + ", " + symptom
                    : symptom;
            }
        });
    });
</script>

</body>
</html>
