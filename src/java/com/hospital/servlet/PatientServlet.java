package com.hospital.servlet;

import com.hospital.beans.Patient;
import com.hospital.dao.PatientDAO;
import com.hospital.dao.UserDAO;
import com.hospital.util.ValidationUtil;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet for handling patient-related operations
 */
@WebServlet("/patient/*")
public class PatientServlet extends HttpServlet {

    private PatientDAO patientDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() {
        patientDAO = new PatientDAO();
        userDAO = new UserDAO();
    }
    
    /**
     * Handles GET requests
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Handle default case - list all patients (admin only)
            listAllPatients(request, response);
        } else if (pathInfo.equals("/search")) {
            // Search patients
            searchPatients(request, response);
        } else if (pathInfo.equals("/profile")) {
            // View patient profile
            viewPatientProfile(request, response);
        } else {
            // Handle unknown paths
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * Handles POST requests
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Handle default case
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid path");
        } else if (pathInfo.equals("/add")) {
            // Add a new patient (admin operation)
            addPatient(request, response);
        } else if (pathInfo.equals("/update")) {
            // Update patient information
            updatePatient(request, response);
        } else {
            // Handle unknown paths
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * List all patients (admin only)
     */
    private void listAllPatients(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verify that user is admin
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        // Get all patients
        List<Patient> patients = patientDAO.getAllPatients();
        
        // Set in request
        request.setAttribute("patients", patients);
        
        // Forward to view
        request.getRequestDispatcher("/admin/viewPatients.jsp").forward(request, response);
    }
    
    /**
     * Search patients
     */
    private void searchPatients(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verify authorization
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        
        // Only admin and doctors can search patients
        if (!userRole.equals("ADMIN") && !userRole.equals("DOCTOR")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        // Get search term
        String searchTerm = request.getParameter("term");
        
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Search term is required");
            return;
        }
        
        // Search patients
        List<Patient> patients = patientDAO.searchPatients(searchTerm);
        
        // Format response based on request type
        String format = request.getParameter("format");
        
        if (format != null && format.equals("json")) {
            // JSON response for AJAX requests
            StringBuilder jsonResponse = new StringBuilder("[");
            boolean first = true;
            
            for (Patient patient : patients) {
                if (!first) {
                    jsonResponse.append(",");
                }
                jsonResponse.append("{\"id\":").append(patient.getPatientId()).append(",");
                jsonResponse.append("\"name\":\"").append(patient.getFirstName()).append(" ")
                         .append(patient.getLastName()).append("\",");
                jsonResponse.append("\"gender\":\"").append(patient.getGender()).append("\",");
                jsonResponse.append("\"age\":").append(patient.getAge()).append(",");
                jsonResponse.append("\"phone\":\"").append(patient.getPhone()).append("\"}");
                first = false;
            }
            
            jsonResponse.append("]");
            
            // Set response content type
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            // Write JSON to response
            response.getWriter().write(jsonResponse.toString());
        } else {
            // HTML response for regular requests
            request.setAttribute("patients", patients);
            request.setAttribute("searchTerm", searchTerm);
            
            // Forward to view based on role
            if (userRole.equals("ADMIN")) {
                request.getRequestDispatcher("/admin/viewPatients.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/doctor/viewMedicalRecords.jsp").forward(request, response);
            }
        }
    }
    
    /**
     * View patient profile
     */
    private void viewPatientProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verify authorization
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        
        // Get patient ID
        String patientIdStr = request.getParameter("id");
        Integer patientId = null;
        
        // If no ID provided and user is patient, use the session patient ID
        if ((patientIdStr == null || patientIdStr.trim().isEmpty()) && userRole.equals("PATIENT")) {
            patientId = (Integer) session.getAttribute("patientId");
        } else if (patientIdStr != null && !patientIdStr.trim().isEmpty()) {
            try {
                patientId = Integer.parseInt(patientIdStr);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid patient ID");
                return;
            }
        }
        
        if (patientId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Patient ID is required");
            return;
        }
        
