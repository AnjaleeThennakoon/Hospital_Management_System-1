<%-- addMedicalRecord.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Medical Record</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
     <link rel="stylesheet" href="style.css">
</head>
<body>
    <jsp:include page="../common/header.jsp" />
  
    
    <div class="container mt-4">
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h3>Add Medical Record</h3>
            </div>
            <div class="card-body">
                <div class="row mb-4">
                    <div class="col-md-6">
                        <h5>Patient Information</h5>
                        <table class="table table-bordered">
                            <tr>
                                <th width="30%">Name</th>
                                <td>${patient.name}</td>
                            </tr>
                            <tr>
                                <th>Age</th>
                                <td>${patient.age}</td>
                            </tr>
                            <tr>
                                <th>Gender</th>
                                <td>${patient.gender}</td>
                            </tr>
                            <tr>
                                <th>Blood Group</th>
                                <td>${patient.bloodGroup}</td>
                            </tr>
                        </table>
                    </div>
                    <div class="col-md-6">
                        <h5>Appointment Information</h5>
                        <table class="table table-bordered">
                            <tr>
                                <th width="30%">Appointment ID</th>
                                <td>${appointment.id}</td>
                            </tr>
                            <tr>
                                <th>Date</th>
                                <td>${appointment.date}</td>
                            </tr>
                            <tr>
                                <th>Time</th>
                                <td>${appointment.time}</td>
                            </tr>
                            <tr>
                                <th>Reason</th>
                                <td>${appointment.reason}</td>
                            </tr>
                        </table>
                    </div>
                </div>
                
                <form action="${pageContext.request.contextPath}/doctor/saveMedicalRecord" method="post" id="medicalRecordForm">
                    <input type="hidden" name="patientId" value="${patient.id}">
                    <input type="hidden" name="appointmentId" value="${appointment.id}">
                    <input type="hidden" name="doctorId" value="${sessionScope.doctor.id}">
                    
                    <div class="mb-3">
                        <label for="symptoms" class="form-label">Symptoms</label>
                        <textarea class="form-control" id="symptoms" name="symptoms" rows="3" required></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label for="diagnosis" class="form-label">Diagnosis</label>
                        <textarea class="form-control" id="diagnosis" name="diagnosis" rows="3" required></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label for="notes" class="form-label">Notes</label>
                        <textarea class="form-control" id="notes" name="notes" rows="3"></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Vital Signs</label>
                        <div class="row g-3">
                            <div class="col-md-3">
                                <div class="input-group">
                                    <span class="input-group-text">Temp</span>
                                    <input type="text" class="form-control" name="temperature" placeholder="°C">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="input-group">
                                    <span class="input-group-text">BP</span>
                                    <input type="text" class="form-control" name="bloodPressure" placeholder="mmHg">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="input-group">
                                    <span class="input-group-text">Pulse</span>
                                    <input type="text" class="form-control" name="pulse" placeholder="bpm">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="input-group">
                                    <span class="input-group-text">Weight</span>
                                    <input type="text" class="form-control" name="weight" placeholder="kg">
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Medications</label>
                        <div id="medicationsContainer">
                            <div class="row g-3 mb-2 medication-row">
                                <div class="col-md-3">
                                    <input type="text" class="form-control" name="medicationName[]" placeholder="Medication Name">
                                </div>
                                <div class="col-md-2">
                                    <input type="text" class="form-control" name="medicationDosage[]" placeholder="Dosage">
                                </div>
                                <div class="col-md-3">
                                    <select class="form-select" name="medicationFrequency[]">
                                        <option value="">Select Frequency</option>
                                        <option value="Once daily">Once daily</option>
                                        <option value="Twice daily">Twice daily</option>
                                        <option value="Three times daily">Three times daily</option>
                                        <option value="Four times daily">Four times daily</option>
                                        <option value="Every 4 hours">Every 4 hours</option>
                                        <option value="Every 6 hours">Every 6 hours</option>
                                        <option value="Every 8 hours">Every 8 hours</option>
                                        <option value="As needed">As needed</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <input type="text" class="form-control" name="medicationDuration[]" placeholder="Duration">
                                </div>
                                <div class="col-md-1">
                                    <button type="button" class="btn btn-danger remove-medication">
                                        <i class="bi bi-trash"></i> ✕
                                    </button>
                                </div>
                            </div>
                        </div>
                        <button type="button" class="btn btn-secondary mt-2" id="addMedicationBtn">
                            Add Medication
                        </button>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Lab Tests</label>
                        <div id="labTestsContainer">
                            <div class="row g-3 mb-2 lab-test-row">
                                <div class="col-md-5">
                                    <input type="text" class="form-control" name="testName[]" placeholder="Test Name">
                                </div>
                                <div class="col-md-6">
                                    <input type="text" class="form-control" name="testDescription[]" placeholder="Description">
                                </div>
                                <div class="col-md-1">
                                    <button type="button" class="btn btn-danger remove-test">
                                        <i class="bi bi-trash"></i> ✕
                                    </button>
                                </div>
                            </div>
                        </div>
                        <button type="button" class="btn btn-secondary mt-2" id="addLabTestBtn">
                            Add Lab Test
                        </button>
                    </div>
                    
                    <div class="mb-3">
                        <label for="followUpDate" class="form-label">Follow-Up Date (if necessary)</label>
                        <input type="date" class="form-control" id="followUpDate" name="followUpDate">
                    </div>
                    
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <button type="button" class="btn btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/doctor/viewAppointments.jsp'">
                            Cancel
                        </button>
                        <button type="submit" class="btn btn-primary">Save Medical Record</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <jsp:include page="../common/footer.jsp" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function() {
            // Add medication
            $('#addMedicationBtn').click(function() {
                var newRow = $('.medication-row:first').clone();
                newRow.find('input').val('');
                newRow.find('select').val('');
                $('#medicationsContainer').append(newRow);
            });
            
            // Remove medication
            $(document).on('click', '.remove-medication', function() {
                if ($('.medication-row').length > 1) {
                    $(this).closest('.medication-row').remove();
                } else {
                    $('.medication-row:first').find('input').val('');
                    $('.medication-row:first').find('select').val('');
                }
            });
            
            // Add lab test
            $('#addLabTestBtn').click(function() {
                var newRow = $('.lab-test-row:first').clone();
                newRow.find('input').val('');
                $('#labTestsContainer').append(newRow);
            });
            
            // Remove lab test
            $(document).on('click', '.remove-test', function() {
                if ($('.lab-test-row').length > 1) {
                    $(this).closest('.lab-test-row').remove();
                } else {
                    $('.lab-test-row:first').find('input').val('');
                }
            });
            
            // Form submission validation
            $('#medicalRecordForm').submit(function(e) {
                if ($('#symptoms').val().trim() === '' || $('#diagnosis').val().trim() === '') {
                    alert('Symptoms and Diagnosis are required fields');
                    e.preventDefault();
                }
            });
        });
    </script>
</body>
</html>