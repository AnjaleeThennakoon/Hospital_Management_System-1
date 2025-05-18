package com.hospital.servlet;

import com.hospital.beans.Appointment;
import com.hospital.beans.Doctor;
import com.hospital.beans.Patient;
import com.hospital.dao.AppointmentDAO;
import com.hospital.dao.DoctorDAO;
import com.hospital.dao.PatientDAO;
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
 * Servlet for handling appointment operations
 */
@WebServlet("/appointment/*")
public class AppointmentServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private DoctorDAO doctorDAO;
    private PatientDAO patientDAO;
    
    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
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
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Handle default case - show all appointments or redirect based on role
            handleDefaultGet(request, response);
        } else if (pathInfo.equals("/view")) {
            // View appointment details
            viewAppointment(request, response);
        } else if (pathInfo.equals("/getAvailableTimeSlots")) {
            // Get available time slots for a doctor on a specific date
            getAvailableTimeSlots(request, response);
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
        } else if (pathInfo.equals("/book")) {
            // Book a new appointment
            bookAppointment(request, response);
        } else if (pathInfo.equals("/update")) {
            // Update an existing appointment
            updateAppointment(request, response);
        } else if (pathInfo.equals("/cancel")) {
            // Cancel an appointment
            cancelAppointment(request, response);
        } else if (pathInfo.equals("/reschedule")) {
            // Reschedule an appointment
            rescheduleAppointment(request, response);
        } else {
            // Handle unknown paths
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * Handle default GET request based on user role
     */
    private void handleDefaultGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        
        switch (userRole) {
            case "ADMIN":
                // Admin sees all appointments
                List<Appointment> allAppointments = appointmentDAO.getAllAppointments();
                request.setAttribute("appointments", allAppointments);
                request.getRequestDispatcher("/admin/viewAppointments.jsp").forward(request, response);
                break;
                
            case "DOCTOR":
                // Doctor sees their appointments
                Integer doctorId = (Integer) session.getAttribute("doctorId");
                if (doctorId != null) {
                    List<Appointment> doctorAppointments = appointmentDAO.getAppointmentsByDoctor(doctorId);
                    request.setAttribute("appointments", doctorAppointments);
                    request.getRequestDispatcher("/doctor/viewAppointments.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/login");
                }
                break;
                
            case "PATIENT":
                // Patient sees their appointments
                Integer patientId = (Integer) session.getAttribute("patientId");
                if (patientId != null) {
                    List<Appointment> patientAppointments = appointmentDAO.getAppointmentsByPatient(patientId);
                    request.setAttribute("appointments", patientAppointments);
                    request.getRequestDispatcher("/patient/viewAppointments.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/login");
                }
                break;
                
            default:
                response.sendRedirect(request.getContextPath() + "/login");
        }
    }
    
    /**
     * View appointment details
     */
    private void viewAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String appointmentIdStr = request.getParameter("id");
        
        if (appointmentIdStr == null || appointmentIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Appointment ID is required");
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            
            if (appointment == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Appointment not found");
                return;
            }
            
            // Set appointment in request
            request.setAttribute("appointment", appointment);
            
            // Get patient and doctor details
            Patient patient = patientDAO.getPatientById(appointment.getPatientId());
            Doctor doctor = doctorDAO.getDoctorById(appointment.getDoctorId());
            
            request.setAttribute("patient", patient);
            request.setAttribute("doctor", doctor);
            
            // Access control - ensure user can only view their own appointments
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            String userRole = (String) session.getAttribute("userRole");
            
            if (userRole.equals("PATIENT")) {
                Integer sessionPatientId = (Integer) session.getAttribute("patientId");
                if (sessionPatientId == null || sessionPatientId != appointment.getPatientId()) {
                    response.sendRedirect(request.getContextPath() + "/patient/patientDashboard.jsp");
                    return;
                }
            } else if (userRole.equals("DOCTOR")) {
                Integer sessionDoctorId = (Integer) session.getAttribute("doctorId");
                if (sessionDoctorId == null || sessionDoctorId != appointment.getDoctorId()) {
                    response.sendRedirect(request.getContextPath() + "/doctor/doctorDashboard.jsp");
                    return;
                }
            }
            
            // Forward to appropriate view based on role
            if (userRole.equals("ADMIN")) {
                request.getRequestDispatcher("/admin/viewAppointmentDetails.jsp").forward(request, response);
            } else if (userRole.equals("DOCTOR")) {
                request.getRequestDispatcher("/doctor/viewAppointmentDetails.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/patient/viewAppointmentDetails.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid appointment ID");
        }
    }
    
    /**
     * Get available time slots for a doctor on a specific date
     */
    private void getAvailableTimeSlots(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String doctorIdStr = request.getParameter("doctorId");
        String appointmentDateStr = request.getParameter("appointmentDate");
        
        if (doctorIdStr == null || appointmentDateStr == null || 
            doctorIdStr.trim().isEmpty() || appointmentDateStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Doctor ID and appointment date are required");
            return;
        }
        
        try {
            int doctorId = Integer.parseInt(doctorIdStr);
            Date appointmentDate = ValidationUtil.parseDate(appointmentDateStr);
            
            if (appointmentDate == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid date format");
                return;
            }
            
            // Define available time slots (this is a simple example, adjust as needed)
            String[] allTimeSlots = {
                "09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM",
                "01:00 PM", "01:30 PM", "02:00 PM", "02:30 PM", "03:00 PM", "03:30 PM",
                "04:00 PM", "04:30 PM"
            };
            
            // Create JSON array for response
            StringBuilder jsonResponse = new StringBuilder("[");
            boolean first = true;
            
            // Check each time slot availability
            for (String timeSlot : allTimeSlots) {
                if (appointmentDAO.isDoctorAvailable(doctorId, appointmentDate, timeSlot)) {
                    if (!first) {
                        jsonResponse.append(",");
                    }
                    jsonResponse.append("{\"value\":\"").append(timeSlot).append("\",");
                    jsonResponse.append("\"text\":\"").append(timeSlot).append("\"}");
                    first = false;
                }
            }
            
            jsonResponse.append("]");
            
            // Set response content type
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            // Write JSON array to response
            response.getWriter().write(jsonResponse.toString());
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid doctor ID");
        }
    }
    
    /**
     * Book a new appointment
     */
    private void bookAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get parameters
        String doctorIdStr = request.getParameter("doctorId");
        String appointmentDateStr = request.getParameter("appointmentDate");
        String timeSlot = request.getParameter("timeSlot");
        String reason = request.getParameter("reason");
        
        // Check required parameters
        if (doctorIdStr == null || appointmentDateStr == null || timeSlot == null || reason == null ||
            doctorIdStr.trim().isEmpty() || appointmentDateStr.trim().isEmpty() || 
            timeSlot.trim().isEmpty() || reason.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All fields are required");
            request.getRequestDispatcher("/patient/bookAppointment.jsp").forward(request, response);
            return;
        }
        
        try {
            // Parse parameters
            int doctorId = Integer.parseInt(doctorIdStr);
            Date appointmentDate = ValidationUtil.parseDate(appointmentDateStr);
            
            if (appointmentDate == null) {
                request.setAttribute("errorMessage", "Invalid date format");
                request.getRequestDispatcher("/patient/bookAppointment.jsp").forward(request, response);
                return;
            }
            
            // Get patient ID from session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("patientId") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            int patientId = (int) session.getAttribute("patientId");
            
            // Check if doctor and time slot are available
            if (!appointmentDAO.isDoctorAvailable(doctorId, appointmentDate, timeSlot)) {
                request.setAttribute("errorMessage", "Selected time slot is no longer available");
                request.getRequestDispatcher("/patient/bookAppointment.jsp").forward(request, response);
                return;
            }
            
            // Create appointment
            Appointment appointment = new Appointment();
            appointment.setPatientId(patientId);
            appointment.setDoctorId(doctorId);
            appointment.setAppointmentDate(appointmentDate);
            appointment.setAppointmentTime(timeSlot);
            appointment.setStatus("PENDING");
            appointment.setReason(reason);
            
            // Save appointment
            int appointmentId = appointmentDAO.createAppointment(appointment);
            
            if (appointmentId == -1) {
                request.setAttribute("errorMessage", "Failed to book appointment. Please try again.");
                request.getRequestDispatcher("/patient/bookAppointment.jsp").forward(request, response);
                return;
            }
            
            // Success - redirect to view appointments
            response.sendRedirect(request.getContextPath() + "/patient/viewAppointments.jsp?success=true");
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input format");
            request.getRequestDispatcher("/patient/bookAppointment.jsp").forward(request, response);
        }
    }
    
    /**
     * Update an existing appointment
     */
    private void updateAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get parameters
        String appointmentIdStr = request.getParameter("appointmentId");
        String status = request.getParameter("status");
        
        // Check required parameters
        if (appointmentIdStr == null || status == null ||
            appointmentIdStr.trim().isEmpty() || status.trim().isEmpty()) {
            
            response.setContentType("text/plain");
            response.getWriter().write("failure");
            return;
        }
        
        try {
            // Parse appointment ID
            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            // Get appointment
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            
            if (appointment == null) {
                response.setContentType("text/plain");
                response.getWriter().write("failure");
                return;
            }
            
            // Verify authorization
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.setContentType("text/plain");
                response.getWriter().write("failure");
                return;
            }
            
            String userRole = (String) session.getAttribute("userRole");
            
            // Patients can only cancel their own appointments
            if (userRole.equals("PATIENT")) {
                Integer patientId = (Integer) session.getAttribute("patientId");
                if (patientId == null || patientId != appointment.getPatientId() || 
                    !status.equals("CANCELLED")) {
                    
                    response.setContentType("text/plain");
                    response.getWriter().write("failure");
                    return;
                }
            }
            
            // Doctors can update status of their appointments
            if (userRole.equals("DOCTOR")) {
                Integer doctorId = (Integer) session.getAttribute("doctorId");
                if (doctorId == null || doctorId != appointment.getDoctorId()) {
                    response.setContentType("text/plain");
                    response.getWriter().write("failure");
                    return;
                }
            }
            
            // Update appointment status
            boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, status);
            
            response.setContentType("text/plain");
            response.getWriter().write(success ? "success" : "failure");
            
        } catch (NumberFormatException e) {
            response.setContentType("text/plain");
            response.getWriter().write("failure");
        }
    }
    
    /**
     * Cancel an appointment
     */
    private void cancelAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get parameters
        String appointmentIdStr = request.getParameter("appointmentId");
        String cancelReason = request.getParameter("cancelReason");
        
        // Check required parameters
        if (appointmentIdStr == null || cancelReason == null ||
            appointmentIdStr.trim().isEmpty() || cancelReason.trim().isEmpty()) {
            
            response.setContentType("text/plain");
            response.getWriter().write("failure");
            return;
        }
        
        try {
            // Parse appointment ID
            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            // Get appointment
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            
            if (appointment == null) {
                response.setContentType("text/plain");
                response.getWriter().write("failure");
                return;
            }
            
            // Verify authorization
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.setContentType("text/plain");
                response.getWriter().write("failure");
                return;
            }
            
            String userRole = (String) session.getAttribute("userRole");
            
            // Patients can only cancel their own appointments
            if (userRole.equals("PATIENT")) {
                Integer patientId = (Integer) session.getAttribute("patientId");
                if (patientId == null || patientId != appointment.getPatientId()) {
                    response.setContentType("text/plain");
                    response.getWriter().write("failure");
                    return;
                }
            }
            
            // Cancel appointment
            boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, "CANCELLED");
            
            response.setContentType("text/plain");
            response.getWriter().write(success ? "success" : "failure");
            
        } catch (NumberFormatException e) {
            response.setContentType("text/plain");
            response.getWriter().write("failure");
        }
    }
    
    /**
     * Reschedule an appointment
     */
    private void rescheduleAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get parameters
        String appointmentIdStr = request.getParameter("appointmentId");
        String newDateStr = request.getParameter("newDate");
        String newTimeSlot = request.getParameter("newTimeSlot");
        String rescheduleReason = request.getParameter("rescheduleReason");
        
        // Check required parameters
        if (appointmentIdStr == null || newDateStr == null || newTimeSlot == null ||
            appointmentIdStr.trim().isEmpty() || newDateStr.trim().isEmpty() || newTimeSlot.trim().isEmpty()) {
            
            response.setContentType("text/plain");
            response.getWriter().write("failure");
            return;
        }
        
        try {
            // Parse appointment ID and new date
            int appointmentId = Integer.parseInt(appointmentIdStr);
            Date newDate = ValidationUtil.parseDate(newDateStr);
            
            if (newDate == null) {
                response.setContentType("text/plain");
                response.getWriter().write("failure");
                return;
            }
            
            // Get appointment
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            
            if (appointment == null) {
                response.setContentType("text/plain");
                response.getWriter().write("failure");
                return;
            }
            
            // Verify authorization
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.setContentType("text/plain");
                response.getWriter().write("failure");
                return;
            }
            
            String userRole = (String) session.getAttribute("userRole");
            
            // Patients can only reschedule their own appointments
            if (userRole.equals("PATIENT")) {
                Integer patientId = (Integer) session.getAttribute("patientId");
                if (patientId == null || patientId != appointment.getPatientId()) {
                    response.setContentType("text/plain");
                    response.getWriter().write("failure");
                    return;
                }
            }
            
            // Check if the new time slot is available
            if (!appointmentDAO.isDoctorAvailable(appointment.getDoctorId(), newDate, newTimeSlot)) {
                response.setContentType("text/plain");
                response.getWriter().write("timeSlotNotAvailable");
                return;
            }
            
            // Cancel old appointment
            boolean cancelSuccess = appointmentDAO.updateAppointmentStatus(appointmentId, "CANCELLED");
            
            if (!cancelSuccess) {
                response.setContentType("text/plain");
                response.getWriter().write("failure");
                return;
            }
            
            // Create new appointment
            Appointment newAppointment = new Appointment();
            newAppointment.setPatientId(appointment.getPatientId());
            newAppointment.setDoctorId(appointment.getDoctorId());
            newAppointment.setAppointmentDate(newDate);
            newAppointment.setAppointmentTime(newTimeSlot);
            newAppointment.setStatus("PENDING");
            newAppointment.setReason(appointment.getReason() + " (Rescheduled)");
            
            int newAppointmentId = appointmentDAO.createAppointment(newAppointment);
            
            if (newAppointmentId == -1) {
                response.setContentType("text/plain");
                response.getWriter().write("failure");
                return;
            }
            
            response.setContentType("text/plain");
            response.getWriter().write("success");
            
        } catch (NumberFormatException e) {
            response.setContentType("text/plain");
            response.getWriter().write("failure");
        }
    }
}