<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Doctor | Hospital Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .required-field::after {
            content: "*";
            color: red;
            margin-left: 4px;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    

    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="adminDashboard.jsp">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="viewDoctors.jsp">Doctors</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Add Doctor</li>
                    </ol>
                </nav>
                <h2><i class="fas fa-user-md"></i> Add New Doctor</h2>
                <p class="text-muted">Enter the details of the new doctor below.</p>
            </div>
        </div>
        
        <!-- Alert for success or error messages -->
        <c:if test="${not empty message}">
            <div class="alert alert-${messageType} alert-dismissible fade show" role="alert">
                <strong>${messageHeader}!</strong> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        
        <div class="row">
            <div class="col-lg-12">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-user-plus"></i> Doctor Information</h5>
                    </div>
                    <div class="card-body">
                        <form action="../DoctorServlet" method="post" class="needs-validation" novalidate>
                            <input type="hidden" name="action" value="addDoctor">
                            
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label for="firstName" class="form-label required-field">First Name</label>
                                    <input type="text" class="form-control" id="firstName" name="firstName" required>
                                    <div class="invalid-feedback">Please enter the first name.</div>
                                </div>
                                <div class="col-md-4">
                                    <label for="middleName" class="form-label">Middle Name</label>
                                    <input type="text" class="form-control" id="middleName" name="middleName">
                                </div>
                                <div class="col-md-4">
                                    <label for="lastName" class="form-label required-field">Last Name</label>
                                    <input type="text" class="form-control" id="lastName" name="lastName" required>
                                    <div class="invalid-feedback">Please enter the last name.</div>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="email" class="form-label required-field">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                    <div class="invalid-feedback">Please enter a valid email address.</div>
                                </div>
                                <div class="col-md-6">
                                    <label for="phone" class="form-label required-field">Phone Number</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" required>
                                    <div class="invalid-feedback">Please enter a phone number.</div>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="specialization" class="form-label required-field">Specialization</label>
                                    <select class="form-select" id="specialization" name="specialization" required>
                                        <option value="">Select Specialization</option>
                                        <option value="Cardiology">Cardiology</option>
                                        <option value="Dermatology">Dermatology</option>
                                        <option value="Endocrinology">Endocrinology</option>
                                        <option value="Gastroenterology">Gastroenterology</option>
                                        <option value="Neurology">Neurology</option>
                                        <option value="Obstetrics">Obstetrics</option>
                                        <option value="Oncology">Oncology</option>
                                        <option value="Ophthalmology">Ophthalmology</option>
                                        <option value="Orthopedics">Orthopedics</option>
                                        <option value="Pediatrics">Pediatrics</option>
                                        <option value="Psychiatry">Psychiatry</option>
                                        <option value="Pulmonology">Pulmonology</option>
                                        <option value="Radiology">Radiology</option>
                                        <option value="Urology">Urology</option>
                                    </select>
                                    <div class="invalid-feedback">Please select a specialization.</div>
                                </div>
                                <div class="col-md-6">
                                    <label for="qualification" class="form-label required-field">Qualification</label>
                                    <input type="text" class="form-control" id="qualification" name="qualification" required>
                                    <div class="invalid-feedback">Please enter the qualification.</div>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="experience" class="form-label required-field">Years of Experience</label>
                                    <input type="number" class="form-control" id="experience" name="experience" min="0" required>
                                    <div class="invalid-feedback">Please enter years of experience.</div>
                                </div>
                                <div class="col-md-6">
                                    <label for="licenseNumber" class="form-label required-field">License Number</label>
                                    <input type="text" class="form-control" id="licenseNumber" name="licenseNumber" required>
                                    <div class="invalid-feedback">Please enter the license number.</div>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="joiningDate" class="form-label required-field">Joining Date</label>
                                    <input type="date" class="form-control" id="joiningDate" name="joiningDate" required>
                                    <div class="invalid-feedback">Please select the joining date.</div>
                                </div>
                                <div class="col-md-6">
                                    <label for="consultationFee" class="form-label required-field">Consultation Fee</label>
                                    <div class="input-group">
                                        <span class="input-group-text">$</span>
                                        <input type="number" class="form-control" id="consultationFee" name="consultationFee" min="0" step="0.01" required>
                                        <div class="invalid-feedback">Please enter the consultation fee.</div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="address" class="form-label required-field">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="3" required></textarea>
                                <div class="invalid-feedback">Please enter the address.</div>
                            </div>
                            
                            <hr>
                            
                            <div class="mb-3">
                                <label class="form-label required-field">Working Days</label>
                                <div class="row">
                                    <div class="col-md-2">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" value="Monday" id="monday" name="workingDays">
                                            <label class="form-check-label" for="monday">Monday</label>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" value="Tuesday" id="tuesday" name="workingDays">
                                            <label class="form-check-label" for="tuesday">Tuesday</label>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" value="Wednesday" id="wednesday" name="workingDays">
                                            <label class="form-check-label" for="wednesday">Wednesday</label>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" value="Thursday" id="thursday" name="workingDays">
                                            <label class="form-check-label" for="thursday">Thursday</label>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" value="Friday" id="friday" name="workingDays">
                                            <label class="form-check-label" for="friday">Friday</label>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" value="Saturday" id="saturday" name="workingDays">
                                            <label class="form-check-label" for="saturday">Saturday</label>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" value="Sunday" id="sunday" name="workingDays">
                                            <label class="form-check-label" for="sunday">Sunday</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="startTime" class="form-label required-field">Working Hours - Start</label>
                                    <input type="time" class="form-control" id="startTime" name="startTime" required>
                                    <div class="invalid-feedback">Please select the start time.</div>
                                </div>
                                <div class="col-md-6">
                                    <label for="endTime" class="form-label required-field">Working Hours - End</label>
                                    <input type="time" class="form-control" id="endTime" name="endTime" required>
                                    <div class="invalid-feedback">Please select the end time.</div>
                                </div>
                            </div>
                            
                            <hr>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="username" class="form-label required-field">Username</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                                        <input type="text" class="form-control" id="username" name="username" required>
                                    </div>
                                    <div class="invalid-feedback">Please enter a username.</div>
                                </div>
                                <div class="col-md-6">
                                    <label for="password" class="form-label required-field">Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                        <input type="password" class="form-control" id="password" name="password" required>
                                        <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="invalid-feedback">Please enter a password.</div>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="notes" class="form-label">Additional Notes</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3"></textarea>
                            </div>
                            
                            <div class="d-flex justify-content-end">
                                <button type="button" class="btn btn-secondary me-2" onclick="window.location.href='viewDoctors.jsp'">Cancel</button>
                                <button type="submit" class="btn btn-primary">Save Doctor</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        (function() {
            'use strict';
            var forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms).forEach(function(form) {
                form.addEventListener('submit', function(event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
        
        // Toggle password visibility
        document.getElementById('togglePassword').addEventListener('click', function() {
            const passwordInput = document.getElementById('password');
            const icon = this.querySelector('i');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });
    </script>
</body>
</html>