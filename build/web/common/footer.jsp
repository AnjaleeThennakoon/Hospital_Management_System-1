<%-- 
    Document   : footer
    Created on : May 11, 2025, 8:16:19 PM
    Author     : Asus
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Footer Section -->
<footer class="footer">
    <div class="footer-content">
        <div class="footer-section about">
            <h3>E-Health</h3>
            <p>Providing high-quality healthcare services through our innovative digital platform.</p>
            <div class="contact">
                <span><i class="fas fa-phone"></i> &nbsp; +94 112 345 678</span>
                <span><i class="fas fa-envelope"></i> &nbsp; info@ehealth.com</span>
            </div>
            <div class="socials">
                <a href="#"><i class="fab fa-facebook"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
                <a href="#"><i class="fab fa-linkedin"></i></a>
            </div>
        </div>
        
        <div class="footer-section links">
            <h3>Quick Links</h3>
            <ul>
                <li><a href="<c:url value='/' />">Home</a></li>
                <li><a href="<c:url value='/services' />">Services</a></li>
                <li><a href="<c:url value='/doctors' />">Our Doctors</a></li>
                <li><a href="<c:url value='/contact' />">Contact Us</a></li>
                <li><a href="<c:url value='/about' />">About Us</a></li>
            </ul>
        </div>
        
        <div class="footer-section resources">
            <h3>Resources</h3>
            <ul>
                <li><a href="<c:url value='/faq' />">FAQs</a></li>
                <li><a href="<c:url value='/terms' />">Terms of Service</a></li>
                <li><a href="<c:url value='/privacy' />">Privacy Policy</a></li>
                <li><a href="<c:url value='/blog' />">Health Blog</a></li>
            </ul>
        </div>
    </div>
    
    <div class="footer-bottom">
        <p>&copy; 2025 E-Health. All rights reserved.</p>
    </div>
</footer>

<!-- Add Font Awesome for icons -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/js/all.min.js"></script>

<style>
    .footer {
        background-color: #2c3e50;
        color: #ecf0f1;
        padding: 40px 0 10px;
        font-family: 'Arial', sans-serif;
        margin-top: 50px;
    }
    
    .footer-content {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-around;
        margin: 0 auto;
        max-width: 1200px;
    }
    
    .footer-section {
        flex: 1;
        padding: 0 15px;
        min-width: 250px;
        margin-bottom: 20px;
    }
    
    .footer-section h3 {
        color: #3498db;
        margin-bottom: 15px;
        font-size: 18px;
        font-weight: 500;
    }
    
    .about p {
        margin-bottom: 20px;
        line-height: 1.5;
    }
    
    .contact span {
        display: block;
        margin-bottom: 8px;
        font-size: 14px;
    }
    
    .socials {
        margin-top: 15px;
    }
    
    .socials a {
        display: inline-block;
        margin-right: 10px;
        width: 35px;
        height: 35px;
        border-radius: 50%;
        text-align: center;
        line-height: 35px;
        background-color: #34495e;
        color: #ecf0f1;
        transition: all 0.3s ease;
    }
    
    .socials a:hover {
        background-color: #3498db;
    }
    
    .links ul, .resources ul {
        list-style-type: none;
        padding-left: 0;
    }
    
    .links li, .resources li {
        margin-bottom: 10px;
    }
    
    .links a, .resources a {
        color: #ecf0f1;
        text-decoration: none;
        transition: all 0.3s ease;
    }
    
    .links a:hover, .resources a:hover {
        color: #3498db;
        padding-left: 5px;
    }
    
    .footer-bottom {
        background-color: #1a252f;
        text-align: center;
        padding: 10px 0;
        margin-top: 20px;
        font-size: 14px;
    }
    
    @media screen and (max-width: 768px) {
        .footer-section {
            flex: 100%;
            margin-bottom: 30px;
        }
    }
</style>
