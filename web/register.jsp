<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hospital Management System - Registration</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            padding-top: 20px;
        }
        .registration-container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .form-title {
            text-align: center;
            margin-bottom: 30px;
            color: #28a745;
        }
        .error-message {
            color: #dc3545;
            font-size: 14px;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="registration-container">
            <h2 class="form-title">Hospital Management System - Registration</h2>
            
            <% if(request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <form action="register" method="post">
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" name="username" value="${username}" required>
                    <% if(request.getAttribute("usernameError") != null) { %>
                        <div class="error-message"><%= request.getAttribute("usernameError") %></div>
                    <% } %>
                </div>
                
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                    <small class="text-muted">Password must be at least 8 characters with at least one letter and one number</small>
                    <% if(request.getAttribute("passwordError") != null) { %>
                        <div class="error-message"><%= request.getAttribute("passwordError") %></div>
                    <% } %>
                </div>
                
                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                    <% if(request.getAttribute("confirmPasswordError") != null) { %>
                        <div class="error-message"><%= request.getAttribute("confirmPasswordError") %></div>
                    <% } %>
                </div>
                
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" name="email" value="${email}" required>
                    <% if(request.getAttribute("emailError") != null) { %>
                        <div class="error-message"><%= request.getAttribute("emailError") %></div>
                    <% } %>
                </div>
                
                <div class="mb-3">
                    <label for="role" class="form-label">Role</label>
                    <select class="form-select" id="role" name="role" required>
                        <option value="" selected disabled>Select a role</option>
                        <option value="PATIENT" ${role == 'PATIENT' ? 'selected' : ''}>Patient</option>
                        <option value="DOCTOR" ${role == 'DOCTOR' ? 'selected' : ''}>Doctor</option>
                        <option value="ADMIN" ${role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                    </select>
                    <% if(request.getAttribute("roleError") != null) { %>
                        <div class="error-message"><%= request.getAttribute("roleError") %></div>
                    <% } %>
                </div>
                
                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="termsCheck" required>
                    <label class="form-check-label" for="termsCheck">I agree to the terms and conditions</label>
                </div>
                
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary">Register</button>
                    <a href="login" class="btn btn-secondary">Already have an account? Login</a>
                </div>
            </form>
        </div>
    </div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>