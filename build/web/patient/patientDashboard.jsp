<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4e73df;
            --secondary-color: #1cc88a;
            --light-color: #f8f9fc;
            --dark-color: #5a5c69;
        }
        
        body {
            background-color: #f8f9fc;
            font-family: 'Nunito', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
        }
        
        .dashboard-container {
            padding: 20px;
            margin-top: 20px;
        }
        
        .welcome-header {
            color: var(--dark-color);
            margin-bottom: 30px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e3e6f0;
        }
        
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            transition: transform 0.3s ease;
            height: 100%;
        }
        
        .card:hover {
            transform: translateY(-5px);
        }
        
        .card-body {
            padding: 1.5rem;
        }
        
        .card-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--dark-color);
        }
        
        .card-text {
            color: #858796;
            font-size: 0.9rem;
            margin-bottom: 1.2rem;
        }
        
        .btn-card {
            width: 100%;
            margin-bottom: 0.5rem;
            padding: 0.5rem;
            font-size: 0.85rem;
        }
        
        .section-card {
            margin-bottom: 30px;
            border: none;
            border-radius: 10px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }
        
        .card-header {
            background-color: #f8f9fc;
            border-bottom: 1px solid #e3e6f0;
            padding: 1rem 1.5rem;
            font-weight: 600;
            color: var(--dark-color);
        }
        
        .table {
            margin-bottom: 0;
        }
        
        .table th {
            border-top: none;
            font-weight: 600;
            color: var(--dark-color);
        }
        
        .badge {
            font-size: 0.75em;
            font-weight: 600;
            padding: 0.35em 0.65em;
        }
        
        .action-btn {
            margin-right: 5px;
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
        }
        
        @media (max-width: 768px) {
            .dashboard-container {
                padding: 10px;
            }
            
            .card-body {
                padding: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Include header and navbar -->
    <jsp:include page="../common/header.jsp" />
    
    <div class="container dashboard-container">
        <h2 class="welcome-header">
            Welcome, 
            <c:choose>
                <c:when test="${not empty sessionScope.patientName}">
                    ${sessionScope.patientName}
                </c:when>
                <c:otherwise>
                    Patient
                </c:otherwise>
            </c:choose>
        </h2>
        
        <div class="row">
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card">
                    <div class="card-body text-center">
                        <h5 class="card-title">Appointments</h5>
                        <p class="card-text">View or book your appointments</p>
                        <a href="${pageContext.request.contextPath}/patient/viewAppointments" class="btn btn-primary btn-card">View Appointments</a>
                        <a href="${pageContext.request.contextPath}/patient/bookAppointment" class="btn btn-success btn-card">Book New</a>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card">
                    <div class="card-body text-center">
                        <h5 class="card-title">Medical Records</h5>
                        <p class="card-text">Access your medical history</p>
                        <a href="${pageContext.request.contextPath}/patient/viewMedicalRecords" class="btn btn-primary btn-card">View Records</a>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card">
                    <div class="card-body text-center">
                        <h5 class="card-title">Billing</h5>
                        <p class="card-text">View your bills and payments</p>
                        <a href="${pageContext.request.contextPath}/patient/viewBills" class="btn btn-primary btn-card">View Bills</a>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card">
                    <div class="card-body text-center">
                        <h5 class="card-title">Profile</h5>
                        <p class="card-text">Update your personal information</p>
                        <a href="${pageContext.request.contextPath}/patient/profile" class="btn btn-primary btn-card">Edit Profile</a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Upcoming Appointments Section -->
        <div class="row">
            <div class="col-12">
                <div class="card section-card">
                    <div class="card-header">
                        <h4>Upcoming Appointments</h4>
                    </div>
                    <div class="card-body">
                        <c:if test="${empty upcomingAppointments}">
                            <div class="alert alert-info">You have no upcoming appointments.</div>
                        </c:if>
                        <c:if test="${not empty upcomingAppointments}">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Time</th>
                                            <th>Doctor</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${upcomingAppointments}" var="appointment">
                                            <tr>
                                                <td>${appointment.appointmentDate}</td>
                                                <td>${appointment.appointmentTime}</td>
                                                <td>Dr. ${appointment.doctorName}</td>
                                                <td>
                                                    <span class="badge bg-${appointment.status == 'CONFIRMED' ? 'success' : appointment.status == 'PENDING' ? 'warning' : 'danger'}">
                                                        ${appointment.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/appointment/view?id=${appointment.appointmentId}" 
                                                       class="btn btn-sm btn-info action-btn">View</a>
                                                    <c:if test="${appointment.status != 'CANCELLED'}">
                                                        <button class="btn btn-sm btn-danger action-btn" 
                                                            onclick="cancelAppointment(${appointment.appointmentId})">Cancel</button>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Recent Medical Records Section -->
        <div class="row">
            <div class="col-12">
                <div class="card section-card">
                    <div class="card-header">
                        <h4>Recent Medical Records</h4>
                    </div>
                    <div class="card-body">
                        <c:if test="${empty recentMedicalRecords}">
                            <div class="alert alert-info">No recent medical records available.</div>
                        </c:if>
                        <c:if test="${not empty recentMedicalRecords}">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Doctor</th>
                                            <th>Diagnosis</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${recentMedicalRecords}" var="record">
                                            <tr>
                                                <td>${record.recordDate}</td>
                                                <td>Dr. ${record.doctorName}</td>
                                                <td>${record.diagnosis}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/patient/viewMedicalRecord?id=${record.recordId}" 
                                                       class="btn btn-sm btn-info action-btn">View Details</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
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
    
    <script>
        function cancelAppointment(appointmentId) {
            if (confirm("Are you sure you want to cancel this appointment?")) {
                $.ajax({
                    url: "${pageContext.request.contextPath}/appointment/update",
                    type: "POST",
                    data: { 
                        appointmentId: appointmentId,
                        status: "CANCELLED"
                    },
                    success: function(response) {
                        alert("Appointment cancelled successfully!");
                        location.reload();
                    },
                    error: function(xhr, status, error) {
                        alert("Error cancelling appointment: " + error);
                    }
                });
            }
        }
    </script>
</body>
</html>