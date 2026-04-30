<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Login – Smart Health</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --blue-dark: #0a2e6e;
            --blue-mid: #1a56db;
            --blue-light: #3b82f6;
            --blue-glow: #60a5fa;
            --cream: #f5f7fc;
            --text-dark: #0d1526;
            --text-muted: #6b7a96;
            --border: rgba(26,86,219,0.16);
            --card-bg: #ffffff;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            min-height: 100vh;
            display: flex;
            background: var(--cream);
            overflow: hidden;
        }

        /* ── LEFT PANEL ── */
        .panel-left {
            width: 48%;
            min-height: 100vh;
            background: linear-gradient(145deg, var(--blue-dark) 0%, var(--blue-mid) 55%, var(--blue-light) 100%);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 48px 52px;
            position: relative;
            overflow: hidden;
        }

        .panel-left::before {
            content: '';
            position: absolute;
            width: 420px; height: 420px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(96,165,250,0.28) 0%, transparent 70%);
            top: -80px; right: -100px;
        }
        .panel-left::after {
            content: '';
            position: absolute;
            width: 300px; height: 300px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255,255,255,0.07) 0%, transparent 70%);
            bottom: 60px; left: -60px;
        }

        /* floating circles decoration */
        .deco-circle {
            position: absolute;
            border-radius: 50%;
            border: 1.5px solid rgba(255,255,255,0.12);
        }
        .deco-circle.c1 { width: 200px; height: 200px; bottom: 180px; right: 30px; }
        .deco-circle.c2 { width: 120px; height: 120px; bottom: 240px; right: 90px; }

        .brand {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #fff;
            text-decoration: none;
            z-index: 1;
        }
        .brand-icon {
            width: 40px; height: 40px;
            background: rgba(255,255,255,0.15);
            border-radius: 12px;
            display: grid; place-items: center;
            font-size: 18px;
            backdrop-filter: blur(6px);
        }
        .brand-name {
            font-family: 'Playfair Display', serif;
            font-size: 22px;
            letter-spacing: 0.5px;
        }

        .panel-left-content { z-index: 1; }

        .panel-tagline {
            font-family: 'Playfair Display', serif;
            font-size: clamp(32px, 4vw, 52px);
            font-weight: 900;
            color: #fff;
            line-height: 1.15;
            margin-bottom: 20px;
        }
        .panel-tagline span { color: var(--blue-glow); }

        .panel-desc {
            color: rgba(255,255,255,0.72);
            font-size: 15px;
            font-weight: 300;
            line-height: 1.7;
            max-width: 340px;
        }

        .panel-features {
            display: flex;
            flex-direction: column;
            gap: 12px;
            z-index: 1;
        }
        .feature-pill {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 50px;
            padding: 10px 18px;
            color: #fff;
            font-size: 13px;
            font-weight: 500;
            width: fit-content;
        }
        .feature-pill i { color: var(--blue-glow); font-size: 14px; }

        /* ── RIGHT PANEL ── */
        .panel-right {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 48px 40px;
            position: relative;
            background: var(--cream);
        }

        .top-nav {
            position: absolute;
            top: 32px; right: 40px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .top-nav span { font-size: 14px; color: var(--text-muted); }
        .btn-register {
            background: transparent;
            border: 1.5px solid var(--blue-mid);
            color: var(--blue-mid);
            border-radius: 50px;
            padding: 8px 22px;
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-register:hover { background: var(--blue-mid); color: #fff; }

        .form-box {
            width: 100%;
            max-width: 420px;
            animation: fadeUp 0.5s ease both;
        }

        .form-header { margin-bottom: 36px; }
        .form-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 32px;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 8px;
        }
        .form-header p { color: var(--text-muted); font-size: 14px; }

        .alert {
            padding: 12px 16px;
            border-radius: 12px;
            font-size: 13.5px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-success { background: #eff8ff; color: #1a56db; border: 1px solid #bfdbfe; }
        .alert-danger  { background: #fff0f0; color: #b91c1c; border: 1px solid #fca5a5; }

        .form-group { margin-bottom: 20px; }
        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 8px;
            letter-spacing: 0.3px;
        }

        .input-wrap { position: relative; }
        .input-wrap i {
            position: absolute;
            left: 16px; top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 15px;
            pointer-events: none;
        }
        .input-wrap input {
            width: 100%;
            padding: 14px 16px 14px 44px;
            border: 1.5px solid var(--border);
            border-radius: 14px;
            font-family: 'DM Sans', sans-serif;
            font-size: 14.5px;
            color: var(--text-dark);
            background: #fff;
            transition: border-color 0.2s, box-shadow 0.2s;
            outline: none;
        }
        .input-wrap input::placeholder { color: #b0bdd4; }
        .input-wrap input:focus {
            border-color: var(--blue-mid);
            box-shadow: 0 0 0 4px rgba(26,86,219,0.08);
        }

        .row-between {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
        }
        .remember {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13.5px;
            color: var(--text-muted);
            cursor: pointer;
        }
        .remember input[type="checkbox"] { accent-color: var(--blue-mid); width: 15px; height: 15px; }
        .forgot { font-size: 13.5px; color: var(--blue-mid); text-decoration: none; font-weight: 500; }
        .forgot:hover { text-decoration: underline; }

        .btn-login {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, var(--blue-mid), var(--blue-dark));
            color: #fff;
            border: none;
            border-radius: 14px;
            font-family: 'DM Sans', sans-serif;
            font-size: 15.5px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            letter-spacing: 0.3px;
            transition: transform 0.15s, box-shadow 0.2s;
            box-shadow: 0 6px 24px rgba(26,86,219,0.3);
        }
        .btn-login:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 30px rgba(26,86,219,0.38);
        }
        .btn-login:active { transform: translateY(0); }

        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 24px 0;
            color: var(--text-muted);
            font-size: 13px;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--border);
        }

        .form-footer {
            text-align: center;
            font-size: 14px;
            color: var(--text-muted);
        }
        .form-footer a { color: var(--blue-mid); font-weight: 600; text-decoration: none; }
        .form-footer a:hover { text-decoration: underline; }
        .form-footer p + p { margin-top: 8px; }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(18px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .panel-left-content { animation: fadeUp 0.6s 0.1s ease both; }

        @media (max-width: 768px) {
            body { flex-direction: column; overflow: auto; }
            .panel-left { width: 100%; min-height: 220px; padding: 32px 28px; }
            .panel-tagline { font-size: 28px; }
            .panel-features { flex-direction: row; flex-wrap: wrap; }
            .panel-right { padding: 40px 24px; }
            .top-nav { top: 20px; right: 24px; }
        }
    </style>
</head>
<body>

    <!-- LEFT PANEL -->
    <div class="panel-left">
        <div class="deco-circle c1"></div>
        <div class="deco-circle c2"></div>

        <a href="index.jsp" class="brand">
            <div class="brand-icon"><i class="fas fa-heartbeat"></i></div>
            <span class="brand-name">Smart Health</span>
        </a>

        <div class="panel-left-content">
            <h2 class="panel-tagline">Your Health,<br>Our <span>Priority.</span></h2>
            <p class="panel-desc">Book appointments, view prescriptions, and connect with top doctors — all in one secure platform designed for you.</p>
        </div>

        <div class="panel-features">
            <div class="feature-pill"><i class="fas fa-calendar-check"></i> Easy Appointments</div>
            <div class="feature-pill"><i class="fas fa-file-medical"></i> Digital Records</div>
            <div class="feature-pill"><i class="fas fa-lock"></i> Private & Secure</div>
        </div>
    </div>

    <!-- RIGHT PANEL -->
    <div class="panel-right">

        <div class="top-nav">
            <span>No account?</span>
            <a href="userRegister.jsp" class="btn-register">Register</a>
        </div>

        <div class="form-box">
            <div class="form-header">
                <h1>Patient Sign In</h1>
                <p>Welcome back! Access your health dashboard below.</p>
            </div>

            <%
                String success = request.getParameter("success");
                String error   = request.getParameter("error");
                if (success != null) {
            %>
                <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= success %></div>
            <% } if (error != null) { %>
                <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> <%= error %></div>
            <% } %>

            <form action="UserLoginServlet" method="post">
                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <div class="input-wrap">
                        <i class="fas fa-envelope"></i>
                        <input type="email" name="email" placeholder="patient@email.com" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Password</label>
                    <div class="input-wrap">
                        <i class="fas fa-lock"></i>
                        <input type="password" name="password" placeholder="Enter your password" required>
                    </div>
                </div>

                <div class="row-between">
                    <label class="remember">
                        <input type="checkbox"> Remember me
                    </label>
                    <a href="#" class="forgot">Forgot password?</a>
                </div>

                <button type="submit" class="btn-login">
                    Sign In <i class="fas fa-arrow-right"></i>
                </button>
            </form>

            <div class="divider">or</div>

            <div class="form-footer">
                <p>Don't have an account? <a href="userRegister.jsp">Register here</a></p>
                <p><a href="doctorLogin.jsp">Login as Doctor instead</a></p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
