<%-- viewAppointments.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Appointments</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.min.css">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    
    <div class="container mt-4">
        <h2>Appointments</h2>
        
        <div class="row mt-3">
            <div class="col-md-6">
                <div class="input-group mb-3">
                    <span class="input-group-text">Filter by Date</span>
                    <input type="text" class="form-control datepicker" id="appointmentDate" name="appointmentDate">
                    <button class="btn btn-primary" type="button" id="filterBtn">Filter</button>
                    <button class="btn btn-secondary" type="button" id="resetBtn">Reset</button>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="appointmentType" id="all" value="all" checked>
                    <label class="form-check-label" for="all">All</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="appointmentType" id="upcoming" value="upcoming">
                    <label class="form-check-label" for="upcoming">Upcoming</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="appointmentType" id="completed" value="completed">
                    <label class="form-check-label" for="completed">Completed</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="appointmentType" id="canceled" value="canceled">
                    <label class="form-check-label" for="canceled">Canceled</label>
                </div>
            </div>
        </div>
        
        <div class="card mt-4">
            <div class="card-body">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>Appointment ID</th>
                            <th>Patient Name</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Status</th>
                            <th>Reason</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="appointmentsTable">
                        <c:forEach items="${appointments}" var="appointment">
                            <tr>
                                <td>${appointment.id}</td>
                                <td>${appointment.patientName}</td>
                                <td>${appointment.date}</td>
                                <td>${appointment.time}</td>
                                <td>
                                    <span class="badge ${appointment.status == 'Scheduled' ? 'bg-primary' : 
                                                          appointment.status == 'Completed' ? 'bg-success' : 
                                                          appointment.status == 'Canceled' ? 'bg-danger' : 
                                                          'bg-warning'}">
                                        ${appointment.status}
                                    </span>
                                </td>
                                <td>${appointment.reason}</td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <c:if test="${appointment.status == 'Scheduled'}">
                                            <button type="button" class="btn btn-sm btn-success" 
                                                    onclick="updateStatus(${appointment.id}, 'Completed')">
                                                Complete
                                            </button>
                                            <button type="button" class="btn btn-sm btn-danger"
                                                    onclick="updateStatus(${appointment.id}, 'Canceled')">
                                                Cancel
                                            </button>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/doctor/addMedicalRecord.jsp?appointmentId=${appointment.id}&patientId=${appointment.patientId}" 
                                           class="btn btn-sm btn-primary">
                                            Add Record
                                        </a>
                                        <button type="button" class="btn btn-sm btn-info"
                                                onclick="viewPatientHistory(${appointment.patientId})">
                                            Patient History
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <!-- Modal for Patient History -->
    <div class="modal fade" id="patientHistoryModal" tabindex="-1" aria-labelledby="patientHistoryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="patientHistoryModalLabel">Patient Medical History</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="patientHistoryContent">
                    <!-- Content will be loaded dynamically -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <a href="#" id="viewFullHistoryBtn" class="btn btn-primary">View Full Records</a>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../common/footer.jsp" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>
    <script>
        $(document).ready(function() {
            $('.datepicker').datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayHighlight: true
            });
            
            // Filter button click
            $('#filterBtn').click(function() {
                filterAppointments();
            });
            
            // Reset button click
            $('#resetBtn').click(function() {
                $('#appointmentDate').val('');
                $('input[name="appointmentType"][value="all"]').prop('checked', true);
                filterAppointments();
            });
            
            // Radio button change
            $('input[name="appointmentType"]').change(function() {
                filterAppointments();
            });
            
            function filterAppointments() {
                var date = $('#appointmentDate').val();
                var type = $('input[name="appointmentType"]:checked').val();
                
                // AJAX call to filter appointments
                $.ajax({
                    url: '${pageContext.request.contextPath}/doctor/filterAppointments',
                    type: 'GET',
                    data: {
                        date: date,
                        type: type
                    },
                    success: function(response) {
                        $('#appointmentsTable').html(response);
                    },
                    error: function(xhr, status, error) {
                        console.error("Error filtering appointments:", error);
                    }
                });
            }
        });
        
        function updateStatus(appointmentId, status) {
            if (confirm("Are you sure you want to mark this appointment as " + status + "?")) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/doctor/updateAppointmentStatus',
                    type: 'POST',
                    data: {
                        appointmentId: appointmentId,
                        status: status
                    },
                    success: function(response) {
                        if (response === "success") {
                            alert("Appointment status updated successfully");
                            location.reload();
                        } else {
                            alert("Failed to update appointment status");
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Error updating appointment status:", error);
                        alert("An error occurred while updating the appointment status");
                    }
                });
            }
        }
        
        function viewPatientHistory(patientId) {
            $.ajax({
                url: '${pageContext.request.contextPath}/doctor/getPatientHistory',
                type: 'GET',
                data: {
                    patientId: patientId
                },
                success: function(response) {
                    $('#patientHistoryContent').html(response);
                    $('#viewFullHistoryBtn').attr('href', '${pageContext.request.contextPath}/doctor/viewMedicalRecords.jsp?patientId=' + patientId);
                    $('#patientHistoryModal').modal('show');
                },
                error: function(xhr, status, error) {
                    console.error("Error fetching patient history:", error);
                    alert("An error occurred while fetching patient history");
                }
            });
        }
    </script>
</body>
</html>