<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }
    String appointmentId = request.getParameter("appointmentId");
    String amount = request.getParameter("amount");
    
    if (appointmentId == null || amount == null) {
        response.sendRedirect("userAppointments.jsp?error=Invalid payment request.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Make Payment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
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
                <div class="card shadow border-0">
                    <div class="card-header bg-primary text-white text-center">
                        <h4><i class="fas fa-credit-card"></i> Make Payment</h4>
                    </div>
                    <div class="card-body p-4">
                        <% 
                            String error = request.getParameter("error");
                            if (error != null) {
                        %>
                            <div class="alert alert-danger alert-dismissible fade show">
                                <%= error %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>
                        
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i> <strong>Appointment ID:</strong> #<%= appointmentId %>
                        </div>

                        <div class="mb-4 p-3 bg-light rounded">
                            <h5 class="text-center mb-3">Payment Summary</h5>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Consultation Fee:</span>
                                <strong>₹<%= amount %></strong>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between">
                                <h5>Total Amount:</h5>
                                <h5 class="text-success">₹<%= amount %></h5>
                            </div>
                        </div>

                        <form action="PaymentServlet" method="post" id="paymentForm">
                            <input type="hidden" name="appointmentId" value="<%= appointmentId %>">
                            <input type="hidden" name="amount" value="<%= amount %>">

                            <div class="mb-3">
                                <label class="form-label">Payment Method *</label>
                                <select class="form-select" name="paymentMethod" id="paymentMethod" required>
                                    <option value="">Select payment method...</option>
                                    <option value="Credit Card">Credit Card</option>
                                    <option value="Debit Card">Debit Card</option>
                                    <option value="UPI">UPI</option>
                                    <option value="Net Banking">Net Banking</option>
                                    <option value="Wallet">Wallet</option>
                                </select>
                            </div>

                            <div id="cardDetails" style="display: none;">
                                <div class="mb-3">
                                    <label class="form-label">Card Number</label>
                                    <input type="text" class="form-control" placeholder="1234 5678 9012 3456" maxlength="19">
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Expiry Date</label>
                                        <input type="text" class="form-control" placeholder="MM/YY" maxlength="5">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">CVV</label>
                                        <input type="password" class="form-control" placeholder="***" maxlength="3">
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Cardholder Name</label>
                                    <input type="text" class="form-control" placeholder="Enter name as on card">
                                </div>
                            </div>

                            <div id="upiDetails" style="display: none;">
                                <div class="mb-3">
                                    <label class="form-label">UPI ID</label>
                                    <input type="text" class="form-control" placeholder="yourname@upi">
                                </div>
                            </div>

                            <div class="alert alert-warning">
                                <small><i class="fas fa-shield-alt"></i> Your payment information is secure and encrypted.</small>
                            </div>

                            <button type="submit" class="btn btn-success btn-lg w-100">
                                <i class="fas fa-lock"></i> Pay ₹<%= amount %>
                            </button>

                            <a href="userAppointments.jsp" class="btn btn-outline-secondary w-100 mt-2">Cancel</a>
                        </form>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <small class="text-muted">
                        <i class="fas fa-shield-alt"></i> Secured by SSL Encryption | 
                        <i class="fas fa-lock"></i> PCI DSS Compliant
                    </small>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('paymentMethod').addEventListener('change', function() {
            var cardDetails = document.getElementById('cardDetails');
            var upiDetails = document.getElementById('upiDetails');
            
            cardDetails.style.display = 'none';
            upiDetails.style.display = 'none';
            
            if (this.value === 'Credit Card' || this.value === 'Debit Card') {
                cardDetails.style.display = 'block';
            } else if (this.value === 'UPI') {
                upiDetails.style.display = 'block';
            }
        });
    </script>
</body>
</html>