package com.hospital.servlet;

import com.hospital.beans.Doctor;
import com.hospital.dao.DoctorDAO;
import com.hospital.dao.UserDAO;
import com.hospital.util.ValidationUtil;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet for handling doctor-related operations
 */
@WebServlet("/doctor/*")
public class DoctorServlet extends HttpServlet {

    private DoctorDAO doctorDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() {
        doctorDAO = new DoctorDAO();
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
            // Handle default case - list all doctors
            listAllDoctors(request, response);
        } else if (pathInfo.equals("/getByDepartment")) {
            // Get doctors by department/specialization
            getDoctorsByDepartment(request, response);
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
            // Add a new doctor (admin operation)
            addDoctor(request, response);
        } else if (pathInfo.equals("/update")) {
            // Update doctor information
            updateDoctor(request, response);
        } else if (pathInfo.equals("/updateSchedule")) {
            // Update doctor schedule
            updateDoctorSchedule(request, response);
        } else {
            // Handle unknown paths
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * List all doctors
     */
    private void listAllDoctors(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get all doctors
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        
        // Set in request
        request.setAttribute("doctors", doctors);
        
        // Forward to view
        request.getRequestDispatcher("/admin/viewDoctors.jsp").forward(request, response);
    }
    
    /**
     * Get doctors by department/specialization
     */
    private void getDoctorsByDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get parameter
        String departmentId = request.getParameter("departmentId");
        
        if (departmentId == null || departmentId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Department ID is required");
            return;
        }
        
        // In this example, we'll just use specialization as department
        List<Doctor> doctors = doctorDAO.getDoctorsBySpecialization(departmentId);
        
        // Create JSON response
        StringBuilder jsonResponse = new StringBuilder("[");
        boolean first = true;
        
        for (Doctor doctor : doctors) {
            if (!first) {
                jsonResponse.append(",");
            }
            jsonResponse.append("{\"id\":").append(doctor.getDoctorId()).append(",");
            jsonResponse.append("\"firstName\":\"").append(doctor.getFirstName()).append("\",");
            jsonResponse.append("\"lastName\":\"").append(doctor.getLastName()).append("\"}");
            first = false;
        }
        
        jsonResponse.append("]");
        
        // Set response content type
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Write JSON to response
        response.getWriter().write(jsonResponse.toString());
    }
    
    /**
     * Add a new doctor (admin operation)
     */
    private void addDoctor(HttpServletRequest request, HttpServletResponse response)
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
        String specialization = request.getParameter("specialization");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        
        // Validate input
        boolean hasErrors = false;
        
        if (!ValidationUtil.isNotNullOrEmpty(firstName) || !ValidationUtil.isNotNullOrEmpty(lastName)) {
            request.setAttribute("errorMessage", "First name and last name are required");
            hasErrors = true;
        }
        
        if (!ValidationUtil.isNotNullOrEmpty(specialization)) {
            request.setAttribute("errorMessage", "Specialization is required");
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
            request.setAttribute("specialization", specialization);
            request.setAttribute("phone", phone);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            
            // Forward back to form
            request.getRequestDispatcher("/admin/addDoctor.jsp").forward(request, response);
            return;
        }
        
        // Create user
        com.hospital.beans.User user = new com.hospital.beans.User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setRole("DOCTOR");
        user.setActive(true);
        
        int userId = userDAO.createUser(user);
        
        if (userId == -1) {
            request.setAttribute("errorMessage", "Error creating user account");
            request.getRequestDispatcher("/admin/addDoctor.jsp").forward(request, response);
            return;
        }
        
        // Create doctor
        Doctor doctor = new Doctor();
        doctor.setFirstName(firstName);
        doctor.setLastName(lastName);
        doctor.setSpecialization(specialization);
        doctor.setPhone(phone);
        
        int doctorId = doctorDAO.createDoctor(doctor, userId);
        
        if (doctorId == -1) {
            request.setAttribute("errorMessage", "Error creating doctor profile");
            request.getRequestDispatcher("/admin/addDoctor.jsp").forward(request, response);
            return;
        }
        
        // Success
        request.setAttribute("message", "Doctor added successfully");
        request.setAttribute("messageType", "success");
        
