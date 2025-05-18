package com.hospital.servlet;

import com.hospital.beans.Doctor;
import com.hospital.beans.Patient;
import com.hospital.beans.User;
import com.hospital.dao.DoctorDAO;
import com.hospital.dao.PatientDAO;
import com.hospital.dao.UserDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet for handling user login
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;
    private DoctorDAO doctorDAO;
    private PatientDAO patientDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
        doctorDAO = new DoctorDAO();
        patientDAO = new PatientDAO();
    }
    
    /**
     * Handles GET requests - displays login form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // Redirect based on user role
            String userRole = (String) session.getAttribute("userRole");
            redirectBasedOnRole(response, userRole);
            return;
        }
        
        // Check if logout parameter is set
        String logout = request.getParameter("logout");
        if (logout != null && logout.equals("true")) {
            request.setAttribute("successMessage", "You have been successfully logged out.");
        }
        
        // Forward to login page
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - processes login form submission
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username, password, and role are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // Authenticate user with role validation
        User user = userDAO.authenticate(username, password);
        
        if (user == null || !user.getRole().equals(role)) {
            request.setAttribute("errorMessage", "Invalid username, password, or role.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // Create session and set attributes
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("userRole", user.getRole());
        
        // Set additional attributes based on role
        if (user.getRole().equals("DOCTOR")) {
            Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
            if (doctor != null) {
                session.setAttribute("doctorId", doctor.getDoctorId());
                session.setAttribute("doctorName", doctor.getFirstName() + " " + doctor.getLastName());
                session.setAttribute("doctor", doctor);
            }
        } else if (user.getRole().equals("PATIENT")) {
            Patient patient = patientDAO.getPatientByUserId(user.getUserId());
            if (patient != null) {
                session.setAttribute("patientId", patient.getPatientId());
                session.setAttribute("patientName", patient.getFirstName() + " " + patient.getLastName());
                session.setAttribute("patient", patient);
            }
        }
        
        // Redirect based on role
        redirectBasedOnRole(response, user.getRole());
    }
    
    /**
     * Helper method to redirect based on user role
     */
    private void redirectBasedOnRole(HttpServletResponse response, String role) throws IOException {
        switch (role) {
            case "ADMIN" -> response.sendRedirect("admin/adminDashboard.jsp");
            case "DOCTOR" -> response.sendRedirect("doctorDashboard.jsp");
            case "PATIENT" -> response.sendRedirect("patient/patientDashboard.jsp");
            default -> response.sendRedirect("login.jsp");
        }
    }
}