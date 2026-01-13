<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Registration</title>

    <!-- ✅ Bootstrap + Font Awesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(to right, #e6f4ea, #ffffff);
            font-family: 'Poppins', sans-serif;
        }
        .card {
            border-radius: 20px;
            border: none;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .card-header {
            border-top-left-radius: 20px !important;
            border-top-right-radius: 20px !important;
            background: linear-gradient(90deg, #198754, #28a745);
        }
        label {
            font-weight: 500;
            color: #333;
        }
        .btn-success {
            font-size: 1.1rem;
            font-weight: 600;
            background: linear-gradient(90deg, #198754, #28a745);
            border: none;
            transition: all 0.3s ease;
        }
        .btn-success:hover {
            transform: scale(1.03);
            box-shadow: 0 3px 8px rgba(0,0,0,0.2);
        }
        .form-control:focus {
            border-color: #198754;
            box-shadow: 0 0 5px rgba(25, 135, 84, 0.5);
        }
        .preview-img {
            width: 130px;
            height: 130px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #198754;
            display: block;
            margin: 10px auto;
        }
        hr {
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>

    <!-- ✅ Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-success shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp">
                <i class="fas fa-heartbeat"></i> Smart Health
            </a>
            <div class="ms-auto">
                <a href="doctorLogin.jsp" class="btn btn-outline-light">
                    <i class="fas fa-sign-in-alt"></i> Login
                </a>
            </div>
        </div>
    </nav>

    <!-- ✅ Registration Form -->
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card">
                    <div class="card-header text-white text-center py-3">
                        <h4 class="mb-0"><i class="fas fa-user-md"></i> Doctor Registration</h4>
                    </div>
                    <div class="card-body p-4">

                        <% 
                            String error = request.getParameter("error");
                            String success = request.getParameter("success");
                            if (error != null) {
                        %>
                            <div class="alert alert-danger alert-dismissible fade show">
                                <%= error %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } 
                           if (success != null) {
                        %>
                            <div class="alert alert-success alert-dismissible fade show">
                                <%= success %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>

                        <!-- ✅ enctype added for file upload -->
                        <form action="DoctorRegisterServlet" method="post" enctype="multipart/form-data">
                            <h5 class="mb-3 text-success"><i class="fas fa-user"></i> Personal Information</h5>

                            <!-- Profile Photo Upload -->
                            <div class="text-center mb-3">
                                <img id="photoPreview" src="https://cdn-icons-png.flaticon.com/512/3870/3870822.png" class="preview-img" alt="Profile Preview">
                                <div class="col-md-6 mx-auto">
                                    <label class="form-label">Profile Photo *</label>
                                    <input type="file" class="form-control" name="profilePhoto" accept="image/*" required onchange="previewImage(event)">
                                    <small class="text-muted">Max size: 5MB. Formats: JPG, PNG, JPEG</small>
                                </div>
                            </div>

                            <div class="row mt-4">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Full Name *</label>
                                    <input type="text" class="form-control" name="fullName" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Email *</label>
                                    <input type="email" class="form-control" name="email" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Password *</label>
                                    <input type="password" class="form-control" name="password" required minlength="6">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Phone Number *</label>
                                    <input type="tel" class="form-control" name="phone" required pattern="[0-9]{10}">
                                </div>
                            </div>

                            <hr class="my-4">
                            <h5 class="mb-3 text-success"><i class="fas fa-briefcase-medical"></i> Professional Information</h5>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Specialization *</label>
                                    <input class="form-control" list="specializations" name="specialization" placeholder="Type or select specialization..." required>
                                    
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
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Qualification *</label>
                                    <input type="text" class="form-control" name="qualification" placeholder="e.g., MBBS, MD" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Hospital / Clinic Name *</label>
                                    <input type="text" class="form-control" name="hospitalName" placeholder="e.g., Apollo Hospital" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Location *</label>
                                    <input type="text" class="form-control" name="location" placeholder="e.g., Mumbai, Andheri" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Experience (Years) *</label>
                                    <input type="number" class="form-control" name="experience" min="0" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Consultation Fee (₹) *</label>
                                    <input type="number" class="form-control" name="consultationFee" min="0" step="0.01" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Available Days *</label>
                                    <input type="text" class="form-control" name="availableDays" placeholder="e.g., Mon-Fri" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Available Time *</label>
                                <input type="text" class="form-control" name="availableTime" placeholder="e.g., 9:00 AM - 5:00 PM" required>
                            </div>

                            <button type="submit" class="btn btn-success w-100 mt-4">
                                <i class="fas fa-user-md"></i> Register as Doctor
                            </button>
                        </form>

                        <div class="text-center mt-3">
                            <p>Already have an account? 
                                <a href="doctorLogin.jsp" class="text-success fw-semibold">Login here</a>
                            </p>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ✅ JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- ✅ Image Preview JS -->
    <script>
        function previewImage(event) {
            const file = event.target.files[0];
            if (file) {
                // Validate file size (5MB max)
                if (file.size > 5 * 1024 * 1024) {
                    alert('File size should not exceed 5MB');
                    event.target.value = '';
                    return;
                }
                
                // Validate file type
                if (!file.type.match('image.*')) {
                    alert('Please select a valid image file');
                    event.target.value = '';
                    return;
                }
                
                const reader = new FileReader();
                reader.onload = function(){
                    const output = document.getElementById('photoPreview');
                    output.src = reader.result;
                };
                reader.readAsDataURL(file);
            }
        }
    </script>

</body>
</html>