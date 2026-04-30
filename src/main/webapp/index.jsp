<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Smart Health - Home</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=Fraunces:wght@700;900&display=swap" rel="stylesheet">

<style>
/* ── RESET & BASE ── */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

:root {
  --indigo:   #5c6bc0;
  --violet:   #7c3aed;
  --emerald:  #10b981;
  --glass:    rgba(255,255,255,0.08);
  --glass-b:  rgba(255,255,255,0.18);
  --dark:     #0d0d1a;
  --card-bg:  #ffffff;
}

html { scroll-behavior: smooth; }

body {
  font-family: 'DM Sans', sans-serif;
  background: var(--dark);
  color: #fff;
  overflow-x: hidden;
}

/* ── ANIMATED BACKGROUND CANVAS ── */
#bg-canvas {
  position: fixed;
  inset: 0;
  z-index: 0;
  pointer-events: none;
}

/* ── NAVBAR ── */
.navbar {
  position: fixed;
  top: 0; left: 0; right: 0;
  z-index: 100;
  padding: 18px 0;
  backdrop-filter: blur(16px);
  background: rgba(13,13,26,0.6);
  border-bottom: 1px solid rgba(255,255,255,0.06);
  transition: background 0.4s;
}

.navbar-brand {
  font-family: 'Fraunces', serif;
  font-weight: 900;
  font-size: 1.5rem;
  color: #fff !important;
  letter-spacing: -0.5px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.brand-icon {
  width: 36px; height: 36px;
  background: linear-gradient(135deg, var(--indigo), var(--violet));
  border-radius: 10px;
  display: grid; place-items: center;
  font-size: 1rem;
  box-shadow: 0 4px 14px rgba(124,58,237,0.5);
}

.nav-link {
  color: rgba(255,255,255,0.75) !important;
  font-weight: 500;
  font-size: 0.9rem;
  padding: 8px 16px !important;
  border-radius: 8px;
  transition: all 0.25s;
}

.nav-link:hover, .nav-link:focus {
  color: #fff !important;
  background: var(--glass);
}

.dropdown-menu {
  background: rgba(20,20,40,0.96);
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 14px;
  padding: 8px;
  backdrop-filter: blur(20px);
  box-shadow: 0 20px 50px rgba(0,0,0,0.4);
}

.dropdown-item {
  color: rgba(255,255,255,0.8);
  border-radius: 8px;
  padding: 9px 14px;
  font-size: 0.88rem;
  font-weight: 500;
  transition: all 0.2s;
}

.dropdown-item:hover {
  background: rgba(255,255,255,0.08);
  color: #fff;
}

/* ── HERO ── */
.hero-section {
  position: relative;
  z-index: 1;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 120px 20px 80px;
  overflow: hidden;
}

.hero-section::before {
  content: '';
  position: absolute;
  inset: 0;
  background:
    radial-gradient(ellipse 80% 60% at 50% 20%, rgba(92,107,192,0.25) 0%, transparent 70%),
    radial-gradient(ellipse 60% 40% at 80% 80%, rgba(124,58,237,0.18) 0%, transparent 60%);
  pointer-events: none;
}

/* Floating orbs */
.orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(60px);
  opacity: 0.35;
  animation: orb-float 8s ease-in-out infinite;
}
.orb-1 {
  width: 350px; height: 350px;
  background: var(--indigo);
  top: 10%; left: -8%;
  animation-delay: 0s;
}
.orb-2 {
  width: 250px; height: 250px;
  background: var(--violet);
  bottom: 15%; right: -5%;
  animation-delay: -3s;
}
.orb-3 {
  width: 180px; height: 180px;
  background: var(--emerald);
  top: 55%; left: 60%;
  animation-delay: -5s;
}

@keyframes orb-float {
  0%, 100% { transform: translateY(0) scale(1); }
  50%       { transform: translateY(-28px) scale(1.05); }
}

.hero-tag {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: rgba(255,255,255,0.08);
  border: 1px solid rgba(255,255,255,0.14);
  border-radius: 100px;
  padding: 7px 18px;
  font-size: 0.8rem;
  font-weight: 600;
  letter-spacing: 0.5px;
  color: rgba(255,255,255,0.8);
  margin-bottom: 28px;
  animation: fadeUp 0.8s ease both;
  animation-delay: 0.1s;
}

