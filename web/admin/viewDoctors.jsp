<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Doctors | Hospital Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css">
    <style>
        .doctor-card {
            transition: transform 0.3s;
        }
        .doctor-card:hover {
            transform: translateY(-5px);
        }
        .doctor-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #0d6efd;
        }
        .status-active {
            color: #198754;
        }
        .status-inactive {
            color: #dc3545;
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
                        <li class="breadcrumb-item active" aria-current="page">Doctors</li>
                    </ol>
                </nav>
                <h2><i class="fas fa-user-md"></i> Doctor Management</h2>
                <p class="text-muted">View and manage all registered doctors in the system.</p>
            </div>
        </div>
        
        <!-- Alert for success or error messages -->
        <c:if test="${not empty message}">
            <div class="alert alert-${messageType} alert-dismissible fade show" role="alert">
                <strong>${messageHeader}!</strong> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        
        <div class="row mb-4">
            <div class="col-md-8">
                <div class="input-group">
                    <input type="text" id="searchDoctor" class="form-control" placeholder="Search doctors by name, specialization, or ID...">
                    <button class="btn btn-outline-secondary" type="button">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </div>
            <div class="col-md-4 text-md-end">
                <a href="addDoctor.jsp" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Add New Doctor
                </a>
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
                </div>
                
                <!-- Filters -->
                <div class="btn-group ms-2">
                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-filter"></i> Filter
                    </button>
                    <ul class="dropdown-menu" aria-labelledby="filterDropdown">
                        <li><h6 class="dropdown-header">By Specialization</h6></li>
                        <li><a class="dropdown-item" href="#">All Specializations</a></li>
                        <li><a class="dropdown-item" href="#">Cardiology</a></li>
                        <li><a class="dropdown-item" href="#">Neurology</a></li>
                        <li><a class="dropdown-item" href="#">Pediatrics</a>