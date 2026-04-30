<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Registration – Smart Health</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary:      #4f46e5;
            --primary-dark: #3730a3;
            --primary-light:#ede9fe;
            --red-dark:     #842029;
            --red-light:    #f8d7da;
            --green-dark:   #146c43;
            --green-light:  #d1e7dd;
            --radius:       14px;
            --shadow:       0 8px 32px rgba(79,70,229,.13);
        }

        *, *::before, *::after { box-sizing: border-box; }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #1a1a1a;
        }

        /* ── Navbar ── */
        .navbar { background: rgba(0,0,0,.18) !important; backdrop-filter: blur(6px); }
        .navbar-brand { font-weight: 700; letter-spacing: -.3px; }

        /* ── Card ── */
        .reg-card {
            border: none;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
        }
        .reg-card .card-header {
            background: linear-gradient(90deg, var(--primary-dark), var(--primary));
            padding: 1.3rem 1.8rem;
            border-bottom: none;
        }
        .reg-card .card-header h4 {
            font-weight: 700;
            margin: 0;
            font-size: 1.25rem;
        }
        .reg-card .card-body { padding: 2rem 2.2rem; }

        /* ── Section heading ── */
        .section-heading {
            font-size: .7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .1em;
            color: var(--primary);
            padding-bottom: 8px;
            border-bottom: 2px solid var(--primary-light);
            margin-bottom: 1.2rem;
            margin-top: 1.8rem;
        }
        .section-heading:first-child { margin-top: 0; }

        /* ── Form controls ── */
        label.form-label {
            font-size: .82rem;
            font-weight: 600;
            color: #444;
            margin-bottom: 5px;
        }
        .form-control, .form-select, textarea.form-control {
            border-radius: 8px;
            border: 1.5px solid #dee2e6;
            font-size: .9rem;
            padding: .52rem .85rem;
            transition: border-color .2s, box-shadow .2s;
            background: #fff;
        }
        .input-group .form-control {
            border-left: none;
            border-radius: 0 8px 8px 0 !important;
        }
        .input-group-text {
            border-radius: 8px 0 0 8px !important;
            border: 1.5px solid #dee2e6;
            border-right: none;
            background: #f8f9fa;
            color: #6c757d;
            font-size: .85rem;
        }
        .form-control:focus, .form-select:focus, textarea.form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79,70,229,.15);
            outline: none;
        }
        .input-group:focus-within .input-group-text {
            border-color: var(--primary);
        }

        /* ── Validation states ── */
        .form-control.is-valid,
        .form-select.is-valid   { border-color: #198754 !important; background-image: none; }
        .form-control.is-invalid,
        .form-select.is-invalid { border-color: #dc3545 !important; background-image: none; box-shadow: 0 0 0 3px rgba(220,53,69,.1); }

        .input-group .form-control.is-valid   { border-color: #198754 !important; }
        .input-group .form-control.is-invalid { border-color: #dc3545 !important; }
        .input-group:has(.is-valid)   .input-group-text { border-color: #198754 !important; }
        .input-group:has(.is-invalid) .input-group-text { border-color: #dc3545 !important; }

        .field-feedback {
            font-size: .78rem;
            margin-top: 4px;
            min-height: 18px;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .field-feedback .icon { font-size: .75rem; }
        .field-feedback.valid-fb   { color: #146c43; }
        .field-feedback.invalid-fb { color: #b02a37; }
        .field-feedback.hidden     { visibility: hidden; }

        /* ── Photo area ── */
        .photo-wrapper {
            display: flex;
            align-items: center;
            gap: 1.2rem;
            padding: 1rem 1.2rem;
            background: var(--primary-light);
            border-radius: 10px;
            border: 1.5px dashed #a5b4fc;
            margin-bottom: 1.5rem;
        }
        .photo-circle {
            width: 78px; height: 78px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--primary);
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
            font-size: .82rem; padding: 0; line-height: 1; z-index: 5;
        }
        .toggle-pass:hover { color: var(--primary); }

        .strength-track {
            height: 4px; background: #e9ecef;
            border-radius: 4px; margin-top: 6px; overflow: hidden;
        }
        .strength-fill {
            height: 100%; width: 0; border-radius: 4px;
            transition: width .35s ease, background .35s ease;
        }
        .strength-label { font-size: .72rem; margin-top: 3px; font-weight: 600; }

        /* ── Submit ── */
        .btn-register {
            background: linear-gradient(90deg, var(--primary-dark), var(--primary));
            color: #fff; border: none;
            border-radius: 10px; font-size: 1rem;
            font-weight: 700; padding: .75rem; width: 100%;
            margin-top: 1.8rem;
            transition: transform .2s, box-shadow .2s;
            letter-spacing: .3px;
        }
        .btn-register:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(79,70,229,.35);
            color: #fff;
        }
        .btn-register:active { transform: scale(.98); }

        /* ── Toast ── */
        .form-toast {
            display: none; border-radius: 10px;
            padding: 12px 16px; font-size: .88rem;
            font-weight: 500; margin-top: 1rem;
            align-items: center; gap: 8px;
        }
        .form-toast.show    { display: flex; }
        .form-toast.success { background: var(--green-light); color: var(--green-dark); border: 1px solid #a3cfbb; }
        .form-toast.error   { background: var(--red-light);   color: var(--red-dark);   border: 1px solid #f5c2c7; }

        .req { color: #dc3545; margin-left: 2px; }
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
            <i class="fas fa-heartbeat me-1"></i> Smart Health
        </a>
        <div class="ms-auto">
            <a href="userLogin.jsp" class="btn btn-outline-light btn-sm">
                <i class="fas fa-sign-in-alt me-1"></i> Login
            </a>
        </div>
    </div>
</nav>

<!-- Form -->
<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-7">
            <div class="reg-card card">

                <div class="card-header text-white text-center">
                    <h4><i class="fas fa-user-plus me-2"></i>Patient Registration</h4>
                </div>

                <div class="card-body">

                    <!-- Server-side alert -->
                    <%
                        String serverError = request.getParameter("error");
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

                    <form action="UserRegisterServlet" method="post"
                          enctype="multipart/form-data" id="regForm" novalidate>

                        <!-- ═══ PHOTO ═══ -->
                        <div class="photo-wrapper">
                            <img id="photoPreview"
                                 src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png"
                                 class="photo-circle" alt="Preview">
                            <div class="photo-meta">
                                <label class="form-label">Profile Photo <small class="text-muted fw-normal">(Optional)</small></label>
                                <input type="file" class="form-control form-control-sm"
                                       id="profilePhoto" name="profilePhoto"
                                       accept="image/*" onchange="handlePhoto(event)">
                                <small>JPG / PNG / JPEG &nbsp;·&nbsp; Max 5 MB</small>
                                <div class="field-feedback hidden" id="photoFb"></div>
                            </div>
                        </div>

                        <!-- ═══ PERSONAL INFO ═══ -->
                        <div class="section-heading"><i class="fas fa-user me-2"></i>Personal Information</div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label" for="fullName">Full Name <span class="req">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <input type="text" class="form-control" id="fullName"
                                           name="fullName" placeholder="John Doe" autocomplete="name">
                                </div>
                                <div class="field-feedback hidden" id="fullNameFb"></div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" for="email">Email <span class="req">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                    <input type="email" class="form-control" id="email"
                                           name="email" placeholder="you@example.com" autocomplete="email">
                                </div>
                                <div class="field-feedback hidden" id="emailFb"></div>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label" for="password">Password <span class="req">*</span></label>
                                <div class="input-group password-wrapper">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
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
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                    <input type="tel" class="form-control" id="phone"
                                           name="phone" placeholder="10-digit number"
                                           maxlength="10" autocomplete="tel">
                                </div>
                                <div class="field-feedback hidden" id="phoneFb"></div>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label" for="gender">Gender <span class="req">*</span></label>
                                <select class="form-select" id="gender" name="gender">
                                    <option value="">Select Gender</option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                                <div class="field-feedback hidden" id="genderFb"></div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" for="dob">Date of Birth <span class="req">*</span></label>
                                <input type="date" class="form-control" id="dob" name="dob">
                                <div class="field-feedback hidden" id="dobFb"></div>
                            </div>
                        </div>

                        <!-- ═══ ADDITIONAL ═══ -->
                        <div class="section-heading"><i class="fas fa-map-marker-alt me-2"></i>Additional Details</div>

                        <div class="mb-3">
                            <label class="form-label" for="address">Address <small class="text-muted fw-normal">(Optional)</small></label>
                            <textarea class="form-control" id="address" name="address"
                                      rows="2" placeholder="Enter your full address"></textarea>
                            <div class="field-feedback hidden" id="addressFb"></div>
                        </div>

                        <!-- Submit -->
                        <button type="submit" class="btn-register">
                            <i class="fas fa-user-plus me-2"></i> Register
                        </button>

                        <!-- Toast -->
                        <div class="form-toast" id="formToast"></div>

                    </form>

                    <div class="text-center mt-3">
                        <small class="text-muted">
                            Already have an account?
                            <a href="userLogin.jsp" class="fw-bold" style="color:var(--primary)">Login here</a>
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
   PHOTO (optional – only validate if file chosen)
═══════════════════════════════════════════════ */

function handlePhoto(event) {
    const file  = event.target.files[0];
    const input = document.getElementById('profilePhoto');
    if (!file) return;

    if (!file.type.match('image.*')) {
        markField('profilePhoto', false);
        setFeedback('photo', 'Only image files are allowed (JPG, PNG, JPEG).', false);
        input.value = '';
        return;
    }
    if (file.size > 5 * 1024 * 1024) {
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
    const val  = this.value;
    const bar  = document.getElementById('strengthBar');
    const lbl  = document.getElementById('strengthLabel');

    let score = 0;
    if (val.length >= 8)          score++;
    if (val.length >= 12)         score++;
    if (/[A-Z]/.test(val))        score++;
    if (/[0-9]/.test(val))        score++;
    if (/[^A-Za-z0-9]/.test(val)) score++;

    const pct = Math.round((score / 5) * 100);
    bar.style.width = pct + '%';

    if (pct === 0)       { bar.style.background = '#dee2e6'; lbl.textContent = 'Strength'; lbl.style.color = '#aaa'; }
    else if (pct <= 40)  { bar.style.background = '#dc3545'; lbl.textContent = 'Weak';     lbl.style.color = '#dc3545'; }
    else if (pct <= 70)  { bar.style.background = '#ffc107'; lbl.textContent = 'Fair';     lbl.style.color = '#b07d00'; }
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
        err: 'Enter a valid email address (e.g., you@example.com).'
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
    gender: {
        validate: v => v !== '',
        ok:  'Gender selected.',
        err: 'Please select your gender.'
    },
    dob: {
        validate: function(v) {
            if (!v) return false;
            const dob  = new Date(v);
            const today = new Date();
            const age  = today.getFullYear() - dob.getFullYear();
            return dob < today && age <= 120;
        },
        ok:  'Date of birth is valid.',
        err: 'Please enter a valid date of birth.'
    }
};

function validateField(fieldId) {
    const cfg = VALIDATORS[fieldId];
    if (!cfg) return true;

    const el = document.getElementById(fieldId);
    if (!el) return true;

    const isValid = cfg.validate(el.value);
    markField(fieldId, isValid);
    setFeedback(fieldId, isValid ? cfg.ok : cfg.err, isValid);
    return isValid;
}

/* attach listeners */
Object.keys(VALIDATORS).forEach(function (id) {
    const el = document.getElementById(id);
    if (!el) return;
    el.addEventListener('blur',   function () { validateField(id); });
    el.addEventListener('input',  function () {
        if (el.classList.contains('is-invalid') || el.classList.contains('is-valid')) {
            validateField(id);
        }
    });
    el.addEventListener('change', function () { validateField(id); });
});

/* ═══════════════════════════════════════════════
   FORM SUBMIT
═══════════════════════════════════════════════ */

document.getElementById('regForm').addEventListener('submit', function (e) {
    e.preventDefault();

    let allValid = true;

    Object.keys(VALIDATORS).forEach(function (id) {
        if (!validateField(id)) allValid = false;
    });

    /* photo is optional – only flag if a file was chosen but is invalid */
    const photoInput = document.getElementById('profilePhoto');
    if (photoInput.files.length > 0 && photoInput.classList.contains('is-invalid')) {
        allValid = false;
    }

    const toast = document.getElementById('formToast');

    if (!allValid) {
        toast.className = 'form-toast error show';
        toast.innerHTML = '<i class="fas fa-triangle-exclamation me-2"></i>'
            + 'Please fix the highlighted errors before submitting.';
        const first = document.querySelector('.is-invalid');
        if (first) first.scrollIntoView({ behavior: 'smooth', block: 'center' });
        return false;
    }

    toast.className = 'form-toast success show';
    toast.innerHTML = '<i class="fas fa-circle-check me-2"></i>'
        + 'All fields validated. Submitting your registration…';

    setTimeout(function () { e.target.submit(); }, 800);
});
</script>

</body>
</html>