.hero-tag .dot {
  width: 7px; height: 7px;
  background: var(--emerald);
  border-radius: 50%;
  box-shadow: 0 0 0 3px rgba(16,185,129,0.3);
  animation: pulse-dot 2s ease-in-out infinite;
}

@keyframes pulse-dot {
  0%, 100% { box-shadow: 0 0 0 3px rgba(16,185,129,0.3); }
  50%       { box-shadow: 0 0 0 6px rgba(16,185,129,0.1); }
}

.hero-title {
  font-family: 'Fraunces', serif;
  font-weight: 900;
  font-size: clamp(2.4rem, 6vw, 4.2rem);
  line-height: 1.1;
  letter-spacing: -1.5px;
  margin-bottom: 22px;
  animation: fadeUp 0.9s ease both;
  animation-delay: 0.2s;
}

.hero-title .accent {
  background: linear-gradient(135deg, #a78bfa, #60a5fa);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.hero-sub {
  font-size: 1.05rem;
  color: rgba(255,255,255,0.55);
  max-width: 520px;
  margin: 0 auto 42px;
  line-height: 1.7;
  font-weight: 400;
  animation: fadeUp 1s ease both;
  animation-delay: 0.35s;
}

.hero-buttons {
  display: flex;
  justify-content: center;
  gap: 14px;
  flex-wrap: wrap;
  animation: fadeUp 1.1s ease both;
  animation-delay: 0.5s;
}

.btn-primary-hero {
  display: inline-flex;
  align-items: center;
  gap: 9px;
  background: linear-gradient(135deg, var(--indigo), var(--violet));
  color: #fff;
  border: none;
  padding: 14px 30px;
  border-radius: 14px;
  font-weight: 600;
  font-size: 0.95rem;
  font-family: 'DM Sans', sans-serif;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.34,1.56,0.64,1);
  box-shadow: 0 8px 30px rgba(124,58,237,0.4);
  text-decoration: none;
}

.btn-primary-hero:hover {
  transform: translateY(-4px) scale(1.03);
  box-shadow: 0 16px 40px rgba(124,58,237,0.55);
  color: #fff;
}

.btn-ghost-hero {
  display: inline-flex;
  align-items: center;
  gap: 9px;
  background: rgba(255,255,255,0.06);
  color: rgba(255,255,255,0.85);
  border: 1px solid rgba(255,255,255,0.15);
  padding: 14px 30px;
  border-radius: 14px;
  font-weight: 600;
  font-size: 0.95rem;
  font-family: 'DM Sans', sans-serif;
  cursor: pointer;
  transition: all 0.3s;
  text-decoration: none;
}

.btn-ghost-hero:hover {
  background: rgba(255,255,255,0.12);
  border-color: rgba(255,255,255,0.3);
  color: #fff;
  transform: translateY(-3px);
}

/* ── HERO STATS ── */
.hero-stats {
  display: flex;
  justify-content: center;
  gap: 40px;
  flex-wrap: wrap;
  margin-top: 60px;
  animation: fadeUp 1.2s ease both;
  animation-delay: 0.65s;
}

.stat-item {
  text-align: center;
}

.stat-num {
  font-family: 'Fraunces', serif;
  font-weight: 900;
  font-size: 2rem;
  color: #fff;
  line-height: 1;
}

.stat-label {
  font-size: 0.78rem;
  color: rgba(255,255,255,0.4);
  margin-top: 4px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.8px;
}

/* ── SERVICES ── */
.services-section {
  position: relative;
  z-index: 1;
  padding: 100px 0;
  background: rgba(255,255,255,0.02);
  border-top: 1px solid rgba(255,255,255,0.06);
}

.section-label {
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 2px;
  text-transform: uppercase;
  color: #a78bfa;
  margin-bottom: 12px;
}

.section-title {
  font-family: 'Fraunces', serif;
  font-weight: 900;
  font-size: clamp(1.8rem, 4vw, 2.8rem);
  letter-spacing: -1px;
  color: #fff;
}

