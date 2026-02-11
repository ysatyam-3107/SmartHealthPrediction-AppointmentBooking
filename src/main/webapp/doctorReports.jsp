<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.mycompany.smarthealthprediction.health.db.DBConnection" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%
    if (session.getAttribute("doctorId") == null) {
        response.sendRedirect("doctorLogin.jsp");
        return;
    }
    String doctorName = (String) session.getAttribute("doctorName");
    String specialization = (String) session.getAttribute("specialization");
    Integer doctorId = (Integer) session.getAttribute("doctorId");

    // ---- Declare all counters ----
    int totalAppointments = 0, pending = 0, confirmed = 0;
    int completed = 0, cancelled = 0, totalPatients = 0;
    double totalRevenue = 0, avgFee = 0;

    // ---- Month-wise data (last 6 months) ----
    List<String>  monthLabels   = new ArrayList<>();
    List<Integer> monthCounts   = new ArrayList<>();
    List<Double>  monthRevenue  = new ArrayList<>();

    // ---- Day-of-week data ----
    int[] dayCount = new int[7]; // 0=Sun … 6=Sat
    String[] dayNames = {"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};

    // ---- Recent appointments ----
    List<Map<String,String>> recentList = new ArrayList<>();

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();

        /* ===== SUMMARY STATS ===== */
        String sumSql =
            "SELECT " +
            "  COUNT(*) AS total, " +
            "  SUM(CASE WHEN a.status='Pending'   THEN 1 ELSE 0 END) AS pending, " +
            "  SUM(CASE WHEN a.status='Confirmed' THEN 1 ELSE 0 END) AS confirmed, " +
            "  SUM(CASE WHEN a.status='Completed' THEN 1 ELSE 0 END) AS completed, " +
            "  SUM(CASE WHEN a.status='Cancelled' THEN 1 ELSE 0 END) AS cancelled, " +
            "  COUNT(DISTINCT a.user_id) AS patients, " +
            "  COALESCE(SUM(CASE WHEN p.payment_id IS NOT NULL THEN d.consultation_fee ELSE 0 END),0) AS revenue " +
            "FROM appointments a " +
            "JOIN doctors d ON d.doctor_id = a.doctor_id " +
            "LEFT JOIN payments p ON p.appointment_id = a.appointment_id " +
            "WHERE a.doctor_id = ?";
        pstmt = conn.prepareStatement(sumSql);
        pstmt.setInt(1, doctorId);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            totalAppointments = rs.getInt("total");
            pending           = rs.getInt("pending");
            confirmed         = rs.getInt("confirmed");
            completed         = rs.getInt("completed");
            cancelled         = rs.getInt("cancelled");
            totalPatients     = rs.getInt("patients");
            totalRevenue      = rs.getDouble("revenue");
        }
        rs.close(); pstmt.close();

        /* ===== AVG CONSULTATION FEE ===== */
        pstmt = conn.prepareStatement("SELECT consultation_fee FROM doctors WHERE doctor_id = ?");
        pstmt.setInt(1, doctorId);
        rs = pstmt.executeQuery();
        if (rs.next()) avgFee = rs.getDouble("consultation_fee");
        rs.close(); pstmt.close();

        /* ===== MONTHLY DATA (last 6 months) ===== */
        String monthlySql =
            "SELECT DATE_FORMAT(a.appointment_date,'%b %Y') AS month_label, " +
            "       DATE_FORMAT(a.appointment_date,'%Y-%m') AS month_sort, " +
            "       COUNT(*) AS cnt, " +
            "       COALESCE(SUM(CASE WHEN p.payment_id IS NOT NULL THEN d.consultation_fee ELSE 0 END),0) AS rev " +
            "FROM appointments a " +
            "JOIN doctors d ON d.doctor_id = a.doctor_id " +
            "LEFT JOIN payments p ON p.appointment_id = a.appointment_id " +
            "WHERE a.doctor_id = ? " +
            "  AND a.appointment_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) " +
            "GROUP BY month_sort, month_label " +
            "ORDER BY month_sort";
        pstmt = conn.prepareStatement(monthlySql);
        pstmt.setInt(1, doctorId);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            monthLabels.add(rs.getString("month_label"));
            monthCounts.add(rs.getInt("cnt"));
            monthRevenue.add(rs.getDouble("rev"));
        }
        rs.close(); pstmt.close();

        /* ===== DAY-OF-WEEK ===== */
        String daySql =
            "SELECT DAYOFWEEK(appointment_date) AS dow, COUNT(*) AS cnt " +
            "FROM appointments WHERE doctor_id = ? " +
            "GROUP BY DAYOFWEEK(appointment_date)";
        pstmt = conn.prepareStatement(daySql);
        pstmt.setInt(1, doctorId);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            int dow = rs.getInt("dow") - 1; // MySQL: 1=Sun
            if (dow >= 0 && dow < 7) dayCount[dow] = rs.getInt("cnt");
        }
        rs.close(); pstmt.close();

        /* ===== RECENT 10 APPOINTMENTS ===== */
        String recentSql =
            "SELECT a.appointment_id, a.appointment_date, a.appointment_time, " +
            "       a.status, a.symptoms, u.full_name, u.phone, " +
            "       CASE WHEN p.payment_id IS NOT NULL THEN 'Yes' ELSE 'No' END AS paid " +
            "FROM appointments a " +
            "JOIN users u ON u.user_id = a.user_id " +
            "LEFT JOIN payments p ON p.appointment_id = a.appointment_id " +
            "WHERE a.doctor_id = ? " +
            "ORDER BY a.appointment_date DESC, a.appointment_time DESC " +
            "LIMIT 10";
        pstmt = conn.prepareStatement(recentSql);
        pstmt.setInt(1, doctorId);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            Map<String,String> row = new LinkedHashMap<>();
            row.put("id",      String.valueOf(rs.getInt("appointment_id")));
            row.put("patient", rs.getString("full_name"));
            row.put("phone",   rs.getString("phone"));
            row.put("date",    rs.getString("appointment_date"));
            row.put("time",    rs.getString("appointment_time"));
            row.put("status",  rs.getString("status"));
            row.put("paid",    rs.getString("paid"));
            String sym = rs.getString("symptoms");
            row.put("symptoms", sym != null && sym.length() > 40 ? sym.substring(0,40)+"…" : sym);
            recentList.add(row);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rs    != null) try { rs.close();    } catch(Exception ignored){}
        if (pstmt != null) try { pstmt.close(); } catch(Exception ignored){}
        if (conn  != null) try { conn.close();  } catch(Exception ignored){}
    }

    // Build JSON arrays for Chart.js
    StringBuilder jsMonthLabels  = new StringBuilder("[");
    StringBuilder jsMonthCounts  = new StringBuilder("[");
    StringBuilder jsMonthRevenue = new StringBuilder("[");
    for (int i = 0; i < monthLabels.size(); i++) {
        if (i > 0) { jsMonthLabels.append(","); jsMonthCounts.append(","); jsMonthRevenue.append(","); }
        jsMonthLabels.append("'").append(monthLabels.get(i)).append("'");
        jsMonthCounts.append(monthCounts.get(i));
        jsMonthRevenue.append(monthRevenue.get(i));
    }
    jsMonthLabels.append("]"); jsMonthCounts.append("]"); jsMonthRevenue.append("]");

    StringBuilder jsDayCounts = new StringBuilder("[");
    for (int i = 0; i < 7; i++) {
        if (i > 0) jsDayCounts.append(",");
        jsDayCounts.append(dayCount[i]);
    }
    jsDayCounts.append("]");

    int cancelledSafe  = cancelled;
    int completedSafe  = completed;
    int confirmedSafe  = confirmed;
    int pendingSafe    = pending;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Reports – Smart Health</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f4f6f9; font-family: 'Segoe UI', sans-serif; }

        /* ---- Stat cards ---- */
        .stat-card {
            border: none;
            border-radius: 16px;
            transition: transform .3s, box-shadow .3s;
            overflow: hidden;
        }
        .stat-card:hover { transform: translateY(-6px); box-shadow: 0 12px 30px rgba(0,0,0,.15); }
        .stat-card .icon-wrap {
            width: 56px; height: 56px; border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            background: rgba(255,255,255,.25); font-size: 1.6rem; color: #fff;
        }
        .stat-card .card-body { padding: 1.4rem; }
        .stat-card .stat-num  { font-size: 2.2rem; font-weight: 800; color: #fff; line-height: 1; }
        .stat-card .stat-lbl  { font-size: .85rem; color: rgba(255,255,255,.88); margin-top: 4px; }

        .card-blue   { background: linear-gradient(135deg,#4e73df,#224abe); }
        .card-yellow { background: linear-gradient(135deg,#f6c23e,#dda20a); }
        .card-cyan   { background: linear-gradient(135deg,#36b9cc,#1a8a9a); }
        .card-green  { background: linear-gradient(135deg,#1cc88a,#13855c); }
        .card-red    { background: linear-gradient(135deg,#e74a3b,#be2617); }
        .card-purple { background: linear-gradient(135deg,#9b59b6,#6c3483); }
        .card-orange { background: linear-gradient(135deg,#fd7e14,#c0550a); }
        .card-teal   { background: linear-gradient(135deg,#20c9a6,#0d6e5b); }

        /* ---- Chart cards ---- */
        .chart-card {
            border: none; border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,.07);
        }
        .chart-card .card-header {
            border-radius: 16px 16px 0 0 !important;
            background: linear-gradient(135deg,#1cc88a,#13855c);
            color: #fff; font-weight: 600; border: none;
        }
        canvas { max-height: 280px; }

        /* ---- Table ---- */
        .report-table thead { background: linear-gradient(135deg,#1cc88a,#13855c); color:#fff; }
        .report-table tbody tr:hover { background: #f0fdf8; }
        .badge-pending   { background:#f6c23e; color:#333; }
        .badge-confirmed { background:#36b9cc; color:#fff; }
        .badge-completed { background:#1cc88a; color:#fff; }
        .badge-cancelled { background:#e74a3b; color:#fff; }

        /* ---- Summary bar ---- */
        .summary-bar { background:#fff; border-radius:16px; padding:20px 28px;
                       box-shadow:0 4px 20px rgba(0,0,0,.07); }

        /* ---- Print ---- */
        @media print {
            nav, footer, .no-print { display:none !important; }
            body { background:#fff; }
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-success">
    <div class="container">
        <a class="navbar-brand" href="doctorDashboard.jsp">
            <i class="fas fa-user-md"></i> Smart Health – Doctor Portal
        </a>
        <button class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#navNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="doctorDashboard.jsp">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="doctorAppointments.jsp">My Appointments</a></li>
                <li class="nav-item"><a class="nav-link active" href="doctorReports.jsp">Reports</a></li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
                        <i class="fas fa-user-md"></i> Dr. <%= doctorName %>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="doctorProfile.jsp">Profile</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="LogoutServlet">Logout</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container my-4">

    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
        <div>
            <h3 class="fw-bold mb-1">
                <i class="fas fa-chart-bar text-success"></i> Appointment Reports
            </h3>
            <p class="text-muted mb-0">Dr. <%= doctorName %> &nbsp;|&nbsp; <%= specialization %></p>
        </div>
        <div class="d-flex gap-2 no-print">
            <button onclick="window.print()" class="btn btn-outline-success">
                <i class="fas fa-print"></i> Print
            </button>
            <a href="doctorDashboard.jsp" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left"></i> Dashboard
            </a>
        </div>
    </div>

    <!-- ===== STAT CARDS ROW 1 ===== -->
    <div class="row g-3 mb-4">
        <div class="col-xl-3 col-md-6">
            <div class="card stat-card card-blue h-100">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="icon-wrap"><i class="fas fa-calendar-check"></i></div>
                    <div>
                        <div class="stat-num"><%= totalAppointments %></div>
                        <div class="stat-lbl">Total Appointments</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="card stat-card card-yellow h-100">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="icon-wrap"><i class="fas fa-hourglass-half"></i></div>
                    <div>
                        <div class="stat-num"><%= pending %></div>
                        <div class="stat-lbl">Pending</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="card stat-card card-cyan h-100">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="icon-wrap"><i class="fas fa-check-circle"></i></div>
                    <div>
                        <div class="stat-num"><%= confirmed %></div>
                        <div class="stat-lbl">Confirmed</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="card stat-card card-green h-100">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="icon-wrap"><i class="fas fa-check-double"></i></div>
                    <div>
                        <div class="stat-num"><%= completed %></div>
                        <div class="stat-lbl">Completed</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== STAT CARDS ROW 2 ===== -->
    <div class="row g-3 mb-4">
        <div class="col-xl-3 col-md-6">
            <div class="card stat-card card-red h-100">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="icon-wrap"><i class="fas fa-times-circle"></i></div>
                    <div>
                        <div class="stat-num"><%= cancelled %></div>
                        <div class="stat-lbl">Cancelled</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="card stat-card card-purple h-100">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="icon-wrap"><i class="fas fa-users"></i></div>
                    <div>
                        <div class="stat-num"><%= totalPatients %></div>
                        <div class="stat-lbl">Unique Patients</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="card stat-card card-orange h-100">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="icon-wrap"><i class="fas fa-rupee-sign"></i></div>
                    <div>
                        <div class="stat-num">₹<%= String.format("%.0f", totalRevenue) %></div>
                        <div class="stat-lbl">Total Revenue</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="card stat-card card-teal h-100">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="icon-wrap"><i class="fas fa-percent"></i></div>
                    <div>
                        <div class="stat-num">
                            <%= totalAppointments > 0
                                ? String.format("%.0f", (completed * 100.0 / totalAppointments))
                                : 0 %>%
                        </div>
                        <div class="stat-lbl">Completion Rate</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== CHARTS ROW ===== -->
    <div class="row g-4 mb-4">

        <!-- Monthly Appointments Bar Chart -->
        <div class="col-lg-8">
            <div class="card chart-card h-100">
                <div class="card-header">
                    <i class="fas fa-chart-bar"></i> Monthly Appointments (Last 6 Months)
                </div>
                <div class="card-body">
                    <canvas id="monthlyChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Status Doughnut Chart -->
        <div class="col-lg-4">
            <div class="card chart-card h-100">
                <div class="card-header">
                    <i class="fas fa-chart-pie"></i> Status Breakdown
                </div>
                <div class="card-body d-flex align-items-center justify-content-center">
                    <canvas id="statusChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">

        <!-- Revenue Line Chart -->
        <div class="col-lg-8">
            <div class="card chart-card h-100">
                <div class="card-header">
                    <i class="fas fa-rupee-sign"></i> Monthly Revenue (Last 6 Months)
                </div>
                <div class="card-body">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Day-of-Week Bar Chart -->
        <div class="col-lg-4">
            <div class="card chart-card h-100">
                <div class="card-header">
                    <i class="fas fa-calendar-week"></i> Appointments by Day
                </div>
                <div class="card-body">
                    <canvas id="dayChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== SUMMARY BAR ===== -->
    <div class="summary-bar mb-4">
        <div class="row text-center">
            <div class="col">
                <div class="fw-bold text-success fs-5">₹<%= String.format("%.0f", avgFee) %></div>
                <div class="text-muted small">Consultation Fee</div>
            </div>
            <div class="col border-start">
                <div class="fw-bold text-primary fs-5">
                    <%= totalAppointments > 0
                        ? String.format("%.1f", (double)(pending + confirmed) / totalAppointments * 100)
                        : 0 %>%
                </div>
                <div class="text-muted small">Active Rate</div>
            </div>
            <div class="col border-start">
                <div class="fw-bold text-danger fs-5">
                    <%= totalAppointments > 0
                        ? String.format("%.1f", cancelled * 100.0 / totalAppointments)
                        : 0 %>%
                </div>
                <div class="text-muted small">Cancellation Rate</div>
            </div>
            <div class="col border-start">
                <div class="fw-bold text-info fs-5"><%= totalPatients %></div>
                <div class="text-muted small">Unique Patients</div>
            </div>
            <div class="col border-start">
                <div class="fw-bold text-warning fs-5">
                    ₹<%= totalPatients > 0
                        ? String.format("%.0f", totalRevenue / totalPatients)
                        : 0 %>
                </div>
                <div class="text-muted small">Revenue / Patient</div>
            </div>
        </div>
    </div>

    <!-- ===== RECENT APPOINTMENTS TABLE ===== -->
    <div class="card chart-card mb-5">
        <div class="card-header d-flex justify-content-between align-items-center">
            <span><i class="fas fa-list-alt"></i> Recent Appointments (Last 10)</span>
            <a href="doctorAppointments.jsp" class="btn btn-sm btn-light">View All</a>
        </div>
        <div class="card-body p-0">
            <% if (recentList.isEmpty()) { %>
                <div class="alert alert-info m-3 text-center">
                    <i class="fas fa-info-circle"></i> No appointments found.
                </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="table report-table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Patient</th>
                            <th>Phone</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Symptoms</th>
                            <th>Status</th>
                            <th>Paid</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% int sno = 1; for (Map<String,String> row : recentList) {
                               String st = row.get("status");
                               String bc = "badge-confirmed";
                               if ("Pending".equals(st))   bc = "badge-pending";
                               else if ("Completed".equals(st)) bc = "badge-completed";
                               else if ("Cancelled".equals(st)) bc = "badge-cancelled";
                        %>
                        <tr>
                            <td><%= sno++ %></td>
                            <td><i class="fas fa-user-circle text-success"></i> <%= row.get("patient") %></td>
                            <td><small><%= row.get("phone") %></small></td>
                            <td><%= row.get("date") %></td>
                            <td><%= row.get("time") %></td>
                            <td><small class="text-muted"><%= row.get("symptoms") %></small></td>
                            <td><span class="badge rounded-pill <%= bc %>"><%= st %></span></td>
                            <td>
                                <% if ("Yes".equals(row.get("paid"))) { %>
                                    <span class="badge bg-success"><i class="fas fa-check"></i> Yes</span>
                                <% } else { %>
                                    <span class="badge bg-secondary">No</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>
</div>

<!-- FOOTER -->
<footer class="bg-dark text-white text-center py-3">
    <p class="mb-0">&copy; 2026 Smart Health System – Doctor Portal</p>
</footer>

<!-- Bootstrap + Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

<script>
const monthLabels  = <%= jsMonthLabels.toString() %>;
const monthCounts  = <%= jsMonthCounts.toString() %>;
const monthRevenue = <%= jsMonthRevenue.toString() %>;
const dayCounts    = <%= jsDayCounts.toString() %>;

// ---- Gradient helper ----
function makeGradient(ctx, c1, c2) {
    const g = ctx.createLinearGradient(0, 0, 0, 280);
    g.addColorStop(0, c1); g.addColorStop(1, c2);
    return g;
}

// ---- 1. Monthly bar chart ----
const mCtx = document.getElementById('monthlyChart').getContext('2d');
new Chart(mCtx, {
    type: 'bar',
    data: {
        labels: monthLabels.length ? monthLabels : ['No data'],
        datasets: [{
            label: 'Appointments',
            data: monthCounts.length ? monthCounts : [0],
            backgroundColor: makeGradient(mCtx, 'rgba(28,200,138,.85)', 'rgba(28,200,138,.25)'),
            borderColor: '#1cc88a',
            borderWidth: 2,
            borderRadius: 8
        }]
    },
    options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: {
            y: { beginAtZero: true, ticks: { precision: 0 },
                 grid: { color: 'rgba(0,0,0,.05)' } },
            x: { grid: { display: false } }
        }
    }
});

// ---- 2. Status doughnut ----
const sCtx = document.getElementById('statusChart').getContext('2d');
new Chart(sCtx, {
    type: 'doughnut',
    data: {
        labels: ['Pending','Confirmed','Completed','Cancelled'],
        datasets: [{
            data: [<%= pendingSafe %>, <%= confirmedSafe %>, <%= completedSafe %>, <%= cancelledSafe %>],
            backgroundColor: ['#f6c23e','#36b9cc','#1cc88a','#e74a3b'],
            borderWidth: 3, borderColor: '#fff'
        }]
    },
    options: {
        responsive: true,
        cutout: '65%',
        plugins: {
            legend: { position: 'bottom',
                labels: { padding: 15, usePointStyle: true } }
        }
    }
});

// ---- 3. Revenue line chart ----
const rCtx = document.getElementById('revenueChart').getContext('2d');
new Chart(rCtx, {
    type: 'line',
    data: {
        labels: monthLabels.length ? monthLabels : ['No data'],
        datasets: [{
            label: 'Revenue (₹)',
            data: monthRevenue.length ? monthRevenue : [0],
            borderColor: '#4e73df',
            backgroundColor: makeGradient(rCtx, 'rgba(78,115,223,.35)', 'rgba(78,115,223,.02)'),
            borderWidth: 3,
            fill: true,
            tension: 0.4,
            pointBackgroundColor: '#4e73df',
            pointRadius: 5
        }]
    },
    options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: {
            y: { beginAtZero: true,
                 ticks: { callback: v => '₹' + v },
                 grid: { color: 'rgba(0,0,0,.05)' } },
            x: { grid: { display: false } }
        }
    }
});

// ---- 4. Day-of-week horizontal bar ----
const dCtx = document.getElementById('dayChart').getContext('2d');
new Chart(dCtx, {
    type: 'bar',
    data: {
        labels: ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'],
        datasets: [{
            label: 'Appointments',
            data: dayCounts,
            backgroundColor: [
                '#e74a3b','#4e73df','#1cc88a','#36b9cc',
                '#f6c23e','#fd7e14','#9b59b6'
            ],
            borderRadius: 6
        }]
    },
    options: {
        indexAxis: 'y',
        responsive: true,
        plugins: { legend: { display: false } },
        scales: {
            x: { beginAtZero: true, ticks: { precision: 0 },
                 grid: { color: 'rgba(0,0,0,.05)' } },
            y: { grid: { display: false } }
        }
    }
});
</script>
</body>
</html>
