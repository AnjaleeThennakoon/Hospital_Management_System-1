package com.hospital.servlet;

import com.hospital.beans.Bill;
import com.hospital.dao.BillDAO;
import com.hospital.dao.PatientDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet for handling billing operations
 */
@WebServlet("/bill/*")
public class BillingServlet extends HttpServlet {

    private BillDAO billDAO;
    private PatientDAO patientDAO;
    
    @Override
    public void init() {
        billDAO = new BillDAO();
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
            // Handle default case - redirect based on role
            redirectBasedOnRole(request, response);
        } else if (pathInfo.equals("/view")) {
            // View bill details
            viewBill(request, response);
        } else if (pathInfo.equals("/patient")) {
            // Get bills for a specific patient
            getBillsByPatient(request, response);
        } else if (pathInfo.equals("/download")) {
            // Download bill as PDF
            downloadBill(request, response);
        } else if (pathInfo.equals("/getFilteredBills")) {
            // Get filtered bills (AJAX)
            getFilteredBills(request, response);
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
        } else if (pathInfo.equals("/generate")) {
            // Generate a new bill
            generateBill(request, response);
        } else if (pathInfo.equals("/processPayment")) {
            // Process payment for a bill
            processPayment(request, response);
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
                // Redirect to admin bills view
                response.sendRedirect(request.getContextPath() + "/admin/viewBills.jsp");
                break;
            case "PATIENT":
                // Redirect to patient's bills view
                response.sendRedirect(request.getContextPath() + "/patient/viewBills.jsp");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login");
        }
    }
    
    /**
     * View bill details
     */
    private void viewBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get bill ID
        String billIdStr = request.getParameter("id");
        
        if (billIdStr == null || billIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Bill ID is required");
            return;
        }
        
        try {
            int billId = Integer.parseInt(billIdStr);
            
            // Get bill
            Bill bill = billDAO.getBillById(billId);
            
            if (bill == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bill not found");
                return;
            }
            
            // Verify authorization
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            String userRole = (String) session.getAttribute("userRole");
            
            // Access control - patients can only view their own bills
            if (userRole.equals("PATIENT")) {
                Integer patientId = (Integer) session.getAttribute("patientId");
                if (patientId == null || patientId != bill.getPatientId()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
            } else if (!userRole.equals("ADMIN")) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }
            
            // Set bill in request
            request.setAttribute("bill", bill);
            
            // Get patient information
            com.hospital.beans.Patient patient = patientDAO.getPatientById(bill.getPatientId());
            request.setAttribute("patient", patient);
            
            // Forward to appropriate view based on role
            if (userRole.equals("ADMIN")) {
                request.getRequestDispatcher("/admin/viewBillDetails.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/patient/viewBillDetails.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid bill ID");
        }
    }
    
    /**
     * Get bills for a specific patient
     */
    private void getBillsByPatient(HttpServletRequest request, HttpServletResponse response)
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
            
            // Access control - patients can only view their own bills
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
            
            // Get bills
            List<Bill> bills = billDAO.getBillsByPatient(patientId);
            
            // Get patient information
            com.hospital.beans.Patient patient = patientDAO.getPatientById(patientId);
            
            if (patient == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Patient not found");
                return;
            }
            
            // Calculate total unpaid amount
            BigDecimal totalUnpaid = billDAO.getTotalUnpaidBillsForPatient(patientId);
            
            // Set attributes in request
            request.setAttribute("bills", bills);
            request.setAttribute("patient", patient);
            request.setAttribute("totalUnpaid", totalUnpaid);
            
            // Forward to appropriate view based on role
            if (userRole.equals("ADMIN")) {
                request.getRequestDispatcher("/admin/viewPatientBills.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/patient/viewBills.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid patient ID");
        }
    }
    
    /**
     * Download bill as PDF
     * Note: This is a stub implementation as PDF generation is not included
     */
    private void downloadBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get bill ID
        String billIdStr = request.getParameter("id");
        
        if (billIdStr == null || billIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Bill ID is required");
            return;
        }
        
        try {
            int billId = Integer.parseInt(billIdStr);
            
            // Get bill
            Bill bill = billDAO.getBillById(billId);
            
            if (bill == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bill not found");
                return;
            }
            
            // Verify authorization
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            String userRole = (String) session.getAttribute("userRole");
            
            // Access control - patients can only download their own bills
            if (userRole.equals("PATIENT")) {
                Integer patientId = (Integer) session.getAttribute("patientId");
                if (patientId == null || patientId != bill.getPatientId()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
            } else if (!userRole.equals("ADMIN")) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }
            
            // Set response content type and headers for PDF download
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=bill_" + billId + ".pdf");
            
            // In a real implementation, this would generate and write the PDF to the response
            // For this simple example, just write a placeholder message
            response.getWriter().write("This is a placeholder for the PDF download functionality.");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid bill ID");
        }
    }
    
    /**
     * Get filtered bills (AJAX)
     */
    private void getFilteredBills(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verify authorization
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        
        // Get filter parameters
        String status = request.getParameter("status");
        String fromDateStr = request.getParameter("fromDate");
        String toDateStr = request.getParameter("toDate");
        String amountMinStr = request.getParameter("amountMin");
        
        // Get appropriate bills based on role
        List<Bill> bills;
        
        if (userRole.equals("ADMIN")) {
            // Admin can see all bills, possibly filtered
            if (status != null && !status.trim().isEmpty()) {
                bills = billDAO.getBillsByStatus(status);
            } else {
                bills = billDAO.getAllBills();
            }
        } else if (userRole.equals("PATIENT")) {
            // Patients can only see their own bills
            Integer patientId = (Integer) session.getAttribute("patientId");
            if (patientId == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            bills = billDAO.getBillsByPatient(patientId);
            
            // Filter by status if provided
            if (status != null && !status.trim().isEmpty()) {
                // In a real app, you would add more sophisticated filtering
                // For this example, just do client-side filtering
            }
        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        // Create JSON response
        StringBuilder jsonResponse = new StringBuilder("[");
        boolean first = true;
        
        for (Bill bill : bills) {
            // Apply additional filters
            if (status != null && !status.trim().isEmpty() && !bill.getStatus().equals(status)) {
                continue;
            }
            
            // Date and amount filtering would be applied here in a real app
            
            if (!first) {
                jsonResponse.append(",");
            }
            
            jsonResponse.append("{\"id\":").append(bill.getBillId()).append(",");
            jsonResponse.append("\"date\":\"").append(bill.getBillDate()).append("\",");
            jsonResponse.append("\"description\":\"").append(bill.getDescription()).append("\",");
            jsonResponse.append("\"totalAmount\":\"").append(bill.getAmount()).append("\",");
            jsonResponse.append("\"status\":\"").append(bill.getStatus()).append("\"}");
            
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
     * Generate a new bill (admin operation)
     */
    private void generateBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verify that user is admin
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only admins can generate bills");
            return;
        }
        
        // Get form parameters
        String patientIdStr = request.getParameter("patientId");
        String amountStr = request.getParameter("amount");
        String description = request.getParameter("description");
        
        // Validate input
        if (patientIdStr == null || patientIdStr.trim().isEmpty() ||
            amountStr == null || amountStr.trim().isEmpty() ||
            description == null || description.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Patient ID, amount, and description are required");
            request.getRequestDispatcher("/admin/generateBill.jsp").forward(request, response);
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdStr);
            BigDecimal amount = new BigDecimal(amountStr);
            
            // Verify patient exists
            com.hospital.beans.Patient patient = patientDAO.getPatientById(patientId);
            if (patient == null) {
                request.setAttribute("errorMessage", "Patient not found");
                request.getRequestDispatcher("/admin/generateBill.jsp").forward(request, response);
                return;
            }
            
            // Create bill
            Bill bill = new Bill();
            bill.setPatientId(patientId);
            bill.setAmount(amount);
            bill.setBillDate(new Date()); // Current date
            bill.setStatus("UNPAID");
            bill.setDescription(description);
            
            // Save bill
            int billId = billDAO.createBill(bill);
            
            if (billId == -1) {
                request.setAttribute("errorMessage", "Failed to generate bill");
                request.getRequestDispatcher("/admin/generateBill.jsp").forward(request, response);
                return;
            }
            
            // Success - redirect to view the new bill
            response.sendRedirect(request.getContextPath() + "/bill/view?id=" + billId);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid patient ID or amount format");
            request.getRequestDispatcher("/admin/generateBill.jsp").forward(request, response);
        }
    }
    
    /**
     * Process payment for a bill
     */
    private void processPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get parameters
        String billIdStr = request.getParameter("billId");
        String paymentMethod = request.getParameter("paymentMethod");
        
        // Validate input
        if (billIdStr == null || billIdStr.trim().isEmpty() ||
            paymentMethod == null || paymentMethod.trim().isEmpty()) {
            
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Bill ID and payment method are required\"}");
            return;
        }
        
        try {
            int billId = Integer.parseInt(billIdStr);
            
            // Get bill
            Bill bill = billDAO.getBillById(billId);
            
            if (bill == null) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Bill not found\"}");
                return;
            }
            
            // Verify authorization
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Not logged in\"}");
                return;
            }
            
            String userRole = (String) session.getAttribute("userRole");
            
            // Access control - patients can only pay their own bills, admin can pay any bill
            if (userRole.equals("PATIENT")) {
                Integer patientId = (Integer) session.getAttribute("patientId");
                if (patientId == null || patientId != bill.getPatientId()) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\": false, \"message\": \"Access denied\"}");
                    return;
                }
            } else if (!userRole.equals("ADMIN")) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Access denied\"}");
                return;
            }
            
            // Update bill status to PAID
            boolean success = billDAO.updateBillStatus(billId, "PAID");
            
            if (!success) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to process payment\"}");
                return;
            }
            
            // Success
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"message\": \"Payment processed successfully\"}");
            
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid bill ID\"}");
        }
    }
}