.service-card {
  background: rgba(255,255,255,0.04);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: 24px;
  padding: 36px 28px;
  transition: all 0.4s cubic-bezier(0.34,1.56,0.64,1);
  position: relative;
  overflow: hidden;
}

.service-card::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: 24px;
  background: linear-gradient(135deg, var(--c1, #5c6bc0), var(--c2, #7c3aed));
  opacity: 0;
  transition: opacity 0.4s;
}

.service-card:hover {
  transform: translateY(-10px);
  border-color: transparent;
  box-shadow: 0 24px 60px rgba(0,0,0,0.3);
}

.service-card:hover::before { opacity: 1; }

.service-card > * { position: relative; z-index: 1; }

.service-icon-wrap {
  width: 60px; height: 60px;
  border-radius: 16px;
  display: grid; place-items: center;
  font-size: 1.5rem;
  margin-bottom: 20px;
  transition: transform 0.4s;
}

.service-card:hover .service-icon-wrap { transform: scale(1.15) rotate(-6deg); }

.s1 .service-icon-wrap { background: rgba(92,107,192,0.2); color: #a5b4fc; }
.s2 .service-icon-wrap { background: rgba(16,185,129,0.2); color: #6ee7b7; }
.s3 .service-icon-wrap { background: rgba(245,158,11,0.2); color: #fcd34d; }

.service-card:hover .service-icon-wrap { background: rgba(255,255,255,0.15); color: #fff; }

.service-title {
  font-weight: 700;
  font-size: 1.1rem;
  margin-bottom: 8px;
  color: #fff;
}

.service-desc {
  font-size: 0.88rem;
  color: rgba(255,255,255,0.5);
  line-height: 1.6;
}

.service-card:hover .service-desc { color: rgba(255,255,255,0.8); }

/* ── FOOTER ── */
footer {
  position: relative;
  z-index: 1;
  text-align: center;
  padding: 30px 20px;
  border-top: 1px solid rgba(255,255,255,0.06);
  color: rgba(255,255,255,0.3);
  font-size: 0.82rem;
}

/* ── ANIMATIONS ── */
@keyframes fadeUp {
  from { opacity: 0; transform: translateY(30px); }
  to   { opacity: 1; transform: translateY(0); }
}

/* ── GET STARTED MODAL ── */
.modal-backdrop.show { backdrop-filter: blur(6px); }

#getStartedModal .modal-dialog {
  max-width: 520px;
}

#getStartedModal .modal-content {
  background: #0f0f1e;
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 28px;
  overflow: hidden;
  box-shadow: 0 40px 100px rgba(0,0,0,0.7);
}

/* Modal entrance */
#getStartedModal.fade .modal-dialog {
  transform: scale(0.88) translateY(20px);
  transition: transform 0.4s cubic-bezier(0.34,1.56,0.64,1), opacity 0.35s ease;
}

#getStartedModal.show .modal-dialog {
  transform: scale(1) translateY(0);
}

/* Modal header */
.gs-modal-header {
  position: relative;
  padding: 36px 32px 0;
  text-align: center;
  overflow: hidden;
}

.gs-modal-header::before {
  content: '';
  position: absolute;
  width: 300px; height: 300px;
  background: radial-gradient(circle, rgba(124,58,237,0.25) 0%, transparent 70%);
  top: -80px; left: 50%;
  transform: translateX(-50%);
  pointer-events: none;
}

.gs-modal-close {
  position: absolute;
  top: 18px; right: 18px;
  width: 34px; height: 34px;
  background: rgba(255,255,255,0.07);
  border: none;
  border-radius: 50%;
  color: rgba(255,255,255,0.6);
  cursor: pointer;
  display: grid; place-items: center;
  transition: all 0.2s;
  font-size: 0.85rem;
}

.gs-modal-close:hover {
  background: rgba(255,255,255,0.15);
  color: #fff;
  transform: rotate(90deg);
}

.gs-modal-logo {
  width: 60px; height: 60px;
  background: linear-gradient(135deg, var(--indigo), var(--violet));
  border-radius: 18px;
  display: grid; place-items: center;
  margin: 0 auto 16px;
  font-size: 1.5rem;
  box-shadow: 0 8px 30px rgba(124,58,237,0.5);
  animation: logo-pop 0.6s cubic-bezier(0.34,1.56,0.64,1) both;
  animation-delay: 0.1s;
}

@keyframes logo-pop {
  from { transform: scale(0.5) rotate(-10deg); opacity: 0; }
  to   { transform: scale(1) rotate(0deg); opacity: 1; }
}

.gs-modal-title {
  font-family: 'Fraunces', serif;
  font-weight: 900;
  font-size: 1.55rem;
  color: #fff;
  letter-spacing: -0.5px;
  margin-bottom: 6px;
  animation: fadeUp 0.5s ease both;
  animation-delay: 0.2s;
}

.gs-modal-sub {
  font-size: 0.85rem;
  color: rgba(255,255,255,0.4);
  margin-bottom: 28px;
  animation: fadeUp 0.5s ease both;
  animation-delay: 0.3s;
}

/* Modal body */
.gs-modal-body {
  padding: 0 28px 32px;
}

/* Role cards */
.gs-cards {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 14px;
  margin-bottom: 22px;
}

.gs-role-card {
  display: block;
  text-decoration: none;
  border-radius: 20px;
  padding: 26px 16px;
  text-align: center;
  position: relative;
  overflow: hidden;
  border: 1.5px solid rgba(255,255,255,0.07);
  background: rgba(255,255,255,0.03);
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.34,1.56,0.64,1);
  animation: fadeUp 0.5s ease both;
}

