<%-- 
    Document   : error
    Created on : May 11, 2025, 8:16:48 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Error Page</title>
        <style>
            /* Reset CSS */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            
            body {
                background-color: #f8f9fa;
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            }
            
            .error-container {
                background-color: white;
                border-radius: 20px;
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
                text-align: center;
                padding: 3rem 2rem;
                max-width: 500px;
                width: 90%;
                animation: fadeIn 0.6s ease-in-out;
            }
            
            @keyframes fadeIn {
                0% {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                100% {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            
            .error-icon {
                font-size: 6rem;
                color: #e74c3c;
                margin-bottom: 1rem;
            }
            
            h1 {
                color: #e74c3c;
                font-size: 2rem;
                margin-bottom: 1rem;
                font-weight: 600;
            }
            
            p {
                color: #555;
                line-height: 1.6;
                margin-bottom: 2rem;
                font-size: 1.1rem;
            }
            
            .btn {
                display: inline-block;
                background: linear-gradient(to right, #3498db, #2980b9);
                color: white;
                text-decoration: none;
                padding: 0.8rem 2rem;
                border-radius: 50px;
                font-weight: 600;
                font-size: 1rem;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(52, 152, 219, 0.4);
            }
            
            .btn:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 20px rgba(52, 152, 219, 0.6);
            }
            
            .btn:active {
                transform: translateY(0);
            }
            
            /* Additional elements styling */
            .error-details {
                background-color: #f8f9fa;
                border-radius: 10px;
                padding: 1rem;
                margin: 1.5rem 0;
                font-size: 0.9rem;
                color: #777;
                border-left: 4px solid #e74c3c;
            }
            
            .support-link {
                color: #3498db;
                text-decoration: underline;
                font-weight: 500;
                margin-top: 1rem;
                display: inline-block;
            }
            
            .support-link:hover {
                color: #2980b9;
            }
            
            /* Responsive adjustments */
            @media (max-width: 480px) {
                .error-container {
                    padding: 2rem 1.5rem;
                }
                
                h1 {
                    font-size: 1.5rem;
                }
                
                p {
                    font-size: 1rem;
                }
                
                .error-icon {
                    font-size: 4rem;
                }
            }
        </style>
    </head>
    <body>
        <div class="error-container">
            <div class="error-icon">⚠</div>
            <h1>Oops! Something went wrong.</h1>
            <p>We encountered an unexpected error. Please try again later or contact support if the issue persists.</p>
            
            <div class="error-details">
                Error occurred at: <%= new java.util.Date() %>
            </div>
            
            <a href="index.jsp" class="btn">Return to Home</a>
            <br>
            <a href="contact.jsp" class="support-link">Contact Support</a>
        </div>
    </body>
</html>
