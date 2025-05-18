package com.hospital.servlet;

import com.hospital.beans.Doctor;
import com.hospital.beans.Patient;
import com.hospital.beans.User;
import com.hospital.dao.DoctorDAO;
import com.hospital.dao.PatientDAO;
import com.hospital.dao.UserDAO;
import com.hospital.util.ValidationUtil;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet for handling user registration
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

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
     * Handles GET requests - displays registration form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
    /**
     * Handles POST requests - processes registration form submission
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        
        // For doctor & patient
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        
        // Additional patient fields
        String gender = request.getParameter("gender");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String address = request.getParameter("address");
        
        // Additional doctor fields
        String specialization = request.getParameter("specialization");
        
        // Remember form data in case of validation errors
        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("role", role);
        request.setAttribute("firstName", firstName);
        request.setAttribute("lastName", lastName);
        request.setAttribute("phone", phone);
        request.setAttribute("gender", gender);
        request.setAttribute("dateOfBirth", dateOfBirthStr);
        request.setAttribute("address", address);
        request.setAttribute("specialization", specialization);
        
        // Validate input
        boolean hasErrors = true;
        
        // Username validation
        if (!ValidationUtil.isNotNullOrEmpty(username)) {
            request.setAttribute("usernameError", "Username is required.");
            hasErrors = true;
        } else if (userDAO.usernameExists(username)) {
            request.setAttribute("usernameError", "Username already exists.");
            hasErrors = true;
        }
        
        // Password validation
        if (!ValidationUtil.isNotNullOrEmpty(password)) {
            request.setAttribute("passwordError", "Password is required.");
            hasErrors = true;
        } else if (password.length() < 8) {
            request.setAttribute("passwordError", "Password must be at least 8 characters.");
            hasErrors = true;
        }
        
        // Confirm password validation
        if (!ValidationUtil.isNotNullOrEmpty(confirmPassword)) {
            request.setAttribute("confirmPasswordError", "Please confirm your password.");
            hasErrors = true;
        } else if (!password.equals(confirmPassword)) {
            request.setAttribute("confirmPasswordError", "Passwords do not match.");
            hasErrors = true;
        }
        
        // Email validation
        if (!ValidationUtil.isNotNullOrEmpty(email)) {
            request.setAttribute("emailError", "Email is required.");
            hasErrors = true;
        } else if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("emailError", "Invalid email format.");
            hasErrors = true;
        }
        
        // Role validation
        if (!ValidationUtil.isNotNullOrEmpty(role)) {
            request.setAttribute("roleError", "Role is required.");
            hasErrors = true;
        }
        
        // Name validation
        if (!ValidationUtil.isNotNullOrEmpty(firstName) || !ValidationUtil.isNotNullOrEmpty(lastName)) {
            request.setAttribute("nameError", "First name and last name are required.");
            hasErrors = true;
        }
        
        // Phone validation
        if (!ValidationUtil.isNotNullOrEmpty(phone)) {
            request.setAttribute("phoneError", "Phone number is required.");
            hasErrors = true;
        } else if (!ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("phoneError", "Invalid phone format (10 digits required).");
            hasErrors = true;
        }
        
        // Patient-specific validations
        if (role != null && role.equals("PATIENT")) {
            if (!ValidationUtil.isNotNullOrEmpty(gender)) {
                request.setAttribute("genderError", "Gender is required.");
                hasErrors = true;
            }
            
            if (ValidationUtil.isNotNullOrEmpty(dateOfBirthStr) && !ValidationUtil.isValidDate(dateOfBirthStr)) {
                request.setAttribute("dateOfBirthError", "Invalid date format (yyyy-MM-dd).");
                hasErrors = true;
            }
        }
        
        // Doctor-specific validations
        if (role != null && role.equals("DOCTOR")) {
            if (!ValidationUtil.isNotNullOrEmpty(specialization)) {
                request.setAttribute("specializationError", "Specialization is required.");
                hasErrors = true;
            }
        }
        
        // If validation fails, return to the form
        if (hasErrors) {
            request.setAttribute("errorMessage", "Please fix the errors in the form.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Create user object
        User user = new User();
        user.setUsername(username);
        user.setPassword(password); // In a real app, you'd hash the password
        user.setEmail(email);
        user.setRole(role);
        user.setActive(true);
        
        // Create user in database
        int userId = userDAO.createUser(user);
        
        if (userId == -1) {
            request.setAttribute("errorMessage", "Error creating user. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Create role-specific information
        boolean roleSaved = false;
        
        if (role.equals("DOCTOR")) {
            Doctor doctor = new Doctor();
            doctor.setFirstName(firstName);
            doctor.setLastName(lastName);
            doctor.setSpecialization(specialization);
            doctor.setPhone(phone);
            
            int doctorId = doctorDAO.createDoctor(doctor, userId);
            roleSaved = (doctorId != -1);
        } else if (role.equals("PATIENT")) {
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
                    // Already validated above, so this shouldn't happen
                }
            }
            
            int patientId = patientDAO.createPatient(patient, userId);
            roleSaved = (patientId != -1);
        } else {
            // For ADMIN, no additional information needed
            roleSaved = true;
        }
        
        if (!roleSaved) {
            request.setAttribute("errorMessage", "Error creating profile. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Registration successful
        request.setAttribute("message", "Registration successful! You can now login.");
        request.setAttribute("messageType", "success");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}