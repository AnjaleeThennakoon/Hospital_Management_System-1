<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Patient - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
    <jsp:include page="/common/header.jsp" />
   
    
    <div class="container mt-4">
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h2>Add New Patient</h2>
            </div>
            <div class="card-body">
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                
                <form action="${pageContext.request.contextPath}/admin/addPatient" method="post" class="needs-validation" novalidate>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="firstName" class="form-label">First Name*</label>
                            <input type="text" class="form-control" id="firstName" name="firstName" required>
                            <div class="invalid-feedback">
                                Please enter a first name.
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="lastName" class="form-label">Last Name*</label>
                            <input type="text" class="form-control" id="lastName" name="lastName" required>
                            <div class="invalid-feedback">
                                Please enter a last name.
                            </div>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="dob" class="form-label">Date of Birth*</label>
                            <input type="date" class="form-control" id="dob" name="dob" required>
                            <div class="invalid-feedback">
                                Please enter a valid date of birth.
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="gender" class="form-label">Gender*</label>
                            <select class="form-select" id="gender" name="gender" required>
                                <option value="" selected disabled>Select gender</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                            <div class="invalid-feedback">
                                Please select a gender.
                            </div>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="bloodGroup" class="form-label">Blood Group</label>
                            <select class="form-select" id="bloodGroup" name="bloodGroup">
                                <option value="" selected disabled>Select blood group</option>
                                <option value="A+">A+</option>
                                <option value="A-">A-</option>
                                <option value="B+">B+</option>
                                <option value="B-">B-</option>
                                <option value="AB+">AB+</option>
                                <option value="AB-">AB-</option>
                                <option value="O+">O+</option>
                                <option value="O-">O-</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="contactNumber" class="form-label">Contact Number*</label>
                            <input type="tel" class="form-control" id="contactNumber" name="contactNumber" 
                                   pattern="[0-9]{10}" required>
                            <div class="invalid-feedback">
                                Please enter a valid 10-digit contact number.
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="email" class="form-label">Email Address*</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                        <div class="invalid-feedback">
                            Please enter a valid email address.
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="address" class="form-label">Address*</label>
                        <textarea class="form-control" id="address" name="address" rows="3" required></textarea>
                        <div class="invalid-feedback">
                            Please enter an address.
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="emergencyContactName" class="form-label">Emergency Contact Name*</label>
                            <input type="text" class="form-control" id="emergencyContactName" name="emergencyContactName" required>
                            <div class="invalid-feedback">
                                Please enter an emergency contact name.
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="emergencyContactNumber" class="form-label">Emergency Contact Number*</label>
                            <input type="tel" class="form-control" id="emergencyContactNumber" name="emergencyContactNumber" 
                                   pattern="[0-9]{10}" required>
                            <div class="invalid-feedback">
                                Please enter a valid 10-digit emergency contact number.
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="medicalHistory" class="form-label">Medical History</label>
                        <textarea class="form-control" id="medicalHistory" name="medicalHistory" rows="3"></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label for="allergies" class="form-label">Allergies</label>
                        <textarea class="form-control" id="allergies" name="allergies" rows="2"></textarea>
                    </div>
                    
                    <div class="d-flex justify-content-between">
                        <button type="submit" class="btn btn-primary">Add Patient</button>
                        <button type="reset" class="btn btn-secondary">Reset Form</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <jsp:include page="/common/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    // Form validation script
    (function () {
        'use strict';
        
        // Fetch all forms that need validation
        var forms = document.querySelectorAll('.needs-validation');
        
        // Loop over them and prevent submission
        Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                
                form.classList.add('was-validated');
            }, false);
        });
    })();
    </script>
</body>
</html>