        // Access control - patients can only view their own profile
        if (userRole.equals("PATIENT")) {
            Integer sessionPatientId = (Integer) session.getAttribute("patientId");
            if (sessionPatientId == null || !sessionPatientId.equals(patientId)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }
        }
        
        // Get patient
        Patient patient = patientDAO.getPatientById(patientId);
        
        if (patient == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Patient not found");
            return;
        }
        
        // Set in request
        request.setAttribute("patient", patient);
        
        // Forward to appropriate view based on role
        if (userRole.equals("ADMIN")) {
            request.getRequestDispatcher("/admin/viewPatients.jsp").forward(request, response);
        } else if (userRole.equals("DOCTOR")) {
            request.getRequestDispatcher("/doctor/viewMedicalRecords.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/patient/patientDashboard.jsp").forward(request, response);
        }
    }
    
    /**
     * Add a new patient (admin operation)
     */
    private void addPatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verify that user is admin
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        // Get form parameters
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String gender = request.getParameter("gender");
        String dateOfBirthStr = request.getParameter("dob");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        
        // Validate input
        boolean hasErrors = false;
        
        if (!ValidationUtil.isNotNullOrEmpty(firstName) || !ValidationUtil.isNotNullOrEmpty(lastName)) {
            request.setAttribute("errorMessage", "First name and last name are required");
            hasErrors = true;
        }
        
        if (!ValidationUtil.isNotNullOrEmpty(gender)) {
            request.setAttribute("errorMessage", "Gender is required");
            hasErrors = true;
        }
        
        if (ValidationUtil.isNotNullOrEmpty(dateOfBirthStr) && !ValidationUtil.isValidDate(dateOfBirthStr)) {
            request.setAttribute("errorMessage", "Invalid date format (yyyy-MM-dd)");
            hasErrors = true;
        }
        
        if (!ValidationUtil.isNotNullOrEmpty(phone) || !ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("errorMessage", "Valid phone number is required");
            hasErrors = true;
        }
        
        if (!ValidationUtil.isNotNullOrEmpty(username)) {
            request.setAttribute("errorMessage", "Username is required");
            hasErrors = true;
        } else if (userDAO.usernameExists(username)) {
            request.setAttribute("errorMessage", "Username already exists");
            hasErrors = true;
        }
        
        if (!ValidationUtil.isNotNullOrEmpty(password) || password.length() < 8) {
            request.setAttribute("errorMessage", "Password must be at least 8 characters");
            hasErrors = true;
        }
        
        if (!ValidationUtil.isNotNullOrEmpty(email) || !ValidationUtil.isValidEmail(email)) {
            request.setAttribute("errorMessage", "Valid email is required");
            hasErrors = true;
        }
        
        if (hasErrors) {
            // Keep form data
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("gender", gender);
            request.setAttribute("dob", dateOfBirthStr);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            
            // Forward back to form
            request.getRequestDispatcher("/admin/addPatient.jsp").forward(request, response);
            return;
        }
        
        // Create user
        com.hospital.beans.User user = new com.hospital.beans.User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setRole("PATIENT");
        user.setActive(true);
        
        int userId = userDAO.createUser(user);
        
        if (userId == -1) {
            request.setAttribute("errorMessage", "Error creating user account");
            request.getRequestDispatcher("/admin/addPatient.jsp").forward(request, response);
            return;
        }
        
        // Create patient
        Patient patient = new Patient();
        patient.setFirstName(firstName);
        patient.setLastName(lastName);
        patient.setGender(gender);
        patient.setPhone(phone);
        patient.setAddress(address);
        
        // Parse date of birth if provided
        if (ValidationUtil.isNotNullOrEmpty(dateOfBirthStr)) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date dateOfBirth = sdf.parse(dateOfBirthStr);
                patient.setDateOfBirth(dateOfBirth);
            } catch (ParseException e) {
                // Already validated format above
            }
        }
        
        int patientId = patientDAO.createPatient(patient, userId);
        
        if (patientId == -1) {
            request.setAttribute("errorMessage", "Error creating patient profile");
            request.getRequestDispatcher("/admin/addPatient.jsp").forward(request, response);
            return;
        }
        
        // Success
        request.setAttribute("message", "Patient added successfully");
        request.setAttribute("messageType", "success");
        
        // Redirect to patient list
        response.sendRedirect(request.getContextPath() + "/admin/viewPatients.jsp");
    }
    
    /**
     * Update patient information
     */
    private void updatePatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verify authorization
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        
        // Get patient ID
        String patientIdStr = request.getParameter("patientId");
        
        if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Patient ID is required");
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdStr);
            
            // Verify permissions
            if (userRole.equals("PATIENT")) {
                Integer sessionPatientId = (Integer) session.getAttribute("patientId");
                if (sessionPatientId == null || sessionPatientId != patientId) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
            } else if (!userRole.equals("ADMIN")) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }
            
            // Get current patient info
            Patient patient = patientDAO.getPatientById(patientId);
            
            if (patient == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Patient not found");
                return;
            }
            
            // Get form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String gender = request.getParameter("gender");
            String dateOfBirthStr = request.getParameter("dob");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            
            // Validate input
            boolean hasErrors = false;
            
            if (!ValidationUtil.isNotNullOrEmpty(firstName) || !ValidationUtil.isNotNullOrEmpty(lastName)) {
                request.setAttribute("errorMessage", "First name and last name are required");
                hasErrors = true;
            }
            
            if (!ValidationUtil.isNotNullOrEmpty(gender)) {
                request.setAttribute("errorMessage", "Gender is required");
                hasErrors = true;
            }
            
            if (ValidationUtil.isNotNullOrEmpty(dateOfBirthStr) && !ValidationUtil.isValidDate(dateOfBirthStr)) {
                request.setAttribute("errorMessage", "Invalid date format (yyyy-MM-dd)");
                hasErrors = true;
            }
            
            if (!ValidationUtil.isNotNullOrEmpty(phone) || !ValidationUtil.isValidPhone(phone)) {
                request.setAttribute("errorMessage", "Valid phone number is required");
                hasErrors = true;
            }
            
            if (hasErrors) {
                // Keep form data
                request.setAttribute("patient", patient);
                request.setAttribute("firstName", firstName);
                request.setAttribute("lastName", lastName);
                request.setAttribute("gender", gender);
                request.setAttribute("dob", dateOfBirthStr);
                request.setAttribute("phone", phone);
                request.setAttribute("address", address);
                
                // Forward back to form
                if (userRole.equals("ADMIN")) {
                    request.getRequestDispatcher("/admin/addPatient.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/patient/patientDashboard.jsp").forward(request, response);
                }
                return;
            }
            
            // Update patient
            patient.setFirstName(firstName);
            patient.setLastName(lastName);
            patient.setGender(gender);
            patient.setPhone(phone);
            patient.setAddress(address);
            
            // Parse date of birth if provided
            if (ValidationUtil.isNotNullOrEmpty(dateOfBirthStr)) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date dateOfBirth = sdf.parse(dateOfBirthStr);
                    patient.setDateOfBirth(dateOfBirth);
                } catch (ParseException e) {
                    // Already validated format above
                }
            }
            
            boolean success = patientDAO.updatePatient(patient);
            
            if (!success) {
                request.setAttribute("errorMessage", "Failed to update patient profile");
                request.setAttribute("patient", patient);
                
                if (userRole.equals("ADMIN")) {
                    request.getRequestDispatcher("/admin/addPatient.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/patient/patientDashboard.jsp").forward(request, response);
                }
                return;
            }
            
            // Success
            request.setAttribute("message", "Patient profile updated successfully");
            request.setAttribute("messageType", "success");
            
            // Redirect based on role
            if (userRole.equals("ADMIN")) {
                response.sendRedirect(request.getContextPath() + "/admin/viewPatients.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/patient/patientDashboard.jsp?updated=true");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid patient ID");
        }
    }
}