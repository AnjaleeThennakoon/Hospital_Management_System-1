<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Medical Records</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet">
</head>
<body>
    <!-- Include header and navbar -->
    <jsp:include page="../common/header.jsp" />
  
    
    <div class="container mt-4">
        <h2>My Medical Records</h2>
        
        <!-- Filter options -->
        <div class="card mb-4">
            <div class="card-header">
                <h5>Filter Records</h5>
            </div>
            <div class="card-body">
                <form id="filterForm" class="row g-3">
                    <div class="col-md-4">
                        <label for="doctorFilter" class="form-label">Doctor</label>
                        <select class="form-select" id="doctorFilter">
                            <option value="">All Doctors</option>
                            <c:forEach items="${doctors}" var="doctor">
                                <option value="${doctor.id}">Dr. ${doctor.firstName} ${doctor.lastName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="fromDate" class="form-label">From Date</label>
                        <input type="date" class="form-control" id="fromDate">
                    </div>
                    <div class="col-md-4">
                        <label for="toDate" class="form-label">To Date</label>
                        <input type="date" class="form-control" id="toDate">
                    </div>
                    <div class="col-12 mt-3">
                        <button type="button" id="applyFilter" class="btn btn-primary">Apply Filters</button>
                        <button type="button" id="resetFilter" class="btn btn-secondary">Reset</button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Medical Records Table -->
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table id="medicalRecordsTable" class="table table-striped">
                        <thead>
                            <tr>
                                <th>Record ID</th>
                                <th>Date</th>
                                <th>Doctor</th>
                                <th>Department</th>
                                <th>Diagnosis</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${medicalRecords}" var="record">
                                <tr>
                                    <td>${record.id}</td>
                                    <td>${record.date}</td>
                                    <td>Dr. ${record.doctor.firstName} ${record.doctor.lastName}</td>
                                    <td>${record.doctor.department}</td>
                                    <td>${record.diagnosis}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/patient/viewMedicalRecordDetails.jsp?id=${record.id}" 
                                           class="btn btn-sm btn-info">View Details</a>
                                        <a href="${pageContext.request.contextPath}/medicalrecord/download?id=${record.id}" 
                                           class="btn btn-sm btn-secondary">Download PDF</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Include footer -->
    <jsp:include page="../common/footer.jsp" />
    
    <!-- Bootstrap JS and jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Initialize DataTable
            const medicalRecordsTable = $('#medicalRecordsTable').DataTable({
                order: [[1, 'desc']], // Sort by date (column 1) in descending order
                language: {
                    emptyTable: "No medical records found",
                    zeroRecords: "No matching medical records found"
                },
                pageLength: 10,
                responsive: true
            });
            
            // Apply filters
            $('#applyFilter').click(function() {
                applyFilters();
            });
            
            // Reset filters
            $('#resetFilter').click(function() {
                $('#filterForm')[0].reset();
                applyFilters();
            });
            
            function applyFilters() {
                const doctorId = $('#doctorFilter').val();
                const fromDate = $('#fromDate').val();
                const toDate = $('#toDate').val();
                
                // AJAX call to get filtered medical records
                $.ajax({
                    url: "${pageContext.request.contextPath}/medicalrecord/getFilteredRecords",
                    type: "GET",
                    data: {
                        doctorId: doctorId,
                        fromDate: fromDate,
                        toDate: toDate
                    },
                    dataType: "json",
                    success: function(data) {
                        // Clear and reload the table with new data
                        medicalRecordsTable.clear();
                        
                        $.each(data, function(index, record) {
                            const actions = `
                                <a href="${pageContext.request.contextPath}/patient/viewMedicalRecordDetails.jsp?id=${record.id}" 
                                   class="btn btn-sm btn-info">View Details</a>
                                <a href="${pageContext.request.contextPath}/medicalrecord/download?id=${record.id}" 
                                   class="btn btn-sm btn-secondary">Download PDF</a>
                            `;
                            
                            medicalRecordsTable.row.add([
                                record.id,
                                record.date,
                                `Dr. ${record.doctor.firstName} ${record.doctor.lastName}`,
                                record.doctor.department,
                                record.diagnosis,
                                actions
                            ]);
                        });
                        
                        medicalRecordsTable.draw();
                    },
                    error: function(xhr, status, error) {
                        console.error("Error loading medical records: " + error);
                        alert("Failed to load medical records. Please try again.");
                    }
                });
            }
        });
    </script>
</body>
</html>