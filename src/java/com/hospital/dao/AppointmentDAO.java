package com.hospital.dao;

import com.hospital.beans.Appointment;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Data Access Object for Appointment-related database operations
 */
public class AppointmentDAO {
    
    /**
     * Create a new appointment
     * @param appointment The appointment to create
     * @return The appointment ID of the created appointment, or -1 if operation failed
     */
    public int createAppointment(Appointment appointment) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int appointmentId = -1;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, reason) " +
                           "VALUES (?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            stmt.setInt(1, appointment.getPatientId());
            stmt.setInt(2, appointment.getDoctorId());
            stmt.setDate(3, new java.sql.Date(appointment.getAppointmentDate().getTime()));
            stmt.setString(4, appointment.getAppointmentTime());
            stmt.setString(5, appointment.getStatus());
            stmt.setString(6, appointment.getReason());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    appointmentId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating appointment: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return appointmentId;
    }
    
    /**
     * Get an appointment by its appointment ID
     * @param appointmentId The appointment ID
     * @return Appointment object if found, null otherwise
     */
    public Appointment getAppointmentById(int appointmentId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Appointment appointment = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT a.*, CONCAT(p.first_name, ' ', p.last_name) as patient_name, " +
                          "CONCAT(d.first_name, ' ', d.last_name) as doctor_name, d.specialization " +
                          "FROM appointments a " +
                          "JOIN patients p ON a.patient_id = p.patient_id " +
                          "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                          "WHERE a.appointment_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, appointmentId);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                
                java.sql.Date date = rs.getDate("appointment_date");
                if (date != null) {
                    appointment.setAppointmentDate(new Date(date.getTime()));
                }
                
                appointment.setAppointmentTime(rs.getString("appointment_time"));
                appointment.setStatus(rs.getString("status"));
                appointment.setReason(rs.getString("reason"));
                
                // Additional fields for display
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setDoctorName(rs.getString("doctor_name"));
                appointment.setDoctorSpecialization(rs.getString("specialization"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting appointment by ID: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return appointment;
    }
    
    /**
     * Get appointments by patient ID
     * @param patientId The patient ID
     * @return List of appointments for the patient
     */
    public List<Appointment> getAppointmentsByPatient(int patientId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Appointment> appointments = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT a.*, CONCAT(p.first_name, ' ', p.last_name) as patient_name, " +
                          "CONCAT(d.first_name, ' ', d.last_name) as doctor_name, d.specialization " +
                          "FROM appointments a " +
                          "JOIN patients p ON a.patient_id = p.patient_id " +
                          "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                          "WHERE a.patient_id = ? " +
                          "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, patientId);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                
                java.sql.Date date = rs.getDate("appointment_date");
                if (date != null) {
                    appointment.setAppointmentDate(new Date(date.getTime()));
                }
                
                appointment.setAppointmentTime(rs.getString("appointment_time"));
                appointment.setStatus(rs.getString("status"));
                appointment.setReason(rs.getString("reason"));
                
                // Additional fields for display
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setDoctorName(rs.getString("doctor_name"));
                appointment.setDoctorSpecialization(rs.getString("specialization"));
                
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            System.err.println("Error getting appointments by patient: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return appointments;
    }
    
    /**
     * Get appointments by doctor ID
     * @param doctorId The doctor ID
     * @return List of appointments for the doctor
     */
    public List<Appointment> getAppointmentsByDoctor(int doctorId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Appointment> appointments = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT a.*, CONCAT(p.first_name, ' ', p.last_name) as patient_name, " +
                          "CONCAT(d.first_name, ' ', d.last_name) as doctor_name, d.specialization " +
                          "FROM appointments a " +
                          "JOIN patients p ON a.patient_id = p.patient_id " +
                          "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                          "WHERE a.doctor_id = ? " +
                          "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, doctorId);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                
                java.sql.Date date = rs.getDate("appointment_date");
                if (date != null) {
                    appointment.setAppointmentDate(new Date(date.getTime()));
                }
                
                appointment.setAppointmentTime(rs.getString("appointment_time"));
                appointment.setStatus(rs.getString("status"));
                appointment.setReason(rs.getString("reason"));
                
                // Additional fields for display
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setDoctorName(rs.getString("doctor_name"));
                appointment.setDoctorSpecialization(rs.getString("specialization"));
                
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            System.err.println("Error getting appointments by doctor: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return appointments;
    }
    
    /**
     * Get appointments by date
     * @param date The appointment date
     * @return List of appointments for the date
     */
    public List<Appointment> getAppointmentsByDate(Date date) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Appointment> appointments = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT a.*, CONCAT(p.first_name, ' ', p.last_name) as patient_name, " +
                          "CONCAT(d.first_name, ' ', d.last_name) as doctor_name, d.specialization " +
                          "FROM appointments a " +
                          "JOIN patients p ON a.patient_id = p.patient_id " +
                          "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                          "WHERE a.appointment_date = ? " +
                          "ORDER BY a.appointment_time";
            stmt = conn.prepareStatement(sql);
            stmt.setDate(1, new java.sql.Date(date.getTime()));
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                
                java.sql.Date sqlDate = rs.getDate("appointment_date");
                if (sqlDate != null) {
                    appointment.setAppointmentDate(new Date(sqlDate.getTime()));
                }
                
                appointment.setAppointmentTime(rs.getString("appointment_time"));
                appointment.setStatus(rs.getString("status"));
                appointment.setReason(rs.getString("reason"));
                
                // Additional fields for display
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setDoctorName(rs.getString("doctor_name"));
                appointment.setDoctorSpecialization(rs.getString("specialization"));
                
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            System.err.println("Error getting appointments by date: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return appointments;
    }
    
    /**
     * Get all appointments
     * @return List of all appointments
     */
    public List<Appointment> getAllAppointments() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Appointment> appointments = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT a.*, CONCAT(p.first_name, ' ', p.last_name) as patient_name, " +
                          "CONCAT(d.first_name, ' ', d.last_name) as doctor_name, d.specialization " +
                          "FROM appointments a " +
                          "JOIN patients p ON a.patient_id = p.patient_id " +
                          "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                          "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
            stmt = conn.prepareStatement(sql);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                
                java.sql.Date date = rs.getDate("appointment_date");
                if (date != null) {
                    appointment.setAppointmentDate(new Date(date.getTime()));
                }
                
                appointment.setAppointmentTime(rs.getString("appointment_time"));
                appointment.setStatus(rs.getString("status"));
                appointment.setReason(rs.getString("reason"));
                
                // Additional fields for display
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setDoctorName(rs.getString("doctor_name"));
                appointment.setDoctorSpecialization(rs.getString("specialization"));
                
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all appointments: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return appointments;
    }
    
    /**
     * Update appointment status
     * @param appointmentId The appointment ID
     * @param status The new status
     * @return true if update successful, false otherwise
     */
    public boolean updateAppointmentStatus(int appointmentId, String status) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE appointments SET status = ? WHERE appointment_id = ?";
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, status);
            stmt.setInt(2, appointmentId);
            
            int affectedRows = stmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            System.err.println("Error updating appointment status: " + e.getMessage());
        } finally {
            DBConnection.closeResources(null, stmt, conn);
        }
        
        return success;
    }
    
    /**
     * Check if a doctor is available at a specific date and time
     * @param doctorId The doctor ID
     * @param date The appointment date
     * @param time The appointment time
     * @return true if doctor is available, false otherwise
     */
    public boolean isDoctorAvailable(int doctorId, Date date, String time) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        boolean isAvailable = true;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM appointments " +
                          "WHERE doctor_id = ? AND appointment_date = ? AND appointment_time = ? " +
                          "AND status != 'CANCELLED'";
            stmt = conn.prepareStatement(sql);
            
            stmt.setInt(1, doctorId);
            stmt.setDate(2, new java.sql.Date(date.getTime()));
            stmt.setString(3, time);
            
            rs = stmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                isAvailable = false;
            }
        } catch (SQLException e) {
            System.err.println("Error checking doctor availability: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return isAvailable;
    }
}