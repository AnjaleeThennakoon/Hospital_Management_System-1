<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Appointments | Hospital Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css">
    <style>
        .status-confirmed {
            color: #198754;
        }
        .status-pending {
            color: #ffc107;
        }
        .status-cancelled {
            color: #dc3545;
        }
        .status-completed {
            color: #0d6efd;
        }
        .appointment-card {
            transition: transform 0.3s;
        }
        .appointment-card:hover {
            transform: translateY(-5px);
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    

    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="adminDashboard.jsp">Dashboard</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Appointments</li>
                    </ol>
                </nav>
                <h2><i class="fas fa-calendar-check"></i> Appointment Management</h2>
                <p class="text-muted">View and manage all appointments in the system.</p>
            </div>
        </div>
        
        <!-- Alert for success or error messages -->
        <c:if test="${not empty message}">
            <div class="alert alert-${messageType} alert-dismissible fade show" role="alert">
                <strong>${messageHeader}!</strong> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        
        <!-- Filters and Search -->
        <div class="row mb-4">
            <div class="col-md-8">
                <div class="input-group">
                    <input type="text" id="searchAppointment" class="form-control" placeholder="Search by patient name, doctor name, or ID...">
                    <button class="btn btn-outline-secondary" type="button">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </div>
            <div class="col-md-4 text-md-end">
                <div class="btn-group" role="group">
                    <button type="button" class="btn btn-primary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-filter"></i> Filter By Status
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="#" data-status="all">All Appointments</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="#" data-status="confirmed">Confirmed</a></li>
                        <li><a class="dropdown-item" href="#" data-status="pending">Pending</a></li>
                        <li><a class="dropdown-item" href="#" data-status="cancelled">Cancelled</a></li>
                        <li><a class="dropdown-item" href="#" data-status="completed">Completed</a></li>
                    </ul>
                </div>
                
                <div class="btn-group ms-2" role="group">
                    <button type="button" class="btn btn-outline-primary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-calendar"></i> Filter By Date
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="#" data-date="all">All Dates</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="#" data-date="today">Today</a></li>
                        <li><a class="dropdown-item" href="#" data-date="tomorrow">Tomorrow</a></li>
                        <li><a class="dropdown-item" href="#" data-date="thisweek">This Week</a></li>
                        <li><a class="dropdown-item" href="#" data-date="nextweek">Next Week</a></li>
                        <li><a class="dropdown-item" href="#" data-date="thismonth">This Month</a></li>
                    </ul>
                </div>
            </div>
        </div>
        
        <!-- View Type Selector -->
        <div class="row mb-4">
            <div class="col">
                <div class="btn-group" role="group" aria-label="View Type">
                    <input type="radio" class="btn-check" name="viewType" id="tableView" checked>
                    <label class="btn btn-outline-primary" for="tableView">
                        <i class="fas fa-table"></i> Table View
                    </label>
                    
                    <input type="radio" class="btn-check" name="viewType" id="cardView">
                    <label class="btn btn-outline-primary" for="cardView">
                        <i class="fas fa-th-large"></i> Card View
                    </label>
                    
                    <input type="radio" class="btn-check" name="viewType" id="calendarView">
                    <label class="btn btn-outline-primary" for="calendarView">
                        <i class="fas fa-calendar-alt"></i> Calendar View
                    </label>
                </div>
                
                <a href="#" class="btn btn-outline-success ms-2" data-bs-toggle="modal" data-bs-target="#exportModal">
                    <i class="fas fa-file-export"></i> Export
                </a>
                
                <a href="#" class="btn btn-outline-info ms-2" data-bs-toggle="modal" data-bs-target="#printModal">
                    <i class="fas fa-print"></i> Print
                </a>
            </div>
        </div>
        
        <!-- Table View -->
        <div id="tableViewContent" class="view-content">
            <div class="card shadow">
                <div class="card-body">
                    <table id="appointmentsTable" class="table table-striped table-hover">
                        <thead class="table-primary">
                            <tr>
                                <th>ID</th>
                                <th>Patient</th>
                                <th>Doctor</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Status</th>
                                <th>Type</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${appointments}" var="appointment" varStatus="loop">
                                <tr>
                                    <td>${appointment.id}</td>
                                    <td>${appointment.patientName}</td>
                                    <td>${appointment.doctorName}</td>
                                    <td>
                                        <fmt:formatDate value="${appointment.appointmentDate}" pattern="dd-MM-yyyy" />
                                    </td>
                                    <td>${appointment.appointmentTime}</td>
                                    <td>
                                        <span class="badge rounded-pill 
                                            ${appointment.status == 'Confirmed' ? 'bg-success' : 
                                              appointment.status == 'Pending' ? 'bg-warning text-dark' : 
                                              appointment.status == 'Cancelled' ? 'bg-danger' : 
                                              appointment.status == 'Completed' ? 'bg-primary' : 'bg-secondary'}">
                                            ${appointment.status}
                                        </span>
                                    </td>
                                    <td>${appointment.appointmentType}</td>
                                    <td>
                                        <div class="dropdown">
                                            <button class="btn btn-sm btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton${loop.index}" data-bs-toggle="dropdown" aria-expanded="false">
                                                Actions
                                            </button>
                                            <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton${loop.index}">
                                                <li>
                                                    <a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#viewAppointmentModal${appointment.id}">
                                                        <i class="fas fa-eye"></i> View Details
                                                    </a>
                                                </li>
                                                <li>
                                                    <a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#editAppointmentModal${appointment.id}">
                                                        <i class="fas fa-edit"></i> Edit
                                                    </a>
                                                </li>
                                                <li>
                                                    <a class="dropdown-item text-success" href="#" onclick="updateStatus(${appointment.id}, 'Confirmed')">
                                                        <i class="fas fa-check-circle"></i> Confirm
                                                    </a>
                                                </li>
                                                <li>
                                                    <a class="dropdown-item text-primary" href="#" onclick="updateStatus(${appointment.id}, 'Completed')">
                                                        <i class="fas fa-check-double"></i> Mark as Completed
                                                    </a>
                                                </li>
                                                <li>
                                                    <a class="dropdown-item text-danger" href="#" onclick="updateStatus(${appointment.id}, 'Cancelled')">
                                                        <i class="fas fa-times-circle"></i> Cancel
                                                    </a>
                                                </li>
                                                <li><hr class="dropdown-divider"></li>
                                                <li>
                                                    <a class="dropdown-item" href="generateBill.jsp?appointmentId=${appointment.id}">
                                                        <i class="fas fa-file-invoice-dollar"></i> Generate Bill
                                                    </a>
                                                </li>
                                                <li>
                                                    <a class="dropdown-item" href="#" onclick="deleteAppointment(${appointment.id})">
                                                        <i class="fas fa-trash-alt"></i> Delete
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <!-- Sample data for preview purposes -->
                            <tr>
                                <td>APT-001</td>
                                <td>John Smith</td>
                                <td>Dr. Sarah Johnson</td>
                                <td>10-05-2025</td>
                                <td>10:00 AM</td>
                                <td><span class="badge rounded-pill bg-success">Confirmed</span></td>
                                <td>Consultation</td>
                                <td>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                            Actions
                                        </button>
                                        <ul class="dropdown-menu">
                                            <li><a class="dropdown-item" href="#"><i class="fas fa-eye"></i> View Details</a></li>
                                            <li><a class="dropdown-item" href="#"><i class="fas fa-edit"></i> Edit</a></li>
                                            <li><a class="dropdown-item text-success" href="#"><i class="fas fa-check-circle"></i> Confirm</a></li>
                                            <li><a class="dropdown-item text-primary" href="#"><i class="fas fa-check-double"></i> Mark as Completed</a></li>
                                            <li><a class="dropdown-item text-danger" href="#"><i class="fas fa-times-circle"></i> Cancel</a></li>
                                            <li><hr class="dropdown-divider"></li>
                                            <li><a class="dropdown-item" href="generateBill.jsp?appointmentId=APT-001"><i class="fas fa-file-invoice-dollar"></i> Generate Bill</a></li>
                                            <li><a class="dropdown-item" href="#"><i class="fas fa-trash-alt"></i> Delete</a></li>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>APT-002</td>
                                <td>Emily Johnson</td>
                                <td>Dr. Michael Lee</td>
                                <td>10-05-2025</td>
                                <td>11:30 AM</td>
                                <td><span class="badge rounded-pill bg-warning text-dark">Pending</span></td>
                                <td>Follow-up</td>
                                <td>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                            Actions
                                        </button>
                                        <ul class="dropdown-menu">
                                            <li><a class="dropdown-item" href="#"><i class="fas fa-eye"></i> View Details</a></li>
                                            <li><a class="dropdown-item" href="#"><i class="fas fa-edit"></i> Edit</a></li>
                                            <li><a class="dropdown-item text-success" href="#"><i class="fas fa-check-circle"></i> Confirm</a></li>
                                            <li><a class="dropdown-item text-primary" href="#"><i class="fas fa-check-double"></i> Mark as Completed</a></li>
                                            <li><a class="dropdown-item text-danger" href="#"><i class="fas fa-times-circle"></i> Cancel</a></li>
                                            <li><hr class="dropdown-divider"></li>
                                            <li><a class="dropdown-item" href="generateBill.jsp?appointmentId=APT-002"><i class="fas fa-file-invoice-dollar"></i> Generate Bill</a></li>
                                            <li><a class="dropdown-item" href="#"><i class="fas fa-trash-alt"></i> Delete</a></li>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>APT-003</td>
                                <td>David Wilson</td>
                                <td>Dr. Jessica Chen</td>
                                <td>11-05-2025</td>
                                <td>9:15 AM</td>
                                <td><span class="badge rounded-pill bg-primary">Completed</span></td>
                                <td>Check-up</td>
                                <td>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                            Actions
                                        </button>
                                        <ul class="dropdown-menu">
                                            <li><a class="dropdown-item" href="#"><i class="fas fa-eye"></i> View Details</a></li>
                                            <li><a class="dropdown-item" href="#"><i class="fas fa-edit"></i> Edit</a></li>
                                            <li><a class="dropdown-item text-success" href="#"><i class="fas fa-check-circle"></i> Confirm</a></li>
                                            <li><a class="dropdown-item text-primary" href="#"><i class="fas fa-check-double"></i> Mark as Completed</a></li>
                                            <li><a class="dropdown-item text-danger" href="#"><i class="fas fa-times-circle"></i> Cancel</a></li>
                                            <li><hr class="dropdown-divider"></li>
                                            <li><a class="dropdown-item" href="generateBill.jsp?appointmentId=APT-003"><i class="fas fa-file-invoice-dollar"></i> Generate Bill</a></li>
                                            <li><a class="dropdown-item" href="#"><i class="fas fa-trash-alt"></i> Delete</a></li>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>APT-004</td>
                                <td>Sarah Brown</td>
                                <td>Dr. Robert Garcia</td>
                                <td>11-05-2025</td>
                                <td>2:45 PM</td>
                                <td><span class="badge rounded-pill bg-danger">Cancelled</span></td>
                                <td>Consultation</td>
                                <td>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                            Actions
                                        </button>
                                        <ul class="dropdown-menu">
                                            <li><a class="dropdown-item" href="#"><i class="fas fa-eye"></i> View Details</a></li>
                                            <li><a class="dropdown-item" href="#"><i class="fas fa-edit"></i> Edit</a></li>
                                            <li><a class="dropdown-item text-success" href="#"><i class="fas fa-check-circle"></i> Confirm</a></li>
                                            <li><a class="dropdown-item text-primary" href="#"><i class="fas fa-check-double"></i> Mark as Completed</a></li>
                                            <li><a class="dropdown-item text-danger" href="#"><i class="fas fa-times-circle"></i> Cancel</a></li>
                                            <li><hr class="dropdown-divider"></li>
                                            <li><a class="dropdown-item" href="generateBill.jsp?appointmentId=APT-004"><i class="fas fa-file-invoice-dollar"></i> Generate Bill</a></li>
                                            <li><a class="dropdown-item" href="#"><i class="fas fa-trash-alt"></i> Delete</a></li>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <!-- Card View (Initially Hidden) -->
        <div id="cardViewContent" class="view-content" style="display: none;">
            <div class="row">
                <!-- Sample data for preview purposes -->
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card appointment-card shadow">
                        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">APT-001</h5>
                            <span class="badge rounded-pill bg-success">Confirmed</span>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <h6 class="text-muted mb-1">Patient</h6>
                                    <p class="mb-0"><i class="fas fa-user me-2"></i> John Smith</p>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <h6 class="text-muted mb-1">Doctor</h6>
                                    <p class="mb-0"><i class="fas fa-user-md me-2"></i> Dr. Sarah Johnson</p>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <h6 class="text-muted mb-1">Date</h6>
                                    <p class="mb-0"><i class="fas fa-calendar-day me-2"></i> 10-05-2025</p>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-muted mb-1">Time</h6>
                                    <p class="mb-0"><i class="fas fa-clock me-2"></i> 10:00 AM</p>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <h6 class="text-muted mb-1">Type</h6>
                                    <p class="mb-0"><i class="fas fa-stethoscope me-2"></i> Consultation</p>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer">
                            <div class="d-flex justify-content-between">
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="tooltip" title="View Details">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="tooltip" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-success" data-bs-toggle="tooltip" title="Mark as Completed">
                                        <i class="fas fa-check-double"></i>
                                    </button>
                                </div>
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-sm btn-outline-danger" data-bs-toggle="tooltip" title="Cancel">
                                        <i class="fas fa-times-circle"></i>
                                    </button>
                                    <a href="generateBill.jsp?appointmentId=APT-001" class="btn btn-sm btn-outline-info" data-bs-toggle="tooltip" title="Generate Bill">
                                        <i class="fas fa-file-invoice-dollar"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card appointment-card shadow">
                        <div class="card-header bg-warning text-dark d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">APT-002</h5>
                            <span class="badge rounded-pill bg-warning text-dark">Pending</span>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <h6 class="text-muted mb-1">Patient</h6>
                                    <p class="mb-0"><i class="fas fa-user me-2"></i> Emily Johnson</p>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <h6 class="text-muted mb-1">Doctor</h6>
                                    <p class="mb-0"><i class="fas fa-user-md me-2"></i> Dr. Michael Lee</p>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <h6 class="text-muted mb-1">Date</h6>
                                    <p class="mb-0"><i class="fas fa-calendar-day me-2"></i> 10-05-2025</p>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-muted mb-1">Time</h6>
                                    <p class="mb-0"><i class="fas fa-clock me-2"></i> 11:30 AM</p>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <h6 class="text-muted mb-1">Type</h6>
                                    <p class="mb-0"><i class="fas fa-stethoscope me-2"></i> Follow-up</p>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer">
                            <div class="d-flex justify-content-between">
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="tooltip" title="View Details">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="tooltip" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-success" data-bs-toggle="tooltip" title="Confirm">
                                        <i class="fas fa-check-circle"></i>
                                    </button>
                                </div>
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-sm btn-outline-danger" data-bs-toggle="tooltip" title="Cancel">
                                        <i class="fas fa-times-circle"></i>
                                    </button>
                                    <a href="generateBill.jsp?appointmentId=APT-002" class="btn btn-sm btn-outline-info" data-bs-toggle="tooltip" title="Generate Bill">
                                        <i class="fas fa-file-invoice-dollar"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card appointment-card shadow">
                        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">APT-003</h5>
                            <span class="badge rounded-pill bg-primary">Completed</span>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <h6 class="text-muted mb-1">Patient</h6>
                                    <p class="mb-0"><i class="fas fa-user me-2"></i> David Wilson</p>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <h6 class="text-muted mb-1">Doctor</h6>
                                    <p class="mb-0"><i class="fas fa-user-md me-2"></i> Dr. Jessica Chen</p>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <h6 class="text-muted mb-1">Date</h6>
                                    <p class="mb-0"><i class="fas fa-calendar-day me-2"></i> 11-05-2025</p>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-muted mb-1">Time</h6>
                                    <p class="mb-0"><i class="fas fa-clock me-2"></i> 9:15 AM</p>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <h6 class="text-muted mb-1">Type</h6>
                                    <p class="mb-0"><i class="fas fa-stethoscope me-2"></i> Check-up</p>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer">
                            <div class="d-flex justify-content-between">
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="tooltip" title="View Details">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="tooltip" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                </div>
                                <div class="btn-group" role="group">
                                    <a href="generateBill.jsp?appointmentId=APT-003" class="btn btn-sm btn-outline-info" data-bs-toggle="tooltip" title="Generate Bill">
                                        <i class="fas fa-file-invoice-dollar"></i>
                                    </a>
                                    <button type="button" class="btn btn-sm btn-outline-danger" data-bs-toggle="tooltip" title="Delete">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card appointment-card shadow">
                        <div class="card-header bg-danger text-white d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">APT-004</h5>
                            <span class="badge rounded-pill bg-danger">Cancelled</span>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <h6 class="text-muted mb-1">Patient</h6>
                                    <p class="mb-0"><i class="fas fa-user me-2"></i> Sarah Brown</p>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <h6 class="text-muted mb-1">Doctor</h6>
                                    <p class="mb-0"><i class="fas fa-user-md me-2"></i> Dr. Robert Garcia</p>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <h6 class="text-muted mb-1">Date</h6>
                                    <p class="mb-0"><i class="fas fa-calendar-day me-2"></i> 11-05-2025</p>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-muted mb-1">Time</h6>
                                    <p class="mb-0"><i class="fas fa-clock me-2"></i> 2:45 PM</p>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <h6 class="text-muted mb-1">Type</h6>
                                    <p class="mb-0"><i class="fas fa-stethoscope me-2"></i> Consultation</p>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer">
                            <div class="d-flex justify-content-between">
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="tooltip" title="View Details">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="tooltip" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                </div>
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-sm btn-outline-success" data-bs-toggle="tooltip" title="Reschedule">
                                        <i class="fas fa-calendar-plus"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-danger" data-bs-toggle="tooltip" title="Delete">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Calendar View (Initially Hidden) -->
        <div id="calendarViewContent" class="view-content" style="display: none;">
            <div class="card shadow">
                <div class="card-body">
                    <div id="appointmentCalendar"></div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Export Modal -->
    <div class="modal fade" id="exportModal" tabindex="-1" aria-labelledby="exportModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="exportModalLabel">Export Appointments</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="mb-3">
                            <label for="exportFormat" class="form-label">Export Format</label>
                            <select class="form-select" id="exportFormat">
                                <option value="excel">Excel (.xlsx)</option>
                                <option value="csv">CSV (.csv)</option>
                                <option value="pdf">PDF (.pdf)</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="exportDateRange" class="form-label">Date Range</label>
                            <select class="form-select" id="exportDateRange">
                                <option value="all">All Dates</option>
                                <option value="today">Today</option>
                                <option value="thisweek">This Week</option>
                                <option value="thismonth">This Month</option>
                                <option value="custom">Custom Range</option>
                            </select>
                        </div>
                        <div class="mb-3 date-range-picker" style="display: none;">
                            <div class="row">
                                <div class="col-md-6">
                                    <label for="exportStartDate" class="form-label">Start Date</label>
                                    <input type="date" class="form-control" id="exportStartDate">
                                </div>
                                <div class="col-md-6">
                                    <label for="exportEndDate" class="form-label">End Date</label>
                                    <input type="date" class="form-control" id="exportEndDate">
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="exportIncludeFields" class="form-label">Include Fields</label>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="patient" id="includePatient" checked>
                                <label class="form-check-label" for="includePatient">
                                    Patient Information
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="doctor" id="includeDoctor" checked>
                                <label class="form-check-label" for="includeDoctor">
                                    Doctor Information
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="appointment" id="includeAppointment" checked>
                                <label class="form-check-label" for="includeAppointment">
                                    Appointment Details
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="notes" id="includeNotes">
                                <label class="form-check-label" for="includeNotes">
                                    Notes
                                </label>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary">Export</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Print Modal -->
    <div class="modal fade" id="printModal" tabindex="-1" aria-labelledby="printModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="printModalLabel">Print Appointments</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="mb-3">
                            <label for="printDateRange" class="form-label">Date Range</label>
                            <select class="form-select" id="printDateRange">
                                <option value="all">All Dates</option>
                                <option value="today">Today</option>
                                <option value="tomorrow">Tomorrow</option>
                                <option value="thisweek">This Week</option>
                                <option value="thismonth">This Month</option>
                                <option value="custom">Custom Range</option>
                            </select>
                        </div>
                        <div class="mb-3 date-range-picker" style="display: none;">
                            <div class="row">
                                <div class="col-md-6">
                                    <label for="printStartDate" class="form-label">Start Date</label>
                                    <input type="date" class="form-control" id="printStartDate">
                                </div>
                                <div class="col-md-6">
                                    <label for="printEndDate" class="form-label">End Date</label>
                                    <input type="date" class="form-control" id="printEndDate">
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="printLayout" class="form-label">Print Layout</label>
                            <select class="form-select" id="printLayout">
                                <option value="table">Table View</option>
                                <option value="detailed">Detailed View</option>
                                <option value="calendar">Calendar View</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Options</label>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="header" id="includePrintHeader" checked>
                                <label class="form-check-label" for="includePrintHeader">
                                    Include Header and Footer
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="patientcontact" id="includePrintPatientContact" checked>
                                <label class="form-check-label" for="includePrintPatientContact">
                                    Include Patient Contact Information
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="notes" id="includePrintNotes">
                                <label class="form-check-label" for="includePrintNotes">
                                    Include Notes
                                </label>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary">Print</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteAppointmentModal" tabindex="-1" aria-labelledby="deleteAppointmentModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteAppointmentModalLabel">Confirm Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this appointment?</p>
                    <p class="text-danger">This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete</button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/5.10.0/main.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/5.10.0/main.min.css" rel="stylesheet">
    
    <script>
        // Initialize DataTable
        $(document).ready(function() {
            $('#appointmentsTable').DataTable({
                responsive: true,
                order: [[3, 'asc'], [4, 'asc']] // Sort by date and time
            });
            
            // Initialize tooltips
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
            
            // View toggle functionality
            $("#tableView").change(function() {
                if($(this).is(":checked")) {
                    $(".view-content").hide();
                    $("#tableViewContent").show();
                }
            });
            
            $("#cardView").change(function() {
                if($(this).is(":checked")) {
                    $(".view-content").hide();
                    $("#cardViewContent").show();
                }
            });
            
            $("#calendarView").change(function() {
                if($(this).is(":checked")) {
                    $(".view-content").hide();
                    $("#calendarViewContent").show();
                    initializeCalendar();
                }
            });
            
            // Export date range selector
            $("#exportDateRange, #printDateRange").change(function() {
                if($(this).val() === "custom") {
                    $(this).closest('.modal-body').find('.date-range-picker').show();
                } else {
                    $(this).closest('.modal-body').find('.date-range-picker').hide();
                }
            });
        });
        
        // Initialize FullCalendar
        function initializeCalendar() {
            var calendarEl = document.getElementById('appointmentCalendar');
            
            // Only initialize once
            if (!calendarEl.innerHTML) {
                var calendar = new FullCalendar.Calendar(calendarEl, {
                    initialView: 'dayGridMonth',
                    headerToolbar: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
                    },
                    buttonText: {
                        today: 'Today',
                        month: 'Month',
                        week: 'Week',
                        day: 'Day',
                        list: 'List'
                    },
                    events: [
                        {
                            title: 'John Smith - Dr. Sarah Johnson',
                            start: '2025-05-10T10:00:00',
                            end: '2025-05-10T10:30:00',
                            backgroundColor: '#198754',
                            borderColor: '#198754',
                            extendedProps: {
                                status: 'Confirmed',
                                type: 'Consultation',
                                appointmentId: 'APT-001'
                            }
                        },
                        {
                            title: 'Emily Johnson - Dr. Michael Lee',
                            start: '2025-05-10T11:30:00',
                            end: '2025-05-10T12:00:00',
                            backgroundColor: '#ffc107',
                            borderColor: '#ffc107',
                            textColor: '#000',
                            extendedProps: {
                                status: 'Pending',
                                type: 'Follow-up',
                                appointmentId: 'APT-002'
                            }
                        },
                        {
                            title: 'David Wilson - Dr. Jessica Chen',
                            start: '2025-05-11T09:15:00',
                            end: '2025-05-11T09:45:00',
                            backgroundColor: '#0d6efd',
                            borderColor: '#0d6efd',
                            extendedProps: {
                                status: 'Completed',
                                type: 'Check-up',
                                appointmentId: 'APT-003'
                            }
                        },
                        {
                            title: 'Sarah Brown - Dr. Robert Garcia',
                            start: '2025-05-11T14:45:00',
                            end: '2025-05-11T15:15:00',
                            backgroundColor: '#dc3545',
                            borderColor: '#dc3545',
                            extendedProps: {
                                status: 'Cancelled',
                                type: 'Consultation',
                                appointmentId: 'APT-004'
                            }
                        }
                    ],
                    eventClick: function(info) {
                        // Show appointment details when clicking on an event
                        alert('Appointment: ' + info.event.title + '\nStatus: ' + info.event.extendedProps.status + '\nType: ' + info.event.extendedProps.type);
                    }
                });
                
                calendar.render();
            }
        }
        
        // Function to update appointment status
        function updateStatus(appointmentId, status) {
            // In production, make an AJAX call to the server to update status
            alert('Appointment ' + appointmentId + ' status updated to ' + status);
        }
        
        // Function to delete appointment 
        function deleteAppointment(appointmentId) {
            // Set the appointment ID to delete
            appointmentIdToDelete = appointmentId;
            
            // Show the confirmation modal
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteAppointmentModal'));
            deleteModal.show();
            
            // Add event listener for confirm button
            document.getElementById('confirmDeleteBtn').addEventListener('click', function() {
                // In production, make an AJAX call to the server to delete the appointment
                alert('Appointment ' + appointmentIdToDelete + ' deleted successfully');
                
                // Hide the modal
                deleteModal.hide();
            });
        }
    </script>
</body>
</html>