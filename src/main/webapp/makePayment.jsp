<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.mycompany.smarthealthprediction.health.db.DBConnection" %>
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

    // Fetch doctor details for this appointment
    String doctorName = "";
    String doctorSpecialization = "";
    String doctorHospital = "";
    String doctorLocation = "";
    String doctorUpiId = "";
    String doctorPhoto = "";
    String appointmentDate = "";
    String appointmentTime = "";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        String sql = "SELECT d.full_name, d.specialization, d.hospital_name, d.location, " +
                     "d.profile_photo, d.upi_id, a.appointment_date, a.appointment_time " +
                     "FROM appointments a JOIN doctors d ON a.doctor_id = d.doctor_id " +
                     "WHERE a.appointment_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(appointmentId));
        rs = pstmt.executeQuery();
        if (rs.next()) {
            doctorName        = rs.getString("full_name");
            doctorSpecialization = rs.getString("specialization");
            doctorHospital    = rs.getString("hospital_name");
            doctorLocation    = rs.getString("location");
            doctorPhoto       = rs.getString("profile_photo") != null ? rs.getString("profile_photo") : "";
            doctorUpiId       = rs.getString("upi_id") != null ? rs.getString("upi_id") : "";
            appointmentDate   = rs.getString("appointment_date");
            appointmentTime   = rs.getString("appointment_time");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    // Generate doctor initials for CSS avatar
    String drInitials = "";
    if (!doctorName.isEmpty()) {
        String[] parts = doctorName.trim().split("\\s+");
        if (parts.length >= 2) {
            drInitials = String.valueOf(parts[0].charAt(0)).toUpperCase() +
                         String.valueOf(parts[parts.length - 1].charAt(0)).toUpperCase();
        } else {
            drInitials = String.valueOf(parts[0].charAt(0)).toUpperCase();
        }
    }

    // Demo UPI if doctor hasn't set one
    String displayUpi = doctorUpiId.isEmpty() ? "smarthealthdemo@upi" : doctorUpiId;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Make Payment - Smart Health</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f0f4f8; }

        /* ---- DOCTOR PAYMENT CARD ---- */
        .pay-to-card {
            background: linear-gradient(135deg, #1a1a2e, #16213e);
            border-radius: 20px;
            color: white;
            padding: 20px;
            margin-bottom: 20px;
            position: relative;
            overflow: hidden;
        }
        .pay-to-card::before {
            content: '';
            position: absolute;
            top: -40px; right: -40px;
            width: 150px; height: 150px;
            border-radius: 50%;
            background: rgba(255,255,255,0.05);
        }
        .pay-to-card::after {
            content: '';
            position: absolute;
            bottom: -30px; left: -30px;
            width: 120px; height: 120px;
            border-radius: 50%;
            background: rgba(255,255,255,0.04);
        }

        .dr-avatar {
            width: 65px; height: 65px;
            border-radius: 50%;
            border: 3px solid rgba(255,255,255,0.3);
            object-fit: cover;
        }
        .dr-avatar-initials {
            width: 65px; height: 65px;
            border-radius: 50%;
            background: linear-gradient(135deg, #0d6efd, #6610f2);
            border: 3px solid rgba(255,255,255,0.3);
            color: white;
            font-size: 1.4rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .upi-badge {
            background: rgba(255,255,255,0.12);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 10px;
            padding: 10px 14px;
            margin-top: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .upi-id-text {
            font-family: monospace;
            font-size: 1rem;
            letter-spacing: 0.5px;
            color: #90e0ef;
            font-weight: 600;
        }
        .copy-btn {
            background: rgba(255,255,255,0.15);
            border: none;
            color: white;
            border-radius: 6px;
            padding: 4px 10px;
            font-size: 0.75rem;
            cursor: pointer;
            transition: 0.2s;
            margin-left: auto;
        }
        .copy-btn:hover { background: rgba(255,255,255,0.3); }

        /* ---- PAYMENT METHODS ---- */
        .method-btn {
            border: 2px solid #dee2e6;
            border-radius: 12px;
            padding: 12px;
            cursor: pointer;
            transition: all 0.25s;
            text-align: center;
            background: white;
        }
        .method-btn:hover, .method-btn.active {
            border-color: #0d6efd;
            background: #f0f5ff;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(13,110,253,0.15);
        }
        .method-btn i { font-size: 1.5rem; display: block; margin-bottom: 4px; }
        .method-btn small { font-size: 0.72rem; color: #666; }

        /* ---- AMOUNT BOX ---- */
        .amount-box {
            background: linear-gradient(135deg, #198754, #20c997);
            border-radius: 14px;
            padding: 16px 20px;
            color: white;
            text-align: center;
        }

        /* ---- INPUT DETAILS ---- */
        .details-panel {
            background: #f8f9ff;
            border: 1.5px solid #e0e7ff;
            border-radius: 14px;
            padding: 18px;
            margin-top: 16px;
            animation: slideDown 0.3s ease;
        }
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .qr-box {
            background: white;
            border-radius: 12px;
            padding: 16px;
            text-align: center;
            border: 2px dashed #0d6efd;
        }
        .qr-placeholder {
            width: 130px; height: 130px;
            background: linear-gradient(135deg, #f0f4ff, #e8efff);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 8px;
            border: 1px solid #c7d7ff;
            flex-direction: column;
            gap: 4px;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="userDashboard.jsp">
                <i class="fas fa-heartbeat"></i> Smart Health
            </a>
        </div>
    </nav>

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-7">

                <%
                    String error = request.getParameter("error");
                    if (error != null) {
                %>
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="fas fa-exclamation-circle"></i> <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <!-- ===== PAY TO DOCTOR CARD ===== -->
                <div class="pay-to-card">
                    <div class="d-flex align-items-center gap-3">
                        <% if (!doctorPhoto.isEmpty()) { %>
                            <img src="<%= doctorPhoto %>" class="dr-avatar"
                                 onerror="this.style.display='none'; document.getElementById('drInitialBox').style.display='flex';">
                            <div id="drInitialBox" class="dr-avatar-initials" style="display:none;"><%= drInitials %></div>
                        <% } else { %>
                            <div class="dr-avatar-initials"><%= drInitials %></div>
                        <% } %>

                        <div>
                            <div style="font-size:0.78rem; opacity:0.7; letter-spacing:1px;">PAYING TO</div>
                            <div style="font-size:1.2rem; font-weight:700;">Dr. <%= doctorName %></div>
                            <div style="font-size:0.85rem; opacity:0.8;">
                                <i class="fas fa-stethoscope me-1"></i><%= doctorSpecialization %>
                                &nbsp;·&nbsp;
                                <i class="fas fa-hospital me-1"></i><%= doctorHospital %>
                            </div>
                        </div>
                    </div>

                    <!-- Appointment Info -->
                    <div class="d-flex gap-3 mt-3" style="font-size:0.82rem; opacity:0.85;">
                        <span><i class="fas fa-calendar me-1"></i> <%= appointmentDate %></span>
                        <span><i class="fas fa-clock me-1"></i> <%= appointmentTime %></span>
                        <span><i class="fas fa-map-marker-alt me-1"></i> <%= doctorLocation %></span>
                    </div>

                    <!-- UPI ID -->
                    <div class="upi-badge">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/UPI-Logo-vector.svg/120px-UPI-Logo-vector.svg.png"
                             height="22" alt="UPI"
                             onerror="this.outerHTML='<span style=\'color:#90e0ef;font-weight:700;\'>UPI</span>'">
                        <div>
                            <div style="font-size:0.7rem; opacity:0.7;">Doctor's UPI ID</div>
                            <div class="upi-id-text" id="upiIdText"><%= displayUpi %></div>
                        </div>
                        <button class="copy-btn" onclick="copyUpi()">
                            <i class="fas fa-copy"></i> Copy
                        </button>
                    </div>

                    <!-- Amount -->
                    <div class="amount-box mt-3">
                        <div style="font-size:0.8rem; opacity:0.85;">Total Amount to Pay</div>
                        <div style="font-size:2rem; font-weight:800;">₹<%= amount %></div>
                        <div style="font-size:0.75rem; opacity:0.75;">Consultation Fee · Appointment #<%= appointmentId %></div>
                    </div>
                </div>

                <!-- ===== PAYMENT FORM CARD ===== -->
                <div class="card shadow border-0" style="border-radius:20px; overflow:hidden;">
                    <div class="card-header bg-primary text-white text-center py-3">
                        <h5 class="mb-0"><i class="fas fa-credit-card me-2"></i>Choose Payment Method</h5>
                    </div>
                    <div class="card-body p-4">
                        <form action="PaymentServlet" method="post" id="paymentForm">
                            <input type="hidden" name="appointmentId" value="<%= appointmentId %>">
                            <input type="hidden" name="amount" value="<%= amount %>">
                            <input type="hidden" name="paymentMethod" id="paymentMethodInput">

                            <!-- Method Selector Grid -->
                            <div class="row g-2 mb-3">
                                <div class="col-3">
                                    <div class="method-btn" onclick="selectMethod('UPI', this)">
                                        <i class="fas fa-mobile-alt text-primary"></i>
                                        <small>UPI</small>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <div class="method-btn" onclick="selectMethod('Credit Card', this)">
                                        <i class="fas fa-credit-card text-success"></i>
                                        <small>Credit Card</small>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <div class="method-btn" onclick="selectMethod('Debit Card', this)">
                                        <i class="fas fa-credit-card text-warning"></i>
                                        <small>Debit Card</small>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <div class="method-btn" onclick="selectMethod('Net Banking', this)">
                                        <i class="fas fa-university text-info"></i>
                                        <small>Net Banking</small>
                                    </div>
                                </div>
                            </div>

                            <!-- UPI Details -->
                            <div id="panel_UPI" class="details-panel" style="display:none;">
                                <h6 class="mb-3"><i class="fas fa-mobile-alt text-primary"></i> Pay via UPI</h6>
                                <div class="row align-items-center">
                                    <div class="col-md-5">
                                        <div class="qr-box">
                                            <div class="qr-placeholder">
                                                <i class="fas fa-qrcode fa-3x text-primary"></i>
                                                <small class="text-muted" style="font-size:0.65rem;">Scan to Pay</small>
                                            </div>
                                            <small class="text-muted">Demo QR Code</small>
                                        </div>
                                    </div>
                                    <div class="col-md-7">
                                        <p class="mb-2 small text-muted">Or enter UPI ID manually:</p>
                                        <div class="input-group mb-3">
                                            <span class="input-group-text"><i class="fas fa-at"></i></span>
                                            <input type="text" class="form-control" 
                                                   value="<%= displayUpi %>" readonly
                                                   style="background:#f8f9fa; font-family:monospace;">
                                            <button type="button" class="btn btn-outline-primary" onclick="copyUpi()">
                                                <i class="fas fa-copy"></i>
                                            </button>
                                        </div>
                                        <div class="alert alert-info py-2 px-3 mb-0" style="font-size:0.8rem;">
                                            <i class="fas fa-info-circle"></i>
                                            Open any UPI app (GPay, PhonePe, Paytm), enter the above UPI ID and pay <strong>₹<%= amount %></strong>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Card Details -->
                            <div id="panel_Card" class="details-panel" style="display:none;">
                                <h6 class="mb-3"><i class="fas fa-credit-card text-success"></i> Card Details</h6>
                                <div class="mb-3">
                                    <label class="form-label small">Card Number</label>
                                    <input type="text" class="form-control" placeholder="1234 5678 9012 3456" maxlength="19"
                                           oninput="this.value=this.value.replace(/[^0-9]/g,'').replace(/(.{4})/g,'$1 ').trim()">
                                </div>
                                <div class="row">
                                    <div class="col-6 mb-3">
                                        <label class="form-label small">Expiry Date</label>
                                        <input type="text" class="form-control" placeholder="MM/YY" maxlength="5">
                                    </div>
                                    <div class="col-6 mb-3">
                                        <label class="form-label small">CVV</label>
                                        <input type="password" class="form-control" placeholder="•••" maxlength="3">
                                    </div>
                                </div>
                                <div class="mb-0">
                                    <label class="form-label small">Cardholder Name</label>
                                    <input type="text" class="form-control" placeholder="Name as on card">
                                </div>
                            </div>

                            <!-- Net Banking -->
                            <div id="panel_NetBanking" class="details-panel" style="display:none;">
                                <h6 class="mb-3"><i class="fas fa-university text-info"></i> Select Your Bank</h6>
                                <div class="row g-2">
                                    <% String[] banks = {"SBI", "HDFC", "ICICI", "Axis", "Kotak", "PNB"}; %>
                                    <% for (String bank : banks) { %>
                                    <div class="col-4">
                                        <div class="method-btn" onclick="this.classList.toggle('active')" style="padding:8px;">
                                            <i class="fas fa-building" style="font-size:1rem;"></i>
                                            <small><%= bank %></small>
                                        </div>
                                    </div>
                                    <% } %>
                                </div>
                            </div>

                            <div class="alert alert-warning mt-3 mb-3 py-2" style="font-size:0.8rem;">
                                <i class="fas fa-shield-alt"></i> <strong>Demo Mode:</strong> No real payment will be processed. Click Pay to confirm your appointment.
                            </div>

                            <button type="submit" class="btn btn-success btn-lg w-100" id="submitBtn" disabled
                                    style="border-radius:12px; font-size:1.1rem; font-weight:600;">
                                <i class="fas fa-lock me-2"></i>Pay ₹<%= amount %>
                            </button>

                            <a href="userAppointments.jsp" class="btn btn-outline-secondary w-100 mt-2"
                               style="border-radius:12px;">Cancel</a>
                        </form>
                    </div>
                </div>

                <div class="text-center mt-3">
                    <small class="text-muted">
                        <i class="fas fa-shield-alt text-success"></i> Secured by SSL &nbsp;|&nbsp;
                        <i class="fas fa-lock text-primary"></i> PCI DSS Compliant
                    </small>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function selectMethod(method, el) {
            // Highlight selected button
            document.querySelectorAll('.method-btn').forEach(b => b.classList.remove('active'));
            el.classList.add('active');

            // Set hidden input
            document.getElementById('paymentMethodInput').value = method;

            // Hide all panels
            document.getElementById('panel_UPI').style.display = 'none';
            document.getElementById('panel_Card').style.display = 'none';
            document.getElementById('panel_NetBanking').style.display = 'none';

            // Show correct panel
            if (method === 'UPI') {
                document.getElementById('panel_UPI').style.display = 'block';
            } else if (method === 'Credit Card' || method === 'Debit Card') {
                document.getElementById('panel_Card').style.display = 'block';
            } else if (method === 'Net Banking') {
                document.getElementById('panel_NetBanking').style.display = 'block';
            }

            // Enable pay button
            document.getElementById('submitBtn').disabled = false;
        }

        function copyUpi() {
            const upi = document.getElementById('upiIdText').innerText;
            navigator.clipboard.writeText(upi).then(() => {
                const btn = event.target.closest('button');
                const orig = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                btn.style.background = 'rgba(25,135,84,0.4)';
                setTimeout(() => { btn.innerHTML = orig; btn.style.background = ''; }, 2000);
            });
        }

        document.getElementById('paymentForm').addEventListener('submit', function(e) {
            if (!document.getElementById('paymentMethodInput').value) {
                e.preventDefault();
                alert('Please select a payment method first!');
            }
        });
    </script>
</body>
</html>
