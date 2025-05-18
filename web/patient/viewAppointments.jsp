<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Appointment Details</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* General Styles */
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #f8f9fa;
    color: #333;
    line-height: 1.6;
}

.container {
    max-width: 1200px;
}

/* Card Styles */
.card {
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    border: none;
    margin-bottom: 2rem;
}

.card-header {
    border-radius: 10px 10px 0 0 !important;
    padding: 1.5rem;
}

.card-header h4 {
    margin-bottom: 0.5rem;
    font-weight: 600;
}

.card-body {
    padding: 2rem;
}

.card-footer {
    background-color: #f8f9fa;
    border-top: 1px solid rgba(0, 0, 0, 0.05);
    padding: 1rem 2rem;
}

/* Badge Styles */
.badge {
    font-size: 0.9rem;
    padding: 0.5rem 0.8rem;
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

/* Table Styles */
.table {
    margin-bottom: 0;
}

.table-bordered {
    border: 1px solid #dee2e6;
}

.table-bordered td {
    vertical-align: middle;
    padding: 1rem;
}

/* Button Styles */
.btn {
    font-weight: 500;
    padding: 0.5rem 1rem;
    border-radius: 6px;
    transition: all 0.3s ease;
}

.btn i {
    margin-right: 5px;
}

.btn-secondary {
    background-color: #6c757d;
    border-color: #6c757d;
}

.btn-secondary:hover {
    background-color: #5a6268;
    border-color: #545b62;
}

.btn-danger {
    background-color: #dc3545;
    border-color: #dc3545;
}

.btn-danger:hover {
    background-color: #c82333;
    border-color: #bd2130;
}

.btn-warning {
    background-color: #ffc107;
    border-color: #ffc107;
    color: #212529;
}

.btn-warning:hover {
    background-color: #e0a800;
    border-color: #d39e00;
    color: #212529;
}

.btn-primary {
    background-color: #0d6efd;
    border-color: #0d6efd;
}

.btn-primary:hover {
    background-color: #0b5ed7;
    border-color: #0a58ca;
}

.btn-info {
    background-color: #0dcaf0;
    border-color: #0dcaf0;
    color: #000;
}

.btn-info:hover {
    background-color: #31d2f2;
    border-color: #25cff2;
    color: #000;
}

.btn-success {
    background-color: #198754;
    border-color: #198754;
}

.btn-success:hover {
    background-color: #157347;
    border-color: #146c43;
}

.btn-outline-primary {
    color: #0d6efd;
    border-color: #0d6efd;
}

.btn-outline-primary:hover {
    background-color: #0d6efd;
    color: #fff;
}

/* Alert Styles */
.alert-info {
    background-color: #e7f8ff;
    border-color: #b6ecff;
    color: #055160;
    padding: 1rem;
    border-radius: 6px;
}

/* Modal Styles */
.modal-content {
    border-radius: 10px;
    border: none;
}

.modal-header {
    border-bottom: 1px solid #dee2e6;
}

.modal-footer {
    border-top: 1px solid #dee2e6;
}

/* Form Styles */
.form-control, .form-select {
    padding: 0.5rem 0.75rem;
    border-radius: 6px;
    border: 1px solid #ced4da;
}

.form-control:focus, .form-select:focus {
    border-color: #86b7fe;
    box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
}

/* Responsive Adjustments */
@media (max-width: 768px) {
    .card-body {
        padding: 1.5rem;
    }
    
    .card-header {
        padding: 1rem;
    }
    
    .btn {
        width: 100%;
        margin-bottom: 0.5rem;
    }
    
    .d-flex.gap-2 {
        flex-direction: column;
    }
}

/* Map Image */
.img-fluid {
    border-radius: 8px;
    border: 1px solid #dee2e6;
}

/* Section Headers */
h2 {
    color: #2c3e50;
    font-weight: 700;
    margin-bottom: 1.5rem;
}

h5 {
    color: #2c3e50;
    font-weight: 600;
    margin-bottom: 1rem;
    padding-bottom: 0.5rem;
    border-bottom: 2px solid #f0f0f0;
}

/* Badge Colors for Different Statuses */
.badge.bg-success {
    background-color: #198754 !important;
}

.badge.bg-warning {
    background-color: #ffc107 !important;
    color: #212529;
}

.badge.bg-info {
    background-color: #0dcaf0 !important;
    color: #000;
}

.badge.bg-danger {
    background-color: #dc3545 !important;
}

/* Collapse Button */
.btn-outline-primary.btn-sm {
    padding: 0.25rem 0.5rem;
    font-size: 0.875rem;
}
    </style>
</head>
<body>
    <!-- Include header and navbar -->
    <jsp:include page="../common/header.jsp" />
    
    <div class="container mt-4">
        <div class="row mb-3">
            <div class="col-md-8">
                <h2>Appointment Details</h2>
            </div>
            <div class="col-md-4 text-end">
                <a href="${pageContext.request.contextPath}/patient/viewAppointments.jsp" class="btn btn-secondary">
                    <i class="bi bi-arrow-left"></i> Back to Appointments
                </a>
            </div>
        </div>
        
        <!-- Appointment Information -->
        <div class="card mb-4">
            <div class="card-header bg-light">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h4>Appointment #${appointment.id}</h4>
                        <p class="mb-0"><strong>Date:</strong> ${appointment.date} | <strong>Time:</strong> ${appointment.timeSlot}</p>
                    </div>
                    <div class="col-md-4 text-md-end">
                        <span class="badge bg-${appointment.status == 'CONFIRMED' ? 'success' : 
                                            appointment.status == 'PENDING' ? 'warning' : 
                                            appointment.status == 'COMPLETED' ? 'info' : 
                                            'danger'}">
                            ${appointment.status}
                        </span>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="row mb-4">
                    <div class="col-md-6">
                        <h5>Patient Information</h5>
                        <p><strong>Name:</strong> ${patient.firstName} ${patient.lastName}</p>
                        <p><strong>Patient ID:</strong> ${patient.id}</p>
                        <p><strong>Contact:</strong> ${patient.phone}</p>
                        <p><strong>Email:</strong> ${patient.email}</p>
                    </div>
                    <div class="col-md-6">
                        <h5>Doctor Information</h5>
                        <p><strong>Name:</strong> Dr. ${appointment.doctor.firstName} ${appointment.doctor.lastName}</p>
                        <p><strong>Department:</strong> ${appointment.doctor.department}</p>
                        <p><strong>Specialization:</strong> ${appointment.doctor.specialization}</p>
                    </div>
                </div>
                
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h5>Appointment Details</h5>
                        <table class="table table-bordered">
                            <tr>
                                <td width="30%"><strong>Reason for Visit:</strong></td>
                                <td>${appointment.reason}</td>
                            </tr>
                            <c:if test="${not empty appointment.medicalHistory}">
                                <tr>
                                    <td><strong>Medical History:</strong></td>
                                    <td>${appointment.medicalHistory}</td>
                                </tr>
                            </c:if>
                            <c:if test="${not empty appointment.notes}">
                                <tr>
                                    <td><strong>Additional Notes:</strong></td>
                                    <td>${appointment.notes}</td>
                                </tr>
                            </c:if>
                            <c:if test="${not empty appointment.doctorNotes}">
                                <tr>
                                    <td><strong>Doctor's Notes:</strong></td>
                                    <td>${appointment.doctorNotes}</td>
                                </tr>
                            </c:if>
                        </table>
                    </div>
                </div>
                
                <!-- Appointment Actions -->
                <div class="row mb-3">
                    <div class="col-md-12">
                        <h5>Appointment Actions</h5>
                        <div class="d-flex gap-2">
                            <c:if test="${appointment.status == 'CONFIRMED' || appointment.status == 'PENDING'}">
                                <button class="btn btn-danger" onclick="showCancelModal()">
                                    <i class="bi bi-x-circle"></i> Cancel Appointment
                                </button>
                                <button class="btn btn-warning" onclick="showRescheduleModal()">
                                    <i class="bi bi-calendar"></i> Reschedule
                                </button>
                            </c:if>
                            
                            <c:if test="${appointment.status == 'COMPLETED' && not empty appointment.medicalRecordId}">
                                <a href="${pageContext.request.contextPath}/patient/viewMedicalRecordDetails.jsp?id=${appointment.medicalRecordId}" 
                                   class="btn btn-primary">
                                    <i class="bi bi-file-earmark-medical"></i> View Medical Record
                                </a>
                            </c:if>
                            
                            <c:if test="${appointment.status == 'COMPLETED' && not empty appointment.billId}">
                                <a href="${pageContext.request.contextPath}/patient/viewBillDetails.jsp?id=${appointment.billId}" 
                                   class="btn btn-info">
                                    <i class="bi bi-receipt"></i> View Bill
                                </a>
                            </c:if>
                            
                            <c:if test="${appointment.status == 'COMPLETED' && appointment.followUpRequired && empty appointment.followUpAppointmentId}">
                                <a href="${pageContext.request.contextPath}/patient/bookAppointment.jsp?followUp=true&doctorId=${appointment.doctor.id}" 
                                   class="btn btn-success">
                                    <i class="bi bi-calendar-plus"></i> Schedule Follow-up
                                </a>
                            </c:if>
                        </div>
                    </div>
                </div>
                
                <!-- Hospital Location and Map -->
                <div class="row mt-4">
                    <div class="col-md-12">
                        <h5>Location</h5>
                        <p>${hospitalInfo.name}</p>
                        <p>${hospitalInfo.address}</p>
                        <p><strong>Department:</strong> ${appointment.doctor.department}, Floor ${appointment.doctor.floor}</p>
                        <p><strong>Room:</strong> ${appointment.roomNumber}</p>
                        
                        <div class="mt-3">
                            <button class="btn btn-outline-primary btn-sm" type="button" data-bs-toggle="collapse" 
                                    data-bs-target="#collapseMap" aria-expanded="false" aria-controls="collapseMap">
                                Show Map <i class="bi bi-map"></i>
                            </button>
                            <div class="collapse mt-2" id="collapseMap">
                                <div class="card card-body">
                                    <!-- Placeholder for a hospital map or directions -->
                                    <img src="${pageContext.request.contextPath}/images/hospital-map.jpg" 
                                         alt="Hospital Map" class="img-fluid">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Preparation Instructions -->
                <c:if test="${not empty appointment.preparationInstructions}">
                    <div class="row mt-4">
                        <div class="col-md-12">
                            <h5>Preparation Instructions</h5>
                            <div class="alert alert-info">
                                <p>${appointment.preparationInstructions}</p>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
            <div class="card-footer">
                <div class="row">
                    <div class="col-md-12">
                        <p class="mb-0">
                            <small>
                                If you need to make changes to this appointment, please do so at least 24 hours in advance. 
                                For urgent matters, please call the hospital directly at ${hospitalInfo.emergencyPhone}.
                            </small>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Cancel Appointment Modal -->
    <div class="modal fade" id="cancelModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="cancelModalLabel">Cancel Appointment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to cancel this appointment? This action cannot be undone.</p>
                    <form id="cancelForm">
                        <input type="hidden" id="appointmentId" name="appointmentId" value="${appointment.id}">
                        <div class="mb-3">
                            <label for="cancelReason" class="form-label">Reason for Cancellation</label>
                            <textarea class="form-control" id="cancelReason" name="cancelReason" rows="3" required></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-danger" id="confirmCancel">Confirm Cancellation</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Reschedule Appointment Modal -->
    <div class="modal fade" id="rescheduleModal" tabindex="-1" aria-labelledby="rescheduleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="rescheduleModalLabel">Reschedule Appointment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="rescheduleForm">
                        <input type="hidden" name="appointmentId" value="${appointment.id}">
                        
                        <div class="mb-3">
                            <label for="newDate" class="form-label">New Date</label>
                            <input type="date" class="form-control" id="newDate" name="newDate" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="newTimeSlot" class="form-label">New Time Slot</label>
                            <select class="form-select" id="newTimeSlot" name="newTimeSlot" required>
                                <option value="">Select a time slot</option>
                                <!-- Will be populated via AJAX after selecting a date -->
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="rescheduleReason" class="form-label">Reason for Rescheduling</label>
                            <textarea class="form-control" id="rescheduleReason" name="rescheduleReason" rows="2"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="confirmReschedule">Reschedule</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Include footer -->
    <jsp:include page="../common/footer.jsp" />
    
    <!-- Bootstrap JS and jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Handle date change for rescheduling
            $('#newDate').change(function() {
                const newDate = $(this).val();
                const doctorId = '${appointment.doctor.id}';
                
                if (newDate) {
                    // Get available time slots for the selected date
                    $.ajax({
                        url: "${pageContext.request.contextPath}/appointment/getAvailableTimeSlots",
                        type: "GET",
                        data: {
                            doctorId: doctorId,
                            appointmentDate: newDate
                        },
                        dataType: "json",
                        success: function(data) {
                            const timeSlotSelect = $('#newTimeSlot');
                            timeSlotSelect.empty();
                            timeSlotSelect.append('<option value="">Select a time slot</option>');
                            
                            if (data.length === 0) {
                                timeSlotSelect.append('<option value="" disabled>No available slots on this date</option>');
                            } else {
                                $.each(data, function(index, slot) {
                                    timeSlotSelect.append('<option value="' + slot.value + '">' + slot.text + '</option>');
                                });
                            }
                        },
                        error: function(xhr, status, error) {
                            console.error("Error loading time slots: " + error);
                            alert("Failed to load available time slots. Please try again.");
                        }
                    });
                }
            });
            
            // Confirm appointment cancellation
            $('#confirmCancel').click(function() {
                const appointmentId = $('#appointmentId').val();
                const cancelReason = $('#cancelReason').val();
                
                if (!cancelReason.trim()) {
                    alert("Please provide a reason for cancellation");
                    return;
                }
                
                $.ajax({
                    url: "${pageContext.request.contextPath}/appointment/cancel",
                    type: "POST",
                    data: {
                        appointmentId: appointmentId,
                        cancelReason: cancelReason
                    },
                    success: function(response) {
                        alert("Appointment cancelled successfully!");
                        $('#cancelModal').modal('hide');
                        // Redirect to appointments list
                        window.location.href = "${pageContext.request.contextPath}/patient/viewAppointments.jsp";
                    },
                    error: function(xhr, status, error) {
                        alert("Error cancelling appointment: " + error);
                    }
                });
            });
            
            // Confirm appointment rescheduling
            $('#confirmReschedule').click(function() {
                const newDate = $('#newDate').val();
                const newTimeSlot = $('#newTimeSlot').val();
                
                if (!newDate || !newTimeSlot) {
                    alert("Please select both a date and a time slot");
                    return;
                }
                
                const formData = $('#rescheduleForm').serialize();
                
                $.ajax({
                    url: "${pageContext.request.contextPath}/appointment/reschedule",
                    type: "POST",
                    data: formData,
                    success: function(response) {
                        alert("Appointment rescheduled successfully!");
                        $('#rescheduleModal').modal('hide');
                        // Reload the page to show updated appointment details
                        location.reload();
                    },
                    error: function(xhr, status, error) {
                        alert("Error rescheduling appointment: " + error);
                    }
                });
            });
        });
        
        // Show cancel modal
        function showCancelModal() {
            $('#cancelReason').val('');
            $('#cancelModal').modal('show');
        }
        
        // Show reschedule modal
        function showRescheduleModal() {
            $('#newDate').val('');
            $('#newTimeSlot').empty().append('<option value="">Select a time slot</option>');
            $('#rescheduleReason').val('');
            $('#rescheduleModal').modal('show');
        }
    </script>
</body>
</html>