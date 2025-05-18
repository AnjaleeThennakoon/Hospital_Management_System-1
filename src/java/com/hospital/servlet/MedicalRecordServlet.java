package com.hospital.servlet;

import com.hospital.beans.MedicalRecord;
import com.hospital.dao.MedicalRecordDAO;
import com.hospital.dao.PatientDAO;
import com.hospital.dao.DoctorDAO;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet for handling medical record operations
 */
@WebServlet("/medicalrecord/*")
public class MedicalRecordServlet extends HttpServlet {

    private MedicalRecordDAO medicalRecordDAO;
    private PatientDAO patientDAO;
    private DoctorDAO doctorDAO;
    
    @Override
    public void init() {
        medicalRecordDAO = new MedicalRecordDAO();
        patientDAO = new PatientDAO();
        doctorDAO = new DoctorDAO();
    }
    
    /**
     * Handles GET requests
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Handle default case - redirect based on role
            redirectBasedOnRole(request, response);
        } else if (pathInfo.equals("/view")) {
            // View medical record details
            viewMedicalRecord(request, response);
        } else if (pathInfo.equals("/patient")) {
            // Get medical records for a specific patient
            getMedicalRecordsByPatient(request, response);
        } else if (pathInfo.equals("/doctor")) {
            // Get medical records created by a specific doctor
            getMedicalRecordsByDoctor(request, response);
        } else if (pathInfo.equals("/download")) {
            // Download medical record as PDF
            downloadMedicalRecord(request, response);
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
            // Add a new medical record
            addMedicalRecord(request, response);
        } else if (pathInfo.equals("/update")) {
            // Update an existing medical record
            updateMedicalRecord(request, response);
        } else {
            // Handle unknown paths
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * Redirect based on user role
     */
    private void redirectBasedOnRole(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        
        switch (userRole) {
            case "ADMIN":
                // Redirect to admin page
                response.sendRedirect(request.getContextPath() + "/admin/adminDashboard.jsp");
                break;
            case "DOCTOR":
                // Redirect to doctor's medical records view
                response.sendRedirect(request.getContextPath() + "/doctor/viewMedicalRecords.jsp");
                break;
            case "PATIENT":
                // Redirect to patient's medical records view
                response.sendRedirect(request.getContextPath() + "/patient/viewMedicalRecords.jsp");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login");
        }
    }
    
