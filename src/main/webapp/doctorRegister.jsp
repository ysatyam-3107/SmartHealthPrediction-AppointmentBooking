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
        .form-control:focus, .form-select:focus {
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
        .time-slot-info {
            background: #e6f4ea;
            border-left: 4px solid #198754;
            padding: 15px;
            border-radius: 8px;
        }
        .day-checkbox {
            cursor: pointer;
            transition: all 0.3s;
        }
        .day-checkbox input[type="checkbox"] {
            width: 20px;
            height: 20px;
            cursor: pointer;
        }
        .day-checkbox label {
            cursor: pointer;
            user-select: none;
            padding-left: 8px;
        }
        .day-checkbox:hover {
            background-color: #f0f0f0;
            border-radius: 5px;
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
                        <form action="DoctorRegisterServlet" method="post" enctype="multipart/form-data" id="registrationForm">
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
                                    <input type="text" class="form-control" name="location" placeholder="e.g., Pune, Maharashtra" required>
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
                            </div>

                            <hr class="my-4">
                            <h5 class="mb-3 text-success"><i class="fas fa-calendar-check"></i> Availability Schedule</h5>

                            <div class="mb-3">
                                <label class="form-label d-block">Available Days * <small class="text-muted">(Select one or more)</small></label>
                                <div class="row">
                                    <div class="col-md-3 col-6 mb-2">
                                        <div class="day-checkbox p-2">
                                            <input type="checkbox" name="availableDays" value="Monday" id="mon">
                                            <label for="mon">Monday</label>
                                        </div>
                                    </div>
                                    <div class="col-md-3 col-6 mb-2">
                                        <div class="day-checkbox p-2">
                                            <input type="checkbox" name="availableDays" value="Tuesday" id="tue">
                                            <label for="tue">Tuesday</label>
                                        </div>
                                    </div>
                                    <div class="col-md-3 col-6 mb-2">
                                        <div class="day-checkbox p-2">
                                            <input type="checkbox" name="availableDays" value="Wednesday" id="wed">
                                            <label for="wed">Wednesday</label>
                                        </div>
                                    </div>
                                    <div class="col-md-3 col-6 mb-2">
                                        <div class="day-checkbox p-2">
                                            <input type="checkbox" name="availableDays" value="Thursday" id="thu">
                                            <label for="thu">Thursday</label>
                                        </div>
                                    </div>
                                    <div class="col-md-3 col-6 mb-2">
                                        <div class="day-checkbox p-2">
                                            <input type="checkbox" name="availableDays" value="Friday" id="fri">
                                            <label for="fri">Friday</label>
                                        </div>
                                    </div>
                                    <div class="col-md-3 col-6 mb-2">
                                        <div class="day-checkbox p-2">
                                            <input type="checkbox" name="availableDays" value="Saturday" id="sat">
                                            <label for="sat">Saturday</label>
                                        </div>
                                    </div>
                                    <div class="col-md-3 col-6 mb-2">
                                        <div class="day-checkbox p-2">
                                            <input type="checkbox" name="availableDays" value="Sunday" id="sun">
                                            <label for="sun">Sunday</label>
                                        </div>
                                    </div>
                                </div>
                                <input type="hidden" name="availableDaysString" id="availableDaysString" required>
                                <small class="text-danger" id="daysError" style="display: none;">Please select at least one day</small>
                            </div>

                            <div class="alert alert-info mb-3">
                                <strong><i class="fas fa-info-circle"></i> Selected Days:</strong>
                                <div id="selectedDaysDisplay" class="mt-2">
                                    <em class="text-muted">No days selected yet</em>
                                </div>
                            </div>

                            <hr class="my-4">
                            <h5 class="mb-3 text-success"><i class="fas fa-clock"></i> Appointment Time Settings</h5>

                            <div class="time-slot-info mb-3">
                                <i class="fas fa-info-circle"></i> <strong>How it works:</strong><br>
                                <small>Set your working hours and appointment duration. The system will automatically create time slots for patients to book.</small>
                            </div>

                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Start Time *</label>
                                    <input type="time" class="form-control" name="startTime" id="startTime" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">End Time *</label>
                                    <input type="time" class="form-control" name="endTime" id="endTime" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Slot Duration *</label>
                                    <select class="form-select" name="slotDuration" id="slotDuration" required>
                                        <option value="">Select duration...</option>
                                        <option value="15">15 minutes</option>
                                        <option value="30" selected>30 minutes</option>
                                        <option value="45">45 minutes</option>
                                        <option value="60">1 hour</option>
                                    </select>
                                </div>
                            </div>

                            <div class="alert alert-info" id="slotPreview" style="display: none;">
                                <strong><i class="fas fa-calendar-alt"></i> Your time slots will be:</strong>
                                <div id="slotList" class="mt-2"></div>
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

    <script>
        // Image preview
        function previewImage(event) {
            const file = event.target.files[0];
            if (file) {
                if (file.size > 5 * 1024 * 1024) {
                    alert('File size should not exceed 5MB');
                    event.target.value = '';
                    return;
                }
                
                if (!file.type.match('image.*')) {
                    alert('Please select a valid image file');
                    event.target.value = '';
                    return;
                }
                
                const reader = new FileReader();
                reader.onload = function(){
                    document.getElementById('photoPreview').src = reader.result;
                };
                reader.readAsDataURL(file);
            }
        }

        // Handle day selection
        const dayCheckboxes = document.querySelectorAll('input[name="availableDays"]');
        const selectedDaysDisplay = document.getElementById('selectedDaysDisplay');
        const availableDaysString = document.getElementById('availableDaysString');
        const daysError = document.getElementById('daysError');

        function updateSelectedDays() {
            const selected = [];
            dayCheckboxes.forEach(checkbox => {
                if (checkbox.checked) {
                    selected.push(checkbox.value);
                }
            });

            if (selected.length > 0) {
                // Create short form display (Mon, Tue, Wed, etc.)
                const shortNames = selected.map(day => day.substring(0, 3));
                selectedDaysDisplay.innerHTML = '<span class="badge bg-success me-1 mb-1">' + 
                    shortNames.join('</span> <span class="badge bg-success me-1 mb-1">') + '</span>';
                
                // Store comma-separated full names for database
                availableDaysString.value = shortNames.join(', ');
                daysError.style.display = 'none';
            } else {
                selectedDaysDisplay.innerHTML = '<em class="text-muted">No days selected yet</em>';
                availableDaysString.value = '';
            }
        }

        dayCheckboxes.forEach(checkbox => {
            checkbox.addEventListener('change', updateSelectedDays);
        });

        // Preview time slots
        function generateTimeSlots() {
            const startTime = document.getElementById('startTime').value;
            const endTime = document.getElementById('endTime').value;
            const duration = parseInt(document.getElementById('slotDuration').value);

            if (!startTime || !endTime || !duration) {
                document.getElementById('slotPreview').style.display = 'none';
                return;
            }

            const start = new Date('1970-01-01T' + startTime);
            const end = new Date('1970-01-01T' + endTime);

            if (start >= end) {
                alert('End time must be after start time');
                document.getElementById('endTime').value = '';
                return;
            }

            const slots = [];
            let current = new Date(start);

            while (current < end) {
                const hours = current.getHours();
                const minutes = current.getMinutes();
                const ampm = hours >= 12 ? 'PM' : 'AM';
                const displayHours = hours % 12 || 12;
                const timeStr = `${displayHours}:${minutes.toString().padStart(2, '0')} ${ampm}`;
                slots.push(timeStr);
                current.setMinutes(current.getMinutes() + duration);
            }

            if (slots.length > 0) {
                document.getElementById('slotPreview').style.display = 'block';
                document.getElementById('slotList').innerHTML = slots.map(slot => 
                    `<span class="badge bg-success me-2 mb-2">${slot}</span>`
                ).join('');
            }
        }

        document.getElementById('startTime').addEventListener('change', generateTimeSlots);
        document.getElementById('endTime').addEventListener('change', generateTimeSlots);
        document.getElementById('slotDuration').addEventListener('change', generateTimeSlots);

        // Form validation
        document.getElementById('registrationForm').addEventListener('submit', function(e) {
            const selected = document.querySelectorAll('input[name="availableDays"]:checked');
            if (selected.length === 0) {
                e.preventDefault();
                daysError.style.display = 'block';
                alert('Please select at least one available day');
                return false;
            }
        });
    </script>

</body>
</html>
