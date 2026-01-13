<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }
    String transactionId = request.getParameter("transactionId");
    String paymentAmount = (String) session.getAttribute("lastPaymentAmount");
    
    // Clear the session attribute after retrieving
    session.removeAttribute("lastPaymentAmount");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Success</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .success-animation {
            animation: scaleIn 0.5s ease-in-out;
        }
        @keyframes scaleIn {
            from { transform: scale(0); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }
        .checkmark {
            animation: checkmark 0.8s ease-in-out;
        }
        @keyframes checkmark {
            0% { transform: scale(0) rotate(0deg); }
            50% { transform: scale(1.2) rotate(180deg); }
            100% { transform: scale(1) rotate(360deg); }
        }
    </style>
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="userDashboard.jsp">
                <i class="fas fa-heartbeat"></i> Smart Health
            </a>
        </div>
    </nav>

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow border-0 success-animation">
                    <div class="card-body text-center p-5">
                        <div class="mb-4 checkmark">
                            <i class="fas fa-check-circle text-success" style="font-size: 80px;"></i>
                        </div>
                        <h2 class="text-success mb-3">Payment Successful!</h2>
                        <p class="lead mb-4">Your appointment has been confirmed.</p>

                        <div class="bg-light p-4 rounded mb-4">
                            <div class="row mb-3">
                                <div class="col-6 text-start">
                                    <small class="text-muted">Transaction ID:</small>
                                </div>
                                <div class="col-6 text-end">
                                    <strong class="text-primary"><%= transactionId %></strong>
                                </div>
                            </div>
                            <hr>
                            <% if (paymentAmount != null) { %>
                            <div class="row mb-3">
                                <div class="col-6 text-start">
                                    <small class="text-muted">Amount Paid:</small>
                                </div>
                                <div class="col-6 text-end">
                                    <strong class="text-success">₹<%= paymentAmount %></strong>
                                </div>
                            </div>
                            <hr>
                            <% } %>
                            <div class="row mb-3">
                                <div class="col-6 text-start">
                                    <small class="text-muted">Date & Time:</small>
                                </div>
                                <div class="col-6 text-end">
                                    <strong><%= new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new java.util.Date()) %></strong>
                                </div>
                            </div>
                            <hr>
                            <div class="row">
                                <div class="col-6 text-start">
                                    <small class="text-muted">Status:</small>
                                </div>
                                <div class="col-6 text-end">
                                    <span class="badge bg-success">Completed</span>
                                </div>
                            </div>
                        </div>

                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i> A confirmation email has been sent to your registered email address.
                        </div>

                        <div class="d-grid gap-2">
                            <a href="userAppointments.jsp" class="btn btn-primary btn-lg">
                                <i class="fas fa-calendar-alt"></i> View My Appointments
                            </a>
                            <a href="userDashboard.jsp" class="btn btn-outline-secondary">
                                <i class="fas fa-home"></i> Go to Dashboard
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Receipt Download Option -->
                <div class="card mt-4 border-0 shadow-sm">
                    <div class="card-body text-center">
                        <h6 class="mb-3">Need a receipt?</h6>
                        <button class="btn btn-outline-primary" onclick="window.print()">
                            <i class="fas fa-download"></i> Download Receipt
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>