    /**
     * View medical record details
     */
    private void viewMedicalRecord(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get record ID
        String recordIdStr = request.getParameter("id");
        
        if (recordIdStr == null || recordIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Record ID is required");
            return;
        }
        
        try {
            int recordId = Integer.parseInt(recordIdStr);
            
            // Get medical record
            MedicalRecord medicalRecord = medicalRecordDAO.getMedicalRecordById(recordId);
            
            if (medicalRecord == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Medical record not found");
                return;
            }
            
            // Verify authorization
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            String userRole = (String) session.getAttribute("userRole");
            
            // Access control - patients can only view their own medical records
            if (userRole.equals("PATIENT")) {
                Integer patientId = (Integer) session.getAttribute("patientId");
                if (patientId == null || patientId != medicalRecord.getPatientId()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
            }
            
            // Access control - doctors can only view medical records they created or for their patients
            if (userRole.equals("DOCTOR")) {
                Integer doctorId = (Integer) session.getAttribute("doctorId");
                if (doctorId == null || doctorId != medicalRecord.getDoctorId()) {
                    // Additional check could be added here if doctors should be able to view records
                    // of their current patients even if created by other doctors
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
            }
            
            // Set medical record in request
            request.setAttribute("medicalRecord", medicalRecord);
            
            // Forward to appropriate view based on role
            if (userRole.equals("ADMIN")) {
                request.getRequestDispatcher("/admin/viewMedicalRecordDetails.jsp").forward(request, response);
            } else if (userRole.equals("DOCTOR")) {
                request.getRequestDispatcher("/doctor/viewMedicalRecordDetails.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/patient/viewMedicalRecordDetails.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid record ID");
        }
    }
    
    /**
     * Get medical records for a specific patient
     */
    private void getMedicalRecordsByPatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get patient ID
        String patientIdStr = request.getParameter("id");
        
        if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Patient ID is required");
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdStr);
            
            // Verify authorization
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            String userRole = (String) session.getAttribute("userRole");
            
            // Access control - patients can only view their own medical records
            if (userRole.equals("PATIENT")) {
                Integer sessionPatientId = (Integer) session.getAttribute("patientId");
                if (sessionPatientId == null || sessionPatientId != patientId) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
            }
            
            // Get medical records
            List<MedicalRecord> medicalRecords = medicalRecordDAO.getMedicalRecordsByPatient(patientId);
            
            // Get patient information
            com.hospital.beans.Patient patient = patientDAO.getPatientById(patientId);
            
            if (patient == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Patient not found");
                return;
            }
            
            // Set attributes in request
            request.setAttribute("medicalRecords", medicalRecords);
            request.setAttribute("patient", patient);
            
            // Forward to appropriate view based on role
            if (userRole.equals("ADMIN")) {
                request.getRequestDispatcher("/admin/viewPatientMedicalRecords.jsp").forward(request, response);
            } else if (userRole.equals("DOCTOR")) {
                request.getRequestDispatcher("/doctor/viewPatientMedicalRecords.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/patient/viewMedicalRecords.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid patient ID");
        }
    }
    
    /**
     * Get medical records created by a specific doctor
     */
    private void getMedicalRecordsByDoctor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get doctor ID
        String doctorIdStr = request.getParameter("id");
        
        if (doctorIdStr == null || doctorIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Doctor ID is required");
            return;
        }
        
        try {
            int doctorId = Integer.parseInt(doctorIdStr);
            
            // Verify authorization
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            String userRole = (String) session.getAttribute("userRole");
            
            // Access control - doctors can only view their own medical records
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
            
            // Get medical records
            List<MedicalRecord> medicalRecords = medicalRecordDAO.getMedicalRecordsByDoctor(doctorId);
            
            // Get doctor information
            com.hospital.beans.Doctor doctor = doctorDAO.getDoctorById(doctorId);
            
            if (doctor == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Doctor not found");
                return;
            }
            
            // Set attributes in request
            request.setAttribute("medicalRecords", medicalRecords);
            request.setAttribute("doctor", doctor);
            
            // Forward to appropriate view
            if (userRole.equals("ADMIN")) {
                request.getRequestDispatcher("/admin/viewDoctorMedicalRecords.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/doctor/viewMedicalRecords.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid doctor ID");
        }
    }
    
    /**
     * Download medical record as PDF
     * Note: This is a stub implementation as PDF generation is not included
     */
    private void downloadMedicalRecord(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get record ID
        String recordIdStr = request.getParameter("id");
        
        if (recordIdStr == null || recordIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Record ID is required");
            return;
        }
        
        try {
            int recordId = Integer.parseInt(recordIdStr);
            
            // Get medical record
            MedicalRecord medicalRecord = medicalRecordDAO.getMedicalRecordById(recordId);
            
            if (medicalRecord == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Medical record not found");
                return;
            }
            
            // Verify authorization
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            String userRole = (String) session.getAttribute("userRole");
            
            // Access control - patients can only download their own medical records
            if (userRole.equals("PATIENT")) {
                Integer patientId = (Integer) session.getAttribute("patientId");
                if (patientId == null || patientId != medicalRecord.getPatientId()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
            }
            
            // Access control - doctors can only download medical records they created
            if (userRole.equals("DOCTOR")) {
                Integer doctorId = (Integer) session.getAttribute("doctorId");
                if (doctorId == null || doctorId != medicalRecord.getDoctorId()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
            }
            
            // Set response content type and headers for PDF download
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=medical_record_" + recordId + ".pdf");
            
            // In a real implementation, this would generate and write the PDF to the response
            // For this simple example, just write a placeholder message
            response.getWriter().write("This is a placeholder for the PDF download functionality.");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid record ID");
        }
    }
    
    /**
     * Add a new medical record
     */
    private void addMedicalRecord(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verify that user is a doctor
        HttpSession session = request.getSession(false);
        if (session == null || !"DOCTOR".equals(session.getAttribute("userRole"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only doctors can add medical records");
            return;
        }
        
        Integer doctorId = (Integer) session.getAttribute("doctorId");
        if (doctorId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get form parameters
        String patientIdStr = request.getParameter("patientId");
        String diagnosis = request.getParameter("diagnosis");
        String prescription = request.getParameter("prescription");
        String notes = request.getParameter("notes");
        
        // Validate input
        if (patientIdStr == null || patientIdStr.trim().isEmpty() ||
            diagnosis == null || diagnosis.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Patient ID and diagnosis are required");
            request.getRequestDispatcher("/doctor/addMedicalRecord.jsp").forward(request, response);
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdStr);
            
            // Verify patient exists
            com.hospital.beans.Patient patient = patientDAO.getPatientById(patientId);
            if (patient == null) {
                request.setAttribute("errorMessage", "Patient not found");
                request.getRequestDispatcher("/doctor/addMedicalRecord.jsp").forward(request, response);
                return;
            }
            
            // Create medical record
            MedicalRecord medicalRecord = new MedicalRecord();
            medicalRecord.setPatientId(patientId);
            medicalRecord.setDoctorId(doctorId);
            medicalRecord.setRecordDate(new Date()); // Current date
            medicalRecord.setDiagnosis(diagnosis);
            medicalRecord.setPrescription(prescription);
            medicalRecord.setNotes(notes);
            
            // Save medical record
            int recordId = medicalRecordDAO.createMedicalRecord(medicalRecord);
            
            if (recordId == -1) {
                request.setAttribute("errorMessage", "Failed to create medical record");
                request.getRequestDispatcher("/doctor/addMedicalRecord.jsp").forward(request, response);
                return;
            }
            
            // Success
            // If this was from an appointment, update the appointment status to completed
            String appointmentIdStr = request.getParameter("appointmentId");
            if (appointmentIdStr != null && !appointmentIdStr.trim().isEmpty()) {
                try {
                    int appointmentId = Integer.parseInt(appointmentIdStr);
                    // In a real app, you would update the appointment status here
                    // appointmentDAO.updateAppointmentStatus(appointmentId, "COMPLETED");
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }
            
            // Redirect to view the new medical record
            response.sendRedirect(request.getContextPath() + "/medicalrecord/view?id=" + recordId);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid patient ID");
            request.getRequestDispatcher("/doctor/addMedicalRecord.jsp").forward(request, response);
        }
    }
    
    /**
     * Update an existing medical record
     */
    private void updateMedicalRecord(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verify that user is a doctor
        HttpSession session = request.getSession(false);
        if (session == null || !"DOCTOR".equals(session.getAttribute("userRole"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only doctors can update medical records");
            return;
        }
        
        Integer doctorId = (Integer) session.getAttribute("doctorId");
        if (doctorId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get form parameters
        String recordIdStr = request.getParameter("recordId");
        String diagnosis = request.getParameter("diagnosis");
        String prescription = request.getParameter("prescription");
        String notes = request.getParameter("notes");
        
        // Validate input
        if (recordIdStr == null || recordIdStr.trim().isEmpty() ||
            diagnosis == null || diagnosis.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Record ID and diagnosis are required");
            request.getRequestDispatcher("/doctor/editMedicalRecord.jsp").forward(request, response);
            return;
        }
        
        try {
            int recordId = Integer.parseInt(recordIdStr);
            
            // Get existing medical record
            MedicalRecord medicalRecord = medicalRecordDAO.getMedicalRecordById(recordId);
            
            if (medicalRecord == null) {
                request.setAttribute("errorMessage", "Medical record not found");
                request.getRequestDispatcher("/doctor/editMedicalRecord.jsp").forward(request, response);
                return;
            }
            
            // Verify doctor is the creator of the record
            if (medicalRecord.getDoctorId() != doctorId) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "You can only update your own medical records");
                return;
            }
            
            // Update medical record
            medicalRecord.setDiagnosis(diagnosis);
            medicalRecord.setPrescription(prescription);
            medicalRecord.setNotes(notes);
            
            // Save changes
            boolean success = medicalRecordDAO.updateMedicalRecord(medicalRecord);
            
            if (!success) {
                request.setAttribute("errorMessage", "Failed to update medical record");
                request.setAttribute("medicalRecord", medicalRecord);
                request.getRequestDispatcher("/doctor/editMedicalRecord.jsp").forward(request, response);
                return;
            }
            
            // Success - redirect to view the updated medical record
            response.sendRedirect(request.getContextPath() + "/medicalrecord/view?id=" + recordId);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid record ID");
            request.getRequestDispatcher("/doctor/editMedicalRecord.jsp").forward(request, response);
        }
    }
}