        // Redirect to doctor list
        response.sendRedirect(request.getContextPath() + "/admin/viewDoctors.jsp");
    }
    
    /**
     * Update doctor information
     */
    private void updateDoctor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verify authorization
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        String action = request.getParameter("action");
        
        // Doctor ID to update
        String doctorIdStr = request.getParameter("doctorId");
        
        if (doctorIdStr == null || doctorIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Doctor ID is required");
            return;
        }
        
        try {
            int doctorId = Integer.parseInt(doctorIdStr);
            
            // Verify permissions
            if (userRole.equals("DOCTOR")) {
                Integer sessionDoctorId = (Integer) session.getAttribute("doctorId");
                if (sessionDoctorId == null || sessionDoctorId != doctorId) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
            } else if (!userRole.equals("ADMIN")) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }
            
            // Get current doctor info
            Doctor doctor = doctorDAO.getDoctorById(doctorId);
            
            if (doctor == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Doctor not found");
                return;
            }
            
            // Get form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String specialization = request.getParameter("specialization");
            String phone = request.getParameter("phone");
            
            // Validate input
            boolean hasErrors = false;
            
            if (!ValidationUtil.isNotNullOrEmpty(firstName) || !ValidationUtil.isNotNullOrEmpty(lastName)) {
                request.setAttribute("errorMessage", "First name and last name are required");
                hasErrors = true;
            }
            
            if (!ValidationUtil.isNotNullOrEmpty(specialization)) {
                request.setAttribute("errorMessage", "Specialization is required");
                hasErrors = true;
            }
            
            if (!ValidationUtil.isNotNullOrEmpty(phone) || !ValidationUtil.isValidPhone(phone)) {
                request.setAttribute("errorMessage", "Valid phone number is required");
                hasErrors = true;
            }
            
            if (hasErrors) {
                // Keep form data
                request.setAttribute("doctor", doctor);
                request.setAttribute("firstName", firstName);
                request.setAttribute("lastName", lastName);
                request.setAttribute("specialization", specialization);
                request.setAttribute("phone", phone);
                
                // Forward back to form
                if (userRole.equals("ADMIN")) {
                    request.getRequestDispatcher("/admin/editDoctor.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/doctor/profile.jsp").forward(request, response);
                }
                return;
            }
            
            // Update doctor
            doctor.setFirstName(firstName);
            doctor.setLastName(lastName);
            doctor.setSpecialization(specialization);
            doctor.setPhone(phone);
            
            boolean success = doctorDAO.updateDoctor(doctor);
            
            if (!success) {
                request.setAttribute("errorMessage", "Failed to update doctor profile");
                request.setAttribute("doctor", doctor);
                
                if (userRole.equals("ADMIN")) {
                    request.getRequestDispatcher("/admin/editDoctor.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/doctor/profile.jsp").forward(request, response);
                }
                return;
            }
            
            // Success
            request.setAttribute("message", "Doctor profile updated successfully");
            request.setAttribute("messageType", "success");
            
            // Redirect based on role
            if (userRole.equals("ADMIN")) {
                response.sendRedirect(request.getContextPath() + "/admin/viewDoctors.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor/profile.jsp?updated=true");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid doctor ID");
        }
    }
    
    /**
     * Update doctor schedule
     */
    private void updateDoctorSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // This is just a placeholder method as schedule is not in the database schema
        // In a real app, you would have a doctor_schedule table
        
        // Verify authorization
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        
        // Doctor ID to update
        String doctorIdStr = request.getParameter("doctorId");
        
        if (doctorIdStr == null || doctorIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Doctor ID is required");
            return;
        }
        
        try {
            int doctorId = Integer.parseInt(doctorIdStr);
            
            // Verify permissions
            if (userRole.equals("DOCTOR")) {
                Integer sessionDoctorId = (Integer) session.getAttribute("doctorId");
                if (sessionDoctorId == null || sessionDoctorId != doctorId) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
            } else if (!userRole.equals("ADMIN")) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }
            
            // For this example, we'll just return success
            response.setContentType("text/plain");
            response.getWriter().write("success");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid doctor ID");
        }
    }
}