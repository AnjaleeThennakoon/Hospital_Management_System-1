<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment</title>
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2980b9;
            --light-gray: #f8f9fa;
            --dark-gray: #343a40;
            --success-color: #28a745;
        }
        
        body {
            background-color: #f5f5f5;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border: none;
            margin-bottom: 30px;
        }
        
        .card-header {
            background-color: var(--primary-color);
            color: white;
            border-radius: 10px 10px 0 0 !important;
            padding: 1.25rem;
        }
        
        .card-header h3 {
            margin: 0;
            font-weight: 600;
        }
        
        .card-body {
            padding: 2rem;
        }
        
        .form-label {
            font-weight: 500;
            color: var(--dark-gray);
            margin-bottom: 0.5rem;
        }
        
        .form-control, .form-select {
            border-radius: 5px;
            padding: 0.75rem 1rem;
            border: 1px solid #ced4da;
            transition: all 0.3s;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(52, 152, 219, 0.25);
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            padding: 0.75rem;
            font-weight: 500;
            border-radius: 5px;
            transition: all 0.3s;
        }
        
        .btn-primary:hover {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }
        
        .btn-secondary {
            padding: 0.75rem;
            font-weight: 500;
            border-radius: 5px;
        }
        
        .text-muted {
            font-size: 0.85rem;
            display: block;
            margin-top: 0.25rem;
        }
        
        .form-check-label {
            font-size: 0.9rem;
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .card-body {
                padding: 1.5rem;
            }
            
            .col-md-8 {
                padding-left: 15px;
                padding-right: 15px;
            }
        }
        
        /* Loading state for selects */
        select[disabled] {
            background-color: #e9ecef;
            opacity: 1;
        }
        
        /* Datepicker styling */
        .datepicker {
            cursor: pointer;
            background-color: white;
        }
        
        /* Form section spacing */
        .form-section {
            margin-bottom: 1.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid #eee;
        }
        
        .form-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
    </style>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- DatePicker CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.min.css">
