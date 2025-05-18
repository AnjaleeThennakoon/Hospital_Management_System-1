package com.hospital.filters;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Filter for authentication and authorization
 */
@WebFilter(urlPatterns = {"/admin/*", "/doctor/*", "/patient/*", "/appointment/*", "/medicalrecord/*", "/bill/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Get the request URI
        String uri = httpRequest.getRequestURI();
        
        // Skip filtering for login and register pages
        if (uri.endsWith("login.jsp") || uri.endsWith("register.jsp") || 
            uri.contains("/login") || uri.contains("/register") ||
            uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png") || 
            uri.endsWith(".jpg") || uri.endsWith(".gif")) {
            
            // Continue request processing
            chain.doFilter(request, response);
            return;
        }
        
        // Check if user is logged in
        HttpSession session = httpRequest.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            // User is not logged in, redirect to login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }
        
        // Get user role for authorization
        String userRole = (String) session.getAttribute("userRole");
        
        // Check access rights based on role and URL path
        boolean accessAllowed = checkAccess(uri, userRole);
        
        if (!accessAllowed) {
            // Access denied, redirect to appropriate page
            if (userRole.equals("ADMIN")) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin/adminDashboard.jsp");
            } else if (userRole.equals("DOCTOR")) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/doctor/doctorDashboard.jsp");
            } else if (userRole.equals("PATIENT")) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/patient/patientDashboard.jsp");
            } else {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            }
            return;
        }
        
        // Access allowed, continue request processing
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
    
    /**
     * Check if user has access rights based on role and URL path
     * @param uri The request URI
     * @param role The user role
     * @return true if access is allowed, false otherwise
     */
    private boolean checkAccess(String uri, String role) {
        // Admin has access to all pages
        if (role.equals("ADMIN")) {
            return true;
        }
        
        // Check access for doctor
        if (role.equals("DOCTOR")) {
            return !uri.contains("/admin/") && !uri.contains("/patient/");
        }
        
        // Check access for patient
        if (role.equals("PATIENT")) {
            return !uri.contains("/admin/") && !uri.contains("/doctor/");
        }
        
        // Default: access denied
        return false;
    }
}