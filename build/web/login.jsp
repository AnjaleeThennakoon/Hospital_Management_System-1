<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Nunito', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-container {
            max-width: 400px;
            padding: 30px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }
        
        .logo {
            text-align: center;
            margin-bottom: 1.5rem;
        }
        
        .logo h1 {
            color: #4e73df;
            font-weight: 700;
            font-size: 1.5rem;
            margin-bottom: 0;
        }
        
        .logo p {
            color: #5a5c69;
            margin-top: 0.25rem;
        }
        
        .form-control {
            padding: 0.75rem 1rem;
            border-radius: 10px;
            margin-bottom: 1rem;
        }
        
        .btn-primary {
            padding: 0.75rem 1rem;
            border-radius: 10px;
            background-color: #4e73df;
            border-color: #4e73df;
            font-weight: 600;
        }
        
        .btn-primary:hover {
            background-color: #2e59d9;
            border-color: #2e59d9;
        }
        
        .form-group {
            margin-bottom: 1rem;
        }
        
        .form-label {
            font-weight: 600;
            color: #5a5c69;
        }
        
        .alert {
            border-radius: 10px;
            margin-bottom: 1.5rem;
        }
        
        .register-link {
            text-align: center;
            margin-top: 1.5rem;
            color: #5a5c69;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">
            <h1>Hospital Management System</h1>
            <p>Please login to continue</p>
        </div>
        
        <% if(request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>
        
        <% if(request.getAttribute("successMessage") != null) { %>
            <div class="alert alert-success" role="alert">
                <%= request.getAttribute("successMessage") %>
            </div>
        <% } %>
        
        <form action="login" method="post">
            <div class="form-group">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            
            <div class="form-group">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            
            <div class="form-group">
                <label for="role" class="form-label">Login As</label>
                <select class="form-select" id="role" name="role" required>
                    <option value="" selected disabled>Select your role</option>
                    <option value="PATIENT">Patient</option>
                    <option value="DOCTOR">Doctor</option>
                    <option value="ADMIN">Admin</option>
                </select>
            </div>
            
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">Login</button>
            </div>
        </form>
        
        <p class="register-link">
            Don't have an account? <a href="register">Register Now</a>
        </p>
    </div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>