<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Patients - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/datatables.net-bs5@1.13.4/css/dataTables.bootstrap5.min.css">
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    
    
    <div class="container mt-4">
        <div class="card">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h2>Patient Directory</h2>
                <a href="${pageContext.request.contextPath}/admin/addPatient.jsp" class="btn btn-light">
                    <i class="bi bi-person-plus"></i> Add New Patient
                </a>
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
                
                <div class="table-responsive">
                    <table id="patientsTable" class="table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Gender</th>
                                <th>Age</th>
                                <th>Contact Number</th>
                                <th>Blood Group</th>
                                <th>Last Visit</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${patients}" var="patient">
                                <tr>
                                    <td>${patient.patientId}</td>
                                    <td>${patient.firstName} ${patient.lastName}</td>
                                    <td>${patient.gender}</td>
                                    <td>
                                        <c:set var="now" value="<%=new java.util.Date()%>" />
                                        <fmt:parseDate value="${patient.dob}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                        <fmt:formatDate value="${parsedDate}" pattern="yyyy" var="birthYear" />
                                        <fmt:formatDate value="${now}" pattern="yyyy" var="currentYear" />
                                        ${currentYear - birthYear}
                                    </td>
                                    <td>${patient.contactNumber}</td>
                                    <td>${patient.bloodGroup}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty patient.lastVisitDate}">
                                                <fmt:formatDate value="${patient.lastVisitDate}" pattern="dd-MMM-yyyy" />
                                            </c:when>
                                            <c:otherwise>
                                                No previous visits
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="dropdown">
                                            <button class="btn btn-sm btn-secondary dropdown-toggle" type="button" id="patientActions${patient.patientId}" data-bs-toggle="dropdown" aria-expanded="false">
                                                Actions
                                            </button>
                                            <ul class="dropdown-menu" aria-labelledby="patientActions${patient.patientId}">
                                                <li>
                                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/viewPatientDetails?id=${patient.patientId}">
                                                        <i class="bi bi-eye"></i> View Details
                                                    </a>
                                                </li>
                                                <li>
                                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/editPatient?id=${patient.patientId}">
                                                        <i class="bi bi-pencil"></i> Edit
                                                    </a>
                                                </li>
                                                <li>
                                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/viewPatientMedicalRecords?id=${patient.patientId}">
                                                        <i class="bi bi-file-medical"></i> Medical Records
                                                    </a>
                                                </li>
                                                <li>
                                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/patientAppointments?id=${patient.patientId}">
                                                        <i class="bi bi-calendar-check"></i> Appointments
                                                    </a>
                                                </li>
                                                <li>
                                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/generateBill?patientId=${patient.patientId}">
                                                        <i class="bi bi-receipt"></i> Generate Bill
                                                    </a>
                                                </li>
                                                <li><hr class="dropdown-divider"></li>
                                                <li>
                                                    <button class="dropdown-item text-danger" type="button" 
                                                            onclick="confirmDelete(${patient.patientId}, '${patient.firstName} ${patient.lastName}')">
                                                        <i class="bi bi-trash"></i> Delete
                                                    </button>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deletePatientModal" tabindex="-1" aria-labelledby="deletePatientModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deletePatientModalLabel">Confirm Patient Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete the patient record for <strong id="patientNameToDelete"></strong>?</p>
                    <p class="text-danger">This action cannot be undone. All related medical records, appointments, and bills will also be deleted.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deletePatientForm" action="${pageContext.request.contextPath}/admin/deletePatient" method="post">
                        <input type="hidden" id="patientIdToDelete" name="patientId" value="">
                        <button type="submit" class="btn btn-danger">Delete Patient</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/common/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/datatables.net@1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/datatables.net-bs5@1.13.4/js/dataTables.bootstrap5.min.js"></script>
    
    <script>
        $(document).ready(function() {
            $('#patientsTable').DataTable({
                "order": [[0, "desc"]], // Sort by ID descending
                "pageLength": 10,
                "language": {
                    "search": "Search patients:",
                    "lengthMenu": "Show _MENU_ patients per page",
                    "info": "Showing _START_ to _END_ of _TOTAL_ patients",
                    "infoEmpty": "No patients found",
                    "infoFiltered": "(filtered from _MAX_ total patients)"
                }
            });
        });
        
        function confirmDelete(patientId, patientName) {
            document.getElementById('patientIdToDelete').value = patientId;
            document.getElementById('patientNameToDelete').innerText = patientName;
            
            // Show modal
            var deleteModal = new bootstrap.Modal(document.getElementById('deletePatientModal'));
            deleteModal.show();
        }
    </script>
</body>
</html>