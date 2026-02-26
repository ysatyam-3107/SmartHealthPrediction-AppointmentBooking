<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Get Started Modal Demo</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<style>
  @import url('https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&display=swap');

  * { font-family: 'Sora', sans-serif; }

  body {
    background: linear-gradient(135deg, #667eea, #764ba2);
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  /* ---- MODAL STYLING ---- */
  .modal-content {
    border: none;
    border-radius: 24px;
    overflow: hidden;
    box-shadow: 0 30px 80px rgba(0,0,0,0.35);
  }

  .modal-header {
    background: linear-gradient(135deg, #667eea, #764ba2);
    color: white;
    border: none;
    padding: 28px 32px 20px;
  }

  .modal-header .modal-title {
    font-weight: 700;
    font-size: 1.4rem;
  }

  .modal-header .btn-close {
    filter: invert(1);
    opacity: 0.8;
  }

  .modal-body {
    padding: 36px 32px 40px;
    background: #fafbff;
  }

  .modal-subtitle {
    text-align: center;
    color: #666;
    margin-bottom: 28px;
    font-size: 0.95rem;
  }

  /* ---- ROLE CARDS ---- */
  .role-card {
    border: 2.5px solid #e0e4f0;
    border-radius: 20px;
    padding: 32px 20px;
    text-align: center;
    cursor: pointer;
    transition: all 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
    background: white;
    text-decoration: none;
    color: inherit;
    display: block;
    position: relative;
    overflow: hidden;
  }

  .role-card::before {
    content: '';
    position: absolute;
    inset: 0;
    opacity: 0;
    transition: opacity 0.3s;
    border-radius: 18px;
  }

  .role-card.patient::before {
    background: linear-gradient(135deg, rgba(102,126,234,0.08), rgba(118,75,162,0.08));
  }

  .role-card.doctor::before {
    background: linear-gradient(135deg, rgba(17,153,142,0.08), rgba(56,239,125,0.08));
  }

  .role-card:hover {
    transform: translateY(-8px) scale(1.02);
    box-shadow: 0 20px 50px rgba(0,0,0,0.12);
  }

  .role-card.patient:hover {
    border-color: #667eea;
  }

  .role-card.doctor:hover {
    border-color: #11998e;
  }

  .role-card:hover::before {
    opacity: 1;
  }

  .role-icon-wrap {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 18px;
    font-size: 2rem;
    transition: transform 0.3s;
  }

  .role-card:hover .role-icon-wrap {
    transform: scale(1.15) rotate(-5deg);
  }

  .patient .role-icon-wrap {
    background: linear-gradient(135deg, #667eea, #764ba2);
    color: white;
  }

  .doctor .role-icon-wrap {
    background: linear-gradient(135deg, #11998e, #38ef7d);
    color: white;
  }

  .role-title {
    font-weight: 700;
    font-size: 1.2rem;
    margin-bottom: 8px;
    color: #1a1a2e;
  }

  .role-desc {
    font-size: 0.82rem;
    color: #888;
    line-height: 1.5;
  }

  .role-badge {
    display: inline-block;
    margin-top: 14px;
    padding: 5px 16px;
    border-radius: 30px;
    font-size: 0.78rem;
    font-weight: 600;
    letter-spacing: 0.5px;
    transition: 0.3s;
  }

  .patient .role-badge {
    background: #eef0ff;
    color: #667eea;
  }

  .doctor .role-badge {
    background: #e6faf2;
    color: #11998e;
  }

  .role-card:hover .role-badge {
    transform: scale(1.08);
  }

  /* ---- DEMO BUTTON ---- */
  .demo-btn {
    padding: 14px 36px;
    border-radius: 30px;
    font-weight: 600;
    background: white;
    color: #764ba2;
    border: none;
    font-size: 1rem;
    font-family: 'Sora', sans-serif;
    transition: 0.3s;
    box-shadow: 0 4px 20px rgba(0,0,0,0.15);
  }

  .demo-btn:hover {
    transform: translateY(-3px);
    box-shadow: 0 12px 30px rgba(255,255,255,0.35);
    background: #f0e8ff;
  }

  .divider-text {
    text-align: center;
    color: #aaa;
    font-size: 0.8rem;
    position: relative;
    margin: 20px 0 8px;
  }

  .divider-text::before, .divider-text::after {
    content: '';
    position: absolute;
    top: 50%;
    width: 38%;
    height: 1px;
    background: #e0e4f0;
  }
  .divider-text::before { left: 0; }
  .divider-text::after { right: 0; }

  .login-links {
    text-align: center;
    font-size: 0.83rem;
    color: #888;
  }

  .login-links a {
    color: #667eea;
    text-decoration: none;
    font-weight: 600;
  }

  .login-links a:hover { text-decoration: underline; }
</style>
</head>
<body>

<!-- Demo trigger button (this represents your hero section button) -->
<button class="demo-btn" data-bs-toggle="modal" data-bs-target="#getStartedModal">
  <i class="fas fa-user-plus me-2"></i> Get Started
</button>

<!-- ===================== MODAL ===================== -->
<div class="modal fade" id="getStartedModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">

      <!-- Header -->
      <div class="modal-header">
        <h5 class="modal-title">
          <i class="fas fa-heartbeat me-2"></i> Welcome to Smart Health
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <!-- Body -->
      <div class="modal-body">
        <p class="modal-subtitle">How would you like to continue?</p>

        <div class="row g-3">

          <!-- Patient Card -->
          <div class="col-6">
            <a href="userRegister.jsp" class="role-card patient">
              <div class="role-icon-wrap">
                <i class="fas fa-user-injured"></i>
              </div>
              <div class="role-title">Patient</div>
              <div class="role-desc">Book appointments & get AI health predictions</div>
              <span class="role-badge">Register →</span>
            </a>
          </div>

          <!-- Doctor Card -->
          <div class="col-6">
            <a href="doctorRegister.jsp" class="role-card doctor">
              <div class="role-icon-wrap">
                <i class="fas fa-user-md"></i>
              </div>
              <div class="role-title">Doctor</div>
              <div class="role-desc">Manage patients & handle appointments online</div>
              <span class="role-badge">Register →</span>
            </a>
          </div>

        </div>

        <!-- Already have account -->
        <div class="divider-text">already have an account?</div>
        <div class="login-links">
          <a href="userLogin.jsp"><i class="fas fa-user me-1"></i>Patient Login</a>
          &nbsp;&nbsp;|&nbsp;&nbsp;
          <a href="doctorLogin.jsp"><i class="fas fa-stethoscope me-1"></i>Doctor Login</a>
        </div>
      </div>

    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>