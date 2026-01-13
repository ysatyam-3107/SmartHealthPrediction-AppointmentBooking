<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <title>Disease Prediction</title>
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
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-success text-white text-center">
                        <h4><i class="fas fa-brain"></i> AI-Powered Disease Prediction</h4>
                    </div>
                    <div class="card-body p-4">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i> <strong>Note:</strong> This is an AI-based prediction system. For accurate diagnosis, please consult a qualified doctor.
                        </div>
                        
                        <% 
                            String error = request.getParameter("error");
                            if (error != null) {
                        %>
                            <div class="alert alert-danger alert-dismissible fade show">
                                <%= error %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>
                        
                        <form action="DiseasePredictionServlet" method="post">
                            <div class="mb-4">
                                <label class="form-label"><strong>Describe Your Symptoms *</strong></label>
                                <textarea class="form-control" name="symptoms" rows="6" 
                                          placeholder="Example: fever, cough, headache, body pain..." 
                                          required></textarea>
                                <small class="form-text text-muted">Please provide detailed symptoms for better prediction accuracy.</small>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label"><strong>Common Symptoms (Click to add):</strong></label><br>
                                <div class="d-flex flex-wrap gap-2">
                                    <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Fever</button>
                                    <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Cough</button>
                                    <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Headache</button>
                                    <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Chest Pain</button>
                                    <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Stomach Pain</button>
                                    <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Nausea</button>
                                    <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Diarrhea</button>
                                    <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Rash</button>
                                    <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Joint Pain</button>
                                    <button type="button" class="btn btn-sm btn-outline-primary symptom-btn">Breathing Difficulty</button>
                                </div>
                            </div>
                            
                            <button type="submit" class="btn btn-success btn-lg w-100 mt-3">
                                <i class="fas fa-brain"></i> Predict Disease
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.querySelectorAll('.symptom-btn').forEach(function(btn) {
            btn.addEventListener('click', function() {
                var textarea = document.querySelector('textarea[name="symptoms"]');
                var currentValue = textarea.value.trim();
                var symptom = this.textContent;
                
                if (currentValue) {
                    textarea.value = currentValue + ', ' + symptom;
                } else {
                    textarea.value = symptom;
                }
            });
        });
    </script>
</body>
</html>