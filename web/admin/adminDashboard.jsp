<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Hospital Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .dashboard-card {
            transition: transform 0.3s;
            margin-bottom: 20px;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .card-icon {
            font-size: 48px;
            color: #0d6efd;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    

    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col">
                <h2><i class="fas fa-tachometer-alt"></i> Admin Dashboard</h2>
                <p class="text-muted">Welcome, <c:out value="${sessionScope.adminName}" />! Manage your hospital system here.</p>
            </div>
        </div>
        
        <div class="row">
            <!-- Statistics Summary -->
            <div class="col-lg-12 mb-4">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-chart-line"></i> System Overview</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 text-center">
                                <h2><c:out value="${doctorCount}" default="0" /></h2>
                                <p class="text-muted">Doctors</p>
                            </div>
                            <div class="col-md-3 text-center">
                                <h2><c:out value="${patientCount}" default="0" /></h2>
                                <p class="text-muted">Patients</p>
                            </div>
                            <div class="col-md-3 text-center">
                                <h2><c:out value="${appointmentCount}" default="0" /></h2>
                                <p class="text-muted">Appointments</p>
                            </div>
                            <div class="col-md-3 text-center">
                                <h2><c:out value="${billCount}" default="0" /></h2>
                                <p class="text-muted">Bills</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <!-- Quick Access Cards -->
            <div class="col-md-4">
                <div class="card dashboard-card shadow">
                    <div class="card-body text-center py-4">
                        <div class="card-icon mb-3">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <h5 class="card-title">Doctor Management</h5>
                        <p class="card-text">Add, view, or manage hospital doctors</p>
                        <div class="mt-4">
                            <a href="addDoctor.jsp" class="btn btn-outline-primary me-2">Add Doctor</a>
                            <a href="viewDoctors.jsp" class="btn btn-primary">View All</a>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card dashboard-card shadow">
                    <div class="card-body text-center py-4">
                        <div class="card-icon mb-3">
                            <i class="fas fa-hospital-user"></i>
                        </div>
                        <h5 class="card-title">Patient Management</h5>
                        <p class="card-text">Add, view, or manage hospital patients</p>
                        <div class="mt-4">
                            <a href="addPatient.jsp" class="btn btn-outline-primary me-2">Add Patient</a>
                            <a href="viewPatients.jsp" class="btn btn-primary">View All</a>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card dashboard-card shadow">
                    <div class="card-body text-center py-4">
                        <div class="card-icon mb-3">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <h5 class="card-title">Appointment Management</h5>
                        <p class="card-text">View and manage all appointments</p>
                        <div class="mt-4">
                            <a href="viewAppointments.jsp" class="btn btn-primary">View All</a>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card dashboard-card shadow">
                    <div class="card-body text-center py-4">
                        <div class="card-icon mb-3">
                            <i class="fas fa-file-invoice-dollar"></i>
                        </div>
                        <h5 class="card-title">Billing Management</h5>
                        <p class="card-text">Generate and view patient bills</p>
                        <div class="mt-4">
                            <a href="generateBill.jsp" class="btn btn-outline-primary me-2">Generate Bill</a>
                            <a href="viewBills.jsp" class="btn btn-primary">View All</a>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card dashboard-card shadow">
                    <div class="card-body text-center py-4">
                        <div class="card-icon mb-3">
                            <i class="fas fa-cog"></i>
                        </div>
                        <h5 class="card-title">System Settings</h5>
                        <p class="card-text">Manage hospital system settings</p>
                        <div class="mt-4">
                            <a href="#" class="btn btn-primary">Manage Settings</a>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card dashboard-card shadow">
                    <div class="card-body text-center py-4">
                        <div class="card-icon mb-3">
                            <i class="fas fa-chart-bar"></i>
                        </div>
                        <h5 class="card-title">Reports</h5>
                        <p class="card-text">Generate and view various reports</p>
                        <div class="mt-4">
                            <a href="#" class="btn btn-primary">View Reports</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Recent Activity Section -->
        <div class="row mt-4">
            <div class="col-lg-12">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-history"></i> Recent Activity</h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Activity</th>
                                    <th>User</th>
                                    <th>Time</th>
                                    <th>Details</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${recentActivities}" var="activity">
                                    <tr>
                                        <td><c:out value="${activity.type}" /></td>
                                        <td><c:out value="${activity.user}" /></td>
                                        <td><c:out value="${activity.time}" /></td>
                                        <td><c:out value="${activity.details}" /></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentActivities}">
                                    <tr>
                                        <td colspan="4" class="text-center">No recent activities</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>