</head>
<body>
    <!-- Include header and navbar -->
    <jsp:include page="../common/header.jsp" />
    
    <div class="container mt-4 mb-5">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-md-10">
                <div class="card">
                    <div class="card-header">
                        <h3>Book New Appointment</h3>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/appointment/book" method="post" id="appointmentForm">
                            <!-- Department Selection -->
                            <div class="mb-4 form-section">
                                <label for="department" class="form-label">Department</label>
                                <select class="form-select" id="department" name="department" required>
                                    <option value="">Select Department</option>
                                    <c:forEach items="${departments}" var="dept">
                                        <option value="${dept.id}">${dept.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <!-- Doctor Selection -->
                            <div class="mb-4 form-section">
                                <label for="doctor" class="form-label">Doctor</label>
                                <select class="form-select" id="doctor" name="doctorId" required disabled>
                                    <option value="">Select Doctor</option>
                                </select>
                            </div>
                            
                            <!-- Appointment Date -->
                            <div class="mb-4 form-section">
                                <label for="appointmentDate" class="form-label">Appointment Date</label>
                                <input type="text" class="form-control datepicker" id="appointmentDate" name="appointmentDate" required readonly>
                                <small class="text-muted">Select a date to see available time slots</small>
                            </div>
                            
                            <!-- Time Slot Selection -->
                            <div class="mb-4 form-section">
                                <label for="timeSlot" class="form-label">Time Slot</label>
                                <select class="form-select" id="timeSlot" name="timeSlot" required disabled>
                                    <option value="">Select Time Slot</option>
                                </select>
                            </div>
                            
                            <!-- Appointment Reason -->
                            <div class="mb-4 form-section">
                                <label for="reason" class="form-label">Reason for Visit</label>
                                <textarea class="form-control" id="reason" name="reason" rows="3" required></textarea>
                            </div>
                            
                            <!-- Medical History -->
                            <div class="mb-4 form-section">
                                <label for="medicalHistory" class="form-label">Any relevant medical history?</label>
                                <textarea class="form-control" id="medicalHistory" name="medicalHistory" rows="2"></textarea>
                            </div>
                            
                            <!-- Insurance Information -->
                            <div class="mb-4 form-section">
                                <label for="insurance" class="form-label">Insurance Provider</label>
                                <input type="text" class="form-control" id="insurance" name="insurance">
                            </div>
                            
                            <div class="mb-4">
                                <label for="policyNumber" class="form-label">Policy Number</label>
                                <input type="text" class="form-control" id="policyNumber" name="policyNumber">
                            </div>
                            
                            <div class="form-check mb-4">
                                <input class="form-check-input" type="checkbox" id="termsAgreed" name="termsAgreed" required>
                                <label class="form-check-label" for="termsAgreed">
                                    I agree to the terms and policies of the hospital
                                </label>
                            </div>
                            
                            <div class="d-grid gap-3">
                                <button type="submit" class="btn btn-primary">Book Appointment</button>
                                <a href="${pageContext.request.contextPath}/patient/patientDashboard.jsp" class="btn btn-outline-secondary">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Include footer -->
    <jsp:include page="../common/footer.jsp" />
    
    <!-- Bootstrap JS and jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- DatePicker JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Initialize datepicker with restrictions (no past dates, no weekends)
            $('.datepicker').datepicker({
                format: 'yyyy-mm-dd',
                startDate: '+1d',
                daysOfWeekDisabled: [0, 6], // Disable weekends (Sunday = 0, Saturday = 6)
                autoclose: true
            });
            
            // Handle department change to load doctors
            $('#department').change(function() {
                const departmentId = $(this).val();
                if (departmentId) {
                    $.ajax({
                        url: "${pageContext.request.contextPath}/doctor/getByDepartment",
                        type: "GET",
                        data: { departmentId: departmentId },
                        dataType: "json",
                        success: function(data) {
                            const doctorSelect = $('#doctor');
                            doctorSelect.empty();
                            doctorSelect.append('<option value="">Select Doctor</option>');
                            
                            $.each(data, function(index, doctor) {
                                doctorSelect.append('<option value="' + doctor.id + '">Dr. ' + doctor.firstName + ' ' + doctor.lastName + '</option>');
                            });
                            
                            doctorSelect.prop('disabled', false);
                            $('#timeSlot').prop('disabled', true);
                        },
                        error: function(xhr, status, error) {
                            console.error("Error loading doctors: " + error);
                            alert("Failed to load doctors. Please try again.");
                        }
                    });
                } else {
                    $('#doctor').prop('disabled', true);
                    $('#timeSlot').prop('disabled', true);
                }
            });
            
            // Handle doctor and date selection to load available time slots
            function loadTimeSlots() {
                const doctorId = $('#doctor').val();
                const appointmentDate = $('#appointmentDate').val();
                
                if (doctorId && appointmentDate) {
                    $.ajax({
                        url: "${pageContext.request.contextPath}/appointment/getAvailableTimeSlots",
                        type: "GET",
                        data: { 
                            doctorId: doctorId,
                            appointmentDate: appointmentDate
                        },
                        dataType: "json",
                        success: function(data) {
                            const timeSlotSelect = $('#timeSlot');
                            timeSlotSelect.empty();
                            timeSlotSelect.append('<option value="">Select Time Slot</option>');
                            
                            if (data.length === 0) {
                                timeSlotSelect.append('<option value="" disabled>No available slots on this date</option>');
                            } else {
                                $.each(data, function(index, slot) {
                                    timeSlotSelect.append('<option value="' + slot.value + '">' + slot.text + '</option>');
                                });
                            }
                            
                            timeSlotSelect.prop('disabled', false);
                        },
                        error: function(xhr, status, error) {
                            console.error("Error loading time slots: " + error);
                            alert("Failed to load time slots. Please try again.");
                        }
                    });
                } else {
                    $('#timeSlot').prop('disabled', true);
                }
            }
            
            $('#doctor').change(function() {
                if ($('#appointmentDate').val()) {
                    loadTimeSlots();
                }
            });
            
            $('.datepicker').change(function() {
                if ($('#doctor').val()) {
                    loadTimeSlots();
                }
            });
            
            // Form validation
            $('#appointmentForm').submit(function(event) {
                if (!$('#termsAgreed').is(':checked')) {
                    alert("You must agree to the terms and policies");
                    event.preventDefault();
                    return;
                }
                
                // Add additional validation if needed
            });
        });
    </script>
</body>
</html>