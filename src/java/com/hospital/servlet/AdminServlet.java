package com.hospital.servlet;

import com.hospital.beans.Doctor;
import com.hospital.beans.Patient;
import com.hospital.beans.User;
import com.hospital.dao.DoctorDAO;
import com.hospital.dao.PatientDAO;
import com.hospital.dao.UserDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet for handling admin-specific operations
 */
@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {

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
     * Handles GET requests
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        // Verify that user is admin
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Handle default case - redirect to admin dashboard
            response.sendRedirect(request.getContextPath() + "/admin/adminDashboard.jsp");
        } else if (pathInfo.equals("/users")) {
            // List all users
            listAllUsers(request, response);
        } else if (pathInfo.equals("/dashboard")) {
            // Show admin dashboard with statistics
            showDashboard(request, response);
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
        
        // Verify that user is admin
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Handle default case
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid path");
        } else if (pathInfo.equals("/deactivateUser")) {
            // Deactivate a user
            deactivateUser(request, response);
        } else if (pathInfo.equals("/activateUser")) {
            // Activate a user
            activateUser(request, response);
        } else {
            // Handle unknown paths
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * List all users
     */
    private void listAllUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get all users
        List<User> users = userDAO.getAllUsers();
        
        // Set in request
        request.setAttribute("users", users);
        
        // Forward to view
        request.getRequestDispatcher("/admin/viewUsers.jsp").forward(request, response);
    }
    
    /**
     * Show admin dashboard with statistics
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get all doctors
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        
        // Get all patients
        List<Patient> patients = patientDAO.getAllPatients();
        
        // Set in request
        request.setAttribute("doctorCount", doctors.size());
        request.setAttribute("patientCount", patients.size());
        
        // Get appointment count, bill count, etc.
        // In a real app, you would have methods to get these counts
        request.setAttribute("appointmentCount", 0);
        request.setAttribute("billCount", 0);
        
        // Forward to view
        request.getRequestDispatcher("/admin/adminDashboard.jsp").forward(request, response);
    }
    
    /**
     * Deactivate a user
     */
    private void deactivateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get user ID
        String userIdStr = request.getParameter("userId");
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            
            // Get user
            User user = userDAO.getUserById(userId);
            
            if (user == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                return;
            }
            
            // Prevent deactivating the current admin
            HttpSession session = request.getSession(false);
            Integer currentUserId = (Integer) session.getAttribute("userId");
            
            if (currentUserId != null && currentUserId == userId) {
                request.setAttribute("errorMessage", "Cannot deactivate your own account");
                request.getRequestDispatcher("/admin/viewUsers.jsp").forward(request, response);
                return;
            }
            
            // Deactivate user
            boolean success = userDAO.deactivateUser(userId);
            
            if (!success) {
                request.setAttribute("errorMessage", "Failed to deactivate user");
                request.getRequestDispatcher("/admin/viewUsers.jsp").forward(request, response);
                return;
            }
            
            // Success
            request.setAttribute("message", "User deactivated successfully");
            request.setAttribute("messageType", "success");
            
            // Redirect to user list
            response.sendRedirect(request.getContextPath() + "/admin/users");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID");
        }
    }
    
    /**
     * Activate a user
     */
    private void activateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get user ID
        String userIdStr = request.getParameter("userId");
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            
            // Get user
            User user = userDAO.getUserById(userId);
            
            if (user == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                return;
            }
            
            // Update user to active
            user.setActive(true);
            boolean success = userDAO.updateUser(user);
            
            if (!success) {
                request.setAttribute("errorMessage", "Failed to activate user");
                request.getRequestDispatcher("/admin/viewUsers.jsp").forward(request, response);
                return;
            }
            
            // Success
            request.setAttribute("message", "User activated successfully");
            request.setAttribute("messageType", "success");
            
            // Redirect to user list
            response.sendRedirect(request.getContextPath() + "/admin/users");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID");
        }
    }
}