.gs-role-card.patient { animation-delay: 0.35s; }
.gs-role-card.doctor  { animation-delay: 0.45s; }

.gs-role-card::after {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: 20px;
  opacity: 0;
  transition: opacity 0.35s;
}

.gs-role-card.patient::after {
  background: linear-gradient(135deg, rgba(92,107,192,0.25), rgba(124,58,237,0.25));
}

.gs-role-card.doctor::after {
  background: linear-gradient(135deg, rgba(16,185,129,0.25), rgba(52,211,153,0.18));
}

.gs-role-card:hover {
  transform: translateY(-6px) scale(1.02);
  border-color: transparent;
}

.gs-role-card.patient:hover { box-shadow: 0 16px 40px rgba(92,107,192,0.35); }
.gs-role-card.doctor:hover  { box-shadow: 0 16px 40px rgba(16,185,129,0.3); }

.gs-role-card:hover::after { opacity: 1; }

.gs-role-card > * { position: relative; z-index: 1; }

.gs-icon-ring {
  width: 64px; height: 64px;
  border-radius: 50%;
  display: grid; place-items: center;
  margin: 0 auto 14px;
  font-size: 1.5rem;
  transition: transform 0.4s cubic-bezier(0.34,1.56,0.64,1);
}

.gs-role-card:hover .gs-icon-ring { transform: scale(1.18) rotate(-8deg); }

