<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Registration – Smart Health</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --green-dark:   #0f5132;
            --green-mid:    #198754;
            --green-light:  #d1e7dd;
            --green-pale:   #f0faf5;
            --red-dark:     #842029;
            --red-light:    #f8d7da;
            --amber:        #ffc107;
            --radius:       12px;
            --shadow:       0 4px 24px rgba(0,0,0,.08);
        }

        *, *::before, *::after { box-sizing: border-box; }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: linear-gradient(135deg, #e8f5ee 0%, #f8fffe 50%, #e0f0ff 100%);
            min-height: 100vh;
            color: #1a1a1a;
        }

        /* ── Navbar ── */
        .navbar {
            background: var(--green-mid) !important;
            box-shadow: 0 2px 12px rgba(25,135,84,.3);
        }
        .navbar-brand { font-weight: 700; letter-spacing: -.3px; }
        .navbar-brand i { margin-right: 6px; }

        /* ── Card ── */
        .reg-card {
            border: none;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
        }
        .reg-card .card-header {
            background: linear-gradient(90deg, #0d6efd15, #19875415);
            border-bottom: 1px solid #dee2e6;
            padding: 1.4rem 1.8rem;
        }
        .reg-card .card-header h4 {
            font-weight: 700;
            color: var(--green-dark);
            margin: 0;
            font-size: 1.3rem;
        }
        .reg-card .card-body { padding: 2rem 2.2rem; }

        /* ── Section headings ── */
        .section-heading {
            font-size: .7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .1em;
            color: var(--green-mid);
            padding-bottom: 8px;
            border-bottom: 2px solid var(--green-light);
            margin-bottom: 1.2rem;
            margin-top: 2rem;
        }
        .section-heading:first-child { margin-top: 0; }

        /* ── Form controls ── */
        label.form-label {
            font-size: .82rem;
            font-weight: 600;
            color: #444;
            margin-bottom: 5px;
        }
        .form-control, .form-select {
            border-radius: 8px;
            border: 1.5px solid #dee2e6;
            font-size: .9rem;
            padding: .52rem .85rem;
            transition: border-color .2s, box-shadow .2s;
            background-color: #fff;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--green-mid);
            box-shadow: 0 0 0 3px rgba(25,135,84,.15);
            outline: none;
        }

        /* ── Validation states ── */
        .form-control.is-valid,
        .form-select.is-valid   { border-color: #198754 !important; background-image: none; }
        .form-control.is-invalid,
        .form-select.is-invalid { border-color: #dc3545 !important; background-image: none; box-shadow: 0 0 0 3px rgba(220,53,69,.12); }

        .field-feedback {
            font-size: .78rem;
            margin-top: 4px;
            min-height: 18px;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .field-feedback .icon { font-size: .75rem; }
        .field-feedback.valid-fb  { color: #146c43; }
        .field-feedback.invalid-fb { color: #b02a37; }
        .field-feedback.hidden    { visibility: hidden; }

        /* ── Photo preview ── */
        .photo-wrapper {
            display: flex;
            align-items: center;
            gap: 1.2rem;
            padding: 1rem 1.2rem;
            background: var(--green-pale);
            border-radius: 10px;
            border: 1.5px dashed #aedfc9;
            margin-bottom: 1.5rem;
        }
        .photo-circle {
            width: 80px; height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--green-mid);
            flex-shrink: 0;
        }
        .photo-meta { flex: 1; }
        .photo-meta .form-label { display: block; }
        .photo-meta small { color: #6c757d; font-size: .75rem; }

        /* ── Password ── */
        .password-wrapper { position: relative; }
        .toggle-pass {
            position: absolute; right: 12px; top: 50%;
            transform: translateY(-50%);
            border: none; background: none;
            color: #6c757d; cursor: pointer;
            font-size: .82rem; padding: 0;
            line-height: 1;
        }
        .toggle-pass:hover { color: var(--green-mid); }

        .strength-track {
            height: 4px;
            background: #e9ecef;
            border-radius: 4px;
            margin-top: 6px;
            overflow: hidden;
        }
        .strength-fill {
            height: 100%;
            width: 0;
            border-radius: 4px;
            transition: width .35s ease, background .35s ease;
        }
        .strength-label {
            font-size: .72rem;
            margin-top: 3px;
            font-weight: 600;
        }

        /* ── Days ── */
        .days-grid { display: flex; flex-wrap: wrap; gap: 8px; }
        .day-pill {
            padding: 5px 14px;
            border-radius: 20px;
            border: 1.5px solid #dee2e6;
            font-size: .82rem;
            font-weight: 600;
            cursor: pointer;
            transition: all .2s;
            background: #fff;
            color: #555;
            user-select: none;
        }
        .day-pill:hover { border-color: var(--green-mid); color: var(--green-mid); }
        .day-pill.active { background: var(--green-mid); border-color: var(--green-mid); color: #fff; }
        .day-pill.day-error { border-color: #dc3545 !important; }

        /* ── Slot badges ── */
        .slot-preview {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-top: 10px;
        }
        .slot-badge {
            font-size: .75rem;
            padding: 3px 10px;
            background: var(--green-pale);
            border: 1px solid #aedfc9;
            border-radius: 20px;
            color: var(--green-dark);
            font-weight: 500;
        }

        /* ── Info box ── */
        .info-box {
            background: #fff8e1;
            border-left: 4px solid var(--amber);
            border-radius: 0 8px 8px 0;
            padding: 10px 14px;
            font-size: .82rem;
            color: #5d4037;
            margin-bottom: 1rem;
        }

        /* ── Submit ── */
        .btn-register {
            background: linear-gradient(90deg, #157347, #198754);
            color: #fff;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 700;
            padding: .75rem;
            width: 100%;
            margin-top: 1.8rem;
            transition: transform .2s, box-shadow .2s;
            letter-spacing: .3px;
        }
        .btn-register:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(25,135,84,.35);
            color: #fff;
        }
        .btn-register:active { transform: scale(.98); }

        /* ── Toast ── */
        .form-toast {
            display: none;
            border-radius: 10px;
            padding: 12px 16px;
            font-size: .88rem;
            font-weight: 500;
            margin-top: 1rem;
            align-items: center;
            gap: 8px;
        }
        .form-toast.show { display: flex; }
        .form-toast.success { background: var(--green-light); color: var(--green-dark); border: 1px solid #a3cfbb; }
        .form-toast.error   { background: var(--red-light);   color: var(--red-dark);   border: 1px solid #f5c2c7; }

        /* ── Required star ── */
        .req { color: #dc3545; margin-left: 2px; }

        /* ── Alert from server ── */
        .server-alert { border-radius: 10px; font-size: .9rem; }

        @media (max-width: 576px) {
            .reg-card .card-body { padding: 1.2rem 1rem; }
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="index.jsp">
            <i class="fas fa-heartbeat"></i> Smart Health
        </a>
        <div class="ms-auto">
            <a href="doctorLogin.jsp" class="btn btn-outline-light btn-sm">
                <i class="fas fa-sign-in-alt me-1"></i> Login
            </a>
        </div>
    </div>
</nav>

<!-- Form -->
<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-10 col-lg-9">
            <div class="reg-card card">

                <div class="card-header d-flex align-items-center gap-2">
                    <i class="fas fa-user-md fa-lg text-success"></i>
                    <h4>Doctor Registration</h4>
                </div>

                <div class="card-body">

                    <!-- Server-side alerts -->
                    <%
                        String serverError   = request.getParameter("error");
                        String serverSuccess = request.getParameter("success");
                        if (serverError != null) {
                    %>
                        <div class="alert alert-danger alert-dismissible fade show server-alert">
                            <i class="fas fa-circle-exclamation me-2"></i><%= serverError %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <% } if (serverSuccess != null) { %>
                        <div class="alert alert-success alert-dismissible fade show server-alert">
                            <i class="fas fa-circle-check me-2"></i><%= serverSuccess %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <% } %>

                    <form action="DoctorRegisterServlet" method="post"
                          enctype="multipart/form-data" id="regForm" novalidate>

                        <!-- ═══ PERSONAL INFO ═══ -->
                        <div class="section-heading"><i class="fas fa-user me-2"></i>Personal Information</div>

                        <!-- Photo -->
                        <div class="photo-wrapper">
                            <img id="photoPreview"
                                 src="https://cdn-icons-png.flaticon.com/512/3870/3870822.png"
                                 class="photo-circle" alt="Preview">
                            <div class="photo-meta">
                                <label class="form-label">Profile Photo <span class="req">*</span></label>
                                <input type="file" class="form-control form-control-sm"
                                       id="profilePhoto" name="profilePhoto"
                                       accept="image/*" onchange="handlePhoto(event)">
                                <small>JPG / PNG / JPEG &nbsp;·&nbsp; Max 5 MB</small>
                                <div class="field-feedback hidden" id="photoFb"></div>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label" for="fullName">Full Name <span class="req">*</span></label>
                                <input type="text" class="form-control" id="fullName" name="fullName"
                                       placeholder="Dr. Jane Smith" autocomplete="name">
                                <div class="field-feedback hidden" id="fullNameFb"></div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" for="email">Email <span class="req">*</span></label>
                                <input type="email" class="form-control" id="email" name="email"
                                       placeholder="doctor@hospital.com" autocomplete="email">
                                <div class="field-feedback hidden" id="emailFb"></div>
                            </div>
                        </div>

                        <div class="row g-3 mb-2">
                            <div class="col-md-6">
                                <label class="form-label" for="password">Password <span class="req">*</span></label>
                                <div class="password-wrapper">
                                    <input type="password" class="form-control" id="password"
                                           name="password" placeholder="Min 8 characters"
                                           autocomplete="new-password">
                                    <button type="button" class="toggle-pass" onclick="togglePassword()">
                                        <i class="fas fa-eye" id="toggleIcon"></i>
                                    </button>
                                </div>
                                <div class="strength-track"><div class="strength-fill" id="strengthBar"></div></div>
                                <div class="strength-label" id="strengthLabel" style="color:#aaa">Strength</div>
                                <div class="field-feedback hidden" id="passwordFb"></div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" for="phone">Phone Number <span class="req">*</span></label>
                                <input type="tel" class="form-control" id="phone" name="phone"
                                       placeholder="10-digit number" maxlength="10"
                                       autocomplete="tel">
                                <div class="field-feedback hidden" id="phoneFb"></div>
                            </div>
                        </div>

                        <!-- ═══ PROFESSIONAL INFO ═══ -->
                        <div class="section-heading"><i class="fas fa-briefcase-medical me-2"></i>Professional Information</div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label" for="specialization">Specialization <span class="req">*</span></label>
                                <input class="form-control" list="specializations"
                                       id="specialization" name="specialization"
                                       placeholder="Type or select...">
                                <datalist id="specializations">
                                    <option value="Allergist / Immunologist">
                                    <option value="Anesthesiologist">
                                    <option value="Cardiologist">
                                    <option value="Cardiac Surgeon">
                                    <option value="Dermatologist">
                                    <option value="Endocrinologist">
                                    <option value="ENT Specialist (Otolaryngologist)">
                                    <option value="Gastroenterologist">
                                    <option value="General Physician">
                                    <option value="General Surgeon">
                                    <option value="Geriatrician">
                                    <option value="Gynecologist">
                                    <option value="Hematologist">
                                    <option value="Infectious Disease Specialist">
                                    <option value="Nephrologist">
                                    <option value="Neurologist">
                                    <option value="Neurosurgeon">
                                    <option value="Obstetrician">
                                    <option value="Oncologist">
                                    <option value="Ophthalmologist">
                                    <option value="Orthopedic Surgeon">
                                    <option value="Pediatrician">
                                    <option value="Pathologist">
                                    <option value="Plastic Surgeon">
                                    <option value="Psychiatrist">
                                    <option value="Pulmonologist">
                                    <option value="Radiologist">
                                    <option value="Rheumatologist">
                                    <option value="Urologist">
                                    <option value="Dentist">
                                </datalist>
                                <div class="field-feedback hidden" id="specializationFb"></div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" for="qualification">Qualification <span class="req">*</span></label>
                                <input type="text" class="form-control" id="qualification"
                                       name="qualification" placeholder="e.g., MBBS, MD">
                                <div class="field-feedback hidden" id="qualificationFb"></div>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label" for="hospitalName">Hospital / Clinic Name <span class="req">*</span></label>
                                <input type="text" class="form-control" id="hospitalName"
                                       name="hospitalName" placeholder="e.g., Apollo Hospital">
                                <div class="field-feedback hidden" id="hospitalNameFb"></div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" for="location">Location <span class="req">*</span></label>
                                <input type="text" class="form-control" id="location"
                                       name="location" placeholder="e.g., Pune, Maharashtra">
                                <div class="field-feedback hidden" id="locationFb"></div>
                            </div>
                        </div>

                        <div class="row g-3 mb-2">
                            <div class="col-md-4">
                                <label class="form-label" for="experience">Experience (Years) <span class="req">*</span></label>
                                <input type="number" class="form-control" id="experience"
                                       name="experience" min="0" max="70" placeholder="e.g., 5">
                                <div class="field-feedback hidden" id="experienceFb"></div>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label" for="consultationFee">Consultation Fee (₹) <span class="req">*</span></label>
                                <input type="number" class="form-control" id="consultationFee"
                                       name="consultationFee" min="0" step="0.01" placeholder="e.g., 500">
                                <div class="field-feedback hidden" id="consultationFeeFb"></div>
                            </div>
                        </div>

                        <!-- ═══ AVAILABILITY ═══ -->
                        <div class="section-heading"><i class="fas fa-calendar-check me-2"></i>Availability Schedule</div>

                        <div class="mb-3">
                            <label class="form-label">Available Days <span class="req">*</span>
                                <small class="text-muted fw-normal">(Select one or more)</small>
                            </label>
                            <div class="days-grid" id="daysGrid">
                                <span class="day-pill" data-day="Monday">Mon</span>
                                <span class="day-pill" data-day="Tuesday">Tue</span>
                                <span class="day-pill" data-day="Wednesday">Wed</span>
                                <span class="day-pill" data-day="Thursday">Thu</span>
                                <span class="day-pill" data-day="Friday">Fri</span>
                                <span class="day-pill" data-day="Saturday">Sat</span>
                                <span class="day-pill" data-day="Sunday">Sun</span>
                            </div>
                            <input type="hidden" name="availableDaysString" id="availableDaysString">
                            <div class="field-feedback hidden" id="daysFb"></div>
                        </div>

                        <!-- Selected days display -->
                        <div class="mb-3" id="selectedDaysWrap" style="display:none">
                            <small class="text-muted">Selected: </small>
                            <span id="selectedDaysDisplay"></span>
                        </div>

                        <!-- ═══ TIME SETTINGS ═══ -->
                        <div class="section-heading"><i class="fas fa-clock me-2"></i>Appointment Time Settings</div>

                        <div class="info-box mb-3">
                            <i class="fas fa-info-circle me-1"></i>
                            Set your working hours and slot duration. The system will auto-generate bookable time slots.
                        </div>

                        <div class="row g-3 mb-2">
                            <div class="col-md-4">
                                <label class="form-label" for="startTime">Start Time <span class="req">*</span></label>
                                <input type="time" class="form-control" id="startTime" name="startTime">
                                <div class="field-feedback hidden" id="startTimeFb"></div>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label" for="endTime">End Time <span class="req">*</span></label>
                                <input type="time" class="form-control" id="endTime" name="endTime">
                                <div class="field-feedback hidden" id="endTimeFb"></div>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label" for="slotDuration">Slot Duration <span class="req">*</span></label>
                                <select class="form-select" id="slotDuration" name="slotDuration">
                                    <option value="">Select duration…</option>
                                    <option value="15">15 minutes</option>
                                    <option value="30" selected>30 minutes</option>
                                    <option value="45">45 minutes</option>
                                    <option value="60">1 hour</option>
                                </select>
                                <div class="field-feedback hidden" id="slotDurationFb"></div>
                            </div>
                        </div>

                        <!-- Slot preview -->
                        <div id="slotPreviewWrap" style="display:none" class="mb-3">
                            <label class="form-label text-success">
                                <i class="fas fa-calendar-alt me-1"></i> Generated Time Slots
                            </label>
                            <div class="slot-preview" id="slotPreview"></div>
                        </div>

                        <!-- Submit -->
                        <button type="submit" class="btn-register" id="submitBtn">
                            <i class="fas fa-user-md me-2"></i> Register as Doctor
                        </button>

                        <!-- Toast -->
                        <div class="form-toast" id="formToast"></div>

                    </form>

                    <div class="text-center mt-3">
                        <small class="text-muted">
                            Already registered?
                            <a href="doctorLogin.jsp" class="text-success fw-semibold">Login here</a>
                        </small>
                    </div>

                </div><!-- /card-body -->
            </div><!-- /card -->
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
/* ═══════════════════════════════════════════════
   UTILITIES
═══════════════════════════════════════════════ */

function setFeedback(id, message, isValid) {
    const el = document.getElementById(id + 'Fb');
    if (!el) return;
    if (message === null) {
        el.className = 'field-feedback hidden';
        el.innerHTML = '';
        return;
    }
    const icon = isValid
        ? '<i class="fas fa-circle-check icon"></i>'
        : '<i class="fas fa-circle-exclamation icon"></i>';
    el.className = 'field-feedback ' + (isValid ? 'valid-fb' : 'invalid-fb');
    el.innerHTML = icon + ' ' + message;
}

function markField(id, isValid) {
    const el = document.getElementById(id);
    if (!el) return;
    el.classList.toggle('is-valid',   isValid);
    el.classList.toggle('is-invalid', !isValid);
}

/* ═══════════════════════════════════════════════
   PHOTO
═══════════════════════════════════════════════ */

let photoValid = false;

function handlePhoto(event) {
    const file = event.target.files[0];
    const input = document.getElementById('profilePhoto');

    if (!file) {
        photoValid = false;
        markField('profilePhoto', false);
        setFeedback('photo', 'Please select a profile photo.', false);
        return;
    }
    if (!file.type.match('image.*')) {
        photoValid = false;
        markField('profilePhoto', false);
        setFeedback('photo', 'Only image files are allowed (JPG, PNG, JPEG).', false);
        input.value = '';
        return;
    }
    if (file.size > 5 * 1024 * 1024) {
        photoValid = false;
        markField('profilePhoto', false);
        setFeedback('photo', 'File too large. Maximum allowed size is 5 MB.', false);
        input.value = '';
        return;
    }

    const reader = new FileReader();
    reader.onload = function (e) {
        document.getElementById('photoPreview').src = e.target.result;
    };
    reader.readAsDataURL(file);

    photoValid = true;
    markField('profilePhoto', true);
    setFeedback('photo', 'Photo uploaded successfully.', true);
}

/* ═══════════════════════════════════════════════
   PASSWORD TOGGLE + STRENGTH
═══════════════════════════════════════════════ */

function togglePassword() {
    const input = document.getElementById('password');
    const icon  = document.getElementById('toggleIcon');
    if (input.type === 'password') {
        input.type = 'text';
        icon.className = 'fas fa-eye-slash';
    } else {
        input.type = 'password';
        icon.className = 'fas fa-eye';
    }
}

document.getElementById('password').addEventListener('input', function () {
    const val = this.value;
    const bar  = document.getElementById('strengthBar');
    const lbl  = document.getElementById('strengthLabel');

    let score = 0;
    if (val.length >= 8)              score++;
    if (val.length >= 12)             score++;
    if (/[A-Z]/.test(val))            score++;
    if (/[0-9]/.test(val))            score++;
    if (/[^A-Za-z0-9]/.test(val))     score++;

    const pct = Math.round((score / 5) * 100);
    bar.style.width = pct + '%';

    if (pct === 0)       { bar.style.background = '#dee2e6'; lbl.textContent = 'Strength'; lbl.style.color = '#aaa'; }
    else if (pct <= 40)  { bar.style.background = '#dc3545'; lbl.textContent = 'Weak';     lbl.style.color = '#dc3545'; }
    else if (pct <= 70)  { bar.style.background = '#ffc107'; lbl.textContent = 'Fair';     lbl.style.color = '#bb8a00'; }
    else                 { bar.style.background = '#198754'; lbl.textContent = 'Strong';   lbl.style.color = '#198754'; }

    validateField('password');
});

/* ═══════════════════════════════════════════════
   FIELD VALIDATORS
═══════════════════════════════════════════════ */

const VALIDATORS = {
    fullName: {
        validate: v => v.trim().length >= 3,
        ok:  'Looks good!',
        err: 'Full name must be at least 3 characters.'
    },
    email: {
        validate: v => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v.trim()),
        ok:  'Valid email address.',
        err: 'Please enter a valid email address (e.g., you@hospital.com).'
    },
    password: {
        validate: v => v.length >= 8,
        ok:  'Password length is acceptable.',
        err: 'Password must be at least 8 characters long.'
    },
    phone: {
        validate: v => /^[0-9]{10}$/.test(v.trim()),
        ok:  'Valid phone number.',
        err: 'Phone must be exactly 10 digits (numbers only).'
    },
    specialization: {
        validate: v => v.trim().length > 0,
        ok:  'Specialization noted.',
        err: 'Please enter or select your specialization.'
    },
    qualification: {
        validate: v => v.trim().length > 0,
        ok:  'Qualification noted.',
        err: 'Please enter your qualification (e.g., MBBS, MD).'
    },
    hospitalName: {
        validate: v => v.trim().length >= 2,
        ok:  'Hospital / Clinic name noted.',
        err: 'Please enter the hospital or clinic name.'
    },
    location: {
        validate: v => v.trim().length >= 2,
        ok:  'Location noted.',
        err: 'Please enter your practice location.'
    },
    experience: {
        validate: v => v !== '' && Number(v) >= 0 && Number(v) <= 70,
        ok:  'Experience entered.',
        err: 'Please enter valid years of experience (0–70).'
    },
    consultationFee: {
        validate: v => v !== '' && Number(v) >= 0,
        ok:  'Consultation fee entered.',
        err: 'Please enter a valid consultation fee (₹0 or more).'
    },
    startTime: {
        validate: v => v !== '',
        ok:  'Start time set.',
        err: 'Please select a start time.'
    },
    endTime: {
        validate: v => {
            if (!v) return false;
            const s = document.getElementById('startTime').value;
            if (!s) return true;
            return new Date('1970-01-01T' + v) > new Date('1970-01-01T' + s);
        },
        ok:  'End time is valid.',
        err: 'End time must be after the start time.'
    },
    slotDuration: {
        validate: v => v !== '',
        ok:  'Slot duration selected.',
        err: 'Please select a slot duration.'
    }
};

function validateField(fieldId) {
    const cfg = VALIDATORS[fieldId];
    if (!cfg) return true;

    const el = document.getElementById(fieldId);
    if (!el) return true;

    const val = el.value;
    const isValid = cfg.validate(val);

    markField(fieldId, isValid);
    setFeedback(fieldId, isValid ? cfg.ok : cfg.err, isValid);

    return isValid;
}

/* attach blur + live-fix listeners */
Object.keys(VALIDATORS).forEach(function (id) {
    const el = document.getElementById(id);
    if (!el) return;
    el.addEventListener('blur',  function () { validateField(id); });
    el.addEventListener('input', function () {
        if (el.classList.contains('is-invalid') || el.classList.contains('is-valid')) {
            validateField(id);
        }
    });
    el.addEventListener('change', function () { validateField(id); });
});

/* Re-validate end time if start time changes */
document.getElementById('startTime').addEventListener('change', function () {
    if (document.getElementById('endTime').value) {
        validateField('endTime');
    }
    generateSlots();
});

/* ═══════════════════════════════════════════════
   DAYS
═══════════════════════════════════════════════ */

const selectedDays = new Set();

document.querySelectorAll('.day-pill').forEach(function (pill) {
    pill.addEventListener('click', function () {
        const day = this.dataset.day;
        if (selectedDays.has(day)) {
            selectedDays.delete(day);
            this.classList.remove('active');
        } else {
            selectedDays.add(day);
            this.classList.add('active');
        }
        updateDaysHidden();
        updateDaysDisplay();
        validateDays();
    });
});

function updateDaysHidden() {
    const shortMap = {
        Monday: 'Mon', Tuesday: 'Tue', Wednesday: 'Wed',
        Thursday: 'Thu', Friday: 'Fri', Saturday: 'Sat', Sunday: 'Sun'
    };
    const arr = Array.from(selectedDays).map(function (d) { return shortMap[d] || d; });
    document.getElementById('availableDaysString').value = arr.join(', ');
}

function updateDaysDisplay() {
    const wrap = document.getElementById('selectedDaysWrap');
    const span = document.getElementById('selectedDaysDisplay');
    if (selectedDays.size === 0) {
        wrap.style.display = 'none';
        return;
    }
    wrap.style.display = 'block';
    const shortMap = {
        Monday: 'Mon', Tuesday: 'Tue', Wednesday: 'Wed',
        Thursday: 'Thu', Friday: 'Fri', Saturday: 'Sat', Sunday: 'Sun'
    };
    span.innerHTML = Array.from(selectedDays).map(function (d) {
        return '<span class="badge bg-success me-1">' + (shortMap[d] || d) + '</span>';
    }).join('');
}

function validateDays() {
    const fb   = document.getElementById('daysFb');
    const pills = document.querySelectorAll('.day-pill');
    if (selectedDays.size === 0) {
        fb.className = 'field-feedback invalid-fb';
        fb.innerHTML = '<i class="fas fa-circle-exclamation icon"></i> Please select at least one available day.';
        pills.forEach(function (p) { p.classList.add('day-error'); });
        return false;
    }
    fb.className = 'field-feedback valid-fb';
    fb.innerHTML = '<i class="fas fa-circle-check icon"></i> ' + selectedDays.size + ' day(s) selected.';
    pills.forEach(function (p) { p.classList.remove('day-error'); });
    return true;
}

/* ═══════════════════════════════════════════════
   SLOT PREVIEW
═══════════════════════════════════════════════ */

function generateSlots() {
    const startVal = document.getElementById('startTime').value;
    const endVal   = document.getElementById('endTime').value;
    const dur      = parseInt(document.getElementById('slotDuration').value);
    const wrap     = document.getElementById('slotPreviewWrap');
    const preview  = document.getElementById('slotPreview');

    preview.innerHTML = '';
    if (!startVal || !endVal || !dur) { wrap.style.display = 'none'; return; }

    const start = new Date('1970-01-01T' + startVal);
    const end   = new Date('1970-01-01T' + endVal);
    if (start >= end) { wrap.style.display = 'none'; return; }

    let cur = new Date(start);
    const badges = [];
    while (cur < end) {
        const h = cur.getHours(), m = cur.getMinutes();
        const ap = h >= 12 ? 'PM' : 'AM';
        const dh = h % 12 || 12;
        badges.push('<span class="slot-badge">' + dh + ':' + String(m).padStart(2, '0') + ' ' + ap + '</span>');
        cur.setMinutes(cur.getMinutes() + dur);
    }

    if (badges.length > 0) {
        preview.innerHTML = badges.join('');
        wrap.style.display = 'block';
    } else {
        wrap.style.display = 'none';
    }
}

document.getElementById('endTime').addEventListener('change',     generateSlots);
document.getElementById('slotDuration').addEventListener('change', generateSlots);

/* ═══════════════════════════════════════════════
   FORM SUBMIT
═══════════════════════════════════════════════ */

document.getElementById('regForm').addEventListener('submit', function (e) {
    e.preventDefault();

    let allValid = true;
    const fields = [
        'fullName','email','password','phone',
        'specialization','qualification','hospitalName','location',
        'experience','consultationFee',
        'startTime','endTime','slotDuration'
    ];

    fields.forEach(function (id) {
        if (!validateField(id)) allValid = false;
    });

    if (!photoValid) {
        markField('profilePhoto', false);
        setFeedback('photo', 'Please upload a valid profile photo (JPG/PNG, max 5 MB).', false);
        allValid = false;
    }

    if (!validateDays()) allValid = false;

    const toast = document.getElementById('formToast');

    if (!allValid) {
        toast.className = 'form-toast error show';
        toast.innerHTML = '<i class="fas fa-triangle-exclamation me-2"></i>'
            + 'Please fix the highlighted errors before submitting.';

        /* scroll to first invalid field */
        const firstInvalid = document.querySelector('.is-invalid, .day-error');
        if (firstInvalid) {
            firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        return false;
    }

    toast.className = 'form-toast success show';
    toast.innerHTML = '<i class="fas fa-circle-check me-2"></i>'
        + 'All fields validated. Submitting your registration…';

    /* Submit after brief delay so user sees the success toast */
    setTimeout(function () { e.target.submit(); }, 800);
});
</script>

</body>
</html>
