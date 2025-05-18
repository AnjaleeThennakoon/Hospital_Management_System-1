<%-- doctorDashboard.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doctor Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
     <link rel="stylesheet" href="style.css">
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    
    <div class="container mt-4">
        <h2>Welcome, Dr. ${sessionScope.doctor.name}</h2>
        
        <div class="row mt-4">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Today's Appointments</h5>
                        <p class="card-text">You have ${todayAppointmentsCount} appointments scheduled for today.</p>
                        <a href="${pageContext.request.contextPath}/doctor/viewAppointments.jsp" class="btn btn-primary">View Appointments</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Medical Records</h5>
                        <p class="card-text">Manage your patients' medical records and add new entries.</p>
                        <a href="${pageContext.request.contextPath}/doctor/viewMedicalRecords.jsp" class="btn btn-primary">View Records</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">My Profile</h5>
                        <p class="card-text">View and update your profile information.</p>
                        <a href="${pageContext.request.contextPath}/doctor/profile.jsp" class="btn btn-primary">My Profile</a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5>Recent Patient Activity</h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Patient</th>
                                    <th>Activity</th>
                                    <th>Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${recentActivity}" var="activity">
                                    <tr>
                                        <td>${activity.patientName}</td>
                                        <td>${activity.description}</td>
                                        <td>${activity.date}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/doctor/viewMedicalRecords.jsp?patientId=${activity.patientId}" class="btn btn-sm btn-info">View Records</a>
                                        </td>
                                    </tr>
                                </c:forEach>
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