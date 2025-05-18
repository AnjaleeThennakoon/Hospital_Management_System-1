<%-- 
    Document   : header
    Created on : May 11, 2025, 8:16:03 PM
    Author     : Asus
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.pageTitle} | E-Health</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="<c:url value='/resources/css/styles.css' />" rel="stylesheet">
    <!-- Favicon -->
    <link rel="shortcut icon" href="<c:url value='/resources/images/favicon.ico' />" type="image/x-icon">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-gradient-start: #4d4dff;
            --primary-gradient-end: #4d94ff;
            --primary-color: #3498db;
            --secondary-color: #2c3e50;
            --accent-color: #ffdd00;
            --text-color: #333;
            --light-bg: #f8f9fa;
        }
        
        body {
            font-family: 'Arial', sans-serif;
            line-height: 1.6;
            color: var(--text-color);
            background-color: #f9f9f9;
            padding-top: 76px; /* Accounts for fixed navbar */
        }
        
        .top-bar {
            background-color: var(--secondary-color);
            color: white;
            padding: 8px 0;
            font-size: 14px;
        }
        
        .top-bar a {
            color: white;
            text-decoration: none;
        }
        
        .top-bar a:hover {
            color: var(--primary-color);
        }
        
        .navbar {
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .navbar-brand {
            font-weight: bold;
            color: var(--primary-color) !important;
            font-size: 24px;
        }
        
        .navbar-brand span {
            color: var(--secondary-color);
        }
        
        .navbar-nav .nav-link {
            color: var(--secondary-color);
            font-weight: 500;
            padding: 0.5rem 1rem;
            transition: all 0.3s ease;
        }
        
        .navbar-nav .nav-link:hover {
            color: var(--primary-color);
        }
        
        .navbar-nav .nav-link.active {
            color: var(--primary-color);
            border-bottom: 2px solid var(--primary-color);
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
        }
        
        .dropdown-menu {
            border-radius: 0;
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
            border: none;
        }
        
        .dropdown-item:hover {
            background-color: #f8f9fa;
            color: var(--primary-color);
        }
        
        .user-menu .dropdown-toggle::after {
            display: none;
        }
        
        .user-menu .dropdown-toggle img {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
        }
        
        @media (max-width: 992px) {
            .navbar-collapse {
                background-color: white;
                padding: 1rem;
                border-radius: 5px;
                box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
            }
        }
    </style>
</head>
<body>
    <!-- Top Bar -->
    <div class="top-bar d-none d-md-block">
        <div class="container d-flex justify-content-between">
            <div>
                <span><i class="fas fa-phone-alt me-2"></i> +94 112 345 678</span>
                <span class="ms-3"><i class="far fa-envelope me-2"></i> info@ehealth.com</span>
            </div>
            <div>
                <a href="#" class="me-3"><i class="far fa-clock me-1"></i> 24/7 Support</a>
                <a href="#" class="me-3"><i class="fas fa-map-marker-alt me-1"></i> Find a Doctor</a>
                <a href="#"><i class="fas fa-ambulance me-1"></i> Emergency</a>
            </div>
        </div>
    </div>
    
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light fixed-top">
        <div class="container">
            <a class="navbar-brand" href="<c:url value='/' />">E-<span>Health</span></a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" 
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.servletPath eq '/index.jsp' ? 'active' : ''}" 
                           href="<c:url value='/' />">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.servletPath eq '/services.jsp' ? 'active' : ''}" 
                           href="<c:url value='/services' />">About Us</a>
                    </li>
                    
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.servletPath eq '/about.jsp' ? 'active' : ''}" 
                           href="<c:url value='/about' />">Services</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.servletPath eq '/contact.jsp' ? 'active' : ''}" 
                           href="<c:url value='/contact' />">Contact</a>
                    </li>
                </ul>
                
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <!-- User not logged in -->
                        <div class="d-flex">
                            <a href="<c:url value='/login.jsp' />" class="btn btn-outline-primary me-2">Login</a>
                            <a href="<c:url value='/register.jsp' />" class="btn btn-primary">Register</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- User logged in -->
                        <div class="dropdown user-menu">
                            <a class="dropdown-toggle d-flex align-items-center" href="#" role="button" 
                               id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.profileImage}">
                                        <img src="<c:url value='${sessionScope.user.profileImage}' />" alt="Profile" class="me-2">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-user-circle fs-4 me-2"></i>
                                    </c:otherwise>
                                </c:choose>
                                <span>${sessionScope.user.firstName}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <c:if test="${sessionScope.userRole eq 'ADMIN'}">
                                    <li><a class="dropdown-item" href="<c:url value='/admin/adminDashboard.jsp' />">
                                        <i class="fas fa-tachometer-alt me-2"></i> Admin Dashboard</a>
                                    </li>
                                </c:if>
                                <c:if test="${sessionScope.userRole eq 'DOCTOR'}">
                                    <li><a class="dropdown-item" href="<c:url value='/doctor/doctorDashboard.jsp' />">
                                        <i class="fas fa-stethoscope me-2"></i> Doctor Dashboard</a>
                                    </li>
                                </c:if>
                                <c:if test="${sessionScope.userRole eq 'PATIENT'}">
                                    <li><a class="dropdown-item" href="<c:url value='/patient/patientDashboard.jsp' />">
                                        <i class="fas fa-user-md me-2"></i> Patient Dashboard</a>
                                    </li>
                                </c:if>
                                <li><a class="dropdown-item" href="<c:url value='/profile' />">
                                    <i class="fas fa-user me-2"></i> My Profile</a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="<c:url value='/logout.jsp' />">
                                    <i class="fas fa-sign-out-alt me-2"></i> Logout</a>
                                </li>
                            </ul>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>
    
    <!-- Page Header - Include on specific pages as needed -->
    <c:if test="${not empty param.showPageHeader and param.showPageHeader eq 'true'}">
        <div class="page-header bg-light py-4 mb-4">
            <div class="container">
                <h1 class="display-6">${param.pageTitle}</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="<c:url value='/' />">Home</a></li>
                        <c:if test="${not empty param.parentPage}">
                            <li class="breadcrumb-item"><a href="${param.parentPageUrl}">${param.parentPage}</a></li>
                        </c:if>
                        <li class="breadcrumb-item active" aria-current="page">${param.pageTitle}</li>
                    </ol>
                </nav>
            </div>
        </div>
    </c:if>
    
    <!-- Main content container - Page content will go here -->
    <div class="main-content">
        <!-- Your page content starts here -->