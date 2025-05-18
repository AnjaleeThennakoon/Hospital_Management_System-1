<%-- viewMedicalRecords.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Medical Records</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <jsp:include page="../common/header.jsp" />
   
    
    <div class="container mt-4">
        <h2>Medical Records</h2>
        
        <c:if test="${empty param.patientId}">
            <div class="card mt-3 mb-4">
                <div class="card-body">
                    <form method="get" action="${pageContext.request.contextPath}/doctor/viewMedicalRecords.jsp" class="row g-3">
                        <div class="col-md-6">
                            <label for="patientSearch" class="form-label">Search Patient</label>
                            <input type="text" class="form-control" id="patientSearch" placeholder="Enter patient name, ID, or phone">
                            <input type="hidden" id="patientId" name="patientId">
                        </div>
                        <div class="col-md-4 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary">Search Records</button>
                        </div>
                    </form>
                    
                    <div id="searchResults" class="mt-2"></div>
                </div>
            </div>
            
            <div class="card">
                <div class="card-header">
                    <h5>Recent Patients</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Patient ID</th>
                                    <th>Name</th>
                                    <th>Age/Gender</th>
                                    <th>Last Visit</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${recentPatients}" var="patient">
                                    <tr>
                                        <td>${patient.id}</td>
                                        <td>${patient.name}</td>
                                        <td>${patient.age} / ${patient.gender}</td>
                                        <td>${patient.lastVisitDate}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/doctor/viewMedicalRecords.jsp?patientId=${patient.id}" class="btn btn-sm btn-primary">
                                                View Records
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:if>
        
        <c:if test="${not empty param.patientId}">
            <div class="card mb-4">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Patient Information</h5>
                    <button class="btn btn-sm btn-light" onclick="window.location.href='${pageContext.request.contextPath}/doctor/viewMedicalRecords.jsp'">
                        Back to All Patients
                    </button>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <table class="table table-bordered">
                                <tr>
                                    <th width="30%">Patient ID</th>
                                    <td>${patient.id}</td>
                                </tr>
                                <tr>
                                    <th>Name</th>
                                    <td>${patient.name}</td>
                                </tr>
                                <tr>
                                    <th>Age/Gender</th>
                                    <td>${patient.age} / ${patient.gender}</td>
                                </tr>
                                <tr>
                                    <th>Contact</th>
                                    <td>${patient.phone}</td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <table class="table table-bordered">
                                <tr>
                                    <th width="30%">Blood Group</th>
                                    <td>${patient.bloodGroup}</td>
                                </tr>
                                <tr>
                                    <th>Allergies</th>
                                    <td>${patient.allergies}</td>
                                </tr>
                                <tr>
                                    <th>Medical History</th>
                                    <td>${patient.medicalHistory}</td>
                                </tr>
                                <tr>
                                    <th>Emergency Contact</th>
                                    <td>${patient.emergencyContact}</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            
            <ul class="nav nav-tabs" id="recordTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="visits-tab" data-bs-toggle="tab" data-bs-target="#visits" type="button" role="tab" aria-controls="visits" aria-selected="true">
                        Medical Records
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="medications-tab" data-bs-toggle="tab" data-bs-target="#medications" type="button" role="tab" aria-controls="medications" aria-selected="false">
                        Medications
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="tests-tab" data-bs-toggle="tab" data-bs-target="#tests" type="button" role="tab" aria-controls="tests" aria-selected="false">
                        Lab Tests
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="timeline-tab" data-bs-toggle="tab" data-bs-target="#timeline" type="button" role="tab" aria-controls="timeline" aria-selected="false">
                        Timeline
                    </button>
                </li>
            </ul>
            
            <div class="tab-content mt-3" id="recordTabsContent">
                <!-- Medical Records Tab -->
                <div class="tab-pane fade show active" id="visits" role="tabpanel" aria-labelledby="visits-tab">
                    <div class="d-flex justify-content-end mb-3">
                        <a href="${pageContext.request.contextPath}/doctor/addMedicalRecord.jsp?patientId=${patient.id}" class="btn btn-primary">
                            <i class="bi bi-plus-circle"></i> Add New Record
                        </a>
                    </div>
                    
                    <div class="accordion" id="recordsAccordion">
                        <c:forEach items="${medicalRecords}" var="record" varStatus="status">
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="heading${status.index}">
                                    <button class="accordion-button ${status.index > 0 ? 'collapsed' : ''}" type="button" 
                                            data-bs-toggle="collapse" data-bs-target="#collapse${status.index}" 
                                            aria-expanded="${status.index == 0 ? 'true' : 'false'}" aria-controls="collapse${status.index}">
                                        <div class="d-flex w-100 justify-content-between">
                                            <span>
                                                <strong>Visit Date:</strong> ${record.visitDate} 
                                                <span class="ms-3"><strong>Diagnosis:</strong> ${record.diagnosis}</span>
                                            </span>
                                            <span class="badge bg-secondary">${record.doctor}</span>
                                        </div>
                                    </button>
                                </h2>
                                <div id="collapse${status.index}" class="accordion-collapse collapse ${status.index == 0 ? 'show' : ''}" 
                                     aria-labelledby="heading${status.index}" data-bs-parent="#recordsAccordion">
                                    <div class="accordion-body">
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <div class="card">
                                                    <div class="card-header bg-light">
                                                        <h6 class="mb-0">Symptoms</h6>
                                                    </div>
                                                    <div class="card-body">
                                                        <p>${record.symptoms}</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="card">
                                                    <div class="card-header bg-light">
                                                        <h6 class="mb-0">Diagnosis</h6>
                                                    </div>
                                                    <div class="card-body">
                                                        <p>${record.diagnosis}</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-12">
                                                <div class="card">
                                                    <div class="card-header bg-light">
                                                        <h6 class="mb-0">Notes</h6>
                                                    </div>
                                                    <div class="card-body">
                                                        <p>${record.notes}</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-12">
                                                <div class="card">
                                                    <div class="card-header bg-light">
                                                        <h6 class="mb-0">Vital Signs</h6>
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="row">
                                                            <div class="col-md-3">
                                                                <p><strong>Temperature:</strong> ${record.temperature}</p>
                                                            </div>
                                                            <div class="col-md-3">
                                                                <p><strong>Blood Pressure:</strong> ${record.bloodPressure}</p>
                                                            </div>
                                                            <div class="col-md-3">
                                                                <p><strong>Pulse:</strong> ${record.pulse}</p>
                                                            </div>
                                                            <div class="col-md-3">
                                                                <p><strong>Weight:</strong> ${record.weight}</p>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <div class="card">
                                                    <div class="card-header bg-light">
                                                        <h6 class="mb-0">Prescribed Medications</h6>
                                                    </div>
                                                    <div class="card-body">
                                                        <table class="table table-striped">
                                                            <thead>
                                                                <tr>
                                                                    <th>Medication</th>
                                                                    <th>Dosage</th>
                                                                    <th>Frequency</th>
                                                                    <th>Duration</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach items="${record.medications}" var="medication">
                                                                    <tr>
                                                                        <td>${medication.name}</td>
                                                                        <td>${medication.dosage}</td>
                                                                        <td>${medication.frequency}</td>
                                                                        <td>${medication.duration}</td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="col-md-6">
                                                <div class="card">
                                                    <div class="card-header bg-light">
                                                        <h6 class="mb-0">Lab Tests Ordered</h6>
                                                    </div>
                                                    <div class="card-body">
                                                        <table class="table table-striped">
                                                            <thead>
                                                                <tr>
                                                                    <th>Test Name</th>
                                                                    <th>Description</th>
                                                                    <th>Status</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach items="${record.labTests}" var="test">
                                                                    <tr>
                                                                        <td>${test.name}</td>
                                                                        <td>${test.description}</td>
                                                                        <td>
                                                                            <span class="badge ${test.status == 'Completed' ? 'bg-success' : 
                                                                                                test.status == 'Pending' ? 'bg-warning' : 
                                                                                                'bg-secondary'}">
                                                                                ${test.status}
                                                                            </span>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="d-flex justify-content-end">
                                                    <button type="button" class="btn btn-primary me-2" 
                                                            onclick="printRecord(${record.id})">
                                                        <i class="bi bi-printer"></i> Print
                                                    </button>
                                                    <a href="${pageContext.request.contextPath}/doctor/editMedicalRecord.jsp?recordId=${record.id}" 
                                                       class="btn btn-secondary">
                                                        <i class="bi bi-pencil"></i> Edit
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                
                <!-- Medications Tab -->
                <div class="tab-pane fade" id="medications" role="tabpanel" aria-labelledby="medications-tab">
                    <div class="card">
                        <div class="card-header bg-light">
                            <h5>Current Medications</h5>
                        </div>
                        <div class="card-body">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Medication</th>
                                        <th>Dosage</th>
                                        <th>Frequency</th>
                                        <th>Start Date</th>
                                        <th>End Date</th>
                                        <th>Prescribed By</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${currentMedications}" var="medication">
                                        <tr>
                                            <td>${medication.name}</td>
                                            <td>${medication.dosage}</td>
                                            <td>${medication.frequency}</td>
                                            <td>${medication.startDate}</td>
                                            <td>${medication.endDate}</td>
                                            <td>${medication.prescribedBy}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    
                    <div class="card mt-4">
                        <div class="card-header bg-light">
                            <h5>Medication History</h5>
                        </div>
                        <div class="card-body">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Medication</th>
                                        <th>Dosage</th>
                                        <th>Frequency</th>
                                        <th>Start Date</th>
                                        <th>End Date</th>
                                        <th>Prescribed By</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${medicationHistory}" var="medication">
                                        <tr>
                                            <td>${medication.name}</td>
                                            <td>${medication.dosage}</td>
                                            <td>${medication.frequency}</td>
                                            <td>${medication.startDate}</td>
                                            <td>${medication.endDate}</td>
                                            <td>${medication.prescribedBy}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
                <!-- Lab Tests Tab -->
                <div class="tab-pane fade" id="tests" role="tabpanel" aria-labelledby="tests-tab">
                    <div class="card">
                        <div class="card-header bg-light">
                            <h5>Lab Test Results</h5>
                        </div>
                        <div class="card-body">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Test Name</th>
                                        <th>Date</th>
                                        <th>Result</th>
                                        <th>Reference Range</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${labTests}" var="test">
                                        <tr>
                                            <td>${test.name}</td>
                                            <td>${test.date}</td>
                                            <td>${test.result}</td>
                                            <td>${test.referenceRange}</td>
                                            <td>
                                                <span class="badge ${test.status == 'Normal' ? 'bg-success' : 
                                                                    test.status == 'Abnormal' ? 'bg-warning' : 
                                                                    test.status == 'Critical' ? 'bg-danger' : 
                                                                    'bg-secondary'}">
                                                    ${test.status}
                                                </span>
                                            </td>
                                            <td>
                                                <button type="button" class="btn btn-sm btn-primary" 
                                                        onclick="viewTestResult(${test.id})">
                                                    View Details
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
                <!-- Timeline Tab -->
                <div class="tab-pane fade" id="timeline" role="tabpanel" aria-labelledby="timeline-tab">
                    <div class="card">
                        <div class="card-body">
                            <div class="timeline">
                                <c:forEach items="${timeline}" var="event">
                                    <div class="timeline-item">
                                        <div class="timeline-badge ${event.type == 'visit' ? 'bg-primary' : 
                                                                   event.type == 'test' ? 'bg-info' : 
                                                                   event.type == 'prescription' ? 'bg-success' : 
                                                                   'bg-secondary'}">
                                            <i class="bi ${event.type == 'visit' ? 'bi-person' : 
                                                         event.type == 'test' ? 'bi-clipboard-data' : 
                                                         event.type == 'prescription' ? 'bi-capsule' : 
                                                         'bi-calendar'}"></i>
                                        </div>
                                        <div class="timeline-panel">
                                            <div class="timeline-heading">
                                                <h6 class="timeline-title">${event.title}</h6>
                                                <p><small class="text-muted"><i class="bi bi-clock"></i> ${event.date}</small></p>
                                            </div>
                                            <div class="timeline-body">
                                                <p>${event.description}</p>
                                            </div>
                                            <div class="timeline-footer">
                                                <c:if test="${not empty event.link}">
                                                    <a href="${event.link}" class="btn btn-sm btn-outline-primary">View Details</a>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
    
    <!-- Test Result Modal -->
    <div class="modal fade" id="testResultModal" tabindex="-1" aria-labelledby="testResultModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="testResultModalLabel">Lab Test Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="testResultContent">
                    <!-- Content will be loaded dynamically -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="printTestBtn">Print</button>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../common/footer.jsp" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function() {
            // Patient search autocomplete
            $('#patientSearch').keyup(function() {
                var searchTerm = $(this).val();
                if (searchTerm.length > 2) {
                    $.ajax({
                        url: '${pageContext.request.contextPath}/doctor/searchPatients',
                        type: 'GET',
                        data: {
                            term: searchTerm
                        },
                        success: function(response) {
                            $('#searchResults').html(response);
                            $('#searchResults').show();
                        },
                        error: function(xhr, status, error) {
                            console.error("Error searching patients:", error);
                        }
                    });
                } else {
                    $('#searchResults').hide();
                }
            });
            
            // Handle patient selection from search results
            $(document).on('click', '.patient-result', function() {
                var patientId = $(this).data('id');
                var patientName = $(this).data('name');
                $('#patientSearch').val(patientName);
                $('#patientId').val(patientId);
                $('#searchResults').hide();
            });
            
            // Hide search results when clicking outside
            $(document).on('click', function(e) {
                if (!$(e.target).closest('#patientSearch, #searchResults').length) {
                    $('#searchResults').hide();
                }
            });
        });
        
        function viewTestResult(testId) {
            $.ajax({
                url: '${pageContext.request.contextPath}/doctor/getTestResult',
                type: 'GET',
                data: {
                    testId: testId
                },
                success: function(response) {
                    $('#testResultContent').html(response);
                    $('#testResultModal').modal('show');
                },
                error: function(xhr, status, error) {
                    console.error("Error fetching test result:", error);
                    alert("An error occurred while fetching the test result");
                }
            });
        }
        
        function printRecord(recordId) {
            window.open('${pageContext.request.contextPath}/doctor/printMedicalRecord?recordId=' + recordId, '_blank');
        }
        
        $('#printTestBtn').click(function() {
            var testId = $(this).data('test-id');
            window.open('${pageContext.request.contextPath}/doctor/printTestResult?testId=' + testId, '_blank');
        });
        
        // Timeline styling
        document.addEventListener('DOMContentLoaded', function() {
            const timelineItems = document.querySelectorAll('.timeline-item');
            timelineItems.forEach((item, index) => {
                if (index % 2 === 0) {
                    item.classList.add('timeline-item-left');
                } else {
                    item.classList.add('timeline-item-right');
                }
            });
        });
    </script>
    <style>
        /* Timeline CSS */
        .timeline {
            position: relative;
            padding: 20px 0;
        }
        
        .timeline:before {
            content: '';
            position: absolute;
            top: 0;
            bottom: 0;
            left: 50%;
            width: 4px;
            margin-left: -2px;
            background-color: #e9ecef;
        }
        
        .timeline-item {
            position: relative;
            margin-bottom: 30px;
        }
        
        .timeline-badge {
            position: absolute;
            top: 0;
            left: 50%;
            width: 40px;
            height: 40px;
            margin-left: -20px;
            border-radius: 50%;
            text-align: center;
            color: #fff;
            line-height: 40px;
            z-index: 1;
        }
        
        .timeline-panel {
            position: relative;
            width: 46%;
            padding: 20px;
            border: 1px solid #d4d4d4;
            border-radius: 5px;
            background-color: #fff;
            box-shadow: 0 1px 6px rgba(0, 0, 0, 0.1);
        }
        
        .timeline-item-left .timeline-panel {
            float: left;
        }
        
        .timeline-item-right .timeline-panel {
            float: right;
        }
        
        .timeline-item-left .timeline-panel:before {
            content: " ";
            position: absolute;
            top: 15px;
            right: -15px;
            border-top: 15px solid transparent;
            border-right: 0 solid #ccc;
            border-bottom: 15px solid transparent;
            border-left: 15px solid #ccc;
        }
        
        .timeline-item-right .timeline-panel:before {
            content: " ";
            position: absolute;
            top: 15px;
            left: -15px;
            border-top: 15px solid transparent;
            border-right: 15px solid #ccc;
            border-bottom: 15px solid transparent;
            border-left: 0 solid #ccc;
        }
        
        .timeline-title {
            margin-top: 0;
            color: inherit;
        }
        
        .timeline-body > p,
        .timeline-body > ul {
            margin-bottom: 0;
        }
        
        .timeline-body > p + p {
            margin-top: 5px;
        }
        
        /* Clear floats after each timeline item */
        .timeline-item:after {
            content: "";
            display: table;
            clear: both;
        }
    </style>
</body>
</html>