.patient .gs-icon-ring {
  background: linear-gradient(135deg, #5c6bc0, #7c3aed);
  box-shadow: 0 6px 20px rgba(92,107,192,0.45);
  color: #fff;
}

.doctor .gs-icon-ring {
  background: linear-gradient(135deg, #10b981, #34d399);
  box-shadow: 0 6px 20px rgba(16,185,129,0.45);
  color: #fff;
}

.gs-role-name {
  font-weight: 700;
  font-size: 1rem;
  color: #fff;
  margin-bottom: 5px;
}

.gs-role-desc {
  font-size: 0.76rem;
  color: rgba(255,255,255,0.4);
  line-height: 1.45;
}

.gs-role-pill {
  display: inline-block;
  margin-top: 12px;
  padding: 4px 14px;
  border-radius: 30px;
  font-size: 0.72rem;
  font-weight: 700;
  letter-spacing: 0.3px;
  transition: all 0.3s;
}

.patient .gs-role-pill { background: rgba(92,107,192,0.2); color: #a5b4fc; }
.doctor  .gs-role-pill { background: rgba(16,185,129,0.2); color: #6ee7b7; }

.gs-role-card:hover .gs-role-pill { transform: scale(1.08); }

/* Divider */
.gs-divider {
  display: flex;
  align-items: center;
  gap: 12px;
  margin: 4px 0 16px;
  color: rgba(255,255,255,0.2);
  font-size: 0.75rem;
  font-weight: 500;
}

.gs-divider::before, .gs-divider::after {
  content: '';
  flex: 1;
  height: 1px;
  background: rgba(255,255,255,0.07);
}

.gs-login-row {
  display: flex;
  justify-content: center;
  gap: 6px;
  animation: fadeUp 0.5s ease both;
  animation-delay: 0.55s;
}

.gs-login-btn {
  flex: 1;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 7px;
  padding: 11px 16px;
  border-radius: 12px;
  font-size: 0.82rem;
  font-weight: 600;
  font-family: 'DM Sans', sans-serif;
  text-decoration: none;
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.08);
  color: rgba(255,255,255,0.6);
  transition: all 0.25s;
}

.gs-login-btn:hover {
  background: rgba(255,255,255,0.1);
  border-color: rgba(255,255,255,0.18);
  color: #fff;
  transform: translateY(-2px);
}

/* ── PARTICLE DOTS ON MODAL ── */
.modal-particle {
  position: absolute;
  width: 4px; height: 4px;
  border-radius: 50%;
  pointer-events: none;
  animation: float-particle 5s ease-in-out infinite;
}

@keyframes float-particle {
  0%, 100% { transform: translateY(0) rotate(0deg); opacity: 0.6; }
  50%       { transform: translateY(-20px) rotate(180deg); opacity: 0.2; }
}
</style>
</head>

<body>

<!-- ── BACKGROUND CANVAS ── -->
<canvas id="bg-canvas"></canvas>

<!-- ── NAVBAR ── -->
<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container">
    <a class="navbar-brand" href="index.jsp">
      <span class="brand-icon"><i class="fas fa-heartbeat"></i></span>
      Smart Health
    </a>

    <button class="navbar-toggler border-0" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto align-items-center gap-1">
        <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>

        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#">Patient</a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="userLogin.jsp"><i class="fas fa-sign-in-alt me-2 text-indigo"></i>Login</a></li>
            <li><a class="dropdown-item" href="userRegister.jsp"><i class="fas fa-user-plus me-2 text-indigo"></i>Register</a></li>
          </ul>
        </li>

        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#">Doctor</a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="doctorLogin.jsp"><i class="fas fa-sign-in-alt me-2"></i>Login</a></li>
            <li><a class="dropdown-item" href="doctorRegister.jsp"><i class="fas fa-user-md me-2"></i>Register</a></li>
          </ul>
        </li>
      </ul>
    </div>
  </div>
</nav>

<!-- ── HERO ── -->
<section class="hero-section">
  <div class="orb orb-1"></div>
  <div class="orb orb-2"></div>
  <div class="orb orb-3"></div>

  <div class="container position-relative">
    <div class="hero-tag">
      <span class="dot"></span>
      AI-Powered Healthcare Platform
    </div>

    <h1 class="hero-title">
      Your Health,<br>
      <span class="accent">Smarter Than Ever</span>
    </h1>

    <p class="hero-sub">
      AI-driven disease predictions, seamless appointments, and secure payments — all in one intelligent platform.
    </p>

    <div class="hero-buttons">
      <!-- Triggers the Get Started modal -->
      <button class="btn-primary-hero" data-bs-toggle="modal" data-bs-target="#getStartedModal">
        <i class="fas fa-user-plus"></i> Get Started
      </button>
      <a href="userLogin.jsp" class="btn-ghost-hero">
        <i class="fas fa-sign-in-alt"></i> Sign In
      </a>
    </div>

    <div class="hero-stats">
      <div class="stat-item">
        <div class="stat-num">12k+</div>
        <div class="stat-label">Patients</div>
      </div>
      <div class="stat-item">
        <div class="stat-num">800+</div>
        <div class="stat-label">Doctors</div>
      </div>
      <div class="stat-item">
        <div class="stat-num">98%</div>
        <div class="stat-label">Accuracy</div>
      </div>
      <div class="stat-item">
        <div class="stat-num">24/7</div>
        <div class="stat-label">Support</div>
      </div>
    </div>
  </div>
</section>

<!-- ── SERVICES ── -->
<section class="services-section">
  <div class="container">
    <div class="text-center mb-5">
      <div class="section-label">What We Offer</div>
      <h2 class="section-title">Everything You Need</h2>
    </div>

    <div class="row g-4">
      <div class="col-md-4">
        <div class="service-card s1" style="--c1:#4338ca;--c2:#6d28d9">
          <div class="service-icon-wrap"><i class="fas fa-calendar-check"></i></div>
          <div class="service-title">Book Appointments</div>
          <p class="service-desc">Schedule consultations with specialist doctors in just a few taps.</p>
        </div>
      </div>

      <div class="col-md-4">
        <div class="service-card s2" style="--c1:#047857;--c2:#059669">
          <div class="service-icon-wrap"><i class="fas fa-brain"></i></div>
          <div class="service-title">Disease Prediction</div>
          <p class="service-desc">Get AI-powered health insights based on your symptoms — instantly.</p>
        </div>
      </div>

      <div class="col-md-4">
        <div class="service-card s3" style="--c1:#b45309;--c2:#d97706">
          <div class="service-icon-wrap"><i class="fas fa-shield-alt"></i></div>
          <div class="service-title">Secure Payments</div>
          <p class="service-desc">Fast, encrypted online payments so you can focus on healing.</p>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ── FOOTER ── -->
<footer>&copy; 2025 Smart Health System — All Rights Reserved</footer>


<!-- ══════════════════════════════
     GET STARTED MODAL
══════════════════════════════ -->
<div class="modal fade" id="getStartedModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content position-relative">

      <!-- Floating particles -->
      <span class="modal-particle" style="top:12%;left:8%;background:#a78bfa;animation-delay:0s"></span>
      <span class="modal-particle" style="top:70%;left:92%;background:#6ee7b7;animation-delay:-1.5s"></span>
      <span class="modal-particle" style="top:85%;left:15%;background:#93c5fd;animation-delay:-3s;width:6px;height:6px"></span>

      <!-- Header -->
      <div class="gs-modal-header">
        <button class="gs-modal-close" data-bs-dismiss="modal">
          <i class="fas fa-times"></i>
        </button>

        <div class="gs-modal-logo">
          <i class="fas fa-heartbeat"></i>
        </div>

        <div class="gs-modal-title">Welcome to Smart Health</div>
        <p class="gs-modal-sub">Choose how you'd like to get started</p>
      </div>

      <!-- Body -->
      <div class="gs-modal-body">
        <div class="gs-cards">

          <!-- Patient -->
          <a href="userRegister.jsp" class="gs-role-card patient">
            <div class="gs-icon-ring"><i class="fas fa-user-injured"></i></div>
            <div class="gs-role-name">Patient</div>
            <div class="gs-role-desc">Book appointments & AI health checks</div>
            <span class="gs-role-pill">Register &rarr;</span>
          </a>

          <!-- Doctor -->
          <a href="doctorRegister.jsp" class="gs-role-card doctor">
            <div class="gs-icon-ring"><i class="fas fa-user-md"></i></div>
            <div class="gs-role-name">Doctor</div>
            <div class="gs-role-desc">Manage patients & appointments online</div>
            <span class="gs-role-pill">Register &rarr;</span>
          </a>

        </div>

        <!-- Login links -->
        <div class="gs-divider">already have an account?</div>
        <div class="gs-login-row">
          <a href="userLogin.jsp" class="gs-login-btn">
            <i class="fas fa-user"></i> Patient Login
          </a>
          <a href="doctorLogin.jsp" class="gs-login-btn">
            <i class="fas fa-stethoscope"></i> Doctor Login
          </a>
        </div>
      </div>

    </div>
  </div>
</div>


<!-- ── SCRIPTS ── -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
/* ── Animated starfield / particle canvas ── */
(function () {
  const canvas = document.getElementById('bg-canvas');
  const ctx    = canvas.getContext('2d');
  let W, H, dots = [];

  function resize() {
    W = canvas.width  = window.innerWidth;
    H = canvas.height = window.innerHeight;
  }

  function initDots(n) {
    dots = [];
    for (let i = 0; i < n; i++) {
      dots.push({
        x:   Math.random() * W,
        y:   Math.random() * H,
        r:   Math.random() * 1.4 + 0.4,
        dx:  (Math.random() - 0.5) * 0.18,
        dy:  (Math.random() - 0.5) * 0.18,
        a:   Math.random()
      });
    }
  }

  function draw() {
    ctx.clearRect(0, 0, W, H);

    dots.forEach(d => {
      ctx.beginPath();
      ctx.arc(d.x, d.y, d.r, 0, Math.PI * 2);
      ctx.fillStyle = `rgba(167,139,250,${d.a * 0.55})`;
      ctx.fill();

      d.x += d.dx; d.y += d.dy;
      if (d.x < 0) d.x = W;
      if (d.x > W) d.x = 0;
      if (d.y < 0) d.y = H;
      if (d.y > H) d.y = 0;
    });

    /* connection lines */
    for (let i = 0; i < dots.length; i++) {
      for (let j = i + 1; j < dots.length; j++) {
        const dx = dots[i].x - dots[j].x;
        const dy = dots[i].y - dots[j].y;
        const dist = Math.sqrt(dx*dx + dy*dy);
        if (dist < 110) {
          ctx.beginPath();
          ctx.moveTo(dots[i].x, dots[i].y);
          ctx.lineTo(dots[j].x, dots[j].y);
          ctx.strokeStyle = `rgba(167,139,250,${0.08 * (1 - dist/110)})`;
          ctx.lineWidth = 0.8;
          ctx.stroke();
        }
      }
    }

    requestAnimationFrame(draw);
  }

  resize();
  initDots(90);
  draw();
  window.addEventListener('resize', () => { resize(); initDots(90); });
})();

/* ── Navbar scroll effect ── */
window.addEventListener('scroll', () => {
  const nav = document.querySelector('.navbar');
  nav.style.background = window.scrollY > 40
    ? 'rgba(13,13,26,0.92)'
    : 'rgba(13,13,26,0.6)';
});

/* ── Scroll-reveal for service cards ── */
(function () {
  const cards = document.querySelectorAll('.service-card');
  const obs = new IntersectionObserver((entries) => {
    entries.forEach((e, i) => {
      if (e.isIntersecting) {
        setTimeout(() => {
          e.target.style.animation = 'fadeUp 0.7s ease both';
        }, i * 120);
        obs.unobserve(e.target);
      }
    });
  }, { threshold: 0.15 });

  cards.forEach(c => {
    c.style.opacity = '0';
    obs.observe(c);
  });
})();

/* ── Counter animation for stats ── */
(function () {
  const stats = [
    { el: document.querySelectorAll('.stat-num')[0], end: 12000, suffix: 'k+', div: 1000 },
    { el: document.querySelectorAll('.stat-num')[1], end: 800,   suffix: '+', div: 1 },
    { el: document.querySelectorAll('.stat-num')[2], end: 98,    suffix: '%', div: 1 },
  ];

  const obs = new IntersectionObserver((entries) => {
    entries.forEach(e => {
      if (!e.isIntersecting) return;
      stats.forEach(s => {
        if (!s.el) return;
        let cur = 0;
        const step = s.end / 60;
        const timer = setInterval(() => {
          cur = Math.min(cur + step, s.end);
          if (s.div > 1)
            s.el.textContent = (cur / s.div).toFixed(0) + s.suffix;
          else
            s.el.textContent = Math.round(cur) + s.suffix;
          if (cur >= s.end) clearInterval(timer);
        }, 20);
      });
      obs.disconnect();
    });
  }, { threshold: 0.5 });

  const statsSection = document.querySelector('.hero-stats');
  if (statsSection) obs.observe(statsSection);
})();
</script>

</body>
</html>
